import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/domain/repositories/auth_repository.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 로그인 취소만 재현하는 Fake.
class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthResultEntity> signInWithGoogle() async =>
      throw const AuthCancelledException();

  @override
  Future<AuthResultEntity> signInWithApple() async =>
      throw const AuthCancelledException();

  @override
  Future<void> signOut() => throw UnimplementedError();
}

/// build()의 무거운 초기화를 우회하고 미로그인(null) 상태로 시작.
class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResultEntity?> build() async => null;
}

ProviderContainer _container(_FakeAuthRepository repo) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
    ],
  );
}

void main() {
  group('AuthNotifier 로그인 취소', () {
    test('Google 취소: 예외 전파 없이 미로그인(data(null))으로 복귀, 에러 상태 아님', () async {
      final container = _container(_FakeAuthRepository());
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      // 취소는 예외로 새어 나오면 안 됨 (버튼은 fire-and-forget).
      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isFalse);
      expect(state.value, isNull);
    });

    test('Apple 취소: 동일하게 조용히 복귀', () async {
      final container = _container(_FakeAuthRepository());
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      await container.read(authNotifierProvider.notifier).signInWithApple();

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isFalse);
      expect(state.value, isNull);
    });
  });
}
