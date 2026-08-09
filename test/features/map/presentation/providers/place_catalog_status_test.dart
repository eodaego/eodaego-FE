import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_detail_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/map/presentation/providers/place_catalog_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 지도 마커 카드가 갈라지는 세 상태를 판정하는 로직.
///
/// 서버는 미수집 항목도 이름 검색에 걸어주되 응답의 `name`을 null로 가린다.
/// 그래서 "이름이 채워져 돌아온 항목 = 수집한 항목"이 판정의 축이다.
/// 이름 검색이 **부분 일치**라는 점이 이 판정을 미묘하게 만든다.

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this._result);

  final List<CatalogItemEntity> _result;

  /// 서버가 실제로 받은 인자 — 카테고리를 함께 넘겨 좁히는지 확인한다.
  DogamCategory? lastCategory;
  String? lastName;

  @override
  Future<List<CatalogItemEntity>> getCatalogItems({
    DogamCategory? category,
    String? name,
  }) async {
    lastCategory = category;
    lastName = name;
    return _result;
  }

  @override
  Future<CatalogItemDetailEntity> getCatalogItem(String id) async =>
      throw UnimplementedError();

  @override
  Future<CatalogSummaryEntity> getCatalogSummary() async =>
      throw UnimplementedError();

  @override
  Future<void> collectCatalogItem(String catalogItemId) async {}
}

Future<PlaceCatalogStatus> _resolve(
  _FakeCatalogRepository repository, {
  String placeName = '동물나라',
  DogamCategory category = DogamCategory.animal,
}) async {
  final container = ProviderContainer(
    overrides: [catalogRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container.read(
    placeCatalogStatusProvider(placeName: placeName, category: category).future,
  );
}

void main() {
  group('지도 장소의 도감 상태', () {
    test('이름이 채워져 돌아오면 이미 수집한 장소로 본다', () async {
      final status = await _resolve(
        _FakeCatalogRepository(const [
          CatalogItemEntity(
            id: 'a1',
            category: DogamCategory.animal,
            collected: true,
            name: '동물나라',
            imageUrl: 'https://example.com/a1.png',
            code: 'A001',
          ),
        ]),
      );

      expect(status.collected?.code, 'A001');
      expect(status.inCatalog, isTrue);
    });

    test('결과는 있는데 이름이 가려져 있으면 아직 못 모은 장소로 본다', () async {
      // 서버는 미수집 항목의 name·imageUrl을 null로 내려보낸다.
      final status = await _resolve(
        _FakeCatalogRepository(const [
          CatalogItemEntity(
            id: 'a1',
            category: DogamCategory.animal,
            collected: false,
          ),
        ]),
      );

      expect(status.collected, isNull);
      expect(status.inCatalog, isTrue);
    });

    test('검색 결과가 없으면 도감에 없는 시설로 본다', () async {
      final status = await _resolve(_FakeCatalogRepository(const []));

      expect(status.collected, isNull);
      expect(status.inCatalog, isFalse);
    });

    test('부분 일치로 딸려온 다른 이름을 수집한 항목으로 오인하지 않는다', () async {
      // '동물나라'로 검색하면 서버가 '동물나라 사육장'까지 물어온다. 그걸 수집으로
      // 읽으면 엉뚱한 도감 상세로 보내게 된다.
      final status = await _resolve(
        _FakeCatalogRepository(const [
          CatalogItemEntity(
            id: 'a9',
            category: DogamCategory.animal,
            collected: true,
            name: '동물나라 사육장',
            code: 'A009',
          ),
        ]),
      );

      expect(status.collected, isNull);
      // 도감에 걸리는 항목이 있으니 촬영 유도까지는 간다.
      expect(status.inCatalog, isTrue);
    });

    test('부분 일치 오탐을 줄이려고 카테고리도 함께 좁혀 보낸다', () async {
      final repository = _FakeCatalogRepository(const []);
      await _resolve(
        repository,
        placeName: '음악분수',
        category: DogamCategory.place,
      );

      expect(repository.lastName, '음악분수');
      expect(repository.lastCategory, DogamCategory.place);
    });
  });
}
