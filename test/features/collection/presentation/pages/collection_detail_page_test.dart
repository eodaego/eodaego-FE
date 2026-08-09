import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_detail_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/presentation/pages/collection_detail_page.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크.
///
/// [detail]이 null이면 상세 조회가 던진다 — 미수집 화면이 상세를 부르는 순간
/// 에러 화면으로 바뀌어 물음표 어서션이 깨진다. 호출 횟수를 세는 대신
/// 화면 출력만으로 "부르지 않는다"를 지킨다.
class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository({this.detail});

  final CatalogItemDetailEntity? detail;

  @override
  Future<List<CatalogItemEntity>> getCatalogItems({
    DogamCategory? category,
    String? name,
  }) async => const [];

  @override
  Future<CatalogItemDetailEntity> getCatalogItem(String id) async {
    final loaded = detail;
    if (loaded == null) {
      throw StateError('미수집 항목의 상세를 호출하면 안 된다 (서버가 403으로 막는다)');
    }
    return loaded;
  }

  @override
  Future<CatalogSummaryEntity> getCatalogSummary() async =>
      const CatalogSummaryEntity(
        totalCount: 0,
        collectedCount: 0,
        collectionRate: 0,
        collectedByCategory: {},
      );

  @override
  Future<void> collectCatalogItem(String catalogItemId) async {}
}

Widget _wrap(Widget child, _FakeCatalogRepository repository) {
  return ProviderScope(
    overrides: [catalogRepositoryProvider.overrideWith((ref) => repository)],
    child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => MaterialApp(home: child),
    ),
  );
}

/// 테스트 기본 뷰(800x600)는 ScreenUtil 기준(393x852)과 달라 레이아웃이 왜곡된다.
/// 실제 기기 비율로 맞춘다.
void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets(
    'shows_question_marks_and_skips_detail_request_when_uncollected',
    (tester) async {
      _useDesignViewport(tester);
      // detail이 null이면 상세 조회는 던진다. 아래 어서션이 통과한다는 것 자체가
      // 상세 API를 부르지 않았다는 증거다.
      final repository = _FakeCatalogRepository();

      await tester.pumpWidget(
        _wrap(
          const CollectionDetailPage(
            itemId: 'p2',
            item: CatalogItemEntity(
              id: 'p2',
              category: DogamCategory.plant,
              collected: false,
            ),
          ),
          repository,
        ),
      );
      await tester.pumpAndSettle();

      // [Finding 3] 히어로도 물음표를 보여준다 — 카테고리 아이콘이 아니다.
      // 히어로(사진 영역) + 본문(_UncollectedBody) 두 곳에서 '?'가 나온다.
      expect(find.text('?'), findsNWidgets(2));
      expect(find.byIcon(DogamCategory.plant.icon), findsNothing);
      expect(find.text('아직이에요'), findsOneWidget);
    },
  );

  testWidgets('loads_detail_and_shows_collected_date_when_collected', (
    tester,
  ) async {
    _useDesignViewport(tester);
    final repository = _FakeCatalogRepository(
      detail: const CatalogItemDetailEntity(
        id: 'a1',
        name: '수달',
        category: DogamCategory.animal,
        feature: '물가에서 헤엄치는 재주꾼',
        childDescription: '물속에서 눈을 뜨고 헤엄칠 수 있어요.',
        collectedAt: '2026.07.05',
      ),
    );

    await tester.pumpWidget(
      _wrap(
        const CollectionDetailPage(
          itemId: 'a1',
          item: CatalogItemEntity(
            id: 'a1',
            category: DogamCategory.animal,
            collected: true,
            name: '수달',
          ),
        ),
        repository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('수달'), findsOneWidget);
    expect(find.text('물가에서 헤엄치는 재주꾼'), findsOneWidget);
    expect(find.text('2026.07.05에 만났어요'), findsOneWidget);
    // [Finding 3] 수집했지만 사진이 없으면 히어로는 물음표가 아니라
    // 카테고리 아이콘을 보여준다 — 미수집과 같은 화면이 되면 안 된다.
    expect(find.text('?'), findsNothing);
    expect(find.byIcon(DogamCategory.animal.icon), findsOneWidget);
  });
}
