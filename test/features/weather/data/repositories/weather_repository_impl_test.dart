import 'package:eodaego/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:eodaego/features/weather/data/models/congestion_model.dart';
import 'package:eodaego/features/weather/data/models/weather_model.dart';
import 'package:eodaego/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:eodaego/features/weather/domain/entities/weather_condition.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크. 내부 협력자는 전부 실제 코드다.
class _FakeWeatherDataSource implements WeatherRemoteDataSource {
  _FakeWeatherDataSource(this.response);

  final WeatherModel response;

  @override
  Future<WeatherModel> getCurrentWeather() async => response;

  @override
  Future<CongestionModel> getCurrentCongestion() async =>
      const CongestionModel();
}

void main() {
  group('getCurrentWeather', () {
    test('maps_server_strings_to_conditions_and_keeps_raw_labels', () async {
      final repository = WeatherRepositoryImpl(
        _FakeWeatherDataSource(
          const WeatherModel(
            temperature: 27.6,
            humidity: 78,
            windSpeed: 1.7,
            skyCondition: '구름많음',
            precipitationType: '없음',
            observedAt: '2026-07-30T00:00:00',
            hourlyForecast: [
              HourlyWeatherModel(
                datetime: '2026-07-30T01:00:00',
                temperature: 26,
                precipitationProbability: 20,
                skyCondition: '구름많음',
                precipitationType: '없음',
              ),
            ],
          ),
        ),
      );

      final weather = await repository.getCurrentWeather();

      expect(weather.temperature, 27.6);
      expect(weather.humidity, 78);
      expect(weather.windSpeed, 1.7);
      expect(weather.sky, WeatherSky.partlyCloudy);
      expect(weather.precipitation, WeatherPrecipitation.none);
      expect(weather.skyLabel, '구름많음');
      // 관측 시각도 KST 벽시계로 읽는다
      expect(weather.observedAt!.hour, 0);
      expect(weather.observedAt!.isUtc, isTrue);
      expect(weather.hourlyForecast.single.dateTime.hour, 1);
      expect(weather.hourlyForecast.single.sky, WeatherSky.partlyCloudy);
    });

    test('keeps_unknown_condition_as_raw_label_without_mapping', () async {
      // 날씨는 항목이 하나뿐이라 도감처럼 제외하면 화면이 통째로 빈다.
      // 매핑만 포기하고 원문은 그대로 넘긴다.
      final repository = WeatherRepositoryImpl(
        _FakeWeatherDataSource(
          const WeatherModel(skyCondition: '짙은안개', precipitationType: '우박'),
        ),
      );

      final weather = await repository.getCurrentWeather();

      expect(weather.sky, isNull);
      expect(weather.precipitation, isNull);
      expect(weather.skyLabel, '짙은안개');
      expect(weather.conditionLabel, '짙은안개');
    });

    test('drops_forecast_slots_whose_time_cannot_be_read', () async {
      final repository = WeatherRepositoryImpl(
        _FakeWeatherDataSource(
          const WeatherModel(
            hourlyForecast: [
              HourlyWeatherModel(datetime: '2026-07-30T01:00:00'),
              HourlyWeatherModel(datetime: '언젠가'),
              HourlyWeatherModel(),
            ],
          ),
        ),
      );

      final weather = await repository.getCurrentWeather();

      // 시각을 모르는 예보는 목록에 놓을 자리가 없다
      expect(weather.hourlyForecast.length, 1);
      expect(weather.hourlyForecast.single.dateTime.hour, 1);
    });
  });
}
