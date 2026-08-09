import '../../../../core/mock/mock_asset_loader.dart';
import '../../domain/entities/course_options.dart';
import '../models/course_favorite_list_model.dart';
import '../models/course_model.dart';
import '../models/course_recommendation_request_model.dart';
import 'course_remote_datasource.dart';

/// 목 코스 데이터소스
///
/// `assets/mock/courses.json`을 읽어 돌려준다.
/// `EnvConfig.useMockData`가 켜졌을 때 [CourseRemoteDataSource] 대신 쓰인다
/// (분기는 `course_provider.dart`에서 한다).
///
/// **주의**: 즐겨찾기 상태를 인스턴스가 인메모리로 들고 있다. 목 모드에서도
/// 하트가 눌리려면 이 상태가 살아 있어야 하므로, 이 데이터소스를 만드는
/// provider는 반드시 `keepAlive`여야 한다.
class CourseMockDataSource implements CourseRemoteDataSource {
  static const _asset = 'assets/mock/courses.json';

  /// 즐겨찾기한 코스 ID — 앱을 다시 켜면 사라진다.
  final _favoriteIds = <String>{};

  /// 픽스처 캐시 — 매 호출마다 에셋을 다시 읽지 않는다.
  List<CourseModel>? _cache;

  Future<List<CourseModel>> _loadCourses() async {
    final cached = _cache;
    if (cached != null) return cached;

    final json = await loadMockJson(_asset);
    final raw = json['courses'] as List? ?? const [];
    final courses = [
      for (final item in raw)
        CourseModel.fromJson(item as Map<String, dynamic>),
    ];
    _cache = courses;
    return courses;
  }

  @override
  Future<List<CourseModel>> recommendCourses(
    CourseRecommendationRequestModel request,
  ) async {
    // 목 단계에서 조건별 분기를 흉내 내지 않는다. 픽스처 전체를 돌려준다.
    final courses = await _loadCourses();
    return [
      for (final course in courses)
        course.copyWith(favorite: _favoriteIds.contains(course.id)),
    ];
  }

  @override
  Future<CourseFavoriteListModel> getFavorites(String? sort) async {
    final courses = await _loadCourses();
    final saved = [
      for (final course in courses)
        if (_favoriteIds.contains(course.id)) course.copyWith(favorite: true),
    ];

    // 서버 정렬을 흉내 낸다 — 소요시간 정렬만 관찰 가능한 차이를 만든다.
    if (sort == FavoriteSort.durationShort.serverValue) {
      saved.sort(
        (a, b) =>
            a.estimatedDurationMinutes.compareTo(b.estimatedDurationMinutes),
      );
    } else if (sort == FavoriteSort.durationLong.serverValue) {
      saved.sort(
        (a, b) =>
            b.estimatedDurationMinutes.compareTo(a.estimatedDurationMinutes),
      );
    } else if (sort == FavoriteSort.oldest.serverValue) {
      // 등록 순서를 따로 기록하지 않는다 — 목에서는 뒤집기로 충분하다.
      final reversed = saved.reversed.toList();
      saved
        ..clear()
        ..addAll(reversed);
    }

    return CourseFavoriteListModel(
      totalCount: saved.length,
      items: [
        for (final course in saved) CourseFavoriteItemModel(course: course),
      ],
    );
  }

  @override
  Future<void> addFavorite(String courseId) async {
    _favoriteIds.add(courseId);
  }

  @override
  Future<void> removeFavorite(String courseId) async {
    _favoriteIds.remove(courseId);
  }
}
