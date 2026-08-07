import '../entities/congestion_entity.dart';
import '../entities/weather_entity.dart';

/// 날씨 Repository 인터페이스
abstract class WeatherRepository {
  /// 현재 날씨와 시간대별 예보를 조회한다.
  ///
  /// **주의**: 돌려주는 예보에는 지나간 시각이 섞여 있다. 화면에 그리기 전에
  /// [WeatherEntity.upcomingFrom]으로 거른다.
  Future<WeatherEntity> getCurrentWeather();

  /// 현재 공원 혼잡도를 조회한다.
  ///
  /// **주의**: AI 서버 장애나 데이터 부재 시 503이 온다. 예외 상황이 아니라
  /// 정상 시나리오이므로 호출부는 조용히 표시를 생략한다.
  Future<CongestionEntity> getCurrentCongestion();
}
