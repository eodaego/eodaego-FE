import 'package:eodaego/core/utils/kst_clock.dart';
import 'package:eodaego/features/weather/domain/entities/weather_entity.dart';
import 'package:eodaego/features/weather/domain/repositories/weather_repository.dart';
import 'package:eodaego/features/weather/presentation/pages/weather_detail_page.dart';
import 'package:eodaego/features/weather/presentation/providers/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크.
class _FakeWeatherRepository implements WeatherRepository {
  _FakeWeatherRepository(this.weather);

  final WeatherEntity weather;

  @override
  Future<WeatherEntity> getCurrentWeather() async => weather;
}

// Builds a weather entity whose forecast spans today (two slots — proves the
// header dedup, not just "one header per row"), tomorrow, and the day after.
// Anchored to nowKst() so the test holds regardless of what day it runs on.
//
// The widget re-reads nowKst() itself at build time — a second real-clock
// read, not the same instant used to build this fixture. withClock doesn't
// help here: verified experimentally that Flutter's test binding schedules
// the widget build outside the Zone it creates, so the widget still observed
// the real clock. Falling back to a margin instead, and the margin is a
// tradeoff between two races: too small and a slow pump/settle can push the
// widget's read past the offset (Race A — the slot silently drops out of
// "upcoming"); too large and it risks now+offset rolling into the next
// calendar day when the test happens to run near midnight KST, which
// duplicates a day header (Race B). A pump/settle never takes minutes, so
// 20s/30s closes Race A with enormous headroom while keeping Race B's window
// two orders of magnitude smaller than a minutes-wide margin would.
// Tomorrow/day-after stay noon-anchored so they never collide with a
// midnight boundary at all.
// nowKst() 기준으로 오늘(두 슬롯 — 헤더가 행마다 찍히는 게 아니라 중복 제거되는지
// 증명한다)·내일·모레 슬롯을 만든다. 테스트 실행 날짜와 무관하게 성립하도록 한다.
//
// 위젯은 빌드 시점에 nowKst()를 따로 한 번 더 읽으므로 실제 시계를 두 번 읽는
// 셈이다. withClock은 도움이 안 된다 — Flutter 테스트 바인딩이 위젯 빌드를 그
// Zone 밖에서 스케줄링해 위젯이 여전히 실제 시각을 본다는 걸 실험으로 확인했다.
// 대신 여유(margin)를 둘 수밖에 없는데, 이 여유는 두 레이스의 트레이드오프다 —
// 너무 작으면 느린 pump/settle이 위젯의 읽기를 오프셋 너머로 밀어 슬롯이
// "이후 예보"에서 조용히 빠진다(레이스 A). 너무 크면 자정 근처 실행에서
// now+오프셋이 다음 날짜로 넘어가 날짜 헤더가 중복된다(레이스 B). pump/settle이
// 분 단위로 걸리는 일은 없으므로 20초·30초면 레이스 A는 여유롭게 막으면서
// 레이스 B의 위험 구간은 분 단위 여유보다 두 자릿수 작게 유지한다. 내일·모레는
// 여전히 정오에 고정해 자정 경계와 아예 충돌하지 않는다.
({
  WeatherEntity weather,
  HourlyForecastEntity todayFirst,
  HourlyForecastEntity todaySecond,
  HourlyForecastEntity tomorrow,
  HourlyForecastEntity dayAfter,
})
_buildWeather() {
  final now = nowKst();
  final todayFirst = HourlyForecastEntity(
    dateTime: now.add(const Duration(seconds: 20)),
    temperature: 20,
    precipitationProbability: 0,
    skyLabel: '맑음',
    precipitationLabel: '없음',
  );
  final todaySecond = HourlyForecastEntity(
    dateTime: now.add(const Duration(seconds: 30)),
    temperature: 24,
    precipitationProbability: 33,
    skyLabel: '맑음',
    precipitationLabel: '없음',
  );
  final tomorrow = HourlyForecastEntity(
    dateTime: DateTime.utc(now.year, now.month, now.day + 1, 12),
    temperature: 22,
    precipitationProbability: 45,
    skyLabel: '흐림',
    precipitationLabel: '없음',
  );
  final dayAfter = HourlyForecastEntity(
    dateTime: DateTime.utc(now.year, now.month, now.day + 2, 9),
    temperature: 18,
    precipitationProbability: 10,
    skyLabel: '맑음',
    precipitationLabel: '없음',
  );
  final weather = WeatherEntity(
    temperature: 21.3,
    humidity: 55,
    windSpeed: 2.1,
    skyLabel: '맑음',
    precipitationLabel: '없음',
    hourlyForecast: [todayFirst, todaySecond, tomorrow, dayAfter],
  );
  return (
    weather: weather,
    todayFirst: todayFirst,
    todaySecond: todaySecond,
    tomorrow: tomorrow,
    dayAfter: dayAfter,
  );
}

Widget _wrap(Widget child, WeatherRepository repository) {
  return ProviderScope(
    overrides: [weatherRepositoryProvider.overrideWith((ref) => repository)],
    child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => MaterialApp(home: child),
    ),
  );
}

/// 테스트 기본 뷰(800x600)는 ScreenUtil 기준(393x852)과 달라 레이아웃이 왜곡된다.
void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets(
    'groups_forecast_rows_under_today_tomorrow_and_dated_headers',
    (tester) async {
      _useDesignViewport(tester);
      final built = _buildWeather();

      await tester.pumpWidget(
        _wrap(
          const WeatherDetailPage(),
          _FakeWeatherRepository(built.weather),
        ),
      );
      await tester.pumpAndSettle();

      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final dayAfterDate = built.dayAfter.dateTime;
      final dayAfterLabel =
          '${dayAfterDate.month}월 ${dayAfterDate.day}일 '
          '(${weekdays[dayAfterDate.weekday - 1]})';

      // 오늘 슬롯이 두 개라도 헤더는 한 번만 찍힌다 (dedup 가드 검증) — 지운다면
      // 행마다 헤더가 반복돼도 이 어서션이 깨진다.
      expect(find.text('오늘'), findsOneWidget);
      expect(find.text('내일'), findsOneWidget);
      expect(find.text(dayAfterLabel), findsOneWidget);
      // 오늘의 두 예보 행이 모두 렌더된다 (헤더 중복 제거가 행을 삼키지 않는다).
      expect(find.text('20°'), findsOneWidget);
      expect(find.text('24°'), findsOneWidget);
    },
  );

  testWidgets(
    'hides_zero_percent_precipitation_but_shows_nonzero_rows',
    (tester) async {
      _useDesignViewport(tester);
      final built = _buildWeather();

      await tester.pumpWidget(
        _wrap(
          const WeatherDetailPage(),
          _FakeWeatherRepository(built.weather),
        ),
      );
      await tester.pumpAndSettle();

      // 0%인 오늘 슬롯은 아무 것도 찍지 않는다.
      expect(find.text('0%'), findsNothing);
      // 0보다 큰 슬롯은 값을 보여준다.
      expect(find.text('45%'), findsOneWidget);
      expect(find.text('10%'), findsOneWidget);
    },
  );
}
