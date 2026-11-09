import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/services/permission/location_permission_service.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/dialogs/login_gate_dialog.dart';
import '../../../../router/route_paths.dart';
import '../../../quiz/presentation/providers/quiz_session_provider.dart';
import '../../../quiz/presentation/quiz_messages.dart';
import '../providers/scan_camera_provider.dart';
import '../widgets/scan_camera_view.dart';

// 문구 상수 — ux-writing 검토로 문장이 바뀌면 여기만 고친다.
const scanWaitingMessage = '사진을 보고 있어요';
const scanCameraDeniedMessage = '카메라를 허용하면 사진을 찍을 수 있어요';
const scanOpenSettingsLabel = '설정 열기';
const scanCameraUnavailableMessage = '이 기기에서는 카메라를 쓸 수 없어요';
const scanShutterLabel = '사진 찍기';

/// 종류 이름 뒤 조사 — 받침이 있으면 '이', 없으면 '가'.
String _subject(DogamCategory c) =>
    c == DogamCategory.place ? '${c.label}가' : '${c.label}이';

/// 촬영 안내 문구 (예: '네모 안에 식물이 들어오게 찍어주세요').
String scanGuideMessage(DogamCategory c) => '네모 안에 ${_subject(c)} 들어오게 찍어주세요';

/// 촬영 (SCAN-01) — 실시간 카메라 프리뷰 위에 프레임·종류 칩·셔터를 얹는다.
/// 앱에서 유일한 다크 화면(cameraBg). 시안: 촬영 화면 카테고리 선택 A안.
class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key, this.initialCategory = DogamCategory.animal});

  /// 처음 골라 둘 종류. 지도 장소 카드에서 들어오면 장소다.
  final DogamCategory initialCategory;

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final _cameraKey = GlobalKey<ScanCameraViewState>();
  final _cameraStatus = ValueNotifier(ScanCameraStatus.loading);
  late DogamCategory _category = widget.initialCategory;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _cameraStatus.dispose();
    super.dispose();
  }

  Future<void> _onShutter() async {
    // 연타 가드 — 첫 await 전에 막는다.
    if (_busy) return;
    if (ref.read(guestRestrictedProvider)) {
      showLoginGateDialog(context, ref, message: '로그인하면 사진을 찍고 도감을 모을 수 있어요');
      return;
    }
    final mockMode = ref.read(scanMockModeProvider);
    // 실서버 모드에서 카메라가 준비되기 전에는 누름을 무시한다.
    if (!mockMode && _cameraStatus.value != ScanCameraStatus.ready) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final imagePath = await _cameraKey.currentState?.takePicture();
      // 실서버 모드에서 카메라가 없으면 프레임 안 안내만 두고 아무것도 안 한다.
      if (imagePath == null && !mockMode) return;
      await ref
          .read(quizSessionProvider.notifier)
          .start(category: _category, imagePath: imagePath);
      // 기다리는 사이 촬영 화면을 닫았으면 퀴즈를 열지 않는다.
      if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
      context.push(RoutePaths.quiz);
    } catch (e) {
      debugPrint('[Scan] ❌ 퀴즈 생성 실패: $e');
      if (mounted) setState(() => _error = scanErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _select(DogamCategory category) => setState(() {
    _category = category;
    _error = null;
  });

  @override
  Widget build(BuildContext context) {
    final color = _category.color;
    final guideStyle = AppTextStyles.body15.copyWith(
      color: AppColors.onPrimary,
    );
    return Scaffold(
      backgroundColor: AppColors.cameraBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: ScanCameraView(key: _cameraKey, status: _cameraStatus),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 260.w,
                      height: 260.w,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomPaint(
                            painter: _CornerBracketsPainter(color: color),
                          ),
                          Center(
                            child: ValueListenableBuilder(
                              valueListenable: _cameraStatus,
                              builder: (context, status, _) =>
                                  _FrameCenter(status: status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                  child: _busy || _error != null
                      ? Text(
                          _busy ? scanWaitingMessage : _error!,
                          textAlign: TextAlign.center,
                          style: guideStyle,
                        )
                      : Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: '네모 안에 '),
                              TextSpan(
                                text: _subject(_category),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(text: ' 들어오게 찍어주세요'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: guideStyle,
                        ),
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final (i, c) in DogamCategory.values.indexed) ...[
                      if (i > 0) SizedBox(width: AppSpacing.sm.w),
                      CategoryChip(
                        label: c.label,
                        color: c.color,
                        selected: c == _category,
                        onTap: _busy ? null : () => _select(c),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AppSpacing.base.h),
                // 전체 폭 Stack — 셔터는 중앙, 닫기는 왼쪽 끝 (셔터 크기로 잡히면 겹침)
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _Shutter(color: color, busy: _busy, onTap: _onShutter),
                      Positioned(
                        left: 28.w,
                        child: IconButton(
                          // 퀴즈에서 go로 돌아온 경우 스택이 비어 있다 — 홈으로 보낸다.
                          onPressed: () => context.canPop()
                              ? context.pop()
                              : context.go(RoutePaths.home),
                          tooltip: '닫기',
                          icon: Icon(
                            Icons.close,
                            size: 28.w,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 프레임 가운데 — 카메라 상태에 따라 초점 아이콘 또는 권한·기기 안내.
class _FrameCenter extends StatelessWidget {
  const _FrameCenter({required this.status});

  final ScanCameraStatus status;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.body15.copyWith(color: AppColors.onPrimary);
    return switch (status) {
      ScanCameraStatus.denied => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            scanCameraDeniedMessage,
            textAlign: TextAlign.center,
            style: style,
          ),
          SizedBox(height: AppSpacing.md.h),
          OutlinedButton(
            onPressed: LocationPermissionService.openAppSettings,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.onPrimary),
              minimumSize: Size(0, 48.h),
              shape: const StadiumBorder(),
            ),
            child: Text(
              scanOpenSettingsLabel,
              style: AppTextStyles.tag13Bold.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
      ScanCameraStatus.unavailable => Text(
        scanCameraUnavailableMessage,
        textAlign: TextAlign.center,
        style: style,
      ),
      _ => Icon(
        Icons.filter_center_focus,
        size: 48.w,
        color: AppColors.onPrimary.withValues(alpha: 0.4),
      ),
    };
  }
}

/// 셔터 78 — 링 색은 고른 종류 색. 기다리는 동안은 눌리지 않고 진행 표시를 보인다.
class _Shutter extends StatelessWidget {
  const _Shutter({
    required this.color,
    required this.busy,
    required this.onTap,
  });

  final Color color;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: scanShutterLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 78.w,
          height: 78.w,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary,
            ),
            child: busy
                ? Padding(
                    padding: EdgeInsets.all(18.w),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: color,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// 촬영 프레임 — 네 모서리 브래킷(시안). 사각형 전체를 두르지 않는다.
class _CornerBracketsPainter extends CustomPainter {
  const _CornerBracketsPainter({required this.color});

  final Color color;

  static const double _armLength = 28;
  static const double _strokeWidth = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(size.width, size.height),
      Offset(0, size.height),
    ];
    const dx = [1, -1, -1, 1];
    const dy = [1, 1, -1, -1];

    for (var i = 0; i < corners.length; i++) {
      final c = corners[i];
      canvas.drawLine(c, Offset(c.dx + dx[i] * _armLength, c.dy), paint);
      canvas.drawLine(c, Offset(c.dx, c.dy + dy[i] * _armLength), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CornerBracketsPainter oldDelegate) =>
      color != oldDelegate.color;
}
