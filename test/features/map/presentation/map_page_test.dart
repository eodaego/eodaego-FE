import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_detail_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/course/domain/repositories/course_repository.dart';
import 'package:eodaego/features/course/presentation/providers/course_provider.dart';
import 'package:eodaego/features/map/data/datasources/facility_remote_datasource.dart';
import 'package:eodaego/features/map/data/models/facility_model.dart';
import 'package:eodaego/features/map/domain/entities/facility_entity.dart';
import 'package:eodaego/features/map/presentation/map_facility_layer.dart';
import 'package:eodaego/features/map/presentation/park_map_data.dart';
import 'package:eodaego/features/map/presentation/providers/facility_provider.dart';
import 'package:eodaego/features/map/presentation/widgets/facility_marker.dart';
import 'package:eodaego/features/map/presentation/pages/map_page.dart';
import 'package:eodaego/features/map/presentation/widgets/course_sheet.dart';
import 'package:eodaego/features/map/presentation/widgets/map_marker.dart';
import 'package:eodaego/features/map/presentation/widgets/park_schematic_map.dart';
import 'package:eodaego/features/map/presentation/widgets/place_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const _course = CourseEntity(
  id: 'course-1',
  title: '공원 한 바퀴',
  tagLabels: [],
  estimatedDurationMinutes: 60,
  entrance: ParkGate.mainGate,
  exit: ParkGate.southGate,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '꿈마루',
      category: DogamCategory.place,
      latitude: 37.549257,
      longitude: 127.079294,
    ),
    CoursePlaceEntity(
      visitOrder: 2,
      name: '어린이 숲 체험장',
      category: DogamCategory.place,
      latitude: 37.547578,
      longitude: 127.083423,
    ),
  ],
);

/// 약도에 좌표가 있는 장소만 마커로 그려진다. 마커 사이 이동을 보려면 둘 다
/// 약도에 있어야 한다.
const _twoMarkerCourse = CourseEntity(
  id: 'course-2',
  title: '두 곳',
  tagLabels: [],
  estimatedDurationMinutes: 60,
  entrance: ParkGate.mainGate,
  exit: ParkGate.southGate,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '꿈마루',
      category: DogamCategory.place,
    ),
    CoursePlaceEntity(
      visitOrder: 2,
      name: '식물원',
      category: DogamCategory.plant,
    ),
  ],
);

/// 시트를 펼쳐도 목록이 남아 스크롤될 만큼 긴 코스.
final _longCourse = CourseEntity(
  id: 'course-3',
  title: '오래 걷는 길',
  tagLabels: const [],
  estimatedDurationMinutes: 180,
  entrance: ParkGate.mainGate,
  exit: ParkGate.southGate,
  favorite: false,
  places: [
    for (var i = 1; i <= 20; i++)
      CoursePlaceEntity(
        visitOrder: i,
        name: '장소$i',
        category: DogamCategory.place,
      ),
  ],
);

/// 코스에 도감 연결이 걸린 장소가 있는 코스 — 앱 안에서 도감을 모으면 뒤집힌다.
const _linkedCatalogItemId = 'f077dafb';

const _linkedCourse = CourseEntity(
  id: 'course-4',
  title: '도감이 걸린 길',
  tagLabels: [],
  estimatedDurationMinutes: 60,
  entrance: ParkGate.mainGate,
  exit: ParkGate.southGate,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '꿈마루',
      category: DogamCategory.place,
      catalogItemId: _linkedCatalogItemId,
    ),
  ],
);

/// 코스 상세 호출만 기록하는 페이크 리포지토리. 받은 id를 그대로 코스로 돌려준다.
class _FakeCourseRepository implements CourseRepository {
  _FakeCourseRepository([this.extra = const {}]);

  /// 기본 코스 목록에 없는 코스(테스트 안에서 만든 것).
  final Map<String, CourseEntity> extra;
  final requestedIds = <String>[];

  @override
  Future<CourseEntity> getCourse(String courseId) async {
    requestedIds.add(courseId);
    return extra[courseId] ?? _courses[courseId]!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

final _courses = {
  for (final c in [_course, _twoMarkerCourse, _longCourse, _linkedCourse])
    c.id: c,
};

/// 서버 시설 목록. 약도 좌표가 있는 것 둘, 약도 좌표가 null인 것, 약도에 없는 것,
/// 출입문(제외 대상) 하나씩.
const _facilities = [
  FacilityEntity(id: 101, name: '고객안내센터', category: '편의시설'),
  FacilityEntity(id: 102, name: '맹수마을', category: '동물'),
  FacilityEntity(id: 103, name: '어린이 숲 체험장', category: '체험'),
  FacilityEntity(id: 104, name: '약도에 없는 곳', category: '기타'),
];

/// 약도에 시설 점으로 그려져야 하는 시설 수 — 픽스처와 약도 데이터에서 계산한다.
int get _schematicFacilityCount => _facilities
    .where((f) => parkFacilitySchematicPositions[f.name] != null)
    .length;

Future<ProviderContainer> _pumpMap(
  WidgetTester tester, {
  CourseEntity? course = _course,
  List<Override> overrides = const [],
  List<FacilityEntity> facilities = const [],
  _FakeCourseRepository? courseRepository,
}) async {
  final container = ProviderContainer(
    overrides: [
      courseRepositoryProvider.overrideWithValue(
        courseRepository ?? _FakeCourseRepository(),
      ),
      mapFacilitiesProvider.overrideWith((ref) async => facilities),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  container.read(selectedCourseProvider.notifier).state = course;

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        child: const MaterialApp(home: MapPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// 약도 안에서 마커도 카드도 없는 자리 — 좌하단 구석.
Offset _emptySpotOnMap(WidgetTester tester) {
  final map = tester.getRect(find.byType(ParkSchematicMap));
  return Offset(map.left + 12, map.bottom - 12);
}

/// 약도 마커를 방문 순서로 찾는다.
///
/// **주의**: 위치로 찾으면 안 된다 — 약도는 선택한 마커를 겹친 무리 위로 올리려고
/// 목록 끝으로 옮기므로, 하나를 누르고 나면 `.last`가 방금 누른 그 마커다.
Finder _marker(int visitOrder) => find.descendant(
  of: find.byType(ParkSchematicMap),
  matching: find.byWidgetPredicate(
    (w) => w is MapMarker && w.number == visitOrder,
  ),
);

/// 약도에 그려진 시설 점.
Finder _facilityMarkers() => find.descendant(
  of: find.byType(ParkSchematicMap),
  matching: find.byType(FacilityMarker),
);

class _FakeFacilityDataSource implements FacilityRemoteDataSource {
  var calls = 0;

  @override
  Future<List<FacilityModel>> getFacilities() async {
    calls++;
    return const [FacilityModel(id: 101, name: '고객안내센터', category: '편의시설')];
  }

  @override
  Future<FacilityDetailModel> getFacility(int facilityId) =>
      throw UnimplementedError();
}

void main() {
  testWidgets('shows_both_map_modes_and_only_mapped_schematic_places', (
    tester,
  ) async {
    await _pumpMap(tester);

    expect(find.text('실제 지도'), findsOneWidget);
    expect(find.text('공원 약도'), findsOneWidget);
    expect(find.byType(ParkSchematicMap), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ParkSchematicMap),
        matching: find.byType(MapMarker),
      ),
      findsOneWidget,
    );
  });

  group('장소 카드 닫기', () {
    // 닫기 X를 없애고 카드 바깥을 누르면 닫히게 했다. 지도는 계속 만질 수 있어야
    // 하므로 바깥 탭은 지도로 그대로 흘려보낸다 — 다른 마커를 바로 누를 수 있다.
    testWidgets('closes_when_the_map_around_the_card_is_tapped', (
      tester,
    ) async {
      await _pumpMap(tester);

      await tester.tap(_marker(1));
      await tester.pumpAndSettle();
      expect(find.byType(PlaceInfoCard), findsOneWidget);

      await tester.tapAt(_emptySpotOnMap(tester));
      await tester.pumpAndSettle();

      expect(find.byType(PlaceInfoCard), findsNothing);
    });

    testWidgets('stays_open_when_the_card_itself_is_tapped', (tester) async {
      await _pumpMap(tester);

      await tester.tap(_marker(1));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(PlaceInfoCard),
          matching: find.text('꿈마루'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlaceInfoCard), findsOneWidget);
    });

    testWidgets('switches_straight_to_another_marker_in_one_tap', (
      tester,
    ) async {
      // 바깥 탭을 지도로 흘려보내는 이유가 이것이다. 탭을 삼키는 배리어였다면
      // 한 번은 닫는 데 쓰고 다시 눌러야 다른 장소가 열린다.
      await _pumpMap(tester, course: _twoMarkerCourse);

      await tester.tap(_marker(1));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(PlaceInfoCard),
          matching: find.text('꿈마루'),
        ),
        findsOneWidget,
      );

      await tester.tap(_marker(2));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(PlaceInfoCard),
          matching: find.text('식물원'),
        ),
        findsOneWidget,
      );
    });
  });

  group('열려 있는 장소 카드', () {
    testWidgets('follows_the_course_when_the_place_gets_collected', (
      tester,
    ) async {
      // 퀴즈로 도감을 모으면 코스의 수집 여부가 갱신된다. 그때 카드를 열어둔
      // 채였다면 마커에는 체크가 붙고 카드만 '아직'을 그리는 일이 없어야 한다.
      final container = await _pumpMap(
        tester,
        course: _linkedCourse,
        overrides: [
          catalogItemDetailProvider(_linkedCatalogItemId).overrideWith(
            (ref) async => const CatalogItemDetailEntity(
              id: _linkedCatalogItemId,
              name: '꿈마루',
              category: DogamCategory.place,
              feature: '',
              childDescription: '',
              code: 'L001',
            ),
          ),
        ],
      );

      await tester.tap(_marker(1));
      await tester.pumpAndSettle();
      expect(find.text('아직 못 만났어요'), findsOneWidget);

      container
          .read(selectedCourseProvider.notifier)
          .update((course) => course?.markCollected(_linkedCatalogItemId));
      await tester.pumpAndSettle();

      // 카드와 마커가 같은 얼굴이어야 한다 — 한 화면에서 서로 반대를 그리면
      // 아이는 모은 곳을 또 찍으러 간다.
      expect(find.text('✓ 도감에 있어요'), findsOneWidget);
      expect(find.text('아직 못 만났어요'), findsNothing);
      expect(tester.widget<MapMarker>(_marker(1)).checkColor, isNotNull);
    });

    testWidgets('disappears_when_another_course_takes_over_the_map', (
      tester,
    ) async {
      // 코스를 갈아타면 지도가 마커를 새로 그린다. 이전 코스에서 열어둔 카드가
      // 그 위에 남아 있으면 지금 코스에 없는 장소를 안내하게 된다.
      final container = await _pumpMap(tester);

      await tester.tap(_marker(1));
      await tester.pumpAndSettle();
      expect(find.byType(PlaceInfoCard), findsOneWidget);

      container.read(selectedCourseProvider.notifier).state = _longCourse;
      await tester.pumpAndSettle();

      expect(find.byType(PlaceInfoCard), findsNothing);
    });
  });

  testWidgets('keeps_the_sheet_handle_in_place_while_the_list_scrolls', (
    tester,
  ) async {
    // 핸들은 시트를 끄는 손잡이다. 목록과 같이 밀려 올라가면 손잡이가 사라진다.
    await _pumpMap(tester, course: _longCourse);

    final handle = find.byKey(CourseSheet.handleKey);
    final sheet = find.byType(CustomScrollView);

    // 손잡이를 끌어 펼친다 — 고정하려다 드래그를 잃어버리기 쉬운 자리다.
    final collapsedHeight = tester.getSize(sheet).height;
    await tester.drag(handle, const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(tester.getSize(sheet).height, greaterThan(collapsedHeight));

    final handleBefore = tester.getRect(handle);
    final firstRowBefore = tester.getTopLeft(find.text('장소1')).dy;

    await tester.drag(sheet, const Offset(0, -60));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('장소1')).dy, lessThan(firstRowBefore));
    expect(tester.getRect(handle), handleBefore);
  });

  group('시설 마커', () {
    testWidgets('map_page_shows_facility_markers_without_course', (
      tester,
    ) async {
      await _pumpMap(tester, course: null, facilities: _facilities);

      expect(_schematicFacilityCount, greaterThan(0));
      expect(_facilityMarkers(), findsNWidgets(_schematicFacilityCount));
    });

    testWidgets('map_page_dims_facility_markers_when_course_selected', (
      tester,
    ) async {
      await _pumpMap(tester, facilities: _facilities);

      final dimmed = find.ancestor(
        of: _facilityMarkers(),
        matching: find.byWidgetPredicate(
          (w) => w is Opacity && w.opacity == dimmedFacilityOpacity,
        ),
      );
      expect(dimmed, findsNWidgets(_schematicFacilityCount));
    });

    testWidgets('map_page_shows_no_facility_markers_for_guest', (tester) async {
      final source = _FakeFacilityDataSource();
      // 실제 mapFacilities를 태워 게스트면 API를 부르지 않는지까지 본다.
      final container = ProviderContainer(
        overrides: [
          guestRestrictedProvider.overrideWithValue(true),
          facilityRemoteDataSourceProvider.overrideWithValue(source),
          courseRepositoryProvider.overrideWithValue(_FakeCourseRepository()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            child: const MaterialApp(home: MapPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_facilityMarkers(), findsNothing);
      expect(source.calls, 0);
    });

    testWidgets('map_page_hides_facility_that_is_already_a_course_place', (
      tester,
    ) async {
      const course = CourseEntity(
        id: 'course-1',
        title: '공원 한 바퀴',
        tagLabels: [],
        estimatedDurationMinutes: 60,
        entrance: ParkGate.mainGate,
        exit: ParkGate.southGate,
        favorite: false,
        places: [
          CoursePlaceEntity(
            visitOrder: 1,
            name: '맹수마을',
            category: DogamCategory.animal,
            facilityId: 102,
          ),
        ],
      );
      await _pumpMap(
        tester,
        course: course,
        facilities: _facilities,
        courseRepository: _FakeCourseRepository({course.id: course}),
      );

      expect(_facilityMarkers(), findsNWidgets(_schematicFacilityCount - 1));
    });
  });

  group('코스 동기화', () {
    testWidgets('map_page_syncs_course_when_selected_course_changes', (
      tester,
    ) async {
      final repository = _FakeCourseRepository();
      final container = await _pumpMap(tester, courseRepository: repository);

      // 지도에 들어올 때 이미 선택돼 있던 코스를 1회 맞춘다.
      expect(repository.requestedIds, [_course.id]);

      container.read(selectedCourseProvider.notifier).state = _longCourse;
      await tester.pumpAndSettle();

      expect(repository.requestedIds, [_course.id, _longCourse.id]);
    });
  });
}
