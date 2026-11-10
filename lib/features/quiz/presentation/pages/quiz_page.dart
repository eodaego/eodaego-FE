import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/catalog_image.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/quiz_entity.dart';
import '../providers/quiz_session_provider.dart';
import '../quiz_messages.dart';

String _questionOf(DogamCategory category) => switch (category) {
  DogamCategory.animal => quizQuestionAnimal,
  DogamCategory.plant => quizQuestionPlant,
  DogamCategory.place => quizQuestionPlace,
};

/// 퀴즈 (QUIZ-02/03) — 서버가 낸 3지선다. 오답은 해당 칸만 잠금, 해설 없음.
/// 세션이 없으면(앱 재시작 등) 촬영 화면으로 보낸다.
class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  bool _submitting = false;

  // 이미 촬영 화면으로 나가는 중이면 세션 없음 리다이렉트를 건너뛴다.
  // Skip the no-session redirect once we are already leaving for scan.
  bool _leaving = false;

  Future<void> _select(String catalogItemId) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final category = ref.read(quizSessionProvider)?.category;
    try {
      final result = await ref
          .read(quizSessionProvider.notifier)
          .answer(catalogItemId);
      if (!mounted) return;
      if (result.correct) {
        // 정답 강조를 잠깐 보여준 뒤 보상 화면으로
        // Brief highlight of the correct choice before the reward screen
        await Future<void>.delayed(const Duration(milliseconds: 250));
        if (mounted) context.pushReplacement(RoutePaths.quizReward);
        return;
      }
    } catch (e) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(content: Text(answerErrorMessage(e))));
      if (e is AppException && e.code == 'QUIZ_NOT_FOUND') {
        _leaving = true;
        ref.read(quizSessionProvider.notifier).clear();
        context.go(RoutePaths.scanWith(category: category));
        return;
      }
    }
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizSessionProvider);
    if (session == null) {
      if (_leaving) return const Scaffold(backgroundColor: AppColors.canvas);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(RoutePaths.scan);
      });
      return const Scaffold(backgroundColor: AppColors.canvas);
    }

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '퀴즈'),
      body: _QuizBody(session: session, busy: _submitting, onSelect: _select),
    );
  }
}

/// 카테고리 뱃지 → 질문 → 찍은 사진 → 3지선다(시안 A안).
class _QuizBody extends StatelessWidget {
  const _QuizBody({
    required this.session,
    required this.busy,
    required this.onSelect,
  });

  final QuizSessionState session;
  final bool busy;
  final void Function(String catalogItemId) onSelect;

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).width * 0.7;
    final answered = session.result != null;
    final path = session.imagePath;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.sm.h),
          AppBadge.category(session.category),
          SizedBox(height: AppSpacing.base.h),
          Text(
            _questionOf(session.category),
            style: AppTextStyles.display22.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Center(
            child: path == null
                ? CatalogImage(category: session.category, size: imageSize)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg.r),
                    child: Image.file(
                      File(path),
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => CatalogImage(
                        category: session.category,
                        size: imageSize,
                      ),
                    ),
                  ),
          ),
          SizedBox(height: AppSpacing.xl.h),
          for (final choice in session.quiz.choices) _choice(choice, answered),
          if (session.lockedChoiceIds.isNotEmpty && !answered)
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

  Widget _choice(QuizChoiceEntity choice, bool answered) {
    final index = session.quiz.choices.indexOf(choice);
    final isLocked = session.lockedChoiceIds.contains(choice.catalogItemId);
    final correctSelected =
        answered &&
        choice.catalogItemId == session.result!.collectedCatalogItemId;
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
            onTap: isLocked || answered || busy
                ? null
                : () => onSelect(choice.catalogItemId),
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
                        choice.name,
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
