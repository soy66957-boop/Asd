// PipesSwatch - Palette color swatch for theme selection.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';

class PipesSwatch extends StatelessWidget {
  const PipesSwatch({
    super.key,
    required this.palette,
    required this.isSelected,
    required this.onTap,
    this.semanticLabel,
    this.enabled = true,
  });

  final PaletteTokens palette;
  final bool isSelected;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final c = tokens.components.swatch;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    // The accent color for THIS palette (not the active theme)
    final accentColor = palette.accent;
    final glowColor = palette.glowColor;

    return Semantics(
      label: semanticLabel ?? palette.name,
      button: true,
      selected: isSelected,
      enabled: enabled,
      child: PipesTap(
        onTap: enabled ? onTap : null,
        state: isSelected ? PipesTapState.selected : PipesTapState.default_,
        semanticLabel: semanticLabel,
        enabled: enabled,
        selected: isSelected,
        pressScale: 0.95,
        minHitSize: 48.0,
        child: AnimatedContainer(
          duration: tokens.motion.feedback,
          curve: tokens.curves.easeOutCubic,
          width: c.size,
          height: c.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.background,
            border: Border.all(
              color: isSelected ? accentColor : c.ringColor,
              width: isSelected ? c.selectedRingWidth : c.ringWidth,
            ),
            boxShadow: isSelected && !disableAnimations
                ? [
                    BoxShadow(
                      color: c.selectedGlowColor.withValues(alpha: 0.4),
                      blurRadius: c.selectedGlowBlur,
                      spreadRadius: 0,
                      offset: Offset.zero,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Container(
              width: c.centerDotSize,
              height: c.centerDotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
