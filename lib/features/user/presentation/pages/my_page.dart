import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../../../router/route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/user_provider.dart';

/// 내 정보 (MY-01/02) — 프로필·수집 통계·닉네임 변경·약관·로그아웃·탈퇴.
class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  /// 탈퇴 요청 진행 중 — 중복 DELETE를 막는다.
  bool _isDeleting = false;

  Future<void> _confirmSignOut(BuildContext context) async {
    final ok = await AppDialog.confirm(
      context: context,
      title: '로그아웃',
      message: '정말 로그아웃할까요?',
      confirmText: '로그아웃',
      isDestructive: true,
    );
    if (ok == true) {
      // 로그아웃 성공 시 라우터 redirect가 로그인 화면으로 이동시킨다
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    if (_isDeleting) return;

    final ok = await AppDialog.confirm(
      context: context,
      title: '정말 탈퇴할까요?',
      message: '모은 도감과 기록이 모두 사라지고\n되돌릴 수 없어요.',
      confirmText: '탈퇴하기',
      isDestructive: true,
    );
    if (ok != true) return;

    setState(() => _isDeleting = true);

    try {
      await ref.read(deleteAccountUseCaseProvider).execute();
    } catch (e) {
      // 하드 삭제는 멱등이다 — 404 MEMBER_NOT_FOUND는 "이미 삭제됨"이지
      // 재시도해야 할 실패가 아니다. 그대로 두면 다음 탭도 영원히 404라
      // 사용자가 죽은 세션에 갇힌다. 이 경우엔 로컬 정리로 넘어간다.
      final alreadyDeleted =
          e is ServerException && e.code == 'MEMBER_NOT_FOUND';
      if (!alreadyDeleted) {
        if (!context.mounted) return;
        setState(() => _isDeleting = false);
        AppSnackbar.show(
          context,
          message: '잠시 후 다시 시도해 주세요',
          backgroundColor: AppColors.danger,
          bottomOffset: 40,
        );
        return;
      }
    }

    // 여기 도달 = 서버 계정은 확실히 사라졌다. 계정이 이미 삭제됐으므로 서버
    // 로그아웃(POST /auth/logout)은 부르지 않는다. 로컬 정리(Firebase signOut
    // 등)가 실패해도 사용자에게 알릴 게 없다 — 서버 삭제는 이미 성공했으므로
    // 세션은 반드시 끝낸다.
    final auth = ref.read(authNotifierProvider.notifier);
    try {
      await auth.cleanupAfterAccountDeletion();
    } catch (e) {
      debugPrint('⚠️ 탈퇴 후 로컬 정리 실패(무시): $e');
    } finally {
      auth.forceLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(guestModeProvider);
    final nickname = isGuest
        ? '게스트'
        : ref.watch(authNotifierProvider).valueOrNull?.nickname ?? '탐험가';
    final percent = (mockDogamCollected / mockDogamTotal * 100).round();
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '내 정보'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24.h),
            Center(
              child: Text(
                nickname,
                style: AppTextStyles.display26.copyWith(color: AppColors.ink),
              ),
            ),
            SizedBox(height: 8.h),
            // 게스트는 바꿀 닉네임(계정) 자체가 없으므로 버튼을 아예 숨긴다.
            if (!isGuest)
              Center(
                child: Material(
                  color: AppColors.surface,
                  shape: const StadiumBorder(
                    side: BorderSide(color: AppColors.line),
                  ),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => context.push(
                      '${RoutePaths.mypageNickname}'
                      '?nickname=${Uri.encodeComponent(nickname)}',
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 48.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            '닉네임 바꾸기',
                            style: AppTextStyles.caption14.copyWith(
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _StatCard(value: '$percent%', label: '수집률'),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    value: '$mockDogamCollected',
                    label: '모은 도감',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (isGuest)
              AppButton(
                text: '로그인하러 가기',
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.ink,
                showBorder: true,
                width: double.infinity,
                onPressed: () {
                  ref.read(guestModeProvider.notifier).state = false;
                  context.go(RoutePaths.login);
                },
              )
            else ...[
              InkWell(
                onTap: () => context.push(RoutePaths.mypageAgreements),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 56.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '약관 및 정책',
                          style: AppTextStyles.body15.copyWith(
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.muted,
                        size: 24.w,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: AppColors.line, height: AppSpacing.lg.h),
              SizedBox(height: AppSpacing.sm.h),
              AppButton(
                text: '로그아웃',
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.ink,
                showBorder: true,
                width: double.infinity,
                onPressed: _isDeleting ? null : () => _confirmSignOut(context),
              ),
              SizedBox(height: 12.h),
              AppButton(
                text: '탈퇴하기',
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.danger,
                showBorder: true,
                subtitle: '모든 기록을 완전히 지워요',
                subtitleColor: AppColors.muted,
                width: double.infinity,
                height: 72.h,
                isLoading: _isDeleting,
                onPressed: _isDeleting
                    ? null
                    : () => _confirmDeleteAccount(context),
              ),
            ],
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

/// 수집 통계 카드.
class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.display26.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
