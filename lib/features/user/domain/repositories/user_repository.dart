import '../entities/agreement_status_entity.dart';

/// User Repository 인터페이스
///
/// 사용자 프로필 관련 비즈니스 로직의 데이터 접근 추상화입니다.
abstract class UserRepository {
  /// 닉네임 변경
  ///
  /// 현재 로그인한 사용자의 닉네임을 [nickname]으로 변경합니다.
  ///
  /// Returns: 서버가 확정한 닉네임 (정규화될 수 있으므로 입력값과 다를 수 있음)
  /// Throws: 409 중복 시 `code == 'NICKNAME_ALREADY_EXISTS'`인 [AppException]
  Future<String> updateNickname(String nickname);

  /// 회원 탈퇴
  ///
  /// 백엔드에서 사용자 계정을 삭제합니다.
  /// 성공 시 로컬 정리(Firebase signOut, 토큰 삭제)는 호출자가 별도로 수행합니다.
  Future<void> deleteAccount();

  /// 약관 동의 상태를 조회합니다.
  ///
  /// Returns: 현재 사용자의 4종 약관 동의 여부
  /// Throws: [NetworkException], [ServerException], [AuthException]
  Future<AgreementStatusEntity> getAgreements();

  /// 약관 동의 정보를 저장합니다.
  ///
  /// 필수 3종(이용약관·개인정보처리방침·위치정보 이용약관)은 내부적으로 true로
  /// 고정되며, 마케팅만 사용자 선택값을 전달합니다.
  ///
  /// [marketing]: 마케팅 수신 동의 여부 (true/false)
  /// Throws: [NetworkException], [ServerException], [ValidationException]
  Future<void> updateAgreements({required bool marketing});
}
