import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/auth_provider.dart';

/// 로그인 화면 안내 키 → (문구, 색). 순수 함수 — 위젯 없이 단위 테스트 가능.
({String message, Color color}) loginNoticeFor(String key) {
  switch (key) {
    case 'logoutSuccess':
      return (message: '로그아웃되었습니다', color: AppColors.ink);
    case 'logoutUnexpected':
      return (message: '로그아웃 중 문제가 있었어요', color: AppColors.danger);
    case 'errorAuthExpired':
      return (message: '세션이 만료되었어요. 다시 로그인해 주세요.', color: AppColors.danger);
    case 'errorTemporaryRetry':
      return (message: '일시적인 오류가 발생했어요. 다시 시도해 주세요.', color: AppColors.danger);
    case 'loginFailed':
      return (message: '로그인에 실패했어요. 잠시 후 다시 시도해 주세요.', color: AppColors.danger);
    default:
      return (message: '다시 로그인해 주세요.', color: AppColors.ink);
  }
}

/// TODO: 어대GO 로그인 디자인 (Google/Apple 소셜 버튼 프리셋).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    // 로그아웃 리다이렉트 등, 화면 진입 시점에 이미 대기 중인 안내 키를 1회 소비.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = ref.read(loginNoticeKeyProvider);
      if (key != null) _showNotice(key);
    });
  }

  /// 안내 키 → AppSnackbar 표시 후 키 소비(null).
  void _showNotice(String key) {
    final notice = loginNoticeFor(key);
    AppSnackbar.show(
      context,
      message: notice.message,
      backgroundColor: notice.color,
      bottomOffset: 40,
    );
    ref.read(loginNoticeKeyProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    // 로그인 화면에 머무는 중 발생한 안내(예: 로그인 실패)를 즉시 소비.
    ref.listen(loginNoticeKeyProvider, (prev, next) {
      if (next != null) _showNotice(next);
    });

    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final notifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('어대GO', style: AppTextStyles.display34),
                  const SizedBox(height: 32),
                  // TODO: AppButton 소셜 프리셋으로 교체
                  ElevatedButton(
                    onPressed: () => notifier.signInWithGoogle(),
                    child: Text('Google로 시작하기',
                        style: AppTextStyles.label16Semibold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => notifier.signInWithApple(),
                    child: Text('Apple로 시작하기',
                        style: AppTextStyles.label16Semibold),
                  ),
                ],
              ),
      ),
    );
  }
}
