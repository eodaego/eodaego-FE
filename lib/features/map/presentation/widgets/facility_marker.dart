import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

/// 약도의 시설 점 — 흰 바탕 + muted 3px 테두리. 코스 숫자 마커보다 작고 조용하다.
///
/// 선택하면 지름 18 + primary 테두리가 되고 이름 라벨이 붙는다.
class FacilityMarker extends StatelessWidget {
  const FacilityMarker({super.key, required this.name, this.selected = false});

  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final diameter = (selected ? 18 : 14).w;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.muted,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        if (selected)
          Positioned(
            top: 16.h,
            child: UnconstrainedBox(
              child: Text(
                name,
                maxLines: 1,
                style: AppTextStyles.tag12Bold.copyWith(
                  color: AppColors.ink,
                  shadows: const [
                    Shadow(color: AppColors.surface, blurRadius: 3),
                    Shadow(color: AppColors.surface, blurRadius: 3),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
