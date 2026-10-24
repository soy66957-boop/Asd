// PipesTap - Pressable wrapper with consistent states.
// Single source for tap feedback: scale, haptics, audio, semantics.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pipes/ui/core/audio/pipes_audio.dart';
import 'package:pipes/ui/core/audio/pipes_haptics.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

/// Visual/touch state of a tappable element.
enum PipesTapState {
  default_,
  hovered,
  focused,
  pressed,
  disabled,
  loading,
  selected,
  error,
}

class PipesTap extends StatefulWidget {
  const PipesTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.state = PipesTapState.default_,
    this.semanticLabel,
    this.enabled = true,
    this.selected = false,
    this.loading = false,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.minHitSize = 48.0,
    this.pressScale = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final PipesTapState state;
  final String? semanticLabel;
  final bool enabled;
  final bool selected;
  final bool loading;
  final HitTestBehavior hitTestBehavior;
  final double minHitSize;
  final double pressScale;

  @override
  State<PipesTap> createState() => _PipesTapState();
}

class _PipesTapState extends State<PipesTap> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: context.tokens.motion.feedback,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.loading || widget.onTap == null) return;
    setState(() => _isPressed = true);
    _pressController.forward();
    PipesHaptics.tap();
    widget.pipesAudio.play(AppSound.tap);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.loading) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
    if (widget.onTap != null) widget.onTap!();
  }

  void _handleTapCancel() {
    if (!widget.enabled || widget.loading) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleLongPress() {
    if (!widget.enabled || widget.loading || widget.onLongPress == null) return;
    widget.onLongPress!();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final palette = context.palette;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final effectiveState = _computeEffectiveState();
    final isInteractive = widget.enabled && !widget.loading && widget.onTap != null;

    // Press scale animation
    final scaleAnimation = disableAnimations
        ? const AlwaysStoppedAnimation<double>(1.0)
        : Tween<double>(begin: 1.0, end: widget.pressScale).animate(
            CurvedAnimation(parent: _pressController, curve: tokens.curves.easeOutCubic),
          );

    // Opacity for disabled/loading states
    final opacity = switch (effectiveState) {
      PipesTapState.disabled => 0.5,
      PipesTapState.loading => 0.7,
      _ => 1.0,
    };

    // Focus ring
    final showFocusRing = _isFocused && !disableAnimations;

    Widget tapTarget = AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed && !disableAnimations ? scaleAnimation.value : 1.0,
          child: Opacity(opacity: opacity, child: child),
        );
      },
      child: widget.child,
    );

    // Semantics
    tapTarget = Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.enabled && !widget.loading,
      selected: widget.selected,
      child: tapTarget,
    );

    // Focus handling
    tapTarget = FocusableActionDetector(
      onShowFocusHighlight: (value) => setState(() => _isFocused = value),
      onShowHoverHighlight: (value) => setState(() => _isHovered = value),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            if (isInteractive) {
              _handleTapDown(TapDownDetails());
              _handleTapUp(TapUpDetails());
            }
            return null;
          },
        ),
      },
      child: tapTarget,
    );

    // Gesture handling
    tapTarget = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: _handleLongPress,
      behavior: widget.hitTestBehavior,
      child: tapTarget,
    );

    // Ensure minimum hit target size
    tapTarget = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minHitSize,
        minHeight: widget.minHitSize,
      ),
      child: tapTarget,
    );

    // Focus ring overlay
    if (showFocusRing) {
      tapTarget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tokens.radius.sm),
          border: Border.all(color: palette.accent, width: 2),
        ),
        child: tapTarget,
      );
    }

    return tapTarget;
  }

  PipesTapState _computeEffectiveState() {
    if (!widget.enabled) return PipesTapState.disabled;
    if (widget.loading) return PipesTapState.loading;
    if (widget.selected) return PipesTapState.selected;
    if (widget.state == PipesTapState.error) return PipesTapState.error;
    if (_isPressed) return PipesTapState.pressed;
    if (_isHovered) return PipesTapState.hovered;
    if (_isFocused) return PipesTapState.focused;
    return PipesTapState.default_;
  }
}

/// Extension for easy access to pipesAudio from BuildContext.
extension PipesAudioContext on BuildContext {
  PipesAudio get pipesAudio => ProviderScope.of(this).read(pipesAudioProvider);
}
