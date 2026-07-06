// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthDataSourceHash() =>
    r'95a0b0edd77b64b9889b799f7f261a1e504f76b6';

/// FirebaseAuthDataSource Provider (keepAlive — 인터셉터 콜백에서 접근)
///
/// Copied from [firebaseAuthDataSource].
@ProviderFor(firebaseAuthDataSource)
final firebaseAuthDataSourceProvider =
    Provider<FirebaseAuthDataSource>.internal(
      firebaseAuthDataSource,
      name: r'firebaseAuthDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseAuthDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthDataSourceRef = ProviderRef<FirebaseAuthDataSource>;
String _$authRemoteDataSourceHash() =>
    r'111774415636cd6b737e8306457009f807e27324';

/// AuthRemoteDataSource Provider (Retrofit)
///
/// Copied from [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider =
    AutoDisposeProvider<AuthRemoteDataSource>.internal(
      authRemoteDataSource,
      name: r'authRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = AutoDisposeProviderRef<AuthRemoteDataSource>;
String _$authRepositoryHash() => r'76a65429e2d010171c010ca11e8101871250895e';

/// AuthRepository Provider
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$signInWithGoogleUseCaseHash() =>
    r'1b922e2ed7b15d3f4948b255a65e9e37bc95fd33';

/// See also [signInWithGoogleUseCase].
@ProviderFor(signInWithGoogleUseCase)
final signInWithGoogleUseCaseProvider =
    AutoDisposeProvider<SignInWithGoogleUseCase>.internal(
      signInWithGoogleUseCase,
      name: r'signInWithGoogleUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signInWithGoogleUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInWithGoogleUseCaseRef =
    AutoDisposeProviderRef<SignInWithGoogleUseCase>;
String _$signInWithAppleUseCaseHash() =>
    r'10f7cc44b09f9a9f109c4622df23bbe451d78fb4';

/// See also [signInWithAppleUseCase].
@ProviderFor(signInWithAppleUseCase)
final signInWithAppleUseCaseProvider =
    AutoDisposeProvider<SignInWithAppleUseCase>.internal(
      signInWithAppleUseCase,
      name: r'signInWithAppleUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$signInWithAppleUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInWithAppleUseCaseRef =
    AutoDisposeProviderRef<SignInWithAppleUseCase>;
String _$signOutUseCaseHash() => r'5f5ccc3ba2bafb31ec2906556a4e9bc5a6f15262';

/// See also [signOutUseCase].
@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = AutoDisposeProvider<SignOutUseCase>.internal(
  signOutUseCase,
  name: r'signOutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutUseCaseRef = AutoDisposeProviderRef<SignOutUseCase>;
String _$authStateHash() => r'0ae5a81036a69d1def479f95de19902549df6988';

/// Firebase Auth State 스트림 (GoRouter refreshListenable 용)
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<User?>;
String _$authNotifierHash() => r'09cc4e30ed949451fe5eb52ab1a1c450ce3f01bc';

/// 인증 상태 Notifier. State: `AsyncValue<AuthResultEntity?>` (null = 미로그인)
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, AuthResultEntity?>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<AuthResultEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
