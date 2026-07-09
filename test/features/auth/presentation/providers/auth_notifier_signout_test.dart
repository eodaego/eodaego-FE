import 'package:eodaego/core/network/dio_client.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/domain/repositories/auth_repository.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// signOut만 제어하는 Fake. 나머지는 사용되지 않음.
class _FakeAuthRepository implements AuthRepository {
  bool throwOnSignOut = false;

  @override
  Future<void> signOut() async {
    if (throwOnSignOut) throw Exception('unexpected');
  }

  @override
  Future<AuthResultEntity> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<AuthResultEntity> signInWithApple() => throw UnimplementedError();
}

/// build()의 무거운 초기화(Firebase/토큰/콜백 등록)를 우회하는 테스트 Notifier.
class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResultEntity?> build() async => const AuthResultEntity(
    userId: 1,
    nickname: '테스트',
    isNewUser: false,
    requiresAgreement: false,
  );
}

ProviderContainer _containerWith(_FakeAuthRepository repo) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
    ],
  );
}

void main() {
  group('AuthNotifier.signOut', () {
    test('정상 로그아웃: state=data(null), loginNoticeKey=logoutSuccess', () async {
      final container = _containerWith(_FakeAuthRepository());
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      await container.read(authNotifierProvider.notifier).signOut();

      expect(container.read(authNotifierProvider).value, isNull);
      expect(container.read(loginNoticeKeyProvider), 'logoutSuccess');
    });

    test(
      '예상 밖 오류: state=data(null), loginNoticeKey=logoutUnexpected',
      () async {
        final container = _containerWith(
          _FakeAuthRepository()..throwOnSignOut = true,
        );
        addTearDown(container.dispose);
        await container.read(authNotifierProvider.future);

        await container.read(authNotifierProvider.notifier).signOut();

        expect(container.read(authNotifierProvider).value, isNull);
        expect(container.read(loginNoticeKeyProvider), 'logoutUnexpected');
      },
    );
  });
}
