import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/course_options.dart';
import 'option_grid.dart';
import 'park_gate_map.dart';

/// 코스 추천 화면의 바텀시트 — 출입문 고르기, 시간·관심분야 고르기.

/// 희망 체류시간 선택지 — 서버에는 분(int)으로 보낸다.
enum StayDuration {
  oneHour('1시간', Icons.hourglass_bottom_rounded, '가볍게 한 바퀴', 60),
  twoHours('2시간', Icons.access_time_filled_rounded, '천천히 둘러보기', 120),
  halfDay('반나절', Icons.wb_sunny_rounded, '구석구석 탐험', 240);

  const StayDuration(this.label, this.icon, this.subtitle, this.minutes);

  final String label;
  final IconData icon;
  final String subtitle;
  final int minutes;
}

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

/// 출입문 그리드 4열 타일 비율 — 393pt 기준 타일 높이가 터치 하한 48 근처(약 44)다.
const _gateTileAspectRatio = 1.85;

/// 들어온 문 → 나갈 문을 차례로 고르는 시트.
///
/// Returns: (입구, 출구). 중간에 닫으면 null
Future<({ParkGate entrance, ParkGate exit})?> showGatePickerSheet(
  BuildContext context,
) {
  return _showCourseSheet(context, const _GatePickerSheet());
}

/// 시간·관심분야를 고르는 시트. 둘 다 비워 둘 수 있다.
///
/// Returns: 고른 값. 중간에 닫으면 null(기존 값 유지)
Future<({StayDuration? duration, Set<InterestType> interests})?>
showPreferenceSheet(
  BuildContext context, {
  required StayDuration? duration,
  required Set<InterestType> interests,
}) {
  return _showCourseSheet(
    context,
    _PreferenceSheet(duration: duration, interests: interests),
  );
}

Future<T?> _showCourseSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl.r)),
    ),
    builder: (_) => child,
  );
}

/// 시트 공통 껍데기 — 그래버 + 제목 + 안내 + 본문.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.title,
    required this.hint,
    required this.child,
  });

  final String title;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.xl.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
          SizedBox(height: AppSpacing.base.h),
          Text(
            title,
            style: AppTextStyles.display22.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            hint,
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
          SizedBox(height: AppSpacing.lg.h),
          child,
        ],
      ),
    );
  }
}

class _GatePickerSheet extends StatefulWidget {
  const _GatePickerSheet();

  @override
  State<_GatePickerSheet> createState() => _GatePickerSheetState();
}

class _GatePickerSheetState extends State<_GatePickerSheet> {
  ParkGate? _entrance;

  void _onGate(ParkGate gate) {
    final entrance = _entrance;
    if (entrance == null) {
      setState(() => _entrance = gate);
      return;
    }
    Navigator.of(context).pop((entrance: entrance, exit: gate));
  }

  @override
  Widget build(BuildContext context) {
    final entrance = _entrance;
    return _SheetFrame(
      title: entrance == null ? '어느 문으로 들어왔어?' : '어디로 나갈 거야?',
      hint: entrance == null
          ? '약도나 아래 목록에서 골라 주세요'
          : '들어온 문으로 돌아오려면 같은 문을 한 번 더 눌러 주세요',
      child: Column(
        children: [
          ParkGateMap(entrance: entrance, onGateTap: _onGate),
          SizedBox(height: AppSpacing.base.h),
          OptionGrid(
            columns: 4,
            aspectRatio: _gateTileAspectRatio,
            children: [
              for (final gate in ParkGate.values)
                OptionTile(
                  label: gate.label,
                  selected: gate == entrance,
                  onTap: () => _onGate(gate),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreferenceSheet extends StatefulWidget {
  const _PreferenceSheet({required this.duration, required this.interests});

  final StayDuration? duration;
  final Set<InterestType> interests;

  @override
  State<_PreferenceSheet> createState() => _PreferenceSheetState();
}

class _PreferenceSheetState extends State<_PreferenceSheet> {
  late StayDuration? _duration = widget.duration;
  late Set<InterestType> _interests = {...widget.interests};

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: '조금 더 맞추기',
      hint: '안 골라도 괜찮아요. 고른 만큼 맞춰 짜요',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '얼마나 놀다 갈까?',
            style: AppTextStyles.display19.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.md.h),
          OptionGrid(
            columns: 3,
            aspectRatio: 1.15,
            children: [
              for (final d in StayDuration.values)
                OptionTile(
                  icon: d.icon,
                  label: d.label,
                  subtitle: d.subtitle,
                  selected: _duration == d,
                  onTap: () =>
                      setState(() => _duration = _duration == d ? null : d),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xl.h),
          Text(
            '뭐가 좋아?',
            style: AppTextStyles.display19.copyWith(color: AppColors.ink),
          ),
          SizedBox(height: AppSpacing.md.h),
          OptionGrid(
            columns: 3,
            aspectRatio: 1.3,
            children: [
              for (final type in InterestType.values)
                OptionTile(
                  icon: _interestIcons[type],
                  label: type.label,
                  selected: _interests.contains(type),
                  onTap: () => setState(() {
                    _interests = _interests.contains(type)
                        ? ({..._interests}..remove(type))
                        : {..._interests, type};
                  }),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xl.h),
          AppButton(
            text: '다 골랐어요',
            onPressed: () => Navigator.of(
              context,
            ).pop((duration: _duration, interests: _interests)),
          ),
        ],
      ),
    );
  }
}
