import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

/// 스플래시. redirect가 authState에 따라 자동 이동하므로 로딩만 표시.
/// TODO: 어대GO 스플래시 디자인 + 오프라인 재시도 로직.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: Text('어대GO', style: AppTextStyles.display34),
      ),
    );
  }
}
