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
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_provider.dart';

/// 희망 체류시간 선택지 — 서버에는 분(int)으로 보낸다.
enum _StayDuration {
  oneHour('1시간', '⏱️', '가볍게 한 바퀴', 60),
  twoHours('2시간', '🕑', '천천히 둘러보기', 120),
  halfDay('반나절', '🌞', '구석구석 탐험', 240);

  const _StayDuration(this.label, this.emoji, this.subtitle, this.minutes);

  final String label;
  final String emoji;
  final String subtitle;
  final int minutes;
}

/// 동행 유형 선택지 이모지·보조설명
const Map<CompanionType, (String, String)> _companionMeta = {
  CompanionType.alone: ('🚶', '내 속도로 걸어요'),
  CompanionType.withChild: ('🧒', '아이 눈높이로 골라요'),
  CompanionType.withPartner: ('💑', '둘이 걷기 좋은 길로'),
  CompanionType.withFriends: ('👫', '같이 놀 거리 위주로'),
  CompanionType.withElderly: ('🧓', '쉬어갈 곳을 넉넉히'),
};

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

  /// 다음 페이지로 넘긴다 (건너뛰기·확정 공용).
  void _advanceFrom(int fromPage) {
    if (_currentPage != fromPage) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// 마지막 조건 스텝에서 결과로 넘어가며 추천을 1회 요청한다.
  void _goToResult() {
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
                  _gateStepPage(
                    question: '어느 문으로 들어왔어?',
                    selected: _entrance,
                    onSelect: (gate) {
                      setState(() => _entrance = gate);
                      _autoAdvance(0);
                    },
                  ),
                  _gateStepPage(
                    question: '어느 문으로 나갈까?',
                    selected: _exit,
                    onSelect: (gate) {
                      setState(() => _exit = gate);
                      _autoAdvance(1);
                    },
                  ),
                  _stepPage(
                    question: '얼마나 놀다 갈까?',
                    onSkip: () => _advanceFrom(2),
                    options: [
                      for (final d in _StayDuration.values)
                        _OptionCard(
                          emoji: d.emoji,
                          title: d.label,
                          subtitle: d.subtitle,
                          selected: _duration == d,
                          selectedColor: AppColors.primary,
                          selectedTint: AppColors.primaryTint,
                          selectedForeground: AppColors.primaryDark,
                          onTap: () {
                            setState(
                              () => _duration = _duration == d ? null : d,
                            );
                            if (_duration != null) _autoAdvance(2);
                          },
                        ),
                    ],
                  ),
                  _interestStepPage(),
                  _stepPage(
                    question: '누구랑 왔어?',
                    onSkip: () => _goToResult(),
                    options: [
                      for (final entry in _companionMeta.entries)
                        _OptionCard(
                          emoji: entry.value.$1,
                          title: entry.key.label,
                          subtitle: entry.value.$2,
                          selected: _companion == entry.key,
                          selectedColor: AppColors.primary,
                          selectedTint: AppColors.primaryTint,
                          selectedForeground: AppColors.primaryDark,
                          onTap: () {
                            setState(
                              () => _companion = _companion == entry.key
                                  ? null
                                  : entry.key,
                            );
                            _goToResult();
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

  Widget _stepPage({
    required String question,
    required List<Widget> options,
    VoidCallback? onSkip,
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
            '건너뛰면 전체에서 골라 추천해요',
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 24.h),
          for (final option in options) ...[option, SizedBox(height: 12.h)],
          if (onSkip != null)
            Center(
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  '건너뛰기',
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 출입문 스텝 — 11개라 칩 그리드로 한 화면에 담는다.
  Widget _gateStepPage({
    required String question,
    required ParkGate? selected,
    required void Function(ParkGate) onSelect,
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
            '들어온 문과 나갈 문을 알려주면 동선을 맞춰 짜요',
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: [
              for (final gate in ParkGate.values)
                CategoryChip(
                  label: gate.label,
                  selected: selected == gate,
                  onTap: () => onSelect(gate),
                ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// 관심분야 스텝 — 복수 선택이라 자동 넘김 대신 버튼으로 확정한다.
  Widget _interestStepPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            '뭐가 제일 좋아?',
            style: AppTextStyles.display24.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: 8.h),
          Text(
            '여러 개 골라도 좋아요. 건너뛰면 전체에서 골라 추천해요',
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: [
              for (final type in InterestType.values)
                CategoryChip(
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
          SizedBox(height: 24.h),
          Center(
            child: AppButton(
              // 아무것도 안 고르고 넘어가는 것과 건너뛰기는 같은 동작이다.
              // 버튼을 둘로 나누면 달라 보여서 하나로 두고 라벨만 바꾼다.
              text: _interests.isEmpty ? '건너뛰기' : '다음',
              width: 240.w,
              height: 52.h,
              onPressed: () => _advanceFrom(3),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
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
