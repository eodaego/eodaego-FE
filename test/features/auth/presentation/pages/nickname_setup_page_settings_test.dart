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

  /// 중복 확인 응답. null이면 [checkError]를 던진다.
  bool availableResult = true;
  Object? checkError;
  String? lastChecked;
  int checkCallCount = 0;

  @override
  Future<String> updateNickname(String nickname) async {
    updateCallCount++;
    lastRequested = nickname;
    if (errorToThrow != null) throw errorToThrow!;
    return nickname;
  }

  @override
  Future<bool> isNicknameAvailable(String nickname) async {
    checkCallCount++;
    lastChecked = nickname;
    if (checkError != null) throw checkError!;
    return availableResult;
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
        tester
            .widget<AppButton>(find.widgetWithText(AppButton, '완료'))
            .isLoading,
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

  group('NicknameSetupPage 자동 중복 확인', () {
    // 입력이 멈춘 뒤 확인이 나가므로, 디바운스 시간을 흘려보내야 한다.
    Future<void> settleCheck(WidgetTester tester) async {
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }

    testWidgets('누를 버튼 없이 입력만으로 확인이 나간다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository()..availableResult = true;
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      expect(find.text('중복확인'), findsNothing);

      await tester.enterText(find.byType(TextField), '새이름');
      await settleCheck(tester);

      expect(repo.lastChecked, '새이름');
      expect(find.text('쓸 수 있는 이름이에요'), findsOneWidget);
    });

    testWidgets('글자를 이어 치는 동안에는 확인을 쏘지 않는다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository()..availableResult = true;
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      // 디바운스가 끝나기 전에 다음 글자가 들어오면 이전 예약은 취소된다.
      await tester.enterText(find.byType(TextField), '새이');
      await tester.pump(const Duration(milliseconds: 150));
      await tester.enterText(find.byType(TextField), '새이름');
      await tester.pump(const Duration(milliseconds: 150));
      expect(repo.checkCallCount, 0);

      await settleCheck(tester);
      expect(repo.checkCallCount, 1);
      expect(repo.lastChecked, '새이름');
    });

    testWidgets('이미 쓰는 이름이면 알리고 저장을 막는다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository()..availableResult = false;
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '중복이름');
      await settleCheck(tester);

      expect(find.text('이미 사용 중인 닉네임이에요'), findsOneWidget);

      // 남이 쓰는 걸 아는데 서버를 또 부를 이유가 없다.
      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();
      expect(repo.updateCallCount, 0);
    });

    testWidgets('확인한 뒤 입력을 고치면 결과가 사라진다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository()..availableResult = true;
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '새이름');
      await settleCheck(tester);
      expect(find.text('쓸 수 있는 이름이에요'), findsOneWidget);

      // 확인 결과는 확인한 그 문자열에만 유효하다.
      await tester.enterText(find.byType(TextField), '다른이름');
      await tester.pump();

      expect(find.text('쓸 수 있는 이름이에요'), findsNothing);
    });

    testWidgets('원래 이름 그대로면 확인을 쏘지 않는다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      // 서버도 본인 닉네임은 중복에서 빼주므로 물어볼 이유가 없다.
      await tester.enterText(find.byType(TextField), '탐험가123');
      await settleCheck(tester);

      expect(repo.checkCallCount, 0);
    });

    testWidgets('형식이 틀리면 확인을 쏘지 않는다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository();
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '어대!');
      await settleCheck(tester);

      expect(repo.checkCallCount, 0);
      expect(find.text('한글, 영문, 숫자만 쓸 수 있어요'), findsOneWidget);
    });

    testWidgets('확인에 실패하면 조용히 물러나고 저장은 막지 않는다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository()
        ..checkError = const NetworkException(message: '연결 실패');
      await tester.pumpWidget(_wrap(repo, isSettings: true));
      await _open(tester);

      await tester.enterText(find.byType(TextField), '새이름');
      await settleCheck(tester);

      // 사용자가 요청한 확인이 아니므로 실패를 알리지 않는다.
      expect(find.textContaining('확인하지 못'), findsNothing);

      await tester.tap(find.text('완료'));
      await tester.pumpAndSettle();
      expect(repo.updateCallCount, 1);
    });
  });
}
