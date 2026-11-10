import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../providers/facility_provider.dart';

/// 장소 카드 아래에 붙는 시설 소개 + 운영시간 줄. 코스 장소 카드와 시설 카드가 함께 쓴다.
///
/// [facilityId]가 null이거나 상세가 없으면(게스트·실패) 아무것도 그리지 않는다.
/// 로딩 중에는 2줄 높이를 잡아 도착 때 카드 높이가 튀지 않게 한다.
class FacilityIntroSection extends ConsumerWidget {
  const FacilityIntroSection({super.key, required this.facilityId});

  final int? facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = facilityId;
    if (id == null) return const SizedBox.shrink();

    final style = AppTextStyles.caption14.copyWith(color: AppColors.muted);
    return ref
        .watch(facilityDetailProvider(id))
        .when(
          // 2줄 높이 자리만 잡는다.
          loading: () => Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text('\n', style: style),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (detail) {
            if (detail == null) return const SizedBox.shrink();
            final intro = detail.intro;
            final hours = detail.hoursLabel;
            if (intro == null && hours == null) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (intro != null) Text(intro, style: style),
                  if (hours != null) ...[
                    if (intro != null) SizedBox(height: 4.h),
                    Text(hours, style: style),
                  ],
                ],
              ),
            );
          },
        );
  }
}
