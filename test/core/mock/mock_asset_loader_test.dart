import 'package:eodaego/core/mock/mock_asset_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dayShiftFrom', () {
    test('returns_positive_when_anchor_is_in_the_past', () {
      final shift = dayShiftFrom(
        anchor: DateTime(2026, 7, 30),
        today: DateTime(2026, 8, 2),
      );

      expect(shift, 3);
    });

    test('returns_negative_when_anchor_is_in_the_future', () {
      final shift = dayShiftFrom(
        anchor: DateTime(2026, 8, 2),
        today: DateTime(2026, 7, 30),
      );

      expect(shift, -3);
    });

    test('returns_zero_when_anchor_and_today_are_the_same_day', () {
      final shift = dayShiftFrom(
        anchor: DateTime(2026, 7, 30, 9),
        today: DateTime(2026, 7, 30, 21),
      );

      expect(shift, 0);
    });
  });

  group('shiftIsoDays', () {
    test('preserves_hour_and_minute_when_shifting_days', () {
      final shifted = shiftIsoDays('2026-07-30T15:00:00', 3);

      expect(shifted, '2026-08-02T15:00:00');
    });

    test('crosses_year_boundary_when_shift_lands_on_next_year', () {
      final shifted = shiftIsoDays('2026-12-31T23:00:00', 1);

      expect(shifted, '2027-01-01T23:00:00');
    });

    test('returns_offset_free_string_without_z_or_plus_suffix', () {
      final shifted = shiftIsoDays('2026-07-30T15:00:00', 1);

      expect(shifted, isNot(contains('Z')));
      expect(shifted, isNot(contains('+')));
    });

    test('returns_input_unchanged_when_null', () {
      expect(shiftIsoDays(null, 3), isNull);
    });

    test('returns_input_unchanged_when_empty', () {
      expect(shiftIsoDays('', 3), '');
    });

    test('returns_input_unchanged_when_unparsable', () {
      expect(shiftIsoDays('내일 오후', 3), '내일 오후');
    });

    test('returns_same_string_when_days_is_zero', () {
      const original = '2026-07-30T15:00:00';

      expect(shiftIsoDays(original, 0), original);
    });
  });
}
