import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/weather_model.dart';

part 'weather_remote_datasource.g.dart';

/// 날씨 백엔드 API 클라이언트
///
/// **엔드포인트**:
/// - `GET /api/1/weather/current` - 현재 날씨 + 시간대별 예보 (JWT 필요)
@RestApi()
abstract class WeatherRemoteDataSource {
  factory WeatherRemoteDataSource(Dio dio) = _WeatherRemoteDataSource;

  /// 현재 날씨 조회
  ///
  /// 장소는 어린이대공원 하나뿐이라 파라미터가 없다.
  ///
  /// - 200: 현재 날씨 + 시간대별 예보
  /// - 401: 인증 실패
  /// - 503: AI 서버 연결 실패 (백엔드가 중계하는 구조라 실제로 날 수 있다)
  @GET(ApiEndpoints.weatherCurrent)
  Future<WeatherModel> getCurrentWeather();
}
