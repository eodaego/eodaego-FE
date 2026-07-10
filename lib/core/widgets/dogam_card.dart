import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/spacing_and_radius.dart';
import '../constants/text_styles.dart';
import '../mock/mock_dogam.dart';

/// 도감 카드 — 수집: 2px 카테고리 테두리 + 이름 / 미수집: surfaceDim + `?`.
/// 도감 그리드·정답 축하 화면에서 공용.
class DogamCard extends StatelessWidget {
  const DogamCard({super.key, required this.item, this.onTap});

  final MockDogamItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final collected = item.collected;
    return Material(
      color: collected ? AppColors.surface : AppColors.surfaceDim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        side: collected
            ? BorderSide(color: item.category.color, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: collected
                      ? Icon(
                          item.category.icon,
                          size: 34.w,
                          color: item.category.color,
                        )
                      : Text(
                          '?',
                          style: AppTextStyles.display34
                              .copyWith(color: AppColors.uncollected),
                        ),
                ),
              ),
              Text(
                collected ? item.name : '미수집',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tag13Bold.copyWith(
                  color: collected ? AppColors.ink : AppColors.uncollected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
