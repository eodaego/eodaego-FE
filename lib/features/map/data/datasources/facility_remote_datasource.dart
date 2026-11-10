import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/facility_model.dart';

part 'facility_remote_datasource.g.dart';

/// 시설 백엔드 API 클라이언트
///
/// **엔드포인트**:
/// - `GET /api/1/facilities` - 시설 목록 (JWT 필요)
/// - `GET /api/1/facilities/{facilityId}` - 시설 상세 (JWT 필요, 없으면 404)
@RestApi()
abstract class FacilityRemoteDataSource {
  factory FacilityRemoteDataSource(Dio dio) = _FacilityRemoteDataSource;

  @GET(ApiEndpoints.facilities)
  Future<List<FacilityModel>> getFacilities();

  @GET(ApiEndpoints.facilityDetail)
  Future<FacilityDetailModel> getFacility(@Path('facilityId') int facilityId);
}
