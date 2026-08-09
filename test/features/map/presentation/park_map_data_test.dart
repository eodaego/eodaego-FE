import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/map/presentation/park_map_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('contains_only_the_26_backend_facility_names', () {
    expect(
      parkFacilitySchematicPositions.keys,
      unorderedEquals(const [
        '고객안내센터',
        '어린이 정원',
        '꿈마루',
        '능동숲속의무대',
        '생태연못',
        '물놀이장',
        '원숭이마을',
        '꿈틀꿈틀놀이터',
        '식물원',
        '식물원 카페테리아',
        '바다동물관',
        '구의문 카페테리아',
        '어린이 숲 체험장',
        '초식동물마을',
        '맹수마을',
        '물새장',
        '꼬마동물마을',
        '열대동물관',
        '팔각당',
        '무지개분수',
        '놀이동산',
        '맘껏놀이터',
        '키즈오토파크',
        '서울상상나라',
        '환경연못',
        '음악분수',
      ]),
    );
  });

  test('keeps_the_unmapped_forest_experience_only_on_the_actual_map', () {
    expect(parkFacilitySchematicPositions['어린이 숲 체험장'], isNull);
  });

  test('keeps_all_schematic_coordinates_normalized', () {
    final positions = parkFacilitySchematicPositions.values.whereType<Offset>();
    for (final position in positions) {
      expect(position.dx, inInclusiveRange(0, 1));
      expect(position.dy, inInclusiveRange(0, 1));
    }
  });

  test('maps_all_11_backend_gate_codes_on_both_maps', () {
    expect(parkGateSchematicPositions.keys, unorderedEquals(ParkGate.values));
    expect(parkGateGeographicPositions.keys, unorderedEquals(ParkGate.values));
  });
}
