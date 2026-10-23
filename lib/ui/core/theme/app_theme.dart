// ThemeData builder from PipesTokens
// Maintains no-transition page routes and applies tokens to component themes.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

class _NoTransitionBuilder extends PageTransitionsBuilder {
  const _NoTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class AppTheme {
  AppTheme._();

  static const _noTransitionTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _NoTransitionBuilder(),
      TargetPlatform.iOS: _NoTransitionBuilder(),
      TargetPlatform.linux: _NoTransitionBuilder(),
      TargetPlatform.macOS: _NoTransitionBuilder(),
      TargetPlatform.windows: _NoTransitionBuilder(),
      TargetPlatform.fuchsia: _NoTransitionBuilder(),
    },
  );

  /// Build ThemeData from PipesTokens
  static ThemeData fromTokens(PipesTokens tokens) {
    final palette = tokens.currentPalette;
    final isDark = palette.isDark;

    final baseTextTheme = _buildTextTheme(palette, tokens.text);

    return ThemeData(
      pageTransitionsTheme: _noTransitionTheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: palette.accent,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: palette.accent,
        onSecondary: isDark ? Colors.black : Colors.white,
        error: palette.danger,
        onError: Colors.white,
        surface: palette.surface,
        onSurface: palette.textPrimary,
        outline: palette.glassBorder,
        shadow: Colors.black.withValues(alpha: 0.3),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      dividerTheme: DividerThemeData(
        color: palette.glassBorder,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          side: BorderSide(color: palette.glassBorder, width: 1.5),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.12),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.xl,
            vertical: tokens.spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radius.md),
          ),
          textStyle: tokens.text.button.copyWith(color: isDark ? Colors.black : Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.glassBorder, width: 1.5),
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.xl,
            vertical: tokens.spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radius.md),
          ),
          textStyle: tokens.text.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacing.lg,
            vertical: tokens.spacing.sm,
          ),
          textStyle: tokens.text.label.copyWith(color: palette.accent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          borderSide: BorderSide(color: palette.glassBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          borderSide: BorderSide(color: palette.glassBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radius.md),
          borderSide: BorderSide(color: palette.accent, width: 2),
        ),
        labelStyle: tokens.text.label.copyWith(color: palette.textSecondary),
        hintStyle: tokens.text.body.copyWith(color: palette.textSecondary.withValues(alpha: 0.6)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radius.lg),
          side: BorderSide(color: palette.glassBorder, width: 1.5),
        ),
        titleTextStyle: tokens.text.title.copyWith(color: palette.textPrimary),
        contentTextStyle: tokens.text.body.copyWith(color: palette.textSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radius.lg),
          ),
          side: BorderSide(color: palette.glassBorder, width: 1.5),
        ),
        modalBackgroundColor: palette.background,
      ),
      textTheme: baseTextTheme,
      extensions: [tokens],
    );
  }

  static TextTheme _buildTextTheme(PaletteTokens palette, TextTokens textTokens) {
    final primary = palette.textPrimary;
    final secondary = palette.textSecondary;

    return TextTheme(
      displayLarge: textTokens.display.copyWith(color: primary),
      displayMedium: textTokens.display.copyWith(fontSize: 28, color: primary),
      displaySmall: textTokens.display.copyWith(fontSize: 24, color: primary),
      headlineLarge: textTokens.title.copyWith(fontSize: 28, color: primary),
      headlineMedium: textTokens.title.copyWith(fontSize: 24, color: primary),
      headlineSmall: textTokens.title.copyWith(fontSize: 20, color: primary),
      titleLarge: textTokens.title.copyWith(color: primary),
      titleMedium: textTokens.title.copyWith(fontSize: 18, color: primary),
      titleSmall: textTokens.label.copyWith(color: primary),
      bodyLarge: textTokens.body.copyWith(color: primary, fontWeight: FontWeight.w500),
      bodyMedium: textTokens.body.copyWith(color: secondary),
      bodySmall: textTokens.caption.copyWith(color: secondary),
      labelLarge: textTokens.button.copyWith(color: primary),
      labelMedium: textTokens.label.copyWith(color: secondary),
      labelSmall: textTokens.caption.copyWith(color: secondary),
    );
  }
}
