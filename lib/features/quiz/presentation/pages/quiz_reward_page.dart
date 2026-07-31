import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/catalog_image.dart';
import '../../../../router/route_paths.dart';
import '../../../collection/domain/entities/catalog_summary_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
import '../../domain/entities/quiz_question_entity.dart';
import '../providers/quiz_provider.dart';
import '../widgets/confetti_layer.dart';

/// 정답 축하 (QUIZ-05) — 크림 배경 위 컨페티 · 획득 카드 · 수집 진행률.
///
/// **주의**: 카드 안 이름은 조사 없이 독립된 라벨로만 노출한다. `'${name}을
/// 만났어요!'` 같은 문자열 결합을 만들지 않는다 — 모음/자음 받침에 따라
/// 을/를이 갈리는 문제를 구조로 없앤 것이라 여기에 다시 만들면 안 된다.
class QuizRewardPage extends ConsumerWidget {
  const QuizRewardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(quizQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
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

class _RewardBody extends ConsumerWidget {
  const _RewardBody({required this.question});

  final QuizQuestionEntity question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 게스트는 토큰이 없다. catalogSummaryProvider를 부르면 401을 만나고
    // 인증 인터셉터가 이를 "세션 만료"로 오인해 강제 로그아웃시킨다(게스트는
    // 로그인한 적이 없는데도, 56e947b에서 이미 한 번 겪은 버그). 그래서
    // 게스트는 진행률 줄 자체를 그리지 않는다 — _CollectionProgress를 아예
    // 빌드하지 않으므로 그 안의 watch도 실행되지 않는다.
    final isGuest = ref.watch(guestModeProvider);

    // Fire the collect on entry. Guests are excluded — they have no token,
    // and a 401 here would trip the forced-logout path (same guard as below).
    // 진입 시 수집을 발화한다. 게스트 제외 — 토큰이 없어 401이 나면
    // 강제 로그아웃 경로를 탄다(아래 진행률 줄과 같은 가드).
    final code = question.code;
    if (!isGuest && code != null) {
      ref.watch(collectCatalogItemByCodeProvider(code));
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정답이에요!',
                style: AppTextStyles.display26.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: 12.h),
              // 마스코트 에셋이 없으면 자리 자체를 차지하지 않는다.
              Image.asset(
                'assets/images/mascot/celebrate.png',
                width: 120.w,
                height: 120.w,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              SizedBox(height: 12.h),
              // scale-in 0.8 → 1.0, easeOutBack 400ms — 앱 유일 진입 애니메이션
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: _RewardCard(question: question),
              ),
              SizedBox(height: 16.h),
              Text(
                '도감에 새 친구를 등록했어요',
                style: AppTextStyles.body15.copyWith(color: AppColors.muted),
              ),
              if (!isGuest) ...[
                SizedBox(height: 24.h),
                const _CollectionProgress(),
              ],
              SizedBox(height: 32.h),
              AppButton(
                text: '도감 보러 가기',
                width: double.infinity,
                textStyle: AppTextStyles.display17,
                onPressed: () => context.go(RoutePaths.collection),
              ),
            ],
          ),
        ),
        // 컨텐츠 위로 떨어지는 전면 오버레이라 Stack의 마지막 자식이어야 한다.
        const Positioned.fill(child: ConfettiLayer()),
      ],
    );
  }
}

/// 획득 카드 — 흰 카드 하나(radius lg)에 그림 + 이름 + 카테고리 뱃지.
/// 카드를 카드로 감싸지 않는다.
class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.question});

  final QuizQuestionEntity question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.base.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Column(
        children: [
          CatalogImage(
            code: question.code,
            category: question.category,
            size: 120.w,
          ),
          SizedBox(height: 12.h),
          Text(
            question.name,
            style: AppTextStyles.display19.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: 8.h),
          AppBadge.category(question.category),
        ],
      ),
    );
  }
}

/// 수집 진행률 — 게이지(채움 reward) + `N / M 모았어요`.
/// 게스트일 때는 부모(`_RewardBody`)가 이 위젯 자체를 빌드하지 않는다.
class _CollectionProgress extends ConsumerWidget {
  const _CollectionProgress();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(catalogSummaryProvider);

    return summaryAsync.when(
      loading: () => AppSkeleton(
        width: double.infinity,
        height: 10.h,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      // 부가 정보라 실패해도 화면 전체를 막지 않고 조용히 생략한다.
      error: (_, _) => const SizedBox.shrink(),
      data: (summary) => _CollectionProgressGauge(summary: summary),
    );
  }
}

class _CollectionProgressGauge extends StatelessWidget {
  const _CollectionProgressGauge({required this.summary});

  final CatalogSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            minHeight: 10.h,
            // 서버가 반올림한 백분율을 그대로 쓴다
            value: summary.collectionRate / 100,
            backgroundColor: AppColors.surfaceDim,
            color: AppColors.reward,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '${summary.collectedCount} / ${summary.totalCount} 모았어요',
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
      ],
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
              color: AppColors.muted,
            ),
            SizedBox(height: 16.h),
            Text(
              '결과를 불러오지 못했어요',
              style: AppTextStyles.display17.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: 8.h),
            Text(
              '잠시 후 다시 시도해 주세요',
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
