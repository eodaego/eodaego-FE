import 'package:eodaego/features/map/domain/entities/facility_entity.dart';
import 'package:flutter_test/flutter_test.dart';

FacilityEntity _summary({String category = '편의시설'}) =>
    FacilityEntity(id: 1, name: '꿈마루', category: category);

FacilityDetailEntity _detail({
  String? open,
  String? close,
  String? note,
}) => FacilityDetailEntity(
  summary: _summary(),
  openTime: open,
  closeTime: close,
  operatingNote: note,
);

void main() {
  group('hoursLabel', () {
    test('hoursLabel_shows_open_and_close_when_both_present', () {
      expect(_detail(open: '10:00', close: '18:00').hoursLabel, '운영 10:00 ~ 18:00');
    });

    test('hoursLabel_falls_back_to_operating_note_when_times_missing', () {
      expect(
        _detail(note: '여름철 정해진 시간에만 운영해요').hoursLabel,
        '여름철 정해진 시간에만 운영해요',
      );
    });

    test('hoursLabel_is_null_when_nothing_known', () {
      expect(_detail().hoursLabel, isNull);
    });

    test('hoursLabel_uses_note_when_only_one_time_present', () {
      expect(_detail(open: '10:00', note: '매주 월요일 휴관').hoursLabel, '매주 월요일 휴관');
    });
  });

  test('isGate_true_only_for_gate_category', () {
    expect(_summary(category: '출입문').isGate, isTrue);
    expect(_summary(category: '편의시설').isGate, isFalse);
  });
}
