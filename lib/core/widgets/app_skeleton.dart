import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/spacing_and_radius.dart';

/// 로딩 스켈레톤 — 라운드 상자에 shimmer를 입힌 공용 위젯.
///
/// **주의**: 미수집을 뜻하는 `?`와 구분된다. 스켈레톤은 움직이고 곧 채워지지만,
/// `?`는 정적이고 수집해야 채워진다. 둘을 같은 자리에 겹쳐 쓰지 않는다.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  /// 상자 너비. 가로를 채우려면 [double.infinity]를 넘긴다.
  final double width;

  /// 상자 높이
  final double height;

  /// 모서리 반경. 생략하면 [AppRadius.xs]
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceDim,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceDim,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.xs.r),
        ),
      ),
    );
  }
}
