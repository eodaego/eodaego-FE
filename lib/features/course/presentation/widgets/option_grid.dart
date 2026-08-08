import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';

/// 위저드 선택지 격자. 항목이 많으면 3열, 적으면 2열로 쓴다.
///
/// [aspectRatio]는 타일 구성에 따라 달라져 호출부가 정한다 —
/// 3열 라벨만 `2.0`, 3열 아이콘+라벨 `1.3`, 2열 아이콘+라벨+부제 `1.85`.
/// 세 값 모두 393pt 기준 타일 높이가 터치 하한 48을 넘긴다.
class OptionGrid extends StatelessWidget {
  const OptionGrid({
    super.key,
    required this.columns,
    required this.aspectRatio,
    required this.children,
  });

  /// 격자 열 수.
  final int columns;

  /// 타일 가로/세로 비율.
  final double aspectRatio;

  /// 격자에 채울 타일들.
  final List<OptionTile> children;

  @override
  Widget build(BuildContext context) {
    // 스텝 본문이 SingleChildScrollView라 격자 자체는 스크롤하지 않는다.
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: columns,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: AppSpacing.sm.w,
      mainAxisSpacing: AppSpacing.sm.h,
      children: children,
    );
  }
}

/// 격자 타일 — 아이콘(선택) + 라벨 + 부제(선택).
///
/// 선택 시 primary 테두리 + tint 배경 + dark 전경을 한 묶음으로 바꾼다.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    this.icon,
    required this.label,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  /// 라벨 위 아이콘. 없으면 라벨만 둔다.
  final IconData? icon;

  /// 선택지 이름.
  final String label;

  /// 라벨 아래 보조 설명 (선택).
  final String? subtitle;

  /// 선택 여부.
  final bool selected;

  /// 탭 핸들러.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.sm.r);

    return Material(
      color: selected ? AppColors.primaryTint : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.line,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24.w,
                  color: selected ? AppColors.primary : AppColors.muted,
                ),
                SizedBox(height: AppSpacing.xs.h),
              ],
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.label16Semibold.copyWith(
                  color: selected ? AppColors.primaryDark : AppColors.ink,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                // 부제가 두 줄로 늘면 타일 높이를 넘긴다. 한 줄로 잘라 둔다.
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption14.copyWith(
                    color: selected ? AppColors.primaryDark : AppColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
