// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizRemoteDataSourceHash() =>
    r'48c83958f2d46f3f6f5edaf7f9d64bcec30cf7f2';

/// QuizRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [QuizMockDataSource]로 바뀐다.
/// **주의**: 목이 정답 id를 인메모리로 들고 있어 keepAlive여야 한다.
///
/// Copied from [quizRemoteDataSource].
@ProviderFor(quizRemoteDataSource)
final quizRemoteDataSourceProvider = Provider<QuizRemoteDataSource>.internal(
  quizRemoteDataSource,
  name: r'quizRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizRemoteDataSourceRef = ProviderRef<QuizRemoteDataSource>;
String _$quizRepositoryHash() => r'0034693d9aaa8fe696cf924be4cb662df208cf26';

/// QuizRepository Provider
///
/// Copied from [quizRepository].
@ProviderFor(quizRepository)
final quizRepositoryProvider = Provider<QuizRepository>.internal(
  quizRepository,
  name: r'quizRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizRepositoryRef = ProviderRef<QuizRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
