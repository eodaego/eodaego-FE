import 'package:freezed_annotation/freezed_annotation.dart';

part 'nickname_availability_response_model.freezed.dart';
part 'nickname_availability_response_model.g.dart';

/// 닉네임 중복 확인 응답 DTO
///
/// `GET /api/1/members/me/nickname/exists?nickname=...` 응답 (200)
///
/// **응답 예시**:
/// ```json
/// { "available": true }
/// ```
///
/// `available: true`면 쓸 수 있는 닉네임, `false`면 다른 회원이 이미 쓰는 중이다.
/// 본인이 현재 쓰는 닉네임은 중복 대상에서 제외되어 `true`로 온다.
@freezed
class NicknameAvailabilityResponseModel
    with _$NicknameAvailabilityResponseModel {
  const factory NicknameAvailabilityResponseModel({
    /// 사용 가능 여부
    @Default(false) bool available,
  }) = _NicknameAvailabilityResponseModel;

  factory NicknameAvailabilityResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$NicknameAvailabilityResponseModelFromJson(json);
}
