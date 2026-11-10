import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/services/location/device_location_service.dart';
import '../../../../core/services/permission/location_permission_service.dart';
import '../../data/datasources/course_mock_datasource.dart';
import '../../data/datasources/course_remote_datasource.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../../domain/repositories/course_repository.dart';
import '../park_gate_positions.dart';

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

/// 지금 위치에서 가장 가까운 출입문 — 코스 추천의 입·출구 기본값.
///
/// **주의**: 권한 요청 팝업은 띄우지 않는다. 이미 허용된 경우에만 위치를 읽고,
/// 위치를 쓸 수 없거나 공원에서 멀면 null을 돌려 사용자가 직접 고르게 한다.
@riverpod
Future<ParkGate?> nearestParkGate(Ref ref) async {
  try {
    if (!await LocationPermissionService.canAccessLocation()) return null;
    final position = await DeviceLocationService.getCurrentPosition(
      timeLimit: const Duration(seconds: 5),
    );
    if (position == null) return null;
    return findNearestParkGate(position.latitude, position.longitude);
  } catch (e) {
    debugPrint('[Course] ⚠️ 가까운 출입문 찾기 실패, 직접 선택으로 진행: $e');
    return null;
  }
}

/// 지도가 들고 있는 선택 코스를 서버 최신 상태로 맞춘다.
///
/// 추천 응답의 수집 여부는 스냅숏이라, 지도에 들어올 때 상세를 다시 받아 교체한다.
///
/// **주의**: 응답이 늦게 와도 그 사이 선택 코스가 바뀌었으면 버린다.
/// 게스트는 호출하지 않고, 실패하면 기존 코스를 그대로 둔다.
@Riverpod(keepAlive: true)
class SelectedCourseSync extends _$SelectedCourseSync {
  @override
  void build() {}

  Future<void> sync() async {
    if (ref.read(guestRestrictedProvider)) return;
    final selected = ref.read(selectedCourseProvider);
    if (selected == null) return;

    try {
      final fresh = await ref
          .read(courseRepositoryProvider)
          .getCourse(selected.id);
      if (ref.read(selectedCourseProvider)?.id != selected.id) return;
      ref.read(selectedCourseProvider.notifier).state = fresh;
    } catch (e) {
      debugPrint('[Course] ⚠️ 코스 상세 동기화 실패, 기존 코스 유지: $e');
    }
  }
}
