import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// 공원 혼잡도 단계 — 뱃지 색 페어링 포함.
/// 노랑(reward)은 홈 CTA·축하 화면 전용이므로 혼잡도에 사용 금지 (디자인 시스템).
enum CongestionLevel {
  relaxed('여유', AppColors.primaryTint, AppColors.primaryDark),
  normal('보통', AppColors.animalTint, AppColors.animalDark),
  crowded('혼잡', AppColors.surfaceDim, AppColors.danger);

  const CongestionLevel(this.label, this.badgeBackground, this.badgeForeground);

  final String label;
  final Color badgeBackground;
  final Color badgeForeground;
}

/// 공원 오늘 상태 목 데이터. API 연동 시 core/mock 폴더째 삭제 예정.
class MockParkStatus {
  const MockParkStatus({
    required this.weatherLabel,
    required this.temperatureC,
    required this.weatherIcon,
    required this.congestion,
  });

  final String weatherLabel;
  final int temperatureC;
  final IconData weatherIcon;
  final CongestionLevel congestion;
}

const MockParkStatus mockParkStatus = MockParkStatus(
  weatherLabel: '맑음',
  temperatureC: 24,
  weatherIcon: Icons.wb_sunny_outlined,
  congestion: CongestionLevel.relaxed,
);
