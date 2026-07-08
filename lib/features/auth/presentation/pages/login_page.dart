import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/network/dio_client.dart';
import '../providers/auth_provider.dart';

/// 강제 로그아웃 사유 키 → 한국어 (i18n 미포팅 대체).
String _forceLogoutMessage(String key) {
  switch (key) {
    case 'errorAuthExpired':
      return '세션이 만료되었어요. 다시 로그인해 주세요.';
    case 'errorTemporaryRetry':
      return '일시적인 오류가 발생했어요. 다시 시도해 주세요.';
    default:
      return '다시 로그인해 주세요.';
  }
}

/// TODO: 어대GO 로그인 디자인 (Google/Apple 소셜 버튼 프리셋).
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 강제 로그아웃 사유 1회 소비 → 스낵바
    ref.listen(loginNoticeKeyProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_forceLogoutMessage(next))),
        );
        ref.read(loginNoticeKeyProvider.notifier).state = null;
      }
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
