import 'package:eodaego/features/quiz/presentation/widgets/confetti_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const palette = [Colors.red, Colors.green, Colors.blue];

  test('same_index_yields_the_same_piece_on_every_call', () {
    final first = confettiPieceAt(7, palette);
    final second = confettiPieceAt(7, palette);

    expect(first.startXFraction, second.startXFraction);
    expect(first.fallSpeed, second.fallSpeed);
    expect(first.rotationTurns, second.rotationTurns);
    expect(first.sizePx, second.sizePx);
    expect(first.color, second.color);
  });

  test('different_indices_spread_across_the_width_instead_of_stacking', () {
    final xs = [for (var i = 0; i < 24; i++) confettiPieceAt(i, palette).startXFraction];

    // A Math.random()-based regression would still pass an "each call is
    // equal" check if it happened to reseed identically, but it could never
    // guarantee spread — so this also protects against a constant fallback.
    expect(xs.toSet().length, greaterThan(1));
  });
}
