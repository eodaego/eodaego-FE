import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

/// canvas 배경 + back 버튼 공용 앱바 (루트 push 화면용).
class AppBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBackAppBar({super.key, required this.title, this.onBack});

  final String title;

  /// 기본은 pop. 위저드처럼 자체 back 처리가 필요하면 오버라이드.
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.canvas,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: onBack ?? () => context.pop(),
        tooltip: '뒤로',
        icon: const Icon(Icons.arrow_back, color: AppColors.ink),
      ),
      title: Text(
        title,
        style: AppTextStyles.display19.copyWith(color: AppColors.ink),
      ),
    );
  }
}
