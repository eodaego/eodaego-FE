import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/storage/secure_token_storage.dart';
import 'package:eodaego/core/widgets/app_back_app_bar.dart';
import 'package:eodaego/core/widgets/app_button.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/presentation/pages/nickname_setup_page.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:eodaego/features/user/domain/entities/agreement_status_entity.dart';
import 'package:eodaego/features/user/domain/repositories/user_repository.dart';
import 'package:eodaego/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

// 테스트 환경엔 플랫폼 채널이 없어 실제 FlutterSecureStorage는 예외를 던진다.
// AuthNotifier.updateNickname의 로컬 저장 분기가 조용히 성공하도록 인메모리로 대체한다.
// (test/features/auth/presentation/providers/auth_notifier_nickname_test.dart와 동일한 shape)
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

class _FakeUserRepository implements UserRepository {
  Object? errorToThrow;
  String? lastRequested;
  int updateCallCount = 0;

  @override
  Future<String> updateNickname(String nickname) async {
    updateCallCount++;
    lastRequested = nickname;
    if (errorToThrow != null) throw errorToThrow!;
    return nickname;
  }

  @override
  Future<void> deleteAccount() => throw UnimplementedError();

  @override
  Future<AgreementStatusEntity> getAgreements() => throw UnimplementedError();

  @override
  Future<void> updateAgreements({required bool marketing}) =>
      throw UnimplementedError();
}

class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResultEntity?> build() async => const AuthResultEntity(
    userId: 'test-user-uuid',
    nickname: '탐험가123',
    isNewUser: false,
    requiresAgreement: false,
  );
}

/// 설정 모드 화면을 push해서 띄우는 호스트. pop 여부를 확인하려면
/// 아래에 남을 화면이 필요하다.
Widget _wrap(_FakeUserRepository repo, {required bool isSettings}) =>
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(repo),
        authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
        secureTokenStorageProvider.overrideWithValue(
          SecureTokenStorage(storage: _FakeSecureStorage()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => NicknameSetupPage(
                      initialNickname: '탐험가123',
                      isSettings: isSettings,
                    ),
                  ),
                ),
                child: const Text('열기'),
              ),
            ),
          ),
        ),
      ),
    );

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('열기'));
  await tester.pumpAndSettle();
}

void main() {
  group('NicknameSetupPage 설정 모드', () {
    testWidgets('설정 모드에서는 뒤로가기 앱바를 띄운다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeUserRepository(), isSettings: true));
      await _open(tester);

      expect(find.byType(AppBackAppBar), findsOneWidget);
      expect(find.text('닉네임 변경'), findsOneWidget);
    });

    testWidgets('온보딩 모드에서는 앱바를 띄우지 않는다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeUserRepository(), isSettings: false));
      await _open(tester);

      expect(find.byType(AppBackAppBar), findsNothing);
    });

    testWidgets('닉네임을 바꾸지 않고 완료하면 서버를 부르지 않고 돌아간다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      expect(repo.updateCallCount, 0);
      expect(find.byType(NicknameSetupPage), findsNothing);
    });

    testWidgets('닉네임을 바꾸고 완료하면 저장하고 돌아간다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '새이름');
      await tester.pump();
      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      expect(repo.lastRequested, '새이름');
      expect(find.byType(NicknameSetupPage), findsNothing);
    });

    testWidgets('온보딩 모드에서 저장에 성공하면 라우터 이동 전에도 제출 상태를 푼다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo, isSettings: false));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '새이름');
      await tester.pump();
      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      expect(repo.lastRequested, '새이름');
      // 온보딩은 스스로 pop하지 않는다 — 실제 앱에선 라우터가 곧 이동시키지만,
      // 이 위젯 테스트엔 라우터가 없어 화면이 그대로 남는다. 그 사이 버튼/입력창이
      // 잠긴 채로 방치되면 안 된다.
      expect(find.byType(NicknameSetupPage), findsOneWidget);
      expect(
        tester.widget<AppButton>(find.byType(AppButton)).isLoading,
        isFalse,
      );
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
    });

    testWidgets('중복 닉네임이면 화면에 머물며 오류를 보여준다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository()
        ..errorToThrow = const ValidationException(
          message: '중복',
          code: 'NICKNAME_ALREADY_EXISTS',
        );
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '중복이름');
      await tester.pump();
      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();

      expect(find.text('이미 사용 중인 닉네임이에요'), findsOneWidget);
      expect(find.byType(NicknameSetupPage), findsOneWidget);
    });
  });
}
