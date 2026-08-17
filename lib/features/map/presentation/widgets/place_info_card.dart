import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/catalog_image.dart';
import '../../../../router/route_paths.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
import '../../../course/domain/entities/course_entity.dart';
import 'map_marker.dart';

/// 마커를 누르면 지도 위에 뜨는 장소 카드.
///
/// 네이티브 `InfoWindow`를 대신한다 — 그건 Google Maps SDK가 그려서 앱 스타일을
/// 입힐 수 없고, 약도 모드에서는 아예 뜨지 않았다.
///
/// 도감 상태는 코스 응답이 함께 준다(`collected`·`catalogItemId`). 그에 따라
/// 카드가 세 얼굴을 갖는다. 사진과 도감 코드가 필요한 ①만 도감 상세를 부른다.
class PlaceInfoCard extends ConsumerWidget {
  const PlaceInfoCard({super.key, required this.place, required this.onClose});

  final CoursePlaceEntity place;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ③ 도감에 없는 시설은 아래로 붙일 게 없다. 한 줄을 이름 밑에 끼워 카드를
    // 짧게 둔다 — 따로 떼면 흰 여백만 남은 큰 상자로 보인다.
    //
    // 문구는 '코스에만 있는 장소예요'였다가 바꿨다. 코스와 도감이 별개 목록이라는
    // 내부 사정을 알아야 이해되는 말이었다.
    final catalogItemId = place.catalogItemId;
    final onlyInCourse = catalogItemId == null;

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
                  checkColor: place.collected ? place.category.dark : null,
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
            if (catalogItemId != null) ...[
              SizedBox(height: 14.h),
              _CatalogBody(
                catalogItemId: catalogItemId,
                collected: place.collected,
                category: place.category,
              ),
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
///
/// ②는 서버를 부르지 않아 첫 프레임에 완성된다. ①만 사진과 도감 코드를 위해
/// 상세를 부르는데, 수집 여부를 이미 알고 있으니 칩과 버튼은 먼저 그려 둔다 —
/// 도착을 기다렸다가 그리면 카드 높이가 튀어 지도를 가리는 면적이 출렁인다.
///
/// **주의**: 미수집 항목의 상세는 서버가 403으로 막는다. [collected]가 false면
/// 절대 부르지 않는다.
class _CatalogBody extends ConsumerWidget {
  const _CatalogBody({
    required this.catalogItemId,
    required this.collected,
    required this.category,
  });

  final String catalogItemId;
  final bool collected;
  final DogamCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = collected
        ? ref.watch(catalogItemDetailProvider(catalogItemId)).valueOrNull
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm.r),
              // ① 사진은 서버 사진 → 로컬 일러스트 → 카테고리 아이콘 3단 폴백을
              // 타는 공용 위젯에 맡긴다. `?`는 이 앱에서 미수집을 뜻하는 글자라
              // '도감에 있어요' 옆에 두면 서로 어긋난다.
              child: collected
                  ? CatalogImage(
                      category: category,
                      size: 72.w,
                      imageUrl: detail?.imageUrl,
                      code: detail?.code,
                    )
                  : const _UnmetThumbnail(),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusChip(collected: collected),
                  SizedBox(height: 6.h),
                  Text(
                    // 도착 전에는 빈 줄로 자리만 잡는다. '-'를 깔면 코드가
                    // 도착하는 순간 글자가 갈아끼워지는 게 보인다.
                    collected
                        ? (detail == null ? '' : '도감 ${detail.code ?? '-'}')
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
        if (collected)
          AppButton(
            text: '도감에서 보기',
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            showBorder: true,
            width: double.infinity,
            height: 52.h,
            // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            // 방금 부른 상세가 캐시에 올라가 있어 상세 화면은 다시 조회하지 않는다.
            onPressed: () =>
                context.push(RoutePaths.collectionDetail(catalogItemId)),
          )
        else
          AppButton(
            text: '여기서 찍기',
            width: double.infinity,
            height: 52.h,
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            // push다 — go로 보내면 스택이 갈려 촬영 화면의 닫기(pop)가 터진다.
            // 탭바 중앙 카메라 버튼도 같은 이유로 push를 쓴다.
            onPressed: () => context.push(RoutePaths.scan),
          ),
      ],
    );
  }
}

/// ② 아직 못 모은 자리 — 서버가 사진을 가리므로 도감 목록과 같은 `?`를 둔다.
class _UnmetThumbnail extends StatelessWidget {
  const _UnmetThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      height: 72.w,
      color: AppColors.surfaceDim,
      alignment: Alignment.center,
      child: Text(
        '?',
        style: AppTextStyles.display26.copyWith(color: AppColors.uncollected),
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
