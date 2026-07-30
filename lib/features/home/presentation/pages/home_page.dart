import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/utils/url_launcher_util.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/weather_icons.dart';
import '../../../../router/route_paths.dart';
import '../../../collection/domain/entities/catalog_summary_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
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
              const _WeatherBar(),
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

/// 오늘 공원 날씨 — 탭하면 상세로 간다.
///
/// 혼잡도는 서버 API가 없어 넣지 않는다. 실데이터 옆에 목업을 두면 바 전체의
/// 신뢰가 깎이고, 뱃지를 눌러도 날씨가 뜨는 어긋남이 생긴다.
class _WeatherBar extends ConsumerWidget {
  const _WeatherBar();

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
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        onTap: () => context.push(RoutePaths.weather),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: ref
              .watch(currentWeatherProvider)
              .when(
                loading: () => Row(
                  children: [
                    AppSkeleton(width: 22.w, height: 22.w),
                    SizedBox(width: 8.w),
                    AppSkeleton(width: 96.w, height: 20.h),
                  ],
                ),
                // 홈에는 다른 콘텐츠가 있다. 바 안에서만 조용히 알린다.
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
                data: (weather) => Row(
                  children: [
                    Icon(
                      weatherIcon(
                        sky: weather.sky,
                        precipitation: weather.precipitation,
                      ),
                      size: 22.w,
                      color: AppColors.muted,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        // 아이 동반 나들이 앱이라 소수점은 읽는 부담만 된다.
                        // 원본 값은 상세 화면에 있다.
                        '${weather.conditionLabel} ${weather.temperature.round()}°',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label16Semibold.copyWith(
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20.w,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}

/// 오늘의 추천 코스 프리뷰 — 탭/CTA 모두 지도 탭 이동 (게이트 없음, 스펙 §4.2).
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
        onTap: () => context.go(RoutePaths.map),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘의 추천 코스',
                style: AppTextStyles.display16.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                course.title,
                style: AppTextStyles.display19.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  AppBadge.category(course.category, label: course.tagLabel),
                  SizedBox(width: 6.w),
                  AppBadge(
                    label: course.durationLabel,
                    background: AppColors.surfaceDim,
                    foreground: AppColors.muted,
                  ),
                  SizedBox(width: 6.w),
                  AppBadge(
                    label: '${course.places.length}곳',
                    background: AppColors.surfaceDim,
                    foreground: AppColors.muted,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              AppButton.reward(
                text: '코스 보러 가기',
                width: double.infinity,
                height: 52.h,
                // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                onPressed: () => context.go(RoutePaths.map),
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
                            '나의 도감',
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

/// 도감 진행률 카드 본문 — 제목 + 뱃지 + 게이지 + 카테고리별 카운트.
class _DogamProgressData extends StatelessWidget {
  const _DogamProgressData({required this.summary});

  final CatalogSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '나의 도감',
              style: AppTextStyles.display16.copyWith(color: AppColors.ink),
            ),
            const Spacer(),
            AppBadge(
              label: '${summary.collectedCount}/${summary.totalCount}',
              background: AppColors.primaryTint,
              foreground: AppColors.primaryDark,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            minHeight: 10.h,
            // 서버가 반올림한 백분율을 그대로 쓴다
            value: summary.collectionRate / 100,
            backgroundColor: AppColors.primaryTint,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            for (final c in DogamCategory.values) ...[
              AppBadge.category(
                c,
                label: '${c.label} ${summary.collectedByCategory[c] ?? 0}',
              ),
              if (c != DogamCategory.values.last) SizedBox(width: 8.w),
            ],
          ],
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
        Row(
          children: [
            Text(
              '나의 도감',
              style: AppTextStyles.display16.copyWith(color: AppColors.ink),
            ),
            const Spacer(),
            AppSkeleton(width: 52.w, height: 22.h),
          ],
        ),
        SizedBox(height: 12.h),
        AppSkeleton(
          width: double.infinity,
          height: 10.h,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              AppSkeleton(width: 64.w, height: 24.h),
              if (i < 2) SizedBox(width: 8.w),
            ],
          ],
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
