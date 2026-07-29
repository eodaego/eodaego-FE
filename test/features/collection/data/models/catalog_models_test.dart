import 'package:eodaego/features/collection/data/models/catalog_item_detail_model.dart';
import 'package:eodaego/features/collection/data/models/catalog_list_response_model.dart';
import 'package:eodaego/features/collection/data/models/catalog_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalogListResponseModel', () {
    test('parses_uncollected_item_with_null_name_and_image', () {
      final model = CatalogListResponseModel.fromJson({
        'totalCount': 2,
        'collectedCount': 1,
        'items': [
          {
            'id': 'item-1',
            'code': 'OTTER',
            'category': 'ANIMAL',
            'name': '수달',
            'imageUrl': 'https://cdn.example.com/otter.png',
            'status': 'AVAILABLE',
            'collected': true,
          },
          {
            'id': 'item-2',
            'code': 'CRANE',
            'category': 'ANIMAL',
            'name': null,
            'imageUrl': null,
            'status': 'AVAILABLE',
            'collected': false,
          },
        ],
      });

      expect(model.totalCount, 2);
      expect(model.collectedCount, 1);
      expect(model.items.first.name, '수달');
      expect(model.items.first.collected, isTrue);
      // 미수집 항목은 서버가 이름·이미지를 가린다
      expect(model.items.last.name, isNull);
      expect(model.items.last.imageUrl, isNull);
      expect(model.items.last.collected, isFalse);
    });

    test('defaults_to_empty_list_when_items_absent', () {
      final model = CatalogListResponseModel.fromJson({});

      expect(model.items, isEmpty);
      expect(model.totalCount, 0);
      expect(model.collectedCount, 0);
    });
  });

  group('CatalogItemDetailModel', () {
    test('parses_full_detail_from_spec_example', () {
      final model = CatalogItemDetailModel.fromJson({
        'id': 'item-1',
        'code': 'OTTER',
        'name': '수달',
        'category': 'ANIMAL',
        'feature': '물가에서 헤엄치는 재주꾼',
        'childDescription': '수달은 물속에서 눈을 뜨고 헤엄칠 수 있어요.',
        'imageUrl': 'https://cdn.example.com/otter.png',
        'collectedAt': '2026-07-05T14:30:00+09:00',
        'status': 'AVAILABLE',
      });

      expect(model.name, '수달');
      expect(model.category, 'ANIMAL');
      expect(model.feature, '물가에서 헤엄치는 재주꾼');
      expect(model.childDescription, '수달은 물속에서 눈을 뜨고 헤엄칠 수 있어요.');
      expect(model.collectedAt, '2026-07-05T14:30:00+09:00');
    });
  });

  group('CatalogSummaryModel', () {
    test('parses_integer_collection_rate_as_double', () {
      // 서버가 0을 정수로 내려도 double로 읽혀야 한다
      final model = CatalogSummaryModel.fromJson({
        'totalCount': 80,
        'collectedCount': 24,
        'collectionRate': 30,
        'byCategory': [
          {
            'category': 'ANIMAL',
            'totalCount': 30,
            'collectedCount': 12,
            'collectionRate': 40.0,
          },
        ],
      });

      expect(model.collectionRate, 30.0);
      expect(model.byCategory.single.category, 'ANIMAL');
      expect(model.byCategory.single.collectedCount, 12);
      expect(model.byCategory.single.collectionRate, 40.0);
    });
  });
}
