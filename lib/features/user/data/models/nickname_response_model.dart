import 'package:freezed_annotation/freezed_annotation.dart';

part 'nickname_response_model.freezed.dart';
part 'nickname_response_model.g.dart';

/// 닉네임 변경 응답 DTO
///
/// `PATCH /api/1/members/me/nickname` 응답 (200)
///
/// **응답 예시**:
/// ```json
/// { "nickname": "어대탐험가" }
/// ```
///
/// 서버가 값을 정규화할 수 있으므로 호출자는 입력값이 아니라
/// **이 응답값**을 상태에 반영해야 한다.
@freezed
class NicknameResponseModel with _$NicknameResponseModel {
  const factory NicknameResponseModel({
    /// 변경된 닉네임
    @Default('') String nickname,
  }) = _NicknameResponseModel;

  factory NicknameResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NicknameResponseModelFromJson(json);
}
