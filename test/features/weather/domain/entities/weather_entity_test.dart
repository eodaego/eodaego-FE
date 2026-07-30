import 'package:clock/clock.dart';
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
  group('parseKstDateTime', () {
    test('reads_offsetless_string_as_kst_wall_clock', () {
      final parsed = parseKstDateTime('2026-07-30T15:00:00')!;

      expect(parsed.year, 2026);
      expect(parsed.month, 7);
      expect(parsed.day, 30);
      expect(parsed.hour, 15);
      // nowKst()와 같은 기준이어야 epoch 비교가 벽시계 비교와 일치한다
      expect(parsed.isUtc, isTrue);
    });

    test('normalizes_offset_bearing_string_to_kst', () {
      // 서버가 나중에 오프셋을 붙여도 조용히 9시간 어긋나지 않는다
      expect(parseKstDateTime('2026-07-30T06:00:00Z')!.hour, 15);
      expect(parseKstDateTime('2026-07-30T15:00:00+09:00')!.hour, 15);
    });

    test('returns_null_when_input_is_missing_or_unparsable', () {
      expect(parseKstDateTime(null), isNull);
      expect(parseKstDateTime(''), isNull);
      expect(parseKstDateTime('내일 오후'), isNull);
    });

    test('returns_null_for_date_only_input_instead_of_device_local_guess', () {
      // 오프셋이 없으니 기기 타임존으로 조용히 해석하지 않고 버린다 —
      // 그러지 않으면 이 값이 기기 타임존에 따라 다른 순간을 가리키게 된다.
      expect(parseKstDateTime('2026-07-30'), isNull);
    });
  });

  group('nowKst', () {
    test('returns_utc_flagged_time_nine_hours_ahead_of_utc', () {
      final utc = DateTime.now().toUtc();
      final kst = nowKst();

      expect(kst.isUtc, isTrue);
      // 같은 순간을 9시간 앞선 벽시계로 표현한다.
      // 오차 허용을 넉넉히 두는 건 이 테스트가 실제 시계를 두 번 읽기 때문이다.
      // 오프셋이 틀리면 시간 단위로 어긋나므로 5초 여유로도 버그는 다 잡힌다.
      expect(
        (kst.difference(utc) - const Duration(hours: 9)).abs(),
        lessThan(const Duration(seconds: 5)),
      );
    });

    test('reads_the_injected_clock_instead_of_the_real_one', () {
      // 여기(순수 Dart 코드, 위젯 빌드 없음)서는 Zone이 정상 전파된다 —
      // withClock이 위젯 빌드까지 닿지 않는 문제와는 별개다.
      final fixed = DateTime.utc(2026, 7, 30, 6);

      final kst = withClock(Clock.fixed(fixed), nowKst);

      expect(kst, fixed.add(const Duration(hours: 9)));
    });
  });

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
