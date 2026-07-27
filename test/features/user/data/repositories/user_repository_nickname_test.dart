import 'package:dio/dio.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/user/data/datasources/user_remote_datasource.dart';
import 'package:eodaego/features/user/data/models/agreement_request_model.dart';
import 'package:eodaego/features/user/data/models/agreement_response_model.dart';
import 'package:eodaego/features/user/data/models/nickname_availability_response_model.dart';
import 'package:eodaego/features/user/data/models/nickname_response_model.dart';
import 'package:eodaego/features/user/data/models/nickname_update_request_model.dart';
import 'package:eodaego/features/user/data/repositories/user_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserRemoteDataSource implements UserRemoteDataSource {
  NicknameUpdateRequestModel? lastNicknameRequest;
  NicknameResponseModel responseToReturn = const NicknameResponseModel(
    nickname: '어대탐험가',
  );
  Object? errorToThrow;

  @override
  Future<NicknameResponseModel> updateNickname(
    NicknameUpdateRequestModel request,
  ) async {
    lastNicknameRequest = request;
    if (errorToThrow != null) throw errorToThrow!;
    return responseToReturn;
  }

  @override
  Future<AgreementResponseModel> getAgreements() => throw UnimplementedError();

  NicknameAvailabilityResponseModel? availabilityToReturn;
  String? lastCheckedNickname;

  @override
  Future<NicknameAvailabilityResponseModel> checkNicknameAvailability(
    String nickname,
  ) async {
    lastCheckedNickname = nickname;
    if (errorToThrow != null) throw errorToThrow!;
    return availabilityToReturn!;
  }

  @override
  Future<void> updateAgreements(AgreementRequestModel request) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAccount() async {}
}

DioException _dioError(int statusCode, String errorCode) {
  final req = RequestOptions(path: '/api/1/members/me/nickname');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode,
      data: {'errorCode': errorCode, 'errorMessage': '오류'},
    ),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  group('UserRepositoryImpl.updateNickname', () {
    test('서버가 확정한 닉네임을 반환한다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..responseToReturn = const NicknameResponseModel(nickname: '어대탐험가');
      final repo = UserRepositoryImpl(fake);

      final result = await repo.updateNickname('어대탐험가');

      expect(result, '어대탐험가');
      expect(fake.lastNicknameRequest!.nickname, '어대탐험가');
    });

    test('409는 NICKNAME_ALREADY_EXISTS를 code에 담은 AppException이 된다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..errorToThrow = _dioError(409, 'NICKNAME_ALREADY_EXISTS');
      final repo = UserRepositoryImpl(fake);

      await expectLater(
        repo.updateNickname('중복닉네임'),
        throwsA(
          isA<AppException>().having(
            (e) => e.code,
            'code',
            'NICKNAME_ALREADY_EXISTS',
          ),
        ),
      );
    });

    test('400도 AppException으로 변환된다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..errorToThrow = _dioError(400, 'INVALID_REQUEST');
      final repo = UserRepositoryImpl(fake);

      await expectLater(
        repo.updateNickname('!!'),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('UserRepositoryImpl.isNicknameAvailable', () {
    test('available를 그대로 반환하고 닉네임을 쿼리로 넘긴다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..availabilityToReturn = const NicknameAvailabilityResponseModel(
          available: true,
        );
      final repo = UserRepositoryImpl(fake);

      final result = await repo.isNicknameAvailable('새이름');

      expect(result, isTrue);
      expect(fake.lastCheckedNickname, '새이름');
    });

    test('이미 쓰는 닉네임이면 false를 반환한다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..availabilityToReturn = const NicknameAvailabilityResponseModel(
          available: false,
        );
      final repo = UserRepositoryImpl(fake);

      expect(await repo.isNicknameAvailable('중복이름'), isFalse);
    });

    test('400은 ValidationException으로 변환된다', () async {
      final fake = _FakeUserRemoteDataSource()
        ..errorToThrow = _dioError(400, 'INVALID_REQUEST');
      final repo = UserRepositoryImpl(fake);

      await expectLater(
        repo.isNicknameAvailable('a'),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
