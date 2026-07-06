import 'package:flutter/painting.dart';

/// 어대GO 색상 팔레트 — `.claude/rules/UI_Design_System.md` 정본.
/// 단일 라이트 테마(웜 아이보리 캔버스). `Color(0xFF..)` 직접 사용 금지, 이 상수만 참조.
class AppColors {
  AppColors._();

  // Brand / Category
  static const Color primary = Color(0xFF3DA35D);
  static const Color primaryDark = Color(0xFF1E6B3C);
  static const Color primaryTint = Color(0xFFE6F4EA);
  static const Color animal = Color(0xFFF58A3C);
  static const Color animalDark = Color(0xFF5C2A08);
  static const Color animalTint = Color(0xFFFEF0E4);
  static const Color plant = Color(0xFF3DA35D);
  static const Color plantDark = Color(0xFF1E6B3C);
  static const Color plantTint = Color(0xFFE6F4EA);
  static const Color place = Color(0xFF4A9FE8);
  static const Color placeDark = Color(0xFF0A3A63);
  static const Color placeTint = Color(0xFFE8F3FC);
  static const Color reward = Color(0xFFFFC93C);
  static const Color rewardDark = Color(0xFF5F4400);

  // Canvas / Surface
  static const Color canvas = Color(0xFFFAF7F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFF0EDE4);
  static const Color cameraBg = Color(0xFF20241F);

  // Ink / Text
  static const Color ink = Color(0xFF2B2B28);
  static const Color muted = Color(0xFF6B6A64);
  static const Color disabled = Color(0xFF9B998F);
  static const Color uncollected = Color(0xFFB9B6AC);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Border / Semantic
  static const Color line = Color(0xFFEBE7DC);
  static const Color danger = Color(0xFFA32D2D);

  /// 모달 스크림(딤 배경). 잉크색 기반 반투명 — 다이얼로그/바텀시트 배경 어둡게.
  static const Color scrim = Color(0x8A2B2B28);

  /// 완전 투명 (Material ink/splash 배경용)
  static const Color transparent = Color(0x00000000);
}
