// PipesIconButton - Circular icon button with consistent states.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';

class PipesIconButton extends StatelessWidget {
  const PipesIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.isSelected = false,
    this.hasError = false,
    this.size,
    this.iconSize,
  }) : assert(semanticLabel != null && semanticLabel.isNotEmpty,
            'PipesIconButton requires a non-empty semanticLabel for accessibility');

  final IconData icon;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool isSelected;
  final bool hasError;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.iconButton;
    final isInteractive = onTap != null && !hasError;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final buttonSize = size ?? c.size;
    final effectiveIconSize = iconSize ?? c.iconSize;
    final hitSize = c.hitSize;

    // Resolve colors
    Color bgColor;
    Color borderColor;
    Color iconColor;

    if (!isInteractive) {
      bgColor = c.disabledBackground;
      borderColor = c.disabledBorder;
      iconColor = c.disabledIconColor;
    } else if (hasError) {
      bgColor = c.pressedBackground;
      borderColor = palette.danger;
      iconColor = palette.danger;
    } else if (isSelected) {
      bgColor = palette.accent.withValues(alpha: 0.15);
      borderColor = palette.accent;
      iconColor = palette.accent;
    } else {
      bgColor = c.background;
      borderColor = c.border;
      iconColor = c.iconColor;
    }

    Widget buttonChild = Container(
      width: buttonSize,
      height: buttonSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Icon(icon, size: effectiveIconSize, color: iconColor),
    );

    // Focus ring
    Widget wrappedChild = buttonChild;

    return PipesTap(
      onTap: isInteractive ? onTap : null,
      state: isInteractive
          ? (isSelected ? PipesTapState.selected : (hasError ? PipesTapState.error : PipesTapState.default_))
          : PipesTapState.disabled,
      semanticLabel: semanticLabel,
      enabled: isInteractive,
      selected: isSelected,
      loading: false,
      pressScale: 0.95,
      minHitSize: hitSize,
      child: wrappedChild,
    );
  }
}
