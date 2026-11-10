import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:eodaego/features/course/presentation/park_gate_positions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('findNearestParkGate', () {
    test('returns_the_gate_when_standing_right_at_it', () {
      for (final MapEntry(key: gate, value: position)
          in parkGateGeographicPositions.entries) {
        expect(
          findNearestParkGate(position.latitude, position.longitude),
          gate,
        );
      }
    });

    test('returns_the_closer_of_two_gates_when_between_them', () {
      // 정문(127.074766)과 능동문(127.074286) 근처지만 정문 쪽에 더 붙은 지점
      expect(findNearestParkGate(37.5478, 127.0752), ParkGate.mainGate);
    });

    test('returns_a_gate_from_the_middle_of_the_park', () {
      // 공원 한가운데 — 문까지 수백 m지만 공원 안이므로 문을 골라야 한다
      expect(findNearestParkGate(37.5485, 127.0815), isNotNull);
    });

    test('returns_null_when_far_from_the_park', () {
      // 서울시청 근처
      expect(findNearestParkGate(37.5663, 126.9779), isNull);
    });
  });
}
