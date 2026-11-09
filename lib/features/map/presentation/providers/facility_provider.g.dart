// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$facilityRemoteDataSourceHash() =>
    r'bf8beaa453a16dd395eb5bdf74b748f87fa17f56';

/// FacilityRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [FacilityMockDataSource]로 바뀐다.
///
/// Copied from [facilityRemoteDataSource].
@ProviderFor(facilityRemoteDataSource)
final facilityRemoteDataSourceProvider =
    Provider<FacilityRemoteDataSource>.internal(
      facilityRemoteDataSource,
      name: r'facilityRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$facilityRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FacilityRemoteDataSourceRef = ProviderRef<FacilityRemoteDataSource>;
String _$facilityRepositoryHash() =>
    r'a44a30dd0a096dace187432c236fd0304e9eaf15';

/// FacilityRepository Provider
///
/// Copied from [facilityRepository].
@ProviderFor(facilityRepository)
final facilityRepositoryProvider = Provider<FacilityRepository>.internal(
  facilityRepository,
  name: r'facilityRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$facilityRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FacilityRepositoryRef = ProviderRef<FacilityRepository>;
String _$mapFacilitiesHash() => r'ca9f2a4ec929636201ee61ab67d8e73568a96304';

/// 지도에 그릴 시설 목록.
///
/// 게스트는 API를 부르지 않고 빈 목록이다. 출입문은 제외하며,
/// 실패해도 지도는 떠야 하므로 로그만 남기고 빈 목록을 돌려준다.
///
/// Copied from [mapFacilities].
@ProviderFor(mapFacilities)
final mapFacilitiesProvider =
    AutoDisposeFutureProvider<List<FacilityEntity>>.internal(
      mapFacilities,
      name: r'mapFacilitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapFacilitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MapFacilitiesRef = AutoDisposeFutureProviderRef<List<FacilityEntity>>;
String _$facilityDetailHash() => r'934376fdfd50f56f77f558e2c8995533a3caa64f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 시설 상세. 게스트이거나 실패하면 null.
///
/// Copied from [facilityDetail].
@ProviderFor(facilityDetail)
const facilityDetailProvider = FacilityDetailFamily();

/// 시설 상세. 게스트이거나 실패하면 null.
///
/// Copied from [facilityDetail].
class FacilityDetailFamily extends Family<AsyncValue<FacilityDetailEntity?>> {
  /// 시설 상세. 게스트이거나 실패하면 null.
  ///
  /// Copied from [facilityDetail].
  const FacilityDetailFamily();

  /// 시설 상세. 게스트이거나 실패하면 null.
  ///
  /// Copied from [facilityDetail].
  FacilityDetailProvider call(int id) {
    return FacilityDetailProvider(id);
  }

  @override
  FacilityDetailProvider getProviderOverride(
    covariant FacilityDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'facilityDetailProvider';
}

/// 시설 상세. 게스트이거나 실패하면 null.
///
/// Copied from [facilityDetail].
class FacilityDetailProvider
    extends AutoDisposeFutureProvider<FacilityDetailEntity?> {
  /// 시설 상세. 게스트이거나 실패하면 null.
  ///
  /// Copied from [facilityDetail].
  FacilityDetailProvider(int id)
    : this._internal(
        (ref) => facilityDetail(ref as FacilityDetailRef, id),
        from: facilityDetailProvider,
        name: r'facilityDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$facilityDetailHash,
        dependencies: FacilityDetailFamily._dependencies,
        allTransitiveDependencies:
            FacilityDetailFamily._allTransitiveDependencies,
        id: id,
      );

  FacilityDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<FacilityDetailEntity?> Function(FacilityDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FacilityDetailProvider._internal(
        (ref) => create(ref as FacilityDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<FacilityDetailEntity?> createElement() {
    return _FacilityDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FacilityDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FacilityDetailRef on AutoDisposeFutureProviderRef<FacilityDetailEntity?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FacilityDetailProviderElement
    extends AutoDisposeFutureProviderElement<FacilityDetailEntity?>
    with FacilityDetailRef {
  _FacilityDetailProviderElement(super.provider);

  @override
  int get id => (origin as FacilityDetailProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
