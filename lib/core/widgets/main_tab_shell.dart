import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_paths.dart';
import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

/// 4탭 셸 스캐폴드 — 하단 탭바(홈·지도·도감·즐겨찾기) + 중앙 카메라 FAB.
class MainTabShell extends StatelessWidget {
  const MainTabShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _CameraFab(
        onTap: () => context.push(RoutePaths.scan),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64.h,
            child: Row(
              children: [
                _TabItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: '홈',
                  shell: navigationShell,
                ),
                _TabItem(
                  index: 1,
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: '지도',
                  shell: navigationShell,
                ),
                // 중앙 카메라 FAB 자리
                SizedBox(width: 76.w),
                _TabItem(
                  index: 2,
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book,
                  label: '도감',
                  shell: navigationShell,
                ),
                _TabItem(
                  index: 3,
                  icon: Icons.favorite_border,
                  activeIcon: Icons.favorite,
                  label: '즐겨찾기',
                  shell: navigationShell,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.shell,
  });

  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final active = shell.currentIndex == index;
    final color = active ? AppColors.primaryDark : AppColors.disabled;
    return Expanded(
      child: InkWell(
        onTap: () =>
            shell.goBranch(index, initialLocation: index == shell.currentIndex),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : icon, size: 26.w, color: color),
            SizedBox(height: 4.h),
            Text(label, style: AppTextStyles.tag12Bold.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

/// 카메라 FAB 64 + canvas색 5px 링 + 브랜드색 그림자 (디자인 시스템 유일 그림자).
class _CameraFab extends StatelessWidget {
  const _CameraFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74.w,
      height: 74.w,
      padding: EdgeInsets.all(5.w),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              offset: const Offset(0, 6),
              blurRadius: 14,
            ),
          ],
        ),
        child: Material(
          color: AppColors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Icon(
              Icons.photo_camera,
              size: 28.w,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
