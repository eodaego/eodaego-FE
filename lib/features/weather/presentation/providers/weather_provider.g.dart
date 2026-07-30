// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherRemoteDataSourceHash() =>
    r'aa034b878de33e2ea71d72547b83c84b6ef68238';

/// WeatherRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [WeatherMockDataSource]로 바뀐다.
/// 아래 [weatherRepositoryProvider]는 어느 쪽이든 같은 인터페이스만 보므로
/// 수정할 필요가 없다.
///
/// Copied from [weatherRemoteDataSource].
@ProviderFor(weatherRemoteDataSource)
final weatherRemoteDataSourceProvider =
    AutoDisposeProvider<WeatherRemoteDataSource>.internal(
      weatherRemoteDataSource,
      name: r'weatherRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weatherRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherRemoteDataSourceRef =
    AutoDisposeProviderRef<WeatherRemoteDataSource>;
String _$weatherRepositoryHash() => r'b48e6c63994399349787e077c5e674f890d51718';

/// WeatherRepository Provider
///
/// Copied from [weatherRepository].
@ProviderFor(weatherRepository)
final weatherRepositoryProvider =
    AutoDisposeProvider<WeatherRepository>.internal(
      weatherRepository,
      name: r'weatherRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weatherRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherRepositoryRef = AutoDisposeProviderRef<WeatherRepository>;
String _$currentWeatherHash() => r'4951b2f0d192f991c441c41cf625372dd690a93b';

/// 현재 날씨. 홈 상단 바와 날씨 상세 화면이 함께 본다.
///
/// **주의**: 상세는 홈에서 push라 홈이 스택에 남는다. 같은 provider를 보므로
/// 상세로 들어갈 때 재요청이 나가지 않는다.
///
/// Copied from [currentWeather].
@ProviderFor(currentWeather)
final currentWeatherProvider =
    AutoDisposeFutureProvider<WeatherEntity>.internal(
      currentWeather,
      name: r'currentWeatherProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentWeatherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWeatherRef = AutoDisposeFutureProviderRef<WeatherEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
