import '../../../../core/constants/dogam_category.dart';
import 'course_options.dart';

/// 코스에 포함된 장소.
///
/// 서버가 주는 좌표(latitude/longitude)와 시설 ID는 쓸 화면이 없어 담지 않는다.
/// 실제 지도를 붙일 때 추가한다.
class CoursePlaceEntity {
  const CoursePlaceEntity({
    required this.visitOrder,
    required this.name,
    required this.category,
  });

  /// 방문 순서(1부터)
  final int visitOrder;
  final String name;
  final DogamCategory category;
}

/// 추천받은 코스.
class CourseEntity {
  const CourseEntity({
    required this.id,
    required this.title,
    required this.tagLabels,
    required this.estimatedDurationMinutes,
    required this.entrance,
    required this.exit,
    required this.favorite,
    required this.places,
  });

  final String id;
  final String title;

  /// AI가 코스마다 만든 특징 태그 1~3개. 빈 배열일 수 있다.
  final List<String> tagLabels;

  /// AI가 계산한 완주 예상 소요시간(분). 요청한 희망 체류시간과 다른 값이다.
  final int estimatedDurationMinutes;

  /// 입구. 서버가 모르는 값을 주면 null이다.
  final ParkGate? entrance;

  /// 출구. 서버가 모르는 값을 주면 null이다.
  final ParkGate? exit;

  /// 현재 회원의 즐겨찾기 여부. 추천 직후에는 항상 false다.
  final bool favorite;

  /// 방문 순서대로 정렬된 장소 목록. 입구·출구는 포함되지 않는다.
  final List<CoursePlaceEntity> places;

  /// 카드 뱃지 색으로 쓸 카테고리 — 장소 중 가장 많은 것.
  ///
  /// 동률이면 방문 순서가 빠른 쪽을 고른다. 장소가 없으면 [DogamCategory.place].
  /// 서버의 `interestTypes`(7종)는 카테고리 3색과 맞지 않아 쓰지 않는다.
  DogamCategory get dominantCategory {
    if (places.isEmpty) return DogamCategory.place;

    final counts = <DogamCategory, int>{};
    for (final place in places) {
      counts[place.category] = (counts[place.category] ?? 0) + 1;
    }

    // 방문 순서대로 훑으며 최다 카테고리를 처음 만나는 지점에서 멈춘다.
    // 이러면 동률일 때 자연히 먼저 방문하는 쪽이 뽑힌다.
    final max = counts.values.reduce((a, b) => a > b ? a : b);
    for (final place in places) {
      if (counts[place.category] == max) return place.category;
    }
    return DogamCategory.place;
  }

  /// "약 2시간", "약 1시간 30분", "약 40분"
  String get durationLabel {
    final hours = estimatedDurationMinutes ~/ 60;
    final minutes = estimatedDurationMinutes % 60;
    if (hours == 0) return '약 $minutes분';
    if (minutes == 0) return '약 $hours시간';
    return '약 $hours시간 $minutes분';
  }

  /// 카테고리 뱃지에 쓸 문구 — AI 태그 첫 개, 없으면 카테고리 이름.
  String get badgeLabel =>
      tagLabels.isNotEmpty ? tagLabels.first : dominantCategory.label;

  /// "정문 → 남문". 서버가 모르는 출입문을 주면 그 자리를 '-'로 둔다.
  String get gateLabel => '${entrance?.label ?? '-'} → ${exit?.label ?? '-'}';

  /// 즐겨찾기만 뒤집은 새 인스턴스를 돌려준다 — 원본은 그대로 둔다.
  CourseEntity copyWith({bool? favorite}) {
    return CourseEntity(
      id: id,
      title: title,
      tagLabels: tagLabels,
      estimatedDurationMinutes: estimatedDurationMinutes,
      entrance: entrance,
      exit: exit,
      favorite: favorite ?? this.favorite,
      places: places,
    );
  }
}
