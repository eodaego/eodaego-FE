import 'package:eodaego/features/course/data/datasources/course_remote_datasource.dart';
import 'package:eodaego/features/course/data/models/course_favorite_list_model.dart';
import 'package:eodaego/features/course/data/models/course_model.dart';
import 'package:eodaego/features/course/data/models/course_recommendation_request_model.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/course/presentation/providers/course_provider.dart';
import 'package:eodaego/features/course/presentation/providers/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크. 응답이 이벤트 루프 한 바퀴 뒤에 오도록 지연을 준다 —
/// 실제 네트워크처럼 await 중에 autoDispose가 끼어들 틈을 만든다.
class _FakeCourseDataSource implements CourseRemoteDataSource {
  final addedIds = <String>[];

  /// 조회 요청이 들어온 sort 값 — 관찰 가능한 경계 상태.
  final fetchedSorts = <String?>[];

  @override
  Future<void> addFavorite(String courseId) async {
    await Future<void>.delayed(Duration.zero);
    addedIds.add(courseId);
  }

  @override
  Future<void> removeFavorite(String courseId) async {
    await Future<void>.delayed(Duration.zero);
  }

  @override
  Future<CourseFavoriteListModel> getFavorites(String? sort) async {
    fetchedSorts.add(sort);
    return const CourseFavoriteListModel();
  }

  @override
  Future<List<CourseModel>> recommendCourses(
    CourseRecommendationRequestModel request,
  ) async => const <CourseModel>[];
}

ProviderContainer _container(_FakeCourseDataSource fake) {
  final container = ProviderContainer(
    overrides: [courseRemoteDataSourceProvider.overrideWithValue(fake)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('toggle_saves_favorite_when_nobody_listens_to_the_provider', () async {
    final fake = _FakeCourseDataSource();
    final container = _container(fake);

    // 화면은 .notifier만 read한다 (watch 없음). autoDispose면 await 도중 폐기된다.
    final ok = await container
        .read(favoriteToggleProvider.notifier)
        .toggle(courseId: 'course-1', favorite: true);

    expect(ok, isTrue);
    expect(fake.addedIds, ['course-1']);
    // 아무도 안 보는 목록까지 새로 불러오면 하트 한 번에 조회가 딸려 나간다.
    expect(fake.fetchedSorts, isEmpty);
  });

  test('toggle_refetches_the_favorite_list_a_screen_is_watching', () async {
    final fake = _FakeCourseDataSource();
    final container = _container(fake);

    // 즐겨찾기 화면이 열려 있는 상황 — 목록을 구독 중이다.
    container.listen(
      favoriteCoursesProvider(FavoriteSort.latest),
      (_, _) {},
      fireImmediately: true,
    );
    await container.read(favoriteCoursesProvider(FavoriteSort.latest).future);
    fake.fetchedSorts.clear();

    await container
        .read(favoriteToggleProvider.notifier)
        .toggle(courseId: 'course-1', favorite: true);
    await container.read(favoriteCoursesProvider(FavoriteSort.latest).future);

    expect(fake.fetchedSorts, ['LATEST']);
  });
}
