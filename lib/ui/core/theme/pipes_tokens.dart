// PipesTokens - Design tokens as ThemeExtension
// All colors, spacing, radii, motion, typography defined here.
// Screens read tokens via context.tokens extension.

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Spacing scale (multiples of 4)
class SpacingTokens {
  const SpacingTokens();

  double get xs => 4;
  double get sm => 8;
  double get md => 12;
  double get lg => 16;
  double get xl => 24;
  double get xxl => 32;
}

/// Border radius scale
class RadiusTokens {
  const RadiusTokens();

  double get sm => 12;
  double get md => 20;
  double get lg => 28;
  double get pill => 9999;
}

/// Motion duration scale
class MotionTokens {
  const MotionTokens();

  Duration get fast => const Duration(milliseconds: 120);
  Duration get base => const Duration(milliseconds: 220);
  Duration get slow => const Duration(milliseconds: 420);
}

/// Motion curves
class CurveTokens {
  const CurveTokens();

  Curve get easeOutCubic => Curves.easeOutCubic;
  Curve get overshoot => Curves.elasticOut;
}

/// Text style scale
class TextTokens {
  const TextTokens();

  TextStyle get display => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  TextStyle get title => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );

  TextStyle get body => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  TextStyle get label => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  TextStyle get button => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  TextStyle get caption => const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}

/// Semantic color tokens for a single palette variant (dark or light)
@immutable
class PaletteTokens {
  const PaletteTokens({
    required this.id,
    required this.name,
    required this.isDark,
    required this.background,
    required this.surface,
    required this.glass,
    required this.glassBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.success,
    required this.danger,
    required this.star,
    // Game-specific tokens
    required this.pipeIdle,
    required this.pipeFlow,
    required this.pipeGlow,
    required this.source,
    required this.boardSurface,
    required this.boardBorder,
  });

  final String id;
  final String name;
  final bool isDark;
  final Color background;
  final Color surface;
  final Color glass;
  final Color glassBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color success;
  final Color danger;
  final Color star;

  // Game tokens
  final Color pipeIdle;
  final Color pipeFlow;
  final Color pipeGlow;
  final Color source;
  final Color boardSurface;
  final Color boardBorder;
}

/// All design tokens as a ThemeExtension
@immutable
class PipesTokens extends ThemeExtension<PipesTokens> {
  const PipesTokens({
    required this.spacing,
    required this.radius,
    required this.motion,
    required this.curves,
    required this.text,
    required this.palettes,
    required this.currentPaletteId,
    required this.themeMode,
  });

  final SpacingTokens spacing;
  final RadiusTokens radius;
  final MotionTokens motion;
  final CurveTokens curves;
  final TextTokens text;
  final Map<String, PaletteTokens> palettes;
  final String currentPaletteId;
  final ThemeMode themeMode;

  PaletteTokens get currentPalette {
    final mode = themeMode == ThemeMode.dark ? 'Dark' : 'Light';
    return palettes['$currentPaletteId$mode']!;
  }

  PaletteTokens getCurrentPalette(ThemeMode mode) {
    final suffix = mode == ThemeMode.dark ? 'Dark' : 'Light';
    return palettes['$currentPaletteId$suffix']!;
  }

  @override
  PipesTokens copyWith({
    SpacingTokens? spacing,
    RadiusTokens? radius,
    MotionTokens? motion,
    CurveTokens? curves,
    TextTokens? text,
    Map<String, PaletteTokens>? palettes,
    String? currentPaletteId,
    ThemeMode? themeMode,
  }) {
    return PipesTokens(
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      motion: motion ?? this.motion,
      curves: curves ?? this.curves,
      text: text ?? this.text,
      palettes: palettes ?? this.palettes,
      currentPaletteId: currentPaletteId ?? this.currentPaletteId,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  PipesTokens lerp(ThemeExtension<PipesTokens>? other, double t) {
    if (other is! PipesTokens) return this;
    return copyWith(
      currentPaletteId: t < 0.5 ? currentPaletteId : other.currentPaletteId,
      themeMode: t < 0.5 ? themeMode : other.themeMode,
    );
  }

  static PipesTokens createDefault() {
    return PipesTokens(
      spacing: const SpacingTokens(),
      radius: const RadiusTokens(),
      motion: const MotionTokens(),
      curves: const CurveTokens(),
      text: const TextTokens(),
      palettes: _buildAllPalettes(),
      currentPaletteId: 'pastelSky',
      themeMode: ThemeMode.dark,
    );
  }

  static Map<String, PaletteTokens> _buildAllPalettes() {
    final palettes = <String, PaletteTokens>{};

    // Original palette definitions with their accent hues extracted
    // Each entry: id -> {displayName, accentColor}
    final originalPalettes = {
      'pastelMint': {'name': 'Mint & Sage', 'accent': const Color(0xFF388E3C)},
      'pastelPeach': {'name': 'Warm Peach', 'accent': const Color(0xFFE65100)},
      'pastelLavender': {'name': 'Soft Lavender', 'accent': const Color(0xFF7B1FA2)},
      'pastelSky': {'name': 'Cloud Sky', 'accent': const Color(0xFF0288D1)},
      'pastelRose': {'name': 'Pastel Rose', 'accent': const Color(0xFFC2185B)},
      'pastelButter': {'name': 'Honey Butter', 'accent': const Color(0xFFF57F17)},
      'pastelCoral': {'name': 'Sweet Coral', 'accent': const Color(0xFFD84315)},
      'pastelOcean': {'name': 'Aqua Breeze', 'accent': const Color(0xFF00695C)},
      'obsidian': {'name': 'Obsidian Dark', 'accent': const Color(0xFF81C784)},
    };

    for (final entry in originalPalettes.entries) {
      final id = entry.key;
      final name = entry.value['name'] as String;
      final accentColor = entry.value['accent'] as Color;
      final hue = _extractHue(accentColor);

      // Dark variant for each palette
      palettes['${id}Dark'] = _deriveDarkPalette(id, name, hue);

      // Light variant for each palette
      palettes['${id}Light'] = _deriveLightPalette(id, name, hue);
    }

    return palettes;
  }

  static double _extractHue(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.hue;
  }

  /// Adjusts foreground color luminance until contrast ratio against background meets minimum.
  /// Returns the adjusted foreground color. Preserves hue as much as possible.
  static Color ensureContrast(Color foreground, Color background, double minRatio) {
    double ratio = _contrastRatio(foreground, background);
    if (ratio >= minRatio) return foreground;

    final bgLum = _relativeLuminance(background);
    final fgLum = _relativeLuminance(foreground);
    final needLighter = fgLum > bgLum;

    // Target luminance for desired contrast:
    // If fg is lighter: L_fg = minRatio * (L_bg + 0.05) - 0.05
    // If fg is darker: L_fg = (L_bg + 0.05) / minRatio - 0.05
    double targetLum = needLighter
        ? minRatio * (bgLum + 0.05) - 0.05
        : (bgLum + 0.05) / minRatio - 0.05;
    targetLum = targetLum.clamp(0.0, 1.0);

    // Fast path: scale RGB toward target luminance
    double scale = targetLum / fgLum;
    if (scale > 2.0) scale = 2.0;
    if (scale < 0.5) scale = 0.5;
    int r = (foreground.r * scale).round().clamp(0, 255);
    int g = (foreground.g * scale).round().clamp(0, 255);
    int b = (foreground.b * scale).round().clamp(0, 255);

    Color adjusted = Color.fromARGB(255, r, g, b);
    double newRatio = _contrastRatio(adjusted, background);
    if (newRatio >= minRatio) return adjusted;

    // Guaranteed fallback: white on dark, black on light always meets WCAG AA
    return needLighter ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  }

  static double _contrastRatio(Color foreground, Color background) {
    final lum1 = _relativeLuminance(foreground);
    final lum2 = _relativeLuminance(background);
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  static double _relativeLuminance(Color color) {
    double sr = _srgbToLinear(color.r / 255.0);
    double sg = _srgbToLinear(color.g / 255.0);
    double sb = _srgbToLinear(color.b / 255.0);
    return 0.2126 * sr + 0.7152 * sg + 0.0722 * sb;
  }

  static double _srgbToLinear(double c) {
    if (c <= 0.03928) return c / 12.92;
    return math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Public contrast ratio for testing
  static double contrastRatio(Color foreground, Color background) => _contrastRatio(foreground, background);

  static PaletteTokens _deriveDarkPalette(String id, String name, double hue) {
    // Dark theme derivation from accent hue per spec
    // background = hue, 40% sat, 7% light
    // surface = hue, 35%, 11%
    // glass = white @ 8% with 1px border of white @ 14%
    // text primary #E8F1FF, text secondary #9FB3CF (ensure 4.5:1 on background)
    // accent: bright accent per spec (ensure 3:1 on background for UI)
    // success #34D399, danger #FB7185, star #FBBF24
    // pipeIdle #5B6E8F (ensure 3:1 on boardSurface), pipeFlow = accent, pipeGlow = accent @ 40%
    // source = accent, boardSurface = surface, boardBorder = glass border

    final baseAccent = _getDarkAccent(id, hue);
    final background = HSLColor.fromAHSL(1.0, hue, 0.40, 0.07).toColor();
    final surface = HSLColor.fromAHSL(1.0, hue, 0.35, 0.11).toColor();
    final glass = const Color(0x14FFFFFF); // white @ 8%
    final glassBorder = const Color(0x24FFFFFF); // white @ 14%
    const textPrimary = Color(0xFFE8F1FF);
    const baseTextSecondary = Color(0xFF9FB3CF);
    const basePipeIdle = Color(0xFF5B6E8F);
    const success = Color(0xFF34D399);
    const danger = Color(0xFFFB7185);
    const star = Color(0xFFFBBF24);

    // Ensure contrast for textSecondary on background (4.5:1)
    final textSecondary = ensureContrast(baseTextSecondary, background, 4.5);
    // Ensure contrast for pipeIdle on boardSurface (3:1)
    final pipeIdle = ensureContrast(basePipeIdle, surface, 3.0);
    // Ensure contrast for accent on background (3:1 for UI elements)
    final accent = ensureContrast(baseAccent, background, 3.0);

    return PaletteTokens(
      id: '${id}Dark',
      name: '$name (Dark)',
      isDark: true,
      background: background,
      surface: surface,
      glass: glass,
      glassBorder: glassBorder,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      accent: accent,
      success: success,
      danger: danger,
      star: star,
      pipeIdle: pipeIdle,
      pipeFlow: accent,
      pipeGlow: accent.withValues(alpha: 0.40),
      source: accent,
      boardSurface: surface,
      boardBorder: glassBorder,
    );
  }

  static PaletteTokens _deriveLightPalette(String id, String name, double hue) {
    // Light theme derivation per spec:
    // background = hue, 60%, 96%
    // surface = hue, 45%, 92%
    // text primary #0F1B2D
    // text secondary #475569 (ensure 4.5:1 on background)
    // accent darkened until white text on it reaches 4.5:1
    // pipeIdle #6B7C99 (ensure 3:1 on boardSurface)
    // boardSurface = surface

    final background = HSLColor.fromAHSL(1.0, hue, 0.60, 0.96).toColor();
    final surface = HSLColor.fromAHSL(1.0, hue, 0.45, 0.92).toColor();
    final glass = const Color(0x14000000); // black @ 8%
    final glassBorder = const Color(0x24000000); // black @ 14%
    const textPrimary = Color(0xFF0F1B2D);
    const baseTextSecondary = Color(0xFF475569);
    const basePipeIdle = Color(0xFF6B7C99);
    final baseAccent = _getLightAccent(id, hue);
    const success = Color(0xFF059669);
    const danger = Color(0xFFDC2626);
    const star = Color(0xFFB45309);

    // Ensure contrast for textSecondary on background (4.5:1)
    final textSecondary = ensureContrast(baseTextSecondary, background, 4.5);
    // Ensure contrast for pipeIdle on boardSurface (3:1)
    final pipeIdle = ensureContrast(basePipeIdle, surface, 3.0);
    // Ensure contrast for accent on background (3:1 for UI elements)
    final accent = ensureContrast(baseAccent, background, 3.0);

    return PaletteTokens(
      id: '${id}Light',
      name: '$name (Light)',
      isDark: false,
      background: background,
      surface: surface,
      glass: glass,
      glassBorder: glassBorder,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      accent: accent,
      success: success,
      danger: danger,
      star: star,
      pipeIdle: pipeIdle,
      pipeFlow: accent,
      pipeGlow: accent.withValues(alpha: 0.40),
      source: accent,
      boardSurface: surface,
      boardBorder: glassBorder,
    );
  }

  static Color _getDarkAccent(String id, double hue) {
    // Use the specified bright accents for dark mode
    switch (id) {
      case 'pastelMint':
        return const Color(0xFF34D399); // green
      case 'pastelPeach':
        return const Color(0xFFFB923C); // orange
      case 'pastelLavender':
        return const Color(0xFFA78BFA); // purple
      case 'pastelSky':
        return const Color(0xFF22D3EE); // aqua (default for new installs)
      case 'pastelRose':
        return const Color(0xFFF472B6); // pink
      case 'pastelButter':
        return const Color(0xFFFACC15); // yellow
      case 'pastelCoral':
        return const Color(0xFFFF7A59); // deep orange
      case 'pastelOcean':
        return const Color(0xFF22D3EE); // aqua
      case 'obsidian':
        return const Color(0xFF34D399); // green
      default:
        return const Color(0xFF22D3EE); // aqua default
    }
  }

  static Color _getLightAccent(String id, double hue) {
    // Light accents - darkened versions that pass 4.5:1 with white text
    switch (id) {
      case 'pastelMint':
        return const Color(0xFF166534); // dark green
      case 'pastelPeach':
        return const Color(0xFF9A3412); // dark orange
      case 'pastelLavender':
        return const Color(0xFF6B21A8); // dark purple
      case 'pastelSky':
        return const Color(0xFF0369A1); // dark blue
      case 'pastelRose':
        return const Color(0xFFBE185D); // dark pink
      case 'pastelButter':
        return const Color(0xFF854D0E); // dark yellow/amber
      case 'pastelCoral':
        return const Color(0xFF9A3412); // dark coral/orange
      case 'pastelOcean':
        return const Color(0xFF004D40); // dark teal
      case 'obsidian':
        return const Color(0xFF166534); // dark green
      default:
        return const Color(0xFF0369A1); // dark blue default
    }
  }
}

/// BuildContext extension for easy token access
extension TokensContext on BuildContext {
  PipesTokens get tokens => Theme.of(this).extension<PipesTokens>() ?? PipesTokens.createDefault();
  
  PaletteTokens get palette => tokens.currentPalette;
}
