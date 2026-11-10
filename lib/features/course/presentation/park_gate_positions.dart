import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../domain/entities/course_options.dart';

/// `map_v6.jpg` 전체 크기를 기준으로 정규화한 출입문 약도 좌표.
const parkGateSchematicPositions = <ParkGate, Offset>{
  ParkGate.mainGate: Offset(0.0977, 0.4955),
  ParkGate.hoegwanGate: Offset(0.2460, 0.7691),
  ParkGate.southGate: Offset(0.5206, 0.9234),
  ParkGate.guiGate: Offset(0.6898, 0.8609),
  ParkGate.eastGate1: Offset(0.8023, 0.6453),
  ParkGate.eastGate2: Offset(0.8102, 0.5858),
  ParkGate.rearGate: Offset(0.8341, 0.2914),
  ParkGate.northGate1: Offset(0.4361, 0.0227),
  ParkGate.northGate2: Offset(0.7046, 0.0907),
  ParkGate.westGate: Offset(0.2837, 0.0984),
  ParkGate.neungdongGate: Offset(0.1225, 0.3189),
};

/// 코스 응답에는 입·출구 위경도가 없으므로 백엔드 출입문 좌표를 사용한다.
const parkGateGeographicPositions = <ParkGate, LatLng>{
  ParkGate.mainGate: LatLng(37.548042, 127.074766),
  ParkGate.hoegwanGate: LatLng(37.545787, 127.075568),
  ParkGate.southGate: LatLng(37.544401, 127.080086),
  ParkGate.guiGate: LatLng(37.545950, 127.087362),
  ParkGate.eastGate1: LatLng(37.547227, 127.089257),
  ParkGate.eastGate2: LatLng(37.548708, 127.089555),
  ParkGate.rearGate: LatLng(37.551206, 127.088769),
  ParkGate.northGate1: LatLng(37.552337, 127.083347),
  ParkGate.northGate2: LatLng(37.552617, 127.080908),
  ParkGate.westGate: LatLng(37.551120, 127.076510),
  ParkGate.neungdongGate: LatLng(37.546895, 127.074286),
};

/// 이 거리 안에 출입문이 있어야 "공원에 있다"고 본다.
///
/// 공원 안 어느 지점이든 가장 가까운 문까지 약 470m라 여유를 두고 500m로 잡았다.
const nearestGateMaxMeters = 500.0;

/// [latitude]·[longitude]에서 가장 가까운 출입문.
///
/// **주의**: 들어온 문이 아니라 "지금 가장 가까운 문"이다. 화면은 사용자가 바꿀 수 있게 둔다.
///
/// Returns: 가장 가까운 문, [nearestGateMaxMeters]보다 멀면 null
ParkGate? findNearestParkGate(double latitude, double longitude) {
  ParkGate? nearest;
  var nearestMeters = double.infinity;
  for (final MapEntry(key: gate, value: position)
      in parkGateGeographicPositions.entries) {
    final meters = Geolocator.distanceBetween(
      latitude,
      longitude,
      position.latitude,
      position.longitude,
    );
    if (meters < nearestMeters) {
      nearest = gate;
      nearestMeters = meters;
    }
  }
  return nearestMeters <= nearestGateMaxMeters ? nearest : null;
}
