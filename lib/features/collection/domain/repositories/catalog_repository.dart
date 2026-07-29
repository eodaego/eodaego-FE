import '../entities/catalog_item_detail_entity.dart';
import '../entities/catalog_item_entity.dart';
import '../entities/catalog_summary_entity.dart';

/// 도감 Repository 인터페이스
abstract class CatalogRepository {
  /// 도감 전체 목록을 조회한다.
  ///
  /// 카테고리 필터·이름 검색은 화면에서 로컬로 처리하므로 쿼리를 보내지 않는다.
  Future<List<CatalogItemEntity>> getCatalogItems();

  /// 도감 항목 하나의 상세를 조회한다.
  ///
  /// **주의**: 미수집 항목은 서버가 403으로 차단한다. 호출 전에
  /// [CatalogItemEntity.collected]를 확인해야 한다.
  Future<CatalogItemDetailEntity> getCatalogItem(String id);

  /// 수집 현황 요약을 조회한다.
  Future<CatalogSummaryEntity> getCatalogSummary();
}
