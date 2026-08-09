import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

const _markerWidth = 44.0;
const _markerHeight = 52.0;
const _pixelRatio = 3.0;

/// 실제 지도에서 약도와 같은 색·번호를 보여주는 PNG 마커를 만든다.
Future<BitmapDescriptor> createGoogleMapMarkerIcon({
  required String label,
  required Color color,
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
