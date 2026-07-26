import 'package:eodaego/core/storage/secure_token_storage.dart';
import 'package:eodaego/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// (test/features/auth/data/repositories/auth_repository_signout_test.dart와 동일한 shape)
class _MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class _MockUser extends Mock implements User {}

/// 실 플랫폼 채널 없이 동작하는 인메모리 secure storage.
/// (test/core/storage/secure_token_storage_is_new_user_test.dart와 동일한 shape)
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

/// [Finding 3] AuthNotifier.build()의 fail-closed 콜드스타트 경로 회귀 테스트.
///
/// 기존 auth_notifier_*_test.dart들은 전부 build()를 override하는 서브클래스를
/// 사용해 실제 build()가 한 번도 실행되지 않는다. 이 파일은 authNotifierProvider
/// 자체는 override하지 않고 firebaseAuthDataSourceProvider/secureTokenStorageProvider만
/// 대체하여 실제 build()를 그대로 실행시킨다.
void main() {
  late _MockFirebaseAuthDataSource firebase;
  late SecureTokenStorage storage;

  setUp(() {
    firebase = _MockFirebaseAuthDataSource();
    when(() => firebase.currentUser).thenReturn(_MockUser());
    when(() => firebase.signOut()).thenAnswer((_) async {});
    storage = SecureTokenStorage(storage: _FakeSecureStorage());
  });

  // 의도적으로 container.dispose()를 호출하지 않는다: 실제 build()가 등록하는
  // ref.onDispose 콜백(forceLogoutCallbackNotifierProvider.unregister)이 컨테이너
  // 전체 dispose 중에는 "이미 dispose된 컨테이너에서 read 시도" 에러를 유발한다
  // (Riverpod이 개별 provider dispose 전에 컨테이너를 먼저 disposed로 표시하기 때문).
  // 이 테스트가 검증하려는 대상(콜드스타트 상태 계산)과 무관한 프레임워크 이슈이므로,
  // 각 테스트가 독립된 컨테이너를 만들고 GC에 맡긴다.
  ProviderContainer containerWith() {
    return ProviderContainer(
      overrides: [
        firebaseAuthDataSourceProvider.overrideWithValue(firebase),
        secureTokenStorageProvider.overrideWithValue(storage),
      ],
    );
  }

  group('AuthNotifier.build (cold start)', () {
    test('토큰+userId+requiresAgreement가 모두 있으면 저장된 값으로 세션을 복원한다', () async {
      await storage.saveTokens(
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
      );
      await storage.saveUserId('user-1');
      await storage.saveNickname('어대탐험가');
      await storage.saveIsNewUser(false);
      await storage.saveRequiresAgreement(false);

      final container = containerWith();

      final result = await container.read(authNotifierProvider.future);

      expect(result, isNotNull);
      expect(result!.userId, 'user-1');
      expect(result.nickname, '어대탐험가');
      expect(result.isNewUser, isFalse);
      expect(result.requiresAgreement, isFalse);
    });

    test(
      'requiresAgreement가 없으면 null을 반환하고 세션을 정리한다 (약관 게이트 우회 방지)',
      () async {
        await storage.saveTokens(
          accessToken: 'access-1',
          refreshToken: 'refresh-1',
        );
        await storage.saveUserId('user-1');
        // requiresAgreement는 저장하지 않음 — 불완전한 스냅샷 시뮬레이션

        final container = containerWith();

        final result = await container.read(authNotifierProvider.future);

        expect(result, isNull);
        expect(await storage.getAccessToken(), isNull);
      },
    );

    test('userId가 없으면 null을 반환하고 세션을 정리한다', () async {
      await storage.saveTokens(
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
      );
      await storage.saveRequiresAgreement(false);
      // userId는 저장하지 않음 — 불완전한 스냅샷 시뮬레이션

      final container = containerWith();

      final result = await container.read(authNotifierProvider.future);

      expect(result, isNull);
      expect(await storage.getAccessToken(), isNull);
    });

    test('저장된 토큰이 전혀 없으면 null을 반환한다', () async {
      final container = containerWith();

      final result = await container.read(authNotifierProvider.future);

      expect(result, isNull);
    });
  });
}
