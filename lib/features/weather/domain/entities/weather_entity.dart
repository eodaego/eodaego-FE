import 'package:freezed_annotation/freezed_annotation.dart';

import 'weather_condition.dart';

part 'weather_entity.freezed.dart';

/// 서버가 주는 시각 문자열을 KST 벽시계로 읽는다.
///
/// **주의**: `DateTime.parse('2026-07-30T00:00:00')`는 오프셋이 없어 기기
/// 로컬 시각으로 해석된다. `Z`를 붙여 UTC로 고정하면 필드값(연·월·일·시)이
/// 그대로 KST 벽시계가 되고, [nowKst]와 같은 기준이 되어 비교가 정확해진다.
/// 기준이 어긋나면 예보 필터가 기기 타임존만큼 통째로 밀린다.
///
/// Returns: KST 벽시계 [DateTime], 읽을 수 없으면 null
DateTime? parseKstDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final asKst = DateTime.tryParse('${raw}Z');
  if (asKst != null) return asKst;
  // Falls back when the server starts sending an explicit offset.
  // 서버가 나중에 오프셋을 붙이면 위 파싱이 실패한다. 정상 파싱 후 KST로 옮긴다.
  return DateTime.tryParse(raw)?.toUtc().add(const Duration(hours: 9));
}

/// 지금을 KST 벽시계로. [parseKstDateTime] 결과와 같은 기준이다.
DateTime nowKst() => DateTime.now().toUtc().add(const Duration(hours: 9));

/// 시간대별 예보 한 칸.
@freezed
class HourlyForecastEntity with _$HourlyForecastEntity {
  const HourlyForecastEntity._();

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

  /// 표시 라벨 — 비·눈이 오면 강수 형태, 아니면 하늘 상태.
  ///
  /// 매핑에 실패해도 서버 원문이 그대로 나온다.
  String get conditionLabel =>
      (precipitation?.isFalling ?? false) ? precipitationLabel : skyLabel;
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
  /// **주의**: [now]는 [nowKst]로 만든 KST 벽시계여야 한다. 기기 로컬 시각을
  /// 넘기면 타임존만큼 어긋난다. 정각이 딱 맞는 예보는 지금 유효한 값이므로
  /// 남긴다.
  List<HourlyForecastEntity> upcomingFrom(DateTime now) =>
      hourlyForecast.where((f) => !f.dateTime.isBefore(now)).toList();
}
