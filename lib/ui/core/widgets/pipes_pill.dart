// PipesPill - Pill-shaped label for "Level N" and similar.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

class PipesPill extends StatelessWidget {
  const PipesPill({
    super.key,
    required this.text,
    this.variant = PipesPillVariant.standard,
    this.textStyle,
  });

  final String text;
  final PipesPillVariant variant;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.pill;

    Color borderColor;
    double borderWidth;
    Color textColor;

    switch (variant) {
      case PipesPillVariant.standard:
        borderColor = c.border;
        borderWidth = c.borderWidth;
        textColor = c.textColor;
      case PipesPillVariant.accent:
        borderColor = palette.accent;
        borderWidth = c.borderWidth;
        textColor = palette.accent;
      case PipesPillVariant.danger:
        borderColor = palette.danger;
        borderWidth = c.borderWidth;
        textColor = palette.danger;
    }

    return IntrinsicWidth(
      child: Container(
        height: c.height,
        padding: EdgeInsets.symmetric(horizontal: c.horizontalPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(c.radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Text(
          text,
          style: (textStyle ?? tokens.text.label).copyWith(color: textColor),
        ),
      ),
    );
  }
}

enum PipesPillVariant {
  standard,
  accent,
  danger,
}
