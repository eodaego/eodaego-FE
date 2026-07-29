import 'dart:ui';

import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/user/domain/entities/agreement_status_entity.dart';
import 'package:eodaego/features/user/domain/repositories/user_repository.dart';
import 'package:eodaego/features/user/presentation/providers/user_provider.dart';
import 'package:eodaego/main.dart';
import 'package:eodaego/router/app_router.dart';
import 'package:eodaego/router/route_paths.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 실제 Firebase/백엔드 의존성 없이 초기 상태만 세팅하는 테스트용 Notifier.
/// (test/features/auth/presentation/providers/auth_notifier_agreement_test.dart와 동일한 shape)
class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(this._initial);

  final AuthResultEntity? _initial;

  @override
  Future<AuthResultEntity?> build() async => _initial;
}

/// AgreementPage 진입 시 `agreementNotifierProvider`가 실제 네트워크를 타지 않도록 하는 fake.
class _FakeUserRepository implements UserRepository {
  @override
  Future<AgreementStatusEntity> getAgreements() async =>
      const AgreementStatusEntity(
        termsOfService: false,
        privacyPolicy: false,
        locationTerms: false,
        marketing: false,
      );

  @override
  Future<String> updateNickname(String nickname) => throw UnimplementedError();

  @override
  Future<bool> isNicknameAvailable(String nickname) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAccount() => throw UnimplementedError();

  @override
  Future<void> updateAgreements({required bool marketing}) =>
      throw UnimplementedError();
}

// /home은 4탭 셸(StatefulShellRoute.indexedStack)의 첫 branch라 그 경로로 리다이렉트/
// 도달하는 순간 HomePage(→ _DogamProgressCard)가 실제로 빌드되며 catalogSummaryProvider를
// watch한다. 실 Dio 호출(네트워크 경계)을 막기 위해 모든 케이스의 기본 override에 둔다 —
// /home을 거치지 않는 케이스에서는 어차피 watch되지 않으니 해가 없다.
const _fakeCatalogSummary = CatalogSummaryEntity(
  totalCount: 80,
  collectedCount: 24,
  collectionRate: 30,
  collectedByCategory: {
    DogamCategory.animal: 8,
    DogamCategory.plant: 8,
    DogamCategory.place: 8,
  },
  totalByCategory: {
    DogamCategory.animal: 27,
    DogamCategory.plant: 27,
    DogamCategory.place: 26,
  },
);

/// [Finding 1] 라우터 리다이렉트 회귀 테스트.
///
/// `lib/router/app_router.dart`의 redirect 클로저는 GoRouter 내부(비공개)라 직접
/// 호출할 수 없다. 실제 `routerProvider`로 GoRouter를 빌드하고 목표 경로로 이동시켜,
/// 최종적으로 어느 화면에 머무는지(`currentConfiguration.uri.path`)를 검증한다.
Future<GoRouter> _buildRouterAt(
  WidgetTester tester,
  AuthResultEntity? user,
  String path, {
  List<Override> extraOverrides = const [],
}) async {
  final container = ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(() => _TestAuthNotifier(user)),
      catalogSummaryProvider.overrideWith((ref) => _fakeCatalogSummary),
      ...extraOverrides,
    ],
  );
  addTearDown(container.dispose);
  await container.read(authNotifierProvider.future);

  final router = container.read(routerProvider);
  router.go(path);

  // ScreenUtilInit의 designSize(393x852)와 다른 테스트 기본 뷰포트(800x600)를
  // 쓰면 하단 탭바 등에서 RenderFlex overflow가 발생한다. 디자인 사이즈에
  // 맞춰 뷰포트를 설정해 실제 기기 비율과 유사하게 만든다.
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
  await tester.pumpAndSettle();

  // _RouterRefreshNotifier가 생성하는 1회성 스플래시 최소노출 타이머(1800ms)를
  // 흘려보내지 않으면 "A Timer is still pending" assertion으로 테스트가 실패한다.
  await tester.pump(const Duration(milliseconds: 1900));

  return router;
}

/// 현재 GoRouter가 머무른 경로.
extension on GoRouter {
  String get currentPath => routerDelegate.currentConfiguration.uri.path;
}

void main() {
  const requiresAgreementUser = AuthResultEntity(
    userId: 'user-1',
    nickname: '',
    isNewUser: true,
    requiresAgreement: true,
  );
  const newUserAfterAgreement = AuthResultEntity(
    userId: 'user-2',
    nickname: '회원a1b2',
    isNewUser: true,
    requiresAgreement: false,
  );
  const onboardedUser = AuthResultEntity(
    userId: 'user-3',
    nickname: '어대탐험가',
    isNewUser: false,
    requiresAgreement: false,
  );

  group('router redirect', () {
    testWidgets(
      'requiresAgreement:true 상태로 /nickname-setup 접근 시 /agreement로 리다이렉트',
      (tester) async {
        final handle = await _buildRouterAt(
          tester,
          requiresAgreementUser,
          RoutePaths.nicknameSetup,
          extraOverrides: [
            userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
          ],
        );

        expect(handle.currentPath, RoutePaths.agreement);
      },
    );

    testWidgets('isNewUser:true 상태로 /agreement 접근 시 /nickname-setup으로 리다이렉트', (
      tester,
    ) async {
      final handle = await _buildRouterAt(
        tester,
        newUserAfterAgreement,
        RoutePaths.agreement,
      );

      expect(handle.currentPath, RoutePaths.nicknameSetup);
    });

    testWidgets(
      '[회귀] requiresAgreement/isNewUser 모두 false 상태로 /nickname-setup에 머물러도 '
      '/home으로 리다이렉트된다 (닉네임 설정 완료 후 방치 방지)',
      (tester) async {
        final handle = await _buildRouterAt(
          tester,
          onboardedUser,
          RoutePaths.nicknameSetup,
        );

        expect(handle.currentPath, RoutePaths.home);
      },
    );

    testWidgets(
      'requiresAgreement/isNewUser 모두 false 상태로 /home에 머무르면 리다이렉트되지 않는다',
      (tester) async {
        final handle = await _buildRouterAt(
          tester,
          onboardedUser,
          RoutePaths.home,
        );

        expect(handle.currentPath, RoutePaths.home);
      },
    );
  });
}
