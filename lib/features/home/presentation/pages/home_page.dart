import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/utils/kst_clock.dart';
import '../../../../core/utils/url_launcher_util.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/weather_icons.dart';
import '../../../../router/route_paths.dart';
import '../../../collection/domain/entities/catalog_summary_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
import '../../../weather/domain/entities/weather_entity.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

/// 홈 (A안) — 날씨·혼잡도 바 + 오늘의 추천 코스 프리뷰 + 도감 요약 + 공식 사이트.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '어대GO',
                    style: AppTextStyles.display19.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push(RoutePaths.mypage),
                    tooltip: '내 정보',
                    icon: Icon(
                      Icons.account_circle_outlined,
                      size: 28.w,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              const _WeatherCard(),
              SizedBox(height: 14.h),
              const _CoursePreviewCard(),
              SizedBox(height: 14.h),
              const _DogamProgressCard(),
              SizedBox(height: 14.h),
              _LinkRow(
                label: '공식 사이트',
                icon: Icons.open_in_new,
                onTap: () => launchExternalUrl(AppUrls.parkOfficialSite),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// 오늘 공원 날씨 카드 — 탭하면 상세로 간다.
///
/// 하단에 혼잡도 한 줄을 함께 보여준다. 미세먼지는 서버 API가 없어 넣지 않는다.
/// 실데이터 옆에 목업을 두면 카드 전체의 신뢰가 깎인다.
class _WeatherCard extends ConsumerWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Guest has no token; calling would 401 and the interceptor would misread
    // it as an expired session and force-log-out. Debug-only path.
    // 게스트는 토큰이 없다. 호출하면 401이 나고 인터셉터가 세션 만료로 오인해
    // 강제 로그아웃시킨다(도감 요약이 겪은 그 버그). 디버그 전용 경로다.
    if (ref.watch(guestModeProvider)) return const SizedBox.shrink();

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: () => context.push(RoutePaths.weather),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ref
              .watch(currentWeatherProvider)
              .when(
                loading: () => const _WeatherCardSkeleton(),
                // 홈에는 다른 콘텐츠가 있다. 카드 안에서만 조용히 알린다.
                error: (_, _) => Row(
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 22.w,
                      color: AppColors.muted,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '날씨를 불러오지 못했어요',
                      style: AppTextStyles.body15.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                data: (weather) => _WeatherCardData(weather: weather),
              ),
        ),
      ),
    );
  }
}

/// 날씨 카드 본문 — 아이콘 + 조건 라벨 + 큰 기온, 아래 오늘 최고/최저·습도 한 줄.
///
/// 최고/최저는 [WeatherEntity.todayRange]가 null이면(오늘 슬롯이 없으면) 그
/// 줄 자체를 그리지 않는다 — `0° / 0°`로 거짓 표시하지 않는다.
class _WeatherCardData extends ConsumerWidget {
  const _WeatherCardData({required this.weather});

  final WeatherEntity weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = weather.todayRange(nowKst());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              weatherIcon(
                sky: weather.sky,
                precipitation: weather.precipitation,
              ),
              size: 32.w,
              color: AppColors.primaryDark,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.conditionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label16Semibold.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  Text(
                    '${weather.temperature.round()}°',
                    style: AppTextStyles.display34.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20.w, color: AppColors.muted),
          ],
        ),
        if (range != null) ...[
          SizedBox(height: 10.h),
          Text(
            '최고 ${range.max.round()}° · 최저 ${range.min.round()}° · 습도 ${weather.humidity}%',
            style: AppTextStyles.body15.copyWith(color: AppColors.muted),
          ),
        ],
        // 혼잡도 조회는 503이 정상 시나리오다(AI 서버 불가·수집 데이터 없음).
        // 실패하면 이 줄만 조용히 사라지고 날씨는 그대로 보인다.
        ref
            .watch(currentCongestionProvider)
            .when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (congestion) => Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // 서버가 모르는 등급을 주면 색 분기 없이 라벨만 보여준다.
                        color: congestion.level?.color ?? AppColors.muted,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '지금 공원은 ${congestion.label}',
                      style: AppTextStyles.body15.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

/// 날씨 카드 로딩 — 아이콘·기온 자리만 스켈레톤.
class _WeatherCardSkeleton extends StatelessWidget {
  const _WeatherCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(width: 32.w, height: 32.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeleton(width: 64.w, height: 16.h),
              SizedBox(height: 6.h),
              AppSkeleton(width: 96.w, height: 34.h),
            ],
          ),
        ),
      ],
    );
  }
}

/// 추천 코스 카드 — 코스 씬 이미지 + 코스명 + CTA. 탭/CTA 모두 지도 탭 이동
/// (게이트 없음, 스펙 §4.2).
class _CoursePreviewCard extends ConsumerWidget {
  const _CoursePreviewCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 지도·추천과 공유하는 선택 코스 (진입 일관성 — 스펙 §6)
    final course = ref.watch(selectedCourseProvider);
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: () => course == null
            ? context.push(RoutePaths.courseRecommend)
            : context.go(RoutePaths.map),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // errorBuilder는 Image의 width/height를 물려받지 않는다 — 에셋이
              // 없으면(데모 당일 가능) 진짜로 자리를 차지하지 않고 텍스트만
              // 남는다. AspectRatio로 감싸면 이 collapse가 깨진다.
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                child: Image.asset(
                  'assets/images/course/today.png',
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                // 아직 고른 코스가 없다. 가짜 코스를 보여주지 않고 추천으로 유도한다.
                course?.title ?? '오늘 갈 코스를 골라볼까요?',
                style: AppTextStyles.display19.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: 16.h),
              AppButton.reward(
                text: course == null ? '코스 추천받기' : '코스 보기',
                width: double.infinity,
                height: 52.h,
                // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                onPressed: () => course == null
                    ? context.push(RoutePaths.courseRecommend)
                    : context.go(RoutePaths.map),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 도감 진행률 카드 — 탭 시 도감 탭으로 전환.
class _DogamProgressCard extends ConsumerWidget {
  const _DogamProgressCard();

  // Guest has no token. If this card called the summary API without auth it
  // would hit a 401, which the interceptor misreads as "session expired" and
  // force-logs-out a guest who was never logged in. So guests render zeros
  // without ever calling the API.
  // 게스트는 토큰이 없다. 인증 없이 이 카드가 요약 API를 부르면 401을 만나고,
  // 인터셉터가 이걸 "세션 만료"로 오인해 강제 로그아웃시킨다(게스트는 로그인한
  // 적이 없는데도). 그래서 게스트는 요청 자체를 하지 않고 0으로 그린다.
  static const _guestSummary = CatalogSummaryEntity(
    totalCount: 0,
    collectedCount: 0,
    collectionRate: 0,
    collectedByCategory: {},
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(guestModeProvider);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: () => context.go(RoutePaths.collection),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: isGuest
              ? _DogamProgressData(summary: _guestSummary)
              : ref
                    .watch(catalogSummaryProvider)
                    .when(
                      loading: () => const _DogamProgressSkeleton(),
                      // 홈에는 다른 콘텐츠가 있다. 카드 안에서만 조용히 알린다.
                      // 제목 Row는 유지해 카드 틀이 무너지지 않게 한다.
                      error: (_, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '내 도감',
                            style: AppTextStyles.display16.copyWith(
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '수집 현황을 불러오지 못했어요',
                            style: AppTextStyles.body15.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      data: (summary) => _DogamProgressData(summary: summary),
                    ),
        ),
      ),
    );
  }
}

/// 도감 진행률 카드 본문 — 큰 백분율 + `수집/전체` + 게이지(노랑 채움) + 마스코트.
class _DogamProgressData extends StatelessWidget {
  const _DogamProgressData({required this.summary});

  final CatalogSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 도감',
                    style: AppTextStyles.display16.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    // 서버가 반올림한 백분율을 그대로 쓴다
                    '${summary.collectionRate.round()}%',
                    style: AppTextStyles.display34.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${summary.collectedCount} / ${summary.totalCount}',
                    style: AppTextStyles.body15.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            // 마스코트 에셋이 없으면(데모 당일 가능) 자리를 차지하지 않는다.
            Image.asset(
              'assets/images/mascot/celebrate.png',
              width: 64.w,
              height: 64.w,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            minHeight: 10.h,
            value: summary.collectionRate / 100,
            backgroundColor: AppColors.surfaceDim,
            color: AppColors.reward,
          ),
        ),
      ],
    );
  }
}

/// 도감 진행률 카드 로딩 — 제목 줄은 그대로 두고 숫자·게이지만 스켈레톤.
class _DogamProgressSkeleton extends StatelessWidget {
  const _DogamProgressSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 도감',
          style: AppTextStyles.display16.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: 8.h),
        AppSkeleton(width: 96.w, height: 34.h),
        SizedBox(height: 4.h),
        AppSkeleton(width: 64.w, height: 18.h),
        SizedBox(height: 14.h),
        AppSkeleton(
          width: double.infinity,
          height: 10.h,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ],
    );
  }
}

/// 바로가기 row — 공식 사이트. (기존 유지)
class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.label16Semibold.copyWith(
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Icon(icon, size: 22.w, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
