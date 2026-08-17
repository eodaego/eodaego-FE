import '../../../../core/constants/dogam_category.dart';
import 'course_options.dart';

/// 코스에 포함된 장소.
///
/// 서버가 주는 좌표는 실제 지도 마커에 사용한다.
///
/// [collected]와 [catalogItemId]가 지도 카드·마커의 도감 표시를 가르는 근거다.
/// 두 값으로 세 갈래가 나온다 — 별도 상태 타입을 두지 않는다.
///
/// | [collected] | [catalogItemId] | 뜻 |
/// | --- | --- | --- |
/// | true | 있음 | 이미 수집했다 — 도감 상세로 보낸다 |
/// | false | 있음 | 도감에 있지만 아직 안 모았다 — 촬영 CTA |
/// | false | null | 도감에 없는 시설 — CTA를 띄우면 거짓말이 된다 |
class CoursePlaceEntity {
  const CoursePlaceEntity({
    required this.visitOrder,
    required this.name,
    required this.category,
    this.catalogItemId,
    this.collected = false,
    this.latitude,
    this.longitude,
  });

  /// 방문 순서(1부터)
  final int visitOrder;
  final String name;
  final DogamCategory category;

  /// 연결된 도감 항목 ID. 도감에 동기화되지 않은 시설이면 null이다.
  ///
  /// **주의**: 코스 응답의 [category]는 화면 표시용으로 다시 매긴 값이라
  /// 도감에 저장된 카테고리(AI 시설은 항상 PLACE)와 다르다. 도감을 찾을 때는
  /// [category]가 아니라 이 ID만 쓴다.
  final String? catalogItemId;

  /// 현재 회원의 도감 수집 여부.
  ///
  /// **주의**: 코스를 추천받은 시점의 스냅숏이다. 앱 안에서 도감을 모으면
  /// [CourseEntity.markCollected]로 맞춰 준다.
  final bool collected;

  final double? latitude;
  final double? longitude;

  /// 수집 여부만 뒤집은 새 인스턴스를 돌려준다 — 원본은 그대로 둔다.
  CoursePlaceEntity copyWith({bool? collected}) {
    return CoursePlaceEntity(
      visitOrder: visitOrder,
      name: name,
      category: category,
      catalogItemId: catalogItemId,
      collected: collected ?? this.collected,
      latitude: latitude,
      longitude: longitude,
    );
  }
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

  /// 즐겨찾기·장소만 갈아끼운 새 인스턴스를 돌려준다 — 원본은 그대로 둔다.
  CourseEntity copyWith({bool? favorite, List<CoursePlaceEntity>? places}) {
    return CourseEntity(
      id: id,
      title: title,
      tagLabels: tagLabels,
      estimatedDurationMinutes: estimatedDurationMinutes,
      entrance: entrance,
      exit: exit,
      favorite: favorite ?? this.favorite,
      places: places ?? this.places,
    );
  }

  /// 방금 모은 도감 항목과 연결된 장소를 수집 상태로 뒤집은 코스를 돌려준다.
  ///
  /// 코스 응답의 수집 여부는 추천받은 시점의 스냅숏이고, 추천은 POST라 같은
  /// 코스를 다시 받아올 수 없다. 앱 안에서 도감을 모으면 이 자리에서 직접
  /// 맞춰야 지도 마커와 장소 카드가 방금 모은 곳을 계속 '아직'으로 그리지 않는다.
  ///
  /// Returns: 바뀔 장소가 없으면 자기 자신. 지도 마커 비트맵은 코스 인스턴스가
  /// 바뀔 때 다시 구우므로, 헛돌지 않게 같은 인스턴스를 돌려주는 편이 낫다.
  CourseEntity markCollected(String catalogItemId) {
    final matches = places.any(
      (place) => place.catalogItemId == catalogItemId && !place.collected,
    );
    if (!matches) return this;

    return copyWith(
      places: [
        for (final place in places)
          if (place.catalogItemId == catalogItemId)
            place.copyWith(collected: true)
          else
            place,
      ],
    );
  }
}
