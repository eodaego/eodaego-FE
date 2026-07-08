import 'package:eodaego/core/constants/app_colors.dart';
import 'package:eodaego/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('loginNoticeFor', () {
    test('logoutSuccess → 성공 문구 + ink', () {
      final n = loginNoticeFor('logoutSuccess');
      expect(n.message, '로그아웃되었습니다');
      expect(n.color, AppColors.ink);
    });

    test('logoutUnexpected → 오류 문구 + danger', () {
      final n = loginNoticeFor('logoutUnexpected');
      expect(n.message, '로그아웃 중 문제가 있었어요');
      expect(n.color, AppColors.danger);
    });

    test('errorAuthExpired → 세션 만료 + danger', () {
      final n = loginNoticeFor('errorAuthExpired');
      expect(n.color, AppColors.danger);
    });

    test('알 수 없는 키 → 기본 문구 + ink', () {
      final n = loginNoticeFor('unknown-key');
      expect(n.message, '다시 로그인해 주세요.');
      expect(n.color, AppColors.ink);
    });
  });
}
