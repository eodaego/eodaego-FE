import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

const _pixelRatio = 3.0;
const _normalSize = 22.0;
const _labelWidth = 120.0;
const _labelHeight = 44.0;

/// 시설 마커 아이콘 비트맵 크기와 마커 기준점(anchor).
///
/// 점이 항상 좌표 위에 오도록 anchor를 점 중심에 맞춘다.
class FacilityMarkerIcon {
  const FacilityMarkerIcon(this.descriptor, this.anchor);

  final BitmapDescriptor descriptor;
  final Offset anchor;
}

/// 약도의 `FacilityMarker`와 같은 모양의 시설 PNG 마커.
///
/// [selectedName]을 주면 지름 18 + primary 테두리에 이름 라벨이 붙는다.
Future<FacilityMarkerIcon> createFacilityMarkerIcon({
  String? selectedName,
}) async {
  final selected = selectedName != null;
  final width = selected ? _labelWidth : _normalSize;
  final height = selected ? _labelHeight : _normalSize;
  final center = Offset(width / 2, selected ? 12 : _normalSize / 2);
  final diameter = selected ? 18.0 : 14.0;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(_pixelRatio);
  canvas
    ..drawCircle(
      center.translate(0, 1),
      diameter / 2,
      Paint()
        ..color = AppColors.ink.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    )
    ..drawCircle(center, diameter / 2, Paint()..color = AppColors.surface)
    ..drawCircle(
      center,
      diameter / 2 - 1.5,
      Paint()
        ..color = selected ? AppColors.primary : AppColors.muted
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

  if (selected) {
    final painter = TextPainter(
      text: TextSpan(
        text: selectedName,
        style: AppTextStyles.tag12Bold.copyWith(
          color: AppColors.ink,
          shadows: const [
            Shadow(color: AppColors.surface, blurRadius: 3),
            Shadow(color: AppColors.surface, blurRadius: 3),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: _labelWidth);
    painter.paint(canvas, Offset(width / 2 - painter.width / 2, 24));
  }

  final image = await recorder.endRecording().toImage(
    (width * _pixelRatio).round(),
    (height * _pixelRatio).round(),
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  final anchor = Offset(0.5, center.dy / height);
  if (bytes == null) {
    return FacilityMarkerIcon(BitmapDescriptor.defaultMarker, anchor);
  }
  return FacilityMarkerIcon(
    BitmapDescriptor.bytes(
      bytes.buffer.asUint8List(),
      width: width,
      height: height,
    ),
    anchor,
  );
}
