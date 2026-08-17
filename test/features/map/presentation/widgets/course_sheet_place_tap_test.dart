import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/map/presentation/widgets/course_sheet.dart';
import 'package:eodaego/features/map/presentation/widgets/map_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// 시트 목록 ↔ 지도 마커 연결.
///
/// 실제 지도에서는 시설이 붙어 있어 마커가 서로 겹친다. 가려진 장소는 이 목록이
/// 유일한 입구라, 배선이 끊기면 그 장소는 열 방법이 없어진다.

const _hidden = CoursePlaceEntity(
  visitOrder: 2,
  name: '물새장',
  category: DogamCategory.animal,
);

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
      name: '꼬마동물마을',
      category: DogamCategory.animal,
      catalogItemId: 'catalog-1',
      collected: true,
    ),
    _hidden,
  ],
);

Future<void> _pumpSheet(
  WidgetTester tester, {
  ValueChanged<CoursePlaceEntity>? onPlaceTap,
  String? selectedPlaceName,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      // 원본은 dotenv(EnvConfig)를 타서 위젯 테스트에서 던진다.
      guestRestrictedProvider.overrideWithValue(false),
    ],
  );
  addTearDown(container.dispose);
  container.read(selectedCourseProvider.notifier).state = _course;

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: CourseSheet(
              onPlaceTap: onPlaceTap,
              selectedPlaceName: selectedPlaceName,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('시트 장소 목록', () {
    testWidgets('장소를 누르면 그 장소가 선택으로 전달된다', (tester) async {
      CoursePlaceEntity? tapped;
      await _pumpSheet(tester, onPlaceTap: (place) => tapped = place);

      await tester.tap(find.text('꼬마동물마을'));
      await tester.pumpAndSettle();

      expect(tapped?.name, '꼬마동물마을');
    });

    testWidgets('선택된 장소의 마커만 카테고리 dark로 바뀐다', (tester) async {
      await _pumpSheet(tester, selectedPlaceName: _hidden.name);

      final markers = tester
          .widgetList<MapMarker>(find.byType(MapMarker))
          .toList();

      final selected = markers.firstWhere(
        (m) => m.number == _hidden.visitOrder,
      );
      final other = markers.firstWhere((m) => m.number == 1);

      expect(selected.color, DogamCategory.animal.dark);
      expect(other.color, DogamCategory.animal.color);
    });

    testWidgets('이미 모은 장소에만 체크가 붙는다', (tester) async {
      // 카테고리색은 건드리지 않는다 — 색은 계속 카테고리를 뜻하고, 체크만
      // "이미 만났다"를 얹는다.
      await _pumpSheet(tester);

      final markers = tester.widgetList<MapMarker>(find.byType(MapMarker));
      final byNumber = {for (final m in markers) m.number: m};

      expect(byNumber[1]?.checkColor, DogamCategory.animal.dark);
      expect(byNumber[1]?.color, DogamCategory.animal.color);
      expect(byNumber[2]?.checkColor, isNull);
    });

    testWidgets('목록 번호는 지도 마커와 같은 방문 순서를 쓴다', (tester) async {
      // 목록 인덱스로 번호를 매기면 서버가 순서를 건너뛴 순간 지도와 어긋난다.
      await _pumpSheet(tester);

      final numbers = tester
          .widgetList<MapMarker>(find.byType(MapMarker))
          .map((m) => m.number)
          .toList();

      expect(numbers, _course.places.map((p) => p.visitOrder).toList());
    });
  });
}
