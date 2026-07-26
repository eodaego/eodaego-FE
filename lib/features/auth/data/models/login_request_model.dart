import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// 소셜 로그인 요청 DTO
///
/// `POST /api/1/auth/login` 요청 바디
///
/// **필수 필드**: [idToken], [socialType], [deviceType], [deviceId]
///
/// [fcmToken]은 선택이며 **null이면 JSON에서 생략된다**.
/// 서버는 값이 있을 때만 갱신하고 생략하면 기존 값을 유지하므로,
/// FCM을 받을 수 없는 환경(에뮬레이터 등)에서 빈 문자열을 보내면
/// 서버에 저장된 멀쩡한 토큰을 덮어쓰게 된다.
@freezed
class LoginRequestModel with _$LoginRequestModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(includeIfNull: false)
  const factory LoginRequestModel({
    /// Firebase ID Token
    required String idToken,

    /// 소셜 로그인 제공자 (`GOOGLE`, `APPLE`)
    required String socialType,

    /// 디바이스 타입 (`IOS`, `ANDROID`)
    required String deviceType,

    /// 고유 디바이스 ID
    required String deviceId,

    /// FCM 디바이스 토큰 (선택 — null이면 전송하지 않음)
    String? fcmToken,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}
