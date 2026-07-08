import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

/// 스플래시. redirect가 authState에 따라 자동 이동하므로 로딩만 표시.
/// TODO: 어대GO 스플래시 디자인 + 오프라인 재시도 로직.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  // TODO(eodaego): 버전 게이트 배선 — AppVersionChecker.check()
  //   → UpdateDialogHelper.handleResult(context, result) 로 /maintenance·/force-update 유도.
  //   (initialize()는 main.dart 부팅 시퀀스에서 배선됨. check→라우팅만 미배선.)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(child: Text('어대GO', style: AppTextStyles.display34)),
    );
  }
}
