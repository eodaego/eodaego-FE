import 'package:eodaego/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (context, _) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('AppButton', () {
    testWidgets('텍스트를 렌더링하고 탭 시 onPressed를 호출한다', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        _wrap(AppButton(text: '시작하기', onPressed: () => tapped++)),
      );
      await tester.pumpAndSettle();

      expect(find.text('시작하기'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, 1);
    });

    testWidgets('onPressed가 null이면 비활성(탭 불가)', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppButton(text: '비활성', onPressed: null)),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('isLoading이면 스피너 표시 + 텍스트 숨김 + 비활성', (tester) async {
      await tester.pumpWidget(
        _wrap(AppButton(text: '로딩', onPressed: () {}, isLoading: true)),
      );
      await tester.pump(); // 무한 스피너 애니라 pumpAndSettle 대신 pump

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('로딩'), findsNothing);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
