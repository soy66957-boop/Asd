// Contrast ratio tests for PipesTokens helper

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

void main() {
  group('PipesTokens contrastRatio helper sanity', () {
    test('contrastRatio(black, white) ~ 21', () {
      final ratio = PipesTokens.contrastRatio(
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
      );
      expect(ratio, closeTo(21.0, 0.1));
    });

    test('contrastRatio(white, white) == 1', () {
      final ratio = PipesTokens.contrastRatio(
        const Color(0xFFFFFFFF),
        const Color(0xFFFFFFFF),
      );
      expect(ratio, closeTo(1.0, 0.001));
    });

    test('contrastRatio(#E8F1FF, #0B1220) > 10', () {
      final ratio = PipesTokens.contrastRatio(
        const Color(0xFFE8F1FF),
        const Color(0xFF0B1220),
      );
      expect(ratio, greaterThan(10.0));
    });
  });

  group('PipesTokens default palette contrast', () {
    final tokens = PipesTokens.createDefault();
    final p = tokens.palettes['pastelSkyDark']!;

    test('textPrimary on background >= 4.5:1', () {
      expect(PipesTokens.contrastRatio(p.textPrimary, p.background), greaterThanOrEqualTo(4.5));
    });

    test('textPrimary on surface >= 4.5:1', () {
      expect(PipesTokens.contrastRatio(p.textPrimary, p.surface), greaterThanOrEqualTo(4.5));
    });

    test('accent on background >= 3:1', () {
      expect(PipesTokens.contrastRatio(p.accent, p.background), greaterThanOrEqualTo(3.0));
    });

    test('onAccent on accent >= 4.5:1', () {
      expect(PipesTokens.contrastRatio(p.onAccent, p.accent), greaterThanOrEqualTo(4.5));
    });
  });
}
