import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/utils/url_launcher_util.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../router/route_paths.dart';

/// 홈 (HOME-01) — 코스 추천 CTA + 도감 진행률 + 바로가기.
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
              const _HeroCard(),
              SizedBox(height: 14.h),
              const _DogamProgressCard(),
              SizedBox(height: 14.h),
              _LinkRow(
                label: '공원 지도 보기',
                icon: Icons.map_outlined,
                onTap: () => context.go(RoutePaths.map),
              ),
              SizedBox(height: 10.h),
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

/// 코스 추천 히어로 카드 — 앱에서 노랑 CTA가 허용된 두 곳 중 하나.
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘은 어디로 가볼까?',
            style: AppTextStyles.display19.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: 6.h),
          Text(
            '시간·관심사에 맞춰 코스 3개를 추천해요',
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 16.h),
          AppButton.reward(
            text: '코스 추천 받기',
            width: double.infinity,
            height: 52.h,
            // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            onPressed: () => context.push(RoutePaths.courseWizard),
          ),
        ],
      ),
    );
  }
}

/// 도감 진행률 카드 — 탭 시 도감 탭으로 전환.
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

/// 바로가기 row — 지도/공식 사이트.
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
