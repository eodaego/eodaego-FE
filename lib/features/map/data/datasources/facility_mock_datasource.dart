import '../../../../core/mock/mock_asset_loader.dart';
import '../models/facility_model.dart';
import 'facility_remote_datasource.dart';

/// 목 시설 데이터소스
///
/// `assets/mock/facilities.json`을 읽어 돌려준다.
/// `EnvConfig.useMockData`가 켜졌을 때 [FacilityRemoteDataSource] 대신 쓰인다.
class FacilityMockDataSource implements FacilityRemoteDataSource {
  static const _asset = 'assets/mock/facilities.json';

  /// 픽스처 캐시 — 매 호출마다 에셋을 다시 읽지 않는다.
  List<FacilityDetailModel>? _cache;

  Future<List<FacilityDetailModel>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final json = await loadMockJson(_asset);
    final raw = json['facilities'] as List? ?? const [];
    return _cache = [
      for (final item in raw)
        FacilityDetailModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<List<FacilityModel>> getFacilities() async {
    final all = await _load();
    return [
      for (final f in all)
        FacilityModel(
          id: f.id,
          category: f.category,
          name: f.name,
          latitude: f.latitude,
          longitude: f.longitude,
          facilityType: f.facilityType,
        ),
    ];
  }

  @override
  Future<FacilityDetailModel> getFacility(int facilityId) async {
    final all = await _load();
    return all.firstWhere((f) => f.id == facilityId);
  }
}
