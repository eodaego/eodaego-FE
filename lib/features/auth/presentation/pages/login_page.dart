import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/pages/legal_document_page.dart';
import '../../../../router/route_paths.dart';
import '../providers/auth_provider.dart';

/// 로그인 화면 안내 키 → (문구, 색). 순수 함수 — 위젯 없이 단위 테스트 가능.
({String message, Color color}) loginNoticeFor(String key) {
  switch (key) {
    case 'logoutSuccess':
      return (message: '로그아웃되었습니다', color: AppColors.ink);
    case 'logoutUnexpected':
      return (message: '로그아웃 중 문제가 있었어요', color: AppColors.danger);
    case 'errorAuthExpired':
      return (message: '세션이 만료되었어요. 다시 로그인해 주세요.', color: AppColors.danger);
    case 'errorTemporaryRetry':
      return (message: '일시적인 오류가 발생했어요. 다시 시도해 주세요.', color: AppColors.danger);
    case 'loginFailed':
      return (message: '로그인에 실패했어요. 잠시 후 다시 시도해 주세요.', color: AppColors.danger);
    default:
      return (message: '다시 로그인해 주세요.', color: AppColors.ink);
  }
}

/// 로그인 화면 — 소셜 로그인 버튼(하단 고정) + 약관 동의 안내.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _locationRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => _openLegal(
        '개인정보처리방침',
        'assets/legals/privacy_policy.json',
        AppUrls.privacyPolicy,
      );
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => _openLegal(
        '이용약관',
        'assets/legals/terms_of_service.json',
        AppUrls.termsOfService,
      );
    _locationRecognizer = TapGestureRecognizer()
      ..onTap = () => _openLegal(
        '위치정보 이용약관',
        'assets/legals/location_terms.json',
        AppUrls.locationTerms,
      );

    // 로그아웃 리다이렉트 등, 진입 시점에 이미 대기 중인 안내 키를 1회 소비.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = ref.read(loginNoticeKeyProvider);
      if (key != null) _showNotice(key);
    });
  }

  @override
  void dispose() {
    _privacyRecognizer.dispose();
    _termsRecognizer.dispose();
    _locationRecognizer.dispose();
    super.dispose();
  }

  /// 안내 키 → AppSnackbar 표시 후 키 소비(null).
  void _showNotice(String key) {
    final notice = loginNoticeFor(key);
    AppSnackbar.show(
      context,
      message: notice.message,
      backgroundColor: notice.color,
      bottomOffset: 40,
    );
    ref.read(loginNoticeKeyProvider.notifier).state = null;
  }

  void _openLegal(String title, String assetPath, String url) {
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

  Future<void> _handleGoogleSignIn() async {
    // 게스트 상태에서 실로그인 시 플래그 잔존 방지 (스펙 §3)
    ref.read(guestModeProvider.notifier).state = false;
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle();
      // 성공 시 네비게이션은 GoRouter redirect가 처리. 취소/실패는 notifier가
      // loginNoticeKey를 설정 → ref.listen → 스낵바. (여기서 예외를 던지지 않음)
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    // 게스트 상태에서 실로그인 시 플래그 잔존 방지 (스펙 §3)
    ref.read(guestModeProvider.notifier).state = false;
    setState(() => _isAppleLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).signInWithApple();
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로그인 화면에 머무는 중 발생한 안내(예: 로그인 실패)를 즉시 소비.
    ref.listen(loginNoticeKeyProvider, (prev, next) {
      if (next != null) _showNotice(next);
    });
    // async 로그인(401 재발급 등) 동안 provider가 dispose되지 않도록 구독 유지.
    ref.watch(authNotifierProvider);

    final busy = _isGoogleLoading || _isAppleLoading;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      // SafeArea 하단 인셋 = 안드로이드 시스템 내비게이션 바 높이만큼 자동 확보.
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text('어대GO', style: AppTextStyles.display34),
              SizedBox(height: AppSpacing.md.h),
              Text(
                '어린이대공원을 탐험하고 도감을 모아요',
                style: AppTextStyles.body15.copyWith(color: AppColors.muted),
              ),
              const Spacer(flex: 4),

              // 소셜 로그인 버튼 — 하단 고정
              AppButton.google(
                onPressed: busy ? null : _handleGoogleSignIn,
                isLoading: _isGoogleLoading,
              ),
              if (Platform.isIOS) ...[
                SizedBox(height: AppSpacing.md.h),
                AppButton.apple(
                  onPressed: busy ? null : _handleAppleSignIn,
                  isLoading: _isAppleLoading,
                ),
              ],

              SizedBox(height: AppSpacing.md.h),
              _buildGuestButton(busy),
              SizedBox(height: AppSpacing.md.h),
              _buildAgreement(),
              SizedBox(height: AppSpacing.md.h),
            ],
          ),
        ),
      ),
    );
  }

  /// 게스트 둘러보기 진입 — 로그인 없이 목 UI 열람 (핵심 액션은 게이트).
  Widget _buildGuestButton(bool busy) {
    return InkWell(
      onTap: busy
          ? null
          : () {
              ref.read(guestModeProvider.notifier).state = true;
              context.go(RoutePaths.home);
            },
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h),
        child: Center(
          child: Text(
            '게스트로 둘러보기',
            style: AppTextStyles.caption14.copyWith(
              color: AppColors.muted,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  /// 약관 동의 안내 — 각 링크 탭 시 [LegalDocumentPage]로 이동.
  Widget _buildAgreement() {
    final linkStyle = AppTextStyles.caption14.copyWith(
      color: AppColors.ink,
      decoration: TextDecoration.underline,
    );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
        children: [
          const TextSpan(text: '가입을 진행하면 '),
          TextSpan(
            text: '개인정보처리방침',
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(text: ', '),
          TextSpan(
            text: '이용약관',
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          const TextSpan(text: ', '),
          TextSpan(
            text: '위치정보 이용약관',
            style: linkStyle,
            recognizer: _locationRecognizer,
          ),
          const TextSpan(text: '에 동의하게 됩니다.'),
        ],
      ),
    );
  }
}
