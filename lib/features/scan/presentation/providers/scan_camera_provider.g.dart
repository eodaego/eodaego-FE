// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_camera_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableCameraListHash() =>
    r'a9a2e6dd39c337ab8eb80fe2dce753d5f57ea0a3';

/// 기기의 카메라 목록. 조회에 실패하면(시뮬레이터 등) 빈 목록을 돌려준다.
///
/// Copied from [availableCameraList].
@ProviderFor(availableCameraList)
final availableCameraListProvider =
    FutureProvider<List<CameraDescription>>.internal(
      availableCameraList,
      name: r'availableCameraListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableCameraListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableCameraListRef = FutureProviderRef<List<CameraDescription>>;
String _$scanMockModeHash() => r'2d67d80d1e100f1d54965372632ce1639553ca5c';

/// 목 데이터 모드 여부. 화면이 `EnvConfig`를 직접 읽지 않게 감싼다(테스트 override용).
///
/// Copied from [scanMockMode].
@ProviderFor(scanMockMode)
final scanMockModeProvider = Provider<bool>.internal(
  scanMockMode,
  name: r'scanMockModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanMockModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScanMockModeRef = ProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
