import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/widgets/course_card.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// 코스 결과 화면과 같은 폭 — 393pt 화면에 좌우 여백 20.
Widget _wrap(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (context, _) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    ),
  ),
);

CourseEntity _course({
  required String tag,
  required int minutes,
  required ParkGate exit,
}) => CourseEntity(
  id: 'c1',
  title: '힐링과 휴식을 위한 식물 및 습지 산책 코스',
  tagLabels: [tag],
  estimatedDurationMinutes: minutes,
  entrance: ParkGate.mainGate,
  exit: exit,
  favorite: false,
  places: const [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '환경연못',
      category: DogamCategory.plant,
    ),
  ],
);

void main() {
  group('CourseCard 뱃지 줄', () {
    testWidgets(
      'card_does_not_overflow_when_tag_duration_and_gates_exceed_one_line',
      (tester) async {
        tester.view.physicalSize = const Size(393, 852);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        // 실서버에서 넘친 조합 그대로 — 산책하기좋은 · 약 1시간 30분 · 정문 → 남문
        await tester.pumpWidget(
          _wrap(
            CourseCard(
              course: _course(
                tag: '산책하기좋은',
                minutes: 90,
                exit: ParkGate.southGate,
              ),
              saved: false,
              onToggleSaved: () {},
              onGo: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        // 뱃지가 잘려 사라지지 않고 하트도 남는다.
        expect(find.text('산책하기좋은'), findsOneWidget);
        expect(find.text('약 1시간 30분'), findsOneWidget);
        expect(find.text('정문 → 남문'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      },
    );
  });
}
