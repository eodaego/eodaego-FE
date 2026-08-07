import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// 공원 혼잡도 등급.
///
/// 서버는 `RELAXED`/`NORMAL`/`SLIGHTLY_CROWDED`/`CROWDED` 네 가지만 내려준다.
/// 색은 여유(초록) → 보통(파랑) → 약간 붐빔(주황) → 붐빔(빨강) 순으로 올라간다.
enum CongestionLevel {
  relaxed('여유', 'RELAXED', AppColors.primary),
  normal('보통', 'NORMAL', AppColors.place),
  slightlyCrowded('약간 붐빔', 'SLIGHTLY_CROWDED', AppColors.animal),
  crowded('붐빔', 'CROWDED', AppColors.danger);

  const CongestionLevel(this.label, this.serverValue, this.color);

  final String label;
  final String serverValue;
  final Color color;

  /// 서버 등급 문자열을 enum으로 변환한다.
  ///
  /// **주의**: 서울시가 기존 4단계 외에 새 등급을 추가하면 매칭되지 않는다.
  /// 기본값으로 욱여넣지 않고 null을 돌려준다 — 색이 없어 그릴 수 없다.
  /// 이때도 [CongestionEntity.label]에는 원본 문자열이 담기므로 라벨만 표시한다.
  ///
  /// Returns: 매칭되는 [CongestionLevel], 알 수 없는 값이면 null
  static CongestionLevel? fromServer(String? value) {
    for (final level in CongestionLevel.values) {
      if (level.serverValue == value) return level;
    }
    return null;
  }
}

/// 공원 현재 혼잡도.
class CongestionEntity {
  const CongestionEntity({
    required this.level,
    required this.label,
    required this.collectedAt,
  });

  /// 혼잡도 등급. 서버가 모르는 값을 주면 null이다.
  final CongestionLevel? level;

  /// 등급의 한글 표기. 서울시 원본 문자열이라 level이 null이어도 항상 값이 있다.
  final String label;

  /// AI 서버가 데이터를 수집한 시각.
  ///
  /// **주의**: 서울시가 산정한 기준 시각보다 수십 분 늦을 수 있다.
  /// "현재 시각의 혼잡도"로 단정해 표기하지 않는다 — 화면에 노출하지 않는다.
  final DateTime? collectedAt;
}
