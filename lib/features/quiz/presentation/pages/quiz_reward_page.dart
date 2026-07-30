import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/dogam_card.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/quiz_question_entity.dart';
import '../providers/quiz_provider.dart';

/// 정답 축하 (QUIZ-05) — 앱에서 노랑이 전면을 덮는 유일한 화면.
/// 텍스트는 전부 rewardDark (페어링 규칙).
class QuizRewardPage extends ConsumerWidget {
  const QuizRewardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(quizQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.reward,
      body: SafeArea(
        child: questionsAsync.when(
          loading: () => const _LoadingBody(),
          error: (_, _) => const _ErrorBody(),
          data: (questions) {
            if (questions.isEmpty) return const _ErrorBody();
            final round = ref.watch(quizRoundProvider);
            return _RewardBody(question: quizQuestionAt(questions, round));
          },
        ),
      ),
    );
  }
}

class _RewardBody extends StatelessWidget {
  const _RewardBody({required this.question});

  final QuizQuestionEntity question;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '${question.name}을 만났어요!',
            style: AppTextStyles.display26.copyWith(
              color: AppColors.rewardDark,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '도감에 새 친구를 등록했어요',
            style: AppTextStyles.body15.copyWith(color: AppColors.rewardDark),
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
                child: DogamCard(
                  category: question.category,
                  // 정답을 맞혀 방금 수집한 항목이라 늘 true.
                  collected: true,
                  name: question.name,
                ),
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
    );
  }
}

/// 문항 로딩 중 스켈레톤.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSkeleton(
            width: 140.w,
            height: 168.h,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
          ),
        ],
      ),
    );
  }
}

/// 문항 로딩 실패 — 화면이 비지 않게 안내 문구를 보인다.
class _ErrorBody extends StatelessWidget {
  const _ErrorBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration_outlined,
              size: 44.w,
              color: AppColors.rewardDark,
            ),
            SizedBox(height: 16.h),
            Text(
              '결과를 불러오지 못했어요',
              style: AppTextStyles.display17.copyWith(
                color: AppColors.rewardDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
