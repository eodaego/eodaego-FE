import 'package:eodaego/core/utils/kst_clock.dart';
import 'package:eodaego/features/weather/domain/entities/weather_condition.dart';
import 'package:eodaego/features/weather/domain/entities/weather_entity.dart';
import 'package:flutter_test/flutter_test.dart';

// Builds an entity whose forecast slots are the given KST timestamps.
// 주어진 KST 시각들로 예보를 채운 엔티티를 만든다.
WeatherEntity _weatherAt(List<String> hours) => WeatherEntity(
  temperature: 27.6,
  humidity: 78,
  windSpeed: 1.7,
  skyLabel: '구름많음',
  precipitationLabel: '없음',
  sky: WeatherSky.partlyCloudy,
  precipitation: WeatherPrecipitation.none,
  hourlyForecast: [
    for (final hour in hours)
      HourlyForecastEntity(
        dateTime: parseKstDateTime(hour)!,
        temperature: 27,
        precipitationProbability: 20,
        skyLabel: '구름많음',
        precipitationLabel: '없음',
      ),
  ],
);

void main() {
  group('upcomingFrom', () {
    test('drops_forecasts_that_already_passed', () {
      // 서버는 발표 기준 전체를 준다. 새벽 2시에 0시 예보가 맨 앞에 온다.
      final weather = _weatherAt([
        '2026-07-30T00:00:00',
        '2026-07-30T01:00:00',
        '2026-07-30T02:00:00',
      ]);

      final upcoming = weather.upcomingFrom(
        parseKstDateTime('2026-07-30T01:30:00')!,
      );

      expect(upcoming.map((f) => f.dateTime.hour), [2]);
    });

    test('keeps_forecast_whose_hour_matches_now_exactly', () {
      // 15:00:00에 보는 15시 예보는 지금 유효한 값이다
      final weather = _weatherAt([
        '2026-07-30T15:00:00',
        '2026-07-30T16:00:00',
      ]);

      final upcoming = weather.upcomingFrom(
        parseKstDateTime('2026-07-30T15:00:00')!,
      );

      expect(upcoming.map((f) => f.dateTime.hour), [15, 16]);
    });

    test('returns_empty_when_every_forecast_is_in_the_past', () {
      final weather = _weatherAt(['2026-07-30T00:00:00']);

      expect(
        weather.upcomingFrom(parseKstDateTime('2026-07-31T00:00:00')!),
        isEmpty,
      );
    });

    test('keeps_forecasts_spanning_multiple_days_in_order', () {
      final weather = _weatherAt([
        '2026-07-30T23:00:00',
        '2026-07-31T00:00:00',
        '2026-08-01T00:00:00',
      ]);

      final upcoming = weather.upcomingFrom(
        parseKstDateTime('2026-07-30T22:00:00')!,
      );

      expect(upcoming.map((f) => f.dateTime.day), [30, 31, 1]);
    });
  });

  group('conditionLabel', () {
    test('prefers_precipitation_over_sky_when_something_is_falling', () {
      // 비가 오는데 `흐림`이라고 쓰면 정보가 줄어든다.
      // WeatherEntity.conditionLabel을 검증한다 — 실제로 화면에 렌더되는
      // 쪽은 이것뿐이고, HourlyForecastEntity에는 더 이상 같은 getter가 없다.
      final weather = WeatherEntity(
        temperature: 27,
        humidity: 78,
        windSpeed: 1.7,
        skyLabel: '흐림',
        precipitationLabel: '비',
        sky: WeatherSky.cloudy,
        precipitation: WeatherPrecipitation.rain,
        hourlyForecast: const [],
      );

      expect(weather.conditionLabel, '비');
    });

    test('falls_back_to_sky_label_when_nothing_is_falling', () {
      final weather = _weatherAt([]);

      // `없음`을 라벨로 쓰지 않는다
      expect(weather.conditionLabel, '구름많음');
    });

    test('shows_raw_server_label_when_mapping_is_unknown', () {
      // 서버 표기가 바뀌어도 화면이 비지 않는다
      final weather = WeatherEntity(
        temperature: 27.6,
        humidity: 78,
        windSpeed: 1.7,
        skyLabel: '짙은안개',
        precipitationLabel: '없음',
        hourlyForecast: const [],
      );

      expect(weather.conditionLabel, '짙은안개');
    });
  });
}
