import 'package:clock/clock.dart';
import 'package:eodaego/core/utils/kst_clock.dart';
import 'package:eodaego/features/weather/data/datasources/weather_mock_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Fixed on a date well away from the fixture's own 2026-07-30 anchor —
  // if the shift silently no-ops, the fixture's original date survives and
  // these assertions fail instead of accidentally matching.
  // 픽스처 자체 앵커인 2026-07-30과 떨어진 날짜로 고정한다 — 시프트가 조용히
  // no-op이면 픽스처 원본 날짜가 그대로 남아 검증이 우연히 통과하는 일이 없다.
  final fixedToday = DateTime.utc(2026, 9, 15, 6);

  Future<Map<String, dynamic>> loadShifted() => withClock(
    Clock.fixed(fixedToday),
    () => WeatherMockDataSource().getCurrentWeather().then(
      (model) => {
        'temperature': model.temperature,
        'humidity': model.humidity,
        'windSpeed': model.windSpeed,
        'precipitationType': model.precipitationType,
        'skyCondition': model.skyCondition,
        'observedAt': model.observedAt,
        'hourlyForecast': model.hourlyForecast,
      },
    ),
  );

  group('getCurrentWeather', () {
    test('keeps_all_81_forecast_slots', () async {
      final weather = await loadShifted();

      expect((weather['hourlyForecast'] as List).length, 81);
    });

    test('shifts_first_slot_to_todays_kst_date', () async {
      final weather = await loadShifted();
      final forecast = weather['hourlyForecast'] as List;
      final firstDateTime = parseKstDateTime(forecast.first.datetime)!;
      final today = withClock(Clock.fixed(fixedToday), nowKst);

      expect(firstDateTime.year, today.year);
      expect(firstDateTime.month, today.month);
      expect(firstDateTime.day, today.day);
      expect(firstDateTime.hour, 0);
    });

    test('preserves_hour_of_day_distribution_after_shift', () async {
      final weather = await loadShifted();
      final forecast = weather['hourlyForecast'] as List;

      // First 24 slots are one full day (00:00 .. 23:00) in the fixture —
      // the shift must not scramble that.
      // 픽스처의 앞 24개 슬롯은 하루치(00시~23시)다 — 시프트가 이 순서를
      // 흐트러뜨리면 안 된다.
      final hours = forecast
          .take(24)
          .map((f) => parseKstDateTime(f.datetime)!.hour)
          .toList();

      expect(hours, List.generate(24, (h) => h));
    });

    test('shifts_observed_at_together_with_forecast', () async {
      final weather = await loadShifted();
      final observedAt = parseKstDateTime(weather['observedAt'] as String)!;
      final today = withClock(Clock.fixed(fixedToday), nowKst);

      expect(observedAt.year, today.year);
      expect(observedAt.month, today.month);
      expect(observedAt.day, today.day);
      expect(observedAt.hour, 0);
    });

    test('leaves_non_time_fields_unchanged_from_fixture', () async {
      final weather = await loadShifted();
      final forecast = weather['hourlyForecast'] as List;

      expect(weather['temperature'], 27.6);
      expect(weather['humidity'], 78);
      expect(weather['windSpeed'], 1.7);
      expect(weather['precipitationType'], '없음');
      expect(weather['skyCondition'], '구름많음');
      expect(forecast.first.temperature, 27);
      expect(forecast.first.precipitationProbability, 20);
      expect(forecast.first.skyCondition, '구름많음');
    });
  });
}
