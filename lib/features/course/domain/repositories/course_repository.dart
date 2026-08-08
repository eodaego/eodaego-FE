import '../entities/course_entity.dart';
import '../entities/course_options.dart';

/// 코스 추천·즐겨찾기 Repository 인터페이스
abstract class CourseRepository {
  /// 코스 추천을 요청한다.
  ///
  /// 호출할 때마다 백엔드가 AI 서버에 요청하고 결과를 새 코스로 저장한다.
  /// [entrance]·[exit]는 필수다. 나머지는 null이면 AI가 알아서 정한다.
  ///
  /// **주의**: 결과 개수는 AI가 정한다. 고정 개수를 보장하지 않으며 빈 목록일 수 있다.
  /// AI 서버 장애 시 `messageKey`가 `errorCourseAiUnavailable`인 `ServerException`을 던진다.
  Future<List<CourseEntity>> recommendCourses({
    required ParkGate entrance,
    required ParkGate exit,
    List<InterestType>? interestTypes,
    int? stayDurationMinutes,
    CompanionType? companionType,
  });

  /// 즐겨찾기한 코스 목록을 [sort] 기준으로 정렬해 조회한다.
  Future<List<CourseEntity>> getFavorites(FavoriteSort sort);

  /// 코스를 즐겨찾기에 등록한다. 멱등이라 중복 호출이 안전하다.
  Future<void> addFavorite(String courseId);

  /// 코스를 즐겨찾기에서 뺀다. 멱등이라 중복 호출이 안전하다.
  Future<void> removeFavorite(String courseId);
}
