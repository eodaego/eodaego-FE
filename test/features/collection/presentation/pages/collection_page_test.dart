import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/core/widgets/app_badge.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/pages/collection_page.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this.items);

  final List<CatalogItemEntity> items;

  @override
  Future<List<CatalogItemEntity>> getCatalogItems() async => items;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// [Finding 1] 게스트는 토큰이 없다 — getCatalogItems()가 호출되면 던져서
/// "게스트는 목록을 요청하지 않는다"를 증명한다.
class _ThrowingCatalogRepository implements CatalogRepository {
  @override
  Future<List<CatalogItemEntity>> getCatalogItems() async {
    throw StateError('게스트는 도감 목록 API를 요청하면 안 된다');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// ANIMAL 수집 3(고양이/강아지/너구리) + PLANT 수집 1(장미) + ANIMAL 미수집 1(이름 없음).
/// 전체 4/5, ANIMAL 필터 3/4, PLANT 필터 1/1 — 필터별로 숫자가 겹치지 않게 구성한다.
List<CatalogItemEntity> _fixtureItems() => const [
  CatalogItemEntity(
    id: 'a1',
    category: DogamCategory.animal,
    collected: true,
    name: '고양이',
  ),
  CatalogItemEntity(
    id: 'a2',
    category: DogamCategory.animal,
    collected: true,
    name: '강아지',
  ),
  CatalogItemEntity(
    id: 'a3',
    category: DogamCategory.animal,
    collected: true,
    name: '너구리',
  ),
  CatalogItemEntity(
    id: 'p1',
    category: DogamCategory.plant,
    collected: true,
    name: '장미',
  ),
  CatalogItemEntity(id: 'u1', category: DogamCategory.animal, collected: false),
];

Widget _wrap(CatalogRepository repository) => ProviderScope(
  overrides: [catalogRepositoryProvider.overrideWith((ref) => repository)],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: CollectionPage()),
  ),
);

/// 테스트 기본 뷰(800x600)는 ScreenUtil 기준(393x852)과 달라 레이아웃이 왜곡된다.
/// 3열 그리드가 실제 기기 비율이 아니면 오버플로우가 난다.
void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Finder _badgeText(String label) =>
    find.descendant(of: find.byType(AppBadge), matching: find.text(label));

void main() {
  group('CollectionPage', () {
    testWidgets('카테고리를 선택하면 그리드가 걸러지고 뱃지 숫자도 함께 바뀐다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeCatalogRepository(_fixtureItems())));
      await tester.pumpAndSettle();

      expect(_badgeText('4/5'), findsOneWidget);
      expect(find.text('장미'), findsOneWidget);
      expect(find.text('고양이'), findsOneWidget);

      await tester.tap(find.text('식물'));
      await tester.pumpAndSettle();

      expect(_badgeText('1/1'), findsOneWidget);
      expect(find.text('장미'), findsOneWidget);
      expect(find.text('고양이'), findsNothing);
      expect(find.text('강아지'), findsNothing);
      expect(find.text('너구리'), findsNothing);
    });

    testWidgets('이름을 검색하면 그리드만 걸러지고 뱃지 숫자는 그대로다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeCatalogRepository(_fixtureItems())));
      await tester.pumpAndSettle();

      expect(_badgeText('4/5'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '고양');
      await tester.pumpAndSettle();

      expect(find.text('고양이'), findsOneWidget);
      expect(find.text('강아지'), findsNothing);
      expect(find.text('너구리'), findsNothing);
      expect(find.text('장미'), findsNothing);
      // 검색어는 그리드만 거르고, 뱃지는 카테고리 스코프만 반영해 그대로다.
      expect(_badgeText('4/5'), findsOneWidget);
    });

    testWidgets('이름이 없는 미수집 항목은 검색해도 죽지 않고 결과에서 빠진다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeCatalogRepository(_fixtureItems())));
      await tester.pumpAndSettle();

      expect(find.text('미수집'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '고양');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('미수집'), findsNothing);
      expect(find.text('고양이'), findsOneWidget);
    });

    testWidgets('게스트는 도감 목록을 요청하지 않고 빈 도감을 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            guestModeProvider.overrideWith((ref) => true),
            catalogRepositoryProvider.overrideWith(
              (ref) => _ThrowingCatalogRepository(),
            ),
          ],
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (context, _) => const MaterialApp(home: CollectionPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 위 override가 던지지 않았다는 것 자체가 "요청하지 않았다"는 증거다.
      expect(tester.takeException(), isNull);
      expect(_badgeText('0/0'), findsOneWidget);
      expect(find.text('공원에서 만나면 여기에 모아둘 수 있어요'), findsOneWidget);
    });

    testWidgets('검색어 없이 결과가 없으면(카테고리 필터) 검색 문구 대신 긍정형 안내를 보여준다', (
      tester,
    ) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeCatalogRepository(_fixtureItems())));
      await tester.pumpAndSettle();

      // 픽스처에는 PLACE 항목이 없다 — 필터링하면 그리드가 빈다.
      await tester.tap(find.text('장소'));
      await tester.pumpAndSettle();

      expect(_badgeText('0/0'), findsOneWidget);
      expect(find.text('공원에서 만나면 여기에 모아둘 수 있어요'), findsOneWidget);
      expect(find.text('찾는 이름이 없어요. 다른 이름으로 찾아보세요'), findsNothing);
    });

    testWidgets('검색 결과가 없으면 검색 관련 문구를 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeCatalogRepository(_fixtureItems())));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '없는이름');
      await tester.pumpAndSettle();

      expect(find.text('찾는 이름이 없어요. 다른 이름으로 찾아보세요'), findsOneWidget);
    });
  });
}
