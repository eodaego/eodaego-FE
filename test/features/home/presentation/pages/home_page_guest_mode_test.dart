import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// [Finding 1] 게스트는 토큰이 없다 — catalogSummaryProvider를 실제로 watch하면
/// 이 override가 던져 테스트가 실패한다. 값을 주는 대신 던지게 해서 "게스트는
/// 요약을 요청하지 않는다"를 검증한다.
Widget _wrapGuest() => ProviderScope(
  overrides: [
    guestModeProvider.overrideWith((ref) => true),
    catalogSummaryProvider.overrideWith(
      (ref) => throw StateError('게스트는 요약 API를 요청하면 안 된다'),
    ),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: HomePage()),
  ),
);

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('HomePage 게스트 모드', () {
    testWidgets('도감 요약을 요청하지 않고 진행률 카드를 0으로 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrapGuest());
      await tester.pumpAndSettle();

      // 위 override가 던지지 않았다는 것 자체가 "요청하지 않았다"는 증거다.
      expect(tester.takeException(), isNull);
      expect(find.text('내 도감'), findsOneWidget);
      // 시안 개편(#22) — 도감 수집률 카드 표기가 `9/24`에서 `9 / 24`(공백)로 바뀌었다.
      expect(find.text('0 / 0'), findsOneWidget);
    });
  });
}
