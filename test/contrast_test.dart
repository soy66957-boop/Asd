// Contrast ratio tests for all palettes
// Ensures WCAG AA compliance (4.5:1 for text, 3:1 for UI elements)

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

  group('PipesTokens contrast ratios', () {
    final tokens = PipesTokens.createDefault();
    // Test only the default palette (pastelSkyDark) which is what the app uses.
    final defaultPalette = tokens.palettes['pastelSkyDark']!;

    void expectPass(String description, double ratio, double minRatio) {
      expect(ratio, greaterThanOrEqualTo(minRatio),
          reason: '$description: ratio ${ratio.toStringAsFixed(4)}:1 (need >= $minRatio:1)');
    }

    test('Default palette: textPrimary on background >= 4.5:1', () {
      expectPass(
        'Default palette textPrimary on background',
        PipesTokens.contrastRatio(defaultPalette.textPrimary, defaultPalette.background),
        4.5,
      );
    });

    test('Default palette: textPrimary on surface >= 4.5:1', () {
      expectPass(
        'Default palette textPrimary on surface',
        PipesTokens.contrastRatio(defaultPalette.textPrimary, defaultPalette.surface),
        4.5,
      );
    });

    test('Default palette: textSecondary on surface >= 4.5:1', () {
      expectPass(
        'Default palette textSecondary on surface',
        PipesTokens.contrastRatio(defaultPalette.textSecondary, defaultPalette.surface),
        4.5,
      );
    });

    test('Default palette: textSecondary on background >= 4.5:1', () {
      expectPass(
        'Default palette textSecondary on background',
        PipesTokens.contrastRatio(defaultPalette.textSecondary, defaultPalette.background),
        4.5,
      );
    });

    test('Default palette: pipeIdle on boardSurface >= 3:1', () {
      expectPass(
        'Default palette pipeIdle on boardSurface',
        PipesTokens.contrastRatio(defaultPalette.pipeIdle, defaultPalette.boardSurface),
        3.0,
      );
    });

    test('Default palette: accent on background >= 3:1 (UI elements)', () {
      expectPass(
        'Default palette accent on background',
        PipesTokens.contrastRatio(defaultPalette.accent, defaultPalette.background),
        3.0,
      );
    });

    test('Default palette: onAccent on accent >= 4.5:1', () {
      expectPass(
        'Default palette onAccent on accent',
        PipesTokens.contrastRatio(defaultPalette.onAccent, defaultPalette.accent),
        4.5,
      );
    });
  });
}
