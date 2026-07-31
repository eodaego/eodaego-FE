import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_detail_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
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
  Future<List<CatalogItemEntity>> getCatalogItems() async => [
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
