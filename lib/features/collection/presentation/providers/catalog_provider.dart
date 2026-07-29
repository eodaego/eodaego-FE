import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/catalog_remote_datasource.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/entities/catalog_item_detail_entity.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../../domain/entities/catalog_summary_entity.dart';
import '../../domain/repositories/catalog_repository.dart';

part 'catalog_provider.g.dart';

// ============================================
// Data Layer Providers
// ============================================

/// CatalogRemoteDataSource Provider (Retrofit)
@riverpod
CatalogRemoteDataSource catalogRemoteDataSource(Ref ref) {
  return CatalogRemoteDataSource(ref.watch(dioProvider));
}

/// CatalogRepository Provider
@riverpod
CatalogRepository catalogRepository(Ref ref) {
  return CatalogRepositoryImpl(ref.watch(catalogRemoteDataSourceProvider));
}

// ============================================
// Presentation Providers (조회)
// ============================================

/// 도감 전체 목록. 카테고리 필터·이름 검색은 화면에서 로컬로 건다.
@riverpod
Future<List<CatalogItemEntity>> catalogItems(Ref ref) {
  return ref.watch(catalogRepositoryProvider).getCatalogItems();
}

/// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
@riverpod
Future<CatalogItemDetailEntity> catalogItemDetail(Ref ref, String id) {
  return ref.watch(catalogRepositoryProvider).getCatalogItem(id);
}

/// 수집 현황 요약. 홈 진행률 카드와 마이페이지 통계가 쓴다.
@riverpod
Future<CatalogSummaryEntity> catalogSummary(Ref ref) {
  return ref.watch(catalogRepositoryProvider).getCatalogSummary();
}
