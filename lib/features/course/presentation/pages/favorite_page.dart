import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../providers/favorite_provider.dart';

/// 정렬 칩 — 칩 하나가 방향 토글로 서버 sort 두 값을 오간다.
enum _SortChip {
  recent('최근에 저장한 순', FavoriteSort.latest, FavoriteSort.oldest),
  duration('걸리는 시간 순', FavoriteSort.durationLong, FavoriteSort.durationShort);

  const _SortChip(this.label, this.desc, this.asc);

  final String label;

  /// 내림차순 — 최근순은 최신 먼저, 시간순은 긴 것 먼저
  final FavoriteSort desc;

  /// 오름차순
  final FavoriteSort asc;
}

/// 즐겨찾기 (탭) — 저장 코스 리스트 + 빈 상태. 정렬·저장/해제는 서버 기준.
class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  /// 서버 기본값이 LATEST라 최근순 내림차순으로 시작한다.
  _SortChip _sort = _SortChip.recent;
  bool _desc = true;

  FavoriteSort get _serverSort => _desc ? _sort.desc : _sort.asc;

  void _tapSort(_SortChip chip) {
    setState(() {
      if (_sort == chip) {
        _desc = !_desc; // 같은 칩 재탭 → 방향 토글
      } else {
        _sort = chip;
        _desc = true;
      }
    });
  }

  String _chipLabel(_SortChip chip) =>
      _sort == chip ? '${chip.label} ${_desc ? '↓' : '↑'}' : chip.label;

  /// 하트 해제 — 서버가 실패하면 목록이 그대로 돌아온다.
  Future<void> _unsave(CourseEntity course) async {
    final ok = await ref
        .read(favoriteToggleProvider.notifier)
        .toggle(courseId: course.id, favorite: false);

    if (!ok && mounted) {
      AppSnackbar.show(
        context,
        message: '저장을 지우지 못했어요. 잠시 후 다시 시도해 주세요',
        backgroundColor: AppColors.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 게스트는 토큰이 없다. 호출하면 401이 나고 인터셉터가 세션 만료로 오인해
    // 강제 로그아웃시킨다. 아예 부르지 않는다.
    final guest = ref.watch(guestRestrictedProvider);
    final state = guest
        ? const AsyncValue<List<CourseEntity>>.data([])
        : ref.watch(favoriteCoursesProvider(_serverSort));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.sm.h),
              Row(
                children: [
                  Text(
                    '저장한 코스',
                    style: AppTextStyles.display19.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  AppBadge(
                    label: '${state.valueOrNull?.length ?? 0}개',
                    background: AppColors.surfaceDim,
                    foreground: AppColors.muted,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                children: [
                  for (final chip in _SortChip.values) ...[
                    if (chip != _SortChip.values.first)
                      SizedBox(width: AppSpacing.sm.w),
                    CategoryChip(
                      label: _chipLabel(chip),
                      selected: _sort == chip,
                      onTap: () => _tapSort(chip),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: state.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (error, _) => Center(
                    child: Text(
                      error is AppException
                          ? error.message
                          : '저장한 코스를 불러오지 못했어요.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body15.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  data: (courses) => courses.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          itemCount: courses.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 14.h),
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return CourseCard(
                              key: ValueKey(course.id),
                              course: course,
                              saved: true,
                              onToggleSaved: () => _unsave(course),
                              onGo: () {
                                ref
                                        .read(selectedCourseProvider.notifier)
                                        .state =
                                    course;
                                context.go(RoutePaths.map);
                              },
                            );
                          },
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

/// 빈 상태 — 점선 원 하트 + 안내 + 지도 이동 버튼.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 96.w,
            height: 96.w,
            child: CustomPaint(
              painter: DashedRRectPainter(
                color: AppColors.uncollected,
                radius: 48.w,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 40.w,
                color: AppColors.uncollected,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.base.h),
          Text(
            '마음에 드는 코스에 하트를 누르면\n여기에 모아둘 수 있어요',
            textAlign: TextAlign.center,
            style: AppTextStyles.body15.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: AppSpacing.lg.h),
          AppButton(
            text: '지도에서 코스 보러 가기',
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.ink,
            showBorder: true,
            width: 260.w,
            height: 52.h,
            onPressed: () => context.go(RoutePaths.map),
          ),
        ],
      ),
    );
  }
}
