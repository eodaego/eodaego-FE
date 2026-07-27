import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

/// 닉네임 설정 화면 — 신규 가입 온보딩과 마이페이지 설정 양쪽에서 쓴다.
///
/// 저장은 서버 `PATCH /api/1/members/me/nickname`으로 이뤄지며,
/// 성공한 경우에만 상태가 갱신된다.
///
/// 온보딩([isSettings]=false)은 닫을 수 없는 게이트라 앱바가 없고, 저장에
/// 성공하면 라우터가 `isNewUser=false`를 보고 홈으로 보낸다.
/// 설정([isSettings]=true)은 앱바로 되돌아갈 길을 열어 두고, 저장 뒤 직접
/// 이전 화면으로 돌아간다.
///
/// TODO: 어대GO 닉네임 설정 디자인 확정 시 레이아웃 교체.
class NicknameSetupPage extends ConsumerStatefulWidget {
  const NicknameSetupPage({
    super.key,
    this.initialNickname,
    this.isSettings = false,
  });

  final String? initialNickname;

  /// 마이페이지에서 진입한 설정 모드 여부.
  final bool isSettings;

  @override
  ConsumerState<NicknameSetupPage> createState() => _NicknameSetupPageState();
}

class _NicknameSetupPageState extends ConsumerState<NicknameSetupPage> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialNickname ?? '',
  );

  /// 형식 오류 또는 서버가 돌려준 오류 (예: 중복)
  String? _errorText;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    // 입력이 바뀌면 서버 오류(중복 등)를 지우고 형식만 다시 검사한다.
    // 비어 있을 때는 오류를 띄우지 않는다 — 다 지웠을 뿐인데 빨간 글씨가
    // 뜨는 건 아직 아무것도 잘못하지 않은 사용자를 나무라는 셈이다.
    // 이때는 안내 문구를 유지하고 완료 버튼만 잠근다.
    setState(() {
      _errorText = _controller.text.trim().isEmpty
          ? null
          : Validators.validateNickname(_controller.text);
    });
  }

  bool get _canSubmit =>
      !_isSubmitting && Validators.validateNickname(_controller.text) == null;

  /// 설정 모드에서 닉네임을 그대로 둔 채 완료를 누른 경우.
  /// 서버를 부를 이유가 없으니 그냥 닫는다.
  bool get _isUnchanged =>
      widget.isSettings &&
      _controller.text.trim() == (widget.initialNickname ?? '').trim();

  Future<void> _submit() async {
    final nickname = _controller.text.trim();
    final formatError = Validators.validateNickname(nickname);
    if (formatError != null) {
      setState(() => _errorText = formatError);
      return;
    }

    if (_isUnchanged) {
      // go_router의 context.pop()이 아닌 Navigator.of(context).pop()을 쓴다 —
      // nickname_setup_page_settings_test.dart는 이 화면을 GoRouter 없이
      // 평범한 MaterialPageRoute로 열어 테스트하므로, context.pop()으로
      // 바꾸면 GoRouter를 찾지 못해 그 테스트가 조용히 깨진다.
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).updateNickname(nickname);
      if (!mounted) return;
      // 온보딩은 라우터가 isNewUser=false를 보고 홈으로 보내지만, 리다이렉트가
      // 지연되거나 실패하는 경우에도 화면이 잠기지 않도록 항상 상태를 푼다.
      setState(() => _isSubmitting = false);
      // 설정 모드는 라우터가 대신 이동시켜주지 않으므로 직접 되돌아간다.
      // 위와 동일한 이유로 context.pop()이 아닌 Navigator.of(context).pop()을
      // 쓴다 — 이 화면을 여는 위젯 테스트엔 GoRouter가 없다.
      if (widget.isSettings) Navigator.of(context).pop();
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = e.code == 'NICKNAME_ALREADY_EXISTS'
            ? '이미 사용 중인 닉네임이에요'
            : '잠시 후 다시 시도해 주세요';
        _isSubmitting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorText = '잠시 후 다시 시도해 주세요';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // autoDispose provider가 비동기 작업 중 dispose되지 않도록 구독을 유지한다.
    ref.watch(authNotifierProvider);

    final hasError = _errorText != null;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: widget.isSettings ? const AppBackAppBar(title: '닉네임 변경') : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 약관 화면과 동일한 상단 리듬 — 제목은 최상단 고정.
              // 설정 모드는 앱바가 이미 자리를 차지하므로 여백을 줄인다.
              SizedBox(
                height: widget.isSettings
                    ? AppSpacing.xl.h
                    : (AppSpacing.xxl * 2).h,
              ),
              Text(
                '닉네임을 정해 주세요',
                style: AppTextStyles.display24.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                '언제든 다시 바꿀 수 있어요',
                style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
              const Spacer(),
              TextField(
                controller: _controller,
                enabled: !_isSubmitting,
                maxLength: Validators.nicknameMaxLength,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_canSubmit) _submit();
                },
                style: AppTextStyles.body17.copyWith(color: AppColors.ink),
                decoration: const InputDecoration(counterText: ''),
              ),
              SizedBox(height: AppSpacing.sm.h),
              // 오류와 안내를 한 자리에서 교체 표시한다.
              // InputDecoration.errorText는 좌측 정렬이라 가운데 정렬한
              // 입력과 축이 어긋난다.
              Text(
                hasError
                    ? _errorText!
                    : '한글, 영문, 숫자로 '
                          '${Validators.nicknameMinLength}~${Validators.nicknameMaxLength}자',
                style: AppTextStyles.caption14.copyWith(
                  color: hasError ? AppColors.danger : AppColors.muted,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                text: '완료',
                onPressed: _canSubmit ? _submit : null,
                isLoading: _isSubmitting,
              ),
              SizedBox(height: AppSpacing.lg.h),
            ],
          ),
        ),
      ),
    );
  }
}
