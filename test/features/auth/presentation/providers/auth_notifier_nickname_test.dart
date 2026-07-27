import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/storage/secure_token_storage.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:eodaego/features/user/domain/entities/agreement_status_entity.dart';
import 'package:eodaego/features/user/domain/repositories/user_repository.dart';
import 'package:eodaego/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

// 테스트 환경엔 플랫폼 채널이 없어 실제 FlutterSecureStorage는 예외를 던진다.
// AuthNotifier.updateNickname의 로컬 저장 분기가 조용히 성공하도록 인메모리로 대체한다.
// (test/core/storage/secure_token_storage_is_new_user_test.dart,
//  test/core/network/auth_interceptor_retry_test.dart와 동일한 shape)
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
  String returnedNickname = '어대탐험가';
  Object? errorToThrow;
  String? lastRequested;

  @override
  Future<String> updateNickname(String nickname) async {
    lastRequested = nickname;
    if (errorToThrow != null) throw errorToThrow!;
    return returnedNickname;
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
    nickname: '회원a1b2c3d4',
    isNewUser: true,
    requiresAgreement: false,
  );
}

ProviderContainer _containerWith(_FakeUserRepository repo) {
  return ProviderContainer(
    overrides: [
      userRepositoryProvider.overrideWithValue(repo),
      authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
      secureTokenStorageProvider.overrideWithValue(
        SecureTokenStorage(storage: _FakeSecureStorage()),
      ),
    ],
  );
}

void main() {
  group('AuthNotifier.updateNickname', () {
    test('성공 시 서버가 확정한 닉네임으로 상태를 갱신하고 isNewUser를 내린다', () async {
      final repo = _FakeUserRepository()..returnedNickname = '어대탐험가';
      final container = _containerWith(repo);
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      await container
          .read(authNotifierProvider.notifier)
          .updateNickname('어대탐험가');

      final state = container.read(authNotifierProvider).value;
      expect(state!.nickname, '어대탐험가');
      expect(state.isNewUser, isFalse);
      expect(repo.lastRequested, '어대탐험가');
    });

    test('서버 응답값이 입력값과 달라도 응답값을 반영한다', () async {
      final repo = _FakeUserRepository()..returnedNickname = '정규화된닉네임';
      final container = _containerWith(repo);
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      await container
          .read(authNotifierProvider.notifier)
          .updateNickname('입력한닉네임');

      expect(container.read(authNotifierProvider).value!.nickname, '정규화된닉네임');
    });

    test('실패 시 상태를 바꾸지 않고 예외를 다시 던진다', () async {
      final repo = _FakeUserRepository()
        ..errorToThrow = const ServerException(
          message: 'conflict',
          messageKey: 'errorTemporaryRetry',
          code: 'NICKNAME_ALREADY_EXISTS',
        );
      final container = _containerWith(repo);
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      await expectLater(
        container.read(authNotifierProvider.notifier).updateNickname('중복닉네임'),
        throwsA(
          isA<AppException>().having(
            (e) => e.code,
            'code',
            'NICKNAME_ALREADY_EXISTS',
          ),
        ),
      );

      final state = container.read(authNotifierProvider).value;
      expect(state!.nickname, '회원a1b2c3d4');
      expect(state.isNewUser, isTrue);
    });
  });
}
