import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/dogam_category.dart';

part 'catalog_item_entity.freezed.dart';

/// 도감 목록 항목
///
/// **주의**: 미수집 항목은 [name]·[imageUrl]이 null이다. 화면에서 물음표로 그린다.
@freezed
class CatalogItemEntity with _$CatalogItemEntity {
  const factory CatalogItemEntity({
    required String id,
    required DogamCategory category,
    required bool collected,
    String? name,
    String? imageUrl,

    /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
    String? code,
  }) = _CatalogItemEntity;
}
