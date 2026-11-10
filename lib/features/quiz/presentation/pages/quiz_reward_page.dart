import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/catalog_image.dart';
import '../../../../router/route_paths.dart';
import '../../../collection/domain/entities/catalog_summary_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
import '../providers/quiz_session_provider.dart';
import '../quiz_messages.dart';
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
    final session = ref.watch(quizSessionProvider);
    final result = session?.result;
    if (session == null || result == null) {
      // 세션 없이 들어오면(앱 재시작 등) 촬영 화면으로 보낸다.
      // No session (e.g. app restart): go back to the scan screen.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RoutePaths.scan);
      });
      return const Scaffold(backgroundColor: AppColors.canvas);
    }

    final collectedId = result.collectedCatalogItemId;
    String? name;
    for (final choice in session.quiz.choices) {
      if (choice.catalogItemId == collectedId) name = choice.name;
    }

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: _RewardBody(
          category: session.category,
          name: name,
          collectedId: collectedId,
          alreadyCollected: session.alreadyCollected,
        ),
      ),
    );
  }
}

class _RewardBody extends ConsumerWidget {
  const _RewardBody({
    required this.category,
    required this.name,
    required this.collectedId,
    required this.alreadyCollected,
  });

  final DogamCategory category;
  final String? name;
  final String? collectedId;
  final bool alreadyCollected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 게스트는 토큰이 없다. catalogSummaryProvider를 부르면 401을 만나고
    // 인증 인터셉터가 이를 "세션 만료"로 오인해 강제 로그아웃시킨다(56e947b).
    // 그래서 게스트는 진행률 줄 자체를 그리지 않는다.
    final isGuest = ref.watch(guestRestrictedProvider);

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
              SizedBox(height: AppSpacing.md.h),
              // 마스코트 에셋이 없으면 자리 자체를 차지하지 않는다.
              Image.asset(
                AppAssets.celebrateMascot,
                width: 120.w,
                height: 120.w,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              SizedBox(height: AppSpacing.md.h),
              // scale-in 0.8 → 1.0, easeOutBack 400ms — 앱 유일 진입 애니메이션
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: _RewardCard(category: category, name: name),
              ),
              SizedBox(height: AppSpacing.base.h),
              Text(
                alreadyCollected ? rewardAgainMessage : rewardNewMessage,
                style: AppTextStyles.body15.copyWith(color: AppColors.muted),
              ),
              if (!isGuest) ...[
                SizedBox(height: AppSpacing.xl.h),
                const _CollectionProgress(),
              ],
              SizedBox(height: AppSpacing.xxl.h),
              AppButton(
                text: '도감 보러 가기',
                width: double.infinity,
                textStyle: AppTextStyles.display17,
                onPressed: () => context.go(
                  collectedId == null
                      ? RoutePaths.collection
                      : RoutePaths.collectionDetail(collectedId!),
                ),
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
  const _RewardCard({required this.category, required this.name});

  final DogamCategory category;
  final String? name;

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
          CatalogImage(category: category, size: 120.w),
          SizedBox(height: AppSpacing.md.h),
          if (name != null) ...[
            Text(
              name!,
              style: AppTextStyles.display19.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: AppSpacing.sm.h),
          ],
          AppBadge.category(category),
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
        SizedBox(height: AppSpacing.sm.h),
        Text(
          '${summary.collectedCount} / ${summary.totalCount} 모았어요',
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
