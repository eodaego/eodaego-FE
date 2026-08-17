import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../course/domain/entities/course_entity.dart';
import '../widgets/course_sheet.dart';
import '../widgets/park_google_map.dart';
import '../widgets/park_schematic_map.dart';
import '../widgets/place_info_card.dart';

enum _MapViewMode { schematic, actual }

/// 지도 (탭) — 실제 지도/공원 약도 + 선택 코스 마커 + 드래그 코스 시트.
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  var _mode = _MapViewMode.schematic;

  /// 마커를 눌러 카드를 띄운 장소. null이면 카드가 없다.
  CoursePlaceEntity? _tappedPlace;

  /// 마커 탭과 시트 목록 탭이 모두 여기로 온다.
  void _openPlace(CoursePlaceEntity place) {
    setState(() => _tappedPlace = place);
  }

  void _closePlace() {
    setState(() => _tappedPlace = null);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedCourseProvider);
    // 코스가 바뀌면 이전 코스의 장소 카드가 남지 않게 한다.
    final tapped = selected == null ? null : _tappedPlace;
    // 시트 접힘 높이(body 기준 22%)에 대응해 풀스크린 기준 20%를 비워 마커·라벨 가림을 방지
    final sheetInset = MediaQuery.sizeOf(context).height * 0.20;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: sheetInset),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      '공원 지도',
                      style: AppTextStyles.display19.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<_MapViewMode>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: _MapViewMode.actual,
                            label: Text('실제 지도'),
                          ),
                          ButtonSegment(
                            value: _MapViewMode.schematic,
                            label: Text('공원 약도'),
                          ),
                        ],
                        selected: {_mode},
                        onSelectionChanged: (selection) {
                          setState(() => _mode = selection.first);
                        },
                        // 선택은 채움으로 보여준다. 틴트는 흰 배경과 구분이 약했다.
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? AppColors.primary
                                : AppColors.surface,
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? AppColors.onPrimary
                                : AppColors.muted,
                          ),
                          side: WidgetStateProperty.resolveWith(
                            (states) => BorderSide(
                              color: states.contains(WidgetState.selected)
                                  ? AppColors.primary
                                  : AppColors.line,
                            ),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            AppTextStyles.tag13Bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg.r),
                        child: ColoredBox(
                          color: AppColors.surfaceDim,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (_mode == _MapViewMode.actual)
                                ParkGoogleMap(
                                  course: selected,
                                  onPlaceTap: _openPlace,
                                  selectedPlaceName: tapped?.name,
                                )
                              else
                                ParkSchematicMap(
                                  course: selected,
                                  onPlaceTap: _openPlace,
                                  selectedPlaceName: tapped?.name,
                                ),
                              // 카드가 떠 있으면 출입문 라벨과 겹친다. 라벨을 숨긴다.
                              if (selected != null && tapped == null)
                                // 지도 네 귀퉁이가 다 임자가 있다 — 좌하단은
                                // Google 로고(가리면 약관 위반), 우하단은 내 위치
                                // 버튼, 상단은 장소 카드. 라벨은 좌상단으로 간다.
                                Positioned(
                                  left: AppSpacing.base.w,
                                  top: AppSpacing.base.h,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.xs.r,
                                      ),
                                    ),
                                    child: Text(
                                      selected.gateLabel,
                                      style: AppTextStyles.tag13Bold.copyWith(
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              // 카드는 지도 위쪽에 띄운다. 아래에 두면 시트를
                              // 펼쳤을 때 그 뒤로 숨어 뜬 줄도 모르고, 좌하단
                              // Google 로고까지 가린다.
                              // 카드 바깥을 누르면 닫는다. Listener + translucent라
                              // 같은 탭이 지도까지 그대로 내려가, 카드를 닫자고
                              // 지도를 못 만지게 되는 일이 없다 — 다른 마커를
                              // 누르면 닫힘과 열림이 이어서 일어나 바로 갈아탄다.
                              if (tapped != null)
                                Positioned.fill(
                                  child: Listener(
                                    behavior: HitTestBehavior.translucent,
                                    onPointerDown: (_) => _closePlace(),
                                  ),
                                ),
                              if (tapped != null)
                                Positioned(
                                  left: 14.w,
                                  right: 14.w,
                                  top: 14.h,
                                  child: PlaceInfoCard(place: tapped),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                  ],
                ),
              ),
            ),
            CourseSheet(
              onPlaceTap: _openPlace,
              selectedPlaceName: tapped?.name,
            ),
          ],
        ),
      ),
    );
  }
}
