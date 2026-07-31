import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_item_summary_model.freezed.dart';
part 'catalog_item_summary_model.g.dart';

/// 도감 목록 항목 DTO
///
/// `GET /api/1/catalog` 응답의 `items[]` 원소.
///
/// **주의**: 미수집 항목은 `name`·`imageUrl`이 null로 내려온다.
/// 응답의 `status`는 앱에서 쓰지 않아 선언하지 않는다.
@freezed
class CatalogItemSummaryModel with _$CatalogItemSummaryModel {
  const factory CatalogItemSummaryModel({
    /// 도감 항목 ID
    required String id,

    /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
    required String category,

    /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 서버가 생략하면 null
    String? code,

    /// 이름 — 미수집이면 null
    String? name,

    /// 이미지 URL — 미수집이면 null
    String? imageUrl,

    /// 현재 회원의 수집 여부
    @Default(false) bool collected,
  }) = _CatalogItemSummaryModel;

  factory CatalogItemSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemSummaryModelFromJson(json);
}
