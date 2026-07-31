import 'package:clock/clock.dart';

/// 서버가 주는 시각 문자열을 KST 벽시계로 읽는다.
///
/// **주의**: `DateTime.parse('2026-07-30T00:00:00')`는 오프셋이 없어 기기
/// 로컬 시각으로 해석된다. `Z`를 붙여 UTC로 고정하면 필드값(연·월·일·시)이
/// 그대로 KST 벽시계가 되고, [nowKst]와 같은 기준이 되어 비교가 정확해진다.
/// 기준이 어긋나면 예보 필터가 기기 타임존만큼 통째로 밀린다.
///
/// 두 번째 시도는 서버가 오프셋(`Z` 또는 `+09:00`)을 붙여 보내는 경우만
/// 받는다. Dart는 그런 입력에만 `isUtc`를 true로 세팅하므로, 오프셋 없는
/// 값(예: 날짜만 있는 `2026-07-30`)이나 형식이 깨진 값은 기기 로컬 시각으로
/// 조용히 잘못 해석되는 대신 null로 떨어진다.
///
/// Returns: KST 벽시계 [DateTime], 읽을 수 없으면 null
DateTime? parseKstDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final asKst = DateTime.tryParse('${raw}Z');
  if (asKst != null) return asKst;
  // 서버가 오프셋을 붙이면 위 파싱(Z 중복)이 실패한다. isUtc로 오프셋이
  // 실제로 있었는지 확인한 뒤에만 KST로 옮긴다 — 그 외 입력은 null.
  final parsed = DateTime.tryParse(raw);
  return parsed != null && parsed.isUtc
      ? parsed.add(const Duration(hours: 9))
      : null;
}

/// 지금을 KST 벽시계로. [parseKstDateTime] 결과와 같은 기준이다.
///
/// `clock.now()`를 쓴다 — 테스트에서 `withClock`으로 고정하면 이 함수도
/// 같은 순간을 본다. 프로덕션에서는 `DateTime.now()`와 동일하다.
DateTime nowKst() => clock.now().toUtc().add(const Duration(hours: 9));
