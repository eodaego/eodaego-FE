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
import '../../../../core/widgets/catalog_image.dart';
import '../../../../core/widgets/category_chip.dart';
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

  // Pull-to-refresh. The shell keeps this page alive across tab switches, so
  // the providers never auto-dispose and the catalog would otherwise be
  // fetched once per app launch with no way to pick up new server data.
  // 당겨서 새로고침. 셸이 탭을 옮겨도 이 페이지를 살려두기 때문에 프로바이더가
  // 스스로 사라지지 않는다. 그래서 앱 실행당 한 번만 조회하고 새 서버 데이터를
  // 받아올 방법이 없다.
  Future<void> _refresh() async {
    // 게스트는 애초에 조회하지 않는다 — 여기서 read하면 막아둔 요청이 나간다.
    if (ref.read(guestModeProvider)) return;

    // 홈·마이페이지가 함께 쓰는 요약도 같이 무효화한다. 목록만 갱신하면
    // 도감 뱃지와 홈 카드 숫자가 어긋난다.
    ref.invalidate(catalogItemsProvider);
    ref.invalidate(catalogSummaryProvider);

    try {
      // 새 값이 도착할 때까지 인디케이터를 유지한다.
      await ref.read(catalogItemsProvider.future);
    } catch (_) {
      // 실패는 화면이 에러 상태로 이미 알린다. 여기선 인디케이터만 닫는다.
    }
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
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  // 앱에 브랜드 colorScheme이 없어 기본값이 Material 보라로 나온다.
                  // 진행바·활성 탭과 같은 primary를 쓰고, canvas 위에 얹히므로
                  // 원 배경은 surface로 대비를 만든다.
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  // 어린이 기준으로 수치를 키우는 원칙에 맞춰 기본 2.0보다 두껍게.
                  strokeWidth: 3,
                  child: itemsAsync.when(
                    loading: () => const _CollectionListSkeleton(),
                    error: (_, _) => _CollectionError(
                      onRetry: () => ref.invalidate(catalogItemsProvider),
                    ),
                    data: (items) => _CollectionGrid(
                      items: _visible(_inCategory(items)),
                      isSearching: _query.isNotEmpty,
                    ),
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

/// 3열 그리드 공통 배치 — 목록과 스켈레톤이 같은 칸 크기를 쓰도록 한 곳에 둔다.
SliverGridDelegate _gridDelegate() => SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  mainAxisSpacing: 10.h,
  crossAxisSpacing: 10.w,
  // 썸네일(64) + 이름 + 카테고리 라벨이 들어갈 세로 여유.
  childAspectRatio: 0.8,
);

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
      final message = isSearching ? '다른 이름으로 찾아보세요' : '공원에서 만나면 여기에 모아둘 수 있어요';
      // The empty state is exactly when a refresh is most wanted, so it has to
      // stay draggable — a plain Center gives RefreshIndicator nothing to pull.
      // 비어 있을 때가 새로고침이 가장 필요한 순간이라 당겨지는 상태를 유지한다.
      // 그냥 Center를 두면 RefreshIndicator가 당길 대상을 못 찾는다.
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Text(
                message,
                style: AppTextStyles.body15.copyWith(color: AppColors.muted),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      // 항목이 한 화면을 못 채워도 당겨서 새로고침이 되게 한다.
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: _gridDelegate(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _CatalogGridCard(
          key: ValueKey(item.id),
          item: item,
          onTap: () =>
              context.push(RoutePaths.collectionDetail(item.id), extra: item),
        );
      },
    );
  }
}

/// 도감 그리드 카드 — 원형 썸네일(64) + 이름 + 카테고리 라벨.
///
/// 수집: 흰 카드 + 이름 + 카테고리 dark 라벨. 미수집: surfaceDim 카드에
/// 이름 자리는 `미수집`, 썸네일은 `?` — 무채색으로 그려 수집 완료와 대비를 만든다.
class _CatalogGridCard extends StatelessWidget {
  const _CatalogGridCard({super.key, required this.item, this.onTap});

  final CatalogItemEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final collected = item.collected;
    return Material(
      color: collected ? AppColors.surface : AppColors.surfaceDim,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        side: collected
            ? const BorderSide(color: AppColors.line)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _thumbnail(),
              SizedBox(height: 8.h),
              Text(
                collected ? (item.name ?? '') : '아직이에요',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tag13Bold.copyWith(
                  color: collected ? AppColors.ink : AppColors.uncollected,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                item.category.label,
                style: AppTextStyles.caption14.copyWith(
                  color: collected ? item.category.dark : AppColors.uncollected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail() {
    if (!item.collected) {
      return Container(
        width: 64.w,
        height: 64.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
        ),
        alignment: Alignment.center,
        child: Text(
          '?',
          style: AppTextStyles.display19.copyWith(color: AppColors.uncollected),
        ),
      );
    }
    return CatalogImage(
      imageUrl: item.imageUrl,
      code: item.code,
      category: item.category,
      size: 64.w,
      circle: true,
    );
  }
}

class _CollectionListSkeleton extends StatelessWidget {
  const _CollectionListSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: _gridDelegate(),
      itemCount: 9,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSkeleton(
              width: 64.w,
              height: 64.w,
              borderRadius: BorderRadius.circular(32.r),
            ),
            SizedBox(height: 8.h),
            AppSkeleton(width: 56.w, height: 13.h),
            SizedBox(height: 6.h),
            AppSkeleton(width: 32.w, height: 12.h),
          ],
        ),
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
          TextButton(onPressed: onRetry, child: const Text('다시 불러오기')),
        ],
      ),
    );
  }
}
