import 'dart:async';

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
import '../../../user/presentation/providers/user_provider.dart';
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

/// 중복 확인 결과. 입력이 바뀌면 항상 [unknown]으로 되돌린다 —
/// 확인한 뒤 글자를 고쳤는데 옛 결과가 남아 있으면 사용자를 속이는 셈이다.
enum _Availability { unknown, checking, available, taken }

class _NicknameSetupPageState extends ConsumerState<NicknameSetupPage> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialNickname ?? '',
  );

  /// 형식 오류 또는 서버가 돌려준 오류 (예: 중복)
  String? _errorText;

  bool _isSubmitting = false;

  _Availability _availability = _Availability.unknown;

  /// 입력이 멈춘 뒤 확인을 쏘기까지의 대기. 글자마다 서버를 부르지 않는다.
  Timer? _debounce;

  static const Duration _debounceDelay = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    // 입력이 바뀌면 서버 오류(중복 등)를 지우고 형식만 다시 검사한다.
    // 비어 있을 때는 오류를 띄우지 않는다 — 다 지웠을 뿐인데 빨간 글씨가
    // 뜨는 건 아직 아무것도 잘못하지 않은 사용자를 나무라는 셈이다.
    // 이때는 안내 문구를 유지하고 완료 버튼만 잠근다.
    _debounce?.cancel();

    setState(() {
      _errorText = _controller.text.trim().isEmpty
          ? null
          : Validators.validateNickname(_controller.text);
      // 확인 결과는 확인한 그 문자열에만 유효하다.
      _availability = _Availability.unknown;
    });

    // 형식부터 틀렸으면 서버에 물어볼 것도 없다.
    if (Validators.validateNickname(_controller.text) != null) return;
    // 설정 모드에서 원래 이름 그대로면 물어볼 이유가 없다 —
    // 서버도 본인 닉네임은 중복에서 빼주므로 무의미한 왕복이다.
    if (_isUnchanged) return;

    _debounce = Timer(_debounceDelay, _checkAvailability);
  }

  bool get _canSubmit =>
      !_isSubmitting &&
      _availability != _Availability.checking &&
      // 이미 남이 쓰는 걸 아는데 저장을 시도할 이유가 없다.
      _availability != _Availability.taken &&
      Validators.validateNickname(_controller.text) == null;

  /// 입력창 아래 한 줄. 오류가 성공 안내보다 우선하고, 둘 다 없으면 비운다.
  /// (형식 안내는 그 아래 고정 줄이 늘 보여준다.)
  String? get _statusText {
    if (_errorText != null) return _errorText!;
    if (_availability == _Availability.available) return '쓸 수 있는 이름이에요';
    return null;
  }

  Color get _statusColor =>
      _errorText != null ? AppColors.danger : AppColors.primary;

  /// 테두리도 상태를 함께 말한다 — 아이콘 하나보다 눈에 먼저 들어온다.
  Color get _fieldBorderColor {
    if (_errorText != null) return AppColors.danger;
    if (_availability == _Availability.available) return AppColors.primary;
    return AppColors.line;
  }

  OutlineInputBorder _fieldBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        borderSide: BorderSide(color: color, width: width),
      );

  /// 입력창 오른쪽. 확인 중엔 스피너, 글자가 있으면 전체 지우기(X) 버튼.
  /// 판정 결과는 테두리 색과 아래 상태 줄이 이미 말해준다 — 예전의 빨간 X
  /// 아이콘은 지우기 버튼처럼 보이는데 눌러도 반응이 없어 오히려 헷갈렸다.
  Widget? get _suffixIcon {
    if (_availability == _Availability.checking) {
      return Padding(
        padding: EdgeInsets.only(right: AppSpacing.base.w),
        child: Center(
          widthFactor: 1,
          child: SizedBox(
            width: 18.w,
            height: 18.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    if (_controller.text.isEmpty) return null;

    return IconButton(
      onPressed: _isSubmitting ? null : _controller.clear,
      tooltip: '모두 지우기',
      icon: Icon(
        Icons.cancel_rounded,
        size: 22.w,
        color: AppColors.uncollected,
      ),
    );
  }

  /// 저장 전에 쓸 수 있는 닉네임인지 물어본다.
  ///
  /// 결과는 확인 시점의 스냅샷일 뿐이다 — 확인과 저장 사이에 남이 선점할 수
  /// 있으므로 저장 시점의 409 처리는 그대로 남겨 둔다.
  Future<void> _checkAvailability() async {
    final nickname = _controller.text.trim();
    final formatError = Validators.validateNickname(nickname);
    if (formatError != null) {
      setState(() => _errorText = formatError);
      return;
    }

    setState(() {
      _availability = _Availability.checking;
      _errorText = null;
    });

    try {
      final available = await ref
          .read(userRepositoryProvider)
          .isNicknameAvailable(nickname);
      // 확인이 도는 사이 저장이 시작됐다면 결과를 반영하지 않는다 —
      // 저장이 세운 오류 문구를 늦게 도착한 확인이 지워버린다.
      if (!mounted || _isSubmitting) return;
      setState(() {
        _availability = available
            ? _Availability.available
            : _Availability.taken;
        _errorText = available ? null : '이미 사용 중인 닉네임이에요';
      });
    } catch (_) {
      if (!mounted) return;
      // 사용자가 요청한 확인이 아니라 자동으로 쏜 것이므로, 실패를 알리지 않고
      // 조용히 물러난다. 저장 시점의 409가 최종 판정이라 막힐 일도 없다.
      setState(() => _availability = _Availability.unknown);
    }
  }

  /// 설정 모드에서 닉네임을 그대로 둔 채 완료를 누른 경우.
  /// 서버를 부를 이유가 없으니 그냥 닫는다.
  bool get _isUnchanged =>
      widget.isSettings &&
      _controller.text.trim() == (widget.initialNickname ?? '').trim();

  Future<void> _submit() async {
    // 저장을 시작하면 예약된 확인은 의미가 없다. 남겨두면 저장이 세운
    // 오류 문구를 뒤늦게 덮어쓴다.
    _debounce?.cancel();

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
                '어떻게 불러줄까요?',
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
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_canSubmit) _submit();
                },
                style: AppTextStyles.body17.copyWith(color: AppColors.ink),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.surface,
                  hintText: '탐험가',
                  hintStyle: AppTextStyles.body17.copyWith(
                    color: AppColors.uncollected,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.base.w,
                    vertical: AppSpacing.base.h,
                  ),
                  border: _fieldBorder(AppColors.line),
                  enabledBorder: _fieldBorder(_fieldBorderColor),
                  focusedBorder: _fieldBorder(_fieldBorderColor, width: 2),
                  suffixIcon: _suffixIcon,
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 44.w,
                    minHeight: 44.h,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              // 상태 줄과 형식 안내 줄을 분리한다. 한 자리에서 갈아끼우면
              // 오류가 뜰 때 형식 안내가 사라져, 정작 필요할 때 규칙을 못 본다.
              SizedBox(
                height: 20.h,
                child: _statusText == null
                    ? null
                    : Text(
                        _statusText!,
                        style: AppTextStyles.caption14.copyWith(
                          color: _statusColor,
                        ),
                      ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                '한글·영문·숫자 '
                '${Validators.nicknameMinLength}~${Validators.nicknameMaxLength}자',
                style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
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
