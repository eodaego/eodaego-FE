// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placeCatalogStatusHash() =>
    r'68ec3df4e56fed0c9b8ff28c0ef718c1cf412ec3';

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
/// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
/// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
/// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
/// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
/// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
/// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
///
/// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
/// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
/// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
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
/// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
/// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
/// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
/// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
/// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
/// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
///
/// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
/// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
/// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
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
  /// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
  /// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
  /// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
  /// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
  /// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
  /// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
  ///
  /// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
  /// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
  /// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
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
  /// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
  /// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
  /// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
  /// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
  /// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
  /// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
  ///
  /// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
  /// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
  /// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
  ///
  /// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
  /// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
  ///
  /// Copied from [placeCatalogStatus].
  PlaceCatalogStatusProvider call({required String placeName}) {
    return PlaceCatalogStatusProvider(placeName: placeName);
  }

  @override
  PlaceCatalogStatusProvider getProviderOverride(
    covariant PlaceCatalogStatusProvider provider,
  ) {
    return call(placeName: provider.placeName);
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
/// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
/// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
/// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
/// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
/// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
/// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
///
/// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
/// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
/// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
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
  /// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
  /// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
  /// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
  /// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
  /// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
  /// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
  ///
  /// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
  /// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
  /// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
  ///
  /// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
  /// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
  ///
  /// Copied from [placeCatalogStatus].
  PlaceCatalogStatusProvider({required String placeName})
    : this._internal(
        (ref) => placeCatalogStatus(
          ref as PlaceCatalogStatusRef,
          placeName: placeName,
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
      );

  PlaceCatalogStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.placeName,
  }) : super.internal();

  final String placeName;

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
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PlaceCatalogStatus> createElement() {
    return _PlaceCatalogStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceCatalogStatusProvider && other.placeName == placeName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, placeName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaceCatalogStatusRef
    on AutoDisposeFutureProviderRef<PlaceCatalogStatus> {
  /// The parameter `placeName` of this provider.
  String get placeName;
}

class _PlaceCatalogStatusProviderElement
    extends AutoDisposeFutureProviderElement<PlaceCatalogStatus>
    with PlaceCatalogStatusRef {
  _PlaceCatalogStatusProviderElement(super.provider);

  @override
  String get placeName => (origin as PlaceCatalogStatusProvider).placeName;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
