import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// 소셜 로그인 응답 DTO
///
/// `POST /api/1/auth/login` 응답 (200 — 신규 가입도 200)
///
/// **응답 예시**:
/// ```json
/// {
///   "accessToken": "eyJhbG...",
///   "refreshToken": "eyJhbG...",
///   "firstLogin": false,
///   "requiresAgreement": true,
///   "nickname": "회원a1b2c3d4",
///   "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// }
/// ```
///
/// 정본 OpenAPI에 `required` 선언이 없으므로, **세션 성립에 필수인 3개만**
/// non-null로 두고 나머지는 안전한 기본값을 준다.
@freezed
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    /// JWT Access Token — 없으면 세션이 성립하지 않으므로 파싱 실패가 맞다
    required String accessToken,

    /// JWT Refresh Token
    required String refreshToken,

    /// 회원 고유 ID (UUID)
    required String userId,

    /// 필수 약관 미동의 여부
    ///
    /// 신규 회원은 항상 true. 기존 회원도 필수 약관 미동의면 매 로그인마다 true.
    /// **누락 시 true(fail-closed)** — 약관 게이트를 열지 않는다.
    @Default(true) bool requiresAgreement,

    /// 이번 요청에서 신규 가입이 함께 처리되었는지 여부
    ///
    /// 누락 시 false — 기존 회원으로 취급해 추가 온보딩을 띄우지 않는다.
    @Default(false) bool firstLogin,

    /// 회원 닉네임 (서버 자동 발급)
    @Default('') String nickname,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
