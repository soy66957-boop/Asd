// Contrast ratio tests for all palettes
// Ensures WCAG AA compliance (4.5:1 for text, 3:1 for UI elements)

import 'package:flutter_test/flutter_test.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

void main() {
  group('PipesTokens contrast ratios', () {
    final tokens = PipesTokens.createDefault();

    test('All dark palettes: text on background >= 4.5:1', () {
      for (final palette in tokens.palettes.values) {
        if (!palette.isDark) continue;

        final contrast = _contrastRatio(palette.textPrimary, palette.background);
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

        final contrast = _contrastRatio(palette.textPrimary, palette.surface);
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

        final contrast = _contrastRatio(palette.textPrimary, palette.background);
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

        final contrast = _contrastRatio(palette.textPrimary, palette.surface);
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
        final contrast = _contrastRatio(palette.pipeIdle, palette.boardSurface);
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

        final contrast = _contrastRatio(palette.textSecondary, palette.background);
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

        final contrast = _contrastRatio(palette.textSecondary, palette.background);
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
        final contrast = _contrastRatio(palette.accent, palette.background);
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

/// Calculate WCAG contrast ratio between two colors
/// Returns ratio as X:1 (e.g., 4.5 for 4.5:1)
double _contrastRatio(Color foreground, Color background) {
  final lum1 = _relativeLuminance(foreground);
  final lum2 = _relativeLuminance(background);
  final lighter = lum1 > lum2 ? lum1 : lum2;
  final darker = lum1 > lum2 ? lum2 : lum1;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Calculate relative luminance per WCAG 2.1
double _relativeLuminance(Color color) {
  final r = _srgbToLinear(color.r / 255.0);
  final g = _srgbToLinear(color.g / 255.0);
  final b = _srgbToLinear(color.b / 255.0);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _srgbToLinear(double c) {
  if (c <= 0.03928) {
    return c / 12.92;
  }
  return ((c + 0.055) / 1.055).clamp(0.0, 1.0).pow(2.4);
}
