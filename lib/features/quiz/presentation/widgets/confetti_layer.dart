import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dogam_category.dart';

/// 컨페티 오버레이 (QUIZ-05) — 카테고리색 3종 + 보상 노랑 + 흰색 조각이
/// 떨어지며 회전하다 2초 후 정지한다(디자인 시스템 파티클 상한).
///
/// **주의**: 조각의 위치·속도·회전·색은 인덱스 기반 순수 함수
/// [confettiPieceAt]로 한 번만 계산해 보관한다. `Random()`을 build마다
/// 새로 굴리면 라운드 전환 등 다른 상태 변화가 있을 때마다 컨페티가
/// 재배치되어 튀어 보인다.
class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({super.key});

  @override
  State<ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<ConfettiLayer>
    with SingleTickerProviderStateMixin {
  static const _pieceCount = 24;

  late final AnimationController _controller;
  late final List<ConfettiPiece> _pieces;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    final palette = [
      for (final category in DogamCategory.values) category.color,
      AppColors.reward,
      AppColors.surface,
    ];
    _pieces = [
      for (var i = 0; i < _pieceCount; i++) confettiPieceAt(i, palette),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ConfettiPainter(
            pieces: _pieces,
            progress: _controller.value,
          ),
        ),
      ),
    );
  }
}

/// 컨페티 조각 하나의 낙하 스펙 — 전부 인덱스에서 결정적으로 유도된다.
@immutable
class ConfettiPiece {
  const ConfettiPiece({
    required this.startXFraction,
    required this.fallSpeed,
    required this.rotationTurns,
    required this.sizePx,
    required this.color,
  });

  /// 가로 위치 (0.0~1.0, 화면 너비 비율). 낙하 내내 고정.
  final double startXFraction;

  /// 낙하 속도 배수. 1.0보다 크면 2초 전에 바닥에 닿아 그 자리에서 멈춘다.
  final double fallSpeed;

  /// 2초 동안 도는 회전 수(음수면 반대 방향).
  final double rotationTurns;

  final double sizePx;
  final Color color;
}

/// [index]로부터 결정적인 컨페티 조각을 만든다 (순수 함수, `Random` 미사용).
///
/// 같은 [index]는 항상 같은 [ConfettiPiece]를 돌려준다 — 매 빌드마다
/// 위치가 바뀌지 않는다는 뜻이다.
ConfettiPiece confettiPieceAt(int index, List<Color> palette) {
  double frac(int seed, int mod) => (seed % mod) / mod;

  return ConfettiPiece(
    startXFraction: frac(index * 37 + 11, 97),
    fallSpeed: 0.8 + frac(index * 53 + 7, 89) * 0.5,
    rotationTurns:
        (index.isEven ? 1 : -1) * (1.5 + frac(index * 29 + 3, 71) * 2),
    sizePx: 6 + frac(index * 17 + 5, 61) * 6,
    color: palette[index % palette.length],
  );
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.pieces, required this.progress});

  final List<ConfettiPiece> pieces;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final piece in pieces) {
      final fallProgress = (progress * piece.fallSpeed).clamp(0.0, 1.0);
      final dx = piece.startXFraction * size.width;
      final dy =
          -piece.sizePx + (size.height + piece.sizePx * 2) * fallProgress;
      final angle = progress * piece.rotationTurns * 2 * math.pi;

      // Fades a piece out over the last stretch of its own fall so nothing
      // comes to rest fully opaque at the bottom — right where the CTA
      // button sits. 조각마다 낙하 막바지에 스스로 옅어지게 해, 화면
      // 하단(CTA 버튼 자리)에 또렷하게 멈춰 있는 조각이 남지 않게 한다.
      const fadeStart = 0.85;
      final fade = fallProgress <= fadeStart
          ? 1.0
          : 1.0 - (fallProgress - fadeStart) / (1.0 - fadeStart);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);
      paint.color = piece.color.withValues(alpha: fade);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.sizePx,
          height: piece.sizePx * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
