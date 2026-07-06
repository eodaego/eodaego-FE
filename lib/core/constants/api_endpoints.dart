/// API 엔드포인트 중앙 관리.
/// TODO(backend): 어대GO 백엔드 API 계약 확정 시 경로/스키마 교체 필요.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String reissue = '/api/auth/reissue';

  // User
  static const String myPage = '/api/user/me';
  static const String deleteAccount = '/api/user/me';
  static const String updateNickname = '/api/user/me/nickname';
  static const String checkNickname = '/api/user/check-nickname';
  static const String agreements = '/api/user/agreements';
}
