import '../repositories/user_repository.dart';

/// 회원 탈퇴 UseCase
///
/// 백엔드 `DELETE /api/1/members/me`를 호출하여 계정을 삭제합니다.
/// 정본 응답은 204이며 본문이 없습니다.
///
/// **주의**: 이 UseCase는 백엔드 계정 삭제만 담당합니다.
/// 로컬 정리(Firebase signOut, 토큰 삭제)는 Presentation 레이어에서
/// 탈퇴 성공 후 별도로 수행합니다.
///
/// **에러 케이스**:
/// - 401: 인증 실패 (AuthInterceptor가 자동 처리)
/// - 404: 존재하지 않는 회원
class DeleteAccountUseCase {
  final UserRepository _repository;

  DeleteAccountUseCase({required UserRepository repository})
    : _repository = repository;

  /// 회원 탈퇴 실행
  ///
  /// Throws: [ServerException], [NetworkException]
  Future<void> execute() async {
    await _repository.deleteAccount();
  }
}
