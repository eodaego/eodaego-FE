import '../../course/domain/entities/course_entity.dart';
import '../domain/entities/facility_entity.dart';

/// 코스가 있을 때 시설 마커의 불투명도 — 코스 마커가 먼저 읽히도록 옅게 둔다.
const double dimmedFacilityOpacity = 0.35;

/// 지도에 시설 마커로 그릴 시설.
///
/// 코스 장소와 같은 시설은 이미 숫자 마커로 그려지므로 뺀다.
List<FacilityEntity> visibleFacilities({
  required List<FacilityEntity> all,
  required CourseEntity? course,
}) {
  if (course == null) return all;
  final shownIds = {
    for (final place in course.places)
      if (place.facilityId != null) place.facilityId,
  };
  return all.where((f) => !shownIds.contains(f.id)).toList();
}
