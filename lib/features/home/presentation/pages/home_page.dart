import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 임시 홈. TODO: 어대GO 홈(도감/지도/카메라) 구현으로 교체.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('어대GO', style: AppTextStyles.display26),
            const SizedBox(height: 12),
            Text(
              '환영합니다 ${user?.nickname ?? ''}',
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () =>
                  ref.read(authNotifierProvider.notifier).signOut(),
              child: Text(
                '로그아웃',
                style: AppTextStyles.label16Semibold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
