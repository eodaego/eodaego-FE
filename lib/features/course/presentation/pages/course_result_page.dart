import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../router/route_paths.dart';

/// 추천 코스 결과 (COURSE-04) — 3개 스와이프.
/// 하트는 화면 로컬 상태, CTA는 지도 탭 전환 (선택 코스 전달 없음 — 스펙 §10).
class CourseResultPage extends StatefulWidget {
  const CourseResultPage({super.key});

  @override
  State<CourseResultPage> createState() => _CourseResultPageState();
}

class _CourseResultPageState extends State<CourseResultPage> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  final Set<String> _savedIds = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '추천 코스'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Text(
                '정문 · 2시간 · 동물',
                style:
                    AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: mockCourses.length,
                itemBuilder: (context, index) {
                  final course = mockCourses[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: SingleChildScrollView(
                      child: CourseCard(
                        course: course,
                        saved: _savedIds.contains(course.id),
                        onToggleSaved: () => setState(() {
                          _savedIds.contains(course.id)
                              ? _savedIds.remove(course.id)
                              : _savedIds.add(course.id);
                        }),
                        onGo: () => context.go(RoutePaths.map),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: mockCourses.length,
                effect: WormEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.line,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '옆으로 넘겨 다른 코스를 볼 수 있어요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption14
                      .copyWith(color: AppColors.muted),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
