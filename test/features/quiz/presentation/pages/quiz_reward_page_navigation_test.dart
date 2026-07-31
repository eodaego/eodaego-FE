import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/quiz/presentation/pages/quiz_reward_page.dart';
import 'package:eodaego/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 실 `GoRouter`로 두 번 연달아 진입해도 두 번째 진입이 로딩 상태에 멈추지
/// 않는지를 검증한다.
///
/// 이 테스트가 별도 파일인 이유: `quiz_reward_page_test.dart`는
/// `quizQuestionsProvider`를 픽스처로 override해 실 에셋 I/O를 피하지만,
/// 그 우회가 "테스트 하네스가 위젯 엘리먼트를 재사용해서 생긴 문제"인지
/// "프로덕션에서도 재현되는 실제 버그"인지는 증명하지 못한다. 여기서는
/// `quizQuestionsProvider`를 override하지 않고, 실 `GoRouter.push`로
/// 매번 새 라우트(= 새 엘리먼트 트리)를 만들어 실제 앱 내비게이션과 같은
/// 조건에서 재확인한다. `pumpAndSettle()`은 쓰지 않는다 — 로딩 중
/// `AppSkeleton`(Shimmer)이 반복 애니메이션을 돌아 절대 정착하지 않는다.
void main() {
  testWidgets('실 GoRouter로 축하 화면에 두 번 진입해도 두 번째 진입이 로딩에 멈추지 않는다', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: RoutePaths.quizReward,
          builder: (context, state) => const QuizRewardPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        // 게스트로 두어 catalogSummaryProvider(네트워크 의존)를 이 테스트의
        // 관심사(quizQuestionsProvider)에서 분리한다.
        overrides: [guestModeProvider.overrideWith((ref) => true)],
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, _) => MaterialApp.router(routerConfig: router),
        ),
      ),
    );

    Future<void> pumpBounded() async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    // 1차 진입 — 실 push, 새 라우트 엘리먼트가 만들어진다.
    router.push(RoutePaths.quizReward);
    await pumpBounded();
    expect(tester.takeException(), isNull);
    expect(find.text('수달'), findsOneWidget);

    router.pop();
    await pumpBounded();

    // 2차 진입 — quizQuestionsProvider가 실 에셋을 다시 읽어야 한다.
    router.push(RoutePaths.quizReward);
    await pumpBounded();

    expect(tester.takeException(), isNull);
    expect(find.text('수달'), findsOneWidget);
  });
}
