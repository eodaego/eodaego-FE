import 'package:eodaego/core/storage/secure_token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  group('SecureTokenStorage.isNewUser', () {
    test('저장한 적이 없으면 false를 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      expect(await storage.getIsNewUser(), isFalse);
    });

    test('saveIsNewUser(true) 후 getIsNewUser는 true를 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveIsNewUser(true);
      expect(await storage.getIsNewUser(), isTrue);
    });

    test('saveIsNewUser(false) 후 getIsNewUser는 false를 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveIsNewUser(false);
      expect(await storage.getIsNewUser(), isFalse);
    });

    test('clearTokens()는 isNewUser도 함께 삭제한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveIsNewUser(true);
      expect(await storage.getIsNewUser(), isTrue);

      await storage.clearTokens();
      expect(await storage.getIsNewUser(), isFalse);
    });
  });

  group('SecureTokenStorage 온보딩 상태', () {
    test('저장한 적 없는 requiresAgreement는 null을 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      expect(await storage.getRequiresAgreement(), isNull);
    });

    test('saveRequiresAgreement(false)와 미저장을 구분한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveRequiresAgreement(false);
      expect(await storage.getRequiresAgreement(), isFalse);
    });

    test('saveRequiresAgreement(true) 후 true를 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveRequiresAgreement(true);
      expect(await storage.getRequiresAgreement(), isTrue);
    });

    test('저장한 적 없는 nickname은 null을 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      expect(await storage.getNickname(), isNull);
    });

    test('saveNickname 후 같은 값을 반환한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveNickname('어대탐험가');
      expect(await storage.getNickname(), '어대탐험가');
    });

    test('clearTokens()는 nickname과 requiresAgreement도 삭제한다', () async {
      final storage = SecureTokenStorage(storage: _FakeSecureStorage());
      await storage.saveNickname('어대탐험가');
      await storage.saveRequiresAgreement(true);

      await storage.clearTokens();

      expect(await storage.getNickname(), isNull);
      expect(await storage.getRequiresAgreement(), isNull);
    });
  });
}
