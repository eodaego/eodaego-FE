import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 도감 카테고리 — 카테고리 컬러 페어링 규칙의 단일 소스.
///
/// 서버는 `ANIMAL`/`PLANT`/`PLACE` 문자열을 쓴다. 변환은 [fromServer]를 거친다.
enum DogamCategory {
  animal(
    '동물',
    'ANIMAL',
    AppColors.animal,
    AppColors.animalTint,
    AppColors.animalDark,
    Icons.pets,
  ),
  plant(
    '식물',
    'PLANT',
    AppColors.plant,
    AppColors.plantTint,
    AppColors.plantDark,
    Icons.local_florist,
  ),
  place(
    '장소',
    'PLACE',
    AppColors.place,
    AppColors.placeTint,
    AppColors.placeDark,
    Icons.place,
  );

  const DogamCategory(
    this.label,
    this.serverValue,
    this.color,
    this.tint,
    this.dark,
    this.icon,
  );

  final String label;
  final String serverValue;
  final Color color;
  final Color tint;
  final Color dark;
  final IconData icon;

  /// 서버 카테고리 문자열을 enum으로 변환한다.
  ///
  /// **주의**: 서버에 카테고리가 추가되면 구버전 앱이 모르는 값을 받는다.
  /// 기본값으로 욱여넣지 않고 null을 돌려준다 — 색·아이콘이 없어 그릴 수 없다.
  ///
  /// Returns: 매칭되는 [DogamCategory], 알 수 없는 값이면 null
  static DogamCategory? fromServer(String? value) {
    for (final category in DogamCategory.values) {
      if (category.serverValue == value) return category;
    }
    return null;
  }
}
