import '../../../../core/mock/mock_asset_loader.dart';
import '../../../../core/utils/kst_clock.dart';
import '../models/catalog_item_detail_model.dart';
import '../models/catalog_list_response_model.dart';
import '../models/catalog_summary_model.dart';
import 'catalog_remote_datasource.dart';

/// 목 도감 데이터소스
///
/// `assets/mock/catalog.json`, `assets/mock/catalog_details.json`을 읽어
/// 돌려준다. `EnvConfig.useMockData`가 켜졌을 때 [CatalogRemoteDataSource]
/// 대신 쓰인다(분기는 `catalog_provider.dart`에서 한다).
class CatalogMockDataSource implements CatalogRemoteDataSource {
  static const _catalogAsset = 'assets/mock/catalog.json';
  static const _detailsAsset = 'assets/mock/catalog_details.json';

  @override
  Future<CatalogListResponseModel> getCatalog() async {
    final json = await loadMockJson(_catalogAsset);
    return CatalogListResponseModel.fromJson(json);
  }

  /// 도감 상세 조회
  ///
  /// **주의**: `catalog_details.json`에는 수집한 9항목만 있다. 없는 id는
  /// 실 서버의 404에 대응해 예외를 던진다 — Repository가 잡아 에러 UI로 간다.
  @override
  Future<CatalogItemDetailModel> getCatalogItem(String catalogItemId) async {
    final details = await loadMockJson(_detailsAsset);
    final shifted = _shiftCollectedAtToToday(details);

    final item = shifted[catalogItemId] as Map<String, dynamic>?;
    if (item == null) {
      throw Exception('존재하지 않는 도감 항목이에요: $catalogItemId');
    }
    return CatalogItemDetailModel.fromJson(item);
  }

  /// 목록에서 계산한다.
  ///
  /// 별도 요약 파일을 두지 않는 이유는 설계 문서 §5 참조 — 항목을 하나
  /// 고칠 때 목록과 요약 두 곳을 같이 고쳐야 하는 어긋남을 원천 차단한다.
  @override
  Future<CatalogSummaryModel> getCatalogSummary() async {
    final catalog = await getCatalog();

    final totalByCategory = <String, int>{};
    final collectedByCategory = <String, int>{};
    for (final item in catalog.items) {
      totalByCategory.update(item.category, (v) => v + 1, ifAbsent: () => 1);
      if (item.collected) {
        collectedByCategory.update(
          item.category,
          (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }

    final totalCount = catalog.items.length;
    final collectedCount = catalog.items.where((i) => i.collected).length;

    return CatalogSummaryModel(
      totalCount: totalCount,
      collectedCount: collectedCount,
      collectionRate: _rate(collectedCount, totalCount),
      byCategory: [
        for (final category in totalByCategory.keys)
          CatalogCategorySummaryModel(
            category: category,
            totalCount: totalByCategory[category]!,
            collectedCount: collectedByCategory[category] ?? 0,
            collectionRate: _rate(
              collectedByCategory[category] ?? 0,
              totalByCategory[category]!,
            ),
          ),
      ],
    );
  }

  /// 상세 맵의 모든 `collectedAt`을 오늘 기준으로 민다.
  ///
  /// 앵커는 상세들 중 가장 늦은 `collectedAt`의 날짜다. 값을 하나도 못 읽으면
  /// 앵커를 구할 수 없으므로 시프트 없이 원본을 그대로 돌려준다(방어).
  Map<String, dynamic> _shiftCollectedAtToToday(Map<String, dynamic> details) {
    final collectedAtDates = details.values
        .map((v) => (v as Map<String, dynamic>)['collectedAt'] as String?)
        .whereType<String>()
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .toList();
    if (collectedAtDates.isEmpty) return details;

    final anchor = collectedAtDates.reduce((a, b) => a.isAfter(b) ? a : b);
    final days = dayShiftFrom(anchor: anchor, today: nowKst());

    return {
      for (final entry in details.entries)
        entry.key: {
          ...entry.value as Map<String, dynamic>,
          'collectedAt': shiftIsoDays(
            (entry.value as Map<String, dynamic>)['collectedAt'] as String?,
            days,
          ),
        },
    };
  }

  double _rate(int collected, int total) {
    if (total == 0) return 0;
    return double.parse((collected / total * 100).toStringAsFixed(1));
  }
}
