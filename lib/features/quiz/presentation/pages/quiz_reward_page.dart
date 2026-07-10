import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/dogam_card.dart';
import '../../../../router/route_paths.dart';

/// 정답 축하 (QUIZ-05) — 앱에서 노랑이 전면을 덮는 유일한 화면.
/// 텍스트는 전부 rewardDark (페어링 규칙).
class QuizRewardPage extends StatelessWidget {
  const QuizRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.reward,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration_outlined,
                size: 56.w,
                color: AppColors.rewardDark,
              ),
              SizedBox(height: 16.h),
              Text(
                '${mockQuizItem.name}을 만났어요!',
                style: AppTextStyles.display26
                    .copyWith(color: AppColors.rewardDark),
              ),
              SizedBox(height: 8.h),
              Text(
                '도감에 새 친구 등록',
                style: AppTextStyles.body15
                    .copyWith(color: AppColors.rewardDark),
              ),
              SizedBox(height: 24.h),
              // scale-in 0.8 → 1.0, easeOutBack 400ms — 앱 유일 진입 애니메이션
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg.r),
                  ),
                  child: SizedBox(
                    width: 140.w,
                    height: 168.h,
                    child: DogamCard(item: mockQuizItem),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              AppButton(
                text: '도감 보러 가기',
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.rewardDark,
                textStyle: AppTextStyles.display17,
                width: double.infinity,
                onPressed: () => context.go(RoutePaths.collection),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
