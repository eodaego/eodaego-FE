import 'package:flutter/material.dart';

import '../../domain/entities/weather_condition.dart';

/// 날씨 상태에 맞는 아이콘을 고른다.
///
/// 강수가 하늘 상태보다 우선이다 — 비가 오는데 해가 뜨면 안 된다.
/// `없음`은 내리는 게 없으므로 하늘 상태로 넘어간다.
///
/// **주의**: 매핑을 모르는 값이면 물음표로 떨어진다. 라벨은 호출부가 서버
/// 원문을 그대로 보여주므로 화면이 비지 않는다.
///
/// Returns: 표시할 [IconData]
IconData weatherIcon({WeatherSky? sky, WeatherPrecipitation? precipitation}) {
  if (precipitation != null && precipitation.isFalling) {
    return switch (precipitation) {
      WeatherPrecipitation.rain => Icons.umbrella,
      WeatherPrecipitation.sleet => Icons.cloudy_snowing,
      WeatherPrecipitation.snow => Icons.ac_unit,
      WeatherPrecipitation.shower => Icons.grain,
      // isFalling이 false라 여기 오지 않는다
      WeatherPrecipitation.none => Icons.help_outline,
    };
  }

  return switch (sky) {
    WeatherSky.clear => Icons.wb_sunny_outlined,
    WeatherSky.partlyCloudy => Icons.wb_cloudy_outlined,
    WeatherSky.cloudy => Icons.cloud_outlined,
    null => Icons.help_outline,
  };
}
