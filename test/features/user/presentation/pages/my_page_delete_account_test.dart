import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/storage/secure_token_storage.dart';
import 'package:eodaego/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:eodaego/features/user/domain/entities/agreement_status_entity.dart';
import 'package:eodaego/features/user/domain/repositories/user_repository.dart';
import 'package:eodaego/features/user/presentation/pages/my_page.dart';
import 'package:eodaego/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 위젯 테스트 환경엔 Firebase App이 초기화돼 있지 않아 실 FirebaseAuthDataSource
// 접근(FirebaseAuth.instance)이 즉시 예외를 던진다. AuthNotifier.build()와
// cleanupAfterAccountDeletion()이 이를 거치므로 경계에서 대체한다.
// (test/features/auth/presentation/providers/auth_notifier_cold_start_test.dart와 동일한 shape)
class _MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

// 실 플랫폼 채널 없이 동작하는 인메모리 secure storage.
// (test/features/auth/presentation/pages/nickname_setup_page_settings_test.dart와 동일한 shape)
class _FakeSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> write({
    required String key,
    String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.remove(key);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// authNotifierProvider의 실 build()는 위 Firebase 문제와 별개로, 등록하는
// ref.onDispose 콜백이 위젯 트리 dispose 시 "이미 dispose된 컨테이너" 에러를
// 유발한다(auth_notifier_cold_start_test.dart 참고). build()만 대체해
// cleanupAfterAccountDeletion()/forceLogout()은 실 구현 그대로 검증한다.
class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResultEntity?> build() async => const AuthResultEntity(
    userId: 'test-user-uuid',
    nickname: '탐험가123',
    isNewUser: false,
    requiresAgreement: false,
  );
}

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository({this.deleteFailure});

  final AppException? deleteFailure;

  int deleteCallCount = 0;

  @override
  Future<void> deleteAccount() async {
    deleteCallCount++;
    if (deleteFailure != null) throw deleteFailure!;
  }

  @override
  Future<String> updateNickname(String nickname) async => nickname;

  @override
  Future<bool> isNicknameAvailable(String nickname) async => true;

  @override
  Future<AgreementStatusEntity> getAgreements() async =>
      const AgreementStatusEntity(
        termsOfService: true,
        privacyPolicy: true,
        locationTerms: true,
        marketing: false,
      );

  @override
  Future<void> updateAgreements({required bool marketing}) async {}
}

Widget _wrap(_FakeUserRepository repo) {
  final firebase = _MockFirebaseAuthDataSource();
  when(() => firebase.signOut()).thenAnswer((_) async {});

  return ProviderScope(
    overrides: [
      userRepositoryProvider.overrideWith((ref) => repo),
      authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
      firebaseAuthDataSourceProvider.overrideWithValue(firebase),
      secureTokenStorageProvider.overrideWithValue(
        SecureTokenStorage(storage: _FakeSecureStorage()),
      ),
    ],
    child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => const MaterialApp(home: MyPage()),
    ),
  );
}

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('MyPage 회원탈퇴', () {
    testWidgets('탈퇴를 확인하면 삭제를 한 번 호출한다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();

      // 다이얼로그의 확인 버튼
      await tester.tap(find.text('탈퇴하기').last);
      // 성공 시 _isDeleting을 되돌리지 않고 라우터 redirect에 맡기므로(실제
      // 앱에선 화면 자체가 사라짐), 버튼의 무한 스피너가 남아 pumpAndSettle이
      // 끝나지 않는다. 비동기 삭제 체인만 흘려보낸다.
      await tester.pump();
      await tester.pump();

      expect(repo.deleteCallCount, 1);
    });

    testWidgets('탈퇴를 취소하면 삭제를 호출하지 않는다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();

      // AppDialog.confirm()의 취소 버튼 기본 라벨은 '닫기'다.
      await tester.tap(find.text('닫기'));
      await tester.pumpAndSettle();

      expect(repo.deleteCallCount, 0);
    });

    testWidgets('탈퇴에 실패하면 화면에 머문다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository(
        deleteFailure: const NetworkException(message: '연결 실패'),
      );
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('탈퇴하기').last);
      await tester.pumpAndSettle();

      expect(repo.deleteCallCount, 1);
      expect(find.byType(MyPage), findsOneWidget);

      // 실패 시 뜨는 스낵바의 3초 자동 dismiss 타이머를 흘려보내
      // "Timer is still pending" 프레임워크 assertion을 피한다.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('삭제는 성공했지만 로컬 정리가 실패해도 세션을 종료한다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      final firebase = _MockFirebaseAuthDataSource();
      // 삭제(execute)는 성공하지만, 로컬 정리 단계(Firebase signOut)가 실패하는
      // 케이스 — forceLogout()이 여전히 호출돼 세션이 끝나야 한다.
      when(() => firebase.signOut()).thenThrow(Exception('firebase down'));

      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWith((ref) => repo),
          authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
          firebaseAuthDataSourceProvider.overrideWithValue(firebase),
          secureTokenStorageProvider.overrideWithValue(
            SecureTokenStorage(storage: _FakeSecureStorage()),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (context, _) => const MaterialApp(home: MyPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('탈퇴하기').last);
      await tester.pump();
      await tester.pump();

      expect(repo.deleteCallCount, 1);
      // forceLogout()이 호출돼 인증 상태가 비워졌어야 한다(세션 종료).
      expect(container.read(authNotifierProvider).valueOrNull, isNull);
      // 서버 삭제는 이미 성공했으므로 로컬 정리 실패가 재시도 안내로 새어나가면 안 된다.
      // (스낵바가 없으니 dismiss 타이머를 흘려보낼 필요도 없다 — 성공 경로라
      // _isDeleting을 되돌리지 않는 버튼의 무한 스피너 때문에 pumpAndSettle은
      // 여기서 쓸 수 없다. 위 my_page_delete_account_test 상단 주석과 동일한 이유.)
      expect(find.text('잠시 후 다시 시도해 주세요'), findsNothing);
    });

    testWidgets('404 MEMBER_NOT_FOUND(이미 삭제된 계정)이면 재시도 안내 없이 세션을 종료한다', (
      tester,
    ) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository(
        deleteFailure: const ServerException(
          message: 'not found',
          code: 'MEMBER_NOT_FOUND',
        ),
      );
      final firebase = _MockFirebaseAuthDataSource();
      when(() => firebase.signOut()).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWith((ref) => repo),
          authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
          firebaseAuthDataSourceProvider.overrideWithValue(firebase),
          secureTokenStorageProvider.overrideWithValue(
            SecureTokenStorage(storage: _FakeSecureStorage()),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (context, _) => const MaterialApp(home: MyPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('탈퇴하기').last);
      await tester.pump();
      await tester.pump();

      expect(repo.deleteCallCount, 1);
      // 하드 삭제는 멱등이다 — 404는 "이미 없음"이지 "실패"가 아니다.
      expect(container.read(authNotifierProvider).valueOrNull, isNull);
      expect(find.text('잠시 후 다시 시도해 주세요'), findsNothing);
    });
  });

  group('MyPage 닉네임 편집', () {
    // my_page_guest_mode_test는 게스트에게 이 아이콘이 없다는 것만 확인한다.
    // 아이콘이 아무에게도 안 그려져도 그 테스트는 통과하므로, 대조군이 필요하다.
    testWidgets('로그인한 사용자에게는 닉네임 옆에 편집 아이콘이 보인다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeUserRepository()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
    });

    testWidgets('닉네임은 편집 아이콘이 있어도 화면 정중앙에 놓인다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeUserRepository()));
      await tester.pumpAndSettle();

      // 아이콘을 닉네임과 한 덩어리로 가운데 정렬하면 닉네임이 아이콘 폭의
      // 절반만큼 왼쪽으로 밀린다. 좌우 슬롯이 대칭이어야 중심이 유지된다.
      final nicknameCenter = tester.getCenter(find.text('탐험가123')).dx;
      final screenCenter = tester.getCenter(find.byType(MyPage)).dx;

      expect(nicknameCenter, moreOrLessEquals(screenCenter, epsilon: 1.0));
      // 아이콘은 닉네임 오른쪽에 있어야 한다.
      expect(
        tester.getCenter(find.byIcon(Icons.edit_rounded)).dx,
        greaterThan(nicknameCenter),
      );
    });
  });
}
