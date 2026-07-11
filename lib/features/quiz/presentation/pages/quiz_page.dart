import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../router/route_paths.dart';

/// 퀴즈 (QUIZ-02/03) — 3지선다. 오답은 해당 칸만 잠금, 해설 없음.
/// 문제는 고정 목 항목(수달) 기반 (스펙 §5).
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static const String _question = '이 친구의 이름은 무엇일까요?';
  static const List<String> _choices = ['너구리', '수달', '비버'];
  static const int _correctIndex = 1;

  final Set<int> _locked = {};
  bool _answered = false;

  void _select(int index) {
    if (_answered || _locked.contains(index)) return;
    if (index == _correctIndex) {
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
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '딩동댕 퀴즈'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: mockQuizItem.category.tint,
                borderRadius: BorderRadius.circular(AppRadius.lg.r),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      mockQuizItem.category.icon,
                      size: 72.w,
                      color: mockQuizItem.category.color,
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: AppBadge(
                      label: '${mockQuizItem.category.label} 발견!',
                      background: AppColors.surface,
                      foreground: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              _question,
              style: AppTextStyles.display22.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: 20.h),
            for (var i = 0; i < _choices.length; i++) _choice(i),
            if (_locked.isNotEmpty && !_answered)
              Center(
                child: Text(
                  '앗, 다시 골라 볼까요?',
                  style: AppTextStyles.caption14
                      .copyWith(color: AppColors.muted),
                ),
              ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _choice(int index) {
    final locked = _locked.contains(index);
    final correctSelected = _answered && index == _correctIndex;
    final background = locked
        ? AppColors.surfaceDim
        : (correctSelected ? AppColors.primaryTint : AppColors.surface);
    final textColor = locked
        ? AppColors.uncollected
        : (correctSelected ? AppColors.primaryDark : AppColors.ink);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          side: locked
              ? BorderSide.none
              : BorderSide(
                  color: correctSelected ? AppColors.primary : AppColors.line,
                ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          onTap: locked || _answered ? null : () => _select(index),
          child: SizedBox(
            height: 60.h,
            child: Center(
              child: Text(
                _choices[index],
                style: AppTextStyles.label16Semibold.copyWith(
                  color: textColor,
                  decoration: locked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
