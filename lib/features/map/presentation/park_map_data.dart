import 'dart:ui';

// Gate positions moved to the course feature; re-exported for existing map imports
// 출입문 좌표는 코스 기능으로 옮겼고, 기존 지도 쪽 import를 위해 다시 내보낸다
export '../../course/presentation/park_gate_positions.dart';

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
