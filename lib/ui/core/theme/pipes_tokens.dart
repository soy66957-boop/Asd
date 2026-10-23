// PipesTokens - Design tokens as ThemeExtension
// All colors, spacing, radii, motion, typography defined here.
// Screens read tokens via context.tokens extension.

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

  static String _formatName(String id) {
    return id
        .split(/(?=[A-Z])/)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static PaletteTokens _deriveDarkPalette(String id, String name, double hue) {
    // Dark theme derivation from accent hue
    // background = hue, 40% sat, 7% light
    // surface = hue, 35%, 11%
    // glass = white @ 8% with 1px border of white @ 14%
    // text primary #E8F1FF, text secondary #9FB3CF
    // accent: use bright accent per spec
    // success #34D399, danger #FB7185, star #FBBF24
    // pipeIdle #5B6E8F, pipeFlow = accent, pipeGlow = accent @ 40%
    // source = accent, boardSurface = surface, boardBorder = glass border

    final accent = _getDarkAccent(id, hue);
    final background = HSLColor.fromAHSL(1.0, hue, 0.40, 0.07).toColor();
    final surface = HSLColor.fromAHSL(1.0, hue, 0.35, 0.11).toColor();
    final glass = const Color(0x14FFFFFF); // white @ 8%
    final glassBorder = const Color(0x24FFFFFF); // white @ 14%
    final textPrimary = const Color(0xFFE8F1FF);
    final textSecondary = const Color(0xFF9FB3CF);
    final success = const Color(0xFF34D399);
    final danger = const Color(0xFFFB7185);
    final star = const Color(0xFFFBBF24);

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
      pipeIdle: const Color(0xFF5B6E8F),
      pipeFlow: accent,
      pipeGlow: accent.withValues(alpha: 0.40),
      source: accent,
      boardSurface: surface,
      boardBorder: glassBorder,
    );
  }

  static PaletteTokens _deriveLightPalette(String id, String name, double hue) {
    // Light theme derivation
    // background = hue, 60%, 96%
    // text #0F1B2D
    // accent darkened until white text on it reaches 4.5:1
    // success #34D399 -> darkened to #059669, danger #FB7185 -> #DC2626, star #FBBF24 -> #B45309
    // pipeIdle #6B7C99 (light), pipeFlow = accent, pipeGlow = accent @ 40%
    // source = accent, boardSurface = surface, boardBorder = glass border

    final background = HSLColor.fromAHSL(1.0, hue, 0.60, 0.96).toColor();
    final surface = HSLColor.fromAHSL(1.0, hue, 0.55, 0.92).toColor();
    final glass = const Color(0x14000000); // black @ 8%
    final glassBorder = const Color(0x24000000); // black @ 14%
    final textPrimary = const Color(0xFF0F1B2D);
    final textSecondary = const Color(0xFF4A5D7A);
    final accent = _getLightAccent(id, hue);
    final success = const Color(0xFF059669); // Darkened for 4.5:1 on white
    final danger = const Color(0xFFDC2626); // Darkened for 4.5:1 on white
    final star = const Color(0xFFB45309); // Darkened for 4.5:1 on white

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
      pipeIdle: const Color(0xFF6B7C99),
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
