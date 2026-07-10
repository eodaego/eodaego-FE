import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/spacing_and_radius.dart';
import '../constants/text_styles.dart';
import '../mock/mock_dogam.dart';

/// 공용 뱃지 — tint 배경 + dark 텍스트 페어링(카테고리) 또는 임의 조합.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  /// 카테고리 뱃지 프리셋 — tint 배경 + 같은 계열 dark 텍스트 (페어링 규칙).
  AppBadge.category(DogamCategory category, {super.key, String? label})
      : label = label ?? category.label,
        background = category.tint,
        foreground = category.dark;

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xs.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.tag13Bold.copyWith(color: foreground),
      ),
    );
  }
}
