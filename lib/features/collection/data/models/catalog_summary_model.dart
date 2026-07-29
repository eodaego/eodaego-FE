import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_summary_model.freezed.dart';
part 'catalog_summary_model.g.dart';

/// 카테고리별 수집 현황 DTO
///
/// [CatalogSummaryModel]의 `byCategory[]` 원소.
@freezed
class CatalogCategorySummaryModel with _$CatalogCategorySummaryModel {
  const factory CatalogCategorySummaryModel({
    /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
    required String category,

    /// 해당 카테고리 전체 항목 수
    @Default(0) int totalCount,

    /// 해당 카테고리 수집 항목 수
    @Default(0) int collectedCount,

    /// 수집률 백분율 — 서버가 반올림해 내려준다
    @Default(0) double collectionRate,
  }) = _CatalogCategorySummaryModel;

  factory CatalogCategorySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogCategorySummaryModelFromJson(json);
}

/// 도감 수집 현황 요약 응답 DTO
///
/// `GET /api/1/catalog/summary` 응답.
///
/// **주의**: `collectionRate`는 서버가 소수점 첫째 자리까지 반올림한
/// 백분율이다. 앱에서 다시 계산하지 않고 그대로 쓴다.
@freezed
class CatalogSummaryModel with _$CatalogSummaryModel {
  const factory CatalogSummaryModel({
    /// 전체 항목 수
    @Default(0) int totalCount,

    /// 전체 수집 항목 수
    @Default(0) int collectedCount,

    /// 전체 수집률 백분율
    @Default(0) double collectionRate,

    /// 카테고리별 현황
    @Default(<CatalogCategorySummaryModel>[])
    List<CatalogCategorySummaryModel> byCategory,
  }) = _CatalogSummaryModel;

  factory CatalogSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogSummaryModelFromJson(json);
}
