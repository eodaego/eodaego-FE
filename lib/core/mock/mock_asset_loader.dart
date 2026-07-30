import 'dart:convert';

import 'package:flutter/services.dart';

/// 목 에셋 JSON을 읽어 맵으로 돌려준다.
Future<Map<String, dynamic>> loadMockJson(String assetPath) async {
  final raw = await rootBundle.loadString(assetPath);
  return jsonDecode(raw) as Map<String, dynamic>;
}

/// 픽스처를 오늘로 옮기는 데 필요한 일수.
///
/// [anchor]가 [today]가 되도록 하는 값이다. 시각은 무시하고 날짜만 본다.
int dayShiftFrom({required DateTime anchor, required DateTime today}) =>
    DateTime.utc(today.year, today.month, today.day)
        .difference(DateTime.utc(anchor.year, anchor.month, anchor.day))
        .inDays;

/// ISO 시각 문자열의 날짜만 [days]일 옮긴다.
///
/// **주의**: 시각(hour)은 보존된다 — 시간대별 기온 곡선이 살아 있어야 한다.
/// 반환 형식은 서버와 같은 오프셋 없는 ISO다. 오프셋을 붙이면 downstream의
/// `parseKstDateTime`이 다른 분기를 타 결과가 달라진다.
///
/// Returns: 옮긴 문자열. 읽을 수 없으면 입력을 그대로 돌려준다.
String? shiftIsoDays(String? iso, int days) {
  if (iso == null || iso.isEmpty) return iso;
  final parsed = DateTime.tryParse(iso.endsWith('Z') ? iso : '${iso}Z');
  if (parsed == null) return iso;
  final moved = parsed.add(Duration(days: days));
  String two(int v) => v.toString().padLeft(2, '0');
  return '${moved.year}-${two(moved.month)}-${two(moved.day)}'
      'T${two(moved.hour)}:${two(moved.minute)}:${two(moved.second)}';
}
