import '../entities/weather_entity.dart';

/// 날씨 Repository 인터페이스
abstract class WeatherRepository {
  /// 현재 날씨와 시간대별 예보를 조회한다.
  ///
  /// **주의**: 돌려주는 예보에는 지나간 시각이 섞여 있다. 화면에 그리기 전에
  /// [WeatherEntity.upcomingFrom]으로 거른다.
  Future<WeatherEntity> getCurrentWeather();
}
