// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$catalogRemoteDataSourceHash() =>
    r'59652a734c1f11fa39956c9e5c0c1aea540b2f86';

/// CatalogRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [CatalogMockDataSource]로 바뀐다.
/// 아래 [catalogRepositoryProvider]는 어느 쪽이든 같은 인터페이스만 보므로
/// 수정할 필요가 없다.
///
/// Copied from [catalogRemoteDataSource].
@ProviderFor(catalogRemoteDataSource)
final catalogRemoteDataSourceProvider =
    AutoDisposeProvider<CatalogRemoteDataSource>.internal(
      catalogRemoteDataSource,
      name: r'catalogRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$catalogRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogRemoteDataSourceRef =
    AutoDisposeProviderRef<CatalogRemoteDataSource>;
String _$catalogRepositoryHash() => r'021fe2b4f60525543aefb02494f5ed9085b83f98';

/// CatalogRepository Provider
///
/// Copied from [catalogRepository].
@ProviderFor(catalogRepository)
final catalogRepositoryProvider =
    AutoDisposeProvider<CatalogRepository>.internal(
      catalogRepository,
      name: r'catalogRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$catalogRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogRepositoryRef = AutoDisposeProviderRef<CatalogRepository>;
String _$catalogItemsHash() => r'e1506c5852a5ef28550c8ff2cc625033d12a89c8';

/// 도감 전체 목록. 카테고리 필터·이름 검색은 화면에서 로컬로 건다.
///
/// Copied from [catalogItems].
@ProviderFor(catalogItems)
final catalogItemsProvider =
    AutoDisposeFutureProvider<List<CatalogItemEntity>>.internal(
      catalogItems,
      name: r'catalogItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$catalogItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogItemsRef = AutoDisposeFutureProviderRef<List<CatalogItemEntity>>;
String _$catalogItemDetailHash() => r'99cc2b551be77d9e5f4ff18aabf5389fb6ccdc85';

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

/// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
///
/// Copied from [catalogItemDetail].
@ProviderFor(catalogItemDetail)
const catalogItemDetailProvider = CatalogItemDetailFamily();

/// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
///
/// Copied from [catalogItemDetail].
class CatalogItemDetailFamily
    extends Family<AsyncValue<CatalogItemDetailEntity>> {
  /// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
  ///
  /// Copied from [catalogItemDetail].
  const CatalogItemDetailFamily();

  /// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
  ///
  /// Copied from [catalogItemDetail].
  CatalogItemDetailProvider call(String id) {
    return CatalogItemDetailProvider(id);
  }

  @override
  CatalogItemDetailProvider getProviderOverride(
    covariant CatalogItemDetailProvider provider,
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
  String? get name => r'catalogItemDetailProvider';
}

/// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
///
/// Copied from [catalogItemDetail].
class CatalogItemDetailProvider
    extends AutoDisposeFutureProvider<CatalogItemDetailEntity> {
  /// 도감 상세. **수집한 항목에만 쓴다** — 미수집은 서버가 403으로 막는다.
  ///
  /// Copied from [catalogItemDetail].
  CatalogItemDetailProvider(String id)
    : this._internal(
        (ref) => catalogItemDetail(ref as CatalogItemDetailRef, id),
        from: catalogItemDetailProvider,
        name: r'catalogItemDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$catalogItemDetailHash,
        dependencies: CatalogItemDetailFamily._dependencies,
        allTransitiveDependencies:
            CatalogItemDetailFamily._allTransitiveDependencies,
        id: id,
      );

  CatalogItemDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<CatalogItemDetailEntity> Function(CatalogItemDetailRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CatalogItemDetailProvider._internal(
        (ref) => create(ref as CatalogItemDetailRef),
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
  AutoDisposeFutureProviderElement<CatalogItemDetailEntity> createElement() {
    return _CatalogItemDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogItemDetailProvider && other.id == id;
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
mixin CatalogItemDetailRef
    on AutoDisposeFutureProviderRef<CatalogItemDetailEntity> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CatalogItemDetailProviderElement
    extends AutoDisposeFutureProviderElement<CatalogItemDetailEntity>
    with CatalogItemDetailRef {
  _CatalogItemDetailProviderElement(super.provider);

  @override
  String get id => (origin as CatalogItemDetailProvider).id;
}

String _$catalogSummaryHash() => r'd51ee7fbf2bca122d138e8e72ba25969f0e45c58';

/// 수집 현황 요약. 홈 진행률 카드와 마이페이지 통계가 쓴다.
///
/// Copied from [catalogSummary].
@ProviderFor(catalogSummary)
final catalogSummaryProvider =
    AutoDisposeFutureProvider<CatalogSummaryEntity>.internal(
      catalogSummary,
      name: r'catalogSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$catalogSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CatalogSummaryRef = AutoDisposeFutureProviderRef<CatalogSummaryEntity>;
String _$collectCatalogItemByCodeHash() =>
    r'0f3efc5c3123f45c920e5010e3050a826408a9ff';

/// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
///
/// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
/// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
///
/// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
/// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
/// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
///
/// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
/// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
/// 호출부가 게스트 가드를 책임진다.
///
/// Copied from [collectCatalogItemByCode].
@ProviderFor(collectCatalogItemByCode)
const collectCatalogItemByCodeProvider = CollectCatalogItemByCodeFamily();

/// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
///
/// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
/// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
///
/// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
/// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
/// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
///
/// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
/// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
/// 호출부가 게스트 가드를 책임진다.
///
/// Copied from [collectCatalogItemByCode].
class CollectCatalogItemByCodeFamily extends Family<AsyncValue<void>> {
  /// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
  ///
  /// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
  /// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
  ///
  /// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
  /// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
  /// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
  ///
  /// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
  /// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
  /// 호출부가 게스트 가드를 책임진다.
  ///
  /// Copied from [collectCatalogItemByCode].
  const CollectCatalogItemByCodeFamily();

  /// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
  ///
  /// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
  /// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
  ///
  /// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
  /// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
  /// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
  ///
  /// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
  /// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
  /// 호출부가 게스트 가드를 책임진다.
  ///
  /// Copied from [collectCatalogItemByCode].
  CollectCatalogItemByCodeProvider call(String code) {
    return CollectCatalogItemByCodeProvider(code);
  }

  @override
  CollectCatalogItemByCodeProvider getProviderOverride(
    covariant CollectCatalogItemByCodeProvider provider,
  ) {
    return call(provider.code);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'collectCatalogItemByCodeProvider';
}

/// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
///
/// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
/// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
///
/// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
/// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
/// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
///
/// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
/// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
/// 호출부가 게스트 가드를 책임진다.
///
/// Copied from [collectCatalogItemByCode].
class CollectCatalogItemByCodeProvider extends AutoDisposeFutureProvider<void> {
  /// code(예: `A001`)로 도감 항목을 찾아 수집 처리하고, 요약·목록을 갱신한다.
  ///
  /// 퀴즈 보상 화면이 진입 시 발화한다 — 수집 판정이 백엔드에 아직 없어
  /// code만으로 즉시 수집 처리한다. 나중에 스캔 수집도 재사용한다.
  ///
  /// **주의**: 모르는 code·이미 수집한 항목은 조용히 스킵하고, 서버 409
  /// (`CATALOG_ITEM_ALREADY_COLLECTED`)는 성공으로 취급한다. 그 외 실패는
  /// AsyncError로 남는다 — 부가 흐름이라 화면은 error 상태를 그리지 않는다.
  ///
  /// **주의**: 게스트 호출 금지 — 토큰이 없어 첫 `GET /catalog`부터 401이
  /// 나고, 인증 인터셉터가 세션 만료로 오인해 강제 로그아웃시킨다(56e947b).
  /// 호출부가 게스트 가드를 책임진다.
  ///
  /// Copied from [collectCatalogItemByCode].
  CollectCatalogItemByCodeProvider(String code)
    : this._internal(
        (ref) =>
            collectCatalogItemByCode(ref as CollectCatalogItemByCodeRef, code),
        from: collectCatalogItemByCodeProvider,
        name: r'collectCatalogItemByCodeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$collectCatalogItemByCodeHash,
        dependencies: CollectCatalogItemByCodeFamily._dependencies,
        allTransitiveDependencies:
            CollectCatalogItemByCodeFamily._allTransitiveDependencies,
        code: code,
      );

  CollectCatalogItemByCodeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.code,
  }) : super.internal();

  final String code;

  @override
  Override overrideWith(
    FutureOr<void> Function(CollectCatalogItemByCodeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CollectCatalogItemByCodeProvider._internal(
        (ref) => create(ref as CollectCatalogItemByCodeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        code: code,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CollectCatalogItemByCodeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectCatalogItemByCodeProvider && other.code == code;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, code.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CollectCatalogItemByCodeRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `code` of this provider.
  String get code;
}

class _CollectCatalogItemByCodeProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with CollectCatalogItemByCodeRef {
  _CollectCatalogItemByCodeProviderElement(super.provider);

  @override
  String get code => (origin as CollectCatalogItemByCodeProvider).code;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
