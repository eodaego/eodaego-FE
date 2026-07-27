import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/pages/legal_document_page.dart';
import '../../domain/entities/agreement_status_entity.dart';
import '../providers/user_provider.dart';

/// 약관 및 정책 (마이페이지 → 약관 다시 보기).
///
/// 필수 3종은 전문 열람만 제공한다 — 철회는 곧 탈퇴이고, 탈퇴 경로는
/// 마이페이지에 따로 있다. 마케팅만 토글로 즉시 저장한다.
class AgreementsPage extends ConsumerStatefulWidget {
  const AgreementsPage({super.key});

  @override
  ConsumerState<AgreementsPage> createState() => _AgreementsPageState();
}

class _AgreementsPageState extends ConsumerState<AgreementsPage> {
  AgreementStatusEntity? _status;
  bool _isLoading = true;
  bool _hasError = false;

  /// 마케팅 토글 저장 진행 중 — 연타로 요청이 겹치지 않게 한다.
  bool _isSavingMarketing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final status = await ref.read(userRepositoryProvider).getAgreements();
      if (!mounted) return;
      setState(() {
        _status = status;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  /// 낙관적 업데이트 — 먼저 켜고, 실패하면 되돌린다.
  Future<void> _toggleMarketing(bool value) async {
    final previous = _status;
    if (previous == null || _isSavingMarketing) return;

    setState(() {
      _status = previous.copyWith(marketing: value);
      _isSavingMarketing = true;
    });

    try {
      await ref
          .read(userRepositoryProvider)
          .updateAgreements(marketing: value);
      if (!mounted) return;
      setState(() => _isSavingMarketing = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = previous;
        _isSavingMarketing = false;
      });
      AppSnackbar.show(
        context,
        message: '잠시 후 다시 시도해 주세요',
        backgroundColor: AppColors.danger,
        bottomOffset: 40,
      );
    }
  }

  void _openLegal({
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

  /// ISO-8601 문자열을 `2026.07.12 동의`로 바꾼다. 파싱 실패 시 null.
  String? _agreedLabel(String? iso) {
    if (iso == null) return null;
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return null;
    final d = parsed.toLocal();
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}.$month.$day 동의';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '약관 및 정책'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _status == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '약관을 불러오지 못했어요',
              style: AppTextStyles.body15.copyWith(color: AppColors.muted),
            ),
            SizedBox(height: AppSpacing.md.h),
            TextButton(onPressed: _load, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    final status = _status!;
    final requiredLabel = _agreedLabel(status.termsAgreedAt);

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.lg.h,
      ),
      children: [
        _LegalRow(
          label: '서비스 이용약관',
          agreedLabel: requiredLabel,
          onTap: () => _openLegal(
            title: '이용약관',
            assetPath: 'assets/legals/terms_of_service.json',
            url: AppUrls.termsOfService,
          ),
        ),
        _LegalRow(
          label: '개인정보 처리방침',
          agreedLabel: requiredLabel,
          onTap: () => _openLegal(
            title: '개인정보처리방침',
            assetPath: 'assets/legals/privacy_policy.json',
            url: AppUrls.privacyPolicy,
          ),
        ),
        _LegalRow(
          label: '위치기반 서비스 약관',
          agreedLabel: requiredLabel,
          onTap: () => _openLegal(
            title: '위치정보 이용약관',
            assetPath: 'assets/legals/location_terms.json',
            url: AppUrls.locationTerms,
          ),
        ),
        Divider(color: AppColors.line, height: AppSpacing.lg.h),
        _LegalRow(
          label: '마케팅 정보 수신',
          agreedLabel: _agreedLabel(status.marketingAgreedAt),
          // 마케팅 원문 웹 URL(AppUrls.marketingConsent)은 아직 자리표시자라
          // 넘기지 않는다 — 확정되면 url 인자만 추가하면 된다.
          onTap: () => _openLegal(
            title: '마케팅 정보 수신 동의',
            assetPath: 'assets/legals/marketing_consent.json',
          ),
          trailing: Switch(
            value: status.marketing,
            // 비활성화된 Switch는 제스처를 흡수하지 못해 탭이 조상 InkWell로
            // 새어나간다(전문 열림). _toggleMarketing 내부의 _isSavingMarketing
            // 가드가 이미 재진입을 막으므로 여기서 다시 비활성화할 필요는 없다.
            onChanged: _toggleMarketing,
            activeTrackColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

/// 약관 한 줄 — 라벨 + 동의 일시 + 오른쪽 위젯(기본은 `>`).
class _LegalRow extends StatelessWidget {
  const _LegalRow({
    required this.label,
    required this.onTap,
    this.agreedLabel,
    this.trailing,
  });

  final String label;
  final VoidCallback onTap;
  final String? agreedLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 56.h),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.body15.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                    if (agreedLabel != null) ...[
                      SizedBox(height: AppSpacing.xs.h),
                      Text(
                        agreedLabel!,
                        style: AppTextStyles.caption14.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.muted,
                    size: 24.w,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
