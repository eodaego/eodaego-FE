import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';

part 'scan_camera_provider.g.dart';

/// 기기의 카메라 목록. 조회에 실패하면(시뮬레이터 등) 빈 목록을 돌려준다.
@Riverpod(keepAlive: true)
Future<List<CameraDescription>> availableCameraList(Ref ref) async {
  try {
    return await availableCameras();
  } catch (e) {
    debugPrint('[Scan] ⚠️ 카메라 목록 조회 실패: $e');
    return const [];
  }
}

/// 목 데이터 모드 여부. 화면이 `EnvConfig`를 직접 읽지 않게 감싼다(테스트 override용).
@Riverpod(keepAlive: true)
bool scanMockMode(Ref ref) => EnvConfig.useMockData;
