import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../domain/entities/facility_entity.dart';
import 'facility_intro_section.dart';
import 'facility_marker.dart';

/// 코스 밖 시설을 눌렀을 때 뜨는 카드. 이름·분류와 소개·운영시간만 보여준다.
///
/// 닫기는 [PlaceInfoCard]와 같다 — 바깥(지도)을 누르면 `MapPage`가 닫는다.
class FacilityInfoCard extends StatelessWidget {
  const FacilityInfoCard({super.key, required this.facility});

  final FacilityEntity facility;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 카드 안 탭이 바깥 탭 감지에 닿지 않게 삼킨다.
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          side: const BorderSide(color: AppColors.line),
        ),
        elevation: 6,
        shadowColor: AppColors.scrim,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.base.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FacilityMarker(name: facility.name),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      facility.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body15.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  AppBadge(
                    label: facility.category,
                    background: AppColors.surfaceDim,
                    foreground: AppColors.muted,
                  ),
                ],
              ),
              FacilityIntroSection(facilityId: facility.id),
            ],
          ),
        ),
      ),
    );
  }
}
