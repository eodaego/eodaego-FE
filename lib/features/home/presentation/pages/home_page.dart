import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../../core/utils/url_launcher_util.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/weather_icons.dart';
import '../../../../router/route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../collection/domain/entities/catalog_summary_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

/// 홈 (A안) — 날씨·혼잡도 바 + 오늘의 추천 코스 프리뷰 + 도감 요약 + 공식 사이트.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.sm.h),
              const _GreetingHeader(),
              SizedBox(height: AppSpacing.base.h),
              const _CourseHeroCard(),
              SizedBox(height: AppSpacing.base.h),
              const _DogamProgressCard(),
              SizedBox(height: AppSpacing.base.h),
              _LinkRow(
                label: '공식 사이트',
                icon: Icons.open_in_new,
                onTap: () => launchExternalUrl(AppUrls.parkOfficialSite),
              ),
              SizedBox(height: AppSpacing.xxl.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// 홈 헤더 — 브랜드·내 정보 줄, 인사말, 그 아래 날씨·혼잡도 칩.
///
/// 인사말이 헤더를 지탱하므로 날씨가 실패해 칩이 빠져도 자리가 비지 않는다.
class _GreetingHeader extends ConsumerWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 마이페이지와 같은 규칙 — 게스트는 '게스트', 닉네임을 아직 안 정했으면 '탐험가'.
    final nickname = ref.watch(guestModeProvider)
        ? '게스트'
        : ref.watch(authNotifierProvider).valueOrNull?.nickname ?? '탐험가';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '어대GO',
              style: AppTextStyles.display16.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => context.push(RoutePaths.mypage),
              tooltip: '내 정보',
              icon: Icon(
                Icons.account_circle_outlined,
                size: 28.w,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          '$nickname님,\n오늘은 뭘 찾아볼까요?',
          style: AppTextStyles.display24.copyWith(color: AppColors.ink),
        ),
        const _WeatherChips(),
      ],
    );
  }
}

/// 날씨·혼잡도 칩 줄 — 탭하면 날씨 상세로 간다.
///
/// 홈은 날씨 화면으로 가는 **유일한 입구**다. 그래서 값을 못 받아도 칩을 지우지
/// 않고 '날씨 보기'로 바꿔 입구를 남긴다. 미세먼지는 서버 API가 없어 넣지 않는다.
class _WeatherChips extends ConsumerWidget {
  const _WeatherChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Guest has no token; calling would 401 and the interceptor would misread
    // it as an expired session and force-log-out. Debug-only path.
    // 게스트는 토큰이 없다. 호출하면 401이 나고 인터셉터가 세션 만료로 오인해
    // 강제 로그아웃시킨다(도감 요약이 겪은 그 버그). 디버그 전용 경로다.
    if (ref.watch(guestModeProvider)) return const SizedBox.shrink();

    final weather = ref.watch(currentWeatherProvider).valueOrNull;
    // 혼잡도 조회는 503이 정상 시나리오다(AI 서버 불가·수집 데이터 없음).
    // 실패·로딩이면 이 칩만 조용히 사라지고 날씨 칩은 그대로 보인다.
    final congestion = ref.watch(currentCongestionProvider).valueOrNull;

    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: [
          _InfoChip(
            leading: Icon(
              weather == null
                  ? Icons.cloud_outlined
                  : weatherIcon(
                      sky: weather.sky,
                      precipitation: weather.precipitation,
                    ),
              size: 16.w,
              color: AppColors.primaryDark,
            ),
            label: weather == null
                ? '날씨 보기'
                : '${weather.conditionLabel} ${weather.temperature.round()}°',
            onTap: () => context.push(RoutePaths.weather),
          ),
          if (congestion != null) ...[
            SizedBox(width: AppSpacing.sm.w),
            _InfoChip(
              leading: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // 서버가 모르는 등급을 주면 색 분기 없이 라벨만 보여준다.
                  color: congestion.level?.color ?? AppColors.muted,
                ),
              ),
              label: congestion.label,
            ),
          ],
        ],
      ),
    );
  }
}

/// 헤더용 pill 칩. [onTap]이 null이면 탭 반응 없이 정보만 보여준다.
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.leading, required this.label, this.onTap});

  final Widget leading;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: 10.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leading,
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTextStyles.caption14.copyWith(color: AppColors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 오늘의 코스 히어로 — 초록 배경 + 코스 씬 이미지 + 코스명 + 노랑 CTA.
/// 탭/CTA 모두 지도 탭 이동 (게이트 없음, 스펙 §4.2).
class _CourseHeroCard extends ConsumerWidget {
  const _CourseHeroCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 지도·추천과 공유하는 선택 코스 (진입 일관성 — 스펙 §6)
    final course = ref.watch(selectedCourseProvider);
    void open() => course == null
        ? context.push(RoutePaths.courseRecommend)
        : context.go(RoutePaths.map);

    return Material(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: open,
        child: Padding(
          // 히어로 카드 패딩은 20 (디자인 시스템 hero-card)
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 코스가 없으면 아래 제목이 이미 권유 문구다. 이 줄을 같이 두면
              // 같은 말을 두 번 하는 꼴이라 코스가 있을 때만 그린다.
              if (course != null) ...[
                Text(
                  '오늘은 이 코스 어때요?',
                  style: AppTextStyles.display19.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                SizedBox(height: 14.h),
              ],
              // errorBuilder는 Image의 width/height를 물려받지 않는다 — 에셋이
              // 없으면(데모 당일 가능) 진짜로 자리를 차지하지 않고 텍스트만
              // 남는다. AspectRatio로 감싸면 이 collapse가 깨진다.
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                child: Image.asset(
                  'assets/images/course/today.png',
                  width: double.infinity,
                  height: 104.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                // 아직 고른 코스가 없다. 가짜 코스를 보여주지 않고 추천으로 유도한다.
                course?.title ?? '오늘 갈 코스를 골라볼까요?',
                style: AppTextStyles.display19.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.base.h),
              AppButton.reward(
                text: course == null ? '코스 추천받기' : '코스 보기',
                width: double.infinity,
                height: 52.h,
                // 카드(radius 24) 내부 버튼은 radius 12 (동심원 규칙)
                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                onPressed: open,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 도감 진행률 카드 — 탭 시 도감 탭으로 전환.
class _DogamProgressCard extends ConsumerWidget {
  const _DogamProgressCard();

  // Guest has no token. If this card called the summary API without auth it
  // would hit a 401, which the interceptor misreads as "session expired" and
  // force-logs-out a guest who was never logged in. So guests render zeros
  // without ever calling the API.
  // 게스트는 토큰이 없다. 인증 없이 이 카드가 요약 API를 부르면 401을 만나고,
  // 인터셉터가 이걸 "세션 만료"로 오인해 강제 로그아웃시킨다(게스트는 로그인한
  // 적이 없는데도). 그래서 게스트는 요청 자체를 하지 않고 0으로 그린다.
  static const _guestSummary = CatalogSummaryEntity(
    totalCount: 0,
    collectedCount: 0,
    collectionRate: 0,
    collectedByCategory: {},
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = ref.watch(guestModeProvider);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: () => context.go(RoutePaths.collection),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: isGuest
              ? _DogamProgressData(summary: _guestSummary)
              : ref
                    .watch(catalogSummaryProvider)
                    .when(
                      loading: () => const _DogamProgressSkeleton(),
                      // 홈에는 다른 콘텐츠가 있다. 카드 안에서만 조용히 알린다.
                      // 제목 Row는 유지해 카드 틀이 무너지지 않게 한다.
                      error: (_, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '내 도감',
                            style: AppTextStyles.display16.copyWith(
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: AppSpacing.base.h),
                          Text(
                            '수집 현황을 불러오지 못했어요',
                            style: AppTextStyles.body15.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      data: (summary) => _DogamProgressData(summary: summary),
                    ),
        ),
      ),
    );
  }
}

/// 도감 진행률 카드 본문 — 2단. 좌측에 제목·백분율·`수집/전체`·게이지(노랑 채움),
/// 우측 한 단은 마스코트 전용.
class _DogamProgressData extends StatelessWidget {
  const _DogamProgressData({required this.summary});

  final CatalogSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    // 좌측 단이 제목·숫자·게이지를 전부 갖고, 우측 단은 마스코트 전용이다.
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내 도감',
                style: AppTextStyles.display16.copyWith(color: AppColors.ink),
              ),
              // 제목과는 벌리고 아래 `수집/전체`와는 붙인다 — 숫자 두 줄이
              // 한 덩어리로 읽혀야 한다.
              SizedBox(height: 14.h),
              Text(
                // 서버가 반올림한 백분율을 그대로 쓴다
                '${summary.collectionRate.round()}%',
                style: AppTextStyles.display34.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                '${summary.collectedCount} / ${summary.totalCount}',
                style: AppTextStyles.body15.copyWith(color: AppColors.muted),
              ),
              SizedBox(height: AppSpacing.base.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  minHeight: 10.h,
                  value: summary.collectionRate / 100,
                  backgroundColor: AppColors.surfaceDim,
                  color: AppColors.reward,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        const _MascotImage(),
      ],
    );
  }
}

/// 도감 진행률 카드 로딩 — 제목·마스코트는 그대로 두고 숫자·게이지만 스켈레톤.
class _DogamProgressSkeleton extends StatelessWidget {
  const _DogamProgressSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내 도감',
                style: AppTextStyles.display16.copyWith(color: AppColors.ink),
              ),
              SizedBox(height: 14.h),
              AppSkeleton(width: 96.w, height: 34.h),
              SizedBox(height: AppSpacing.xs.h),
              AppSkeleton(width: 64.w, height: 18.h),
              SizedBox(height: AppSpacing.base.h),
              AppSkeleton(
                width: double.infinity,
                height: 10.h,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        const _MascotImage(),
      ],
    );
  }
}

/// 도감 카드 우측 단 마스코트 — 본문·스켈레톤이 같은 자리를 차지해야 로딩→로드
/// 시 좌측 게이지 폭이 튀지 않는다.
///
/// 에셋이 없으면(데모 당일 가능) 자리를 차지하지 않는다.
class _MascotImage extends StatelessWidget {
  const _MascotImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.celebrateMascot,
      width: 88.w,
      height: 88.w,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}

/// 바로가기 row — 공식 사이트. (기존 유지)
class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.label16Semibold.copyWith(
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Icon(icon, size: 22.w, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
