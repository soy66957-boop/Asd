// PipesButton - Unified button component with all variants and states.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';

enum PipesButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
}

class PipesButton extends StatelessWidget {
  const PipesButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = PipesButtonVariant.primary,
    this.isSelected = false,
    this.isLoading = false,
    this.hasError = false,
    this.semanticLabel,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.leading,
  });

  final String text;
  final VoidCallback? onPressed;
  final PipesButtonVariant variant;
  final bool isSelected;
  final bool isLoading;
  final bool hasError;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final Widget? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.button;
    final isInteractive = onPressed != null && !isLoading;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final effectiveVariant = hasError ? PipesButtonVariant.danger : variant;

    // Resolve colors based on variant and state
    final (Color bgColor, Color textColor, Color? borderColor, List<BoxShadow>? shadows) = _resolveColors(
      context,
      effectiveVariant,
      isInteractive,
      isSelected,
      disableAnimations,
    );

    Widget label = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(c.loadingSpinnerColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && iconPosition == IconPosition.leading) ...[
                icon!,
                SizedBox(width: tokens.spacing.xs),
              ],
              Text(
                text,
                style: tokens.text.button.copyWith(color: textColor),
              ),
              if (icon != null && iconPosition == IconPosition.trailing) ...[
                SizedBox(width: tokens.spacing.xs),
                icon!,
              ],
            ],
          );

    final buttonChild = Container(
      height: height ?? c.height,
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(c.radius),
        border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
        boxShadow: shadows,
      ),
      child: DefaultTextStyle.merge(
        style: tokens.text.button.copyWith(color: textColor),
        child: label,
      ),
    );

    return PipesTap(
      onTap: isInteractive ? onPressed : null,
      state: _computeTapState(isInteractive, isSelected, hasError, isLoading),
      semanticLabel: semanticLabel,
      enabled: isInteractive,
      selected: isSelected,
      loading: isLoading,
      pressScale: c.pressedScale,
      minHitSize: 48.0,
      child: buttonChild,
    );
  }

  (Color, Color, Color?, List<BoxShadow>?) _resolveColors(
    BuildContext context,
    PipesButtonVariant variant,
    bool isInteractive,
    bool isSelected,
    bool disableAnimations,
  ) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.button;

    switch (variant) {
      case PipesButtonVariant.primary:
        if (!isInteractive) {
          return (
            c.primaryBackground.withValues(alpha: 0.5),
            c.disabledForeground,
            c.disabledBorder,
            null,
          );
        }
        final glowOpacity = disableAnimations ? 0.0 : (isSelected ? c.selectedGlowOpacity : c.glowOpacityDefault);
        return (
          c.primaryBackground,
          c.primaryForeground,
          null,
          glowOpacity > 0
              ? [
                  BoxShadow(
                    color: c.primaryGlowColor.withValues(alpha: glowOpacity),
                    blurRadius: c.primaryGlowBlur,
                    spreadRadius: 0,
                    offset: Offset.zero,
                  ),
                ]
              : null,
        );

      case PipesButtonVariant.secondary:
        if (!isInteractive) {
          return (
            c.secondaryBackground.withValues(alpha: 0.5),
            c.disabledForeground,
            c.disabledBorder,
            null,
          );
        }
        if (isSelected) {
          return (
            c.secondaryBackground,
            c.secondaryForeground,
            c.selectedBorder,
            [
              BoxShadow(
                color: c.primaryGlowColor.withValues(alpha: c.selectedGlowOpacity),
                blurRadius: c.primaryGlowBlur,
                spreadRadius: 0,
                offset: Offset.zero,
              ),
            ],
          );
        }
        return (
          c.secondaryBackground,
          c.secondaryForeground,
          c.secondaryBorder,
          null,
        );

      case PipesButtonVariant.ghost:
        if (!isInteractive) {
          return (
            Colors.transparent,
            c.disabledForeground,
            null,
            null,
          );
        }
        return (
          Colors.transparent,
          c.ghostForeground,
          null,
          null,
        );

      case PipesButtonVariant.danger:
        if (!isInteractive) {
          return (
            Colors.transparent,
            c.disabledForeground,
            c.errorBorder.withValues(alpha: 0.5),
            null,
          );
        }
        if (hasError) {
          return (
            Colors.transparent,
            c.dangerForeground,
            c.errorBorder,
            null,
          );
        }
        return (
          Colors.transparent,
          c.dangerForeground,
          c.dangerBorder,
          null,
        );
    }
  }

  PipesTapState _computeTapState(
    bool isInteractive,
    bool isSelected,
    bool hasError,
    bool isLoading,
  ) {
    if (!isInteractive) return PipesTapState.disabled;
    if (isLoading) return PipesTapState.loading;
    if (hasError) return PipesTapState.error;
    if (isSelected) return PipesTapState.selected;
    return PipesTapState.default_;
  }
}

enum IconPosition { leading, trailing }
