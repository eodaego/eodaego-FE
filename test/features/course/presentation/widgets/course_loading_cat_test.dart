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

double _scale(WidgetTester tester) =>
    tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

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

    testWidgets('누르는 동안 커졌다가 놓으면 원래 크기로 돌아온다', (tester) async {
      await tester.pumpWidget(_wrap(const CourseLoadingCat()));
      await tester.pump();

      expect(_scale(tester), 1.0);

      final gesture = await tester.press(find.byType(LottieBuilder));
      await tester.pump();
      expect(_scale(tester), 1.1);

      await gesture.up();
      await tester.pump();
      expect(_scale(tester), 1.0);
    });

    testWidgets('탭이 취소돼도 원래 크기로 돌아온다', (tester) async {
      await tester.pumpWidget(_wrap(const CourseLoadingCat()));
      await tester.pump();

      final gesture = await tester.press(find.byType(LottieBuilder));
      await tester.pump();
      await gesture.cancel();
      await tester.pump();

      expect(_scale(tester), 1.0);
    });
  });
}
