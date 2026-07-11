import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../router/route_paths.dart';
import 'map_marker.dart';

/// 지도 하단 드래그 시트 — 지금 보는 코스 + 코스 추천 진입.
/// 추천 자체는 전용 페이지(/course/recommend)로 분리 (스펙 §4).
/// 게스트(restricted)는 추천 진입 대신 인라인 로그인 유도.
class CourseSheet extends ConsumerWidget {
  const CourseSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(selectedCourseProvider);
    final restricted = ref.watch(guestRestrictedProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.22,
      minChildSize: 0.22,
      maxChildSize: 0.5,
      snap: true,
      snapSizes: const [0.22, 0.5],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl.r),
            ),
            border: const Border(top: BorderSide(color: AppColors.line)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            children: [
              SizedBox(height: 12.h),
              Center(
                child: Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                '지금 보는 코스',
                style:
                    AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
              SizedBox(height: 6.h),
              Text(
                course.title,
                style: AppTextStyles.display16.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: 12.h),
              for (var i = 0; i < course.places.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    children: [
                      MapMarker(
                        number: i + 1,
                        color: course.places[i].category.color,
                        size: 26,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        course.places[i].name,
                        style: AppTextStyles.body15
                            .copyWith(color: AppColors.ink),
                      ),
                      const Spacer(),
                      AppBadge.category(course.places[i].category),
                    ],
                  ),
                ),
              SizedBox(height: 8.h),
              if (restricted)
                const _GuestGate()
              else
                AppButton(
                  text: '코스 추천 받기',
                  width: double.infinity,
                  height: 52.h,
                  onPressed: () => context.push(RoutePaths.courseRecommend),
                ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}

/// 게스트 인라인 게이트 — 추천 진입 버튼 자리 대체 (게스트 스펙 §3.5).
class _GuestGate extends ConsumerWidget {
  const _GuestGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Icon(Icons.lock_outline, size: 32.w, color: AppColors.uncollected),
        SizedBox(height: 10.h),
        Text(
          '로그인하면 코스 추천을 받을 수 있어요',
          textAlign: TextAlign.center,
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: 16.h),
        Center(
          child: AppButton(
            text: '로그인하러 가기',
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            showBorder: true,
            width: 240.w,
            height: 52.h,
            onPressed: () {
              ref.read(guestModeProvider.notifier).state = false;
              context.go(RoutePaths.login);
            },
          ),
        ),
      ],
    );
  }
}
