import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../domain/entities/course_options.dart';
import '../park_gate_positions.dart';

/// 공원 약도 위 출입문 핀.
///
/// [onGateTap]이 있으면 11개 문을 모두 그리고 누를 수 있다(문 고르기 시트).
/// 없으면 [entrance]·[exit]만 그린다(경로 썸네일).
///
/// **주의**: 동문1·2처럼 핀끼리 붙은 문이 있어 핀만으로는 잘못 누르기 쉽다.
/// 문을 고르는 화면은 이 약도 아래에 출입문 그리드를 함께 둔다.
class ParkGateMap extends StatelessWidget {
  const ParkGateMap({super.key, this.entrance, this.exit, this.onGateTap});

  static const _aspectRatio = 1010 / 619;

  /// 라벨을 핀 아래에 다는 문 — 약도 위쪽 끝이거나 이웃 핀과 겹치는 문.
  static const _labelBelow = {
    ParkGate.northGate1,
    ParkGate.northGate2,
    ParkGate.westGate,
    ParkGate.eastGate1,
  };

  final ParkGate? entrance;
  final ParkGate? exit;
  final ValueChanged<ParkGate>? onGateTap;

  bool get _interactive => onGateTap != null;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      (_interactive ? AppRadius.md : AppRadius.sm).r,
    );
    final from = entrance;
    final to = exit;
    final gates = _interactive
        ? ParkGate.values
        : [?from, if (to != null && to != from) to];

    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: radius,
                  child: Image.asset(
                    'assets/images/course/map_v6.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              for (final gate in gates) _pin(gate, constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _pin(ParkGate gate, BoxConstraints constraints) {
    final position = parkGateSchematicPositions[gate]!;
    final selected = gate == entrance || gate == exit;
    final dotSize = (_interactive ? 14 : 10).w;
    final dot = Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : AppColors.surface,
        border: Border.all(
          color: selected ? AppColors.primaryDark : AppColors.ink,
          width: 3,
        ),
      ),
    );

    // Thumbnail shows a single label for a round trip
    // 썸네일은 왕복이면 라벨 하나만 단다
    final showLabel = _interactive || gate == entrance;
    final label = Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xs.r),
        border: Border.all(
          color: selected ? AppColors.primaryDark : AppColors.line,
        ),
      ),
      child: Text(
        gate.label,
        style: AppTextStyles.tag12Bold.copyWith(
          color: selected ? AppColors.onPrimary : AppColors.ink,
        ),
      ),
    );

    final below = _labelBelow.contains(gate);
    final tapPadding = _interactive ? AppSpacing.xs.w : 0.0;
    // Distance from the pin's top (or bottom) edge to the dot center
    // 핀 위(또는 아래) 끝에서 점 중심까지의 거리
    final toDotCenter = tapPadding + 2.h + dotSize / 2;
    final pin = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel && !below) label,
        SizedBox(height: 2.h),
        dot,
        SizedBox(height: 2.h),
        if (showLabel && below) label,
      ],
    );

    // Anchor the dot center on the gate coordinate
    // 점의 중심을 문 좌표에 맞춘다
    return Positioned(
      left: position.dx * constraints.maxWidth,
      top: position.dy * constraints.maxHeight,
      child: FractionalTranslation(
        translation: Offset(-0.5, below ? 0 : -1),
        child: Transform.translate(
          offset: Offset(0, below ? -toDotCenter : toDotCenter),
          child: _interactive
              ? Semantics(
                  button: true,
                  label: gate.label,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onGateTap!(gate),
                    child: Padding(
                      padding: EdgeInsets.all(tapPadding),
                      child: pin,
                    ),
                  ),
                )
              : pin,
        ),
      ),
    );
  }
}
