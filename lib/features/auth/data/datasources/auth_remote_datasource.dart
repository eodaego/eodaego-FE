import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

part 'auth_remote_datasource.g.dart';

/// Auth 백엔드 API 클라이언트
///
/// **엔드포인트**:
/// - `POST /api/1/auth/login` — 소셜 로그인
/// - `POST /api/1/auth/logout` — 로그아웃
///
/// 토큰 재발급(`/api/1/auth/reissue`)은 [AuthInterceptor]가 직접 처리하므로
/// 여기에 두지 않는다.
@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  /// 소셜 로그인
  ///
  /// Firebase ID Token을 백엔드에 전송하여 JWT를 발급받습니다.
  /// 신규 가입이 함께 일어나도 200을 반환하며, `firstLogin`으로 구분합니다.
  ///
  /// - 200: 로그인 성공
  /// - 400: 요청 바디 검증 실패 (INVALID_REQUEST)
  /// - 401: 토큰 검증 실패 (FIREBASE_TOKEN_VERIFICATION_FAILED, SOCIAL_TYPE_MISMATCH)
  @POST(ApiEndpoints.login)
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);

  /// 로그아웃
  ///
  /// 서버가 refreshToken을 삭제합니다. 요청 바디는 없으며
  /// `Authorization: Bearer {accessToken}` 헤더만 사용합니다.
  ///
  /// - 204: 로그아웃 성공 (응답 본문 없음)
  @POST(ApiEndpoints.logout)
  Future<void> logout();
}
