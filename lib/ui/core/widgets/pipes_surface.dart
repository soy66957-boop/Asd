// PipesSurface - Surface container with hairline border and optional glow.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

class PipesSurface extends StatelessWidget {
  const PipesSurface({
    super.key,
    required this.child,
    this.alive = false,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
  });

  final Widget child;
  final bool alive;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.surface;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final effectiveRadius = borderRadius ?? c.radius;
    final glowOpacity = alive && !disableAnimations ? c.aliveGlowOpacity : 0.0;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.all(color: c.border, width: 1.5),
        boxShadow: glowOpacity > 0
            ? [
                BoxShadow(
                  color: c.glowColor.withValues(alpha: glowOpacity),
                  blurRadius: c.glowBlur,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
