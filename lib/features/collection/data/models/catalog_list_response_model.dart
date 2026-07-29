import 'package:freezed_annotation/freezed_annotation.dart';

import 'catalog_item_summary_model.dart';

part 'catalog_list_response_model.freezed.dart';
part 'catalog_list_response_model.g.dart';

/// 도감 목록 조회 응답 DTO
///
/// `GET /api/1/catalog` 응답.
///
/// **주의**: `totalCount`/`collectedCount`는 요청한 카테고리 필터 기준이다.
/// 앱은 필터 없이 전체를 받으므로 전체 기준 값이 내려온다.
@freezed
class CatalogListResponseModel with _$CatalogListResponseModel {
  const factory CatalogListResponseModel({
    /// 전체 항목 수
    @Default(0) int totalCount,

    /// 현재 회원의 수집 항목 수
    @Default(0) int collectedCount,

    /// 도감 항목 목록
    @Default(<CatalogItemSummaryModel>[]) List<CatalogItemSummaryModel> items,
  }) = _CatalogListResponseModel;

  factory CatalogListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogListResponseModelFromJson(json);
}
