import '../entities/facility_entity.dart';

/// 공원 시설 Repository 인터페이스
abstract class FacilityRepository {
  /// 시설 전체 목록. 출입문도 포함된다.
  Future<List<FacilityEntity>> getFacilities();

  /// 시설 상세. 없는 ID면 `AppException`(404)을 던진다.
  Future<FacilityDetailEntity> getFacility(int id);
}
