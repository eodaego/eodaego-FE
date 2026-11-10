import 'dart:async';

import 'package:dio/dio.dart';
import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/course/data/datasources/course_remote_datasource.dart';
import 'package:eodaego/features/course/data/models/course_favorite_list_model.dart';
import 'package:eodaego/features/course/data/models/course_model.dart';
import 'package:eodaego/features/course/data/models/course_recommendation_request_model.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/presentation/providers/course_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크. [gate]가 있으면 완료될 때까지 응답을 붙든다.
class _FakeCourseDataSource implements CourseRemoteDataSource {
  _FakeCourseDataSource({this.result, this.error, this.gate});

  final CourseModel? result;
  final Object? error;
  final Completer<void>? gate;
  var calls = 0;

  @override
  Future<CourseModel> getCourse(String courseId) async {
    calls++;
    await gate?.future;
    if (error != null) throw error!;
    return result!;
  }

  @override
  Future<List<CourseModel>> recommendCourses(
    CourseRecommendationRequestModel request,
  ) async => const [];

  @override
  Future<CourseFavoriteListModel> getFavorites(String? sort) async =>
      const CourseFavoriteListModel();

  @override
  Future<void> addFavorite(String courseId) async {}

  @override
  Future<void> removeFavorite(String courseId) async {}
}

CourseEntity _course(String id, {bool collected = false}) => CourseEntity(
  id: id,
  title: id,
  tagLabels: const [],
  estimatedDurationMinutes: 60,
  entrance: null,
  exit: null,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '맹수마을',
      category: DogamCategory.animal,
      catalogItemId: 'item-1',
      collected: collected,
    ),
  ],
);

CourseModel _serverCourse(String id, {required bool collected}) => CourseModel(
  id: id,
  places: [
    CoursePlaceModel(
      visitOrder: 1,
      name: '맹수마을',
      category: 'ANIMAL',
      catalogItemId: 'item-1',
      collected: collected,
    ),
  ],
);

ProviderContainer _container(
  _FakeCourseDataSource fake, {
  bool guest = false,
}) {
  final container = ProviderContainer(
    overrides: [
      courseRemoteDataSourceProvider.overrideWithValue(fake),
      guestRestrictedProvider.overrideWithValue(guest),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('sync_replaces_selected_course_with_server_collected_state', () async {
    final fake = _FakeCourseDataSource(
      result: _serverCourse('c1', collected: true),
    );
    final container = _container(fake);
    container.read(selectedCourseProvider.notifier).state = _course('c1');

    await container.read(selectedCourseSyncProvider.notifier).sync();

    expect(
      container.read(selectedCourseProvider)!.places.single.collected,
      isTrue,
    );
  });

  test('sync_keeps_course_when_request_fails', () async {
    final fake = _FakeCourseDataSource(
      error: DioException(requestOptions: RequestOptions(path: '/x')),
    );
    final container = _container(fake);
    final original = _course('c1');
    container.read(selectedCourseProvider.notifier).state = original;

    await container.read(selectedCourseSyncProvider.notifier).sync();

    expect(container.read(selectedCourseProvider), same(original));
  });

  test('sync_ignores_late_response_after_course_switched', () async {
    final gate = Completer<void>();
    final fake = _FakeCourseDataSource(
      result: _serverCourse('c1', collected: true),
      gate: gate,
    );
    final container = _container(fake);
    container.read(selectedCourseProvider.notifier).state = _course('c1');

    final pending = container.read(selectedCourseSyncProvider.notifier).sync();
    final other = _course('c2');
    container.read(selectedCourseProvider.notifier).state = other;
    gate.complete();
    await pending;

    expect(container.read(selectedCourseProvider), same(other));
  });

  test('sync_does_nothing_when_no_course_selected', () async {
    final fake = _FakeCourseDataSource(
      result: _serverCourse('c1', collected: true),
    );
    final container = _container(fake);

    await container.read(selectedCourseSyncProvider.notifier).sync();

    expect(fake.calls, 0);
    expect(container.read(selectedCourseProvider), isNull);
  });

  test('sync_does_nothing_for_guest', () async {
    final fake = _FakeCourseDataSource(
      result: _serverCourse('c1', collected: true),
    );
    final container = _container(fake, guest: true);
    container.read(selectedCourseProvider.notifier).state = _course('c1');

    await container.read(selectedCourseSyncProvider.notifier).sync();

    expect(fake.calls, 0);
  });
}
