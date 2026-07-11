import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_course.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../router/route_paths.dart';

/// 체류시간 필터 — 1시간 ≤70분 / 2시간 ≤150분 / 반나절 >150분 (스펙 §5.1)
enum _DurationFilter {
  oneHour('1시간', '⏱️', '가볍게 한 바퀴'),
  twoHours('2시간', '🕑', '천천히 둘러보기'),
  halfDay('반나절', '🌞', '구석구석 탐험');

  const _DurationFilter(this.label, this.emoji, this.subtitle);

  final String label;
  final String emoji;
  final String subtitle;

  bool matches(int minutes) => switch (this) {
        oneHour => minutes <= 70,
        twoHours => minutes <= 150,
        halfDay => minutes > 150,
      };
}

/// 출입문 옵션 (라벨, 이모지, 보조설명)
const List<(String, String, String)> _entranceOptions = [
  ('정문', '🚪', '능동 사거리 쪽'),
  ('후문', '🚇', '아차산역 쪽'),
  ('구의문', '🌳', '구의동 쪽'),
];

/// 관심분야 옵션 이모지·보조설명
const Map<DogamCategory, (String, String)> _interestMeta = {
  DogamCategory.animal: ('🦁', '동물 친구들을 만나요'),
  DogamCategory.plant: ('🌿', '풀과 나무를 관찰해요'),
  DogamCategory.place: ('📍', '공원 명소를 찾아가요'),
};

/// 코스 추천 (스텝 인디케이터) — 3스텝 조건 + 결과 카드 스와이프.
/// 미선택 = 전체 (건너뛰기 허용). 진입점(지도 시트 버튼)이 게스트 게이트를 담당.
class CourseRecommendPage extends ConsumerStatefulWidget {
  const CourseRecommendPage({super.key});

  @override
  ConsumerState<CourseRecommendPage> createState() =>
      _CourseRecommendPageState();
}

class _CourseRecommendPageState extends ConsumerState<CourseRecommendPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? _entrance; // null = 전체
  _DurationFilter? _duration;
  DogamCategory? _interest;

  /// 결과 카드 하트 — 즐겨찾기와 상태 공유 없음 (스펙 §9)
  final Set<String> _savedIds = {};

  List<MockCourse> get _filtered => mockCourses
      .where((c) =>
          (_entrance == null || c.entranceLabel == _entrance) &&
          (_duration == null || _duration!.matches(c.durationMinutes)) &&
          (_interest == null || c.category == _interest))
      .toList();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 선택 350ms 후 자동 다음 스텝 — 예약 시점 페이지 가드 (레이스 방지).
  void _autoAdvance(int fromPage) {
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || _currentPage != fromPage) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _back(BuildContext context) {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      context.pop();
    }
  }

  void _goWithCourse(MockCourse course) {
    ref.read(selectedCourseProvider.notifier).state = course;
    context.go(RoutePaths.map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBackAppBar(title: '코스 추천', onBack: () => _back(context)),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            SmoothPageIndicator(
              controller: _pageController,
              count: 4,
              effect: WormEffect(
                dotHeight: 8.h,
                dotWidth: 8.w,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.line,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _stepPage(
                    question: '어느 문으로 들어왔어?',
                    options: [
                      for (final (label, emoji, subtitle) in _entranceOptions)
                        _OptionCard(
                          emoji: emoji,
                          title: label,
                          subtitle: subtitle,
                          selected: _entrance == label,
                          selectedColor: AppColors.primary,
                          selectedTint: AppColors.primaryTint,
                          selectedForeground: AppColors.primaryDark,
                          onTap: () {
                            setState(() =>
                                _entrance = _entrance == label ? null : label);
                            if (_entrance != null) _autoAdvance(0);
                          },
                        ),
                    ],
                  ),
                  _stepPage(
                    question: '얼마나 놀다 갈까?',
                    options: [
                      for (final d in _DurationFilter.values)
                        _OptionCard(
                          emoji: d.emoji,
                          title: d.label,
                          subtitle: d.subtitle,
                          selected: _duration == d,
                          selectedColor: AppColors.primary,
                          selectedTint: AppColors.primaryTint,
                          selectedForeground: AppColors.primaryDark,
                          onTap: () {
                            setState(() =>
                                _duration = _duration == d ? null : d);
                            if (_duration != null) _autoAdvance(1);
                          },
                        ),
                    ],
                  ),
                  _stepPage(
                    question: '뭐가 제일 좋아?',
                    options: [
                      for (final entry in _interestMeta.entries)
                        _OptionCard(
                          emoji: entry.value.$1,
                          title: entry.key.label,
                          subtitle: entry.value.$2,
                          selected: _interest == entry.key,
                          selectedColor: entry.key.color,
                          selectedTint: entry.key.tint,
                          selectedForeground: entry.key.dark,
                          onTap: () {
                            setState(() => _interest =
                                _interest == entry.key ? null : entry.key);
                            if (_interest != null) _autoAdvance(2);
                          },
                        ),
                    ],
                  ),
                  _resultPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepPage({required String question, required List<Widget> options}) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            question,
            style: AppTextStyles.display24.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: 8.h),
          Text(
            '건너뛰어도 돼요 — 안 고르면 전체에서 추천해요',
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 24.h),
          for (final option in options) ...[
            option,
            SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }

  Widget _resultPage() {
    final results = _filtered;
    final summary = [
      _entrance ?? '전체',
      _duration?.label ?? '전체',
      _interest?.label ?? '전체',
    ].join(' · ');

    if (results.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '조건에 맞는 코스가 없어요',
              textAlign: TextAlign.center,
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
            SizedBox(height: 20.h),
            Center(
              child: AppButton(
                text: '조건 다시 고르기',
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.ink,
                showBorder: true,
                width: 240.w,
                height: 52.h,
                onPressed: () => _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Text(
            summary,
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: _ResultCards(
            // 필터가 바뀌면 내부 PageController 위치를 초기화하기 위해 재생성
            key: ValueKey('$summary-${results.length}'),
            results: results,
            savedIds: _savedIds,
            onToggleSaved: (course) => setState(() {
              _savedIds.contains(course.id)
                  ? _savedIds.remove(course.id)
                  : _savedIds.add(course.id);
            }),
            onGo: _goWithCourse,
          ),
        ),
      ],
    );
  }
}

/// 결과 카드 스와이프 — 내부 PageView가 가로 제스처를 소비 (외부 스텝과 충돌 없음).
class _ResultCards extends StatefulWidget {
  const _ResultCards({
    super.key,
    required this.results,
    required this.savedIds,
    required this.onToggleSaved,
    required this.onGo,
  });

  final List<MockCourse> results;
  final Set<String> savedIds;
  final void Function(MockCourse) onToggleSaved;
  final void Function(MockCourse) onGo;

  @override
  State<_ResultCards> createState() => _ResultCardsState();
}

class _ResultCardsState extends State<_ResultCards> {
  final PageController _controller = PageController(viewportFraction: 0.92);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.results.length,
            itemBuilder: (context, index) {
              final course = widget.results[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SingleChildScrollView(
                  child: CourseCard(
                    course: course,
                    saved: widget.savedIds.contains(course.id),
                    onToggleSaved: () => widget.onToggleSaved(course),
                    onGo: () => widget.onGo(course),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.results.length,
          effect: WormEffect(
            dotHeight: 8.h,
            dotWidth: 8.w,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.line,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

/// 옵션 카드 — radius 24 + 2px 테두리, 선택 시 tint 배경 + dark 텍스트 페어링.
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.selectedColor,
    required this.selectedTint,
    required this.selectedForeground,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool selected;
  final Color selectedColor;
  final Color selectedTint;
  final Color selectedForeground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? selectedTint : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: BorderSide(
          color: selected ? selectedColor : AppColors.line,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // 이모지 크기 지정용 — TextStyle 직접 생성이 허용된 유일한 예외
              Text(emoji, style: TextStyle(fontSize: 30.sp)),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.label16Semibold.copyWith(
                      color: selected ? selectedForeground : AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption14.copyWith(
                      color: selected ? selectedForeground : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
