import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

/// 지도 마커/장소 번호 원 — 카테고리색 + 흰 3px 테두리 + Ssurround 숫자 (map-marker 스펙).
class MapMarker extends StatelessWidget {
  const MapMarker({
    super.key,
    required this.number,
    required this.color,
    this.size = 34,
  });

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
