import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';
import '../../../../router/route_paths.dart';

/// 즐겨찾기 (탭) — 저장 코스 리스트 + 빈 상태.
/// 하트 해제는 화면 로컬 상태 (재진입 시 목 초기값으로 리셋 — 스펙 §10).
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<MockCourse> _saved = List.of(mockCourses);
  String _sort = '전체'; // UI 토글만, 정렬 로직 없음 (스펙 §7.11)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '저장한 코스',
                    style: AppTextStyles.display19
                        .copyWith(color: AppColors.ink),
                  ),
                  SizedBox(width: 8.w),
                  AppBadge(
                    label: '${_saved.length}개',
                    background: AppColors.surfaceDim,
                    foreground: AppColors.muted,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  for (final s in const ['전체', '최근순', '시간순']) ...[
                    CategoryChip(
                      label: s,
                      selected: _sort == s,
                      onTap: () => setState(() => _sort = s),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ],
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: _saved.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        itemCount: _saved.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final course = _saved[index];
                          return CourseCard(
                            key: ValueKey(course.id),
                            course: course,
                            saved: true,
                            onToggleSaved: () =>
                                setState(() => _saved.remove(course)),
                            onGo: () => context.go(RoutePaths.map),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 빈 상태 — 점선 원 하트 + 안내 + 위저드 이동 버튼.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 96.w,
            height: 96.w,
            child: CustomPaint(
              painter: DashedRRectPainter(
                color: AppColors.uncollected,
                radius: 48.w,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 40.w,
                color: AppColors.uncollected,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '아직 저장한 코스가 없어요\n추천 코스에서 하트를 눌러 저장해요',
            textAlign: TextAlign.center,
            style: AppTextStyles.body15.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 20.h),
          AppButton(
            text: '코스 추천 받으러 가기',
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            showBorder: true,
            width: 260.w,
            height: 52.h,
            onPressed: () => context.push(RoutePaths.courseWizard),
          ),
        ],
      ),
    );
  }
}
