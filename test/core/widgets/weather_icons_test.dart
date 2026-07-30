import 'package:eodaego/core/widgets/weather_icons.dart';
import 'package:eodaego/features/weather/domain/entities/weather_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('weatherIcon', () {
    test('prefers_precipitation_icon_over_sky_icon', () {
      // 비가 오는데 해가 뜨면 안 된다
      final icon = weatherIcon(
        sky: WeatherSky.clear,
        precipitation: WeatherPrecipitation.rain,
      );

      expect(icon, isNot(Icons.wb_sunny_outlined));
      expect(icon, Icons.umbrella);
    });

    test('uses_sky_icon_when_nothing_is_falling', () {
      expect(
        weatherIcon(
          sky: WeatherSky.clear,
          precipitation: WeatherPrecipitation.none,
        ),
        Icons.wb_sunny_outlined,
      );
      expect(
        weatherIcon(
          sky: WeatherSky.partlyCloudy,
          precipitation: WeatherPrecipitation.none,
        ),
        Icons.wb_cloudy_outlined,
      );
      expect(
        weatherIcon(
          sky: WeatherSky.cloudy,
          precipitation: WeatherPrecipitation.none,
        ),
        Icons.cloud_outlined,
      );
    });

    test('uses_sky_icon_when_precipitation_mapping_is_unknown', () {
      // 강수 표기가 바뀌어도 하늘 상태로 그릴 수 있으면 그린다
      expect(
        weatherIcon(sky: WeatherSky.clear, precipitation: null),
        Icons.wb_sunny_outlined,
      );
    });

    test('falls_back_to_question_mark_when_nothing_is_known', () {
      expect(weatherIcon(), Icons.help_outline);
      expect(weatherIcon(sky: null, precipitation: null), Icons.help_outline);
    });

    test('maps_every_falling_precipitation_type_to_its_own_icon', () {
      // 모든 강수 종류가 고유한 아이콘으로 매핑되는지 확인
      // (sky를 넘겨서 강수 우선도 함께 검증)
      expect(
        weatherIcon(
          sky: WeatherSky.clear,
          precipitation: WeatherPrecipitation.sleet,
        ),
        Icons.cloudy_snowing,
      );
      expect(
        weatherIcon(
          sky: WeatherSky.clear,
          precipitation: WeatherPrecipitation.snow,
        ),
        Icons.ac_unit,
      );
      expect(
        weatherIcon(
          sky: WeatherSky.clear,
          precipitation: WeatherPrecipitation.shower,
        ),
        Icons.grain,
      );
    });
  });
}
