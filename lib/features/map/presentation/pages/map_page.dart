import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';

/// 지도 (MAP-01, 탭) — 약도 placeholder + 코스 마커 + 하단 장소 시트.
/// 표시 코스는 항상 mockCourses 첫 번째로 고정 (스펙 §7.5).
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  /// 마커 배치 위치 (약도 이미지 수급 전 임의 좌표)
  static const List<Alignment> _markerAlignments = [
    Alignment(-0.5, 0.35),
    Alignment(0.35, -0.05),
    Alignment(-0.1, -0.5),
    Alignment(0.55, 0.5),
  ];

  @override
  Widget build(BuildContext context) {
    final course = mockCourses.first;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    '공원 지도',
                    style: AppTextStyles.display19
                        .copyWith(color: AppColors.ink),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: BorderRadius.circular(AppRadius.lg.r),
                      ),
                    ),
                    CustomPaint(
                      painter: DashedRRectPainter(
                        color: AppColors.uncollected,
                        radius: AppRadius.lg.r,
                      ),
                    ),
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Text(
                        '공식 약도 이미지',
                        style: AppTextStyles.caption14
                            .copyWith(color: AppColors.muted),
                      ),
                    ),
                    for (var i = 0; i < course.places.length; i++)
                      Align(
                        alignment:
                            _markerAlignments[i % _markerAlignments.length],
                        child: _MapMarker(
                          number: i + 1,
                          color: course.places[i].category.color,
                        ),
                      ),
                    Positioned(
                      left: 16.w,
                      bottom: 16.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xs.r),
                        ),
                        child: Text(
                          course.entranceLabel,
                          style: AppTextStyles.tag13Bold
                              .copyWith(color: AppColors.ink),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // 하단 고정 시트 — 상단 radius 32 + grabber (bottom-sheet 스펙)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl.r),
                ),
                border: const Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    course.title,
                    style: AppTextStyles.display16
                        .copyWith(color: AppColors.ink),
                  ),
                  SizedBox(height: 12.h),
                  for (var i = 0; i < course.places.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: [
                          _MapMarker(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 지도 마커 — 카테고리색 원 + 흰 3px 테두리 + 숫자 (map-marker 스펙 34px).
class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.number, required this.color, this.size = 34});

  final int number;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: AppColors.onPrimary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.2),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          // 마커 숫자는 Ssurround (map-marker 스펙)
          style: AppTextStyles.display16.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}
