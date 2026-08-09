import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/pages/legal_document_page.dart';
import '../providers/agreement_provider.dart';
import '../providers/auth_provider.dart';

/// 약관 동의 화면 — 필수 3종 + 선택 1종.
///
/// 각 행의 `>`를 누르면 [LegalDocumentPage]로 약관 전문이 열린다.
class AgreementPage extends ConsumerWidget {
  const AgreementPage({super.key});

  /// [url]이 null이면 전문 페이지에 "웹에서 보기"가 노출되지 않는다.
  void _openLegal(
    BuildContext context, {
    required String title,
    required String assetPath,
    String? url,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LegalDocumentPage(
          title: title,
          assetPath: assetPath,
          externalUrl: url,
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(agreementNotifierProvider.notifier).submit();
    if (result == AgreementSubmitResult.success) {
      await ref.read(authNotifierProvider.notifier).markAgreementCompleted();
      return;
    }
    if (!context.mounted) return;
    AppSnackbar.show(
      context,
      message: result == AgreementSubmitResult.offline
          ? '네트워크 연결을 확인해 주세요'
          : '잠시 후 다시 시도해 주세요',
      backgroundColor: AppColors.danger,
      bottomOffset: 40,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // autoDispose provider가 제출(비동기) 중 dispose되지 않도록 구독을 유지한다.
    final state = ref.watch(agreementNotifierProvider);
    final notifier = ref.read(agreementNotifierProvider.notifier);
    final busy = state.isLoading || state.isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목은 화면 최상단 고정. 중앙 정렬 대상은 아래 약관 목록뿐이다.
              // 노치/상태바에서 충분히 떨어뜨리려 스케일 내에서 32+32로 띄운다.
              SizedBox(height: (AppSpacing.xxl * 2).h),
              Text(
                '약관에 동의하면\n바로 시작할 수 있어요',
                style: AppTextStyles.display24.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                '꼭 동의해야 하는 항목이 있어요',
                style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
              const Spacer(),
              _AgreeAllRow(
                checked: state.allAgreed,
                onToggle: () => notifier.toggleAll(!state.allAgreed),
              ),
              _rowDivider,
              _AgreementRow(
                label: '서비스 이용약관',
                isRequired: true,
                checked: state.termsOfService,
                onToggle: notifier.toggleTerms,
                onOpenDocument: () => _openLegal(
                  context,
                  title: '이용약관',
                  assetPath: AppAssets.termsOfService,
                  url: AppUrls.termsOfService,
                ),
              ),
              _AgreementRow(
                label: '개인정보 처리방침',
                isRequired: true,
                checked: state.privacyPolicy,
                onToggle: notifier.togglePrivacy,
                onOpenDocument: () => _openLegal(
                  context,
                  title: '개인정보처리방침',
                  assetPath: AppAssets.privacyPolicy,
                  url: AppUrls.privacyPolicy,
                ),
              ),
              _AgreementRow(
                label: '위치기반 서비스 약관',
                isRequired: true,
                checked: state.locationTerms,
                onToggle: notifier.toggleLocation,
                onOpenDocument: () => _openLegal(
                  context,
                  title: '위치정보 이용약관',
                  assetPath: AppAssets.locationTerms,
                  url: AppUrls.locationTerms,
                ),
              ),
              _AgreementRow(
                label: '마케팅 정보 받기',
                isRequired: false,
                checked: state.marketing,
                onToggle: notifier.toggleMarketing,
                // 웹 원문 URL(AppUrls.marketingConsent)은 아직 TODO 자리표시자라
                // 넘기지 않는다 — 확정되면 url 인자만 추가하면 된다.
                onOpenDocument: () => _openLegal(
                  context,
                  title: '마케팅 정보 수신 동의',
                  assetPath: AppAssets.marketingConsent,
                ),
              ),
              const Spacer(),
              AppButton(
                text: '동의하고 시작하기',
                onPressed: state.hasAllRequired && !busy
                    ? () => _submit(context, ref)
                    : null,
                isLoading: state.isSubmitting,
              ),
              SizedBox(height: AppSpacing.lg.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// 전체 동의와 개별 약관 목록을 가르는 구분선.
/// 행 높이(48)를 잠식하지 않도록 height 1로 고정.
const _rowDivider = Divider(height: 1, thickness: 1, color: AppColors.line);

/// 전체 동의 행 — 개별 행보다 크게 잡아 한 번에 누르기 쉽게 한다.
///
/// 선택 항목(마케팅)까지 함께 토글되므로 보조 문구로 명시한다.
class _AgreeAllRow extends StatelessWidget {
  const _AgreeAllRow({required this.checked, required this.onToggle});

  final bool checked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.base.h),
        child: Row(
          children: [
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              size: 28.w,
              color: checked ? AppColors.primary : AppColors.uncollected,
            ),
            SizedBox(width: AppSpacing.sm.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '전체 동의하기',
                    style: AppTextStyles.label16Semibold.copyWith(
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    '선택 항목까지 모두 동의해요',
                    style: AppTextStyles.caption14.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 약관 한 줄 — 왼쪽(체크+라벨) 탭은 동의 토글, 오른쪽 `>` 탭은 전문 열기.
class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.label,
    required this.isRequired,
    required this.checked,
    required this.onToggle,
    required this.onOpenDocument,
  });

  final String label;
  final bool isRequired;
  final bool checked;
  final VoidCallback onToggle;

  /// `>` 탭 시 약관 전문 페이지를 연다.
  final VoidCallback onOpenDocument;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppRadius.sm.r),
            child: Padding(
              // 24(아이콘) + 12*2 = 48 — 최소 터치 타깃 충족.
              // 좌측 패딩 0: 체크 아이콘을 화면 패딩(20) 기준으로 제목과 정렬.
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
              child: Row(
                children: [
                  Icon(
                    checked
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 24.w,
                    color: checked ? AppColors.primary : AppColors.uncollected,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: AppTextStyles.body15.copyWith(
                          color: AppColors.ink,
                        ),
                        children: [
                          TextSpan(
                            text: isRequired ? '[필수] ' : '[선택] ',
                            style: AppTextStyles.body15.copyWith(
                              color: isRequired
                                  ? AppColors.primaryDark
                                  : AppColors.muted,
                            ),
                          ),
                          TextSpan(text: label),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onOpenDocument,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: SizedBox(
            width: 48.w,
            height: 48.w,
            child: Center(
              child: Icon(
                Icons.chevron_right_rounded,
                size: 24.w,
                color: AppColors.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
