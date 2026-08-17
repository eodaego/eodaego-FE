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
    this.checkColor,
    this.size = 34,
    this.elevated = true,
  });

  final int number;
  final Color color;

  /// 이미 도감에 모은 장소에만 준다 — 우상단에 이 색 체크가 붙는다.
  ///
  /// 미수집을 무채색으로 흐리는 대신 수집한 쪽에 표식을 얹는다. 지도에서는
  /// 색이 살아 있는 마커가 "아직 만날 수 있는 곳"으로 읽혀야 하고, 카테고리색을
  /// 수집 여부로 유용하면 '색 = 카테고리' 규칙도 깨진다.
  final Color? checkColor;

  final double size;

  /// 그림자 여부. 지도 위에 떠 있을 때만 켠다 — 흰 카드나 목록 안에서는
  /// 띄울 지면이 없어 숫자가 번져 보인다.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final check = checkColor;
    final badgeSize = size * 0.44;

    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        // 뱃지를 원 바깥으로 밀어 숫자를 가리지 않게 한다. 크기는 마커 원 그대로
        // 두므로 목록·카드 정렬은 흔들리지 않는다.
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: AppColors.onPrimary, width: 3),
              boxShadow: elevated
                  ? [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: 0.2),
                        offset: const Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '$number',
                // 마커 숫자는 Ssurround (map-marker 스펙)
                style: AppTextStyles.display16.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
          if (check != null)
            Positioned(
              top: -(size * 0.06).w,
              right: -(size * 0.06).w,
              child: Container(
                width: badgeSize.w,
                height: badgeSize.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: check,
                  // 흰 링 위로 올라앉는 자리라 테두리가 없으면 경계가 사라진다.
                  border: Border.all(color: AppColors.onPrimary, width: 1.5),
                ),
                child: Icon(
                  Icons.check,
                  size: (badgeSize * 0.7).w,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
