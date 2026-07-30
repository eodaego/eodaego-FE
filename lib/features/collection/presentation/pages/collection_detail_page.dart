import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/catalog_image.dart';
import '../../domain/entities/catalog_item_detail_entity.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../providers/catalog_provider.dart';

/// 도감 상세 (CATALOG 상세) — 사진 영역·뱃지·어린이 눈높이 설명·수집일.
///
/// **주의**: 미수집 항목은 서버가 상세를 403으로 막는다. [item]의 `collected`가
/// false면 상세 API를 호출하지 않고 물음표 화면을 그린다.
class CollectionDetailPage extends ConsumerWidget {
  const CollectionDetailPage({super.key, required this.itemId, this.item});

  final String itemId;

  /// 목록에서 넘어온 항목. 딥링크로 바로 진입하면 null이다.
  final CatalogItemEntity? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listItem = item;

    // 미수집이면 서버를 부르지 않는다.
    if (listItem != null && !listItem.collected) {
      return _DetailScaffold(
        category: listItem.category,
        collected: false,
        child: const _UncollectedBody(),
      );
    }

    final detailAsync = ref.watch(catalogItemDetailProvider(itemId));

    return detailAsync.when(
      loading: () => _DetailScaffold(
        // 카테고리를 이미 아니까 색을 즉시 칠한다. 회색에서 컬러로 튀지 않는다.
        category: listItem?.category,
        // 목록이 이미 들고 있는 코드를 그대로 써서 로딩 중 깜빡임을 막는다.
        code: listItem?.code,
        collected: listItem?.collected ?? true,
        child: const _LoadingBody(),
      ),
      error: (_, _) => _DetailScaffold(
        category: listItem?.category,
        code: listItem?.code,
        collected: listItem?.collected ?? true,
        child: _ErrorBody(
          onRetry: () => ref.invalidate(catalogItemDetailProvider(itemId)),
        ),
      ),
      data: (detail) => _DetailScaffold(
        category: detail.category,
        code: detail.code,
        collected: true,
        child: _LoadedBody(detail: detail),
      ),
    );
  }
}

/// 상세 화면 뼈대 — 사진 영역과 본문 사이의 공통 배치.
class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({
    required this.child,
    required this.collected,
    this.category,
    this.code,
  });

  final Widget child;

  /// 히어로가 `?`(미수집)와 사진/아이콘(수집)을 가르는 기준.
  final bool collected;
  final DogamCategory? category;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '도감 상세'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(category: category, code: code, collected: collected),
            SizedBox(height: 16.h),
            child,
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

/// 사진 영역 — 카테고리 tint 배경 위에 미수집은 `?`, 수집은 `CatalogImage`
/// (코드로 찾은 사진, 없거나 실패하면 카테고리 아이콘)를 올린다.
class _Hero extends StatelessWidget {
  const _Hero({required this.collected, this.category, this.code});

  final bool collected;
  final DogamCategory? category;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg.r);
    final c = category;
    return Container(
      height: 260.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: c?.tint ?? AppColors.surfaceDim,
        borderRadius: radius,
      ),
      child: Center(
        child: !collected
            ? Text(
                '?',
                style: AppTextStyles.display34.copyWith(
                  color: AppColors.uncollected,
                ),
              )
            : (c == null
                  ? const SizedBox.shrink()
                  : CatalogImage(code: code, category: c, size: 120.w)),
      ),
    );
  }
}

/// 미수집 — 카테고리만 보여주고 나머지는 물음표.
class _UncollectedBody extends StatelessWidget {
  const _UncollectedBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppBadge(
          label: '미수집',
          background: AppColors.surfaceDim,
          foreground: AppColors.uncollected,
        ),
        SizedBox(height: 12.h),
        Text(
          '?',
          style: AppTextStyles.display26.copyWith(color: AppColors.uncollected),
        ),
        SizedBox(height: 8.h),
        Text(
          '아직 만나지 못했어요. 공원에서 찾아보세요',
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}

/// 로딩 — 카테고리 색은 이미 칠했고 글자 자리만 스켈레톤.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(width: 72.w, height: 24.h),
        SizedBox(height: 12.h),
        AppSkeleton(width: 140.w, height: 30.h),
        SizedBox(height: 8.h),
        AppSkeleton(width: double.infinity, height: 20.h),
        SizedBox(height: 16.h),
        AppSkeleton(
          width: double.infinity,
          height: 120.h,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '도감 정보를 불러오지 못했어요',
          style: AppTextStyles.body17.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: 12.h),
        TextButton(onPressed: onRetry, child: const Text('다시 시도')),
      ],
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.detail});

  final CatalogItemDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppBadge.category(detail.category),
            SizedBox(width: 8.w),
            const AppBadge(
              label: '수집 완료',
              background: AppColors.primaryTint,
              foreground: AppColors.primaryDark,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          detail.name,
          style: AppTextStyles.display26.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: 8.h),
        Text(
          detail.feature,
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '어린이 눈높이 설명',
                style: AppTextStyles.display16.copyWith(
                  color: detail.category.dark,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                detail.childDescription,
                style: AppTextStyles.body17.copyWith(color: AppColors.ink),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        if (detail.collectedAt != null)
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18.w,
                color: AppColors.muted,
              ),
              SizedBox(width: 6.w),
              Text(
                '${detail.collectedAt}에 만났어요',
                style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
            ],
          ),
      ],
    );
  }
}
