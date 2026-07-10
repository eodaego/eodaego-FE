import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

/// 선택형 pill 칩 — 필터/정렬/토글용.
/// 선택 시 [color](기본 primary)로 채움 + 흰 텍스트, 비선택 시 surface + line 테두리.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    this.color,
    this.onTap,
  });

  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? AppColors.primary;
    return Material(
      color: selected ? fill : AppColors.surface,
      shape: StadiumBorder(
        side: selected
            ? BorderSide.none
            : const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Text(
            label,
            style: AppTextStyles.tag13Bold.copyWith(
              color: selected ? AppColors.onPrimary : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
