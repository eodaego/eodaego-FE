/// 앱 라우트 경로 상수. (게임 라우트는 이번 포팅 범위 아님)
class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String nicknameSetup = '/nickname-setup';
  static const String agreement = '/agreement';
  static const String home = '/home';
  static const String maintenance = '/maintenance';
  static const String forceUpdate = '/force-update';

  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String onboardingName = 'onboarding';
  static const String nicknameSetupName = 'nicknameSetup';
  static const String agreementName = 'agreement';
  static const String homeName = 'home';
  static const String maintenanceName = 'maintenance';
  static const String forceUpdateName = 'forceUpdate';

  static String nicknameSetupWithNickname(String nickname) =>
      '$nicknameSetup?nickname=${Uri.encodeComponent(nickname)}';

  // ── 목 UI 화면 (탭 셸 브랜치) ──
  static const String map = '/map';
  static const String collection = '/collection';
  static const String favorite = '/favorite';

  // ── 목 UI 화면 (루트 push) ──
  static const String scan = '/scan';
  static const String quiz = '/quiz';
  static const String quizReward = '/quiz/reward';
  static const String mypage = '/mypage';

  static const String mapName = 'map';
  static const String collectionName = 'collection';
  static const String collectionDetailName = 'collectionDetail';
  static const String favoriteName = 'favorite';
  static const String scanName = 'scan';
  static const String quizName = 'quiz';
  static const String quizRewardName = 'quizReward';
  static const String mypageName = 'mypage';

  /// 도감 상세 경로 생성 (예: /collection/a1)
  static String collectionDetail(String id) => '$collection/$id';
}
