import 'package:eodaego/features/weather/domain/entities/weather_condition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeatherSky.fromServer', () {
    test('maps_server_strings_to_matching_sky', () {
      expect(WeatherSky.fromServer('맑음'), WeatherSky.clear);
      expect(WeatherSky.fromServer('구름많음'), WeatherSky.partlyCloudy);
      expect(WeatherSky.fromServer('흐림'), WeatherSky.cloudy);
    });

    test('returns_null_when_sky_is_unknown', () {
      // 서버 표기가 바뀌어도 앱이 죽지 않아야 한다. 호출부가 원문을 그대로 쓴다.
      expect(WeatherSky.fromServer('짙은안개'), isNull);
      expect(WeatherSky.fromServer(''), isNull);
      expect(WeatherSky.fromServer(null), isNull);
    });
  });

  group('WeatherPrecipitation.fromServer', () {
    test('maps_server_strings_to_matching_precipitation', () {
      expect(WeatherPrecipitation.fromServer('없음'), WeatherPrecipitation.none);
      expect(WeatherPrecipitation.fromServer('비'), WeatherPrecipitation.rain);
      expect(
        WeatherPrecipitation.fromServer('비/눈'),
        WeatherPrecipitation.sleet,
      );
      expect(WeatherPrecipitation.fromServer('눈'), WeatherPrecipitation.snow);
      expect(
        WeatherPrecipitation.fromServer('소나기'),
        WeatherPrecipitation.shower,
      );
    });

    test('returns_null_when_precipitation_is_unknown', () {
      expect(WeatherPrecipitation.fromServer('우박'), isNull);
      expect(WeatherPrecipitation.fromServer(null), isNull);
    });
  });

  group('WeatherPrecipitation.isFalling', () {
    test('reports_falling_for_every_type_except_none', () {
      // `없음`만 아무것도 안 내린다. 라벨·아이콘이 하늘 상태로 넘어가는 기준이다.
      expect(WeatherPrecipitation.none.isFalling, isFalse);
      expect(WeatherPrecipitation.rain.isFalling, isTrue);
      expect(WeatherPrecipitation.sleet.isFalling, isTrue);
      expect(WeatherPrecipitation.snow.isFalling, isTrue);
      expect(WeatherPrecipitation.shower.isFalling, isTrue);
    });
  });
}
