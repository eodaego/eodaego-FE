import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/option_grid.dart';

/// 희망 체류시간 선택지 — 서버에는 분(int)으로 보낸다.
enum _StayDuration {
  oneHour('1시간', Icons.hourglass_bottom_rounded, '가볍게 한 바퀴', 60),
  twoHours('2시간', Icons.access_time_filled_rounded, '천천히 둘러보기', 120),
  halfDay('반나절', Icons.wb_sunny_rounded, '구석구석 탐험', 240);

  const _StayDuration(this.label, this.icon, this.subtitle, this.minutes);

  final String label;
  final IconData icon;
  final String subtitle;
  final int minutes;
}

/// 동행 유형 선택지 아이콘·보조설명
const Map<CompanionType, (IconData, String)> _companionMeta = {
  CompanionType.alone: (Icons.directions_walk_rounded, '내 속도로 걸어요'),
  CompanionType.withChild: (Icons.child_care_rounded, '아이 눈높이로 골라요'),
  CompanionType.withPartner: (Icons.favorite_rounded, '둘이 걷기 좋은 길로'),
  CompanionType.withFriends: (Icons.groups_rounded, '같이 놀 거리 위주로'),
  CompanionType.withElderly: (Icons.elderly_rounded, '쉬어갈 곳을 넉넉히'),
};

/// 관심분야 선택지 아이콘
const Map<InterestType, IconData> _interestIcons = {
  InterestType.animal: Icons.pets_rounded,
  InterestType.nature: Icons.park_rounded,
  InterestType.activity: Icons.attractions_rounded,
  InterestType.photoSpot: Icons.photo_camera_rounded,
  InterestType.relaxation: Icons.deck_rounded,
  InterestType.cultureEvent: Icons.festival_rounded,
  InterestType.learning: Icons.menu_book_rounded,
};

/// 코스 추천 스텝별 하단 버튼 라벨과 활성 여부. 순수 함수 — 위젯 없이 단위 테스트 가능.
({String label, bool enabled}) courseStepFooter(
  int page, {
  required bool selected,
}) {
  // 입구(0)·출구(1)는 필수라 고르기 전엔 넘어갈 수 없다.
  if (page <= 1) return (label: '다음', enabled: selected);
  // 동행(4)이 마지막 조건 스텝이라 여기서 바로 추천을 요청한다.
  if (page == 4) {
    return (label: selected ? '코스 추천받기' : '건너뛰기', enabled: true);
  }
  return (label: selected ? '다음' : '건너뛰기', enabled: true);
}

/// 코스 추천 (스텝 인디케이터) — 5스텝 조건 + 결과 카드 스와이프.
/// 입구·출구는 필수, 나머지는 건너뛰기 허용. 진입점(지도 시트 버튼)이 게스트 게이트를 담당.
class CourseRecommendPage extends ConsumerStatefulWidget {
  const CourseRecommendPage({super.key});

  @override
  ConsumerState<CourseRecommendPage> createState() =>
      _CourseRecommendPageState();
}

class _CourseRecommendPageState extends ConsumerState<CourseRecommendPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  ParkGate? _entrance;
  ParkGate? _exit;
  _StayDuration? _duration;
  final Set<InterestType> _interests = {};
  CompanionType? _companion;

  Timer? _advanceTimer;

  @override
  void dispose() {
    _advanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// 선택 350ms 후 자동 진행. 재선택 시 앞선 예약을 취소한다.
  void _scheduleAdvance(int fromPage, VoidCallback action) {
    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted || _currentPage != fromPage) return;
      action();
    });
  }

  /// 다음 페이지로 넘긴다 (건너뛰기·확정 공용).
  void _advanceFrom(int fromPage) {
    // 버튼을 먼저 누른 경우 남은 예약이 한 번 더 넘기는 것을 막는다.
    _advanceTimer?.cancel();
    if (_currentPage != fromPage) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// 마지막 조건 스텝에서 결과로 넘어가며 추천을 1회 요청한다.
  void _goToResult() {
    _advanceTimer?.cancel();
    final entrance = _entrance;
    final exit = _exit;
    // 입구·출구는 필수라 여기 도달하면 반드시 채워져 있다. 방어적 가드다.
    if (entrance == null || exit == null) return;

    ref
        .read(courseRecommendationProvider.notifier)
        .request(
          entrance: entrance,
          exit: exit,
          interestTypes: _interests.isEmpty ? null : _interests.toList(),
          stayDurationMinutes: _duration?.minutes,
          companionType: _companion,
        );
    _advanceFrom(4);
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

  /// 하트 — 화면을 먼저 뒤집고, 서버가 실패하면 되돌린다.
  Future<void> _toggleFavorite(CourseEntity course) async {
    final next = !course.favorite;
    final notifier = ref.read(courseRecommendationProvider.notifier);
    notifier.markFavorite(course.id, next);

    final ok = await ref
        .read(favoriteToggleProvider.notifier)
        .toggle(courseId: course.id, favorite: next);

    if (!ok && mounted) {
      notifier.markFavorite(course.id, !next);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장하지 못했어요. 잠시 후 다시 시도해 주세요.')),
      );
    }
  }

  void _goWithCourse(CourseEntity course) {
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
              count: 6,
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
                    hint: '들어온 문과 나갈 문을 알려주면 동선을 맞춰 짜요',
                    grid: _gateGrid(
                      selected: _entrance,
                      onSelect: (gate) {
                        setState(() => _entrance = gate);
                        _scheduleAdvance(0, () => _advanceFrom(0));
                      },
                    ),
                  ),
                  _stepPage(
                    question: '어느 문으로 나갈까?',
                    hint: '들어온 문과 나갈 문을 알려주면 동선을 맞춰 짜요',
                    grid: _gateGrid(
                      selected: _exit,
                      onSelect: (gate) {
                        setState(() => _exit = gate);
                        _scheduleAdvance(1, () => _advanceFrom(1));
                      },
                    ),
                  ),
                  _stepPage(
                    question: '얼마나 놀다 갈까?',
                    hint: '건너뛰면 전체에서 골라 추천해요',
                    grid: OptionGrid(
                      columns: 2,
                      aspectRatio: 1.85,
                      children: [
                        for (final d in _StayDuration.values)
                          OptionTile(
                            icon: d.icon,
                            label: d.label,
                            subtitle: d.subtitle,
                            selected: _duration == d,
                            onTap: () {
                              setState(
                                () => _duration = _duration == d ? null : d,
                              );
                              // 선택을 풀면 예약도 함께 걷어낸다.
                              _advanceTimer?.cancel();
                              if (_duration != null) {
                                _scheduleAdvance(2, () => _advanceFrom(2));
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  // 관심분야는 복수 선택이라 자동 넘김 없이 하단 버튼으로만 확정한다.
                  _stepPage(
                    question: '뭐가 제일 좋아?',
                    hint: '여러 개 골라도 좋아요. 건너뛰면 전체에서 골라 추천해요',
                    grid: OptionGrid(
                      columns: 3,
                      aspectRatio: 1.3,
                      children: [
                        for (final type in InterestType.values)
                          OptionTile(
                            icon: _interestIcons[type],
                            label: type.label,
                            selected: _interests.contains(type),
                            onTap: () => setState(() {
                              _interests.contains(type)
                                  ? _interests.remove(type)
                                  : _interests.add(type);
                            }),
                          ),
                      ],
                    ),
                  ),
                  _stepPage(
                    question: '누구랑 왔어?',
                    hint: '건너뛰면 전체에서 골라 추천해요',
                    grid: OptionGrid(
                      columns: 2,
                      aspectRatio: 1.85,
                      children: [
                        for (final entry in _companionMeta.entries)
                          OptionTile(
                            icon: entry.value.$1,
                            label: entry.key.label,
                            subtitle: entry.value.$2,
                            selected: _companion == entry.key,
                            onTap: () {
                              setState(
                                () => _companion = _companion == entry.key
                                    ? null
                                    : entry.key,
                              );
                              _advanceTimer?.cancel();
                              if (_companion != null) {
                                _scheduleAdvance(4, _goToResult);
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  _resultPage(),
                ],
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  /// 하단 고정 버튼 — 스텝마다 자리가 같아야 레이아웃이 흔들리지 않는다.
  /// 결과 스텝은 코스 카드 안에 CTA가 있어 버튼을 두지 않는다.
  Widget _footer() {
    final page = _currentPage;
    if (page == 5) return const SizedBox.shrink();

    final selected = switch (page) {
      0 => _entrance != null,
      1 => _exit != null,
      2 => _duration != null,
      3 => _interests.isNotEmpty,
      _ => _companion != null,
    };
    final footer = courseStepFooter(page, selected: selected);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg.w,
        right: AppSpacing.lg.w,
        bottom: AppSpacing.md.h,
      ),
      child: AppButton(
        text: footer.label,
        onPressed: !footer.enabled
            ? null
            : (page == 4 ? _goToResult : () => _advanceFrom(page)),
      ),
    );
  }

  /// 스텝 본문 껍데기 — 질문 + 안내 + 선택지 격자.
  Widget _stepPage({
    required String question,
    required String hint,
    required Widget grid,
  }) {
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
            hint,
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 24.h),
          grid,
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// 출입문 격자 — 11개가 전부 '문'이라 아이콘 없이 라벨만 둔다.
  Widget _gateGrid({
    required ParkGate? selected,
    required void Function(ParkGate) onSelect,
  }) {
    return OptionGrid(
      columns: 3,
      aspectRatio: 2.0,
      children: [
        for (final gate in ParkGate.values)
          OptionTile(
            label: gate.label,
            selected: selected == gate,
            onTap: () => onSelect(gate),
          ),
      ],
    );
  }

  Widget _resultPage() {
    final state = ref.watch(courseRecommendationProvider);

    return state.when(
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              '코스를 만들고 있어요',
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
      error: (error, _) {
        // AI 서버 장애는 조건 문제가 아니다. 조건을 바꾸라고 하면 헛수고를 시킨다.
        final aiDown =
            error is AppException &&
            error.messageKey == 'errorCourseAiUnavailable';
        final message = error is AppException
            ? error.message
            : '코스를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
        return _ResultNotice(
          message: aiDown ? '지금은 코스를 만들지 못했어요\n잠시 후 다시 시도해 주세요' : message,
          buttonText: '다시 시도',
          onPressed: _goToResult,
        );
      },
      data: (courses) {
        if (courses == null) return const SizedBox.shrink();
        if (courses.isEmpty) {
          return _ResultNotice(
            message: '조건을 바꾸면 코스를 찾을 수 있어요',
            buttonText: '조건 다시 고르기',
            onPressed: () => _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            ),
          );
        }
        return _ResultCards(
          key: ValueKey(courses.map((c) => c.id).join('-')),
          results: courses,
          onToggleSaved: _toggleFavorite,
          onGo: _goWithCourse,
        );
      },
    );
  }
}

/// 결과 스텝의 안내 — 실패·결과 없음이 같은 껍데기를 쓰고 문구·버튼만 다르다.
class _ResultNotice extends StatelessWidget {
  const _ResultNotice({
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body15.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 20.h),
          Center(
            child: AppButton(
              text: buttonText,
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.ink,
              showBorder: true,
              width: 240.w,
              height: 52.h,
              onPressed: onPressed,
            ),
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}

/// 결과 카드 스와이프 — 내부 PageView가 가로 제스처를 소비 (외부 스텝과 충돌 없음).
class _ResultCards extends StatefulWidget {
  const _ResultCards({
    super.key,
    required this.results,
    required this.onToggleSaved,
    required this.onGo,
  });

  final List<CourseEntity> results;
  final void Function(CourseEntity) onToggleSaved;
  final void Function(CourseEntity) onGo;

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
                    saved: course.favorite,
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
