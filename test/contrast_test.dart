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

    void expectAllPass(String description, Iterable<PaletteTokens> palettes,
        double Function(PaletteTokens p) getRatio, double minRatio) {
      final failures = <String>[];
      for (final palette in palettes) {
        final ratio = getRatio(palette);
        if (ratio < minRatio) {
          failures.add(
            '$description - ${palette.id}: ratio ${ratio.toStringAsFixed(4)}:1 (need >= $minRatio:1)',
          );
        }
      }
      expect(failures, isEmpty, reason: failures.join('\n'));
    }

    test('All dark palettes: textPrimary on background >= 4.5:1', () {
      expectAllPass(
        'Dark palette textPrimary on background',
        tokens.palettes.values.where((p) => p.isDark),
        (p) => PipesTokens.contrastRatio(p.textPrimary, p.background),
        4.5,
      );
    });

    test('All dark palettes: textPrimary on surface >= 4.5:1', () {
      expectAllPass(
        'Dark palette textPrimary on surface',
        tokens.palettes.values.where((p) => p.isDark),
        (p) => PipesTokens.contrastRatio(p.textPrimary, p.surface),
        4.5,
      );
    });

    test('All light palettes: textPrimary on background >= 4.5:1', () {
      expectAllPass(
        'Light palette textPrimary on background',
        tokens.palettes.values.where((p) => !p.isDark),
        (p) => PipesTokens.contrastRatio(p.textPrimary, p.background),
        4.5,
      );
    });

    test('All light palettes: textPrimary on surface >= 4.5:1', () {
      expectAllPass(
        'Light palette textPrimary on surface',
        tokens.palettes.values.where((p) => !p.isDark),
        (p) => PipesTokens.contrastRatio(p.textPrimary, p.surface),
        4.5,
      );
    });

    test('All dark palettes: textSecondary on surface >= 4.5:1', () {
      expectAllPass(
        'Dark palette textSecondary on surface',
        tokens.palettes.values.where((p) => p.isDark),
        (p) => PipesTokens.contrastRatio(p.textSecondary, p.surface),
        4.5,
      );
    });

    test('All light palettes: textSecondary on surface >= 4.5:1', () {
      expectAllPass(
        'Light palette textSecondary on surface',
        tokens.palettes.values.where((p) => !p.isDark),
        (p) => PipesTokens.contrastRatio(p.textSecondary, p.surface),
        4.5,
      );
    });

    test('All palettes: pipeIdle on boardSurface >= 3:1', () {
      expectAllPass(
        'Palette pipeIdle on boardSurface',
        tokens.palettes.values,
        (p) => PipesTokens.contrastRatio(p.pipeIdle, p.boardSurface),
        3.0,
      );
    });

    test('All dark palettes: textSecondary on background >= 4.5:1', () {
      expectAllPass(
        'Dark palette textSecondary on background',
        tokens.palettes.values.where((p) => p.isDark),
        (p) => PipesTokens.contrastRatio(p.textSecondary, p.background),
        4.5,
      );
    });

    test('All light palettes: textSecondary on background >= 4.5:1', () {
      expectAllPass(
        'Light palette textSecondary on background',
        tokens.palettes.values.where((p) => !p.isDark),
        (p) => PipesTokens.contrastRatio(p.textSecondary, p.background),
        4.5,
      );
    });

    test('All palettes: accent on background >= 3:1 (UI elements)', () {
      expectAllPass(
        'Palette accent on background',
        tokens.palettes.values,
        (p) => PipesTokens.contrastRatio(p.accent, p.background),
        3.0,
      );
    });

    test('All palettes: onAccent on accent >= 4.5:1', () {
      expectAllPass(
        'Palette onAccent on accent',
        tokens.palettes.values,
        (p) => PipesTokens.contrastRatio(p.onAccent, p.accent),
        4.5,
      );
    });
  });
}
