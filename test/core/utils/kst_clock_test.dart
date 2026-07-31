import 'package:clock/clock.dart';
import 'package:eodaego/core/utils/kst_clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseKstDateTime', () {
    test('reads_offsetless_string_as_kst_wall_clock', () {
      final parsed = parseKstDateTime('2026-07-30T15:00:00')!;

      expect(parsed.year, 2026);
      expect(parsed.month, 7);
      expect(parsed.day, 30);
      expect(parsed.hour, 15);
      // nowKst()와 같은 기준이어야 epoch 비교가 벽시계 비교와 일치한다
      expect(parsed.isUtc, isTrue);
    });

    test('normalizes_offset_bearing_string_to_kst', () {
      // 서버가 나중에 오프셋을 붙여도 조용히 9시간 어긋나지 않는다
      expect(parseKstDateTime('2026-07-30T06:00:00Z')!.hour, 15);
      expect(parseKstDateTime('2026-07-30T15:00:00+09:00')!.hour, 15);
    });

    test('returns_null_when_input_is_missing_or_unparsable', () {
      expect(parseKstDateTime(null), isNull);
      expect(parseKstDateTime(''), isNull);
      expect(parseKstDateTime('내일 오후'), isNull);
    });

    test('returns_null_for_date_only_input_instead_of_device_local_guess', () {
      // 오프셋이 없으니 기기 타임존으로 조용히 해석하지 않고 버린다 —
      // 그러지 않으면 이 값이 기기 타임존에 따라 다른 순간을 가리키게 된다.
      expect(parseKstDateTime('2026-07-30'), isNull);
    });
  });

  group('nowKst', () {
    test('returns_utc_flagged_time_nine_hours_ahead_of_utc', () {
      final utc = DateTime.now().toUtc();
      final kst = nowKst();

      expect(kst.isUtc, isTrue);
      // 같은 순간을 9시간 앞선 벽시계로 표현한다.
      // 오차 허용을 넉넉히 두는 건 이 테스트가 실제 시계를 두 번 읽기 때문이다.
      // 오프셋이 틀리면 시간 단위로 어긋나므로 5초 여유로도 버그는 다 잡힌다.
      expect(
        (kst.difference(utc) - const Duration(hours: 9)).abs(),
        lessThan(const Duration(seconds: 5)),
      );
    });

    test('reads_the_injected_clock_instead_of_the_real_one', () {
      // 여기(순수 Dart 코드, 위젯 빌드 없음)서는 Zone이 정상 전파된다 —
      // withClock이 위젯 빌드까지 닿지 않는 문제와는 별개다.
      final fixed = DateTime.utc(2026, 7, 30, 6);

      final kst = withClock(Clock.fixed(fixed), nowKst);

      expect(kst, fixed.add(const Duration(hours: 9)));
    });
  });
}
