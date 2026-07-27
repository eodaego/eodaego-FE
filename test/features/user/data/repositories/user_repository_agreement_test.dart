import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/user/data/datasources/user_remote_datasource.dart';
import 'package:eodaego/features/user/data/models/agreement_request_model.dart';
import 'package:eodaego/features/user/data/models/agreement_response_model.dart';
import 'package:eodaego/features/user/data/models/nickname_availability_response_model.dart';
import 'package:eodaego/features/user/data/models/nickname_response_model.dart';
import 'package:eodaego/features/user/data/models/nickname_update_request_model.dart';
import 'package:eodaego/features/user/data/repositories/user_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserRemoteDataSource implements UserRemoteDataSource {
  AgreementResponseModel? responseToReturn;
  AgreementRequestModel? lastUpdateRequest;
  Object? errorToThrow;

  @override
  Future<AgreementResponseModel> getAgreements() async {
    if (errorToThrow != null) throw errorToThrow!;
    return responseToReturn!;
  }

  @override
  Future<NicknameAvailabilityResponseModel> checkNicknameAvailability(
    String nickname,
  ) => throw UnimplementedError();

  @override
  Future<void> updateAgreements(AgreementRequestModel request) async {
    lastUpdateRequest = request;
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<NicknameResponseModel> updateNickname(
    NicknameUpdateRequestModel request,
  ) => throw UnimplementedError();

  @override
  Future<void> deleteAccount() async {}
}

DioException _dioError(int statusCode) => DioException(
  requestOptions: RequestOptions(path: '/api/1/members/me/agreements'),
  response: Response(
    requestOptions: RequestOptions(path: '/api/1/members/me/agreements'),
    statusCode: statusCode,
    data: {'errorCode': 'INVALID_REQUEST', 'errorMessage': '잘못된 요청입니다.'},
  ),
  type: DioExceptionType.badResponse,
);

void main() {
  group('UserRepositoryImpl.getAgreements', () {
    test('성공 시 AgreementStatusEntity를 반환한다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..responseToReturn = const AgreementResponseModel(
          termsOfServiceAgreed: true,
          privacyPolicyAgreed: true,
          locationInfoAgreed: true,
          marketingAgreed: false,
        );
      final repo = UserRepositoryImpl(fake);

      final result = await repo.getAgreements();

      expect(result.termsOfService, true);
      expect(result.privacyPolicy, true);
      expect(result.locationTerms, true);
      expect(result.marketing, false);
      expect(result.hasAllRequired, true);
    });

    test('DioException은 AppException으로 변환된다', () async {
      final fake = _FakeUserRemoteDataSource()..errorToThrow = _dioError(401);
      final repo = UserRepositoryImpl(fake);

      expect(() => repo.getAgreements(), throwsA(isA<AppException>()));
    });

    test('응답의 동의 일시를 엔티티로 옮긴다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..responseToReturn = const AgreementResponseModel(
          termsOfServiceAgreed: true,
          privacyPolicyAgreed: true,
          locationInfoAgreed: true,
          marketingAgreed: true,
          termsAgreedAt: '2026-07-12T10:00:00+09:00',
          marketingAgreedAt: '2026-07-20T09:30:00+09:00',
        );
      final repository = UserRepositoryImpl(fake);

      final entity = await repository.getAgreements();

      expect(entity.termsAgreedAt, '2026-07-12T10:00:00+09:00');
      expect(entity.marketingAgreedAt, '2026-07-20T09:30:00+09:00');
    });
  });

  group('UserRepositoryImpl.updateAgreements', () {
    test('필수 3종은 항상 true로 고정되고 marketing만 사용자 값이 반영된다', () async {
      final fake = _FakeUserRemoteDataSource();
      final repo = UserRepositoryImpl(fake);

      await repo.updateAgreements(marketing: true);

      expect(fake.lastUpdateRequest, isNotNull);
      expect(fake.lastUpdateRequest!.termsOfServiceAgreed, true);
      expect(fake.lastUpdateRequest!.privacyPolicyAgreed, true);
      expect(fake.lastUpdateRequest!.locationInfoAgreed, true);
      expect(fake.lastUpdateRequest!.marketingAgreed, true);
    });

    test('marketing=false도 정상 전달된다', () async {
      final fake = _FakeUserRemoteDataSource();
      final repo = UserRepositoryImpl(fake);

      await repo.updateAgreements(marketing: false);

      expect(fake.lastUpdateRequest!.marketingAgreed, false);
    });

    test('DioException은 AppException으로 변환된다', () async {
      final fake = _FakeUserRemoteDataSource()..errorToThrow = _dioError(400);
      final repo = UserRepositoryImpl(fake);

      expect(
        () => repo.updateAgreements(marketing: false),
        throwsA(isA<AppException>()),
      );
    });
  });
}
