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

  /// 닉네임 사용 가능 여부 확인
  ///
  /// 저장 전에 미리 중복을 알려주기 위한 조회다. 저장 시점의 409는 이 확인과
  /// 무관하게 여전히 발생할 수 있으므로(확인과 저장 사이에 남이 선점 가능),
  /// 이 결과를 최종 보장으로 취급하지 않는다.
  ///
  /// 본인이 현재 쓰는 닉네임은 중복 대상에서 제외되어 `true`를 반환한다.
  ///
  /// Returns: 쓸 수 있으면 `true`
  /// Throws: 형식 위반 시 [ValidationException], 그 외 [NetworkException] 등
  Future<bool> isNicknameAvailable(String nickname);

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
