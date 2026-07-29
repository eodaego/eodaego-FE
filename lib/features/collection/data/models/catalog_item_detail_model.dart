import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_item_detail_model.freezed.dart';
part 'catalog_item_detail_model.g.dart';

/// 도감 상세 조회 응답 DTO
///
/// `GET /api/1/catalog/{catalogItemId}` 응답.
///
/// **주의**: 미수집 항목은 서버가 403으로 차단하므로 이 DTO는 항상 수집한
/// 항목이다. `collectedAt`은 ISO 8601 문자열이다.
@freezed
class CatalogItemDetailModel with _$CatalogItemDetailModel {
  const factory CatalogItemDetailModel({
    /// 도감 항목 ID
    required String id,

    /// 이름
    required String name,

    /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
    required String category,

    /// 특징 — 앱에서 한 줄 설명 자리에 쓴다
    @Default('') String feature,

    /// 어린이 눈높이 설명
    @Default('') String childDescription,

    /// 이미지 URL
    String? imageUrl,

    /// 수집 시각 (ISO 8601)
    String? collectedAt,
  }) = _CatalogItemDetailModel;

  factory CatalogItemDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemDetailModelFromJson(json);
}
