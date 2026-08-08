import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/course_favorite_list_model.dart';
import '../models/course_model.dart';
import '../models/course_recommendation_request_model.dart';

part 'course_remote_datasource.g.dart';

/// 코스·즐겨찾기 백엔드 API 클라이언트
///
/// **엔드포인트**:
/// - `POST /api/1/courses/recommendations` - 코스 추천 (JWT 필요)
/// - `GET /api/1/favorites` - 즐겨찾기 목록 (JWT 필요)
/// - `POST /api/1/favorites/{courseId}` - 즐겨찾기 등록 (JWT 필요, 멱등)
/// - `DELETE /api/1/favorites/{courseId}` - 즐겨찾기 삭제 (JWT 필요, 멱등, 204)
///
/// **주의**: `GET /api/1/courses/{courseId}`는 호출할 곳이 없어 선언하지 않는다.
/// 추천 응답과 즐겨찾기 목록이 코스 전체 정보를 준다.
@RestApi()
abstract class CourseRemoteDataSource {
  factory CourseRemoteDataSource(Dio dio) = _CourseRemoteDataSource;

  /// 코스 추천 요청
  ///
  /// 호출할 때마다 백엔드가 AI 서버에 요청하고 결과를 새 코스로 저장한다.
  ///
  /// - 200: 코스 배열 (개수는 AI가 정한다 — 고정 개수 보장 없음)
  /// - 400: entrance/exit 누락 등 검증 실패
  /// - 503: 외부 AI 서버 호출 실패
  @POST(ApiEndpoints.courseRecommendations)
  Future<List<CourseModel>> recommendCourses(
    @Body() CourseRecommendationRequestModel request,
  );

  /// 즐겨찾기 목록 조회
  ///
  /// - 200: 총 개수 + 정렬된 목록 (없으면 totalCount 0, items 빈 배열)
  /// - 400: 허용 목록 밖의 sort 값
  @GET(ApiEndpoints.favorites)
  Future<CourseFavoriteListModel> getFavorites(@Query('sort') String? sort);

  /// 즐겨찾기 등록 (멱등)
  ///
  /// 이미 등록된 코스를 다시 요청해도 에러 없이 200이다.
  /// 응답 본문(즐겨찾기 ID·시각)은 쓰지 않는다.
  @POST(ApiEndpoints.favoriteCourse)
  Future<void> addFavorite(@Path('courseId') String courseId);

  /// 즐겨찾기 삭제 (멱등, 204 no body)
  ///
  /// 등록되어 있지 않은 코스를 삭제 요청해도 204다.
  @DELETE(ApiEndpoints.favoriteCourse)
  Future<void> removeFavorite(@Path('courseId') String courseId);
}
