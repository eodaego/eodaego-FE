import 'package:eodaego/features/weather/domain/entities/congestion_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CongestionLevel.fromServer', () {
    test('maps_all_four_documented_levels', () {
      expect(CongestionLevel.fromServer('RELAXED'), CongestionLevel.relaxed);
      expect(CongestionLevel.fromServer('NORMAL'), CongestionLevel.normal);
      expect(
        CongestionLevel.fromServer('SLIGHTLY_CROWDED'),
        CongestionLevel.slightlyCrowded,
      );
      expect(CongestionLevel.fromServer('CROWDED'), CongestionLevel.crowded);
    });

    test('returns_null_when_server_adds_an_unknown_level', () {
      // 서울시가 등급을 추가하면 구버전 앱이 모르는 값을 받는다.
      // 기본값으로 욱여넣지 않는다 — 색이 없어 그릴 수 없다.
      expect(CongestionLevel.fromServer('VERY_CROWDED'), isNull);
    });

    test('returns_null_when_value_is_null', () {
      expect(CongestionLevel.fromServer(null), isNull);
    });

    test('exposes_korean_labels_matching_the_api_contract', () {
      expect(CongestionLevel.relaxed.label, '여유');
      expect(CongestionLevel.normal.label, '보통');
      expect(CongestionLevel.slightlyCrowded.label, '약간 붐빔');
      expect(CongestionLevel.crowded.label, '붐빔');
    });
  });
}
