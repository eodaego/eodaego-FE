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

    // 초기 상태: Firebase + JWT 토큰 + 온보딩 상태가 모두 있어야 인증으로 본다.
    // 로그인 시 저장은 여러 개의 독립적인 비동기 쓰기라, 중간에 앱이 종료되면
    // 불완전한 스냅샷이 남을 수 있다. 필수 값이 하나라도 없으면 세션을 정리한다
    // (누락된 requiresAgreement를 false로 취급하면 약관 게이트를 우회하게 된다).
    final dataSource = ref.watch(firebaseAuthDataSourceProvider);
    final tokenStorage = ref.watch(secureTokenStorageProvider);

    final currentUser = dataSource.currentUser;
    if (currentUser == null) return null;

    if (!await tokenStorage.hasTokens()) return null;

    final userId = await tokenStorage.getUserId();
    final requiresAgreement = await tokenStorage.getRequiresAgreement();

    if (userId == null || requiresAgreement == null) {
      debugPrint('⚠️ [AuthNotifier] 불완전한 세션 스냅샷 — 재로그인 유도');
      try {
        await dataSource.signOut();
      } catch (_) {}
      await tokenStorage.clearTokens();
      return null;
    }

    // 닉네임은 표시용이라 누락 시 빈 문자열로 폴백한다.
    final nickname = await tokenStorage.getNickname() ?? '';
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
    } on AuthCancelledException {
      // 사용자가 로그인 취소 — 에러 아님. 조용히 미로그인 상태로 복귀.
      state = const AsyncValue.data(null);
    } catch (e) {
      // 실제 로그인 실패(네트워크/서버/Firebase 등). 앱은 멈추지 않고,
      // 로그인 화면에 안내(AppSnackbar)만 띄운다.
      debugPrint('⚠️ [$provider] 로그인 실패: $e');
      ref.read(loginNoticeKeyProvider.notifier).state = 'loginFailed';
      state = const AsyncValue.data(null);
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

  /// 약관 동의 완료 → requiresAgreement=false (로컬 영속 포함)
  Future<void> markAgreementCompleted() async {
    final current = state.valueOrNull;
    if (current == null || !current.requiresAgreement) return;
    state = AsyncValue.data(current.copyWith(requiresAgreement: false));
    try {
      await ref.read(secureTokenStorageProvider).saveRequiresAgreement(false);
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] saveRequiresAgreement(false) 실패: $e');
    }
  }

  /// 백엔드 "필수 약관 미동의" 차단 → requiresAgreement=true (로컬 영속 포함)
  Future<void> markNeedsAgreement() async {
    final current = state.valueOrNull;
    if (current == null || current.requiresAgreement) return;
    state = AsyncValue.data(current.copyWith(requiresAgreement: true));
    try {
      await ref.read(secureTokenStorageProvider).saveRequiresAgreement(true);
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] saveRequiresAgreement(true) 실패: $e');
    }
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
