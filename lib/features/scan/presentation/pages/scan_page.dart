import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';
import '../../../../core/widgets/dialogs/login_gate_dialog.dart';
import '../../../../router/route_paths.dart';

/// 촬영 (SCAN-01) — 목 배경. 카메라 프리뷰 없이 UI만 (스펙 §2).
/// 앱에서 유일한 다크 화면(cameraBg).
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  DogamCategory _mode = DogamCategory.animal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cameraBg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final c in DogamCategory.values) ...[
                  _ScanModeChip(
                    category: c,
                    selected: _mode == c,
                    onTap: () => setState(() => _mode = c),
                  ),
                  if (c != DogamCategory.values.last) SizedBox(width: 10.w),
                ],
              ],
            ),
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
                          color: _mode.color,
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
              _mode == DogamCategory.place ? '위치로 확인해요' : '네모 안에 들어오게 찍어요',
              style: AppTextStyles.body15.copyWith(color: AppColors.onPrimary),
            ),
            SizedBox(height: 28.h),
            Stack(
              alignment: Alignment.center,
              children: [
                _Shutter(
                  color: _mode.color,
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

/// 촬영 모드 토글 pill — 활성 시 해당 카테고리색 채움 (다크 배경 전용 스타일).
class _ScanModeChip extends StatelessWidget {
  const _ScanModeChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final DogamCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? category.color : AppColors.transparent,
      shape: StadiumBorder(
        side: selected
            ? BorderSide.none
            : BorderSide(
                color: AppColors.onPrimary.withValues(alpha: 0.5),
              ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 48.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Center(
              widthFactor: 1,
              child: Text(
                category.label,
                style: AppTextStyles.label16Semibold.copyWith(
                  color: selected
                      ? AppColors.onPrimary
                      : AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 셔터 78 — 링 색 = 현재 모드 카테고리색.
class _Shutter extends StatelessWidget {
  const _Shutter({required this.color, required this.onTap});

  final Color color;
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
          border: Border.all(color: color, width: 4),
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
