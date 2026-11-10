import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_message_keys.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../core/widgets/loading_cat.dart';
import '../../../../router/route_paths.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/course_options.dart';
import '../providers/course_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/course_sheets.dart';
import '../widgets/park_gate_map.dart';

/// 동행 유형 선택지 아이콘
const Map<CompanionType, IconData> _companionIcons = {
  CompanionType.alone: Icons.directions_walk_rounded,
  CompanionType.withChild: Icons.child_care_rounded,
  CompanionType.withPartner: Icons.favorite_rounded,
  CompanionType.withFriends: Icons.groups_rounded,
  CompanionType.withElderly: Icons.elderly_rounded,
};

/// 출입문 이름 뒤 조사 '으로/로'.
///
/// 받침 없음·ㄹ받침이면 '로', 그 외 받침은 '으로'. 숫자는 한자어 읽기(0 영, 3 삼, 6 육만 '으로').
String directionParticle(String word) {
  if (word.isEmpty) return '로';
  final last = word.codeUnitAt(word.length - 1);
  if (last >= 0x30 && last <= 0x39) {
    return const {0x30, 0x33, 0x36}.contains(last) ? '으로' : '로';
  }
  if (last < 0xAC00 || last > 0xD7A3) return '로';
  final jong = (last - 0xAC00) % 28;
  return jong == 0 || jong == 8 ? '로' : '으로';
}

/// 코스 추천 — 한 화면에서 끝난다.
///
/// 입·출구는 지금 위치에서 가장 가까운 문으로 미리 채우고(못 찾으면 직접 고름),
/// 동행 타일을 누르면 바로 추천을 요청한다. 시간·관심분야는 시트에서 고르는 선택 사항이다.
/// 진입점(지도 시트 버튼)이 게스트 게이트를 담당.
class CourseRecommendPage extends ConsumerStatefulWidget {
  const CourseRecommendPage({super.key});

  @override
  ConsumerState<CourseRecommendPage> createState() =>
      _CourseRecommendPageState();
}

class _CourseRecommendPageState extends ConsumerState<CourseRecommendPage> {
  ParkGate? _entrance;
  ParkGate? _exit;

  /// 입·출구를 위치로 채웠는지 — 안내 문구가 달라진다.
  bool _gateFromLocation = false;
  bool _locating = true;

  StayDuration? _duration;
  Set<InterestType> _interests = const {};
  CompanionType? _companion;

  /// 추천을 요청했는지. 결과에 온 뒤에는 조건 화면으로 되돌아가지 않는다.
  bool _requested = false;

  @override
  void initState() {
    super.initState();
    ref.read(nearestParkGateProvider.future).then((gate) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        // Keep a gate the user already picked while location was loading
        // 위치를 찾는 동안 사용자가 이미 고른 문은 덮어쓰지 않는다
        if (gate == null || _entrance != null) return;
        _entrance = gate;
        _exit = gate;
        _gateFromLocation = true;
      });
    });
  }

  Future<void> _pickGates() async {
    final picked = await showGatePickerSheet(context);
    if (picked == null || !mounted) return;
    setState(() {
      _entrance = picked.entrance;
      _exit = picked.exit;
      _gateFromLocation = false;
    });
  }

  Future<void> _pickPreferences() async {
    final picked = await showPreferenceSheet(
      context,
      duration: _duration,
      interests: _interests,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _duration = picked.duration;
      _interests = picked.interests;
    });
  }

  /// 동행 타일 — 고르는 즉시 추천을 1회 요청한다. [companion]이 null이면 '상관없어요'.
  void _requestWith(CompanionType? companion) {
    _companion = companion;
    _request();
  }

  void _request() {
    final entrance = _entrance;
    final exit = _exit;
    // 동행 타일은 입·출구가 있어야 눌린다. 방어적 가드다.
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
    setState(() => _requested = true);
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
      AppSnackbar.show(
        context,
        message: '저장하지 못했어요. 잠시 후 다시 시도해 주세요',
        backgroundColor: AppColors.danger,
      );
    }
  }

  void _goWithCourse(CourseEntity course) {
    ref.read(selectedCourseProvider.notifier).state = course;
    context.go(RoutePaths.map);
  }

  @override
  Widget build(BuildContext context) {
    // 결과에서도 뒤로가기는 조건 화면이 아니라 코스에 들어오기 전 화면으로 나간다.
    // 추천은 호출할 때마다 AI 서버를 거치고 서버에 코스가 새로 저장되므로,
    // 조건만 고쳐 다시 요청하는 길을 열어두지 않는다.
    //
    // 조건 화면에서도 구독한다 — autoDispose라 아무도 보지 않으면 요청 직후 결과가 버려진다.
    final result = ref.watch(courseRecommendationProvider);
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBackAppBar(title: '코스 추천', onBack: () => context.pop()),
      body: SafeArea(
        child: _requested ? _resultPage(result) : _conditionPage(),
      ),
    );
  }

  // ============================================
  // Conditions (조건)
  // ============================================

  Widget _conditionPage() {
    final entrance = _entrance;
    final exit = _exit;
    final hasGates = entrance != null && exit != null;
    final preferences = [
      ?_duration?.label,
      for (final type in _interests) type.label,
    ];

    final String gateHint;
    if (_locating && !hasGates) {
      gateHint = '가까운 문을 찾고 있어요';
    } else if (!hasGates) {
      gateHint = '들어온 문을 알려 주세요';
    } else if (_gateFromLocation) {
      gateHint = '지금 위치에서 가장 가까운 문으로 골랐어요';
    } else {
      gateHint = '직접 고른 문이에요';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppSpacing.xl.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section(
            question: '어디로 들어왔어?',
            hint: gateHint,
            child: _RouteCard(
              entrance: entrance,
              exit: exit,
              onChange: _pickGates,
            ),
          ),
          // Full-bleed band separating the two sections
          // 두 영역을 나누는 화면 폭 전체의 띠
          Container(
            height: AppSpacing.sm.h,
            margin: EdgeInsets.only(top: 28.h, bottom: AppSpacing.xl.h),
            color: AppColors.surfaceDim,
          ),
          _section(
            question: '누구랑 왔어?',
            hint: '누르면 바로 코스를 짜 드려요',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _companionGrid(enabled: hasGates),
                SizedBox(height: AppSpacing.base.h),
                Center(
                  child: TextButton(
                    onPressed: _pickPreferences,
                    child: Text(
                      preferences.isEmpty
                          ? '시간·관심도 고르기'
                          : '시간·관심도 고르기 (${preferences.join('·')})',
                      style: AppTextStyles.caption14.copyWith(
                        color: AppColors.muted,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 질문 + 안내 + 본문. 좌우 패딩은 여기서만 준다 — 구분 띠는 화면 끝까지 닿아야 한다.
  Widget _section({
    required String question,
    required String hint,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.sm.h),
          Text(
            question,
            style: AppTextStyles.display24.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            hint,
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: AppSpacing.base.h),
          child,
        ],
      ),
    );
  }

  Widget _companionGrid({required bool enabled}) {
    final tiles = [
      for (final MapEntry(key: type, value: icon) in _companionIcons.entries)
        _CompanionTile(
          icon: icon,
          label: type.label,
          onTap: enabled ? () => _requestWith(type) : null,
        ),
      _CompanionTile(
        icon: Icons.shuffle_rounded,
        label: '상관없어요',
        onTap: enabled ? () => _requestWith(null) : null,
      ),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      childAspectRatio: 2.3,
      crossAxisSpacing: AppSpacing.sm.w,
      mainAxisSpacing: AppSpacing.sm.h,
      children: tiles,
    );
  }

  // ============================================
  // Result (결과)
  // ============================================

  Widget _resultPage(AsyncValue<List<CourseEntity>?> state) {
    return state.when(
      loading: () => const Center(child: LoadingCat(title: '코스를 만들고 있어요')),
      error: (error, _) {
        // AI 서버 장애는 조건 문제가 아니다. 조건을 바꾸라고 하면 헛수고를 시킨다.
        final aiDown =
            error is AppException &&
            error.messageKey == AppMessageKeys.errorCourseAiUnavailable;
        final message = error is AppException
            ? error.message
            : '코스를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
        return _ResultNotice(
          message: aiDown ? '지금은 코스를 만들지 못했어요\n잠시 후 다시 시도해 주세요' : message,
          buttonText: '다시 시도',
          onPressed: _request,
        );
      },
      data: (courses) {
        if (courses == null) return const SizedBox.shrink();
        if (courses.isEmpty) {
          return _ResultNotice(
            message: '조건을 바꾸면 코스를 찾을 수 있어요',
            buttonText: '조건 다시 고르기',
            onPressed: () => setState(() => _requested = false),
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

/// 입·출구 요약 — 약도 썸네일 + "정문 → 정문" + 바꾸기. 문이 없으면 카드 전체가 고르기 버튼이다.
class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.entrance,
    required this.exit,
    required this.onChange,
  });

  final ParkGate? entrance;
  final ParkGate? exit;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final from = entrance;
    final to = exit;
    final hasGates = from != null && to != null;
    final radius = BorderRadius.circular(AppRadius.lg.r);

    final titleStyle = AppTextStyles.display17.copyWith(
      color: hasGates ? AppColors.ink : AppColors.muted,
      height: 1.4,
    );
    final Widget title;
    final String description;
    if (hasGates) {
      // Ssurround has no arrow glyph, so the arrow is an icon
      // Ssurround에 화살표 글리프가 없어 아이콘으로 그린다
      title = Row(
        children: [
          Text(from.label, style: titleStyle),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 18.w,
              color: AppColors.muted,
            ),
          ),
          Text(to.label, style: titleStyle),
        ],
      );
      description = from == to
          ? '${to.label}${directionParticle(to.label)} 돌아오는 코스'
          : '${to.label}${directionParticle(to.label)} 나가는 코스';
    } else {
      title = Text('들어온 문을 골라 주세요', style: titleStyle);
      description = '약도에서 눌러서 골라요';
    }

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onChange,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Row(
            children: [
              SizedBox(
                width: 110.w,
                child: ParkGateMap(entrance: from, exit: to),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      description,
                      style: AppTextStyles.caption14.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasGates)
                Padding(
                  padding: EdgeInsets.only(left: AppSpacing.xs.w),
                  child: Text(
                    '바꾸기',
                    style: AppTextStyles.label16Semibold.copyWith(
                      color: AppColors.primaryDark,
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

/// 동행 타일 — 아이콘 + 라벨 한 줄. 누르면 바로 추천한다. [onTap]이 null이면 비활성.
class _CompanionTile extends StatelessWidget {
  const _CompanionTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.sm.r);
    final enabled = onTap != null;

    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: AppColors.line, width: 2),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.base.w),
            child: Row(
              children: [
                Icon(icon, size: 24.w, color: AppColors.muted),
                SizedBox(width: 10.w),
                Text(
                  label,
                  style: AppTextStyles.label16Semibold.copyWith(
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 결과의 안내 — 실패·결과 없음이 같은 껍데기를 쓰고 문구·버튼만 다르다.
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
          SizedBox(height: AppSpacing.lg.h),
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

/// 결과 카드 목록 — 세로 스크롤.
class _ResultCards extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.sm.h,
      ),
      itemCount: results.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final course = results[index];
        return CourseCard(
          course: course,
          saved: course.favorite,
          onToggleSaved: () => onToggleSaved(course),
          onGo: () => onGo(course),
        );
      },
    );
  }
}
