import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

const _markerWidth = 44.0;
const _markerHeight = 52.0;
const _pixelRatio = 3.0;

/// 도감 수집 체크 뱃지 — 원 중심을 기준으로 우상단 45° 지점에 얹는다.
const _badgeCenter = Offset(34, 9.5);
const _badgeRadius = 7.5;

/// 실제 지도에서 약도와 같은 색·번호를 보여주는 PNG 마커를 만든다.
///
/// [checkColor]를 주면 우상단에 그 색 체크가 붙는다 — 이미 도감에 모은 장소다
/// (`MapMarker`의 약도 마커와 같은 규칙).
Future<BitmapDescriptor> createGoogleMapMarkerIcon({
  required String label,
  required Color color,
  Color? checkColor,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(_pixelRatio);
  final center = const Offset(_markerWidth / 2, 21);
  final markerPath = Path()
    ..addOval(Rect.fromCircle(center: center, radius: 20))
    ..moveTo(15, 36)
    ..lineTo(_markerWidth / 2, _markerHeight)
    ..lineTo(29, 36)
    ..close();

  canvas.drawShadow(markerPath, AppColors.ink, 3, true);
  canvas.drawPath(markerPath, Paint()..color = AppColors.onPrimary);
  canvas.drawCircle(center, 17, Paint()..color = color);

  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.display16.copyWith(color: AppColors.onPrimary),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(
    canvas,
    Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    ),
  );

  if (checkColor != null) {
    // 흰 테두리 → 카테고리 dark 채움 → 흰 체크. 마커의 흰 링 위로 올라앉는
    // 자리라 테두리가 없으면 경계가 사라진다(`MapMarker`와 같은 규칙).
    canvas
      ..drawCircle(
        _badgeCenter,
        _badgeRadius + 1.5,
        Paint()..color = AppColors.onPrimary,
      )
      ..drawCircle(_badgeCenter, _badgeRadius, Paint()..color = checkColor);
    final check = Path()
      ..moveTo(_badgeCenter.dx - 3.4, _badgeCenter.dy - 0.2)
      ..lineTo(_badgeCenter.dx - 1.0, _badgeCenter.dy + 2.6)
      ..lineTo(_badgeCenter.dx + 3.6, _badgeCenter.dy - 3.0);
    canvas.drawPath(
      check,
      Paint()
        ..color = AppColors.onPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  final image = await recorder.endRecording().toImage(
    (_markerWidth * _pixelRatio).round(),
    (_markerHeight * _pixelRatio).round(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (bytes == null) return BitmapDescriptor.defaultMarker;

  return BitmapDescriptor.bytes(
    bytes.buffer.asUint8List(),
    width: _markerWidth,
    height: _markerHeight,
  );
}
