import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/widgets/app_back_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../../../router/route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../collection/domain/entities/catalog_summary_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
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

  /// 현재 앱 버전 (예: '1.0.28'). 첫 프레임 뒤에 채워진다.
  String? _appVersion;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _appVersion = info.version);
    });
  }

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

    // 하드 삭제라 확인 다이얼로그만으로는 약하다 — '탈퇴하기'(또는 delete)를
    // 직접 입력해야 버튼이 통과된다. 틀리면 AppDialog의 shake로만 알린다.
    // 컨트롤러 대신 onChanged로 받는다: 다이얼로그 닫힘 애니메이션 중에
    // dispose된 컨트롤러를 TextField가 건드리는 문제를 원천 차단한다.
    var typed = '';
    var confirmed = false;
    await AppDialog.show(
      context: context,
      title: '정말 탈퇴할까요?',
      message: '모은 도감과 기록이 모두 사라지고\n되돌릴 수 없어요.\n계속하려면 아래에 \'탈퇴하기\'를 입력해 주세요.',
      customContent: TextField(
        autofocus: true,
        onChanged: (value) => typed = value,
        textAlign: TextAlign.center,
        style: AppTextStyles.body15.copyWith(color: AppColors.ink),
        decoration: InputDecoration(
          hintText: '탈퇴하기',
          hintStyle: AppTextStyles.body15.copyWith(
            color: AppColors.uncollected,
          ),
          filled: true,
          fillColor: AppColors.surfaceDim,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.base.w,
            vertical: AppSpacing.md.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      cancelText: '닫기',
      confirmText: '탈퇴하기',
      isDestructive: true,
      validator: () {
        final input = typed.trim();
        return input == '탈퇴하기' || input.toLowerCase() == 'delete';
      },
      onConfirm: () => confirmed = true,
    );
    if (!confirmed) return;

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
    // Guest has no token. Calling the summary API here would 401, and the
    // interceptor would misread that as an expired session and force-log-out
    // a guest who was never logged in. So guests skip the request entirely —
    // null signals "render zeros" to _StatsCard.
    // 게스트는 토큰이 없다. 여기서 요약 API를 부르면 401이 나고, 인터셉터가
    // 이를 세션 만료로 오인해 로그인한 적 없는 게스트를 강제 로그아웃시킨다.
    // 그래서 게스트는 조회 자체를 하지 않는다 — null은 "0으로 보여준다"는 신호다.
    final summaryAsync = isGuest ? null : ref.watch(catalogSummaryProvider);
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: const AppBackAppBar(title: '내 정보'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.xl.h),
            _ProfileHeader(
              nickname: nickname,
              // 게스트는 바꿀 닉네임(계정) 자체가 없으므로 링크를 숨긴다.
              onEditTap: isGuest
                  ? null
                  : () => context.push(
                      '${RoutePaths.mypageNickname}'
                      '?nickname=${Uri.encodeComponent(nickname)}',
                    ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
            Text(
              '내 도감',
              style: AppTextStyles.display16.copyWith(color: AppColors.ink),
            ),
            SizedBox(height: AppSpacing.md.h),
            _StatsCard(
              summaryAsync: summaryAsync,
              onTap: () => context.go(RoutePaths.collection),
            ),
            SizedBox(height: AppSpacing.xxl.h),
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
              _MenuRow(
                title: '약관과 정책',
                onTap: () => context.push(RoutePaths.mypageAgreements),
              ),
              const Divider(color: AppColors.line, height: 1),
              _MenuRow(
                title: '로그아웃',
                onTap: _isDeleting ? null : () => _confirmSignOut(context),
              ),
              const Divider(color: AppColors.line, height: 1),
              // 탈퇴는 Hard Delete — 경고 subtitle은 항상 동반한다.
              _MenuRow(
                title: '탈퇴하기',
                titleColor: AppColors.danger,
                subtitle: '모든 기록을 완전히 지워요',
                isLoading: _isDeleting,
                onTap: _isDeleting
                    ? null
                    : () => _confirmDeleteAccount(context),
              ),
            ],
            SizedBox(height: AppSpacing.xxl.h),
            // 로딩 중엔 빈 문자열 — Text가 줄 높이는 유지하므로 자리가 안 튄다.
            Center(
              child: Text(
                _appVersion == null ? '' : '버전 $_appVersion',
                style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
              ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
          ],
        ),
      ),
    );
  }
}

/// 프로필 헤더 — 닉네임 + 닉네임 바꾸기 링크.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.nickname, this.onEditTap});

  final String nickname;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            nickname,
            style: AppTextStyles.display26.copyWith(color: AppColors.ink),
            // 닉네임은 10자까지 허용된다 — 넘치면 줄바꿈 대신 줄임표.
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onEditTap != null)
          InkWell(
            onTap: onEditTap,
            borderRadius: BorderRadius.circular(AppRadius.xs.r),
            child: ConstrainedBox(
              // 텍스트 링크지만 터치 영역은 48을 지킨다.
              constraints: BoxConstraints(minHeight: 48.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '닉네임 바꾸기',
                    style: AppTextStyles.caption14.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18.w,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// 수집 통계 카드 — 한 장을 세로 구분선으로 2분할, 탭하면 도감으로.
///
/// [summaryAsync]가 null이면 게스트다(조회 자체를 하지 않음) — 0을 그대로 보여준다.
/// 로딩은 숫자 자리만 스켈레톤으로, 에러는 카드 틀은 유지한 채 숫자 대신
/// 짧은 안내로 바꾼다. 0으로 단언하지 않는다.
class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.summaryAsync, required this.onTap});

  final AsyncValue<CatalogSummaryEntity>? summaryAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final async = summaryAsync;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          child: async == null
              ? const _StatsRow(percentText: '0%', countText: '0')
              : async.when(
                  loading: () => const _StatsRow(loading: true),
                  // 카드 틀은 유지하고, 0을 사실처럼 보여주는 대신 짧게 알린다.
                  error: (_, _) => Center(
                    child: Text(
                      '수집 현황을 불러오지 못했어요',
                      style: AppTextStyles.body15.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  data: (summary) => _StatsRow(
                    percentText: '${summary.collectionRate.round()}%',
                    countText: '${summary.collectedCount}',
                  ),
                ),
        ),
      ),
    );
  }
}

/// 두 칼럼(수집률/모은 도감) — 로딩이면 숫자 자리에 스켈레톤을 넣는다.
class _StatsRow extends StatelessWidget {
  const _StatsRow({this.percentText, this.countText, this.loading = false});

  final String? percentText;
  final String? countText;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              valueText: percentText,
              loading: loading,
              label: '수집률',
            ),
          ),
          const VerticalDivider(color: AppColors.line, width: 1, thickness: 1),
          Expanded(
            child: _StatColumn(
              valueText: countText,
              loading: loading,
              label: '모은 도감',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    this.valueText,
    this.loading = false,
    required this.label,
  });

  final String? valueText;
  final bool loading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 14.w,
              color: AppColors.muted,
            ),
          ],
        ),
        SizedBox(height: 6.h),
        loading
            ? AppSkeleton(width: 48.w, height: 26.h)
            : Text(
                valueText ?? '',
                style: AppTextStyles.display26.copyWith(
                  color: AppColors.primary,
                ),
              ),
      ],
    );
  }
}

/// 메뉴 리스트 행 — 제목 + 셰브론, 탈퇴 행은 danger색 + 경고 subtitle.
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.title,
    this.subtitle,
    this.titleColor,
    this.isLoading = false,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Color? titleColor;
  final bool isLoading;
  final VoidCallback? onTap;

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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body15.copyWith(
                        color: titleColor ?? AppColors.ink,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption14.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.muted,
                  ),
                )
              else
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
