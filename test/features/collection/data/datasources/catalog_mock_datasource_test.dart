import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:eodaego/core/utils/kst_clock.dart';
import 'package:eodaego/features/collection/data/datasources/catalog_mock_datasource.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Fixed well *before* the fixture's own 2026-07-30 anchor. collectedAt
  // must always read as on-or-before "today" — if the shift silently
  // no-ops, the fixture's original (07-24~07-30) dates stay put and land
  // *after* this fixedToday, so the "before today" checks below fail
  // instead of accidentally passing.
  // 픽스처 자체 앵커인 2026-07-30보다 앞선 날짜로 고정한다. collectedAt은
  // 항상 "오늘" 이전이어야 하는데, 시프트가 조용히 no-op이면 픽스처 원본
  // (07-24~07-30) 날짜가 그대로 남아 이 fixedToday보다 미래가 되어 아래
  // "오늘 이전" 검증이 우연히 통과하지 않고 정확히 실패한다.
  final fixedToday = DateTime.utc(2026, 3, 10, 6);
  final dataSource = CatalogMockDataSource();

  group('getCatalog', () {
    test('lists_24_items_with_9_collected', () async {
      final catalog = await dataSource.getCatalog();

      expect(catalog.items.length, 24);
      expect(catalog.items.where((i) => i.collected).length, 9);
    });

    test('hides_name_for_uncollected_items', () async {
      final catalog = await dataSource.getCatalog();

      for (final item in catalog.items.where((i) => !i.collected)) {
        expect(item.name, isNull);
      }
    });

    test('reveals_name_for_collected_items', () async {
      final catalog = await dataSource.getCatalog();

      for (final item in catalog.items.where((i) => i.collected)) {
        expect(item.name, isNotNull);
      }
    });

    test('has_no_image_url_for_any_item', () async {
      final catalog = await dataSource.getCatalog();

      for (final item in catalog.items) {
        expect(item.imageUrl, isNull);
      }
    });
  });

  group('getCatalogItem', () {
    test('returns_detail_for_a_collected_item_id', () async {
      final catalog = await dataSource.getCatalog();
      final collectedId = catalog.items.firstWhere((i) => i.collected).id;

      final detail = await dataSource.getCatalogItem(collectedId);

      expect(detail.id, collectedId);
      expect(detail.name, isNotNull);
    });

    test('throws_for_an_unknown_item_id', () async {
      expect(
        () => dataSource.getCatalogItem('not-a-real-id'),
        throwsA(anything),
      );
    });

    test('shifts_every_collected_items_collectedAt_to_before_today', () async {
      await withClock(Clock.fixed(fixedToday), () async {
        final today = nowKst();
        final catalog = await dataSource.getCatalog();
        final collectedIds = catalog.items
            .where((i) => i.collected)
            .map((i) => i.id);

        for (final id in collectedIds) {
          final detail = await dataSource.getCatalogItem(id);
          final collectedAt = parseKstDateTime(detail.collectedAt)!;
          expect(
            collectedAt.isAfter(today),
            isFalse,
            reason: '$id의 collectedAt이 오늘보다 미래예요',
          );
        }
      });
    });

    test('anchors_latest_collectedAt_to_todays_kst_date', () async {
      await withClock(Clock.fixed(fixedToday), () async {
        final today = nowKst();
        final catalog = await dataSource.getCatalog();
        final collectedIds = catalog.items
            .where((i) => i.collected)
            .map((i) => i.id);

        final shiftedDates = <DateTime>[];
        for (final id in collectedIds) {
          final detail = await dataSource.getCatalogItem(id);
          shiftedDates.add(parseKstDateTime(detail.collectedAt)!);
        }

        final latest = shiftedDates.reduce((a, b) => a.isAfter(b) ? a : b);
        expect(latest.year, today.year);
        expect(latest.month, today.month);
        expect(latest.day, today.day);
      });
    });
  });

  group('getCatalogSummary', () {
    test('matches_total_and_collected_counts_from_the_list', () async {
      final catalog = await dataSource.getCatalog();
      final summary = await dataSource.getCatalogSummary();

      expect(summary.totalCount, catalog.items.length);
      expect(
        summary.collectedCount,
        catalog.items.where((i) => i.collected).length,
      );
    });

    test('collectionRate_is_9_of_24_as_a_rounded_percentage', () async {
      final summary = await dataSource.getCatalogSummary();

      expect(summary.collectionRate, 37.5);
    });

    test('byCategory_matches_actual_counts_per_category', () async {
      final catalog = await dataSource.getCatalog();
      final summary = await dataSource.getCatalogSummary();

      for (final category in ['ANIMAL', 'PLANT', 'PLACE']) {
        final items = catalog.items.where((i) => i.category == category);
        final entry = summary.byCategory.firstWhere(
          (c) => c.category == category,
        );

        expect(entry.totalCount, items.length);
        expect(entry.collectedCount, items.where((i) => i.collected).length);
      }
    });
  });

  group('fixture consistency', () {
    test('catalog_and_details_reference_the_same_id_set', () async {
      final catalogRaw =
          jsonDecode(await rootBundle.loadString('assets/mock/catalog.json'))
              as Map<String, dynamic>;
      final detailsRaw =
          jsonDecode(
                await rootBundle.loadString('assets/mock/catalog_details.json'),
              )
              as Map<String, dynamic>;

      final collectedIds = (catalogRaw['items'] as List)
          .cast<Map<String, dynamic>>()
          .where((item) => item['collected'] == true)
          .map((item) => item['id'] as String)
          .toSet();

      expect(detailsRaw.keys.toSet(), collectedIds);
    });
  });
}
