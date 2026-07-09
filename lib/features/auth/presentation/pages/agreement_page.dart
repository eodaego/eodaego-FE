import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../providers/agreement_provider.dart';
import '../providers/auth_provider.dart';

/// TODO: 어대GO 약관 동의 디자인 (agreement 위젯 재사용).
class AgreementPage extends ConsumerWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agreementNotifierProvider);
    final notifier = ref.read(agreementNotifierProvider.notifier);

    Widget row(String label, bool value, VoidCallback onTap) =>
        CheckboxListTile(
          value: value,
          onChanged: (_) => onTap(),
          title: Text(label, style: AppTextStyles.body15),
        );

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text('약관에 동의해 주세요', style: AppTextStyles.display24),
            row('[필수] 서비스 이용약관', state.termsOfService, notifier.toggleTerms),
            row('[필수] 개인정보 처리방침', state.privacyPolicy, notifier.togglePrivacy),
            row(
              '[필수] 위치기반 서비스 약관',
              state.locationTerms,
              notifier.toggleLocation,
            ),
            row('[선택] 마케팅 수신 동의', state.marketing, notifier.toggleMarketing),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: state.hasAllRequired && !state.isSubmitting
                    ? () async {
                        final result = await notifier.submit();
                        if (result == AgreementSubmitResult.success) {
                          ref
                              .read(authNotifierProvider.notifier)
                              .markAgreementCompleted();
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('잠시 후 다시 시도해 주세요.')),
                          );
                        }
                      }
                    : null,
                child: Text('동의하고 시작하기', style: AppTextStyles.label16Semibold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
