import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../core/widgets/dashed_rrect_painter.dart';
import '../../../../router/route_paths.dart';

/// 즐겨찾기 정렬 기준
enum _FavoriteSort {
  recent('최근 저장순'),
  duration('소요시간순');

  const _FavoriteSort(this.label);

  final String label;
}

/// 즐겨찾기 (탭) — 저장 코스 리스트 + 빈 상태.
/// 하트 해제는 화면 로컬 상태 (재진입 시 목 초기값으로 리셋 — 스펙 §10).
class FavoritePage extends ConsumerStatefulWidget {
  const FavoritePage({super.key});

  @override
  ConsumerState<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  late final List<MockCourse> _saved;

  /// null = 전체(저장 순서 그대로)
  _FavoriteSort? _sort;

  /// 첫 탭은 내림차순, 같은 칩 재탭 시 방향 토글
  bool _desc = true;

  @override
  void initState() {
    super.initState();
    // 게스트는 저장한 코스가 없음 — empty state로 시작 (게스트 스펙 §7.2)
    _saved = ref.read(guestRestrictedProvider) ? [] : mockCourses.take(3).toList(); // 저장 데모용 부분 시드 (전체 시드는 저장 기능 체감 저하)
  }

  /// 정렬 적용된 표시 리스트 — _saved(리스트 순서 = 저장 순서로 간주)는 불변 유지.
  List<MockCourse> get _displayed {
    switch (_sort) {
      case null:
        return _saved;
      case _FavoriteSort.recent:
        // desc = 최근 저장(리스트 뒤쪽)이 위로
        return _desc ? _saved.reversed.toList() : _saved;
      case _FavoriteSort.duration:
        final list = List.of(_saved)
          ..sort((a, b) => _desc
              ? b.durationMinutes.compareTo(a.durationMinutes)
              : a.durationMinutes.compareTo(b.durationMinutes));
        return list;
    }
  }

  void _tapSort(_FavoriteSort? mode) {
    setState(() {
      if (mode == null) {
        _sort = null;
        return;
      }
      if (_sort == mode) {
        _desc = !_desc; // 같은 칩 재탭 → 방향 토글
      } else {
        _sort = mode;
        _desc = true;
      }
    });
  }

  String _chipLabel(_FavoriteSort mode) =>
      _sort == mode ? '${mode.label} ${_desc ? '↓' : '↑'}' : mode.label;

  @override
  Widget build(BuildContext context) {
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
                    '저장한 코스',
                    style: AppTextStyles.display19
                        .copyWith(color: AppColors.ink),
                  ),
                  SizedBox(width: 8.w),
                  AppBadge(
                    label: '${_saved.length}개',
                    background: AppColors.surfaceDim,
                    foreground: AppColors.muted,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  CategoryChip(
                    label: '전체',
                    selected: _sort == null,
                    onTap: () => _tapSort(null),
                  ),
                  for (final mode in _FavoriteSort.values) ...[
                    SizedBox(width: 8.w),
                    CategoryChip(
                      label: _chipLabel(mode),
                      selected: _sort == mode,
                      onTap: () => _tapSort(mode),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: _saved.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        itemCount: _displayed.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final course = _displayed[index];
                          return CourseCard(
                            key: ValueKey(course.id),
                            course: course,
                            saved: true,
                            onToggleSaved: () =>
                                setState(() => _saved.remove(course)),
                            onGo: () => context.go(RoutePaths.map),
                          );
                        },
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
          SizedBox(height: 16.h),
          Text(
            '아직 저장한 코스가 없어요\n지도에서 마음에 드는 코스에 하트를 눌러요',
            textAlign: TextAlign.center,
            style: AppTextStyles.body15.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 20.h),
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
