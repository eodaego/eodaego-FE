import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env_config.dart';

/// 게스트 둘러보기 상태. 인메모리 전용(비영속) — 앱 재시작 시 해제된다.
///
/// 해제 경로 3곳: 내 정보 '로그인하러 가기', 로그인 게이트 다이얼로그 확인,
/// 로그인 핸들러 시작 시. redirect는 인증 여부를 먼저 확인하므로
/// 실로그인 상태에서 남은 플래그는 무해하다.
final guestModeProvider = StateProvider<bool>((ref) => false);

/// 실효 게스트 제한 여부 — 게이트(셔터·코스 추천·즐겨찾기 시드)는 이 값으로 판단한다.
/// 목 데이터 모드(USE_MOCK_DATA=true)에서는 UI 개발 편의를 위해 게스트도
/// 전 기능을 돌아다닐 수 있게 게이트를 열어둔다. 실 데이터에서만 제한.
final guestRestrictedProvider = Provider<bool>(
  (ref) => ref.watch(guestModeProvider) && !EnvConfig.useMockData,
);
