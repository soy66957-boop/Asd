// PipesToggle - Toggle switch with accent thumb and glow.

import 'package:flutter/material.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';
import 'package:pipes/ui/core/widgets/pipes_tap.dart';

class PipesToggle extends StatefulWidget {
  const PipesToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;
  final bool enabled;

  @override
  State<PipesToggle> createState() => _PipesToggleState();
}

class _PipesToggleState extends State<PipesToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: context.tokens.components.toggle.animationDuration,
      vsync: this,
    );
    _thumbAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant PipesToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onChanged(!widget.value);
    PipesHaptics.tap();
    context.pipesAudio.play(AppSound.tap);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.toggle;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: widget.semanticLabel,
      togglable: true,
      checked: widget.value,
      enabled: widget.enabled,
      child: PipesTap(
        onTap: widget.enabled ? _handleTap : null,
        state: widget.enabled ? PipesTapState.default_ : PipesTapState.disabled,
        semanticLabel: widget.semanticLabel,
        enabled: widget.enabled,
        selected: widget.value,
        pressScale: 1.0,
        minHitSize: c.hitSize,
        child: AnimatedBuilder(
          animation: disableAnimations ? _thumbAnimation : Listenable.merge([_controller]),
          builder: (context, child) {
            final t = disableAnimations ? (widget.value ? 1.0 : 0.0) : _thumbAnimation.value;

            final trackColor = Color.lerp(c.offTrackColor, c.onTrackColor, t)!;
            final thumbColor = Color.lerp(c.offThumbColor, c.onThumbColor, t)!;
            final glowOpacity = widget.value ? 1.0 : 0.0;

            final trackWidth = c.trackWidth;
            final trackHeight = c.trackHeight;
            final thumbSize = c.thumbSize;
            final thumbOffset = (trackWidth - thumbSize) * t;

            return Container(
              width: trackWidth,
              height: trackHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(trackHeight / 2),
                color: trackColor,
              ),
              child: Stack(
                children: [
                  // Glow on thumb when on
                  if (glowOpacity > 0 && !disableAnimations)
                    Positioned(
                      left: thumbOffset + (thumbSize - trackHeight) / 2,
                      top: 0,
                      child: Container(
                        width: trackHeight,
                        height: trackHeight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: thumbColor,
                          boxShadow: [
                            BoxShadow(
                              color: c.onGlowColor.withValues(alpha: glowOpacity * 0.4),
                              blurRadius: c.onGlowBlur,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Thumb
                  Positioned(
                    left: thumbOffset,
                    top: (trackHeight - thumbSize) / 2,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: thumbColor,
                        boxShadow: [
                          BoxShadow(
                            color: palette.textPrimary.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
