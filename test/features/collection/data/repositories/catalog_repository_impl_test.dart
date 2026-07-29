import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/collection/data/datasources/catalog_remote_datasource.dart';
import 'package:eodaego/features/collection/data/models/catalog_item_detail_model.dart';
import 'package:eodaego/features/collection/data/models/catalog_item_summary_model.dart';
import 'package:eodaego/features/collection/data/models/catalog_list_response_model.dart';
import 'package:eodaego/features/collection/data/models/catalog_summary_model.dart';
import 'package:eodaego/features/collection/data/repositories/catalog_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크. 내부 협력자는 전부 실제 코드다.
class _FakeCatalogDataSource implements CatalogRemoteDataSource {
  _FakeCatalogDataSource({
    this.list = const CatalogListResponseModel(),
    this.detail,
    this.summary = const CatalogSummaryModel(),
  });

  final CatalogListResponseModel list;
  final CatalogItemDetailModel? detail;
  final CatalogSummaryModel summary;

  @override
  Future<CatalogListResponseModel> getCatalog() async => list;

  @override
  Future<CatalogItemDetailModel> getCatalogItem(String catalogItemId) async =>
      detail!;

  @override
  Future<CatalogSummaryModel> getCatalogSummary() async => summary;
}

void main() {
  group('getCatalogItems', () {
    test(
      'maps_server_category_to_enum_and_keeps_null_name_for_uncollected',
      () async {
        final repository = CatalogRepositoryImpl(
          _FakeCatalogDataSource(
            list: const CatalogListResponseModel(
              totalCount: 2,
              collectedCount: 1,
              items: [
                CatalogItemSummaryModel(
                  id: 'a1',
                  category: 'ANIMAL',
                  name: '수달',
                  imageUrl: 'https://cdn.example.com/otter.png',
                  collected: true,
                ),
                CatalogItemSummaryModel(
                  id: 'p1',
                  category: 'PLANT',
                  collected: false,
                ),
              ],
            ),
          ),
        );

        final items = await repository.getCatalogItems();

        expect(items.length, 2);
        expect(items.first.category, DogamCategory.animal);
        expect(items.first.name, '수달');
        expect(items.last.category, DogamCategory.plant);
        expect(items.last.name, isNull);
        expect(items.last.collected, isFalse);
      },
    );

    test('drops_items_whose_category_is_unknown', () async {
      final repository = CatalogRepositoryImpl(
        _FakeCatalogDataSource(
          list: const CatalogListResponseModel(
            items: [
              CatalogItemSummaryModel(id: 'a1', category: 'ANIMAL'),
              CatalogItemSummaryModel(id: 'x1', category: 'INSECT'),
            ],
          ),
        ),
      );

      final items = await repository.getCatalogItems();

      // 색·아이콘이 없는 카테고리는 그릴 수 없으므로 목록에서 뺀다
      expect(items.map((e) => e.id), ['a1']);
    });
  });

  group('getCatalogItem', () {
    test('formats_collected_at_as_dotted_date', () async {
      final repository = CatalogRepositoryImpl(
        _FakeCatalogDataSource(
          detail: const CatalogItemDetailModel(
            id: 'a1',
            name: '수달',
            category: 'ANIMAL',
            feature: '물가에서 헤엄치는 재주꾼',
            childDescription: '물속에서 눈을 뜨고 헤엄칠 수 있어요.',
            collectedAt: '2026-07-05T14:30:00+09:00',
          ),
        ),
      );

      final detail = await repository.getCatalogItem('a1');

      expect(detail.collectedAt, '2026.07.05');
      expect(detail.category, DogamCategory.animal);
      expect(detail.feature, '물가에서 헤엄치는 재주꾼');
    });

    test('formats_collected_at_using_kst_even_when_utc_date_differs', () async {
      // 2026-07-05T08:00:00+09:00 == 2026-07-04T23:00:00Z — UTC 날짜가 하루 다르다.
      // toLocal()로 바꾸면 CI 러너 타임존에 따라 07.04로도 보일 수 있어
      // KST(UTC+9)로 고정 변환하는지를 검증한다.
      final repository = CatalogRepositoryImpl(
        _FakeCatalogDataSource(
          detail: const CatalogItemDetailModel(
            id: 'a1',
            name: '수달',
            category: 'ANIMAL',
            collectedAt: '2026-07-05T08:00:00+09:00',
          ),
        ),
      );

      final detail = await repository.getCatalogItem('a1');

      expect(detail.collectedAt, '2026.07.05');
    });

    test('leaves_collected_at_null_when_server_omits_it', () async {
      final repository = CatalogRepositoryImpl(
        _FakeCatalogDataSource(
          detail: const CatalogItemDetailModel(
            id: 'a1',
            name: '수달',
            category: 'ANIMAL',
          ),
        ),
      );

      final detail = await repository.getCatalogItem('a1');

      expect(detail.collectedAt, isNull);
    });

    test('throws_when_category_is_unknown', () async {
      final repository = CatalogRepositoryImpl(
        _FakeCatalogDataSource(
          detail: const CatalogItemDetailModel(
            id: 'x1',
            name: '알 수 없는 항목',
            category: 'INSECT',
          ),
        ),
      );

      // 반쯤 만들어진 엔티티를 돌려주지 않고 예외를 던져야 한다
      expect(
        () => repository.getCatalogItem('x1'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getCatalogSummary', () {
    test(
      'groups_counts_by_category_and_keeps_server_collection_rate',
      () async {
        final repository = CatalogRepositoryImpl(
          _FakeCatalogDataSource(
            summary: const CatalogSummaryModel(
              totalCount: 80,
              collectedCount: 24,
              collectionRate: 30.0,
              byCategory: [
                CatalogCategorySummaryModel(
                  category: 'ANIMAL',
                  totalCount: 30,
                  collectedCount: 12,
                  collectionRate: 40.0,
                ),
                CatalogCategorySummaryModel(
                  category: 'INSECT',
                  totalCount: 5,
                  collectedCount: 1,
                  collectionRate: 20.0,
                ),
              ],
            ),
          ),
        );

        final summary = await repository.getCatalogSummary();

        expect(summary.totalCount, 80);
        expect(summary.collectedCount, 24);
        // 서버가 계산한 값을 그대로 쓴다
        expect(summary.collectionRate, 30.0);
        expect(summary.collectedByCategory[DogamCategory.animal], 12);
        // 알 수 없는 카테고리는 무시한다
        expect(summary.collectedByCategory.length, 1);
      },
    );
  });
}
