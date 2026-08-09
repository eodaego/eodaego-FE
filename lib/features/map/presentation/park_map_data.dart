import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../course/domain/entities/course_options.dart';

/// `map_v6.jpg` 전체 크기를 기준으로 정규화한 백엔드 시설 좌표.
///
/// 범례에 없는 어린이 숲 체험장은 실제 지도에만 표시한다.
const parkFacilitySchematicPositions = <String, Offset?>{
  '고객안내센터': Offset(0.1773, 0.5099),
  '어린이 정원': Offset(0.2418, 0.5945),
  '꿈마루': Offset(0.3285, 0.4815),
  '능동숲속의무대': Offset(0.3663, 0.5766),
  '생태연못': Offset(0.2945, 0.6235),
  '물놀이장': Offset(0.4399, 0.7326),
  '원숭이마을': Offset(0.5623, 0.6071),
  '꿈틀꿈틀놀이터': Offset(0.4102, 0.6555),
  '식물원': Offset(0.4228, 0.6122),
  '식물원 카페테리아': Offset(0.4570, 0.6361),
  '바다동물관': Offset(0.5452, 0.7828),
  '구의문 카페테리아': Offset(0.6350, 0.8033),
  '어린이 숲 체험장': null,
  '초식동물마을': Offset(0.5573, 0.7054),
  '맹수마을': Offset(0.5812, 0.5636),
  '물새장': Offset(0.5652, 0.4721),
  '꼬마동물마을': Offset(0.5056, 0.5459),
  '열대동물관': Offset(0.4858, 0.4653),
  '팔각당': Offset(0.5226, 0.4124),
  '무지개분수': Offset(0.7573, 0.3157),
  '놀이동산': Offset(0.6448, 0.3243),
  '맘껏놀이터': Offset(0.4656, 0.2888),
  '키즈오토파크': Offset(0.2777, 0.1683),
  '서울상상나라': Offset(0.1853, 0.3528),
  '환경연못': Offset(0.1703, 0.3931),
  '음악분수': Offset(0.2468, 0.4364),
};

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
