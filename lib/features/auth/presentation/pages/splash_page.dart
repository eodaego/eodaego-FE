import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

/// 스플래시. redirect가 authState에 따라 자동 이동하므로 로딩만 표시.
/// TODO: 어대GO 스플래시 디자인 + 오프라인 재시도 로직.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  // TODO(eodaego): Firebase Remote Config(어대GO 프로젝트) 설정 확정 후 스플래시에서 버전 체크 배선.
  //   RemoteConfigService.instance.initialize() → AppVersionChecker.check()
  //   → UpdateDialogHelper.handleResult(context, result) 로 /maintenance·/force-update 유도.
  //   (services는 lib/core/services/remote_config/ 에 포팅 완료, 호출부만 미배선.)

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
