import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../data/datasources/catalog_mock_datasource.dart';
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
///
/// `EnvConfig.useMockData`가 켜지면 [CatalogMockDataSource]로 바뀐다.
/// 아래 [catalogRepositoryProvider]는 어느 쪽이든 같은 인터페이스만 보므로
/// 수정할 필요가 없다.
@riverpod
CatalogRemoteDataSource catalogRemoteDataSource(Ref ref) {
  if (EnvConfig.useMockData) {
    debugPrint('[Mock] ✅ 도감 목 데이터 사용');
    return CatalogMockDataSource();
  }
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

// ============================================
// Presentation Providers (수집)
// ============================================

/// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
///
/// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
/// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
///
/// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
/// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
/// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
///
/// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
/// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
/// 호출부가 게스트 가드를 책임진다.
@riverpod
Future<void> collectCatalogItemByCode(Ref ref, String code) async {
  // Read once — watching would re-run this via the invalidate below.
  // 한 번만 읽는다 — watch하면 아래 invalidate가 이 provider를 다시 돌린다.
  final items = await ref.read(catalogItemsProvider.future);

  CatalogItemEntity? item;
  for (final candidate in items) {
    if (candidate.code == code) {
      item = candidate;
      break;
    }
  }
  if (item == null) {
    debugPrint('[Catalog] ⚠️ 수집 대상 code를 찾지 못했어요: $code');
    return;
  }
  if (item.collected) return;

  try {
    await ref.read(catalogRepositoryProvider).collectCatalogItem(item.id);
  } on ServerException catch (e) {
    // Server already has it — treat as success and refresh below.
    // 서버 기준 이미 수집 — 성공으로 취급하고 아래에서 갱신한다.
    if (e.code != 'CATALOG_ITEM_ALREADY_COLLECTED') rethrow;
    debugPrint('[Catalog] ⚠️ 이미 수집한 항목: $code');
  }

  ref.invalidate(catalogSummaryProvider);
  ref.invalidate(catalogItemsProvider);

  // The selected course carries a snapshot of collection state; nothing refetches it.
  // 지금 보는 코스는 추천 시점의 수집 여부를 들고 있고 아무도 다시 받아오지 않는다.
  // 방금 모은 장소가 지도에서 계속 '아직'으로 보이지 않도록 여기서 맞춘다.
  // 코스 타입을 이름으로 쓰지 않아 course feature를 직접 import하지 않는다.
  final collectedId = item.id;
  ref
      .read(selectedCourseProvider.notifier)
      .update((course) => course?.markCollected(collectedId));
}
