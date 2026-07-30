import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/dogam_category.dart';

part 'catalog_item_detail_entity.freezed.dart';

/// 도감 상세
///
/// **주의**: [collectedAt]은 표시용 `2026.07.05` 포맷이다.
@freezed
class CatalogItemDetailEntity with _$CatalogItemDetailEntity {
  const factory CatalogItemDetailEntity({
    required String id,
    required String name,
    required DogamCategory category,
    required String feature,
    required String childDescription,
    String? imageUrl,
    String? collectedAt,

    /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
    String? code,
  }) = _CatalogItemDetailEntity;
}
