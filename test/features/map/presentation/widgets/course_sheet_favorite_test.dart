import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/course/domain/repositories/course_repository.dart';
import 'package:eodaego/features/course/presentation/providers/course_provider.dart';
import 'package:eodaego/features/map/presentation/widgets/course_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// 지도 시트의 '지금 보는 코스' 하트.
///
/// 화면을 먼저 뒤집고 서버가 실패하면 되돌린다. 뒤집는 대상이
/// `selectedCourseProvider`라, 되돌리기가 새면 지도 마커·홈 카드까지 거짓 상태로
/// 남는다 — 그래서 되돌리기를 직접 검증한다.

const _course = CourseEntity(
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
    ),
  ],
);

class _FakeCourseRepository implements CourseRepository {
  _FakeCourseRepository({this.failWrites = false});

  /// true면 등록·삭제가 서버에서 실패한 것으로 친다.
  final bool failWrites;
  final added = <String>[];

  @override
  Future<void> addFavorite(String courseId) async {
    if (failWrites) throw Exception('network down');
    added.add(courseId);
  }

  @override
  Future<void> removeFavorite(String courseId) async {
    if (failWrites) throw Exception('network down');
  }

  @override
  Future<List<CourseEntity>> getFavorites(FavoriteSort sort) async => const [];

  @override
  Future<List<CourseEntity>> recommendCourses({
    required ParkGate entrance,
    required ParkGate exit,
    List<InterestType>? interestTypes,
    int? stayDurationMinutes,
    CompanionType? companionType,
  }) async => const [];
}

Future<ProviderContainer> _pumpSheet(
  WidgetTester tester, {
  required CourseRepository repository,
  bool guest = false,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      courseRepositoryProvider.overrideWithValue(repository),
      // 실효 게스트 여부를 직접 준다 — 원본은 dotenv(EnvConfig.useMockData)를
      // 타서 위젯 테스트에서 던진다.
      guestRestrictedProvider.overrideWithValue(guest),
    ],
  );
  addTearDown(container.dispose);
  container.read(selectedCourseProvider.notifier).state = _course;

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) =>
            MaterialApp(home: const Scaffold(body: CourseSheet())),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group('지도 시트 즐겨찾기', () {
    testWidgets('하트를 누르면 지금 보는 코스가 저장 상태로 바뀐다', (tester) async {
      final repository = _FakeCourseRepository();
      final container = await _pumpSheet(tester, repository: repository);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      expect(container.read(selectedCourseProvider)?.favorite, isTrue);
      expect(repository.added, ['course-1']);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('서버가 실패하면 하트를 되돌리고 안내를 보여준다', (tester) async {
      final container = await _pumpSheet(
        tester,
        repository: _FakeCourseRepository(failWrites: true),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      // 되돌아가지 않으면 지도·홈까지 "저장됨"으로 거짓말한다.
      expect(container.read(selectedCourseProvider)?.favorite, isFalse);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('저장하지 못했어요. 잠시 후 다시 시도해 주세요'), findsOneWidget);

      // AppSnackbar는 3초 뒤 스스로 사라진다. 그 타이머를 남긴 채 끝내면
      // 테스트 프레임워크가 '펜딩 타이머'로 실패시킨다.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('게스트에게는 하트를 주지 않는다', (tester) async {
      // 즐겨찾기는 회원 기준으로 서버에 저장된다 — 눌러도 401이다.
      await _pumpSheet(
        tester,
        repository: _FakeCourseRepository(),
        guest: true,
      );

      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });
  });
}
