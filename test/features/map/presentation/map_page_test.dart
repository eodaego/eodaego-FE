import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/map/presentation/pages/map_page.dart';
import 'package:eodaego/features/map/presentation/widgets/map_marker.dart';
import 'package:eodaego/features/map/presentation/widgets/park_schematic_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows_both_map_modes_and_only_mapped_schematic_places', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(selectedCourseProvider.notifier).state = const CourseEntity(
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
}
