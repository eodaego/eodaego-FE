import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

/// 닉네임 설정 화면 (신규 가입 온보딩)
///
/// 서버가 자동 발급한 닉네임을 초기값으로 받아, 사용자가 원하면 바꾼다.
/// 저장은 서버 `PATCH /api/1/members/me/nickname`으로 이뤄지며,
/// 성공한 경우에만 상태가 갱신되어 라우터가 홈으로 보낸다.
///
/// TODO: 어대GO 닉네임 설정 디자인 확정 시 레이아웃 교체.
class NicknameSetupPage extends ConsumerStatefulWidget {
  const NicknameSetupPage({super.key, this.initialNickname});
  final String? initialNickname;

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
    setState(() {
      _errorText = Validators.validateNickname(_controller.text);
    });
  }

  bool get _canSubmit =>
      !_isSubmitting && Validators.validateNickname(_controller.text) == null;

  Future<void> _submit() async {
    final nickname = _controller.text.trim();
    final formatError = Validators.validateNickname(nickname);
    if (formatError != null) {
      setState(() => _errorText = formatError);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).updateNickname(nickname);
      // 성공 시 라우터가 isNewUser=false를 보고 홈으로 보낸다.
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = e.code == 'NICKNAME_ALREADY_EXISTS'
            ? '이미 사용 중인 닉네임이에요'
            : '잠시 후 다시 시도해 주세요';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorText = '잠시 후 다시 시도해 주세요');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // autoDispose provider가 비동기 작업 중 dispose되지 않도록 구독을 유지한다.
    ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '닉네임을 정해 주세요',
                style: AppTextStyles.display24,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: _controller,
                enabled: !_isSubmitting,
                maxLength: Validators.nicknameMaxLength,
                style: AppTextStyles.body17,
                decoration: InputDecoration(
                  errorText: _errorText,
                  errorStyle: AppTextStyles.caption14.copyWith(
                    color: AppColors.danger,
                  ),
                  counterText: '',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '한글, 영문, 숫자로 '
                '${Validators.nicknameMinLength}~${Validators.nicknameMaxLength}자',
                style: AppTextStyles.caption14,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              AppButton(
                text: '완료',
                onPressed: _canSubmit ? _submit : null,
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
