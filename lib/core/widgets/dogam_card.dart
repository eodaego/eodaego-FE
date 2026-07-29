import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/dogam_category.dart';
import '../constants/spacing_and_radius.dart';
import '../constants/text_styles.dart';
import 'app_skeleton.dart';

/// 도감 카드 — 수집: 2px 카테고리 테두리 + 사진(없으면 아이콘) + 이름 /
/// 미수집: surfaceDim + `?`.
///
/// 도감 그리드·정답 축하 화면에서 공용.
///
/// **주의**: 도메인 엔티티가 아니라 원시 필드를 받는다. core 위젯이 특정
/// feature의 domain 계층에 묶이지 않게 하기 위해서다.
class DogamCard extends StatelessWidget {
  const DogamCard({
    super.key,
    required this.category,
    required this.collected,
    this.name,
    this.imageUrl,
    this.onTap,
  });

  /// 카테고리 — 미수집이어도 색·아이콘에 쓴다
  final DogamCategory category;

  /// 수집 여부
  final bool collected;

  /// 이름 — 미수집이면 null
  final String? name;

  /// 사진 URL — 없으면 카테고리 아이콘으로 대체
  final String? imageUrl;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: collected ? AppColors.surface : AppColors.surfaceDim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        side: collected
            ? BorderSide(color: category.color, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              Expanded(child: Center(child: _buildThumbnail())),
              Text(
                collected ? (name ?? '') : '미수집',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tag13Bold.copyWith(
                  color: collected ? AppColors.ink : AppColors.uncollected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (!collected) {
      return Text(
        '?',
        style: AppTextStyles.display34.copyWith(color: AppColors.uncollected),
      );
    }

    final url = imageUrl;
    if (url == null || url.isEmpty) return _categoryIcon();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xs.r),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        // Decode at thumbnail size. A 3-column tile is ~110dp wide, so a
        // full-resolution decode costs ~13x the memory for no visible gain,
        // and the catalog runs to hundreds of items.
        // 썸네일 크기로 디코딩한다. 3열 타일은 110dp 남짓이라 원본 해상도로
        // 디코딩하면 보이는 차이 없이 메모리만 13배 쓴다. 도감 항목은 수백 개다.
        cacheWidth: _thumbnailCacheWidth,
        // 사진을 못 받아도 화면이 비지 않게 기존 아이콘으로 되돌린다
        errorBuilder: (context, error, stackTrace) => _categoryIcon(),
        // 로딩 중에는 스켈레톤을 보여준다 (spec §8)
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const AppSkeleton(
            width: double.infinity,
            height: double.infinity,
          );
        },
      ),
    );
  }

  Widget _categoryIcon() {
    return Icon(category.icon, size: 34.w, color: category.color);
  }
}

// Decode width for grid thumbnails: ~110dp tile at 3x device pixel ratio.
// 그리드 썸네일 디코딩 폭 — 110dp 타일 기준, 3배 DPR을 감안한 값.
const int _thumbnailCacheWidth = 340;
