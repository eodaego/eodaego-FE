import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_urls.dart';
import '../../constants/text_styles.dart';
import '../../utils/url_launcher_util.dart';

/// 강제 업데이트 안내. TODO: 어대GO 디자인 + AppButton 프리셋으로 교체.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

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
                Text('업데이트가 필요해요', style: AppTextStyles.display24),
                const SizedBox(height: 12),
                Text(
                  '원활한 이용을 위해\n최신 버전으로 업데이트해 주세요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => launchExternalUrl(AppUrls.storeUrl),
                  child: Text('지금 업데이트',
                      style: AppTextStyles.label16Semibold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
