import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
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

/// 홈 날씨 칩 — 게스트 가드 위치와 성공/실패 상태를 구분한다.
/// `valueOrNull`은 provider 에러를 던지지 않고 null로 접으므로 "예외 없음"만으로는
/// 게이트가 실제로 provider watch보다 먼저 실행됐는지 증명하지 못한다 — 이 파일은
/// 렌더된 텍스트로 직접 검증한다.

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

/// 실제 Firebase/보안저장소를 타지 않고 초기 상태만 세팅하는 테스트용 Notifier.
/// (test/router/app_router_redirect_test.dart와 동일한 shape)
class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(this._initial);

  final AuthResultEntity? _initial;

  @override
  Future<AuthResultEntity?> build() async => _initial;
}

Widget _wrap(List<Override> overrides) => ProviderScope(
  overrides: [
    // 홈 인사말이 닉네임을 읽는다 — 실제 인증 초기화를 타지 않게 막는다.
    authNotifierProvider.overrideWith(() => _TestAuthNotifier(null)),
    ...overrides,
  ],
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
  group('HomePage 날씨 칩', () {
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

    testWidgets('조회에 성공하면 조건 라벨과 반올림한 기온을 한 칩에 보여준다', (tester) async {
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

      // 홈 레이어 개편 — 날씨 카드가 헤더 칩으로 줄면서 조건 라벨과 기온이 다시
      // 한 Text로 합쳐졌다. 최고/최저·습도 상세는 날씨 화면으로 넘겼다.
      expect(find.text('구름많음 28°'), findsOneWidget);
    });

    testWidgets('조회에 실패해도 예외 없이 날씨 화면으로 가는 칩을 남긴다', (tester) async {
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
      // 홈은 날씨 화면으로 가는 유일한 입구다. 값을 못 받았다고 칩을 지우면
      // 날씨 화면에 영영 못 들어간다 — 라벨만 바꿔 입구를 남긴다.
      expect(find.text('날씨 보기'), findsOneWidget);
    });
  });
}
