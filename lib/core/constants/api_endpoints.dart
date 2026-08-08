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

  /// 닉네임 중복 확인 (GET, `?nickname=`).
  ///
  /// 공개 API가 아니다 — Bearer 토큰이 필요하며, 본인이 쓰는 닉네임은
  /// 중복 대상에서 제외되어 `available: true`로 응답한다.
  static const String checkNickname = '$_v1/members/me/nickname/exists';

  // 회원탈퇴 (DELETE, 204 no body).
  static const String deleteAccount = '$_v1/members/me';

  // Catalog — 회원별 도감 뷰.
  // `/catalog/items/*`(Catalog Item 태그)는 관리용이라 앱이 호출하지 않는다.
  static const String catalog = '$_v1/catalog';
  static const String catalogSummary = '$_v1/catalog/summary';
  static const String catalogDetail = '$_v1/catalog/{catalogItemId}';

  /// 도감 항목 수집 (POST, 204 no body). 이미 수집이면 409.
  static const String catalogCollect = '$_v1/catalog/{catalogItemId}/collect';

  // Weather — 백엔드가 내부망 AI 서버에서 받아 중계한다.
  // 장소는 어린이대공원 하나뿐이라 파라미터가 없다.
  static const String weatherCurrent = '$_v1/weather/current';

  // Congestion — 백엔드가 내부망 AI 서버에서 받아 중계한다.
  // 데이터가 없거나 AI 서버가 죽으면 503이며, 이는 정상 시나리오다.
  static const String congestionCurrent = '$_v1/congestion/current';

  // Course — 추천은 백엔드가 내부망 AI 서버를 호출해 중계하고 결과를 저장한다.
  // 호출할 때마다 서버에 코스가 새로 생성된다.
  static const String courseRecommendations = '$_v1/courses/recommendations';

  // Course Favorite — 등록·삭제 모두 멱등이다.
  static const String favorites = '$_v1/favorites';
  static const String favoriteCourse = '$_v1/favorites/{courseId}';
}
