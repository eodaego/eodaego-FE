// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseRemoteDataSourceHash() =>
    r'586a255583ce79946cc5696aea3451f951008218';

/// CourseRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [CourseMockDataSource]로 바뀐다.
///
/// **주의**: keepAlive다. 목 데이터소스가 즐겨찾기 상태를 인메모리로 들고 있어,
/// 인스턴스가 재생성되면 목 모드에서 하트가 초기화된다.
///
/// Copied from [courseRemoteDataSource].
@ProviderFor(courseRemoteDataSource)
final courseRemoteDataSourceProvider =
    Provider<CourseRemoteDataSource>.internal(
      courseRemoteDataSource,
      name: r'courseRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$courseRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CourseRemoteDataSourceRef = ProviderRef<CourseRemoteDataSource>;
String _$courseRepositoryHash() => r'4a37c4184ff145ab54fdb43405c49fb2b87e2b63';

/// CourseRepository Provider
///
/// Copied from [courseRepository].
@ProviderFor(courseRepository)
final courseRepositoryProvider = Provider<CourseRepository>.internal(
  courseRepository,
  name: r'courseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$courseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CourseRepositoryRef = ProviderRef<CourseRepository>;
String _$courseRecommendationHash() =>
    r'498315dd1ad8c451dfc3c760f38dc7c8a01b8cf1';

/// 코스 추천 결과.
///
/// `null`은 "아직 요청하지 않음", 빈 목록은 "요청했으나 결과 없음"이다. 화면이 둘을 구분한다.
///
/// **주의**: 추천은 호출할 때마다 AI 서버를 거치고 서버에 코스가 새로 저장된다.
/// 결과를 여기 보관하므로 스와이프·리빌드로 재호출되지 않는다.
///
/// Copied from [CourseRecommendation].
@ProviderFor(CourseRecommendation)
final courseRecommendationProvider =
    AutoDisposeAsyncNotifierProvider<
      CourseRecommendation,
      List<CourseEntity>?
    >.internal(
      CourseRecommendation.new,
      name: r'courseRecommendationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$courseRecommendationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CourseRecommendation = AutoDisposeAsyncNotifier<List<CourseEntity>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
