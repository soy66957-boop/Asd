// PipesHeader - Three-slot header: leading | center (expanded) | trailing.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

class PipesHeader extends StatelessWidget {
  const PipesHeader({
    super.key,
    this.leading,
    this.center,
    this.trailing,
    this.height,
    this.slotWidth,
    this.horizontalPadding = 16.0,
  });

  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final double? height;
  final double? slotWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final c = tokens.components.header;

    final effectiveHeight = height ?? c.height;
    final effectiveSlotWidth = slotWidth ?? c.slotWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: effectiveHeight,
        child: Row(
          children: [
            // Leading slot - fixed width
            SizedBox(
              width: effectiveSlotWidth,
              child: leading ?? const SizedBox.shrink(),
            ),
            // Center slot - expanded and centered
            Expanded(
              child: Center(
                child: center ?? const SizedBox.shrink(),
              ),
            ),
            // Trailing slot - fixed width (same as leading)
            SizedBox(
              width: effectiveSlotWidth,
              child: trailing ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
