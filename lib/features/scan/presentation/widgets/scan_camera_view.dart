import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/scan_camera_provider.dart';

/// 카메라 상태 — 화면이 프레임 안 안내를 고르는 데 쓴다.
enum ScanCameraStatus { loading, ready, denied, unavailable }

/// resumed 때 카메라를 다시 열지 판단한다.
///
/// 권한 팝업은 inactive→resumed만 낸다. 거절 직후 다시 열면 권한을 또 묻게 되므로
/// (Android 11+는 두 번째 거절이 영구 거절), 우리가 해제했거나 앱이 실제로
/// 백그라운드에 다녀온 경우(설정 화면 왕복 포함)에만 다시 연다.
bool shouldReopenCameraOnResume({
  required bool hasController,
  required bool releasedByLifecycle,
  required bool wentToBackground,
}) => !hasController && (releasedByLifecycle || wentToBackground);

/// 촬영 화면 배경의 실시간 카메라 프리뷰.
///
/// 후면 카메라를 열고, 앱이 inactive가 되면 해제했다가 resumed 때 다시 연다.
/// 상태는 [status]로 알린다. 촬영은 `GlobalKey<ScanCameraViewState>`로
/// [ScanCameraViewState.takePicture]를 부른다.
class ScanCameraView extends ConsumerStatefulWidget {
  const ScanCameraView({super.key, required this.status});

  final ValueNotifier<ScanCameraStatus> status;

  @override
  ConsumerState<ScanCameraView> createState() => ScanCameraViewState();
}

class ScanCameraViewState extends ConsumerState<ScanCameraView>
    with WidgetsBindingObserver {
  static const _deniedCodes = {
    'CameraAccessDenied',
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
  };

  CameraController? _controller;

  /// inactive에서 우리가 카메라를 해제했는지
  bool _releasedByLifecycle = false;

  /// 마지막 resumed 이후 앱이 실제로 백그라운드(paused/hidden)에 갔는지
  bool _wentToBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    switch (state) {
      case AppLifecycleState.inactive:
        // 초기화 중(권한 팝업도 inactive를 낸다)에는 건드리지 않는다.
        if (controller == null || !controller.value.isInitialized) return;
        _releasedByLifecycle = true;
        setState(() => _controller = null);
        controller.dispose();
        widget.status.value = ScanCameraStatus.loading;
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        _wentToBackground = true;
      case AppLifecycleState.resumed:
        final reopen = shouldReopenCameraOnResume(
          hasController: controller != null,
          releasedByLifecycle: _releasedByLifecycle,
          wentToBackground: _wentToBackground,
        );
        _releasedByLifecycle = false;
        _wentToBackground = false;
        if (reopen) _open();
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _open() async {
    final cameras = await ref.read(availableCameraListProvider.future);
    if (!mounted || _controller != null) return;
    if (cameras.isEmpty) {
      widget.status.value = ScanCameraStatus.unavailable;
      return;
    }
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = controller;
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      debugPrint('[Scan] ❌ 카메라 열기 실패: ${e.code}');
      if (identical(_controller, controller)) _controller = null;
      controller.dispose();
      if (!mounted) return;
      widget.status.value = _deniedCodes.contains(e.code)
          ? ScanCameraStatus.denied
          : ScanCameraStatus.unavailable;
      return;
    }
    // 기다리는 사이 화면을 나갔거나 백그라운드로 해제됐으면 버린다.
    if (!mounted || !identical(_controller, controller)) {
      controller.dispose();
      return;
    }
    setState(() {});
    widget.status.value = ScanCameraStatus.ready;
  }

  /// 사진을 찍어 파일 경로를 돌려준다.
  ///
  /// Returns: 카메라가 준비되지 않았으면 null. 촬영 자체가 실패하면 던진다.
  Future<String?> takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return null;
    final file = await controller.takePicture();
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final previewSize = controller?.value.previewSize;
    if (controller == null ||
        !controller.value.isInitialized ||
        previewSize == null) {
      return const SizedBox.expand();
    }
    // previewSize는 가로 기준이라 세로 화면에 맞춰 뒤집어 화면을 꽉 채운다.
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: previewSize.height,
          height: previewSize.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
