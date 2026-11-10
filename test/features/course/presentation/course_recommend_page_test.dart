import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/course/domain/repositories/course_repository.dart';
import 'package:eodaego/features/course/presentation/pages/course_recommend_page.dart';
import 'package:eodaego/features/course/presentation/providers/course_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// 추천 요청이 서버로 나가는 경계. 화면이 보낸 조건을 그대로 기록한다.
typedef _Request = ({
  ParkGate entrance,
  ParkGate exit,
  List<InterestType>? interestTypes,
  int? stayDurationMinutes,
  CompanionType? companionType,
});

class _RecordingCourseRepository implements CourseRepository {
  final requests = <_Request>[];

  @override
  Future<List<CourseEntity>> recommendCourses({
    required ParkGate entrance,
    required ParkGate exit,
    List<InterestType>? interestTypes,
    int? stayDurationMinutes,
    CompanionType? companionType,
  }) async {
    requests.add((
      entrance: entrance,
      exit: exit,
      interestTypes: interestTypes,
      stayDurationMinutes: stayDurationMinutes,
      companionType: companionType,
    ));
    // 빈 결과 — 이 테스트는 보낸 조건만 본다.
    return const [];
  }

  @override
  Future<CourseEntity> getCourse(String courseId) async =>
      throw UnimplementedError();

  @override
  Future<List<CourseEntity>> getFavorites(FavoriteSort sort) async => const [];

  @override
  Future<void> addFavorite(String courseId) async {}

  @override
  Future<void> removeFavorite(String courseId) async {}
}

Future<_RecordingCourseRepository> _pumpPage(
  WidgetTester tester, {
  required ParkGate? nearestGate,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final repository = _RecordingCourseRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        courseRepositoryProvider.overrideWithValue(repository),
        nearestParkGateProvider.overrideWith((ref) async => nearestGate),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => const MaterialApp(home: CourseRecommendPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void main() {
  testWidgets('위치로 찾은 문을 입·출구로 채우고 동행을 누르면 그 조건으로 바로 추천한다', (tester) async {
    final repository = await _pumpPage(tester, nearestGate: ParkGate.mainGate);

    expect(find.text('정문으로 돌아오는 코스'), findsOneWidget);

    await tester.tap(find.text(CompanionType.withChild.label));
    await tester.pumpAndSettle();

    expect(repository.requests, [
      (
        entrance: ParkGate.mainGate,
        exit: ParkGate.mainGate,
        interestTypes: null,
        stayDurationMinutes: null,
        companionType: CompanionType.withChild,
      ),
    ]);
  });

  testWidgets('위치를 못 찾으면 문을 고르기 전엔 추천하지 않고, 시트에서 고른 문으로 추천한다', (tester) async {
    final repository = await _pumpPage(tester, nearestGate: null);

    await tester.tap(find.text('상관없어요'));
    await tester.pumpAndSettle();
    expect(repository.requests, isEmpty);

    await tester.tap(find.text('들어온 문을 골라 주세요'));
    await tester.pumpAndSettle();
    // 핀과 그리드에 같은 이름이 있다. 그리드 타일(마지막)을 누른다.
    await tester.tap(find.text(ParkGate.rearGate.label).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(ParkGate.southGate.label).last);
    await tester.pumpAndSettle();

    expect(find.text('남문으로 나가는 코스'), findsOneWidget);

    await tester.tap(find.text('상관없어요'));
    await tester.pumpAndSettle();

    expect(repository.requests.single.entrance, ParkGate.rearGate);
    expect(repository.requests.single.exit, ParkGate.southGate);
    expect(repository.requests.single.companionType, isNull);
  });

  testWidgets('시간·관심을 고르면 다음 추천에 함께 보낸다', (tester) async {
    final repository = await _pumpPage(tester, nearestGate: ParkGate.mainGate);

    await tester.tap(find.text('시간·관심도 고르기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2시간'));
    await tester.tap(find.text(InterestType.animal.label));
    await tester.pump();
    await tester.ensureVisible(find.text('다 골랐어요'));
    await tester.tap(find.text('다 골랐어요'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CompanionType.alone.label));
    await tester.pumpAndSettle();

    expect(repository.requests.single.stayDurationMinutes, 120);
    expect(repository.requests.single.interestTypes, [InterestType.animal]);
  });

  test('출입문 이름에 맞는 조사를 붙인다', () {
    expect(directionParticle('정문'), '으로');
    expect(directionParticle('동문1'), '로');
    expect(directionParticle('북문2'), '로');
  });
}
