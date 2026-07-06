/// 어대GO 스페이싱/래디우스 스케일 — `.claude/rules/UI_Design_System.md` 정본.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20; // 화면 좌우 기본 패딩
  static const double xl = 24;
  static const double xxl = 32;
}

/// 규칙: 외부 radius = 내부 radius × 2, 패딩 = 내부 radius.
class AppRadius {
  AppRadius._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 999;
}
