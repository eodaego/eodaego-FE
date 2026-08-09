import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/widgets/previous_button.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/course/domain/repositories/course_repository.dart';
import 'package:eodaego/features/course/presentation/pages/course_recommend_page.dart';
import 'package:eodaego/features/course/presentation/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 추천은 호출할 때마다 AI 서버를 거치고 서버에 코스가 새로 저장된다. 그래서
/// 결과까지 온 뒤에는 위저드로 되돌아가는 길이 없어야 한다 — 앱바 뒤로가기도,
/// 오른쪽 스와이프도. 뒤로가기는 코스에 들어오기 전 화면으로 나간다.

const _course = CourseEntity(
  id: 'c1',
  title: '숲속 동물 친구들 코스',
  tagLabels: [],
  // 뱃지 3개 + 하트가 한 줄에 들어가는 짧은 값. 이 테스트가 검증하는 건 뒤로가기
  // 동선이지 CourseCard 레이아웃이 아니다.
  estimatedDurationMinutes: 30,
  entrance: ParkGate.mainGate,
  exit: ParkGate.mainGate,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '동물나라',
      category: DogamCategory.animal,
    ),
  ],
);

/// 데이터 계층 경계만 대체한다 — 화면·provider는 실제 코드를 그대로 쓴다.
class _FakeCourseRepository implements CourseRepository {
  @override
  Future<List<CourseEntity>> recommendCourses({
    required ParkGate entrance,
    required ParkGate exit,
    List<InterestType>? interestTypes,
    int? stayDurationMinutes,
    CompanionType? companionType,
  }) async => [_course];

  @override
  Future<List<CourseEntity>> getFavorites(FavoriteSort sort) async => const [];

  @override
  Future<void> addFavorite(String courseId) async {}

  @override
  Future<void> removeFavorite(String courseId) async {}
}

const _entryText = '코스 진입 전 화면';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/entry',
    routes: [
      GoRoute(
        path: '/entry',
        builder: (context, _) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => context.push('/course/recommend'),
              child: const Text(_entryText),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/course/recommend',
        builder: (_, _) => const CourseRecommendPage(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      courseRepositoryProvider.overrideWithValue(_FakeCourseRepository()),
    ],
    child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => MaterialApp.router(routerConfig: router),
    ),
  );
}

/// 진입 화면에서 위저드 5스텝을 실제로 눌러 결과 화면까지 간다.
Future<void> _walkToResult(WidgetTester tester) async {
  await tester.tap(find.text(_entryText));
  await tester.pumpAndSettle();

  // 입구(0)·출구(1)는 고르면 350ms 뒤 자동으로 넘어간다.
  for (var i = 0; i < 2; i++) {
    await tester.tap(find.text(ParkGate.mainGate.label).first);
    await tester.pumpAndSettle();
  }
  // 체류시간(2)·관심분야(3)·동행(4)은 고르지 않고 하단 버튼으로 넘긴다.
  for (var i = 0; i < 3; i++) {
    await tester.tap(find.text('건너뛰기'));
    await tester.pumpAndSettle();
  }
}

void main() {
  group('코스 추천 결과 화면 뒤로가기', () {
    testWidgets('앱바 뒤로가기를 누르면 위저드가 아니라 코스 진입 전 화면으로 나간다', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await _walkToResult(tester);

      // 결과에 도착했다.
      expect(find.text(_course.title), findsOneWidget);

      await tester.tap(find.byType(PreviousButton));
      await tester.pumpAndSettle();

      // 위저드 마지막 스텝이 아니라 진입 전 화면으로 나왔다.
      expect(find.text('누구랑 왔어?'), findsNothing);
      expect(find.text(_entryText), findsOneWidget);
    });

    testWidgets('결과에서 오른쪽으로 밀어도 위저드로 돌아가지 않는다', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await _walkToResult(tester);

      await tester.drag(find.text(_course.title), const Offset(320, 0));
      await tester.pumpAndSettle();

      expect(find.text('누구랑 왔어?'), findsNothing);
      expect(find.text(_course.title), findsOneWidget);
    });
  });
}
