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
}
