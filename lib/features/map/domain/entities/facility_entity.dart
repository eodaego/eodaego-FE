/// 공원 시설 (목록 항목)
class FacilityEntity {
  /// 서버가 출입문에 붙이는 분류 값
  static const gateCategory = '출입문';

  final int id;
  final String name;
  final String category;

  /// 좌표 정보가 없는 시설은 null
  final double? latitude;
  final double? longitude;
  final String? facilityType;

  const FacilityEntity({
    required this.id,
    required this.name,
    required this.category,
    this.latitude,
    this.longitude,
    this.facilityType,
  });

  /// 출입문 여부 — 시설 마커로 그리지 않는다.
  bool get isGate => category == gateCategory;
}

/// 공원 시설 상세
class FacilityDetailEntity {
  final FacilityEntity summary;
  final String? intro;
  final String? description;
  final String? openTime;
  final String? closeTime;
  final String? operatingNote;

  const FacilityDetailEntity({
    required this.summary,
    this.intro,
    this.description,
    this.openTime,
    this.closeTime,
    this.operatingNote,
  });

  /// 운영시간 문구. 개장·폐장 시각이 둘 다 있으면 시각, 아니면 안내 문구, 둘 다 없으면 null.
  String? get hoursLabel {
    final open = openTime;
    final close = closeTime;
    if (open != null && close != null) return '운영 $open ~ $close';
    return operatingNote;
  }
}
