import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('serverValue', () {
    test('park_gate_covers_all_eleven_documented_gates', () {
      expect(ParkGate.values.map((g) => g.serverValue).toSet(), {
        'MAIN_GATE',
        'HOEGWAN_GATE',
        'SOUTH_GATE',
        'GUI_GATE',
        'EAST_GATE_1',
        'EAST_GATE_2',
        'REAR_GATE',
        'NORTH_GATE_1',
        'NORTH_GATE_2',
        'WEST_GATE',
        'NEUNGDONG_GATE',
      });
    });

    test('interest_type_covers_all_seven_documented_types', () {
      expect(InterestType.values.map((t) => t.serverValue).toSet(), {
        'ANIMAL',
        'NATURE',
        'ACTIVITY',
        'PHOTO_SPOT',
        'RELAXATION',
        'CULTURE_EVENT',
        'LEARNING',
      });
    });

    test('companion_type_covers_all_five_documented_types', () {
      expect(CompanionType.values.map((t) => t.serverValue).toSet(), {
        'ALONE',
        'WITH_CHILD',
        'WITH_PARTNER',
        'WITH_FRIENDS',
        'WITH_ELDERLY',
      });
    });

    test('favorite_sort_covers_all_four_documented_values', () {
      expect(FavoriteSort.values.map((s) => s.serverValue).toSet(), {
        'LATEST',
        'OLDEST',
        'DURATION_SHORT',
        'DURATION_LONG',
      });
    });
  });

  group('fromServer', () {
    test('park_gate_maps_known_value_and_rejects_unknown', () {
      expect(ParkGate.fromServer('MAIN_GATE'), ParkGate.mainGate);
      expect(ParkGate.fromServer('SPACE_GATE'), isNull);
      expect(ParkGate.fromServer(null), isNull);
    });
  });

  group('labels', () {
    test('every_option_has_a_non_empty_korean_label', () {
      for (final gate in ParkGate.values) {
        expect(gate.label, isNotEmpty);
      }
      for (final type in InterestType.values) {
        expect(type.label, isNotEmpty);
      }
      for (final type in CompanionType.values) {
        expect(type.label, isNotEmpty);
      }
    });
  });
}
