import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../router/route_paths.dart';
import 'map_marker.dart';

/// 체류시간 필터 — 1시간 ≤70분 / 2시간 ≤150분 / 반나절 >150분 (스펙 §3.3)
enum _DurationFilter {
  oneHour('1시간'),
  twoHours('2시간'),
  halfDay('반나절');

  const _DurationFilter(this.label);

  final String label;

  bool matches(int minutes) => switch (this) {
        oneHour => minutes <= 70,
        twoHours => minutes <= 150,
        halfDay => minutes > 150,
      };
}

/// 지도 하단 드래그 시트 — 선택 코스 요약 + 칩 필터 즉석 추천.
/// 접힘(22%)엔 선택 코스 헤더, 확장(80%)엔 추천 섹션.
/// 게스트는 추천 섹션 대신 인라인 로그인 유도 (스펙 §3.5).
class CourseSheet extends ConsumerStatefulWidget {
  const CourseSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final MockCourse selected;
  final ValueChanged<MockCourse> onSelect;

  @override
  ConsumerState<CourseSheet> createState() => _CourseSheetState();
}

class _CourseSheetState extends ConsumerState<CourseSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  static const List<String> _entrances = ['정문', '후문', '구의문'];

  String? _entrance; // null = 전체
  _DurationFilter? _duration;
  DogamCategory? _interest;

  /// 시트 로컬 하트 — 즐겨찾기 페이지와 상태 공유 없음 (스펙 §8)
  final Set<String> _savedIds = {};

  List<MockCourse> get _filtered => mockCourses
      .where((c) =>
          (_entrance == null || c.entranceLabel == _entrance) &&
          (_duration == null || _duration!.matches(c.durationMinutes)) &&
          (_interest == null || c.category == _interest))
      .toList();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(MockCourse course) {
    widget.onSelect(course);
    // 선택한 코스가 지도에 드러나도록 접힘 높이로 스냅
    _controller.animateTo(
      0.22,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(guestModeProvider);
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.22,
      minChildSize: 0.22,
      maxChildSize: 0.8,
      snap: true,
      snapSizes: const [0.22, 0.8],
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
              SizedBox(height: 12.h),
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
              SizedBox(height: 12.h),
              _selectedHeader(),
              SizedBox(height: 16.h),
              const Divider(color: AppColors.line, height: 1),
              SizedBox(height: 16.h),
              if (isGuest) _guestGate() else ..._recommendSection(),
              SizedBox(height: 32.h),
            ],
          ),
        );
      },
    );
  }

  /// 접힘 상태에서 보이는 상단 — 지금 지도에 그려진 코스.
  Widget _selectedHeader() {
    final course = widget.selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '지금 보는 코스',
          style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: 6.h),
        Text(
          course.title,
          style: AppTextStyles.display16.copyWith(color: AppColors.ink),
        ),
        SizedBox(height: 12.h),
        for (var i = 0; i < course.places.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                MapMarker(
                  number: i + 1,
                  color: course.places[i].category.color,
                  size: 26,
                ),
                SizedBox(width: 10.w),
                Text(
                  course.places[i].name,
                  style: AppTextStyles.body15.copyWith(color: AppColors.ink),
                ),
                const Spacer(),
                AppBadge.category(course.places[i].category),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _recommendSection() {
    final results = _filtered;
    return [
      Text(
        '코스 추천',
        style: AppTextStyles.display16.copyWith(color: AppColors.ink),
      ),
      SizedBox(height: 4.h),
      Text(
        '조건을 고르면 딱 맞는 코스를 보여줘요',
        style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
      ),
      SizedBox(height: 12.h),
      _chipRow([
        for (final e in _entrances)
          CategoryChip(
            label: e,
            selected: _entrance == e,
            onTap: () =>
                setState(() => _entrance = _entrance == e ? null : e),
          ),
      ]),
      SizedBox(height: 8.h),
      _chipRow([
        for (final d in _DurationFilter.values)
          CategoryChip(
            label: d.label,
            selected: _duration == d,
            onTap: () =>
                setState(() => _duration = _duration == d ? null : d),
          ),
      ]),
      SizedBox(height: 8.h),
      _chipRow([
        for (final c in DogamCategory.values)
          CategoryChip(
            label: c.label,
            selected: _interest == c,
            color: c.color,
            onTap: () =>
                setState(() => _interest = _interest == c ? null : c),
          ),
      ]),
      SizedBox(height: 16.h),
      if (results.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Center(
            child: Text(
              '조건에 맞는 코스가 없어요',
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
          ),
        )
      else
        for (final course in results) _courseRow(course),
    ];
  }

  Widget _chipRow(List<Widget> chips) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips)
            Padding(padding: EdgeInsets.only(right: 8.w), child: chip),
        ],
      ),
    );
  }

  Widget _courseRow(MockCourse course) {
    final selected = course.id == widget.selected.id;
    final saved = _savedIds.contains(course.id);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: selected ? AppColors.primaryTint : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.line,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          onTap: () => _select(course),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: AppTextStyles.label16Semibold.copyWith(
                          color: selected
                              ? AppColors.primaryDark
                              : AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          AppBadge.category(course.category,
                              label: course.tagLabel),
                          SizedBox(width: 6.w),
                          AppBadge(
                            label: course.durationLabel,
                            background: AppColors.surfaceDim,
                            foreground: AppColors.muted,
                          ),
                          SizedBox(width: 6.w),
                          AppBadge(
                            label: '${course.places.length}곳',
                            background: AppColors.surfaceDim,
                            foreground: AppColors.muted,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    saved
                        ? _savedIds.remove(course.id)
                        : _savedIds.add(course.id);
                  }),
                  tooltip: saved ? '저장 해제' : '저장',
                  icon: Icon(
                    saved ? Icons.favorite : Icons.favorite_border,
                    size: 22.w,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 게스트 인라인 게이트 — 추천 섹션 자리 대체 (다이얼로그 아님, 스펙 §3.5).
  Widget _guestGate() {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Icon(Icons.lock_outline, size: 32.w, color: AppColors.uncollected),
        SizedBox(height: 10.h),
        Text(
          '로그인하면 코스 추천을 받을 수 있어요',
          textAlign: TextAlign.center,
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: 16.h),
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
