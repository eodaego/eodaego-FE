import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 어대GO 타이포 — `.claude/rules/UI_Design_System.md` 정본.
/// weight/fontSize/fontFamily는 이 파일에서만 정의. copyWith로 color/decoration만 변경 허용.
class AppTextStyles {
  AppTextStyles._();

  static const String _display = 'Cafe24Ssurround';
  static const String _body = 'Pretendard';

  // Display (Cafe24Ssurround)
  static TextStyle get display34 =>
      TextStyle(fontFamily: _display, fontSize: 34.sp, height: 1.2);
  static TextStyle get display26 =>
      TextStyle(fontFamily: _display, fontSize: 26.sp, height: 1.25);
  static TextStyle get display24 =>
      TextStyle(fontFamily: _display, fontSize: 24.sp, height: 1.35);
  static TextStyle get display22 =>
      TextStyle(fontFamily: _display, fontSize: 22.sp, height: 1.4);
  static TextStyle get display19 =>
      TextStyle(fontFamily: _display, fontSize: 19.sp, height: 1.3);
  static TextStyle get display17 =>
      TextStyle(fontFamily: _display, fontSize: 17.sp, height: 1.0);
  static TextStyle get display16 =>
      TextStyle(fontFamily: _display, fontSize: 16.sp, height: 1.0);

  // Body (Pretendard)
  static TextStyle get body17 => TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 17.sp,
    height: 1.65,
    letterSpacing: -0.32,
  );
  static TextStyle get body15 => TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
    height: 1.6,
    letterSpacing: -0.32,
  );
  static TextStyle get label16Semibold => TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 1.0,
    letterSpacing: -0.32,
  );
  static TextStyle get caption14 => TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 1.4,
    letterSpacing: -0.32,
  );
  static TextStyle get tag13Bold => TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 13.sp,
    height: 1.0,
    letterSpacing: -0.32,
  );
  static TextStyle get tag12Bold => TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    height: 1.0,
    letterSpacing: -0.32,
  );
}
