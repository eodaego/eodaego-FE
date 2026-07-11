import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';
import '../widgets/course_sheet.dart';
import '../widgets/map_marker.dart';

/// 지도 (탭) — 약도 placeholder + 선택 코스 마커 + 드래그 코스 시트.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// 초기 선택 = 오늘의 추천 코스 (홈 프리뷰와 동일 — 스펙 §3.2)
  MockCourse _selected = mockCourses.first;

  /// 마커 배치 위치 (약도 이미지 수급 전 임의 좌표)
  static const List<Alignment> _markerAlignments = [
    Alignment(-0.5, 0.35),
    Alignment(0.35, -0.05),
    Alignment(-0.1, -0.5),
    Alignment(0.55, 0.5),
  ];

  @override
  Widget build(BuildContext context) {
    // 시트 접힘 높이(body 기준 22%)에 대응해 풀스크린 기준 20%를 비워 마커·라벨 가림을 방지
    final sheetInset = MediaQuery.sizeOf(context).height * 0.20;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: sheetInset),
              child: Padding(
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
                    SizedBox(height: 12.h),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDim,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.lg.r),
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
                          for (var i = 0; i < _selected.places.length; i++)
                            Align(
                              alignment: _markerAlignments[
                                  i % _markerAlignments.length],
                              child: MapMarker(
                                number: i + 1,
                                color: _selected.places[i].category.color,
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
                                borderRadius:
                                    BorderRadius.circular(AppRadius.xs.r),
                              ),
                              child: Text(
                                _selected.entranceLabel,
                                style: AppTextStyles.tag13Bold
                                    .copyWith(color: AppColors.ink),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
            CourseSheet(
              selected: _selected,
              onSelect: (course) => setState(() => _selected = course),
            ),
          ],
        ),
      ),
    );
  }
}
