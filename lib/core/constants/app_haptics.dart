import 'package:flutter/services.dart';

// ============================================
// Haptics (진동)
// ============================================

/// 앱 전역 진동 피드백.
///
/// 진동을 직접 호출하지 않고 항상 이 클래스를 거친다.
/// 나중에 진동 끄기 설정이 생기면 여기 한곳만 고치면 된다.
abstract final class AppHaptics {
  /// Light tap feedback for buttons and tappable icons
  /// 버튼·아이콘 탭에 주는 가벼운 진동
  static void tap() => HapticFeedback.lightImpact();
}
