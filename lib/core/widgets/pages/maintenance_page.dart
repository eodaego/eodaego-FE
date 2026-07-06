import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';

/// 서버 점검 안내. TODO: 어대GO 점검 화면 디자인으로 교체.
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('잠시 점검 중이에요', style: AppTextStyles.display24),
                const SizedBox(height: 12),
                Text(
                  '더 나은 서비스를 위해 점검하고 있어요.\n잠시 후 다시 시도해 주세요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
