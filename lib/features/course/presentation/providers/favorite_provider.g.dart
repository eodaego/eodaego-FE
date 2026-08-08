// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteCoursesHash() => r'9c8f78d867336eec707111f73ea3b0a704d5fd02';

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

/// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
///
/// Copied from [favoriteCourses].
@ProviderFor(favoriteCourses)
const favoriteCoursesProvider = FavoriteCoursesFamily();

/// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
///
/// Copied from [favoriteCourses].
class FavoriteCoursesFamily extends Family<AsyncValue<List<CourseEntity>>> {
  /// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
  ///
  /// Copied from [favoriteCourses].
  const FavoriteCoursesFamily();

  /// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
  ///
  /// Copied from [favoriteCourses].
  FavoriteCoursesProvider call(FavoriteSort sort) {
    return FavoriteCoursesProvider(sort);
  }

  @override
  FavoriteCoursesProvider getProviderOverride(
    covariant FavoriteCoursesProvider provider,
  ) {
    return call(provider.sort);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'favoriteCoursesProvider';
}

/// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
///
/// Copied from [favoriteCourses].
class FavoriteCoursesProvider
    extends AutoDisposeFutureProvider<List<CourseEntity>> {
  /// 즐겨찾기한 코스 목록. 정렬은 서버가 한다.
  ///
  /// Copied from [favoriteCourses].
  FavoriteCoursesProvider(FavoriteSort sort)
    : this._internal(
        (ref) => favoriteCourses(ref as FavoriteCoursesRef, sort),
        from: favoriteCoursesProvider,
        name: r'favoriteCoursesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$favoriteCoursesHash,
        dependencies: FavoriteCoursesFamily._dependencies,
        allTransitiveDependencies:
            FavoriteCoursesFamily._allTransitiveDependencies,
        sort: sort,
      );

  FavoriteCoursesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sort,
  }) : super.internal();

  final FavoriteSort sort;

  @override
  Override overrideWith(
    FutureOr<List<CourseEntity>> Function(FavoriteCoursesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FavoriteCoursesProvider._internal(
        (ref) => create(ref as FavoriteCoursesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CourseEntity>> createElement() {
    return _FavoriteCoursesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoriteCoursesProvider && other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FavoriteCoursesRef on AutoDisposeFutureProviderRef<List<CourseEntity>> {
  /// The parameter `sort` of this provider.
  FavoriteSort get sort;
}

class _FavoriteCoursesProviderElement
    extends AutoDisposeFutureProviderElement<List<CourseEntity>>
    with FavoriteCoursesRef {
  _FavoriteCoursesProviderElement(super.provider);

  @override
  FavoriteSort get sort => (origin as FavoriteCoursesProvider).sort;
}

String _$favoriteToggleHash() => r'be041d3d38c0fd400330d39d2f162053265eb9de';

/// 즐겨찾기 토글 1회 = API 호출 + 목록 무효화.
///
/// 하트 상태 자체는 갖지 않는다. 화면이 자기 목록을 낙관적으로 먼저 뒤집고,
/// 실패하면 되돌린다. 등록·삭제 둘 다 멱등이라 더블탭·재시도가 안전하다.
///
/// **주의**: keepAlive다. 화면이 `ref.read(...notifier)`로만 쓰고 watch하지 않아
/// autoDispose면 API 응답을 기다리는 동안 폐기된다. 폐기 시 Riverpod이 내부
/// `_futureCompleter`를 완료시키면서 비우지 않아, 응답 후 `state` 대입이
/// `Bad state: Future already completed`로 터졌다.
///
/// Copied from [FavoriteToggle].
@ProviderFor(FavoriteToggle)
final favoriteToggleProvider =
    AsyncNotifierProvider<FavoriteToggle, void>.internal(
      FavoriteToggle.new,
      name: r'favoriteToggleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteToggleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteToggle = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
