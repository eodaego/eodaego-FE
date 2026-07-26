import 'package:freezed_annotation/freezed_annotation.dart';

part 'agreement_request_model.freezed.dart';
part 'agreement_request_model.g.dart';

/// 약관 동의 저장 요청 DTO
///
/// `PATCH /api/1/members/me/agreements` 요청 본문
///
/// 필수 3종(개인정보처리방침/위치정보/이용약관)은 **all-or-nothing**이다.
/// 셋 다 true로만 보낼 수 있으며, 하나라도 false거나 누락되면 400이 반환된다.
/// 마케팅은 선택값으로 자유롭게 켜고 끌 수 있다.
///
/// **요청 예시**:
/// ```json
/// {
///   "termsOfServiceAgreed": true,
///   "privacyPolicyAgreed": true,
///   "locationInfoAgreed": true,
///   "marketingAgreed": false
/// }
/// ```
@freezed
class AgreementRequestModel with _$AgreementRequestModel {
  const factory AgreementRequestModel({
    /// 이용약관 동의 여부 (필수, true여야 함)
    required bool termsOfServiceAgreed,

    /// 개인정보처리방침 동의 여부 (필수, true여야 함)
    required bool privacyPolicyAgreed,

    /// 위치정보 수집 동의 여부 (필수, true여야 함)
    required bool locationInfoAgreed,

    /// 마케팅 정보 수신 동의 여부 (선택)
    required bool marketingAgreed,
  }) = _AgreementRequestModel;

  factory AgreementRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementRequestModelFromJson(json);
}
