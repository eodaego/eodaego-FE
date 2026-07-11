import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/mock/mock_park_status.dart';
import '../../../../core/utils/url_launcher_util.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../router/route_paths.dart';

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
                    style: AppTextStyles.display19
                        .copyWith(color: AppColors.ink),
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
              const _ParkStatusBar(),
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

/// 오늘 공원 상태 — 날씨 + 혼잡도 한 줄 바.
class _ParkStatusBar extends StatelessWidget {
  const _ParkStatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(mockParkStatus.weatherIcon, size: 22.w, color: AppColors.muted),
          SizedBox(width: 8.w),
          Text(
            '${mockParkStatus.weatherLabel} ${mockParkStatus.temperatureC}°',
            style:
                AppTextStyles.label16Semibold.copyWith(color: AppColors.ink),
          ),
          const Spacer(),
          Text(
            '지금 공원',
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(width: 8.w),
          AppBadge(
            label: mockParkStatus.congestion.label,
            background: mockParkStatus.congestion.badgeBackground,
            foreground: mockParkStatus.congestion.badgeForeground,
          ),
        ],
      ),
    );
  }
}

/// 오늘의 추천 코스 프리뷰 — 탭/CTA 모두 지도 탭 이동 (게이트 없음, 스펙 §4.2).
class _CoursePreviewCard extends StatelessWidget {
  const _CoursePreviewCard();

  @override
  Widget build(BuildContext context) {
    // 지도 초기 선택 코스와 동일 (진입 일관성)
    final course = mockCourses.first;
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
                style: AppTextStyles.display16
                    .copyWith(color: AppColors.primaryDark),
              ),
              SizedBox(height: 8.h),
              Text(
                course.title,
                style:
                    AppTextStyles.display19.copyWith(color: AppColors.ink),
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

/// 도감 진행률 카드 — 탭 시 도감 탭으로 전환. (기존 유지)
class _DogamProgressCard extends StatelessWidget {
  const _DogamProgressCard();

  @override
  Widget build(BuildContext context) {
    final counts = {
      for (final c in DogamCategory.values)
        c: mockDogamItems
            .where((e) => e.category == c && e.collected)
            .length,
    };
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '나의 도감',
                    style: AppTextStyles.display16
                        .copyWith(color: AppColors.ink),
                  ),
                  const Spacer(),
                  AppBadge(
                    label: '$mockDogamCollected/$mockDogamTotal',
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
                  value: mockDogamCollected / mockDogamTotal,
                  backgroundColor: AppColors.primaryTint,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  for (final c in DogamCategory.values) ...[
                    AppBadge.category(c, label: '${c.label} ${counts[c]}'),
                    if (c != DogamCategory.values.last) SizedBox(width: 8.w),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
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
                style: AppTextStyles.label16Semibold
                    .copyWith(color: AppColors.ink),
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
