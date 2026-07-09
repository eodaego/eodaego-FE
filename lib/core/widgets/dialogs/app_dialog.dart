import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../constants/spacing_and_radius.dart';
import '../../constants/text_styles.dart';
import 'dialog_animation.dart';
import 'dialog_spacing.dart';

/// 앱 전역에서 사용하는 공용 다이얼로그 컴포넌트
///
/// **기본 스펙**:
/// - 배경: white, 모서리: 32px 라운드
/// - 양옆 마진: 32px (화면 너비에 맞게 확장)
/// - 애니메이션: 스케일 + 페이드 (250ms, easeOutBack)
///
/// **버튼 모드 3가지**:
/// 1. 2버튼 (취소+확인): `cancelText`를 지정하면 취소 버튼 표시
/// 2. 1버튼 (확인만): `cancelText` 미지정 (기본값)
/// 3. 무버튼: `showButtons: false` (타이머, 공지 등에서 사용)
///
/// **유효성 검증 + shake 애니메이션**:
/// `validator`를 지정하면 확인 버튼 탭 시 validator 실행.
/// false 반환 시 다이얼로그를 닫지 않고 흔들림 애니메이션으로 피드백.
///
/// **사용 예시**:
/// ```dart
/// // 기본 확인 다이얼로그 (1버튼)
/// AppDialog.show(
///   context: context,
///   title: '알림',
///   message: '저장이 완료되었어요',
/// );
///
/// // 확인/취소 다이얼로그 (2버튼)
/// AppDialog.show(
///   context: context,
///   title: '삭제할까요?',
///   message: '이 항목을 삭제합니다',
///   cancelText: '취소',
///   onConfirm: () => delete(),
/// );
///
/// // validator + shake (6자리 코드 검증)
/// AppDialog.show(
///   context: context,
///   title: '코드 입력',
///   customContent: AppTextField(controller: ctrl, maxLength: 6),
///   cancelText: '취소',
///   confirmText: '확인',
///   validator: () => ctrl.text.trim().length == 6,
///   onConfirm: () => submitCode(ctrl.text.trim()),
/// );
///
/// // spacing 커스터마이징 (특정 다이얼로그만 간격 조절)
/// AppDialog.show(
///   context: context,
///   title: '안내',
///   spacing: DialogSpacing(toContent: AppSpacing.md.h),
///   customContent: Column(...),
/// );
///
/// // 간편 확인 (bool 반환)
/// final result = await AppDialog.confirm(
///   context: context,
///   title: '삭제할까요?',
///   message: '삭제하면 되돌릴 수 없어요',
///   isDestructive: true,
/// );
/// if (result == true) { /* 삭제 */ }
/// ```
class AppDialog extends StatefulWidget {
  const AppDialog({
    super.key,
    this.title,
    this.message,
    required this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.showButtons = true,
    this.customContent,
    this.showAvatar = false,
    this.avatarWidget,
    this.nickname,
    this.confirmColor,
    this.confirmTextColor,
    this.cancelColor,
    this.cancelTextColor,
    this.titleStyle,
    this.spacing,
    this.backgroundColor,
    this.isDarkMode = false,
  });

  /// 제목 (선택) - display19, ink. null이면 제목 영역 숨김
  final String? title;

  /// 메시지 (선택) - body15, muted
  final String? message;

  /// 확인 버튼 텍스트 (기본: '확인')
  final String confirmText;

  /// 취소 버튼 텍스트 (null이면 취소 버튼 없음)
  final String? cancelText;

  /// 확인 콜백
  final VoidCallback? onConfirm;

  /// 취소 콜백
  final VoidCallback? onCancel;

  /// 위험 액션 여부 (true면 확인 버튼 빨간색)
  final bool isDestructive;

  /// 버튼 표시 여부 (false면 버튼 영역 전체 숨김)
  final bool showButtons;

  /// 커스텀 콘텐츠 (message 대신 또는 추가로 사용)
  final Widget? customContent;

  /// 아바타 표시 여부 (기본: false, 컬렉션 아이템 확인 등 특정 상황에서만 사용)
  final bool showAvatar;

  /// 아바타 위젯 (showAvatar가 true일 때 표시)
  final Widget? avatarWidget;

  /// 닉네임/라벨 (showAvatar가 true일 때 아바타 아래 표시)
  final String? nickname;

  /// 확인 버튼 배경색 (미지정 시 isDestructive ? danger : ink)
  final Color? confirmColor;

  /// 확인 버튼 텍스트색 (미지정 시 surface)
  final Color? confirmTextColor;

  /// 취소 버튼 배경색 (미지정 시 surfaceDim)
  final Color? cancelColor;

  /// 취소 버튼 텍스트색 (미지정 시 muted)
  final Color? cancelTextColor;

  /// 제목 스타일 오버라이드 (미지정 시 display19, ink)
  final TextStyle? titleStyle;

  /// 다이얼로그 내부 섹션 간 간격 오버라이드 (미지정 시 기본값 적용)
  final DialogSpacing? spacing;

  /// 다이얼로그 배경색 (미지정 시 AppColors.surface)
  final Color? backgroundColor;

  /// 다크 배경 다이얼로그 여부
  ///
  /// true일 때 명시적 색상 미지정 시:
  /// - 배경: ink, 제목/확인텍스트: surface
  /// - confirm: primary(초록) 배경
  /// - cancel: ink 배경, disabled 텍스트
  final bool isDarkMode;

  // ============================================
  // 정적 메서드
  // ============================================

  /// showGeneralDialog 공용 래퍼
  ///
  /// [show]와 [confirm]이 공유하는 다이얼로그 표시 보일러플레이트를 추출합니다.
  static Future<T?> _buildAndShow<T>({
    required BuildContext context,
    required bool barrierDismissible,
    required Widget Function(BuildContext dialogContext) builder,
  }) {
    // 다이얼로그 열기 전 포커스 해제 — 다이얼로그 닫힘(pop) 시
    // 이전 route의 TextField로 포커스가 자동 복원되는 것을 방지
    FocusScope.of(context).unfocus();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dialog',
      barrierColor: DialogAnimation.barrierColor,
      transitionDuration: DialogAnimation.duration,
      pageBuilder: (dialogContext, _, _) => builder(dialogContext),
      transitionBuilder: DialogAnimation.buildTransition,
    );
  }

  /// 다이얼로그 표시
  ///
  /// [validator]를 지정하면 확인 버튼 탭 시 먼저 호출됩니다.
  /// false를 반환하면 다이얼로그를 닫지 않고 흔들림 애니메이션을 실행합니다.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool showButtons = true,
    Widget? customContent,
    bool showAvatar = false,
    Widget? avatarWidget,
    String? nickname,
    bool barrierDismissible = true,
    Color? confirmColor,
    Color? confirmTextColor,
    Color? cancelColor,
    Color? cancelTextColor,
    TextStyle? titleStyle,
    bool Function()? validator,
    DialogSpacing? spacing,
    Color? backgroundColor,
    bool isDarkMode = false,
  }) {
    final dialogKey = GlobalKey<_AppDialogState>();

    return _buildAndShow<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AppDialog(
        key: dialogKey,
        title: title,
        message: message,
        confirmText: confirmText ?? '확인',
        cancelText: cancelText,
        isDestructive: isDestructive,
        showButtons: showButtons,
        customContent: customContent,
        showAvatar: showAvatar,
        avatarWidget: avatarWidget,
        nickname: nickname,
        confirmColor: confirmColor,
        confirmTextColor: confirmTextColor,
        cancelColor: cancelColor,
        cancelTextColor: cancelTextColor,
        titleStyle: titleStyle,
        spacing: spacing,
        backgroundColor: backgroundColor,
        isDarkMode: isDarkMode,
        onConfirm: () {
          if (validator != null && !validator()) {
            dialogKey.currentState?.shake();
            return;
          }
          Navigator.of(dialogContext).pop();
          onConfirm?.call();
        },
        onCancel: onCancel != null
            ? () {
                Navigator.of(dialogContext).pop();
                onCancel.call();
              }
            : () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  /// 간편 확인 다이얼로그 (bool 반환)
  static Future<bool?> confirm({
    required BuildContext context,
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
    bool showAvatar = false,
    Widget? avatarWidget,
    String? nickname,
    bool barrierDismissible = true,
    Color? confirmColor,
    Color? confirmTextColor,
    Color? cancelColor,
    Color? cancelTextColor,
    TextStyle? titleStyle,
    DialogSpacing? spacing,
    Color? backgroundColor,
    bool isDarkMode = false,
  }) {
    return _buildAndShow<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AppDialog(
        title: title,
        message: message,
        confirmText: confirmText ?? '확인',
        cancelText: cancelText ?? '취소',
        isDestructive: isDestructive,
        showAvatar: showAvatar,
        avatarWidget: avatarWidget,
        nickname: nickname,
        confirmColor: confirmColor,
        confirmTextColor: confirmTextColor,
        cancelColor: cancelColor,
        cancelTextColor: cancelTextColor,
        titleStyle: titleStyle,
        spacing: spacing,
        backgroundColor: backgroundColor,
        isDarkMode: isDarkMode,
        onConfirm: () => Navigator.of(dialogContext).pop(true),
        onCancel: () => Navigator.of(dialogContext).pop(false),
      ),
    );
  }

  // ============================================
  // State
  // ============================================

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: -8.w), weight: 1),
          TweenSequenceItem(
            tween: Tween(begin: -8.w, end: 8.w),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 8.w, end: -6.w),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween(begin: -6.w, end: 4.w),
            weight: 2,
          ),
          TweenSequenceItem(tween: Tween(begin: 4.w, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  /// 흔들림 애니메이션 실행
  void shake() {
    _shakeController.forward(from: 0);
  }

  /// 확인 버튼 배경색 (기본값 적용)
  Color get _resolvedConfirmColor =>
      widget.confirmColor ??
      (widget.isDestructive
          ? AppColors.danger
          : widget.isDarkMode
          ? AppColors.primary
          : AppColors.ink);

  /// 확인 버튼 텍스트색 (기본값 적용)
  Color get _resolvedConfirmTextColor =>
      widget.confirmTextColor ??
      (widget.isDarkMode ? AppColors.ink : AppColors.surface);

  /// 취소 버튼 배경색 (기본값 적용)
  Color get _resolvedCancelColor =>
      widget.cancelColor ??
      (widget.isDarkMode ? AppColors.ink : AppColors.surfaceDim);

  /// 취소 버튼 텍스트색 (기본값 적용)
  Color get _resolvedCancelTextColor =>
      widget.cancelTextColor ??
      (widget.isDarkMode ? AppColors.disabled : AppColors.muted);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset * 0.4),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Center(
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.w),
              padding: EdgeInsets.only(
                top: AppSpacing.xl.h,
                left: AppSpacing.md.w,
                right: AppSpacing.md.w,
                bottom: AppSpacing.base.h,
              ),
              decoration: BoxDecoration(
                color:
                    widget.backgroundColor ??
                    (widget.isDarkMode ? AppColors.ink : AppColors.surface),
                borderRadius: BorderRadius.circular(AppRadius.xl.r),
              ),
              child: Material(
                color: AppColors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 아바타 + 닉네임/라벨 (선택)
                    if (widget.showAvatar) ...[
                      _buildAvatarSection(),
                      SizedBox(
                        height:
                            widget.spacing?.avatarToTitle ?? AppSpacing.base.h,
                      ),
                    ],

                    // 제목
                    if (widget.title != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs.w,
                        ),
                        child: Text(
                          widget.title!,
                          style:
                              widget.titleStyle ??
                              AppTextStyles.display19.copyWith(
                                color: widget.isDarkMode
                                    ? AppColors.surface
                                    : AppColors.ink,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // 메시지
                    if (widget.message != null) ...[
                      SizedBox(
                        height:
                            widget.spacing?.titleToMessage ?? AppSpacing.md.h,
                      ),
                      Text(
                        widget.message!,
                        style: AppTextStyles.body15.copyWith(
                          color: widget.isDarkMode
                              ? AppColors.disabled
                              : AppColors.muted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    // 커스텀 콘텐츠
                    if (widget.customContent != null) ...[
                      SizedBox(
                        height:
                            widget.spacing?.toContent ??
                            (widget.message != null
                                ? AppSpacing.md.h
                                : AppSpacing.lg.h),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm.w,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: widget.customContent!,
                        ),
                      ),
                    ],

                    // 버튼들
                    if (widget.showButtons) ...[
                      SizedBox(
                        height: widget.spacing?.toButtons ?? AppSpacing.lg.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs.w,
                        ),
                        child: _buildButtons(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 아바타 + 닉네임/라벨 섹션
  Widget _buildAvatarSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 아바타 이미지
        SizedBox(
          width: 92.w,
          height: 108.w,
          child: widget.avatarWidget ?? const SizedBox.shrink(),
        ),
        // 닉네임/라벨
        if (widget.nickname != null) ...[
          SizedBox(height: AppSpacing.xs.h),
          Text(
            widget.nickname!,
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// 버튼 영역
  Widget _buildButtons() {
    final hasCancel = widget.cancelText != null;

    if (hasCancel) {
      // 2버튼: 취소 + 확인
      return Row(
        children: [
          Expanded(
            child: _DialogActionButton(
              text: widget.cancelText!,
              onPressed: widget.onCancel,
              backgroundColor: _resolvedCancelColor,
              foregroundColor: _resolvedCancelTextColor,
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: _DialogActionButton(
              text: widget.confirmText,
              onPressed: () {
                widget.onConfirm?.call();
              },
              backgroundColor: _resolvedConfirmColor,
              foregroundColor: _resolvedConfirmTextColor,
            ),
          ),
        ],
      );
    }

    // 1버튼: 확인만
    return _DialogActionButton(
      text: widget.confirmText,
      onPressed: () {
        widget.onConfirm?.call();
      },
      backgroundColor: _resolvedConfirmColor,
      foregroundColor: _resolvedConfirmTextColor,
      width: double.infinity,
    );
  }
}

/// AppDialog 전용 액션 버튼
///
/// TODO: 어대GO 공용 AppButton 컴포넌트가 추가되면 이걸로 교체.
class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.width,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.label16Semibold.copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}
