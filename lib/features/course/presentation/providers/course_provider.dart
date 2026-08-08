import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/course_mock_datasource.dart';
import '../../data/datasources/course_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../../domain/repositories/course_repository.dart';

part 'course_provider.g.dart';

// ============================================
// Data Layer Providers
// ============================================

/// CourseRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [CourseMockDataSource]로 바뀐다.
///
/// **주의**: keepAlive다. 목 데이터소스가 즐겨찾기 상태를 인메모리로 들고 있어,
/// 인스턴스가 재생성되면 목 모드에서 하트가 초기화된다.
@Riverpod(keepAlive: true)
CourseRemoteDataSource courseRemoteDataSource(Ref ref) {
  if (EnvConfig.useMockData) {
    debugPrint('[Mock] ✅ 코스 목 데이터 사용');
    return CourseMockDataSource();
  }
  return CourseRemoteDataSource(ref.watch(dioProvider));
}

/// CourseRepository Provider
@Riverpod(keepAlive: true)
CourseRepository courseRepository(Ref ref) {
  return CourseRepositoryImpl(ref.watch(courseRemoteDataSourceProvider));
}

// ============================================
// Presentation Providers (추천)
// ============================================

/// 코스 추천 결과.
///
/// `null`은 "아직 요청하지 않음", 빈 목록은 "요청했으나 결과 없음"이다. 화면이 둘을 구분한다.
///
/// **주의**: 추천은 호출할 때마다 AI 서버를 거치고 서버에 코스가 새로 저장된다.
/// 결과를 여기 보관하므로 스와이프·리빌드로 재호출되지 않는다.
@riverpod
class CourseRecommendation extends _$CourseRecommendation {
  @override
  FutureOr<List<CourseEntity>?> build() => null;

  /// 조건으로 추천을 1회 요청한다. [entrance]·[exit]는 필수다.
  Future<void> request({
    required ParkGate entrance,
    required ParkGate exit,
    List<InterestType>? interestTypes,
    int? stayDurationMinutes,
    CompanionType? companionType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(courseRepositoryProvider)
          .recommendCourses(
            entrance: entrance,
            exit: exit,
            interestTypes: interestTypes,
            stayDurationMinutes: stayDurationMinutes,
            companionType: companionType,
          );
    });
  }

  /// 결과 목록 안에서 코스 하나의 즐겨찾기 표시만 뒤집는다.
  ///
  /// 서버 호출은 하지 않는다 — 호출은 `favoriteToggleProvider`가 담당한다.
  void markFavorite(String courseId, bool favorite) {
    final courses = state.valueOrNull;
    if (courses == null) return;
    state = AsyncValue.data([
      for (final course in courses)
        if (course.id == courseId)
          course.copyWith(favorite: favorite)
        else
          course,
    ]);
  }
}
