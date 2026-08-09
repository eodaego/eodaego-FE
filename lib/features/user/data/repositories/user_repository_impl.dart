import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_message_keys.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_exception_handler.dart';
import '../../domain/entities/agreement_status_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/agreement_request_model.dart';
import '../models/nickname_update_request_model.dart';

/// User Repository 구현체
///
/// [UserRemoteDataSource]를 통해 백엔드 User API를 호출합니다.
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<String> updateNickname(String nickname) async {
    try {
      final response = await _dataSource.updateNickname(
        NicknameUpdateRequestModel(nickname: nickname),
      );

      if (kDebugMode) {
        debugPrint('✅ 닉네임 변경 성공: ${response.nickname}');
      }

      return response.nickname;
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '닉네임을 바꾸지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorNicknameUpdateUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final response = await _dataSource.checkNicknameAvailability(nickname);

      if (kDebugMode) {
        debugPrint('🔍 닉네임 중복 확인: $nickname → ${response.available}');
      }

      return response.available;
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '닉네임을 확인하지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorNicknameCheckUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dataSource.deleteAccount();

      if (kDebugMode) {
        debugPrint('✅ 회원 탈퇴 성공');
      }
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      throw ServerException(
        message: '탈퇴하지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorDeleteAccountUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<AgreementStatusEntity> getAgreements() async {
    try {
      final response = await _dataSource.getAgreements();

      if (kDebugMode) {
        debugPrint(
          '✅ 약관 동의 상태 조회: '
          'terms=${response.termsOfServiceAgreed}, '
          'privacy=${response.privacyPolicyAgreed}, '
          'location=${response.locationInfoAgreed}, '
          'marketing=${response.marketingAgreed}',
        );
      }

      return AgreementStatusEntity(
        termsOfService: response.termsOfServiceAgreed,
        privacyPolicy: response.privacyPolicyAgreed,
        locationTerms: response.locationInfoAgreed,
        marketing: response.marketingAgreed,
        termsAgreedAt: response.termsAgreedAt,
        marketingAgreedAt: response.marketingAgreedAt,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '약관 동의 상태를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorAgreementFetchUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateAgreements({required bool marketing}) async {
    try {
      await _dataSource.updateAgreements(
        AgreementRequestModel(
          termsOfServiceAgreed: true,
          privacyPolicyAgreed: true,
          locationInfoAgreed: true,
          marketingAgreed: marketing,
        ),
      );

      if (kDebugMode) {
        debugPrint('✅ 약관 동의 저장 성공 (marketing=$marketing)');
      }
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '약관 동의를 저장하지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorAgreementSaveUnexpected,
        originalException: e,
      );
    }
  }
}
