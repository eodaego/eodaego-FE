import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_haptics.dart';
import '../../../../core/constants/spacing_and_radius.dart';
import '../../../../core/constants/text_styles.dart';

/// 코스 생성 대기 화면.
///
/// AI 응답까지 기다리는 시간이 길어 고양이를 눌러볼 수 있게 뒀다.
/// 누르는 동안만 커지고 놓으면 돌아오므로 화면 구성이 흐트러지지 않는다.
class CourseLoadingCat extends StatefulWidget {
  const CourseLoadingCat({super.key});

  @override
  State<CourseLoadingCat> createState() => _CourseLoadingCatState();
}

class _CourseLoadingCatState extends State<CourseLoadingCat> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTapDown: (_) {
            AppHaptics.tap();
            _setPressed(true);
          },
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: AnimatedScale(
            scale: _pressed ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutBack,
            // AI 생성이라 대기가 길다. 스피너 대신 계속 볼 만한 그림을 둔다.
            child: Lottie.asset(
              'assets/animations/Loader_Cat.json',
              width: 360.w,
              repeat: true,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.base.h),
        Text(
          '코스를 만들고 있어요',
          style: AppTextStyles.body15.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          '조금만 기다리면 돼요',
          style: AppTextStyles.caption14.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
