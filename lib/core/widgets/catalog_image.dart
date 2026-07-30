import 'package:flutter/material.dart';

import '../constants/dogam_category.dart';

/// 도감 일러스트 위젯 — `code`로 에셋을 찾고, 없거나 로드에 실패하면 카테고리
/// 아이콘으로 대체한다.
///
/// **주의**: 에셋 존재 여부를 미리 검사하지 않는다. `Image.asset`의
/// `errorBuilder`가 곧 폴백이다 — `assets/images/catalog/`가 비어 있어도
/// (일러스트 작업 중) 화면은 카테고리 아이콘으로 정상 렌더링된다.
class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.category,
    required this.size,
    this.code,
    this.circle = false,
  });

  /// 도감 항목 코드 — `assets/images/catalog/{code}.png`를 가리킨다. null이면 아이콘으로 대체
  final String? code;

  /// 카테고리 — 아이콘·색 폴백에 쓴다
  final DogamCategory category;

  /// 위젯 한 변의 크기
  final double size;

  /// true면 원형으로 자르고 카테고리 tint 배경을 깐다 (도감 목록 행 썸네일용)
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final image = _buildImageOrIcon();

    if (!circle) return SizedBox(width: size, height: size, child: image);

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: category.tint,
        alignment: Alignment.center,
        child: image,
      ),
    );
  }

  Widget _buildImageOrIcon() {
    final code = this.code;
    if (code == null || code.isEmpty) return _categoryIcon();

    return Image.asset(
      'assets/images/catalog/$code.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _categoryIcon(),
    );
  }

  Widget _categoryIcon() {
    return Icon(category.icon, size: size * 0.6, color: category.color);
  }
}
