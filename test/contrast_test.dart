// Contrast ratio tests for all palettes
// Ensures WCAG AA compliance (4.5:1 for text, 3:1 for UI elements)

import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

void main() {
  group('PipesTokens contrast ratios', () {
    final tokens = PipesTokens.createDefault();

    test('All dark palettes: text on background >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (!palette.isDark) continue;

        final contrast = PipesTokens.contrastRatio(palette.textPrimary, palette.background);
        expect(
          contrast >= 4.5,
          isTrue,
          reason:
              'Dark palette ${palette.id}: textPrimary on background contrast is $contrast:1 (need >= 4.5:1)',
        );
      }
    });

    test('All dark palettes: text on surface >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (!palette.isDark) continue;

        final contrast = PipesTokens.contrastRatio(palette.textPrimary, palette.surface);
        expect(
          contrast >= 4.5,
          isTrue,
          reason:
              'Dark palette ${palette.id}: textPrimary on surface contrast is $contrast:1 (need >= 4.5:1)',
        );
      }
    });

    test('All light palettes: text on background >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (palette.isDark) continue;

        final contrast = PipesTokens.contrastRatio(palette.textPrimary, palette.background);
        expect(
          contrast >= 4.5,
          isTrue,
          reason:
              'Light palette ${palette.id}: textPrimary on background contrast is $contrast:1 (need >= 4.5:1)',
        );
      }
    });

    test('All light palettes: text on surface >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (palette.isDark) continue;

        final contrast = PipesTokens.contrastRatio(palette.textPrimary, palette.surface);
        expect(
          contrast >= 4.5,
          isTrue,
          reason:
              'Light palette ${palette.id}: textPrimary on surface contrast is $contrast:1 (need >= 4.5:1)',
        );
      }
    });

    test('All palettes: pipeIdle on boardSurface >= 3:1', () {
      for (final palette in tokens.palettes.values) {
        final contrast = PipesTokens.contrastRatio(palette.pipeIdle, palette.boardSurface);
        expect(
          contrast >= 3.0,
          isTrue,
          reason:
              'Palette ${palette.id}: pipeIdle on boardSurface contrast is $contrast:1 (need >= 3:1)',
        );
      }
    });

    test('All dark palettes: secondary text on background >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (!palette.isDark) continue;

        final contrast = PipesTokens.contrastRatio(palette.textSecondary, palette.background);
        expect(
          contrast >= 4.5,
          isTrue,
          reason:
              'Dark palette ${palette.id}: textSecondary on background contrast is $contrast:1 (need >= 4.5:1)',
        );
      }
    });

    test('All light palettes: secondary text on background >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (palette.isDark) continue;

        final contrast = PipesTokens.contrastRatio(palette.textSecondary, palette.background);
        expect(
          contrast >= 4.5,
          isTrue,
          reason:
              'Light palette ${palette.id}: textSecondary on background contrast is $contrast:1 (need >= 4.5:1)',
        );
      }
    });

    test('All palettes: accent on background >= 3:1 (UI elements)', () {
      for (final palette in tokens.palettes.values) {
        final contrast = PipesTokens.contrastRatio(palette.accent, palette.background);
        expect(
          contrast >= 3.0,
          isTrue,
          reason:
              'Palette ${palette.id}: accent on background contrast is $contrast:1 (need >= 3:1 for UI)',
        );
      }
    });
  });
}
