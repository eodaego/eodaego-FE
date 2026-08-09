import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../router/route_paths.dart';
import '../../../course/domain/entities/course_entity.dart';
import '../providers/place_catalog_provider.dart';
import 'map_marker.dart';

/// 마커를 누르면 지도 위에 뜨는 장소 카드.
///
/// 네이티브 `InfoWindow`를 대신한다 — 그건 Google Maps SDK가 그려서 앱 스타일을
/// 입힐 수 없고, 약도 모드에서는 아예 뜨지 않았다.
///
/// 코스 장소가 들고 있는 정보는 순서·이름·카테고리뿐이라, 나머지는 도감에서
/// 끌어온다([placeCatalogStatusProvider]). 도감 상태에 따라 카드가 세 얼굴을 갖는다.
class PlaceInfoCard extends ConsumerWidget {
  const PlaceInfoCard({super.key, required this.place, required this.onClose});

  final CoursePlaceEntity place;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref
        .watch(placeCatalogStatusProvider(placeName: place.name))
        .valueOrNull;

    // ③ 도감에 없는 시설은 아래로 붙일 게 없다. 한 줄을 이름 밑에 끼워 카드를
    // 짧게 둔다 — 따로 떼면 흰 여백만 남은 큰 상자로 보인다.
    //
    // 문구는 '코스에만 있는 장소예요'였다가 바꿨다. 코스와 도감이 별개 목록이라는
    // 내부 사정을 알아야 이해되는 말이었다.
    final onlyInCourse =
        status != null && status.collected == null && !status.inCatalog;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: const BorderSide(color: AppColors.line),
      ),
      // 지도 위에 뜨는 유일한 요소라 앱에서 예외적으로 그림자를 준다.
      elevation: 6,
      shadowColor: AppColors.scrim,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.base.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MapMarker(
                  number: place.visitOrder,
                  color: place.category.color,
                  size: 26,
                  elevated: false,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              place.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body15.copyWith(
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm.w),
                          AppBadge.category(place.category),
                        ],
                      ),
                      if (onlyInCourse) ...[
                        SizedBox(height: 2.h),
                        Text(
                          // 도감에 없는 곳이라는 사실 대신 여기서 할 수 있는 걸
                          // 말한다 — 못 하는 걸 앞세우면 고장난 것처럼 읽힌다.
                          '구경하고 가는 곳이에요',
                          style: AppTextStyles.caption14.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  tooltip: '닫기',
                  icon: Icon(Icons.close, size: 20.w, color: AppColors.muted),
                ),
              ],
            ),
            // 도감 조회 중에는 아래 절반을 그리지 않는다. 스켈레톤을 깔면 카드
            // 높이가 두 번 튀어(로딩 → 상태별) 지도를 가리는 면적이 출렁인다.
            if (status != null && !onlyInCourse) ...[
              SizedBox(height: 14.h),
              _CatalogBody(status: status),
            ],
          ],
        ),
      ),
    );
  }
}

/// 도감 상태별 본문 — 수집함(①)과 미수집(②)만 온다.
///
/// ③ 도감에 없는 시설은 찍어도 등록되지 않아 CTA가 없고, 안내 한 줄은 카드
/// 헤더가 직접 그린다.
class _CatalogBody extends StatelessWidget {
  const _CatalogBody({required this.status});

  final PlaceCatalogStatus status;

  @override
  Widget build(BuildContext context) {
    final collected = status.collected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Thumbnail(imageUrl: collected?.imageUrl),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusChip(collected: collected != null),
                  SizedBox(height: 6.h),
                  Text(
                    collected != null
                        ? '도감 ${collected.code ?? '-'}'
                        : '찍으면 도감에 등록돼요',
                    style: AppTextStyles.caption14.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        // ① 수집함 → 도감 상세로. ② 미수집 → 카메라로.
        if (collected != null)
          AppButton(
            text: '도감에서 보기',
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            showBorder: true,
            width: double.infinity,
            height: 52.h,
            // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            // 이미 받아둔 항목을 넘겨 상세에서 다시 조회하지 않게 한다.
            onPressed: () => context.push(
              RoutePaths.collectionDetail(collected.id),
              extra: collected,
            ),
          )
        else
          AppButton(
            text: '여기서 찍기',
            width: double.infinity,
            height: 52.h,
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            onPressed: () => context.go(RoutePaths.scan),
          ),
      ],
    );
  }
}

/// 수집한 항목만 실사 이미지를 준다 — 미수집은 서버가 `imageUrl`을 null로 가린다.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = 72.w;
    final placeholder = Container(
      width: size,
      height: size,
      color: AppColors.surfaceDim,
      alignment: Alignment.center,
      child: Text(
        '?',
        style: AppTextStyles.display26.copyWith(color: AppColors.uncollected),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      child: imageUrl == null
          ? placeholder
          : Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              // 원격 이미지는 실패가 정상 시나리오다. 깨진 아이콘 대신 `?`로 둔다.
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.collected});

  final bool collected;

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: collected ? '✓ 도감에 있어요' : '아직 못 만났어요',
      background: collected ? AppColors.primaryTint : AppColors.surfaceDim,
      foreground: collected ? AppColors.primaryDark : AppColors.muted,
    );
  }
}
