import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_message_keys.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_exception_handler.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';
import '../models/course_model.dart';
import '../models/course_recommendation_request_model.dart';

/// Course Repository 구현체
///
/// [CourseRemoteDataSource]를 통해 백엔드 코스·즐겨찾기 API를 호출한다.
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _dataSource;

  CourseRepositoryImpl(this._dataSource);

  @override
  Future<List<CourseEntity>> recommendCourses({
    required ParkGate entrance,
    required ParkGate exit,
    List<InterestType>? interestTypes,
    int? stayDurationMinutes,
    CompanionType? companionType,
  }) async {
    try {
      final response = await _dataSource.recommendCourses(
        CourseRecommendationRequestModel(
          entrance: entrance.serverValue,
          exit: exit.serverValue,
          interestTypes: interestTypes
              ?.map((type) => type.serverValue)
              .toList(),
          stayDurationMinutes: stayDurationMinutes,
          companionType: companionType?.serverValue,
        ),
      );

      final courses = response.map(_toEntity).toList();

      if (kDebugMode) {
        debugPrint('[Course] ✅ 추천 ${courses.length}건');
      }

      return courses;
    } on DioException catch (e) {
      // The AI server being down is not a condition problem. The result page
      // offers a retry only when it can tell the two apart.
      // AI 서버 장애는 조건 문제가 아니다. 결과 화면이 "다시 시도"를 띄우려면
      // 조건 때문에 코스가 안 나온 경우와 구분돼야 한다.
      if (e.response?.statusCode == 503) {
        debugPrint('[Course] ❌ AI 서버 응답 없음 (503)');
        throw ServerException(
          message: '지금은 코스를 만들지 못했어요. 잠시 후 다시 시도해 주세요.',
          messageKey: AppMessageKeys.errorCourseAiUnavailable,
          originalException: e,
        );
      }
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '코스를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorCourseUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<List<CourseEntity>> getFavorites(FavoriteSort sort) async {
    try {
      final response = await _dataSource.getFavorites(sort.serverValue);

      final courses = <CourseEntity>[];
      for (final item in response.items) {
        final course = item.course;
        if (course == null) continue;
        courses.add(_toEntity(course));
      }

      if (kDebugMode) {
        debugPrint('[Course] ✅ 즐겨찾기 ${courses.length}건 (${sort.serverValue})');
      }

      return courses;
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '저장한 코스를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorFavoriteUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<void> addFavorite(String courseId) async {
    try {
      await _dataSource.addFavorite(courseId);
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  @override
  Future<void> removeFavorite(String courseId) async {
    try {
      await _dataSource.removeFavorite(courseId);
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  /// 코스 DTO를 도메인 엔티티로 옮긴다.
  ///
  /// 카테고리를 모르는 장소는 색·아이콘이 없어 그릴 수 없으므로 제외한다.
  CourseEntity _toEntity(CourseModel dto) {
    final places = <CoursePlaceEntity>[];
    final unknownCategories = <String>{};
    for (final place in dto.places) {
      final category = DogamCategory.fromServer(place.category);
      if (category == null) {
        unknownCategories.add(place.category ?? 'null');
        continue;
      }
      places.add(
        CoursePlaceEntity(
          visitOrder: place.visitOrder,
          name: place.name,
          category: category,
          latitude: place.latitude,
          longitude: place.longitude,
        ),
      );
    }

    if (unknownCategories.isNotEmpty) {
      debugPrint(
        '[Course] ⚠️ 알 수 없는 장소 카테고리 (${unknownCategories.join(', ')}) — '
        '${dto.places.length - places.length}개 장소 제외',
      );
    }

    return CourseEntity(
      id: dto.id,
      title: dto.title,
      tagLabels: dto.tagLabels,
      estimatedDurationMinutes: dto.estimatedDurationMinutes,
      entrance: ParkGate.fromServer(dto.entrance),
      exit: ParkGate.fromServer(dto.exit),
      favorite: dto.favorite,
      places: places,
    );
  }
}
