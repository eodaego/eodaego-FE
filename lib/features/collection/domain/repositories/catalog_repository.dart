import '../../../../core/constants/dogam_category.dart';
import '../entities/catalog_item_detail_entity.dart';
import '../entities/catalog_item_entity.dart';
import '../entities/catalog_summary_entity.dart';

/// 도감 Repository 인터페이스
abstract class CatalogRepository {
  /// 도감 목록을 조회한다. 인자를 모두 생략하면 전체를 받는다.
  ///
  /// 도감 화면의 카테고리 필터·검색은 전체를 받아 로컬로 처리한다. 인자를 쓰는
  /// 곳은 지도 마커 카드처럼 **한 항목만 짚어야 하는** 경우다.
  ///
  /// **주의**: [name]은 서버에서 부분 일치로 검색된다. 미수집 항목도 검색에는
  /// 걸리지만 결과의 [CatalogItemEntity.name]은 null이다 — 이름이 채워져 돌아온
  /// 항목만이 "수집한 항목"이다.
  Future<List<CatalogItemEntity>> getCatalogItems({
    DogamCategory? category,
    String? name,
  });

  /// 도감 항목 하나의 상세를 조회한다.
  ///
  /// **주의**: 미수집 항목은 서버가 403으로 차단한다. 호출 전에
  /// [CatalogItemEntity.collected]를 확인해야 한다.
  Future<CatalogItemDetailEntity> getCatalogItem(String id);

  /// 수집 현황 요약을 조회한다.
  Future<CatalogSummaryEntity> getCatalogSummary();

  /// 도감 항목을 수집 처리한다.
  ///
  /// **주의**: 이미 수집한 항목이면 서버가 409
  /// (`CATALOG_ITEM_ALREADY_COLLECTED`)로 거부한다 — 성공으로 취급할지는
  /// 호출부가 결정한다.
  Future<void> collectCatalogItem(String catalogItemId);
}
