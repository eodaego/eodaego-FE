import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/dogam_category.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_exception_handler.dart';
import '../../domain/entities/catalog_item_detail_entity.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../../domain/entities/catalog_summary_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_datasource.dart';

/// Catalog Repository 구현체
///
/// [CatalogRemoteDataSource]를 통해 백엔드 도감 API를 호출한다.
class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _dataSource;

  CatalogRepositoryImpl(this._dataSource);

  @override
  Future<List<CatalogItemEntity>> getCatalogItems() async {
    try {
      final response = await _dataSource.getCatalog();

      final items = <CatalogItemEntity>[];
      // Unknown category values seen in this response, collected instead of
      // logged per item — a new server category would otherwise print once
      // per affected item (up to 50 lines for one load).
      // 이번 응답에서 본 미지 카테고리 값들 — 항목마다 찍지 않고 모아둔다.
      // 서버에 카테고리가 추가되면 항목당(최대 50줄) 로그가 찍히는 걸 막는다.
      final unknownCategories = <String>{};
      for (final dto in response.items) {
        final category = DogamCategory.fromServer(dto.category);
        if (category == null) {
          unknownCategories.add(dto.category);
          continue;
        }
        items.add(
          CatalogItemEntity(
            id: dto.id,
            category: category,
            collected: dto.collected,
            name: dto.name,
            imageUrl: dto.imageUrl,
          ),
        );
      }

      if (unknownCategories.isNotEmpty) {
        final excludedCount = response.items.length - items.length;
        debugPrint(
          '[Catalog] ⚠️ 알 수 없는 카테고리 ${unknownCategories.length}종 '
          '(${unknownCategories.join(', ')}) — $excludedCount개 항목 제외',
        );
      }

      if (kDebugMode) {
        debugPrint('[Catalog] ✅ 도감 목록 ${items.length}개 조회');
      }

      return items;
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '도감을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: 'errorCatalogListUnexpected',
        originalException: e,
      );
    }
  }

  @override
  Future<CatalogItemDetailEntity> getCatalogItem(String id) async {
    try {
      final dto = await _dataSource.getCatalogItem(id);

      final category = DogamCategory.fromServer(dto.category);
      if (category == null) {
        debugPrint('[Catalog] ⚠️ 알 수 없는 카테고리: ${dto.category} (상세 표시 불가)');
        throw ServerException(
          message: '아직 준비 중인 항목이에요.',
          messageKey: 'errorCatalogUnknownCategory',
        );
      }

      if (kDebugMode) {
        debugPrint('[Catalog] ✅ 도감 상세 조회: ${dto.name}');
      }

      return CatalogItemDetailEntity(
        id: dto.id,
        name: dto.name,
        category: category,
        feature: dto.feature,
        childDescription: dto.childDescription,
        imageUrl: dto.imageUrl,
        collectedAt: _formatCollectedAt(dto.collectedAt),
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '도감 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: 'errorCatalogDetailUnexpected',
        originalException: e,
      );
    }
  }

  @override
  Future<CatalogSummaryEntity> getCatalogSummary() async {
    try {
      final dto = await _dataSource.getCatalogSummary();

      final collectedByCategory = <DogamCategory, int>{};
      for (final entry in dto.byCategory) {
        final category = DogamCategory.fromServer(entry.category);
        if (category == null) {
          debugPrint('[Catalog] ⚠️ 알 수 없는 카테고리: ${entry.category} (요약 제외)');
          continue;
        }
        collectedByCategory[category] = entry.collectedCount;
      }

      if (kDebugMode) {
        debugPrint(
          '[Catalog] ✅ 수집 현황 요약: '
          '${dto.collectedCount}/${dto.totalCount} (${dto.collectionRate}%)',
        );
      }

      return CatalogSummaryEntity(
        totalCount: dto.totalCount,
        collectedCount: dto.collectedCount,
        collectionRate: dto.collectionRate,
        collectedByCategory: collectedByCategory,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '수집 현황을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: 'errorCatalogSummaryUnexpected',
        originalException: e,
      );
    }
  }

  // Formats an ISO 8601 timestamp into the display format `2026.07.05`.
  // ISO 8601 시각을 표시용 `2026.07.05` 포맷으로 바꾼다.
  //
  // **주의**: 어대GO는 서울 어린이대공원 앱이라 수집 시각은 항상 한국 시간(KST) 기준이다.
  // `toLocal()`을 쓰면 기기(혹은 CI 러너)의 타임존에 따라 날짜가 달라진다
  // (예: `2026-07-05T08:00:00+09:00`가 UTC-계열 환경에서는 07.04로 보인다).
  // 그래서 기기 타임존과 무관하게 UTC+9를 고정으로 더한다.
  String? _formatCollectedAt(String? iso) {
    if (iso == null) return null;
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) {
      debugPrint('[Catalog] ⚠️ 수집 시각 파싱 실패: $iso');
      return null;
    }
    final kst = parsed.toUtc().add(const Duration(hours: 9));
    final month = kst.month.toString().padLeft(2, '0');
    final day = kst.day.toString().padLeft(2, '0');
    return '${kst.year}.$month.$day';
  }
}
