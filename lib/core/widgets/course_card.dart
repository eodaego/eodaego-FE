import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/spacing_and_radius.dart';
import '../constants/text_styles.dart';
import '../../features/course/domain/entities/course_entity.dart';
import 'app_badge.dart';
import 'app_button.dart';

/// 코스 카드 — 태그 뱃지 + 번호 장소 리스트 + 하트 토글 + CTA.
/// 코스 결과·즐겨찾기에서 공용.
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.saved,
    this.onToggleSaved,
    this.onGo,
  });

  final CourseEntity course;
  final bool saved;
  final VoidCallback? onToggleSaved;
  final VoidCallback? onGo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.base.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AppBadge.category(
                course.dominantCategory,
                label: course.badgeLabel,
              ),
              SizedBox(width: AppSpacing.sm.w),
              AppBadge(
                label: course.durationLabel,
                background: AppColors.surfaceDim,
                foreground: AppColors.muted,
              ),
              SizedBox(width: AppSpacing.sm.w),
              AppBadge(
                label: course.gateLabel,
                background: AppColors.surfaceDim,
                foreground: AppColors.muted,
              ),
              const Spacer(),
              IconButton(
                onPressed: onToggleSaved,
                tooltip: saved ? '저장 지우기' : '저장',
                icon: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  size: 24.w,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            course.title,
            style: AppTextStyles.display19.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.md.h),
          for (var i = 0; i < course.places.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
              child: Row(
                children: [
                  _NumberDot(
                    number: i + 1,
                    color: course.places[i].category.color,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    course.places[i].name,
                    style: AppTextStyles.body15.copyWith(color: AppColors.ink),
                  ),
                ],
              ),
            ),
          SizedBox(height: AppSpacing.sm.h),
          AppButton(
            text: '이 코스로 갈래!',
            width: double.infinity,
            height: 52.h,
            // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            textStyle: AppTextStyles.display17,
            onPressed: onGo,
          ),
        ],
      ),
    );
  }
}

/// 코스 순서 번호 원 — 카테고리색 solid + 흰 Ssurround 숫자.
class _NumberDot extends StatelessWidget {
  const _NumberDot({required this.number, required this.color});

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: Text(
          '$number',
          // 코스 스텝 번호 숫자는 Ssurround (디자인 시스템)
          style: AppTextStyles.display16.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}
