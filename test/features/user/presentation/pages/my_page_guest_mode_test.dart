import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/user/presentation/pages/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

// 게스트는 닉네임 변경도, 약관 조회도, 탈퇴도 할 수 없는 계정이 없는 상태다.
// isGuest가 false로 짧은 회로되는 authNotifierProvider는 게스트 경로에서
// 아예 watch되지 않으므로 별도 override가 필요 없다.
//
// [Finding 1] 게스트는 토큰이 없다 — catalogSummaryProvider를 실제로 watch하면
// 이 override가 던져 테스트가 실패한다. 값을 주는 대신 던지게 해서 "게스트는
// 요약을 요청하지 않는다"를 검증한다.
Widget _wrapGuest() => ProviderScope(
  overrides: [
    guestModeProvider.overrideWith((ref) => true),
    catalogSummaryProvider.overrideWith(
      (ref) => throw StateError('게스트는 요약 API를 요청하면 안 된다'),
    ),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: MyPage()),
  ),
);

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('MyPage 게스트 모드', () {
    testWidgets('닉네임 바꾸기, 약관 및 정책, 탈퇴하기를 숨기고 로그인하러 가기만 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrapGuest());
      await tester.pumpAndSettle();

      expect(find.text('닉네임 바꾸기'), findsNothing);
      expect(find.text('약관 및 정책'), findsNothing);
      expect(find.text('탈퇴하기'), findsNothing);
      expect(find.text('로그인하러 가기'), findsOneWidget);
    });

    testWidgets('도감 요약을 요청하지 않고 수집 통계를 0으로 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrapGuest());
      await tester.pumpAndSettle();

      // 위 override가 던지지 않았다는 것 자체가 "요청하지 않았다"는 증거다.
      expect(tester.takeException(), isNull);
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });
  });
}
