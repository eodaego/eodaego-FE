import 'dart:math' as math;

import 'package:eodaego/features/course/presentation/widgets/course_loading_cat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

Widget _wrap(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (context, _) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

/// 지금 고양이가 실제로 그려지고 있는 배율 (목표값이 아니라 진행 중인 값).
double _scale(WidgetTester tester) => tester
    .renderObject(find.byType(LottieBuilder))
    .getTransformTo(tester.renderObject(find.byType(CourseLoadingCat)))
    .getMaxScaleOnAxis();

/// 좌우로 기운 정도 — 회전이 없으면 0이다.
double _tilt(WidgetTester tester) => tester
    .renderObject(find.byType(LottieBuilder))
    .getTransformTo(tester.renderObject(find.byType(CourseLoadingCat)))
    .storage[1];

/// 흔들림은 왕복이라 한 순간만 재면 0을 지나칠 수 있다.
/// 짧게 여러 번 재서 가장 크게 기운 값을 돌려준다.
Future<double> _maxTiltOverTime(WidgetTester tester) async {
  var maxAbs = 0.0;
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 40));
    maxAbs = math.max(maxAbs, _tilt(tester).abs());
  }
  return maxAbs;
}

void main() {
  group('CourseLoadingCat', () {
    // 기본 테스트 화면(800x600)에는 360.w 고양이가 들어가지 않는다.
    setUp(() {
      final view = TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first;
      view.physicalSize = const Size(786, 1704);
      view.devicePixelRatio = 2;
      addTearDown(view.reset);
    });

    testWidgets('누르고 있는 동안 일정한 속도로 커진다', (tester) async {
      await tester.pumpWidget(_wrap(const CourseLoadingCat()));
      await tester.pump();

      expect(_scale(tester), 1.0);

      final gesture = await tester.press(find.byType(LottieBuilder));
      await tester.pump();
      // 누른 직후에는 아직 커지지 않았다 (확 튀지 않는다)
      expect(_scale(tester), closeTo(1.0, 0.01));

      await tester.pump(const Duration(milliseconds: 1500));
      expect(_scale(tester), closeTo(2.5, 0.1)); // 3초 중 절반 지점

      await tester.pump(const Duration(milliseconds: 1500));
      // 한계에서는 파르르 떨리느라 ±3% 안에서 움직인다
      expect(_scale(tester), closeTo(4.0, 0.15));

      await gesture.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      expect(_scale(tester), closeTo(1.0, 0.05));
    });

    testWidgets('한계에 가까워져야 흔들리기 시작한다', (tester) async {
      await tester.pumpWidget(_wrap(const CourseLoadingCat()));
      await tester.pump(const Duration(milliseconds: 500));

      // 가만히 있을 때는 기울지 않는다
      expect(_tilt(tester), closeTo(0.0, 0.001));

      await tester.press(find.byType(LottieBuilder));
      await tester.pump();

      // 절반쯤 부풀었을 때는 아직 거의 흔들리지 않는다
      await tester.pump(const Duration(milliseconds: 1500));
      expect(_tilt(tester).abs(), lessThan(0.01));

      // 한계에 다다르면 눈에 띄게 흔들린다
      await tester.pump(const Duration(milliseconds: 1340));
      expect(await _maxTiltOverTime(tester), greaterThan(0.05));
    });

    testWidgets('놓으면 통통 튀며 돌아오고, 흔들림이 크기보다 오래 남는다', (tester) async {
      await tester.pumpWidget(_wrap(const CourseLoadingCat()));
      await tester.pump();

      final gesture = await tester.press(find.byType(LottieBuilder));
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await gesture.up();
      await tester.pump();

      // 돌아오는 길 중간에는 아직 크다 (한 번에 줄지 않고 튄다)
      await tester.pump(const Duration(milliseconds: 300));
      expect(_scale(tester), greaterThan(1.2));

      // 크기는 돌아왔지만 아직 흔들리고 있다
      await tester.pump(const Duration(milliseconds: 350));
      expect(_scale(tester), closeTo(1.0, 0.05));
      expect(await _maxTiltOverTime(tester), greaterThan(0.01));

      // 여운도 곧 잦아든다
      await tester.pump(const Duration(milliseconds: 500));
      expect(_tilt(tester), closeTo(0.0, 0.001));
      expect(_scale(tester), closeTo(1.0, 0.01));
    });

    testWidgets('탭이 취소돼도 원래 크기로 돌아온다', (tester) async {
      await tester.pumpWidget(_wrap(const CourseLoadingCat()));
      await tester.pump();

      final gesture = await tester.press(find.byType(LottieBuilder));
      await tester.pump(const Duration(milliseconds: 1500));
      await gesture.cancel();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(_scale(tester), closeTo(1.0, 0.01));
      expect(_tilt(tester), closeTo(0.0, 0.001));
    });
  });
}
