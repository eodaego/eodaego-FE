/// 사용자 입력 검증 유틸리티
///
/// 백엔드 검증 규칙을 클라이언트에서 미리 적용해 즉시 피드백을 준다.
/// 서버 검증은 그대로 신뢰 경계로 남으므로, 여기서 통과해도 400이 올 수 있다.
class Validators {
  Validators._();

  /// 닉네임 허용 문자: 한글/영문/숫자 (공백·특수문자 불가)
  static final RegExp _nicknamePattern = RegExp(r'^[가-힣a-zA-Z0-9]+$');

  /// 닉네임 최소 길이 (정본 `NicknameUpdateRequest.minLength`)
  static const int nicknameMinLength = 2;

  /// 닉네임 최대 길이 (정본 `NicknameUpdateRequest.maxLength`)
  static const int nicknameMaxLength = 30;

  /// 닉네임 검증
  ///
  /// 유효하면 `null`, 아니면 사용자에게 표시할 메시지를 반환한다.
  /// 앞뒤 공백은 제거한 뒤 검사하므로, 호출자도 서버에 보낼 때 trim해야 한다.
  static String? validateNickname(String? value) {
    final nickname = value?.trim() ?? '';

    if (nickname.isEmpty) {
      return '닉네임을 입력해 주세요';
    }

    if (nickname.length < nicknameMinLength ||
        nickname.length > nicknameMaxLength) {
      return '$nicknameMinLength자에서 $nicknameMaxLength자 사이로 입력해 주세요';
    }

    if (!_nicknamePattern.hasMatch(nickname)) {
      return '한글, 영문, 숫자만 쓸 수 있어요';
    }

    return null;
  }
}
