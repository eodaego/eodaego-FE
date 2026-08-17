import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_detail_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 Repository 페이크 — 수집 상태를 메모리로 들고 있어
/// invalidate 후 재조회가 실제로 갱신된 값을 받는지 검증할 수 있다.
class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository({required this.items, this.collectError});

  final List<CatalogItemEntity> items;
  final AppException? collectError;
  final collectedIds = <String>[];

  @override
  Future<List<CatalogItemEntity>> getCatalogItems({
    DogamCategory? category,
    String? name,
  }) async => [
    for (final item in items)
      collectedIds.contains(item.id) ? item.copyWith(collected: true) : item,
  ];

  @override
  Future<void> collectCatalogItem(String catalogItemId) async {
    if (collectError != null) throw collectError!;
    collectedIds.add(catalogItemId);
  }

  @override
  Future<CatalogSummaryEntity> getCatalogSummary() async =>
      CatalogSummaryEntity(
        totalCount: items.length,
        collectedCount: collectedIds.length,
        collectionRate: 0,
        collectedByCategory: const {},
      );

  @override
  Future<CatalogItemDetailEntity> getCatalogItem(String id) =>
      throw UnimplementedError();
}

const _uncollectedOtter = CatalogItemEntity(
  id: 'item-a001',
  category: DogamCategory.animal,
  collected: false,
  code: 'A001',
);

/// 지도에서 보고 있는 코스 — 장소 하나가 [catalogItemId]로 도감에 걸려 있다.
CourseEntity _selectedCourse({required String? catalogItemId}) => CourseEntity(
  id: 'course-1',
  title: '수달 만나러 가는 길',
  tagLabels: const [],
  estimatedDurationMinutes: 60,
  entrance: ParkGate.mainGate,
  exit: ParkGate.southGate,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '수달마을',
      category: DogamCategory.animal,
      catalogItemId: catalogItemId,
    ),
  ],
);

void main() {
  ProviderContainer makeContainer(CatalogRepository repository) {
    final container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWith((ref) => repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('collects_item_and_refreshes_catalog_and_summary', () async {
    final repository = _FakeCatalogRepository(items: [_uncollectedOtter]);
    final container = makeContainer(repository);
    // Reproduce a watching screen — keep the autoDispose caches alive so
    // stale values would survive without the invalidate calls.
    // 화면이 보고 있는 상황 재현 — autoDispose 캐시를 유지해서
    // "invalidate 없이는 옛 값이 남는다"를 검증 가능하게 만든다.
    container.listen(catalogItemsProvider, (_, _) {});
    container.listen(catalogSummaryProvider, (_, _) {});
    expect(
      (await container.read(catalogSummaryProvider.future)).collectedCount,
      0,
    );

    await container.read(collectCatalogItemByCodeProvider('A001').future);

    expect(repository.collectedIds, ['item-a001']);
    final refreshed = await container.read(catalogItemsProvider.future);
    expect(refreshed.single.collected, isTrue);
    expect(
      (await container.read(catalogSummaryProvider.future)).collectedCount,
      1,
    );
  });

  test('skips_collect_when_item_is_already_collected', () async {
    final repository = _FakeCatalogRepository(
      items: [_uncollectedOtter.copyWith(collected: true)],
    );
    final container = makeContainer(repository);

    await container.read(collectCatalogItemByCodeProvider('A001').future);

    expect(repository.collectedIds, isEmpty);
  });

  test('skips_collect_when_code_not_in_catalog', () async {
    final repository = _FakeCatalogRepository(items: [_uncollectedOtter]);
    final container = makeContainer(repository);

    await container.read(collectCatalogItemByCodeProvider('X999').future);

    expect(repository.collectedIds, isEmpty);
  });

  test('completes_silently_when_server_says_already_collected', () async {
    final repository = _FakeCatalogRepository(
      items: [_uncollectedOtter],
      collectError: const ServerException(
        message: 'conflict',
        code: 'CATALOG_ITEM_ALREADY_COLLECTED',
      ),
    );
    final container = makeContainer(repository);

    // Completion without exception itself is the assertion.
    // 예외 없이 완료되는 것 자체가 검증이다.
    await container.read(collectCatalogItemByCodeProvider('A001').future);

    expect(repository.collectedIds, isEmpty);
  });

  // 코스 응답의 수집 여부는 추천 시점 스냅숏이고 아무도 다시 받아오지 않는다.
  // 앱에서 모은 도감을 여기서 코스에 맞춰 주지 않으면 지도가 계속 '아직'을 그린다.
  test(
    'flips_the_map_course_place_when_its_catalog_item_is_collected',
    () async {
      final container = makeContainer(
        _FakeCatalogRepository(items: [_uncollectedOtter]),
      );
      container.read(selectedCourseProvider.notifier).state = _selectedCourse(
        catalogItemId: 'item-a001',
      );

      await container.read(collectCatalogItemByCodeProvider('A001').future);

      expect(
        container.read(selectedCourseProvider)?.places.single.collected,
        isTrue,
      );
    },
  );

  test(
    'keeps_the_map_course_when_no_place_links_to_the_collected_item',
    () async {
      final container = makeContainer(
        _FakeCatalogRepository(items: [_uncollectedOtter]),
      );
      final selected = _selectedCourse(catalogItemId: 'item-other');
      container.read(selectedCourseProvider.notifier).state = selected;

      await container.read(collectCatalogItemByCodeProvider('A001').future);

      // 인스턴스까지 그대로여야 한다 — 코스가 바뀌면 지도가 마커 비트맵을 다시 굽는다.
      expect(container.read(selectedCourseProvider), same(selected));
    },
  );

  test('surfaces_error_when_collect_fails_with_other_server_error', () async {
    final repository = _FakeCatalogRepository(
      items: [_uncollectedOtter],
      collectError: const ServerException(
        message: 'not found',
        code: 'CATALOG_ITEM_NOT_FOUND',
      ),
    );
    final container = makeContainer(repository);

    await expectLater(
      container.read(collectCatalogItemByCodeProvider('A001').future),
      throwsA(isA<ServerException>()),
    );
  });
}
