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
    required this.primaryGlowColor,
    required this.primaryGlowBlur,
    required this.secondaryBackground,
    required this.secondaryForeground,
    required this.secondaryBorder,
    required this.ghostForeground,
    required this.dangerBorder,
    required this.dangerForeground,
    required this.disabledBorder,
    required this.disabledForeground,
    required this.loadingSpinnerColor,
    required this.height,
    required this.radius,
    required this.pressedScale,
    required this.glowOpacityDefault,
    required this.glowOpacityPressed,
    required this.selectedBorder,
    required this.selectedGlowOpacity,
    required this.errorBorder,
  });

  // Primary
  final Color primaryBackground;
  final Color primaryForeground;
  final Color primaryGlowColor;
  final double primaryGlowBlur;
  // Secondary
  final Color secondaryBackground;
  final Color secondaryForeground;
  final Color secondaryBorder;
  // Ghost
  final Color ghostForeground;
  // Danger
  final Color dangerBorder;
  final Color dangerForeground;
  // States
  final Color disabledBorder;
  final Color disabledForeground;
  final Color loadingSpinnerColor;
  // Geometry
  final double height;
  final double radius;
  final double pressedScale;
  // Glow
  final double glowOpacityDefault;
  final double glowOpacityPressed;
  // Selected
  final Color selectedBorder;
  final double selectedGlowOpacity;
  // Error
  final Color errorBorder;
}

@immutable
class IconButtonComponentTokens {
  const IconButtonComponentTokens({
    required this.size,
    required this.hitSize,
    required this.iconSize,
    required this.background,
    required this.border,
    required this.iconColor,
    required this.hoverBackground,
    required this.focusedBackground,
    required this.pressedBackground,
    required this.disabledBackground,
    required this.disabledBorder,
    required this.disabledIconColor,
    required this.radius,
  });

  final double size;
  final double hitSize;
  final double iconSize;
  final Color background;
  final Color border;
  final Color iconColor;
  final Color hoverBackground;
  final Color focusedBackground;
  final Color pressedBackground;
  final Color disabledBackground;
  final Color disabledBorder;
  final Color disabledIconColor;
  final double radius;
}

@immutable
class SurfaceComponentTokens {
  const SurfaceComponentTokens({
    required this.background,
    required this.border,
    required this.radius,
    required this.glowColor,
    required this.glowBlur,
    required this.aliveGlowOpacity,
  });

  final Color background;
  final Color border;
  final double radius;
  final Color glowColor;
  final double glowBlur;
  final double aliveGlowOpacity;
}

@immutable
class PillComponentTokens {
  const PillComponentTokens({
    required this.height,
    required this.horizontalPadding,
    required this.border,
    required this.borderWidth,
    required this.textColor,
    required this.radius,
  });

  final double height;
  final double horizontalPadding;
  final Color border;
  final double borderWidth;
  final Color textColor;
  final double radius;
}

@immutable
class ToggleComponentTokens {
  const ToggleComponentTokens({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbSize,
    required this.offTrackColor,
    required this.offThumbColor,
    required this.onTrackColor,
    required this.onThumbColor,
    required this.onGlowColor,
    required this.onGlowBlur,
    required this.disabledTrackColor,
    required this.disabledThumbColor,
    required this.hitWidth,
    required this.hitHeight,
    required this.animationDuration,
  });

  final double trackWidth;
  final double trackHeight;
  final double thumbSize;
  final Color offTrackColor;
  final Color offThumbColor;
  final Color onTrackColor;
  final Color onThumbColor;
  final Color onGlowColor;
  final double onGlowBlur;
  final Color disabledTrackColor;
  final Color disabledThumbColor;
  final double hitWidth;
  final double hitHeight;
  final Duration animationDuration;
}

@immutable
class SwatchComponentTokens {
  const SwatchComponentTokens({
    required this.size,
    required this.background,
    required this.ringWidth,
    required this.ringColor,
    required this.centerDotSize,
    required this.selectedRingWidth,
    required this.selectedGlowColor,
    required this.selectedGlowBlur,
    required this.radius,
  });

  final double size;
  final Color background;
  final double ringWidth;
  final Color ringColor;
  final double centerDotSize;
  final double selectedRingWidth;
  final Color selectedGlowColor;
  final double selectedGlowBlur;
  final double radius;
}

@immutable
class LevelTileComponentTokens {
  const LevelTileComponentTokens({
    required this.size,
    required this.radius,
    required this.lockedBorder,
    required this.lockedIconColor,
    required this.unlockedTextColor,
    required this.currentBorder,
    required this.currentTextColor,
    required this.currentGlowColor,
    required this.currentGlowBlur,
    required this.completedTextColor,
    required this.completedDotColor,
    required this.completedDotSize,
    required this.borderWidth,
    required this.currentBorderWidth,
  });

  final double size;
  final double radius;
  final Color lockedBorder;
  final Color lockedIconColor;
  final Color unlockedTextColor;
  final Color currentBorder;
  final Color currentTextColor;
  final Color currentGlowColor;
  final double currentGlowBlur;
  final Color completedTextColor;
  final Color completedDotColor;
  final double completedDotSize;
  final double borderWidth;
  final double currentBorderWidth;
}

@immutable
class HeaderComponentTokens {
  const HeaderComponentTokens({
    required this.height,
    required this.slotWidth,
  });

  final double height;
  final double slotWidth;
}

@immutable
class PipeTokens {
  const PipeTokens({
    required this.tubeWidthRatio,
    required this.coreRatio,
    required this.highlightAlpha,
    required this.glowAlphas,
    required this.glowWidthRatios,
    required this.shimmerPeriod,
    required this.fillDuration,
    required this.fillStagger,
    required this.springStiffness,
    required this.springDamping,
    required this.winWaveStep,
    required this.winPulseScale,
  });

  final double tubeWidthRatio;
  final double coreRatio;
  final double highlightAlpha;
  final List<double> glowAlphas;
  final List<double> glowWidthRatios;
  final Duration shimmerPeriod;
  final Duration fillDuration;
  final Duration fillStagger;
  final double springStiffness;
  final double springDamping;
  final Duration winWaveStep;
  final double winPulseScale;

  static PipeTokens fromPalette(PaletteTokens palette) => PipeTokens(
        tubeWidthRatio: 0.26,
        coreRatio: 0.5,
        highlightAlpha: 0.12,
        glowAlphas: [0.06, 0.10, 0.16],
        glowWidthRatios: [1.9, 1.5, 1.2],
        shimmerPeriod: const Duration(milliseconds: 2400),
        fillDuration: const Duration(milliseconds: 220), // state token
        fillStagger: const Duration(milliseconds: 60),
        springStiffness: 420,
        springDamping: 28,
        winWaveStep: const Duration(milliseconds: 45),
        winPulseScale: 1.06,
      );
}

@immutable
class ComponentTokens {
  const ComponentTokens({
    required this.button,
    required this.iconButton,
    required this.surface,
    required this.pill,
    required this.toggle,
    required this.swatch,
    required this.levelTile,
    required this.header,
    required this.pipe,
  });

  factory ComponentTokens.fromPalette(PaletteTokens palette) => ComponentTokens(
        button: ButtonComponentTokens(
          // Primary
          primaryBackground: palette.accent,
          primaryForeground: palette.onAccent,
          primaryGlowColor: palette.glowColor,
          primaryGlowBlur: PaletteTokens.glowBlur,
          // Secondary
          secondaryBackground: palette.surface,
          secondaryForeground: palette.textPrimary,
          secondaryBorder: palette.glassBorder,
          // Ghost
          ghostForeground: palette.accent,
          // Danger
          dangerBorder: palette.danger.withValues(alpha: 0.5),
          dangerForeground: palette.danger,
          // States
          disabledBorder: palette.glassBorder.withValues(alpha: 0.5),
          disabledForeground: palette.textSecondary.withValues(alpha: 0.5),
          loadingSpinnerColor: palette.onAccent,
          // Geometry
          height: 48.0,
          radius: 9999.0, // pill
          pressedScale: 0.97,
          // Glow
          glowOpacityDefault: 0.40,
          glowOpacityPressed: 0.60,
          // Selected
          selectedBorder: palette.accent,
          selectedGlowOpacity: 0.30,
          // Error
          errorBorder: palette.danger,
        ),
        iconButton: IconButtonComponentTokens(
          size: 44.0,
          hitSize: 48.0,
          iconSize: 20.0,
          background: palette.surface,
          border: palette.glassBorder,
          iconColor: palette.textPrimary,
          hoverBackground: palette.glass,
          focusedBackground: palette.glass,
          pressedBackground: palette.glass.withValues(alpha: 0.2),
          disabledBackground: palette.surface.withValues(alpha: 0.5),
          disabledBorder: palette.glassBorder.withValues(alpha: 0.5),
          disabledIconColor: palette.textSecondary.withValues(alpha: 0.5),
          radius: 9999.0,
        ),
        surface: SurfaceComponentTokens(
          background: palette.surface,
          border: palette.glassBorder,
          radius: 20.0,
          glowColor: palette.glowColor,
          glowBlur: PaletteTokens.glowBlur,
          aliveGlowOpacity: 0.40,
        ),
        pill: PillComponentTokens(
          height: 28.0,
          // horizontalPadding = 16dp (content) - 1.5dp (border) = 14.5dp so total rendered width = text + 32dp
          horizontalPadding: 14.5,
          border: palette.glassBorder,
          borderWidth: 1.5,
          textColor: palette.textPrimary,
          radius: 9999.0,
        ),
        toggle: ToggleComponentTokens(
          trackWidth: 52.0,
          trackHeight: 32.0,
          thumbSize: 24.0,
          offTrackColor: palette.glassBorder,
          offThumbColor: palette.textSecondary,
          onTrackColor: palette.accent.withValues(alpha: 0.2),
          onThumbColor: palette.accent,
          onGlowColor: palette.glowColor,
          onGlowBlur: PaletteTokens.glowBlur,
          disabledTrackColor: palette.glassBorder.withValues(alpha: 0.5),
          disabledThumbColor: palette.textSecondary.withValues(alpha: 0.5),
          hitWidth: 56.0,
          hitHeight: 48.0,
          animationDuration: Duration(milliseconds: 120),
        ),
        swatch: SwatchComponentTokens(
          size: 44.0,
          background: palette.surface,
          ringWidth: 2.0,
          ringColor: palette.glassBorder,
          centerDotSize: 8.0,
          selectedRingWidth: 3.0,
          selectedGlowColor: palette.glowColor,
          selectedGlowBlur: PaletteTokens.glowBlur,
          radius: 9999.0,
        ),
        levelTile: LevelTileComponentTokens(
          size: 56.0,
          radius: 16.0,
          lockedBorder: palette.glassBorder,
          lockedIconColor: palette.textSecondary.withValues(alpha: 0.6),
          unlockedTextColor: palette.textPrimary,
          currentBorder: palette.accent,
          currentTextColor: palette.textPrimary,
          currentGlowColor: palette.glowColor,
          currentGlowBlur: PaletteTokens.glowBlur,
          completedTextColor: palette.textPrimary,
          completedDotColor: palette.accent,
          completedDotSize: 8.0,
          borderWidth: 1.5,
          currentBorderWidth: 2.5,
        ),
        header: HeaderComponentTokens(
          height: 56.0,
          slotWidth: 56.0,
        ),
        pipe: PipeTokens.fromPalette(palette),
      );

  final ButtonComponentTokens button;
  final IconButtonComponentTokens iconButton;
  final SurfaceComponentTokens surface;
  final PillComponentTokens pill;
  final ToggleComponentTokens toggle;
  final SwatchComponentTokens swatch;
  final LevelTileComponentTokens levelTile;
  final HeaderComponentTokens header;
  final PipeTokens pipe;
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
  double get lg => 28;
  double get pill => 9999;
}

/// Motion duration scale (design: feedback 120ms, state 220ms, screen 420ms, celebration 3000ms, hintDisplay 1600ms)
class MotionTokens {
  const MotionTokens();

  Duration get feedback => const Duration(milliseconds: 120);
  Duration get state => const Duration(milliseconds: 220);
  Duration get screen => const Duration(milliseconds: 420);
  Duration get celebration => const Duration(milliseconds: 3000);
  Duration get hintDisplay => const Duration(milliseconds: 1600);
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
    final newPaletteId = currentPaletteId ?? this.currentPaletteId;
    final newThemeMode = themeMode ?? this.themeMode;
    final newPalettes = palettes ?? this.palettes;
    
    // Regenerate components if palette or theme mode changed
    final paletteChanged = newPaletteId != this.currentPaletteId || newThemeMode != this.themeMode;
    final ComponentTokens effectiveComponents;
    if (components != null) {
      effectiveComponents = components;
    } else if (paletteChanged) {
      final suffix = newThemeMode == ThemeMode.dark ? 'Dark' : 'Light';
      effectiveComponents = ComponentTokens.fromPalette(newPalettes['$newPaletteId$suffix']!);
    } else {
      effectiveComponents = this.components!;
    }

    return PipesTokens(
      primitives: primitives ?? this.primitives,
      components: effectiveComponents,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      motion: motion ?? this.motion,
      curves: curves ?? this.curves,
      text: text ?? this.text,
      palettes: newPalettes,
      currentPaletteId: newPaletteId,
      themeMode: newThemeMode,
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
      primitives: PrimitiveTokens(palettes: primitives),
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
    const baseTextPrimary = Color(0xFFEAF2FF);
    const baseTextSecondary = Color(0xFF93A4BF);

    // Ensure textPrimary meets 4.5:1 on background (fixed color may not suffice for all hues).
    final textPrimary = ensureContrast(baseTextPrimary, background, 4.5);
    const basePipeIdle = Color(0xFF5B6E8F);
    const success = Color(0xFF34D399);
    const danger = Color(0xFFFB7185);
    const star = Color(0xFFFBBF24);

    // Ensure textSecondary meets 4.5:1 on BOTH background and surface.
    // Compute luminance of both backgrounds; for dark theme, the one with HIGHER luminance
    // requires a LIGHTER foreground (more stringent). Ensure on that one first.
    final bgLum = background.computeLuminance();
    final surfaceLum = surface.computeLuminance();
    final primaryBg = bgLum > surfaceLum ? background : surface;
    final secondaryBg = bgLum > surfaceLum ? surface : background;
    final textSecondaryOnPrimary = ensureContrast(baseTextSecondary, primaryBg, 4.5);
    final textSecondary = ensureContrast(textSecondaryOnPrimary, secondaryBg, 4.5);
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
    const baseTextPrimary = Color(0xFF0F1B2D);
    const baseTextSecondary = Color(0xFF475569);

    // Ensure textPrimary meets 4.5:1 on background (fixed color may not suffice for all hues).
    final textPrimary = ensureContrast(baseTextPrimary, background, 4.5);
    const basePipeIdle = Color(0xFF6B7C99);
    const success = Color(0xFF059669);
    const danger = Color(0xFFDC2626);
    const star = Color(0xFFB45309);

    // Ensure textSecondary meets 4.5:1 on BOTH background and surface.
    // For light theme, the background with LOWER luminance requires a DARKER foreground (more stringent).
    final bgLum = background.computeLuminance();
    final surfaceLum = surface.computeLuminance();
    final primaryBg = bgLum < surfaceLum ? background : surface;
    final secondaryBg = bgLum < surfaceLum ? surface : background;
    final textSecondaryOnPrimary = ensureContrast(baseTextSecondary, primaryBg, 4.5);
    final textSecondary = ensureContrast(textSecondaryOnPrimary, secondaryBg, 4.5);
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

  PipeTokens get pipeTokens => tokens.components.pipe;
}
