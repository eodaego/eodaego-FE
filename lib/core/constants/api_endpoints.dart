/// API 엔드포인트 중앙 관리.
///
/// 정본: `docs/api-docs.json`. 모든 경로는 `/api/{version}` 형태이며
/// 현재 모든 엔드포인트의 버전은 `1`이다.
class ApiEndpoints {
  ApiEndpoints._();

  /// API 버전 prefix. const 문자열 보간이므로 Retrofit 어노테이션에서 사용 가능.
  static const String _v1 = '/api/1';

  // Auth
  static const String login = '$_v1/auth/login';
  static const String logout = '$_v1/auth/logout';
  static const String reissue = '$_v1/auth/reissue';

  // Member
  static const String agreements = '$_v1/members/me/agreements';
  static const String updateNickname = '$_v1/members/me/nickname';

  // GET 마이페이지 조회는 정본에 대응 API가 없다. 후속 작업에서 정리한다.
  static const String myPage = '$_v1/members/me';

  // 회원탈퇴는 정본에 존재한다 (DELETE, 204 no body).
  // 현재 DataSource가 응답 본문을 기대하는 불일치는 후속 작업에서 바로잡는다.
  static const String deleteAccount = '$_v1/members/me';
}
