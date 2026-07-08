import 'package:eodaego/core/storage/secure_token_storage.dart';
import 'package:eodaego/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:eodaego/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:eodaego/features/auth/data/models/logout_request_model.dart';
import 'package:eodaego/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LogoutRequestModel(refreshToken: ''));
  });

  late _MockFirebaseAuthDataSource firebase;
  late _MockAuthRemoteDataSource remote;
  late _MockSecureTokenStorage storage;
  late AuthRepositoryImpl repo;

  setUp(() {
    firebase = _MockFirebaseAuthDataSource();
    remote = _MockAuthRemoteDataSource();
    storage = _MockSecureTokenStorage();
    repo = AuthRepositoryImpl(
      firebaseAuthDataSource: firebase,
      authRemoteDataSource: remote,
      tokenStorage: storage,
    );
    when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => remote.logout(any())).thenAnswer((_) async {});
    when(() => firebase.signOut()).thenAnswer((_) async {});
    when(() => storage.clearTokens()).thenAnswer((_) async {});
  });

  group('AuthRepositoryImpl.signOut', () {
    test('정상 경로: 백엔드·Firebase·토큰삭제 모두 호출된다', () async {
      await repo.signOut();
      verify(() => remote.logout(any())).called(1);
      verify(() => firebase.signOut()).called(1);
      verify(() => storage.clearTokens()).called(1);
    });

    test('백엔드 로그아웃 실패해도 clearTokens 호출되고 예외가 새지 않는다', () async {
      when(() => remote.logout(any())).thenThrow(Exception('backend down'));
      await repo.signOut();
      verify(() => firebase.signOut()).called(1);
      verify(() => storage.clearTokens()).called(1);
    });

    test('Firebase 로그아웃 실패해도 clearTokens 호출되고 예외가 새지 않는다', () async {
      when(() => firebase.signOut()).thenThrow(Exception('firebase error'));
      await repo.signOut();
      verify(() => storage.clearTokens()).called(1);
    });
  });
}
