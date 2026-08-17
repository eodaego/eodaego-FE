import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../router/route_paths.dart';
import '../../../course/domain/entities/course_entity.dart';
import '../../../course/presentation/providers/favorite_provider.dart';
import 'map_marker.dart';

/// 지도 하단 드래그 시트 — 지금 보는 코스 + 코스 추천 진입.
/// 추천 자체는 전용 페이지(/course/recommend)로 분리 (스펙 §4).
/// 게스트(restricted)는 추천 진입 대신 인라인 로그인 유도.
class CourseSheet extends ConsumerWidget {
  const CourseSheet({super.key, this.onPlaceTap, this.selectedPlaceName});

  /// 접힘·펼침 두 지점만 쓴다(snap).
  static const _collapsed = 0.22;
  static const _expanded = 0.5;

  /// 목록에서 장소를 고름. 지도의 마커 선택과 같은 동작으로 이어진다.
  final ValueChanged<CoursePlaceEntity>? onPlaceTap;

  /// 지금 선택된 장소의 이름. 해당 줄을 카테고리 틴트로 짚어 준다.
  final String? selectedPlaceName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(selectedCourseProvider);
    final restricted = ref.watch(guestRestrictedProvider);
    return DraggableScrollableSheet(
      initialChildSize: _collapsed,
      minChildSize: _collapsed,
      maxChildSize: _expanded,
      snap: true,
      snapSizes: const [_collapsed, _expanded],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl.r),
            ),
            border: const Border(top: BorderSide(color: AppColors.line)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            children: [
              SizedBox(height: AppSpacing.md.h),
              Center(
                child: Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              if (course == null)
                Text(
                  '코스를 고르면 여기에 표시돼요',
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '지금 보는 코스',
                            style: AppTextStyles.caption14.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            course.title,
                            style: AppTextStyles.display16.copyWith(
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 즐겨찾기는 서버에 회원 기준으로 저장된다. 게스트에게 하트를
                    // 주면 눌러도 401이 난다.
                    if (!restricted) _FavoriteButton(course: course),
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
                for (final (index, place) in course.places.indexed) ...[
                  // 순서 사이만 끊는다. 첫 줄 위에 선이 붙으면 코스 제목과
                  // 목록이 분리돼 딴 블록처럼 보인다.
                  if (index > 0)
                    Divider(height: 12.h, thickness: 1, color: AppColors.line),
                  _PlaceRow(
                    place: place,
                    selected: place.name == selectedPlaceName,
                    onTap: () => onPlaceTap?.call(place),
                  ),
                ],
              ],
              SizedBox(height: AppSpacing.sm.h),
              if (restricted)
                const _GuestGate()
              else
                AppButton(
                  text: '코스 추천 받기',
                  width: double.infinity,
                  height: 52.h,
                  onPressed: () => context.push(RoutePaths.courseRecommend),
                ),
              SizedBox(height: AppSpacing.xl.h),
            ],
          ),
        );
      },
    );
  }
}

/// 코스 장소 한 줄 — 누르면 지도 마커를 고른 것과 같다.
///
/// 마커가 겹쳐서 안 보이는 장소(실제 지도에서 흔하다)는 이 목록이 유일한 입구다.
class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    required this.selected,
    required this.onTap,
  });

  final CoursePlaceEntity place;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 시트 배경은 Material이 아니라 Container다. 잉크가 번질 자리를 만들어 준다.
    return Material(
      // 선택 표시는 마커와 같은 규칙 — 카테고리 계열 안에서만 움직인다.
      color: selected ? place.category.tint : AppColors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.sm.h,
          ),
          child: Row(
            children: [
              MapMarker(
                // 지도 마커와 같은 번호를 써야 한다 — 목록에서 고른 줄과
                // 지도에서 켜지는 마커가 어긋나면 연결 자체가 무너진다.
                number: place.visitOrder,
                color: selected ? place.category.dark : place.category.color,
                checkColor: place.collected ? place.category.dark : null,
                size: 26,
                elevated: false,
              ),
              SizedBox(width: 10.w),
              // 이름이 남은 폭을 다 먹어야 뱃지가 오른쪽 끝에 고정된다.
              // Flexible + Spacer 조합이면 둘이 여백을 반씩 나눠 가져서
              // 뱃지 위치가 이름 길이마다 달라진다.
              Expanded(
                child: Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body15.copyWith(color: AppColors.ink),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              AppBadge.category(place.category),
            ],
          ),
        ),
      ),
    );
  }
}

/// 지금 보는 코스의 하트.
///
/// 화면을 먼저 뒤집고 서버가 실패하면 되돌린다 — 코스 추천 결과 카드의 하트와
/// 같은 규칙이다. 등록·삭제 둘 다 멱등이라 더블탭이 안전하다.
///
/// 뒤집는 대상이 [selectedCourseProvider]라 지도 마커·홈 코스 카드가 함께 따라온다.
class _FavoriteButton extends ConsumerStatefulWidget {
  const _FavoriteButton({required this.course});

  final CourseEntity course;

  @override
  ConsumerState<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<_FavoriteButton> {
  Future<void> _toggle() async {
    final course = widget.course;
    final next = !course.favorite;

    ref.read(selectedCourseProvider.notifier).state = course.copyWith(
      favorite: next,
    );

    final ok = await ref
        .read(favoriteToggleProvider.notifier)
        .toggle(courseId: course.id, favorite: next);

    if (!ok && mounted) {
      ref.read(selectedCourseProvider.notifier).state = course.copyWith(
        favorite: !next,
      );
      AppSnackbar.show(
        context,
        message: '저장하지 못했어요. 잠시 후 다시 시도해 주세요',
        backgroundColor: AppColors.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = widget.course.favorite;
    return IconButton(
      onPressed: _toggle,
      tooltip: saved ? '저장 지우기' : '저장',
      icon: Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        size: 24.w,
        color: AppColors.primary,
      ),
    );
  }
}

/// 게스트 인라인 게이트 — 추천 진입 버튼 자리 대체 (게스트 스펙 §3.5).
class _GuestGate extends ConsumerWidget {
  const _GuestGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.sm.h),
        Icon(Icons.lock_outline, size: 32.w, color: AppColors.uncollected),
        SizedBox(height: 10.h),
        Text(
          '로그인하면 코스 추천을 받을 수 있어요',
          textAlign: TextAlign.center,
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppSpacing.base.h),
        Center(
          child: AppButton(
            text: '로그인하러 가기',
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            showBorder: true,
            width: 240.w,
            height: 52.h,
            onPressed: () {
              ref.read(guestModeProvider.notifier).state = false;
              context.go(RoutePaths.login);
            },
          ),
        ),
      ],
    );
  }
}
