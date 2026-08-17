import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
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

Future<void> _pumpMap(
  WidgetTester tester, {
  CourseEntity course = _course,
}) async {
  final container = ProviderContainer();
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
}
