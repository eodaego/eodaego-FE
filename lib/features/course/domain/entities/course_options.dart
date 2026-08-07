/// 코스 추천 조건과 즐겨찾기 정렬에 쓰는 서버 enum 대응.
///
/// 정본: `docs/api-docs.json`의 `CourseRecommendationRequest`,
/// `CourseResponse`, `GET /favorites`의 `sort` 파라미터.
library;

/// 공원 출입문 11개.
///
/// **주의**: 한글 라벨은 서버 enum 이름에서 직역한 잠정값이다.
/// 회관문·동문 1·2·북문 1·2의 실제 공원 안내도 표기를 확인해 확정한다.
enum ParkGate {
  mainGate('정문', 'MAIN_GATE'),
  hoegwanGate('회관문', 'HOEGWAN_GATE'),
  southGate('남문', 'SOUTH_GATE'),
  guiGate('구의문', 'GUI_GATE'),
  eastGate1('동문1', 'EAST_GATE_1'),
  eastGate2('동문2', 'EAST_GATE_2'),
  rearGate('후문', 'REAR_GATE'),
  northGate1('북문1', 'NORTH_GATE_1'),
  northGate2('북문2', 'NORTH_GATE_2'),
  westGate('서문', 'WEST_GATE'),
  neungdongGate('능동문', 'NEUNGDONG_GATE');

  const ParkGate(this.label, this.serverValue);

  final String label;
  final String serverValue;

  /// Returns: 매칭되는 [ParkGate], 알 수 없는 값이면 null
  static ParkGate? fromServer(String? value) {
    for (final gate in ParkGate.values) {
      if (gate.serverValue == value) return gate;
    }
    return null;
  }
}

/// 코스 관심 태그 7종. 추천 요청에서 복수 선택한다.
enum InterestType {
  animal('동물', 'ANIMAL'),
  nature('자연', 'NATURE'),
  activity('놀거리', 'ACTIVITY'),
  photoSpot('사진 명소', 'PHOTO_SPOT'),
  relaxation('쉬어가기', 'RELAXATION'),
  cultureEvent('문화·행사', 'CULTURE_EVENT'),
  learning('배우기', 'LEARNING');

  const InterestType(this.label, this.serverValue);

  final String label;
  final String serverValue;

  /// Returns: 매칭되는 [InterestType], 알 수 없는 값이면 null
  static InterestType? fromServer(String? value) {
    for (final type in InterestType.values) {
      if (type.serverValue == value) return type;
    }
    return null;
  }
}

/// 동행 유형 5종.
enum CompanionType {
  alone('혼자', 'ALONE'),
  withChild('아이와', 'WITH_CHILD'),
  withPartner('연인과', 'WITH_PARTNER'),
  withFriends('친구와', 'WITH_FRIENDS'),
  withElderly('어른과', 'WITH_ELDERLY');

  const CompanionType(this.label, this.serverValue);

  final String label;
  final String serverValue;

  /// Returns: 매칭되는 [CompanionType], 알 수 없는 값이면 null
  static CompanionType? fromServer(String? value) {
    for (final type in CompanionType.values) {
      if (type.serverValue == value) return type;
    }
    return null;
  }
}

/// 즐겨찾기 목록 정렬 기준.
///
/// 정렬 필드와 방향이 하나의 값에 묶여 있다. 서버 기본값은 [latest]다.
enum FavoriteSort {
  latest('LATEST'),
  oldest('OLDEST'),
  durationShort('DURATION_SHORT'),
  durationLong('DURATION_LONG');

  const FavoriteSort(this.serverValue);

  final String serverValue;
}
