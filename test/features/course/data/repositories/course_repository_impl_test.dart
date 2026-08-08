import 'package:dio/dio.dart';
import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/course/data/datasources/course_remote_datasource.dart';
import 'package:eodaego/features/course/data/models/course_favorite_list_model.dart';
import 'package:eodaego/features/course/data/models/course_model.dart';
import 'package:eodaego/features/course/data/models/course_recommendation_request_model.dart';
import 'package:eodaego/features/course/data/repositories/course_repository_impl.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크. 내부 협력자는 전부 실제 코드다.
class _FakeCourseDataSource implements CourseRemoteDataSource {
  _FakeCourseDataSource({
    this.courses = const <CourseModel>[],
    this.favorites = const CourseFavoriteListModel(),
    this.recommendError,
  });

  final List<CourseModel> courses;
  final CourseFavoriteListModel favorites;
  final Object? recommendError;

  /// 마지막 추천 요청 본문 — 관찰 가능한 경계 상태.
  CourseRecommendationRequestModel? lastRequest;

  /// 즐겨찾기 조회 시 받은 sort 값.
  String? lastSort;

  final addedIds = <String>[];
  final removedIds = <String>[];

  @override
  Future<List<CourseModel>> recommendCourses(
    CourseRecommendationRequestModel request,
  ) async {
    lastRequest = request;
    if (recommendError != null) throw recommendError!;
    return courses;
  }

  @override
  Future<CourseFavoriteListModel> getFavorites(String? sort) async {
    lastSort = sort;
    return favorites;
  }

  @override
  Future<void> addFavorite(String courseId) async => addedIds.add(courseId);

  @override
  Future<void> removeFavorite(String courseId) async =>
      removedIds.add(courseId);
}

DioException _dioError(int statusCode) {
  final request = RequestOptions(path: '/api/1/courses/recommendations');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: request, statusCode: statusCode),
  );
}

void main() {
  group('recommendCourses', () {
    test('sends_selected_options_as_server_enum_strings', () async {
      final fake = _FakeCourseDataSource();
      final repository = CourseRepositoryImpl(fake);

      await repository.recommendCourses(
        entrance: ParkGate.mainGate,
        exit: ParkGate.southGate,
        interestTypes: const [InterestType.animal, InterestType.photoSpot],
        stayDurationMinutes: 120,
        companionType: CompanionType.withChild,
      );

      expect(fake.lastRequest?.entrance, 'MAIN_GATE');
      expect(fake.lastRequest?.exit, 'SOUTH_GATE');
      expect(fake.lastRequest?.interestTypes, ['ANIMAL', 'PHOTO_SPOT']);
      expect(fake.lastRequest?.stayDurationMinutes, 120);
      expect(fake.lastRequest?.companionType, 'WITH_CHILD');
    });

    test('sends_null_for_skipped_options', () async {
      final fake = _FakeCourseDataSource();
      final repository = CourseRepositoryImpl(fake);

      await repository.recommendCourses(
        entrance: ParkGate.mainGate,
        exit: ParkGate.mainGate,
      );

      expect(fake.lastRequest?.interestTypes, isNull);
      expect(fake.lastRequest?.stayDurationMinutes, isNull);
      expect(fake.lastRequest?.companionType, isNull);
    });

    test('maps_response_into_entities', () async {
      final fake = _FakeCourseDataSource(
        courses: const [
          CourseModel(
            id: 'c1',
            title: '동물 만나러 가는 길',
            tagLabels: ['동물듬뿍'],
            estimatedDurationMinutes: 120,
            entrance: 'MAIN_GATE',
            exit: 'SOUTH_GATE',
            places: [
              CoursePlaceModel(
                visitOrder: 1,
                name: '맹수마을',
                category: 'ANIMAL',
              ),
            ],
          ),
        ],
      );
      final repository = CourseRepositoryImpl(fake);

      final result = await repository.recommendCourses(
        entrance: ParkGate.mainGate,
        exit: ParkGate.southGate,
      );

      expect(result, hasLength(1));
      expect(result.first.id, 'c1');
      expect(result.first.entrance, ParkGate.mainGate);
      expect(result.first.places.first.category, DogamCategory.animal);
    });

    test('drops_places_whose_category_the_app_does_not_know', () async {
      // 서버에 카테고리가 추가되면 색·아이콘이 없어 그릴 수 없다.
      final fake = _FakeCourseDataSource(
        courses: const [
          CourseModel(
            id: 'c1',
            places: [
              CoursePlaceModel(visitOrder: 1, name: '맹수마을', category: 'ANIMAL'),
              CoursePlaceModel(visitOrder: 2, name: '미래관', category: 'SPACE'),
            ],
          ),
        ],
      );
      final repository = CourseRepositoryImpl(fake);

      final result = await repository.recommendCourses(
        entrance: ParkGate.mainGate,
        exit: ParkGate.mainGate,
      );

      expect(result.first.places.map((p) => p.name), ['맹수마을']);
    });

    test('raises_a_retryable_ai_error_when_the_ai_server_is_down', () async {
      // 503은 조건 문제가 아니라 서버 장애다. 화면이 "다시 시도"를 띄우려면
      // 다른 에러와 구분돼야 한다.
      final fake = _FakeCourseDataSource(recommendError: _dioError(503));
      final repository = CourseRepositoryImpl(fake);

      await expectLater(
        repository.recommendCourses(
          entrance: ParkGate.mainGate,
          exit: ParkGate.mainGate,
        ),
        throwsA(
          isA<ServerException>().having(
            (e) => e.messageKey,
            'messageKey',
            'errorCourseAiUnavailable',
          ),
        ),
      );
    });

    test('raises_a_plain_server_error_for_other_failures', () async {
      final fake = _FakeCourseDataSource(recommendError: _dioError(500));
      final repository = CourseRepositoryImpl(fake);

      await expectLater(
        repository.recommendCourses(
          entrance: ParkGate.mainGate,
          exit: ParkGate.mainGate,
        ),
        throwsA(
          isA<ServerException>().having(
            (e) => e.messageKey,
            'messageKey',
            isNot('errorCourseAiUnavailable'),
          ),
        ),
      );
    });
  });

  group('getFavorites', () {
    test('sends_the_sort_value_the_server_documents', () async {
      final fake = _FakeCourseDataSource();
      final repository = CourseRepositoryImpl(fake);

      await repository.getFavorites(FavoriteSort.durationLong);

      expect(fake.lastSort, 'DURATION_LONG');
    });

    test('drops_items_whose_course_is_missing', () async {
      final fake = _FakeCourseDataSource(
        favorites: const CourseFavoriteListModel(
          totalCount: 2,
          items: [
            CourseFavoriteItemModel(course: CourseModel(id: 'c1')),
            CourseFavoriteItemModel(),
          ],
        ),
      );
      final repository = CourseRepositoryImpl(fake);

      final result = await repository.getFavorites(FavoriteSort.latest);

      expect(result.map((c) => c.id), ['c1']);
    });
  });
}
