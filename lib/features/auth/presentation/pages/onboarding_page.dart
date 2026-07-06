import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../router/route_paths.dart';

/// TODO: 어대GO 온보딩 (smooth_page_indicator 캐러셀).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('어대GO에 오신 걸 환영해요', style: AppTextStyles.display24),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.login),
              child: Text('시작하기', style: AppTextStyles.label16Semibold),
            ),
          ],
        ),
      ),
    );
  }
}
