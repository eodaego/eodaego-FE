import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_recommendation_request_model.freezed.dart';
part 'course_recommendation_request_model.g.dart';

/// 코스 추천 요청 DTO
///
/// `POST /api/1/courses/recommendations` 요청 본문.
///
/// **주의**: `entrance`·`exit`는 필수다. 나머지는 건너뛰면 null로 보내며,
/// 백엔드가 기본값을 채우지 않고 AI 서버에 null 그대로 전달한다.
@freezed
class CourseRecommendationRequestModel with _$CourseRecommendationRequestModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(includeIfNull: false)
  const factory CourseRecommendationRequestModel({
    /// 입구 원문 — 필수
    required String entrance,

    /// 출구 원문 — 필수
    required String exit,

    /// 관심 태그 원문 목록. null이면 AI가 전체 태그를 대상으로 추천한다
    List<String>? interestTypes,

    /// 희망 체류시간(분). null이면 AI가 알아서 정한다
    int? stayDurationMinutes,

    /// 동행 유형 원문. null이면 AI가 알아서 정한다
    String? companionType,
  }) = _CourseRecommendationRequestModel;

  factory CourseRecommendationRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CourseRecommendationRequestModelFromJson(json);
}
