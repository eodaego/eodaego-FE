import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/dogam_card.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/catalog_item_entity.dart';
import '../providers/catalog_provider.dart';

/// 도감 (CATALOG-01~03) — 필터·검색·3열 그리드.
///
/// 목록은 서버에서 한 번 받고 카테고리 필터·이름 검색은 로컬에서 건다.
class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  DogamCategory? _filter; // null = 전체
  String _query = '';

  // Applies the category filter only. 카테고리 필터만 적용한다.
  // 카운트 뱃지는 검색어에 영향받지 않아야 하므로 검색 전 단계를 따로 둔다.
  List<CatalogItemEntity> _inCategory(List<CatalogItemEntity> items) {
    if (_filter == null) return items;
    return items.where((e) => e.category == _filter).toList();
  }

  List<CatalogItemEntity> _visible(List<CatalogItemEntity> items) {
    if (_query.isEmpty) return items;
    return items.where((e) => (e.name ?? '').contains(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(guestModeProvider);
    // Guest has no token. Calling the list API here would 401, and the
    // interceptor would misread that as an expired session and force-log-out
    // a guest who was never logged in. So guests skip the request and see
    // an empty catalog — truthful, since a guest has never collected anything.
    // 게스트는 토큰이 없다. 여기서 목록 API를 부르면 401이 나고, 인터셉터가
    // 이를 세션 만료로 오인해 로그인한 적 없는 게스트를 강제 로그아웃시킨다.
    // 그래서 게스트는 조회를 하지 않고 빈 도감을 보여준다 — 게스트는 수집한
    // 적이 없으니 사실과 같다.
    final itemsAsync = isGuest
        ? const AsyncValue<List<CatalogItemEntity>>.data(<CatalogItemEntity>[])
        : ref.watch(catalogItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '도감',
                    style: AppTextStyles.display19.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  itemsAsync.when(
                    loading: () => AppSkeleton(width: 52.w, height: 22.h),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (items) {
                      final scoped = _inCategory(items);
                      final collected = scoped.where((e) => e.collected).length;
                      return AppBadge(
                        label: '$collected/${scoped.length}',
                        background: AppColors.primaryTint,
                        foreground: AppColors.primaryDark,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryChip(
                      label: '전체',
                      selected: _filter == null,
                      onTap: () => setState(() => _filter = null),
                    ),
                    for (final c in DogamCategory.values) ...[
                      SizedBox(width: 8.w),
                      CategoryChip(
                        label: c.label,
                        selected: _filter == c,
                        color: c.color,
                        onTap: () => setState(() => _filter = c),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                onChanged: (v) => setState(() => _query = v.trim()),
                style: AppTextStyles.body15.copyWith(color: AppColors.ink),
                decoration: InputDecoration(
                  hintText: '이름으로 찾기',
                  hintStyle: AppTextStyles.body15.copyWith(
                    color: AppColors.disabled,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: itemsAsync.when(
                  loading: () => const _CollectionGridSkeleton(),
                  error: (_, _) => _CollectionError(
                    onRetry: () => ref.invalidate(catalogItemsProvider),
                  ),
                  data: (items) => _CollectionGrid(
                    items: _visible(_inCategory(items)),
                    isSearching: _query.isNotEmpty,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3열 그리드 — 로딩·데이터가 같은 배치를 쓰도록 delegate를 공유한다.
SliverGridDelegate _gridDelegate() {
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 3 / 3.6,
    mainAxisSpacing: 10.h,
    crossAxisSpacing: 10.w,
  );
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.items, required this.isSearching});

  final List<CatalogItemEntity> items;

  /// 검색어가 있는 상태에서 결과가 없는 것인지 — 빈 문구를 가른다.
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      // 검색 결과가 없을 때만 검색 관련 문구를 보여준다. 카테고리 필터·빈
      // 도감·게스트 모드처럼 검색과 무관한 빈 상태에는 긍정형 안내를 쓴다.
      final message = isSearching
          ? '찾는 이름이 없어요. 다른 이름으로 찾아보세요'
          : '공원에서 만나면 여기에 모아둘 수 있어요';
      return Center(
        child: Text(
          message,
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: _gridDelegate(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return DogamCard(
          key: ValueKey(item.id),
          category: item.category,
          collected: item.collected,
          name: item.name,
          imageUrl: item.imageUrl,
          onTap: () =>
              context.push(RoutePaths.collectionDetail(item.id), extra: item),
        );
      },
    );
  }
}

class _CollectionGridSkeleton extends StatelessWidget {
  const _CollectionGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: _gridDelegate(),
      itemCount: 12,
      itemBuilder: (context, index) => AppSkeleton(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
      ),
    );
  }
}

class _CollectionError extends StatelessWidget {
  const _CollectionError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '도감을 불러오지 못했어요',
            style: AppTextStyles.body17.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: 12.h),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
