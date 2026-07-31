import 'package:freezed_annotation/freezed_annotation.dart';

import 'weather_condition.dart';

part 'weather_entity.freezed.dart';

/// 시간대별 예보 한 칸.
@freezed
class HourlyForecastEntity with _$HourlyForecastEntity {
  const factory HourlyForecastEntity({
    /// 예보 시각 (KST 벽시계)
    required DateTime dateTime,

    /// 예상 기온
    required double temperature,

    /// 강수 확률 백분율
    required int precipitationProbability,

    /// 하늘 상태 서버 원문
    required String skyLabel,

    /// 강수 형태 서버 원문
    required String precipitationLabel,

    /// 매핑된 하늘 상태 — 모르는 값이면 null
    WeatherSky? sky,

    /// 매핑된 강수 형태 — 모르는 값이면 null
    WeatherPrecipitation? precipitation,
  }) = _HourlyForecastEntity;
}

/// 현재 날씨와 시간대별 예보.
@freezed
class WeatherEntity with _$WeatherEntity {
  const WeatherEntity._();

  const factory WeatherEntity({
    /// 현재 기온
    required double temperature,

    /// 현재 습도 백분율
    required int humidity,

    /// 현재 풍속 (m/s)
    required double windSpeed,

    /// 하늘 상태 서버 원문
    required String skyLabel,

    /// 강수 형태 서버 원문
    required String precipitationLabel,

    /// 시간대별 예보. 지나간 시각이 섞여 있으므로 [upcomingFrom]으로 거른다.
    required List<HourlyForecastEntity> hourlyForecast,

    /// 매핑된 하늘 상태 — 모르는 값이면 null
    WeatherSky? sky,

    /// 매핑된 강수 형태 — 모르는 값이면 null
    WeatherPrecipitation? precipitation,

    /// 관측 시각 (KST 벽시계)
    DateTime? observedAt,
  }) = _WeatherEntity;

  /// 표시 라벨 — 비·눈이 오면 강수 형태, 아니면 하늘 상태.
  String get conditionLabel =>
      (precipitation?.isFalling ?? false) ? precipitationLabel : skyLabel;

  /// 지금 이후 예보만 돌려준다.
  ///
  /// 서버는 발표 기준 전체(지나간 시각 포함)를 주므로 새벽 2시에 앱을 켜면
  /// 0시·1시 예보가 목록 맨 앞에 온다.
  ///
  /// **주의**: [now]는 `nowKst()`로 만든 KST 벽시계여야 한다. 기기 로컬 시각을
  /// 넘기면 타임존만큼 어긋난다. 정각이 딱 맞는 예보는 지금 유효한 값이므로
  /// 남긴다.
  List<HourlyForecastEntity> upcomingFrom(DateTime now) =>
      hourlyForecast.where((f) => !f.dateTime.isBefore(now)).toList();

  /// 오늘(KST) 예보 슬롯의 최고·최저 기온. 오늘 슬롯이 없으면 null.
  ///
  /// **주의**: [upcomingFrom]과 다르다. 하루 전체의 최고/최저이므로 이미 지난
  /// 오늘 시각도 포함한다 — "지금 이후"로 자르면 저녁에 보는 최저 기온이
  /// 새벽값을 놓쳐 거짓이 된다. [now]는 [nowKst]로 만든 KST 벽시계여야
  /// 예보 시각과 같은 기준으로 비교된다.
  ({double min, double max})? todayRange(DateTime now) {
    final todayTemps = hourlyForecast
        .where(
          (f) =>
              f.dateTime.year == now.year &&
              f.dateTime.month == now.month &&
              f.dateTime.day == now.day,
        )
        .map((f) => f.temperature);
    if (todayTemps.isEmpty) return null;

    return (
      min: todayTemps.reduce((a, b) => a < b ? a : b),
      max: todayTemps.reduce((a, b) => a > b ? a : b),
    );
  }
}
