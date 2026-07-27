import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/agreement_request_model.dart';
import '../models/agreement_response_model.dart';
import '../models/nickname_response_model.dart';
import '../models/nickname_update_request_model.dart';

part 'user_remote_datasource.g.dart';

/// User 백엔드 API 클라이언트
///
/// Retrofit 기반으로 User API를 호출합니다.
///
/// **엔드포인트**:
/// - `PATCH /api/1/members/me/nickname` - 닉네임 변경 (JWT 필요)
/// - `DELETE /api/1/members/me` - 회원 탈퇴 (JWT 필요)
@RestApi()
abstract class UserRemoteDataSource {
  factory UserRemoteDataSource(Dio dio) = _UserRemoteDataSource;

  /// 닉네임 변경
  ///
  /// 현재 로그인한 사용자의 닉네임을 변경합니다.
  ///
  /// - 200: 변경 성공 (변경된 닉네임 반환)
  /// - 400: 형식 검증 실패 (INVALID_REQUEST)
  /// - 409: 이미 사용 중인 닉네임 (NICKNAME_ALREADY_EXISTS)
  @PATCH(ApiEndpoints.updateNickname)
  Future<NicknameResponseModel> updateNickname(
    @Body() NicknameUpdateRequestModel request,
  );

  /// 회원 탈퇴
  ///
  /// 로그인한 사용자의 계정을 삭제합니다.
  ///
  /// - 204: 탈퇴 성공 (응답 본문 없음)
  /// - 401: 인증 실패 (UNAUTHORIZED)
  /// - 404: 존재하지 않는 회원 (MEMBER_NOT_FOUND)
  @DELETE(ApiEndpoints.deleteAccount)
  Future<void> deleteAccount();

  /// 약관 동의 상태 조회
  ///
  /// 현재 로그인한 사용자의 4종 약관 동의 여부를 조회합니다.
  ///
  /// - 200: 약관 동의 상태 (AgreementResponseModel)
  /// - 401: 인증 실패
  @GET(ApiEndpoints.agreements)
  Future<AgreementResponseModel> getAgreements();

  /// 약관 동의 저장
  ///
  /// 현재 로그인한 사용자의 약관 동의 정보를 저장합니다.
  /// 필수 3종(termsOfServiceAgreed, privacyPolicyAgreed, locationInfoAgreed)은 모두 true여야 합니다.
  ///
  /// - 204: 저장 성공 (응답 본문 없음)
  /// - 400: 유효성 검사 실패 (필수 약관 미동의)
  /// - 401: 인증 실패
  @PATCH(ApiEndpoints.agreements)
  Future<void> updateAgreements(@Body() AgreementRequestModel request);
}
