import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_apple_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/utils/firebase_auth_error_handler.dart';
import '../../../user/presentation/providers/user_provider.dart';

part 'auth_provider.g.dart';

/// FirebaseAuthDataSource Provider (keepAlive — 인터셉터 콜백에서 접근)
@Riverpod(keepAlive: true)
FirebaseAuthDataSource firebaseAuthDataSource(Ref ref) {
  return FirebaseAuthDataSource();
}

/// AuthRemoteDataSource Provider (Retrofit)
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
}

/// AuthRepository Provider
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    firebaseAuthDataSource: ref.watch(firebaseAuthDataSourceProvider),
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(secureTokenStorageProvider),
  );
}

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) =>
    SignInWithGoogleUseCase(repository: ref.watch(authRepositoryProvider));

@riverpod
SignInWithAppleUseCase signInWithAppleUseCase(Ref ref) =>
    SignInWithAppleUseCase(repository: ref.watch(authRepositoryProvider));

@riverpod
SignOutUseCase signOutUseCase(Ref ref) =>
    SignOutUseCase(repository: ref.watch(authRepositoryProvider));

/// Firebase Auth State 스트림 (GoRouter refreshListenable 용)
@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthDataSourceProvider).authStateChanges();
}

/// 인증 상태 Notifier. State: `AsyncValue<AuthResultEntity?>` (null = 미로그인)
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthResultEntity?> build() async {
    // 강제 로그아웃 콜백 등록 (core → auth 역전 패턴)
    Future.microtask(() {
      ref.read(forceLogoutCallbackNotifierProvider.notifier).register(({
        String? messageKey,
      }) async {
        final firebaseDataSource = ref.read(firebaseAuthDataSourceProvider);
        await firebaseDataSource.signOut();
        await ref.read(secureTokenStorageProvider).clearTokens();
        if (messageKey != null) {
          ref.read(loginNoticeKeyProvider.notifier).state = messageKey;
        }
        forceLogout();
      });
    });

    ref.onDispose(() {
      ref.read(forceLogoutCallbackNotifierProvider.notifier).unregister();
    });

    // 초기 상태: Firebase + JWT 토큰 모두 있어야 인증
    final dataSource = ref.watch(firebaseAuthDataSourceProvider);
    final tokenStorage = ref.watch(secureTokenStorageProvider);
    final currentUser = dataSource.currentUser;
    if (currentUser == null) return null;

    if (!await tokenStorage.hasTokens()) return null;

    final userId = await tokenStorage.getUserId();
    if (userId == null) {
      try {
        await dataSource.signOut();
      } catch (_) {}
      await tokenStorage.clearTokens();
      return null;
    }

    // cold start: 약관/프로필을 백엔드에서 조회 (각 실패 독립 허용)
    final userRepo = ref.read(userRepositoryProvider);
    bool requiresAgreement = false;
    String nickname = currentUser.displayName ?? '';
    try {
      final status = await userRepo.getAgreements();
      requiresAgreement = !status.hasAllRequired;
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] 약관 상태 조회 실패: $e');
    }
    try {
      final profile = await userRepo.getMyProfile();
      nickname = profile.nickname;
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] 프로필 조회 실패: $e');
    }

    final isNewUser = await tokenStorage.getIsNewUser();
    return AuthResultEntity(
      userId: userId,
      nickname: nickname,
      isNewUser: isNewUser,
      requiresAgreement: requiresAgreement,
    );
  }

  Future<void> signInWithGoogle() => _signIn(
        () => ref.read(signInWithGoogleUseCaseProvider).execute(),
        provider: 'Google',
      );

  Future<void> signInWithApple() => _signIn(
        () => ref.read(signInWithAppleUseCaseProvider).execute(),
        provider: 'Apple',
      );

  Future<void> _signIn(
    Future<AuthResultEntity> Function() run, {
    required String provider,
  }) async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await run());
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(
        FirebaseAuthErrorHandler.createAuthException(e, provider: provider),
        StackTrace.current,
      );
      rethrow;
    } catch (e, stack) {
      state = AsyncValue.error(
        e is AppException
            ? e
            : AuthException(
                message: 'unknown auth error',
                messageKey: 'errorUnknown',
                originalException: e,
              ),
        stack,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signOutUseCaseProvider).execute();
      ref.read(loginNoticeKeyProvider.notifier).state = 'logoutSuccess';
    } catch (e) {
      // repo가 로컬 정리를 best-effort로 이미 수행함(토큰삭제 실행).
      // 여기 도달 = 토큰삭제 자체 실패 등 극히 드문 경우 → 안내만.
      debugPrint('⚠️ 로그아웃 중 예상 밖 오류: $e');
      ref.read(loginNoticeKeyProvider.notifier).state = 'logoutUnexpected';
    } finally {
      state = const AsyncValue.data(null); // 항상 로그아웃 완료 상태
    }
  }

  /// 닉네임 설정 완료 → isNewUser=false 로 갱신 (영속 포함)
  Future<void> updateNicknameCompleted(String nickname) async {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      AuthResultEntity(
        userId: current.userId,
        nickname: nickname,
        isNewUser: false,
        requiresAgreement: current.requiresAgreement,
      ),
    );
    try {
      await ref.read(secureTokenStorageProvider).saveIsNewUser(false);
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] saveIsNewUser(false) 실패: $e');
    }
  }

  /// 약관 동의 완료 → requiresAgreement=false
  void markAgreementCompleted() {
    final current = state.valueOrNull;
    if (current == null || !current.requiresAgreement) return;
    state = AsyncValue.data(current.copyWith(requiresAgreement: false));
  }

  /// 백엔드 "필수 약관 미동의" 차단 → requiresAgreement=true
  void markNeedsAgreement() {
    final current = state.valueOrNull;
    if (current == null || current.requiresAgreement) return;
    state = AsyncValue.data(current.copyWith(requiresAgreement: true));
  }

  /// 회원 탈퇴 후 로컬 정리 (state는 호출부에서 forceLogout로 초기화)
  Future<void> cleanupAfterAccountDeletion() async {
    final firebaseDataSource = ref.read(firebaseAuthDataSourceProvider);
    try {
      await firebaseDataSource.signOut();
    } finally {
      await ref.read(secureTokenStorageProvider).clearTokens();
    }
  }

  /// 강제 로그아웃 (AuthInterceptor 재발급 실패 시)
  void forceLogout() {
    state = const AsyncValue.data(null);
  }
}
