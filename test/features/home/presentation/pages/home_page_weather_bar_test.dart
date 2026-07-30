import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/home/presentation/pages/home_page.dart';
import 'package:eodaego/features/weather/domain/entities/weather_condition.dart';
import 'package:eodaego/features/weather/domain/entities/weather_entity.dart';
import 'package:eodaego/features/weather/presentation/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// 홈 날씨 바 — 게스트 가드 위치와 로딩/에러/데이터 3상태를 구분한다.
/// `AsyncValue.when()`은 provider 에러를 던지지 않고 error 브랜치로 보내므로
/// "예외 없음"만으로는 게이트가 실제로 provider watch보다 먼저 실행됐는지
/// 증명하지 못한다 — 이 파일은 렌더된 텍스트로 직접 검증한다.

const _guestSentinelWeather = WeatherEntity(
  temperature: 99.9,
  humidity: 1,
  windSpeed: 0,
  skyLabel: '게스트가드우회감지문자열',
  precipitationLabel: '없음',
  hourlyForecast: [],
);

const _dataWeather = WeatherEntity(
  temperature: 27.6,
  humidity: 60,
  windSpeed: 2.1,
  skyLabel: '구름많음',
  precipitationLabel: '없음',
  hourlyForecast: [],
  sky: WeatherSky.partlyCloudy,
  precipitation: WeatherPrecipitation.none,
);

const _emptyCatalogSummary = CatalogSummaryEntity(
  totalCount: 0,
  collectedCount: 0,
  collectionRate: 0,
  collectedByCategory: {},
);

Widget _wrap(List<Override> overrides) => ProviderScope(
  overrides: overrides,
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: HomePage()),
  ),
);

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('HomePage 날씨 바', () {
    testWidgets('게스트는 날씨 provider가 값을 줘도 그 내용을 보여주지 않는다', (tester) async {
      _useDesignViewport(tester);

      await tester.pumpWidget(
        _wrap([
          guestModeProvider.overrideWith((ref) => true),
          currentWeatherProvider.overrideWith(
            (ref) async => _guestSentinelWeather,
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('게스트가드우회감지문자열'), findsNothing);
    });

    testWidgets('조회에 성공하면 반올림한 기온과 조건 라벨을 보여준다', (tester) async {
      _useDesignViewport(tester);

      await tester.pumpWidget(
        _wrap([
          currentWeatherProvider.overrideWith((ref) async => _dataWeather),
          catalogSummaryProvider.overrideWith(
            (ref) async => _emptyCatalogSummary,
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('구름많음 28°'), findsOneWidget);
    });

    testWidgets('조회에 실패하면 예외 없이 짧은 안내를 보여준다', (tester) async {
      _useDesignViewport(tester);

      await tester.pumpWidget(
        _wrap([
          currentWeatherProvider.overrideWith(
            (ref) async => throw StateError('network down'),
          ),
          catalogSummaryProvider.overrideWith(
            (ref) async => _emptyCatalogSummary,
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('날씨를 불러오지 못했어요'), findsOneWidget);
    });
  });
}
