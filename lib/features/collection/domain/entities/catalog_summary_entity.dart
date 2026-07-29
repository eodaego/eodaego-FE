import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/dogam_category.dart';

part 'catalog_summary_entity.freezed.dart';

/// 도감 수집 현황 요약
///
/// **주의**: [collectionRate]는 서버가 반올림한 백분율(0~100)이다.
/// 앱에서 다시 계산하지 않는다.
@freezed
class CatalogSummaryEntity with _$CatalogSummaryEntity {
  const factory CatalogSummaryEntity({
    required int totalCount,
    required int collectedCount,
    required double collectionRate,
    required Map<DogamCategory, int> collectedByCategory,
  }) = _CatalogSummaryEntity;
}
