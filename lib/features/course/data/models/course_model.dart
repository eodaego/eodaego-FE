import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

/// 코스 장소 DTO
///
/// `CourseResponse.places[]` 원소.
///
/// **주의**: 응답의 `facilityId`는 현재 사용하지 않는다.
/// `mapX`·`mapY`는 문서상 항상 null이라 약도 좌표는 프론트에서 관리한다.
@freezed
class CoursePlaceModel with _$CoursePlaceModel {
  const factory CoursePlaceModel({
    /// 방문 순서(1부터)
    @Default(0) int visitOrder,

    /// 장소 이름 — 도감 미동기화 시설이면 AI가 준 이름이 들어온다
    @Default('') String name,

    /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
    String? category,

    /// 연결된 도감 항목 ID. 도감에 동기화되지 않은 시설이면 null
    String? catalogItemId,

    /// 현재 회원의 도감 수집 여부
    @Default(false) bool collected,

    /// 실제 지도에 표시할 위도
    double? latitude,

    /// 실제 지도에 표시할 경도
    double? longitude,
  }) = _CoursePlaceModel;

  factory CoursePlaceModel.fromJson(Map<String, dynamic> json) =>
      _$CoursePlaceModelFromJson(json);
}

/// 코스 DTO
///
/// `POST /api/1/courses/recommendations` 응답 원소이자
/// `GET /api/1/favorites` 응답의 `items[].course`.
///
/// **주의**: 응답의 `interestTypes`는 카드 뱃지가 장소 카테고리를 쓰므로 선언하지 않는다.
@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    @Default('') String id,
    @Default('') String title,

    /// AI가 만든 특징 태그 1~3개
    @Default(<String>[]) List<String> tagLabels,

    /// AI가 계산한 완주 예상 소요시간(분)
    @Default(0) int estimatedDurationMinutes,

    /// 입구 원문 (`MAIN_GATE` 등)
    String? entrance,

    /// 출구 원문
    String? exit,

    /// 즐겨찾기 여부 — 추천 직후에는 항상 false
    @Default(false) bool favorite,

    /// 방문 순서대로 정렬된 장소. 입구·출구는 포함되지 않는다
    @Default(<CoursePlaceModel>[]) List<CoursePlaceModel> places,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}
