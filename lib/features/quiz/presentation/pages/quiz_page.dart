import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/catalog_image.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/quiz_question_entity.dart';
import '../providers/quiz_provider.dart';

/// 퀴즈 (QUIZ-02/03) — 3지선다. 오답은 해당 칸만 잠금, 해설 없음.
/// 문항은 `assets/mock/quiz.json`에서 라운드에 맞게 순환한다(설계 문서 §7).
class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  final Set<int> _locked = {};
  bool _answered = false;

  void _select(int index, int answerIndex) {
    if (_answered || _locked.contains(index)) return;
    if (index == answerIndex) {
      setState(() => _answered = true);
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) context.pushReplacement(RoutePaths.quizReward);
      });
    } else {
      setState(() => _locked.add(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(quizQuestionsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '퀴즈'),
      body: questionsAsync.when(
        loading: () => const _LoadingBody(),
        error: (_, _) => const _ErrorBody(),
        data: (questions) {
          if (questions.isEmpty) return const _ErrorBody();
          final round = ref.watch(quizRoundProvider);
          final question = quizQuestionAt(questions, round);
          return _QuizBody(
            question: question,
            locked: _locked,
            answered: _answered,
            onSelect: (index) => _select(index, question.answerIndex),
          );
        },
      ),
    );
  }
}

/// 카테고리 뱃지 → 질문 → 그림 → 3지선다(시안 A안).
///
/// 그림은 컨테이너 없이 크림 배경 위에 화면 폭의 약 70%로 놓는다. 카테고리
/// 뱃지는 그림 위가 아니라 질문 위에 둔다 — 그림을 가리지 않으면서
/// 색+아이콘+라벨 3중 표기를 만족한다.
class _QuizBody extends StatelessWidget {
  const _QuizBody({
    required this.question,
    required this.locked,
    required this.answered,
    required this.onSelect,
  });

  final QuizQuestionEntity question;
  final Set<int> locked;
  final bool answered;
  final void Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).width * 0.7;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.sm.h),
          AppBadge.category(question.category),
          SizedBox(height: AppSpacing.base.h),
          Text(
            question.question,
            style: AppTextStyles.display22.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Center(
            child: CatalogImage(
              code: question.code,
              category: question.category,
              size: imageSize,
            ),
          ),
          SizedBox(height: AppSpacing.xl.h),
          for (var i = 0; i < question.choices.length; i++) _choice(i),
          if (locked.isNotEmpty && !answered)
            Center(
              child: Text(
                '앗, 다시 골라 볼까요?',
                style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
            ),
          SizedBox(height: AppSpacing.xl.h),
        ],
      ),
    );
  }

  Widget _choice(int index) {
    final isLocked = locked.contains(index);
    final correctSelected = answered && index == question.answerIndex;
    final background = isLocked
        ? AppColors.surfaceDim
        : (correctSelected ? AppColors.primaryTint : AppColors.surface);
    final textColor = isLocked
        ? AppColors.uncollected
        : (correctSelected ? AppColors.primaryDark : AppColors.ink);
    final ringColor = isLocked
        ? AppColors.uncollected
        : (correctSelected ? AppColors.primary : AppColors.line);
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            side: isLocked
                ? BorderSide.none
                : BorderSide(
                    color: correctSelected ? AppColors.primary : AppColors.line,
                  ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            onTap: isLocked || answered ? null : () => onSelect(index),
            child: SizedBox(
              height: 60.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.base.w),
                child: Row(
                  children: [
                    _NumberCircle(
                      number: index + 1,
                      ringColor: ringColor,
                      textColor: textColor,
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Expanded(
                      child: Text(
                        question.choices[index],
                        style: AppTextStyles.label16Semibold.copyWith(
                          color: textColor,
                          decoration: isLocked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 선지 번호 원(①②③) — 미선택은 line 테두리, 오답 잠금 시 uncollected로 바뀐다.
class _NumberCircle extends StatelessWidget {
  const _NumberCircle({
    required this.number,
    required this.ringColor,
    required this.textColor,
  });

  final int number;
  final Color ringColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 28.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor),
      ),
      child: Text(
        '$number',
        style: AppTextStyles.tag13Bold.copyWith(color: textColor),
      ),
    );
  }
}

/// 문항 로딩 중 스켈레톤 — 뱃지·질문·그림·보기 3개 자리를 흉내낸다.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).width * 0.7;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      children: [
        SizedBox(height: AppSpacing.sm.h),
        AppSkeleton(
          width: 72.w,
          height: 24.h,
          borderRadius: BorderRadius.circular(AppRadius.xs.r),
        ),
        SizedBox(height: AppSpacing.base.h),
        AppSkeleton(width: double.infinity, height: 28.h),
        SizedBox(height: AppSpacing.lg.h),
        Center(
          child: AppSkeleton(
            width: imageSize,
            height: imageSize,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
          ),
        ),
        SizedBox(height: AppSpacing.xl.h),
        for (var i = 0; i < 3; i++) ...[
          AppSkeleton(
            width: double.infinity,
            height: 60.h,
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
          SizedBox(height: AppSpacing.md.h),
        ],
      ],
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
            Icon(Icons.quiz_outlined, size: 44.w, color: AppColors.muted),
            SizedBox(height: AppSpacing.base.h),
            Text(
              '퀴즈를 불러오지 못했어요',
              style: AppTextStyles.display17.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: AppSpacing.sm.h),
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
