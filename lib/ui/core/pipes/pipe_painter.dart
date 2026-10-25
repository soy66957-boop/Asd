// pipe_painter.dart - Shared neon pipe painter with animated layers.
// One place draws every pipe; hero in 5B will reuse it.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pipes/ui/core/pipes/pipe_geometry.dart';
import 'package:pipes/ui/core/pipes/flow_order.dart';
import 'package:pipes/ui/core/theme/pipes_tokens.dart';

/// A tile's animated state for the painter.
class PipeTileAnim {
  const PipeTileAnim({
    required this.rotationAngle,
    required this.fillProgress,
    required this.isRotating,
    required this.visuallyConnected,
  });

  /// Current visual rotation in radians.
  final double rotationAngle;

  /// Water fill progress 0.0..1.0.
  final double fillProgress;

  /// Whether currently rotating (spring animation in progress).
  final bool isRotating;

  /// Logic-connected AND not currently rotating.
  final bool visuallyConnected;
}

/// Per-tile animation controllers held by the board.
class PipeTileControllers {
  PipeTileControllers({
    required this.rotationController,
    required this.rotationAnimation,
    required this.fillController,
  });

  final AnimationController rotationController;
  final Animation<double> rotationAnimation;
  final AnimationController fillController;
}

/// Shared pipe painter that draws the entire board.
class PipePainter extends CustomPainter {
  PipePainter({
    required this.board,
    required this.waterFlow,
    required this.sourceRow,
    required this.sourceCol,
    required this.tileSize,
    required this.animations,
    required this.tokens,
    required this.palette,
    this.winProgress = 0.0,
    this.disableAnimations = false,
  });

  final List<List<int>> board;
  final List<List<bool>> waterFlow;
  final int sourceRow;
  final int sourceCol;
  final double tileSize;
  final List<List<PipeTileAnim>> animations;
  final PipeTokens tokens;
  final PaletteTokens palette;
  final double winProgress; // 0.0..1.0 for win wave
  final bool disableAnimations;

  // Shared tickers for shimmer and source pulse
  static final _ShimmerTicker _shimmerTicker = _ShimmerTicker();
  static final _SourcePulseTicker _sourcePulseTicker = _SourcePulseTicker();

  @override
  void paint(Canvas canvas, Size size) {
    final n = board.length;
    final double tubeWidth = tileSize * tokens.tubeWidthRatio;
    final double coreWidth = tubeWidth * tokens.coreRatio;
    final double highlightAlpha = tokens.highlightAlpha;
    final List<double> glowAlphas = tokens.glowAlphas;
    final List<double> glowWidthRatios = tokens.glowWidthRatios;

    // Precompute flow order once per paint (could be cached externally)
    final flowInfos = computeFlowOrder(
      board: board,
      sourceRow: sourceRow,
      sourceCol: sourceCol,
    );

    // Shimmer and pulse values (driven by shared tickers)
    final double shimmerPhase = _shimmerTicker.phase;
    final double sourcePulse = _sourcePulseTicker.pulse;

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        final mask = board[r][c];
        if (mask == 0) continue;

        final anim = animations[r][c];
        final flowInfo = flowInfos[r][c];
        final geometry = buildPipeGeometry(mask, 0, tileSize); // rotation handled via canvas

        final bool isSource = (r == sourceRow && c == sourceCol);
        final bool hasWaterLogic = waterFlow[r][c];
        final bool visuallyConnected = anim.visuallyConnected;

        // Canvas transform for this tile
        canvas.save();
        canvas.translate(c * tileSize, r * tileSize);

        // Apply rotation animation
        canvas.translate(tileSize / 2, tileSize / 2);
        canvas.rotate(anim.rotationAngle);
        canvas.translate(-tileSize / 2, -tileSize / 2);

        // Layer 1: Tube body (idle color)
        final tubePaint = Paint()
          ..color = palette.pipeIdle
          ..style = PaintingStyle.stroke
          ..strokeWidth = tubeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(geometry.tubePath, tubePaint);

        // Layer 2: Highlight (thin white stroke offset top-left)
        final highlightPaint = Paint()
          ..color = Colors.white.withValues(alpha: highlightAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = tubeWidth * 0.15
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        // Offset path slightly toward top-left for highlight effect
        final highlightPath = _offsetPath(geometry.tubePath, -tubeWidth * 0.1, -tubeWidth * 0.1);
        canvas.drawPath(highlightPath, highlightPaint);

        // Layer 3: Glow (three wider strokes, no MaskFilter, no saveLayer)
        if (visuallyConnected || isSource) {
          for (int i = 0; i < glowAlphas.length; i++) {
            final glowPaint = Paint()
              ..color = palette.accent.withValues(alpha: glowAlphas[i])
              ..style = PaintingStyle.stroke
              ..strokeWidth = tubeWidth * glowWidthRatios[i]
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round;
            canvas.drawPath(geometry.tubePath, glowPaint);
          }
        }

        // Layer 4: Water core (animated fill)
        if (visuallyConnected && anim.fillProgress > 0) {
          final corePaint = Paint()
            ..color = palette.accent
            ..style = PaintingStyle.stroke
            ..strokeWidth = coreWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

          final metrics = geometry.tubePath.computeMetrics();
          for (final metric in metrics) {
            final extractLen = metric.length * anim.fillProgress;
            final segment = metric.extractPath(0, extractLen);
            canvas.drawPath(segment, corePaint);
          }
        }

        // Layer 5: Shimmer (bright segment traveling along water)
        if (visuallyConnected && anim.fillProgress > 0 && !disableAnimations) {
          final shimmerPaint = Paint()
            ..color = Colors.white.withValues(alpha: 0.35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = coreWidth * 1.2
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

          final metrics = geometry.tubePath.computeMetrics();
          for (final metric in metrics) {
            final totalLen = metric.length;
            final shimmerLen = totalLen * 0.15; // short segment
            final phasePos = (shimmerPhase * totalLen) % (totalLen + shimmerLen);
            final start = phasePos - shimmerLen;
            if (start < totalLen && start + shimmerLen > 0) {
              final segmentStart = start.clamp(0.0, totalLen);
              final segmentEnd = (start + shimmerLen).clamp(0.0, totalLen);
              if (segmentEnd > segmentStart) {
                final segment = metric.extractPath(segmentStart, segmentEnd);
                canvas.drawPath(segment, shimmerPaint);
              }
            }
          }
        }

        // Source tile extras
        if (isSource) {
          // Source ring
          if (geometry.sourceRingPath != null) {
            final ringPaint = Paint()
              ..color = palette.accent
              ..style = PaintingStyle.stroke
              ..strokeWidth = tubeWidth * 0.6
              ..strokeCap = StrokeCap.round;
            canvas.drawPath(geometry.sourceRingPath!, ringPaint);
          }

          // Pulsing core
          final pulseScale = 0.9 + 0.2 * sourcePulse; // 0.9 to 1.1
          final pulsePaint = Paint()
            ..color = palette.accent
            ..style = PaintingStyle.fill;
          canvas.drawCircle(
            Offset(tileSize / 2, tileSize / 2),
            tubeWidth * 0.6 * pulseScale,
            pulsePaint,
          );

          // Pulse glow
          if (!disableAnimations) {
            final glowPaint = Paint()
              ..color = palette.accent.withValues(alpha: 0.3 * (1 - sourcePulse))
              ..style = PaintingStyle.stroke
              ..strokeWidth = tubeWidth * 2.0 * (1 + sourcePulse)
              ..strokeCap = StrokeCap.round;
            canvas.drawCircle(Offset(tileSize / 2, tileSize / 2), tileSize * 0.4, glowPaint);
          }
        }

        // Win wave pulse
        if (winProgress > 0 && visuallyConnected && !disableAnimations) {
          final flowInfo = flowInfos[r][c];
          if (flowInfo.connected) {
            final delay = flowInfo.distance * tokens.winWaveStep.inMilliseconds / 1000.0;
            final tileProgress = (winProgress - delay).clamp(0.0, 1.0);
            if (tileProgress > 0) {
              final pulse = math.sin(tileProgress * math.pi);
              final scale = 1.0 + (tokens.winPulseScale - 1.0) * pulse;
              final glowAlpha = 1.8 - 0.8 * tileProgress;

              canvas.save();
              canvas.translate(tileSize / 2, tileSize / 2);
              canvas.scale(scale);
              canvas.translate(-tileSize / 2, -tileSize / 2);

              final winGlowPaint = Paint()
                ..color = palette.accent.withValues(alpha: 0.2 * glowAlpha)
                ..style = PaintingStyle.stroke
                ..strokeWidth = tubeWidth * 2.5
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round;
              canvas.drawPath(geometry.tubePath, winGlowPaint);

              canvas.restore();
            }
          }
        }

        canvas.restore(); // tile transform
      }
    }
  }

  @override
  bool shouldRepaint(covariant PipePainter oldDelegate) {
    return oldDelegate.board != board ||
        oldDelegate.waterFlow != waterFlow ||
        oldDelegate.animations != animations ||
        oldDelegate.winProgress != winProgress ||
        oldDelegate.disableAnimations != disableAnimations;
  }

  Path _offsetPath(Path source, double dx, double dy) {
    final path = Path();
    path.addPath(source, Offset(dx, dy));
    return path;
  }
}

/// Shared ticker for shimmer animation across all tiles.
class _ShimmerTicker {
  _ShimmerTicker() {
    _controller = AnimationController.unbounded(vsync: _VSync());
    _controller.repeat(period: const Duration(milliseconds: 2400));
  }

  late final AnimationController _controller;

  double get phase => _controller.value;
}

/// Shared ticker for source pulse animation.
class _SourcePulseTicker {
  _SourcePulseTicker() {
    _controller = AnimationController.unbounded(vsync: _VSync());
    _controller.repeat(period: const Duration(milliseconds: 2000));
  }

  late final AnimationController _controller;

  double get pulse => (math.sin(_controller.value * 2 * math.pi) + 1) / 2; // 0..1
}

/// Minimal vsync for unbounded controllers.
class _VSync extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick, debugLabel: 'PipePainter');
}
