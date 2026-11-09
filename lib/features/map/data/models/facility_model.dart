import 'package:freezed_annotation/freezed_annotation.dart';

part 'facility_model.freezed.dart';
part 'facility_model.g.dart';

/// 시설 목록 DTO
///
/// `GET /api/1/facilities` 응답 원소.
/// 좌표가 없는 시설은 latitude/longitude가 null이다.
@freezed
class FacilityModel with _$FacilityModel {
  const factory FacilityModel({
    @Default(0) int id,

    /// 시설 분류 (`출입문`, `편의시설` 등)
    @Default('') String category,
    @Default('') String name,
    double? latitude,
    double? longitude,
    String? facilityType,
  }) = _FacilityModel;

  factory FacilityModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityModelFromJson(json);
}

/// 시설 상세 DTO
///
/// `GET /api/1/facilities/{facilityId}` 응답.
/// `openTime`/`closeTime`은 서버가 `HH:mm` 문자열로 준다.
@freezed
class FacilityDetailModel with _$FacilityDetailModel {
  const factory FacilityDetailModel({
    @Default(0) int id,
    @Default('') String category,
    @Default('') String name,
    String? intro,
    String? description,
    double? latitude,
    double? longitude,
    String? facilityType,
    String? openTime,
    String? closeTime,
    String? operatingNote,
  }) = _FacilityDetailModel;

  factory FacilityDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FacilityDetailModelFromJson(json);
}
