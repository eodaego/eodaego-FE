// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placeCatalogStatusHash() =>
    r'4df0b760479ea4f9fd16ce3187469bb3f5c62fae';

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

/// 코스 장소 하나를 도감에서 찾는다.
///
/// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
/// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
/// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
///
/// **주의**: 서버 검색은 부분 일치라 "동물나라"가 "동물나라 사육장"까지 물어온다.
/// 카테고리를 함께 넘겨 좁히고, 수집 판정은 이름 완전 일치로 한 번 더 조인다.
/// 정확한 키(`facilityId` ↔ 도감 `externalId`)는 관리용 API에만 있어 못 쓴다.
///
/// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
/// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
///
/// Copied from [placeCatalogStatus].
@ProviderFor(placeCatalogStatus)
const placeCatalogStatusProvider = PlaceCatalogStatusFamily();

/// 코스 장소 하나를 도감에서 찾는다.
///
/// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
/// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
/// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
///
/// **주의**: 서버 검색은 부분 일치라 "동물나라"가 "동물나라 사육장"까지 물어온다.
/// 카테고리를 함께 넘겨 좁히고, 수집 판정은 이름 완전 일치로 한 번 더 조인다.
/// 정확한 키(`facilityId` ↔ 도감 `externalId`)는 관리용 API에만 있어 못 쓴다.
///
/// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
/// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
///
/// Copied from [placeCatalogStatus].
class PlaceCatalogStatusFamily extends Family<AsyncValue<PlaceCatalogStatus>> {
  /// 코스 장소 하나를 도감에서 찾는다.
  ///
  /// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
  /// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
  /// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
  ///
  /// **주의**: 서버 검색은 부분 일치라 "동물나라"가 "동물나라 사육장"까지 물어온다.
  /// 카테고리를 함께 넘겨 좁히고, 수집 판정은 이름 완전 일치로 한 번 더 조인다.
  /// 정확한 키(`facilityId` ↔ 도감 `externalId`)는 관리용 API에만 있어 못 쓴다.
  ///
  /// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
  /// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
  ///
  /// Copied from [placeCatalogStatus].
  const PlaceCatalogStatusFamily();

  /// 코스 장소 하나를 도감에서 찾는다.
  ///
  /// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
  /// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
  /// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
  ///
  /// **주의**: 서버 검색은 부분 일치라 "동물나라"가 "동물나라 사육장"까지 물어온다.
  /// 카테고리를 함께 넘겨 좁히고, 수집 판정은 이름 완전 일치로 한 번 더 조인다.
  /// 정확한 키(`facilityId` ↔ 도감 `externalId`)는 관리용 API에만 있어 못 쓴다.
  ///
  /// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
  /// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
  ///
  /// Copied from [placeCatalogStatus].
  PlaceCatalogStatusProvider call({
    required String placeName,
    required DogamCategory category,
  }) {
    return PlaceCatalogStatusProvider(placeName: placeName, category: category);
  }

  @override
  PlaceCatalogStatusProvider getProviderOverride(
    covariant PlaceCatalogStatusProvider provider,
  ) {
    return call(placeName: provider.placeName, category: provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'placeCatalogStatusProvider';
}

/// 코스 장소 하나를 도감에서 찾는다.
///
/// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
/// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
/// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
///
/// **주의**: 서버 검색은 부분 일치라 "동물나라"가 "동물나라 사육장"까지 물어온다.
/// 카테고리를 함께 넘겨 좁히고, 수집 판정은 이름 완전 일치로 한 번 더 조인다.
/// 정확한 키(`facilityId` ↔ 도감 `externalId`)는 관리용 API에만 있어 못 쓴다.
///
/// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
/// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
///
/// Copied from [placeCatalogStatus].
class PlaceCatalogStatusProvider
    extends AutoDisposeFutureProvider<PlaceCatalogStatus> {
  /// 코스 장소 하나를 도감에서 찾는다.
  ///
  /// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
  /// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
  /// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
  ///
  /// **주의**: 서버 검색은 부분 일치라 "동물나라"가 "동물나라 사육장"까지 물어온다.
  /// 카테고리를 함께 넘겨 좁히고, 수집 판정은 이름 완전 일치로 한 번 더 조인다.
  /// 정확한 키(`facilityId` ↔ 도감 `externalId`)는 관리용 API에만 있어 못 쓴다.
  ///
  /// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
  /// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
  ///
  /// Copied from [placeCatalogStatus].
  PlaceCatalogStatusProvider({
    required String placeName,
    required DogamCategory category,
  }) : this._internal(
         (ref) => placeCatalogStatus(
           ref as PlaceCatalogStatusRef,
           placeName: placeName,
           category: category,
         ),
         from: placeCatalogStatusProvider,
         name: r'placeCatalogStatusProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$placeCatalogStatusHash,
         dependencies: PlaceCatalogStatusFamily._dependencies,
         allTransitiveDependencies:
             PlaceCatalogStatusFamily._allTransitiveDependencies,
         placeName: placeName,
         category: category,
       );

  PlaceCatalogStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.placeName,
    required this.category,
  }) : super.internal();

  final String placeName;
  final DogamCategory category;

  @override
  Override overrideWith(
    FutureOr<PlaceCatalogStatus> Function(PlaceCatalogStatusRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaceCatalogStatusProvider._internal(
        (ref) => create(ref as PlaceCatalogStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        placeName: placeName,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PlaceCatalogStatus> createElement() {
    return _PlaceCatalogStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceCatalogStatusProvider &&
        other.placeName == placeName &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, placeName.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaceCatalogStatusRef
    on AutoDisposeFutureProviderRef<PlaceCatalogStatus> {
  /// The parameter `placeName` of this provider.
  String get placeName;

  /// The parameter `category` of this provider.
  DogamCategory get category;
}

class _PlaceCatalogStatusProviderElement
    extends AutoDisposeFutureProviderElement<PlaceCatalogStatus>
    with PlaceCatalogStatusRef {
  _PlaceCatalogStatusProviderElement(super.provider);

  @override
  String get placeName => (origin as PlaceCatalogStatusProvider).placeName;
  @override
  DogamCategory get category => (origin as PlaceCatalogStatusProvider).category;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
