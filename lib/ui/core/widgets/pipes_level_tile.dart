// PipesLevelTile - Level tile for level select screen.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/icons/pipes_icons.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';

enum PipesLevelTileState {
  locked,
  unlocked,
  current,
  completed,
}

class PipesLevelTile extends StatelessWidget {
  const PipesLevelTile({
    super.key,
    required this.levelNumber,
    required this.state,
    required this.onTap,
    this.semanticLabel,
  });

  final int levelNumber;
  final PipesLevelTileState state;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.levelTile;
    final isInteractive = onTap != null && state != PipesLevelTileState.locked;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    Color borderColor;
    double borderWidth;
    Color textColor;
    List<BoxShadow>? shadows;
    Widget? child;

    switch (state) {
      case PipesLevelTileState.locked:
        borderColor = c.lockedBorder;
        borderWidth = c.borderWidth;
        textColor = palette.textSecondary;
        child = Icon(
          PipesIcons.lock,
          size: 20,
          color: c.lockedIconColor,
        );
      case PipesLevelTileState.unlocked:
        borderColor = c.lockedBorder;
        borderWidth = c.borderWidth;
        textColor = c.unlockedTextColor;
        child = Text(
          '$levelNumber',
          style: tokens.text.body.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        );
      case PipesLevelTileState.current:
        borderColor = c.currentBorder;
        borderWidth = c.currentBorderWidth;
        textColor = c.currentTextColor;
        shadows = !disableAnimations
            ? [
                BoxShadow(
                  color: c.currentGlowColor.withValues(alpha: 0.4),
                  blurRadius: c.currentGlowBlur,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ]
            : null;
        child = Text(
          '$levelNumber',
          style: tokens.text.body.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        );
      case PipesLevelTileState.completed:
        borderColor = c.lockedBorder;
        borderWidth = c.borderWidth;
        textColor = c.completedTextColor;
        child = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$levelNumber',
              style: tokens.text.body.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 2),
            Container(
              width: c.completedDotSize,
              height: c.completedDotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.completedDotColor,
              ),
            ),
          ],
        );
    }

    return PipesTap(
      onTap: isInteractive ? onTap : null,
      state: isInteractive ? PipesTapState.default_ : PipesTapState.disabled,
      semanticLabel: semanticLabel ?? 'Level $levelNumber, ${_stateName(state)}',
      enabled: isInteractive,
      selected: state == PipesLevelTileState.current,
      pressScale: 0.97,
      minHitSize: 48.0,
      child: Container(
        width: c.size,
        height: c.size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(c.radius),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: shadows,
        ),
        child: child,
      ),
    );
  }

  String _stateName(PipesLevelTileState s) {
    return switch (s) {
      PipesLevelTileState.locked => 'locked',
      PipesLevelTileState.unlocked => 'unlocked',
      PipesLevelTileState.current => 'current',
      PipesLevelTileState.completed => 'completed',
    };
  }
}
