import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 게스트 둘러보기 상태. 인메모리 전용(비영속) — 앱 재시작 시 해제된다.
///
/// 해제 경로 3곳: 내 정보 '로그인하러 가기', 로그인 게이트 다이얼로그 확인,
/// 로그인 핸들러 시작 시. redirect는 인증 여부를 먼저 확인하므로
/// 실로그인 상태에서 남은 플래그는 무해하다.
final guestModeProvider = StateProvider<bool>((ref) => false);
