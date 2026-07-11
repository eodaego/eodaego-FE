import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/spacing_and_radius.dart';
import '../constants/text_styles.dart';

/// 버튼 내 아이콘 위치 (텍스트 기준 왼쪽/오른쪽).
enum IconPosition { leading, trailing }

/// 앱 전역 공용 버튼.
///
/// **기본(채움) 스펙**: 353x56, radius 16, 배경 [AppColors.primary],
/// 텍스트/아이콘 [AppColors.onPrimary], 테두리 없음, [AppTextStyles.label16Semibold].
/// **비활성**(`onPressed == null` 또는 `isLoading`): 배경 [AppColors.uncollected].
///
/// 소셜/변형은 **팩토리 프리셋**([AppButton.google], [AppButton.apple])으로 확장한다.
/// (프로젝트 규칙: 별도 버튼 위젯을 만들지 않고 프리셋으로 통일한다.)
///
/// ```dart
/// AppButton(text: '시작하기', onPressed: () {});
/// AppButton.google(onPressed: () => signInWithGoogle());
/// AppButton.apple(onPressed: () => signInWithApple(), isLoading: loading);
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.showBorder = false,
    this.borderWidth = 1.0,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.isLoading = false,
    this.subtitle,
    this.subtitleColor,
    this.contentAlignment,
    this.textStyle,
  });

  /// Google 로그인 프리셋 — 흰 배경 + ink 텍스트 + 테두리 + 구글 아이콘(원색 유지).
  factory AppButton.google({
    Key? key,
    required VoidCallback? onPressed,
    String text = 'Google로 시작하기',
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.ink,
      showBorder: true,
      icon: SvgPicture.asset(
        'assets/icons/icon_google.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  /// Apple 로그인 프리셋 — ink 배경 + 흰 텍스트 + 애플 아이콘(흰색 틴트).
  factory AppButton.apple({
    Key? key,
    required VoidCallback? onPressed,
    String text = 'Apple로 시작하기',
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.ink,
      foregroundColor: AppColors.onPrimary,
      icon: SvgPicture.asset(
        'assets/icons/icon_apple.svg',
        width: 20.w,
        height: 20.w,
        colorFilter: const ColorFilter.mode(
          AppColors.onPrimary,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  /// 보상 노랑 CTA 프리셋 — 홈 '코스 보러 가기'·축하 화면 전용.
  /// (노랑 사용 허용 위치는 이 두 곳뿐 — UI_Design_System.md)
  factory AppButton.reward({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.reward,
      foregroundColor: AppColors.rewardDark,
      textStyle: AppTextStyles.display17,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  /// 버튼 텍스트 (필수).
  final String text;

  /// 클릭 핸들러 (필수, null이면 비활성화).
  final VoidCallback? onPressed;

  /// 활성 배경색 (기본: [AppColors.primary]).
  final Color? backgroundColor;

  /// 활성 텍스트/아이콘 색 (기본: [AppColors.onPrimary]).
  final Color? foregroundColor;

  /// 비활성 배경색 (기본: [AppColors.uncollected]).
  final Color? disabledBackgroundColor;

  /// 비활성 텍스트/아이콘 색 (기본: [AppColors.onPrimary]).
  final Color? disabledForegroundColor;

  /// 테두리 표시 여부 (기본: false — 채움 버튼은 테두리 불필요).
  final bool showBorder;

  /// 테두리 두께 (기본: 1.0).
  final double borderWidth;

  /// 활성 테두리 색 (기본: [AppColors.line]).
  final Color? borderColor;

  /// 버튼 너비 (기본: 353.w).
  final double? width;

  /// 버튼 높이 (기본: 56.h).
  final double? height;

  /// 모서리 반경 (기본: 16.r).
  final BorderRadius? borderRadius;

  /// 아이콘 위젯 (선택).
  final Widget? icon;

  /// 아이콘 위치 (기본: leading).
  final IconPosition iconPosition;

  /// 로딩 상태 (true면 스피너 표시 + 비활성).
  final bool isLoading;

  /// 서브 텍스트 (선택, 메인 텍스트 아래 caption14).
  final String? subtitle;

  /// 서브 텍스트 색 (기본: 메인 텍스트 색).
  final Color? subtitleColor;

  /// 내용 정렬 (기본: center).
  final MainAxisAlignment? contentAlignment;

  /// 텍스트 스타일 오버라이드 (기본: [AppTextStyles.label16Semibold]).
  final TextStyle? textStyle;

  bool get _disabled => isLoading || onPressed == null;

  Color get _effectiveBackgroundColor => _disabled
      ? (disabledBackgroundColor ?? AppColors.uncollected)
      : (backgroundColor ?? AppColors.primary);

  Color get _effectiveForegroundColor => _disabled
      ? (disabledForegroundColor ?? AppColors.onPrimary)
      : (foregroundColor ?? AppColors.onPrimary);

  Color get _effectiveBorderColor =>
      _disabled ? AppColors.transparent : (borderColor ?? AppColors.line);

  double get _effectiveWidth => width ?? 353.w;

  double get _effectiveHeight => height ?? 56.h;

  BorderRadius get _effectiveBorderRadius =>
      borderRadius ?? BorderRadius.circular(AppRadius.md.r);

  MainAxisAlignment get _effectiveContentAlignment =>
      contentAlignment ?? MainAxisAlignment.center;

  Color get _effectiveSubtitleColor =>
      subtitleColor ?? _effectiveForegroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _effectiveWidth,
      height: _effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: _effectiveBorderRadius,
        border: showBorder
            ? Border.all(color: _effectiveBorderColor, width: borderWidth)
            : null,
      ),
      child: ElevatedButton(
        onPressed: _disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(_effectiveWidth, _effectiveHeight),
          backgroundColor: _effectiveBackgroundColor,
          foregroundColor: _effectiveForegroundColor,
          disabledBackgroundColor:
              disabledBackgroundColor ?? AppColors.uncollected,
          disabledForegroundColor:
              disabledForegroundColor ?? AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: _effectiveBorderRadius),
          padding: EdgeInsets.zero,
          elevation: 0,
          shadowColor: AppColors.transparent,
        ),
        child: isLoading ? _buildLoadingIndicator() : _buildButtonContent(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 20.w,
      height: 20.w,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(_effectiveForegroundColor),
      ),
    );
  }

  Widget _buildButtonContent() {
    final Widget textWidget;
    if (subtitle == null) {
      textWidget = Text(
        text,
        style: (textStyle ?? AppTextStyles.label16Semibold).copyWith(
          color: _effectiveForegroundColor,
        ),
      );
    } else {
      textWidget = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: (textStyle ?? AppTextStyles.label16Semibold).copyWith(
              color: _effectiveForegroundColor,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            subtitle!,
            style: AppTextStyles.caption14.copyWith(
              color: _effectiveSubtitleColor,
            ),
          ),
        ],
      );
    }

    if (icon == null) return textWidget;

    final isSpaceBetween =
        _effectiveContentAlignment == MainAxisAlignment.spaceBetween;
    final gap = SizedBox(width: AppSpacing.sm.w);

    return Row(
      mainAxisAlignment: _effectiveContentAlignment,
      mainAxisSize: MainAxisSize.max,
      children: iconPosition == IconPosition.trailing
          ? [textWidget, if (!isSpaceBetween) gap, icon!]
          : [icon!, if (!isSpaceBetween) gap, textWidget],
    );
  }
}
