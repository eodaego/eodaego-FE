import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/mock/mock_dogam.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 내 정보 (MY-01/02) — 프로필·수집 통계·로그아웃(실동작)·탈퇴(준비 중).
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname =
        ref.watch(authNotifierProvider).valueOrNull?.nickname ?? '탐험가';
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
              child: Container(
                width: 96.w,
                height: 96.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceDim,
                ),
                child: Icon(Icons.person, size: 48.w, color: AppColors.muted),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                nickname,
                style: AppTextStyles.display19.copyWith(color: AppColors.ink),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Material(
                color: AppColors.surface,
                shape: const StadiumBorder(
                  side: BorderSide(color: AppColors.line),
                ),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () =>
                      AppSnackbar.show(context, message: '준비 중이에요'),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 48.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          '닉네임 바꾸기',
                          style: AppTextStyles.caption14
                              .copyWith(color: AppColors.muted),
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
                Expanded(child: _StatCard(value: '$percent%', label: '수집률')),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                      value: '$mockDogamCollected', label: '모은 도감'),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: '로그아웃',
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.ink,
              showBorder: true,
              width: double.infinity,
              onPressed: () => _confirmSignOut(context, ref),
            ),
            SizedBox(height: 12.h),
            AppButton(
              text: '탈퇴하기',
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.danger,
              showBorder: true,
              subtitle: '모든 기록이 완전히 삭제돼요',
              subtitleColor: AppColors.muted,
              width: double.infinity,
              height: 72.h,
              onPressed: () => AppSnackbar.show(context, message: '준비 중이에요'),
            ),
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
