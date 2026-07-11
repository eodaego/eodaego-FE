import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_badge.dart';

/// 도감 상세 (CATALOG 상세) — 사진 영역·뱃지·어린이 눈높이 설명·수집일.
class CollectionDetailPage extends StatelessWidget {
  const CollectionDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final item = mockDogamItems.firstWhere(
      (e) => e.id == itemId,
      orElse: () => mockDogamItems.first,
    );
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '도감 상세'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: item.category.tint,
                borderRadius: BorderRadius.circular(AppRadius.lg.r),
              ),
              child: Center(
                child: Icon(
                  item.category.icon,
                  size: 72.w,
                  color: item.category.color,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                AppBadge.category(item.category),
                SizedBox(width: 8.w),
                const AppBadge(
                  label: '수집 가능',
                  background: AppColors.primaryTint,
                  foreground: AppColors.primaryDark,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              item.name,
              style: AppTextStyles.display26.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: 8.h),
            Text(
              item.oneLiner,
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '어린이 눈높이 설명',
                    style: AppTextStyles.display16
                        .copyWith(color: item.category.dark),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    item.kidsDescription,
                    style: AppTextStyles.body17.copyWith(color: AppColors.ink),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (item.collected)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18.w,
                    color: AppColors.muted,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '수집일 ${item.collectedAt}',
                    style: AppTextStyles.caption14
                        .copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
