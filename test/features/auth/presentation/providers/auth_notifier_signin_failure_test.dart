import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/network/dio_client.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/domain/repositories/auth_repository.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 백엔드/네트워크 실패를 재현하는 Fake (백엔드 미실행 시나리오).
class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthResultEntity> signInWithGoogle() async => throw const NetworkException(
    message: 'connection error',
    code: 'connection-error',
  );

  @override
  Future<AuthResultEntity> signInWithApple() async => throw const NetworkException(
    message: 'connection error',
    code: 'connection-error',
  );

  @override
  Future<void> signOut() => throw UnimplementedError();
}

class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResultEntity?> build() async => null;
}

ProviderContainer _container() => ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
    authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
  ],
);

void main() {
  group('AuthNotifier 로그인 실패(백엔드/네트워크)', () {
    test('Google: 예외 전파 없이 미로그인 복귀 + loginNoticeKey=loginFailed', () async {
      final container = _container();
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      // 실패가 예외로 새어 나오면 안 됨 (버튼은 fire-and-forget).
      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isFalse);
      expect(state.value, isNull);
      expect(container.read(loginNoticeKeyProvider), 'loginFailed');
    });

    test('Apple: 동일하게 안내 키 설정 + 조용히 복귀', () async {
      final container = _container();
      addTearDown(container.dispose);
      await container.read(authNotifierProvider.future);

      await container.read(authNotifierProvider.notifier).signInWithApple();

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isFalse);
      expect(state.value, isNull);
      expect(container.read(loginNoticeKeyProvider), 'loginFailed');
    });
  });
}
