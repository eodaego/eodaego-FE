import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import 'course_provider.dart';

part 'favorite_provider.g.dart';

/// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
@riverpod
Future<List<CourseEntity>> favoriteCourses(Ref ref, FavoriteSort sort) {
  return ref.watch(courseRepositoryProvider).getFavorites(sort);
}

/// 즐겨찾기 토글 1회 = API 호출 + 목록 무효화.
///
/// 하트 상태 자체는 갖지 않는다. 화면이 자기 목록을 낙관적으로 먼저 뒤집고,
/// 실패하면 되돌린다. 등록·삭제 둘 다 멱등이라 더블탭·재시도가 안전하다.
///
/// **주의**: keepAlive다. 화면이 `ref.read(...notifier)`로만 쓰고 watch하지 않아
/// autoDispose면 API 응답을 기다리는 동안 폐기된다. 폐기 시 Riverpod이 내부
/// `_futureCompleter`를 완료시키면서 비우지 않아, 응답 후 `state` 대입이
/// `Bad state: Future already completed`로 터졌다.
@Riverpod(keepAlive: true)
class FavoriteToggle extends _$FavoriteToggle {
  @override
  FutureOr<void> build() {}

  /// [favorite]가 true면 등록, false면 삭제한다.
  ///
  /// Returns: 성공하면 true. 실패하면 false — 호출한 화면이 낙관적 갱신을 되돌린다.
  Future<bool> toggle({
    required String courseId,
    required bool favorite,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseRepositoryProvider);
      if (favorite) {
        await repository.addFavorite(courseId);
      } else {
        await repository.removeFavorite(courseId);
      }
    });

    if (state.hasError) {
      debugPrint('[Course] ❌ 즐겨찾기 토글 실패: ${state.error}');
      return false;
    }

    // 서버 진실로 목록을 다시 맞춘다 — 정렬 순서도 서버가 정한다.
    // sort별로 하나씩 무효화하면 debug 빌드에서 Riverpod이 확인차 provider를
    // 먼저 build해버려(element.dart `_debugAssertCanDependOn`) 아무도 안 보는
    // 목록까지 4번 조회한다. family 통째로 넘기면 살아 있는 것만 건드린다.
    ref.invalidate(favoriteCoursesProvider);
    return true;
  }
}
