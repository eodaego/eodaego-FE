import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/pages/agreement_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/nickname_setup_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../core/widgets/pages/force_update_page.dart';
import '../core/widgets/pages/maintenance_page.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// auth 상태 변경 시 redirect 재평가를 위한 Listenable
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;
}

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: _AuthRefreshNotifier(ref),
    redirect: (context, state) {
      try {
        final auth = ref.read(authNotifierProvider);
        if (auth.isLoading) return null;

        final user = auth.value;
        final isAuthenticated = user != null;
        final path = state.uri.path;

        final publicPaths = [
          RoutePaths.login,
          RoutePaths.maintenance,
          RoutePaths.forceUpdate,
        ];

        if (!isAuthenticated) {
          return publicPaths.contains(path) ? null : RoutePaths.login;
        }

        if (user.requiresAgreement) {
          return path == RoutePaths.agreement ? null : RoutePaths.agreement;
        }

        if (user.isNewUser) {
          return path == RoutePaths.nicknameSetup
              ? null
              : RoutePaths.nicknameSetupWithNickname(user.nickname);
        }

        if (path == RoutePaths.login) return RoutePaths.home;
        if (path == RoutePaths.agreement) return RoutePaths.home;
        if (path == RoutePaths.splash) return RoutePaths.home;
        return null;
      } catch (e, stack) {
        debugPrint('🚨 [GoRouter redirect] 예외: $e\n$stack');
        return RoutePaths.login;
      }
    },
    // 화면 전환 애니메이션 없음: 모든 라우트를 NoTransitionPage로 즉시 전환
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RoutePaths.splashName,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RoutePaths.loginName,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RoutePaths.onboardingName,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: RoutePaths.nicknameSetup,
        name: RoutePaths.nicknameSetupName,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: NicknameSetupPage(
            initialNickname: state.uri.queryParameters['nickname'],
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.agreement,
        name: RoutePaths.agreementName,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const AgreementPage()),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RoutePaths.homeName,
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const HomePage()),
      ),
      GoRoute(
        path: RoutePaths.maintenance,
        name: RoutePaths.maintenanceName,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const MaintenancePage(),
        ),
      ),
      GoRoute(
        path: RoutePaths.forceUpdate,
        name: RoutePaths.forceUpdateName,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ForceUpdatePage(),
        ),
      ),
    ],
  );
}
