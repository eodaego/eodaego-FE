import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../course/domain/entities/course_entity.dart';
import '../../../course/domain/entities/course_options.dart';
import '../park_map_data.dart';
import 'map_marker.dart';

class ParkSchematicMap extends StatelessWidget {
  const ParkSchematicMap({
    super.key,
    required this.course,
    this.onPlaceTap,
    this.selectedPlaceName,
  });

  static const _aspectRatio = 1010 / 619;

  final CourseEntity? course;

  /// 장소 마커 탭. 출입문 마커는 도감과 무관하므로 콜백을 걸지 않는다.
  final ValueChanged<CoursePlaceEntity>? onPlaceTap;

  /// 카드를 띄운 장소의 이름. 그 마커만 카테고리 dark로 칠하고 위로 올린다.
  final String? selectedPlaceName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/course/map_v6.jpg',
                  fit: BoxFit.fill,
                ),
                if (course != null) ..._placeMarkers(constraints),
                if (course != null) ..._gateMarkers(constraints),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _placeMarkers(BoxConstraints constraints) {
    final markers = <Widget>[];
    Widget? selectedMarker;

    for (final place in course!.places) {
      final position = parkFacilitySchematicPositions[place.name];
      if (position == null) continue;

      final isSelected = place.name == selectedPlaceName;
      // 마커 그림은 32지만 터치 영역은 48이어야 한다(디자인 시스템 Touch
      // Targets — 어린이 손가락 기준). 배치도 48 기준으로 해야 마커가 밀리지
      // 않는다.
      final marker = _positionedMarker(
        position: position,
        constraints: constraints,
        size: 48.w,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onPlaceTap?.call(place),
          child: SizedBox(
            width: 48.w,
            height: 48.w,
            child: Center(
              child: MapMarker(
                number: place.visitOrder,
                // 선택은 같은 카테고리의 dark로 표시한다. 다른 색으로 바꾸면
                // '색 = 카테고리' 규칙이 깨진다.
                color: isSelected ? place.category.dark : place.category.color,
                size: 32,
              ),
            ),
          ),
        ),
      );

      if (isSelected) {
        selectedMarker = marker;
      } else {
        markers.add(marker);
      }
    }

    // 선택한 마커는 겹친 무리 위로 올린다 — 어느 걸 눌렀는지 보여야 한다.
    if (selectedMarker != null) markers.add(selectedMarker);
    return markers;
  }

  List<Widget> _gateMarkers(BoxConstraints constraints) {
    final entrance = course!.entrance;
    final exit = course!.exit;
    if (entrance != null && entrance == exit) {
      return [
        _gateMarker(
          gate: entrance,
          label: '↕',
          color: AppColors.primaryDark,
          constraints: constraints,
        ),
      ];
    }

    return [
      if (entrance != null)
        _gateMarker(
          gate: entrance,
          label: '입',
          color: AppColors.primaryDark,
          constraints: constraints,
        ),
      if (exit != null)
        _gateMarker(
          gate: exit,
          label: '출',
          color: AppColors.placeDark,
          constraints: constraints,
        ),
    ];
  }

  Widget _gateMarker({
    required ParkGate gate,
    required String label,
    required Color color,
    required BoxConstraints constraints,
  }) {
    final position = parkGateSchematicPositions[gate]!;
    final size = 30.w;
    return _positionedMarker(
      position: position,
      constraints: constraints,
      size: size,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: AppColors.onPrimary, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.tag12Bold.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }

  Widget _positionedMarker({
    required Offset position,
    required BoxConstraints constraints,
    required double size,
    required Widget child,
  }) {
    final left = (position.dx * constraints.maxWidth - size / 2).clamp(
      0.0,
      constraints.maxWidth - size,
    );
    final top = (position.dy * constraints.maxHeight - size / 2).clamp(
      0.0,
      constraints.maxHeight - size,
    );
    return Positioned(left: left, top: top, child: child);
  }
}
