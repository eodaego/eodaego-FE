import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/dogam_category.dart';
import 'app_skeleton.dart';

/// 도감 일러스트 위젯 — 3단 폴백으로 사진을 찾는다.
///
/// [imageUrl](서버 사진) → [code](로컬 에셋 `assets/images/catalog/{code}.png`)
/// → 카테고리 아이콘 순서다.
///
/// **주의**: 어느 단계도 존재 여부를 미리 검사하지 않는다. `CachedNetworkImage`의
/// `errorWidget`과 `Image.asset`의 `errorBuilder`가 곧 다음 단계로의 폴백이다 —
/// `assets/images/catalog/`가 비어 있어도(일러스트 작업 중) 화면은 카테고리
/// 아이콘으로 정상 렌더링된다.
class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.category,
    required this.size,
    this.imageUrl,
    this.code,
    this.circle = false,
  });

  /// 서버 사진 URL — 있으면 최우선으로 쓴다. null/실패면 [code] 단계로 넘어간다
  final String? imageUrl;

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
    final image = _buildImage();

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

  Widget _buildImage() {
    final url = imageUrl;
    if (url == null || url.isEmpty) return _assetOrIcon();

    return CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      // 로딩 중 아이콘이 잠깐 보였다 사진으로 바뀌지 않게 스켈레톤을 깐다
      placeholder: (context, url) => AppSkeleton(width: size, height: size),
      // 네트워크 실패(404 포함)면 로컬 에셋 단계로 넘어간다
      errorWidget: (context, url, error) => _assetOrIcon(),
    );
  }

  Widget _assetOrIcon() {
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
