import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

/// 시간대별 예보 DTO
///
/// [WeatherModel]의 `hourlyForecast[]` 원소.
///
/// **주의**: `datetime`은 타임존 오프셋이 없는 문자열이다
/// (`2026-07-30T01:00:00`). 파싱은 `parseKstDateTime`을 거친다.
@freezed
class HourlyWeatherModel with _$HourlyWeatherModel {
  const factory HourlyWeatherModel({
    /// 예보 시각 (오프셋 없음)
    String? datetime,

    /// 예상 기온 — 서버가 정수로 내려도 double로 읽는다
    @Default(0) double temperature,

    /// 강수 확률 백분율
    @Default(0) int precipitationProbability,

    /// 강수 형태 원문
    @Default('') String precipitationType,

    /// 하늘 상태 원문
    @Default('') String skyCondition,
  }) = _HourlyWeatherModel;

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$HourlyWeatherModelFromJson(json);
}

/// 현재 날씨 조회 응답 DTO
///
/// `GET /api/1/weather/current` 응답.
///
/// **주의**: `hourlyForecast`에는 이미 지나간 시각이 섞여 있다(발표 기준 전체).
/// 응답의 `id`·`placeRefKey`·`collectedAt`은 앱에서 쓰지 않아 선언하지 않는다.
@freezed
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    /// 현재 기온
    @Default(0) double temperature,

    /// 현재 습도 백분율
    @Default(0) int humidity,

    /// 현재 풍속 (m/s)
    @Default(0) double windSpeed,

    /// 강수 형태 원문
    @Default('') String precipitationType,

    /// 하늘 상태 원문
    @Default('') String skyCondition,

    /// 관측 시각 (오프셋 없음)
    String? observedAt,

    /// 시간대별 예보
    @Default(<HourlyWeatherModel>[]) List<HourlyWeatherModel> hourlyForecast,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
}
