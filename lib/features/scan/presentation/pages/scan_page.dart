import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';
import '../../../../core/widgets/dialogs/login_gate_dialog.dart';
import '../../../../router/route_paths.dart';

/// 촬영 (SCAN-01) — 목 배경. 카메라 프리뷰 없이 UI만 (스펙 §2).
/// 앱에서 유일한 다크 화면(cameraBg).
/// 카테고리 구분 없이 촬영하면 자동 인식하는 기획 — 모드 토글 없음.
class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cameraBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 260.w,
                  height: 260.w,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(
                        painter: DashedRRectPainter(
                          color: AppColors.primary,
                          radius: AppRadius.lg.r,
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.filter_center_focus,
                          size: 48.w,
                          color: AppColors.onPrimary.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              '네모 안에 들어오게 찍으면 무엇인지 알려줄게요',
              style: AppTextStyles.body15.copyWith(color: AppColors.onPrimary),
            ),
            SizedBox(height: 28.h),
            Stack(
              alignment: Alignment.center,
              children: [
                _Shutter(
                  onTap: () {
                    if (ref.read(guestRestrictedProvider)) {
                      showLoginGateDialog(
                        context,
                        ref,
                        message: '로그인하면 사진을 찍고 도감을 모을 수 있어요',
                      );
                      return;
                    }
                    context.push(RoutePaths.quiz);
                  },
                ),
                Positioned(
                  left: 28.w,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    tooltip: '닫기',
                    icon: Icon(
                      Icons.close,
                      size: 28.w,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

/// 셔터 78 — 브랜드색 링 (자동 인식이라 카테고리 구분 없음).
class _Shutter extends StatelessWidget {
  const _Shutter({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78.w,
        height: 78.w,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 4),
        ),
        child: const DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}
