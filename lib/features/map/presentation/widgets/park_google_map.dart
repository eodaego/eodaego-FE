import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/services/location/device_location_service.dart';
import '../../../../core/services/permission/location_permission_service.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../course/domain/entities/course_entity.dart';
import '../park_map_data.dart';
import 'google_map_marker_icon.dart';

class ParkGoogleMap extends StatefulWidget {
  const ParkGoogleMap({
    super.key,
    required this.course,
    this.onPlaceTap,
    this.selectedPlaceName,
  });

  final CourseEntity? course;

  /// 장소 마커 탭. 네이티브 `InfoWindow` 대신 Flutter 카드를 띄우기 위한 것으로,
  /// 출입문 마커는 도감과 무관하므로 콜백을 걸지 않는다.
  final ValueChanged<CoursePlaceEntity>? onPlaceTap;

  /// 카드를 띄운 장소의 이름. 그 마커만 카테고리 dark로 굽고 위로 올린다.
  final String? selectedPlaceName;

  @override
  State<ParkGoogleMap> createState() => _ParkGoogleMapState();
}

class _ParkGoogleMapState extends State<ParkGoogleMap> {
  static const _parkCenter = LatLng(37.5485, 127.0821);
  static final _parkBounds = LatLngBounds(
    southwest: const LatLng(37.544401, 127.074286),
    northeast: const LatLng(37.552617, 127.089555),
  );
  static final _parkCameraBounds = CameraTargetBounds(_parkBounds);

  late Future<Map<String, BitmapDescriptor>> _markerIcons;

  GoogleMapController? _controller;

  /// 파란 점 표시 여부. 권한이 있어야 켤 수 있다.
  bool _myLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _markerIcons = _loadMarkerIcons();
    _syncMyLocation();
  }

  /// 이미 허락받아 둔 경우에만 파란 점을 켠다.
  ///
  /// 여기서 권한을 *요청*하지는 않는다 — 지도를 보러 들어온 사람에게 팝업부터
  /// 들이밀지 않는다. 요청은 사용자가 버튼을 눌렀을 때 한다.
  Future<void> _syncMyLocation() async {
    final granted = await LocationPermissionService.canAccessLocation();
    if (!mounted || !granted) return;
    setState(() => _myLocationEnabled = true);
  }

  Future<void> _moveToMyLocation() async {
    // 버튼을 눌렀다는 건 위치를 보겠다는 뜻이다. 권한은 이 시점에 묻는다.
    final granted = await LocationPermissionService.ensurePermission();
    if (!mounted) return;
    if (!granted) {
      // 실패가 아니라 안내라서 danger를 쓰지 않는다.
      AppSnackbar.show(context, message: '위치 권한을 켜면 지금 있는 곳을 보여줄 수 있어요');
      return;
    }
    setState(() => _myLocationEnabled = true);

    final position = await DeviceLocationService.getCurrentPosition();
    if (!mounted) return;
    if (position == null) {
      AppSnackbar.show(
        context,
        message: '지금 있는 곳을 찾지 못했어요. 잠시 후 다시 눌러 주세요',
        backgroundColor: AppColors.danger,
      );
      return;
    }

    final target = LatLng(position.latitude, position.longitude);
    // 카메라가 공원 경계(_parkCameraBounds) 밖으로는 못 나간다. 공원 밖에서
    // 누르면 경계에 붙은 채 멈춰 아무 일도 안 한 것처럼 보이므로 미리 알린다.
    if (!_parkBounds.contains(target)) {
      AppSnackbar.show(context, message: '지금은 공원 밖에 있어요');
      return;
    }

    await _controller?.animateCamera(CameraUpdate.newLatLng(target));
  }

  @override
  void didUpdateWidget(covariant ParkGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 선택이 바뀌면 색이 바뀐다 — 아이콘은 PNG라 다시 구워야 한다.
    if (oldWidget.course != widget.course ||
        oldWidget.selectedPlaceName != widget.selectedPlaceName) {
      _markerIcons = _loadMarkerIcons();
    }
  }

  Future<Map<String, BitmapDescriptor>> _loadMarkerIcons() async {
    final course = widget.course;
    if (course == null) return const {};

    final icons = <String, BitmapDescriptor>{};
    for (final place in course.places) {
      // 선택은 같은 카테고리의 dark로 표시한다. 다른 색으로 바꾸면
      // '색 = 카테고리' 규칙이 깨진다.
      final isSelected = place.name == widget.selectedPlaceName;
      icons[_placeMarkerId(place)] = await createGoogleMapMarkerIcon(
        label: '${place.visitOrder}',
        color: isSelected ? place.category.dark : place.category.color,
      );
    }
    if (course.entrance != null && course.entrance == course.exit) {
      icons['gate'] = await createGoogleMapMarkerIcon(
        label: '↕',
        color: AppColors.primaryDark,
      );
    } else if (course.entrance != null) {
      icons['entrance'] = await createGoogleMapMarkerIcon(
        label: '입',
        color: AppColors.primaryDark,
      );
    }
    if (course.exit != null && course.entrance != course.exit) {
      icons['exit'] = await createGoogleMapMarkerIcon(
        label: '출',
        color: AppColors.placeDark,
      );
    }
    return icons;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, BitmapDescriptor>>(
          future: _markerIcons,
          builder: (context, snapshot) {
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _parkCenter,
                zoom: 14.8,
              ),
              onMapCreated: (controller) => _controller = controller,
              cameraTargetBounds: _parkCameraBounds,
              minMaxZoomPreference: const MinMaxZoomPreference(14, null),
              markers: _buildMarkers(snapshot.data ?? const {}),
              myLocationEnabled: _myLocationEnabled,
              mapToolbarEnabled: false,
              // 기본 버튼 대신 앱 스타일 버튼을 쓴다(플랫폼마다 모양이 다르다).
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            );
          },
        ),
        // 좌하단은 Google 로고 자리라 비워 둔다.
        Positioned(
          right: AppSpacing.base.w,
          bottom: AppSpacing.base.h,
          child: _MyLocationButton(onPressed: _moveToMyLocation),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers(Map<String, BitmapDescriptor> icons) {
    final course = widget.course;
    if (course == null) return const {};

    final markers = <Marker>{};
    for (final place in course.places) {
      final latitude = place.latitude;
      final longitude = place.longitude;
      if (latitude == null || longitude == null) continue;

      final markerId = _placeMarkerId(place);
      markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(latitude, longitude),
          icon: icons[markerId] ?? BitmapDescriptor.defaultMarker,
          // 선택한 마커는 겹친 무리 위로 올린다 — 어느 걸 눌렀는지 보여야 한다.
          zIndex: place.name == widget.selectedPlaceName ? 1 : 0,
          // InfoWindow를 비워 둔다 — 네이티브 말풍선이 뜨면 우리 카드와 겹친다.
          onTap: () => widget.onPlaceTap?.call(place),
        ),
      );
    }

    final entrance = course.entrance;
    final exit = course.exit;
    final entrancePosition = parkGateGeographicPositions[entrance];
    if (entrance != null && entrance == exit && entrancePosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('gate'),
          position: entrancePosition,
          icon: icons['gate'] ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '입·출구 · ${entrance.label}'),
        ),
      );
      return markers;
    }

    if (entrance != null && entrancePosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('entrance'),
          position: entrancePosition,
          icon: icons['entrance'] ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '입구 · ${entrance.label}'),
        ),
      );
    }

    final exitPosition = parkGateGeographicPositions[exit];
    if (exit != null && exitPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('exit'),
          position: exitPosition,
          icon: icons['exit'] ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '출구 · ${exit.label}'),
        ),
      );
    }
    return markers;
  }

  String _placeMarkerId(CoursePlaceEntity place) =>
      'place_${place.visitOrder}_${place.name}';
}

/// 내 위치로 카메라를 되돌리는 원형 버튼.
///
/// 지도 위에 뜨는 유일한 조작 요소라 예외적으로 그림자를 준다.
class _MyLocationButton extends StatelessWidget {
  const _MyLocationButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.line)),
      elevation: 2,
      shadowColor: AppColors.scrim,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          // 최소 터치 48 (디자인 시스템 Touch Targets)
          width: 48.w,
          height: 48.w,
          child: Icon(
            Icons.my_location,
            size: 22.w,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
