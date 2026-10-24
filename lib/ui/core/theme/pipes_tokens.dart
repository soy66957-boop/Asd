// PipesTokens - Design tokens as ThemeExtension
// Three layers: primitive (raw palette numbers) -> semantic (background, surface,
// text, accent, glow, danger) -> component (button.primary.background, etc.).
// Screens use only semantic and component tokens.

import 'package:flutter/material.dart';

// ============================================================================
// PRIMITIVE LAYER — raw palette numbers
// ============================================================================

/// Raw numbers for one palette: its id, display name, hue, and base accent color.
@immutable
class PalettePrimitives {
  const PalettePrimitives({
    required this.id,
    required this.name,
    required this.hue,
    required this.baseAccent,
  });

  final String id;
  final String name;
  final double hue;
  final Color baseAccent;
}

/// Primitive tokens: raw palette numbers, keyed by palette id.
@immutable
class PrimitiveTokens {
  const PrimitiveTokens({required this.palettes});

  final Map<String, PalettePrimitives> palettes;

  PalettePrimitives of(String id) => palettes[id]!;

  double hueOf(String id) => palettes[id]!.hue;
}

// ============================================================================
// SEMANTIC LAYER — background, surface, text, accent, glow, danger
// ============================================================================

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
    required this.onAccent,
    required this.success,
    required this.danger,
    required this.star,
    required this.pipeIdle,
    required this.pipeFlow,
    required this.glowColor,
    required this.source,
    required this.boardSurface,
    required this.boardBorder,
  });

  /// Glow blur radius (design: blur 20, no spread).
  static const double glowBlur = 20.0;

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
  final Color onAccent;
  final Color success;
  final Color danger;
  final Color star;
  final Color pipeIdle;
  final Color pipeFlow;
  final Color glowColor;
  final Color source;
  final Color boardSurface;
  final Color boardBorder;
}

// ============================================================================
// COMPONENT LAYER — component-scoped tokens
// ============================================================================

@immutable
class ButtonComponentTokens {
  const ButtonComponentTokens({
    required this.primaryBackground,
    required this.primaryForeground,
    required this.secondaryBackground,
    required this.secondaryForeground,
  });

  final Color primaryBackground;
  final Color primaryForeground;
  final Color secondaryBackground;
  final Color secondaryForeground;
}

@immutable
class ComponentTokens {
  const ComponentTokens({required this.button});

  factory ComponentTokens.fromPalette(PaletteTokens palette) => ComponentTokens(
        button: ButtonComponentTokens(
          primaryBackground: palette.accent,
          primaryForeground: palette.onAccent,
          secondaryBackground: palette.surface,
          secondaryForeground: palette.textPrimary,
        ),
      );

  final ButtonComponentTokens button;
}

// ============================================================================
// SCALE TOKENS — spacing, radius, motion, curves, text
// ============================================================================

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
  double get pill => 9999;
}

/// Motion duration scale (design: feedback 120ms, state 220ms, screen 420ms)
class MotionTokens {
  const MotionTokens();

  Duration get feedback => const Duration(milliseconds: 120);
  Duration get state => const Duration(milliseconds: 220);
  Duration get screen => const Duration(milliseconds: 420);
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

// ============================================================================
// PALETTE DERIVATION (design color rules)
// ============================================================================

/// All design tokens as a ThemeExtension
@immutable
class PipesTokens extends ThemeExtension<PipesTokens> {
  const PipesTokens({
    required this.primitives,
    required this.components,
    required this.spacing,
    required this.radius,
    required this.motion,
    required this.curves,
    required this.text,
    required this.palettes,
    required this.currentPaletteId,
    required this.themeMode,
  });

  final PrimitiveTokens primitives;
  final ComponentTokens components;
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
    PrimitiveTokens? primitives,
    ComponentTokens? components,
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
      primitives: primitives ?? this.primitives,
      components: components ?? this.components,
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
    final primitives = _buildPrimitives();
    final palettes = _buildAllPalettes(primitives);
    final defaultPalette = palettes['pastelSkyDark']!;
    return PipesTokens(
      primitives: primitives,
      components: ComponentTokens.fromPalette(defaultPalette),
      spacing: const SpacingTokens(),
      radius: const RadiusTokens(),
      motion: const MotionTokens(),
      curves: const CurveTokens(),
      text: const TextTokens(),
      palettes: palettes,
      currentPaletteId: 'pastelSky',
      themeMode: ThemeMode.dark,
    );
  }

  static Map<String, PalettePrimitives> _buildPrimitives() {
    // Original palette definitions with their accent hues extracted.
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

    final primitives = <String, PalettePrimitives>{};
    for (final entry in originalPalettes.entries) {
      final id = entry.key;
      final name = entry.value['name'] as String;
      final baseAccent = entry.value['accent'] as Color;
      final hue = _extractHue(baseAccent);
      primitives[id] = PalettePrimitives(
        id: id,
        name: name,
        hue: hue,
        baseAccent: baseAccent,
      );
    }
    return primitives;
  }

  static Map<String, PaletteTokens> _buildAllPalettes(
    Map<String, PalettePrimitives> primitives,
  ) {
    final palettes = <String, PaletteTokens>{};

    for (final entry in primitives.entries) {
      final id = entry.key;
      final name = entry.value.name;
      final hue = entry.value.hue;

      // Dark variant for each palette
      palettes['${id}Dark'] = _deriveDarkPalette(id, name, hue);

      // Light variant for each palette
      palettes['${id}Light'] = _deriveLightPalette(id, name, hue);
    }

    return palettes;
  }

  /// Computes WCAG contrast ratio between two colors using Flutter's built-in luminance.
  static double contrastRatio(Color foreground, Color background) {
    final lum1 = foreground.computeLuminance();
    final lum2 = background.computeLuminance();
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Adjusts foreground color lightness in HSL space until contrast ratio against background meets minimum.
  static Color ensureContrast(Color foreground, Color background, double minRatio) {
    if (contrastRatio(foreground, background) >= minRatio) return foreground;

    final bgLum = background.computeLuminance();
    final isDarkBg = bgLum < 0.5;
    final hsl = HSLColor.fromColor(foreground);

    final step = isDarkBg ? 0.02 : -0.02;
    double lightness = hsl.lightness;

    for (int i = 0; i < 50; i++) {
      lightness = (lightness + step).clamp(0.0, 1.0);
      final adjusted = hsl.withLightness(lightness).toColor();
      if (contrastRatio(adjusted, background) >= minRatio) return adjusted;
      if ((isDarkBg && lightness >= 1.0) || (!isDarkBg && lightness <= 0.0)) break;
    }

    return isDarkBg ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  }

  static double _extractHue(Color color) => HSLColor.fromColor(color).hue;

  /// Dark accent: palette's own hue at 95% sat, 58% light, then ensureContrast >= 3:1 on background.
  static Color _accentForDark(double hue, Color background) {
    final accent = HSLColor.fromAHSL(1.0, hue, 0.95, 0.58).toColor();
    return ensureContrast(accent, background, 3.0);
  }

  /// Light accent: palette's hue darkened until white text on it is >= 4.5:1
  /// and the accent on background is >= 3:1.
  static Color _accentForLight(double hue, Color background) {
    final hsl = HSLColor.fromAHSL(1.0, hue, 1.0, 0.5);
    double lightness = 0.5;
    for (int i = 0; i < 200; i++) {
      final color = hsl.withLightness(lightness).toColor();
      if (contrastRatio(const Color(0xFFFFFFFF), color) >= 4.5 &&
          contrastRatio(color, background) >= 3.0) {
        return color;
      }
      lightness = (lightness - 0.005).clamp(0.0, 1.0);
      if (lightness <= 0.0) break;
    }
    return hsl.withLightness(0.0).toColor();
  }

  static PaletteTokens _deriveDarkPalette(String id, String name, double hue) {
    // DESIGN.md COLOR, DARK (default)
    // background = hue, 30% sat, 4% light
    // surface = hue, 26% sat, 8% light
    // hairline = white @ 10%
    // text #EAF2FF; secondary text #93A4BF; idle pipe #5B6E8F
    // neon accent = hue at 95% sat, 58% light, then ensureContrast >= 3:1 on background
    // onAccent = #07090F or white, whichever contrasts more (>= 4.5:1)
    final background = HSLColor.fromAHSL(1.0, hue, 0.30, 0.04).toColor();
    final surface = HSLColor.fromAHSL(1.0, hue, 0.26, 0.08).toColor();
    final glass = const Color(0x1AFFFFFF); // white @ 10%
    final glassBorder = const Color(0x1AFFFFFF); // white @ 10%
    const textPrimary = Color(0xFFEAF2FF);
    const baseTextSecondary = Color(0xFF93A4BF);
    const basePipeIdle = Color(0xFF5B6E8F);
    const success = Color(0xFF34D399);
    const danger = Color(0xFFFB7185);
    const star = Color(0xFFFBBF24);

    final textSecondary = ensureContrast(baseTextSecondary, background, 4.5);
    final pipeIdle = ensureContrast(basePipeIdle, surface, 3.0);
    final accent = _accentForDark(hue, background);

    final darkOnAccentCandidate = const Color(0xFF07090F);
    final whiteOnAccentCandidate = const Color(0xFFFFFFFF);
    final darkRatio = contrastRatio(darkOnAccentCandidate, accent);
    final whiteRatio = contrastRatio(whiteOnAccentCandidate, accent);
    final onAccentBase = darkRatio >= whiteRatio ? darkOnAccentCandidate : whiteOnAccentCandidate;
    final onAccent = ensureContrast(onAccentBase, accent, 4.5);

    final glowColor = accent.withValues(alpha: 0.40);

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
      onAccent: onAccent,
      success: success,
      danger: danger,
      star: star,
      pipeIdle: pipeIdle,
      pipeFlow: accent,
      glowColor: glowColor,
      source: accent,
      boardSurface: surface,
      boardBorder: glassBorder,
    );
  }

  static PaletteTokens _deriveLightPalette(String id, String name, double hue) {
    // DESIGN.md COLOR, LIGHT
    // background = hue, 40% sat, 97% light
    // surface = white; hairline = black @ 10%
    // text #0F1B2D; secondary text #475569; idle pipe #6B7C99
    // accent = hue darkened until white text on it >= 4.5:1 and accent on background >= 3:1
    final background = HSLColor.fromAHSL(1.0, hue, 0.40, 0.97).toColor();
    final surface = const Color(0xFFFFFFFF);
    final glass = const Color(0x1A000000); // black @ 10%
    final glassBorder = const Color(0x1A000000); // black @ 10%
    const textPrimary = Color(0xFF0F1B2D);
    const baseTextSecondary = Color(0xFF475569);
    const basePipeIdle = Color(0xFF6B7C99);
    const success = Color(0xFF059669);
    const danger = Color(0xFFDC2626);
    const star = Color(0xFFB45309);

    final textSecondary = ensureContrast(baseTextSecondary, background, 4.5);
    final pipeIdle = ensureContrast(basePipeIdle, surface, 3.0);
    final accent = _accentForLight(hue, background);

    final darkOnAccentCandidate = const Color(0xFF07090F);
    final whiteOnAccentCandidate = const Color(0xFFFFFFFF);
    final darkRatio = contrastRatio(darkOnAccentCandidate, accent);
    final whiteRatio = contrastRatio(whiteOnAccentCandidate, accent);
    final onAccentBase = darkRatio >= whiteRatio ? darkOnAccentCandidate : whiteOnAccentCandidate;
    final onAccent = ensureContrast(onAccentBase, accent, 4.5);

    final glowColor = accent.withValues(alpha: 0.40);

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
      onAccent: onAccent,
      success: success,
      danger: danger,
      star: star,
      pipeIdle: pipeIdle,
      pipeFlow: accent,
      glowColor: glowColor,
      source: accent,
      boardSurface: surface,
      boardBorder: glassBorder,
    );
  }
}

/// BuildContext extension for easy token access
extension TokensContext on BuildContext {
  PipesTokens get tokens => Theme.of(this).extension<PipesTokens>() ?? PipesTokens.createDefault();

  PaletteTokens get palette => tokens.currentPalette;
}
