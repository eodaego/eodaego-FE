import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/utils/kst_clock.dart';
import '../../../../core/widgets/weather_icons.dart';
import '../../domain/entities/weather_entity.dart';
import '../providers/weather_provider.dart';

/// 날씨 상세 — 현재 상태 + 지금 이후 시간대별 예보.
///
/// 홈 상단 바에서 push로 들어온다. 같은 provider를 보므로 재요청이 없다.
class WeatherDetailPage extends ConsumerWidget {
  const WeatherDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '날씨'),
      body: ref
          .watch(currentWeatherProvider)
          .when(
            loading: () => const _LoadingBody(),
            error: (_, _) => _ErrorBody(
              onRetry: () => ref.invalidate(currentWeatherProvider),
            ),
            data: (weather) => _WeatherBody(weather: weather),
          ),
    );
  }
}

/// 본문 — 현재 상태 카드 + 날짜별 예보 목록.
class _WeatherBody extends StatelessWidget {
  const _WeatherBody({required this.weather});

  final WeatherEntity weather;

  @override
  Widget build(BuildContext context) {
    final now = nowKst();
    final upcoming = weather.upcomingFrom(now);
    final entries = _buildEntries(upcoming, now);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      // 현재 상태 카드 1 + (예보가 없으면 안내 1, 있으면 항목 수)
      itemCount: 1 + (entries.isEmpty ? 1 : entries.length),
      itemBuilder: (context, index) {
        if (index == 0) return _CurrentCard(weather: weather);
        if (entries.isEmpty) return const _EmptyForecast();

        final entry = entries[index - 1];
        return entry.forecast == null
            ? _DayHeader(label: entry.label!)
            : _ForecastRow(forecast: entry.forecast!);
      },
    );
  }
}

/// 현재 상태 카드 — 큰 아이콘, 라벨, 기온(원본), 습도·바람, 관측 시각.
class _CurrentCard extends StatelessWidget {
  const _CurrentCard({required this.weather});

  final WeatherEntity weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSpacing.sm.h, bottom: AppSpacing.sm.h),
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                weatherIcon(
                  sky: weather.sky,
                  precipitation: weather.precipitation,
                ),
                size: 44.w,
                color: AppColors.primaryDark,
              ),
              SizedBox(width: 14.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.conditionLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.display19.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${weather.temperature}°',
                      style: AppTextStyles.display26.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.base.h),
          Row(
            children: [
              _Metric(label: '습도', value: '${weather.humidity}%'),
              SizedBox(width: AppSpacing.xl.w),
              _Metric(label: '바람', value: '${weather.windSpeed}m/s'),
            ],
          ),
          if (weather.observedAt != null) ...[
            SizedBox(height: AppSpacing.md.h),
            Text(
              '${_hourLabel(weather.observedAt!)} 기준',
              style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

/// 습도·바람 한 칸.
class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
        ),
        SizedBox(width: 6.w),
        Text(
          value,
          style: AppTextStyles.label16Semibold.copyWith(color: AppColors.ink),
        ),
      ],
    );
  }
}

/// 날짜 구분선.
class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.base.h, bottom: AppSpacing.sm.h),
      child: Text(
        label,
        style: AppTextStyles.display16.copyWith(color: AppColors.primaryDark),
      ),
    );
  }
}

/// 예보 한 줄 — 시각 · 아이콘 · 기온 · 강수 확률.
class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.forecast});

  final HourlyForecastEntity forecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      child: Row(
        children: [
          SizedBox(
            width: 48.w,
            child: Text(
              _hourLabel(forecast.dateTime),
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
          ),
          Icon(
            weatherIcon(
              sky: forecast.sky,
              precipitation: forecast.precipitation,
            ),
            size: 20.w,
            color: AppColors.muted,
          ),
          SizedBox(width: AppSpacing.md.w),
          Text(
            '${forecast.temperature.round()}°',
            style: AppTextStyles.label16Semibold.copyWith(color: AppColors.ink),
          ),
          const Spacer(),
          // 81개 중 절반이 0%다. 전부 찍으면 정보가 있는 행이 묻힌다.
          if (forecast.precipitationProbability > 0)
            Text(
              '${forecast.precipitationProbability}%',
              style: AppTextStyles.caption14.copyWith(color: AppColors.place),
            ),
        ],
      ),
    );
  }
}

/// 남은 예보가 없을 때 — 현재 날씨는 그대로 두고 이 자리만 채운다.
class _EmptyForecast extends StatelessWidget {
  const _EmptyForecast();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl.h),
      child: Center(
        child: Text(
          '예보는 잠시 뒤에 볼 수 있어요',
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
      ),
    );
  }
}

/// 로딩 — 현재 카드와 목록 몇 줄을 스켈레톤으로.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      children: [
        SizedBox(height: AppSpacing.sm.h),
        AppSkeleton(
          width: double.infinity,
          height: 160.h,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
        ),
        SizedBox(height: AppSpacing.xl.h),
        for (var i = 0; i < 8; i++) ...[
          AppSkeleton(width: double.infinity, height: 24.h),
          SizedBox(height: AppSpacing.base.h),
        ],
      ],
    );
  }
}

/// 조회 실패 — 상세는 이 화면이 전부라 전체를 덮는다.
class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 44.w, color: AppColors.muted),
            SizedBox(height: AppSpacing.base.h),
            Text(
              '날씨를 불러오지 못했어요',
              style: AppTextStyles.display17.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              '잠시 후 다시 시도해 주세요',
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
            SizedBox(height: AppSpacing.xl.h),
            AppButton(text: '다시 불러오기', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

// ============================================
// List Assembly (목록 조립)
// ============================================

/// 날짜 헤더 또는 예보 한 줄. 둘을 평탄한 리스트로 섞어 `ListView.builder`에
/// 넘기면 그룹핑 상태를 따로 들 필요가 없다.
class _Entry {
  const _Entry.header(this.label) : forecast = null;
  const _Entry.forecast(this.forecast) : label = null;

  final String? label;
  final HourlyForecastEntity? forecast;
}

List<_Entry> _buildEntries(List<HourlyForecastEntity> items, DateTime now) {
  final entries = <_Entry>[];
  DateTime? lastDay;
  for (final forecast in items) {
    final day = _dayOf(forecast.dateTime);
    if (lastDay != day) {
      entries.add(_Entry.header(_dayLabel(day, now)));
      lastDay = day;
    }
    entries.add(_Entry.forecast(forecast));
  }
  return entries;
}

// Truncates to the date. KST wall-clock values are UTC-flagged, so building
// the day marker with DateTime.utc keeps both sides comparable.
// 날짜만 남긴다. KST 벽시계 값은 UTC 플래그를 달고 있으므로 날짜 표식도
// DateTime.utc로 만들어야 `==` 비교가 성립한다.
DateTime _dayOf(DateTime at) => DateTime.utc(at.year, at.month, at.day);

/// 날짜 헤더 문구. 오늘·내일만 그렇게 부르고 그 뒤는 날짜로 쓴다.
/// "모레"·"글피"는 헷갈린다.
String _dayLabel(DateTime day, DateTime now) {
  final diff = day.difference(_dayOf(now)).inDays;
  if (diff == 0) return '오늘';
  if (diff == 1) return '내일';
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return '${day.month}월 ${day.day}일 (${weekdays[day.weekday - 1]})';
}

/// 시각 문구 — `15시`.
String _hourLabel(DateTime at) => '${at.hour}시';
