import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_detail_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/map/presentation/widgets/place_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 마커 카드가 갈라지는 세 얼굴 — 판정 근거는 코스 응답의 두 필드뿐이다.
///
/// | `collected` | `catalogItemId` | 카드 |
/// | --- | --- | --- |
/// | true | 있음 | 이미 수집함 — 도감 상세로 보낸다 |
/// | false | 있음 | 아직 못 모음 — 촬영 CTA |
/// | false | null | 도감에 없는 시설 — CTA 없음 |

/// HTTP 경계를 대신하는 페이크.
///
/// [detailCalls]로 왕복 횟수를 센다. 화면만 보고는 "부르지 않았다"를 지킬 수
/// 없다 — FutureProvider가 예외를 AsyncError로 삼켜서 `valueOrNull`이 null이
/// 되고, 미수집 카드는 부르든 안 부르든 똑같이 그려지기 때문이다. 실제 서버는
/// 미수집 항목의 상세를 403으로 막으므로 이 횟수가 곧 지켜야 할 계약이다.
class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository({this.detail});

  final CatalogItemDetailEntity? detail;

  /// 상세 조회가 실제로 나간 횟수 — 경계에서 관찰한 값이다.
  int detailCalls = 0;

  @override
  Future<List<CatalogItemEntity>> getCatalogItems({
    DogamCategory? category,
    String? name,
  }) async => const [];

  @override
  Future<CatalogItemDetailEntity> getCatalogItem(String id) async {
    detailCalls++;
    final loaded = detail;
    if (loaded == null) {
      throw StateError('수집하지 않은 장소의 상세를 호출하면 안 된다 (서버가 403으로 막는다)');
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

Future<void> _pumpCard(
  WidgetTester tester,
  CoursePlaceEntity place, {
  _FakeCatalogRepository? repository,
}) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        catalogRepositoryProvider.overrideWith(
          (ref) => repository ?? _FakeCatalogRepository(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: PlaceInfoCard(place: place, onClose: () {}),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('지도 장소 카드', () {
    testWidgets(
      'sends_the_visitor_to_the_catalog_when_the_place_is_collected',
      (tester) async {
        await _pumpCard(
          tester,
          const CoursePlaceEntity(
            visitOrder: 1,
            name: '음악분수',
            category: DogamCategory.place,
            catalogItemId: 'f077dafb',
            collected: true,
          ),
          repository: _FakeCatalogRepository(
            detail: const CatalogItemDetailEntity(
              id: 'f077dafb',
              name: '음악분수',
              category: DogamCategory.place,
              feature: '',
              childDescription: '',
              code: 'L001',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('✓ 도감에 있어요'), findsOneWidget);
        expect(find.text('도감 L001'), findsOneWidget);
        expect(find.text('도감에서 보기'), findsOneWidget);
        expect(find.text('여기서 찍기'), findsNothing);
      },
    );

    testWidgets('invites_a_photo_when_the_place_is_in_the_catalog_but_unmet', (
      tester,
    ) async {
      final repository = _FakeCatalogRepository();
      await _pumpCard(
        tester,
        const CoursePlaceEntity(
          visitOrder: 2,
          name: '맹수마을',
          category: DogamCategory.animal,
          catalogItemId: 'd4d20450',
        ),
        repository: repository,
      );
      await tester.pumpAndSettle();

      expect(find.text('아직 못 만났어요'), findsOneWidget);
      expect(find.text('찍으면 도감에 등록돼요'), findsOneWidget);
      expect(find.text('여기서 찍기'), findsOneWidget);
      expect(find.text('도감에서 보기'), findsNothing);
      // 서버가 403으로 막는 자리다. 화면 문구만으로는 이 계약이 안 지켜진다.
      expect(repository.detailCalls, 0);
    });

    testWidgets('offers_no_call_to_action_for_a_place_outside_the_catalog', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        const CoursePlaceEntity(
          visitOrder: 3,
          name: '바다동물관',
          category: DogamCategory.animal,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('구경하고 가는 곳이에요'), findsOneWidget);
      expect(find.text('여기서 찍기'), findsNothing);
      expect(find.text('도감에서 보기'), findsNothing);
    });

    testWidgets('leaves_a_way_back_when_sending_the_visitor_to_the_camera', (
      tester,
    ) async {
      // 촬영 화면(`/scan`)은 탭 셸 밖 루트 라우트이고 닫기 버튼이 pop이다.
      // 여기서 go로 보내면 스택이 갈려 닫기가 'nothing to pop'으로 터진다.
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(
              body: PlaceInfoCard(
                place: const CoursePlaceEntity(
                  visitOrder: 2,
                  name: '맹수마을',
                  category: DogamCategory.animal,
                  catalogItemId: 'd4d20450',
                ),
                onClose: () {},
              ),
            ),
          ),
          GoRoute(
            path: '/scan',
            builder: (_, _) => const Scaffold(body: Text('촬영 화면')),
          ),
        ],
      );
      addTearDown(router.dispose);

      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWith(
              (ref) => _FakeCatalogRepository(),
            ),
          ],
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (context, _) => MaterialApp.router(routerConfig: router),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('여기서 찍기'));
      await tester.pumpAndSettle();

      expect(find.text('촬영 화면'), findsOneWidget);
      expect(
        router.routerDelegate.canPop(),
        isTrue,
        reason: '촬영 화면에서 닫기를 누르면 지도로 돌아올 수 있어야 한다',
      );
    });

    testWidgets('draws_the_uncollected_face_without_waiting_for_a_response', (
      tester,
    ) async {
      // 도감 조회가 사라진 자리 — 첫 프레임에 카드가 완성돼야 한다.
      await _pumpCard(
        tester,
        const CoursePlaceEntity(
          visitOrder: 2,
          name: '맹수마을',
          category: DogamCategory.animal,
          catalogItemId: 'd4d20450',
        ),
      );

      expect(find.text('여기서 찍기'), findsOneWidget);
    });
  });
}
