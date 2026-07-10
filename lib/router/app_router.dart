import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/pages/agreement_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/nickname_setup_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/collection/presentation/pages/collection_detail_page.dart';
import '../features/collection/presentation/pages/collection_page.dart';
import '../features/course/presentation/pages/course_wizard_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/quiz/presentation/pages/quiz_page.dart';
import '../features/quiz/presentation/pages/quiz_reward_page.dart';
import '../features/scan/presentation/pages/scan_page.dart';
import '../core/widgets/main_tab_shell.dart';
import '../core/widgets/pages/force_update_page.dart';
import '../core/widgets/pages/maintenance_page.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// 스플래시 화면 최소 노출 시간 (앱 시작 시 1회)
const Duration _minSplashDuration = Duration(milliseconds: 1800);

/// auth 상태 변경 + 최소 스플래시 시간 경과 시 redirect 재평가를 위한 Listenable
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, _) => notifyListeners());
    _splashTimer = Timer(_minSplashDuration, () {
      minSplashElapsed = true;
      notifyListeners();
    });
  }
  final Ref _ref;
  Timer? _splashTimer;

  /// 최소 스플래시 노출 시간이 지났는지 여부
  bool minSplashElapsed = false;

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }
}

@riverpod
GoRouter router(Ref ref) {
  final refresh = _RouterRefreshNotifier(ref);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final path = state.uri.path;

      // 스플래시 최소 노출 시간 보장: auth 로딩/에러와 무관하게 최상단에서 적용.
      // (auth.value가 에러를 rethrow하면 아래 catch로 빠지므로, 게이트를 try 밖에 둬야 유효)
      if (path == RoutePaths.splash && !refresh.minSplashElapsed) {
        return null;
      }

      try {
        final auth = ref.read(authNotifierProvider);
        if (auth.isLoading) return null;

        final user = auth.value;
        final isAuthenticated = user != null;

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
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const OnboardingPage()),
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
      // ── 4탭 셸 ──
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          key: state.pageKey,
          child: MainTabShell(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RoutePaths.homeName,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.map,
                name: RoutePaths.mapName,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const _StubPage(title: '지도'),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.collection,
                name: RoutePaths.collectionName,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const CollectionPage(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: RoutePaths.collectionDetailName,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: CollectionDetailPage(
                        itemId: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.favorite,
                name: RoutePaths.favoriteName,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const _StubPage(title: '즐겨찾기'),
                ),
              ),
            ],
          ),
        ],
      ),
      // ── 루트 push 화면 (탭바 없음) ──
      GoRoute(
        path: RoutePaths.scan,
        name: RoutePaths.scanName,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ScanPage(),
        ),
      ),
      GoRoute(
        path: RoutePaths.quiz,
        name: RoutePaths.quizName,
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const QuizPage()),
      ),
      GoRoute(
        path: RoutePaths.quizReward,
        name: RoutePaths.quizRewardName,
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const QuizRewardPage()),
      ),
      GoRoute(
        path: RoutePaths.courseWizard,
        name: RoutePaths.courseWizardName,
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const CourseWizardPage()),
      ),
      GoRoute(
        path: RoutePaths.courseResult,
        name: RoutePaths.courseResultName,
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const _StubPage(title: '추천 코스')),
      ),
      GoRoute(
        path: RoutePaths.mypage,
        name: RoutePaths.mypageName,
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey, child: const _StubPage(title: '내 정보')),
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

/// 목 UI 구축 중 임시 화면. 모든 화면 구현 완료 시(Task 13) 삭제.
class _StubPage extends StatelessWidget {
  const _StubPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}
