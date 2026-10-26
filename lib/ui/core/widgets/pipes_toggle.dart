// PipesToggle - Toggle switch with accent thumb and glow.
// Track: 48x32dp visible. Thumb: 24dp centered. Hit area: 48x48dp centered (invisible padding).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

class PipesToggle extends ConsumerStatefulWidget {
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
  ConsumerState<PipesToggle> createState() => _PipesToggleState();
}

class _PipesToggleState extends ConsumerState<PipesToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.value) {
      // Will be set to 1.0 in didChangeDependencies after controller is created
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controllerInitialized) {
      _controller = AnimationController(
        duration: context.tokens.motion.feedback,
        vsync: this,
      );
      _thumbAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      if (widget.value) _controller.value = 1.0;
      _controllerInitialized = true;
    }
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
    PipesHaptics.tap();
    ref.read(pipesAudioProvider).play(AppSound.tap);
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final c = tokens.components.toggle;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final isInteractive = widget.enabled;

    // Track dimensions (painted) - from tokens
    final double trackWidth = c.trackWidth;
    final double trackHeight = c.trackHeight;
    final double thumbSize = c.thumbSize;

    // Hit area dimensions (invisible, centered on track)
    final double hitWidth = c.hitWidth;
    final double hitHeight = c.hitHeight;

    // Track position within hit area box (centered)
    // Horizontal: (56 - 52) / 2 = 2dp margin each side
    // Vertical: (48 - 32) / 2 = 8dp margin each side
    final double trackLeft = (hitWidth - trackWidth) / 2;
    final double trackTop = (hitHeight - trackHeight) / 2;

    // Colors
    final trackColor = widget.value ? c.onTrackColor : c.offTrackColor;
    final thumbColor = widget.value ? c.onThumbColor : c.offThumbColor;

    // The track widget (painted at 48x32) - keyed for testing
    final trackWidget = AnimatedBuilder(
      animation: _thumbAnimation,
      builder: (context, child) {
        final progress = _thumbAnimation.value;
        final thumbOffset = progress * (trackWidth - thumbSize); // 0 to 24
        final glowOpacity = progress * 0.4;

        return Positioned(
          key: const Key('pipes_toggle_track'),
          left: trackLeft,
          top: trackTop,
          child: Container(
            width: trackWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(trackHeight / 2),
              color: trackColor,
              boxShadow: widget.value && !disableAnimations
                  ? [
                      BoxShadow(
                        color: c.onGlowColor.withValues(alpha: glowOpacity * 0.4),
                        blurRadius: c.onGlowBlur,
                        spreadRadius: 0,
                        offset: Offset.zero,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Glow ring behind thumb
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
                          color: c.onGlowColor.withValues(alpha: glowOpacity),
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
          ),
        );
      },
    );

    // Hit area box (48x48) with track positioned inside
    // Track (48x32) is centered in hit box, flush horizontally
    return Semantics(
      label: widget.semanticLabel,
      checked: widget.value,
      enabled: widget.enabled,
      child: GestureDetector(
        onTap: isInteractive ? _handleTap : null,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: hitWidth,
          height: hitHeight,
          child: Stack(
            children: [trackWidget],
          ),
        ),
      ),
    );
  }
}
