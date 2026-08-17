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

/// 마커 카드가 갈라지는 세 얼굴 — 판정 근거는 코스 응답의 두 필드뿐이다.
///
/// | `collected` | `catalogItemId` | 카드 |
/// | --- | --- | --- |
/// | true | 있음 | 이미 수집함 — 도감 상세로 보낸다 |
/// | false | 있음 | 아직 못 모음 — 촬영 CTA |
/// | false | null | 도감에 없는 시설 — CTA 없음 |

/// HTTP 경계를 대신하는 페이크.
///
/// [detail]이 null이면 상세 조회가 던진다. 수집하지 않은 장소의 상세를 부르면
/// 실제 서버가 403으로 막으므로, "부르지 않는다"를 호출 횟수 대신 화면이
/// 멀쩡한지로 지킨다.
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
    testWidgets('sends_the_visitor_to_the_catalog_when_the_place_is_collected', (
      tester,
    ) async {
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
    });

    testWidgets('invites_a_photo_when_the_place_is_in_the_catalog_but_unmet', (
      tester,
    ) async {
      // 상세를 부르면 페이크가 던진다 — 화면이 멀쩡하다는 것이 곧 부르지 않았다는 뜻이다.
      await _pumpCard(
        tester,
        const CoursePlaceEntity(
          visitOrder: 2,
          name: '맹수마을',
          category: DogamCategory.animal,
          catalogItemId: 'd4d20450',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('아직 못 만났어요'), findsOneWidget);
      expect(find.text('찍으면 도감에 등록돼요'), findsOneWidget);
      expect(find.text('여기서 찍기'), findsOneWidget);
      expect(find.text('도감에서 보기'), findsNothing);
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
