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
  }) = _CatalogItemDetailEntity;
}
