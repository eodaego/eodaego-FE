import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../router/route_paths.dart';

class _WizardOption {
  const _WizardOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;
}

class _WizardStep {
  const _WizardStep({
    required this.question,
    required this.subtitle,
    required this.options,
  });

  final String question;
  final String subtitle;
  final List<_WizardOption> options;
}

/// 코스 추천 위저드 (COURSE-01~03) — 한 화면 한 질문, 3스텝.
/// 스텝 0·1은 단일 선택(350ms 후 자동 진행), 스텝 2는 복수 선택 + CTA.
class CourseWizardPage extends StatefulWidget {
  const CourseWizardPage({super.key});

  @override
  State<CourseWizardPage> createState() => _CourseWizardPageState();
}

class _CourseWizardPageState extends State<CourseWizardPage> {
  static const List<_WizardStep> _singleSteps = [
    _WizardStep(
      question: '어느 문으로 들어왔어?',
      subtitle: '가까운 출입문을 골라요',
      options: [
        _WizardOption(emoji: '🚪', title: '정문', subtitle: '능동 사거리 쪽'),
        _WizardOption(emoji: '🚇', title: '후문', subtitle: '아차산역 쪽'),
        _WizardOption(emoji: '🌳', title: '구의문', subtitle: '구의동 쪽'),
      ],
    ),
    _WizardStep(
      question: '얼마나 놀다 갈까?',
      subtitle: '체류 시간을 골라요',
      options: [
        _WizardOption(emoji: '⏱️', title: '1시간 정도', subtitle: '가볍게 한 바퀴'),
        _WizardOption(emoji: '🕑', title: '2시간 정도', subtitle: '천천히 둘러보기'),
        _WizardOption(emoji: '🌞', title: '반나절', subtitle: '구석구석 탐험'),
      ],
    ),
  ];

  static const Map<DogamCategory, _WizardOption> _interestOptions = {
    DogamCategory.animal: _WizardOption(
        emoji: '🦁', title: '동물', subtitle: '동물 친구들을 만나요'),
    DogamCategory.plant: _WizardOption(
        emoji: '🌿', title: '식물', subtitle: '풀과 나무를 관찰해요'),
    DogamCategory.place: _WizardOption(
        emoji: '📍', title: '장소', subtitle: '공원 명소를 찾아가요'),
  };

  int _step = 0;
  final List<int?> _singleSelections = [null, null];
  final Set<DogamCategory> _interests = {};

  bool get _isInterestStep => _step == 2;

  void _selectSingle(int optionIndex) {
    if (_singleSelections[_step] != null) return; // 진행 중 중복 탭 방지
    setState(() => _singleSelections[_step] = optionIndex);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _step += 1);
    });
  }

  void _back(BuildContext context) {
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() {
      _step -= 1;
      // 돌아간 스텝의 선택을 초기화해 자동 진행이 다시 동작하게 한다
      if (_step < _singleSelections.length) _singleSelections[_step] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _isInterestStep ? null : _singleSteps[_step];
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBackAppBar(title: '코스 추천', onBack: () => _back(context)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: i == _step ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: i == _step ? AppColors.primary : AppColors.line,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    if (i < 2) SizedBox(width: 6.w),
                  ],
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                _isInterestStep ? '뭐가 제일 좋아?' : step!.question,
                style: AppTextStyles.display24.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: 8.h),
              Text(
                _isInterestStep ? '여러 개 골라도 돼요' : step!.subtitle,
                style:
                    AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
              SizedBox(height: 24.h),
              if (!_isInterestStep)
                for (var i = 0; i < step!.options.length; i++) ...[
                  _OptionCard(
                    option: step.options[i],
                    selected: _singleSelections[_step] == i,
                    selectedColor: AppColors.primary,
                    selectedTint: AppColors.primaryTint,
                    onTap: () => _selectSingle(i),
                  ),
                  SizedBox(height: 12.h),
                ]
              else ...[
                for (final entry in _interestOptions.entries) ...[
                  _OptionCard(
                    option: entry.value,
                    selected: _interests.contains(entry.key),
                    selectedColor: entry.key.color,
                    selectedTint: entry.key.tint,
                    onTap: () => setState(() {
                      _interests.contains(entry.key)
                          ? _interests.remove(entry.key)
                          : _interests.add(entry.key);
                    }),
                  ),
                  SizedBox(height: 12.h),
                ],
                const Spacer(),
                AppButton(
                  text: '코스 3개 보러 가기',
                  width: double.infinity,
                  onPressed: _interests.isEmpty
                      ? null
                      : () => context.push(RoutePaths.courseResult),
                ),
                SizedBox(height: 16.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 위저드 옵션 카드 — radius 24 + 2px 테두리, 선택 시 색 채움 (option-card 스펙).
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.selectedColor,
    required this.selectedTint,
    required this.onTap,
  });

  final _WizardOption option;
  final bool selected;
  final Color selectedColor;
  final Color selectedTint;
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
              Text(option.emoji, style: TextStyle(fontSize: 30.sp)),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: AppTextStyles.label16Semibold
                        .copyWith(color: AppColors.ink),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    option.subtitle,
                    style: AppTextStyles.caption14
                        .copyWith(color: AppColors.muted),
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
