// pipe_geometry.dart - Pure pipe geometry: from tile kind + rotation to tube Paths.
// Caches paths per (kind, rotation, tileSize).

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Represents the 4-bit mask of open sides: N=1, E=2, S=4, W=8.
typedef PipeMask = int;

/// Pipe kind derived from base mask (ignoring rotation).
enum PipeKind {
  empty,      // 0
  endCap,     // 1,2,4,8 (1 side)
  straight,   // 5,10 (2 opposite)
  corner,     // 3,6,12,9 (2 adjacent)
  tJunction,  // 7,14,13,11 (3 sides)
  cross,      // 15 (4 sides) - also source
}

/// Determines the base pipe kind from a mask (rotation-normalized).
PipeKind kindFromMask(PipeMask mask) {
  switch (mask) {
    case 0:
      return PipeKind.empty;
    case 1:
    case 2:
    case 4:
    case 8:
      return PipeKind.endCap;
    case 5:
    case 10:
      return PipeKind.straight;
    case 3:
    case 6:
    case 9:
    case 12:
      return PipeKind.corner;
    case 7:
    case 11:
    case 13:
    case 14:
      return PipeKind.tJunction;
    case 15:
      return PipeKind.cross;
    default:
      return PipeKind.empty;
  }
}

/// Rotates a mask 90° clockwise.
PipeMask rotateCw(PipeMask mask) {
  return ((mask << 1) & 0xF) | ((mask >> 3) & 0x1);
}

/// Rotates a mask 90° counter-clockwise.
PipeMask rotateCcw(PipeMask mask) {
  return ((mask >> 1) & 0x7) | ((mask << 3) & 0x8);
}

/// Applies rotation (0..3) to a mask.
PipeMask applyRotation(PipeMask baseMask, int rotation) {
  var m = baseMask;
  for (var i = 0; i < (rotation % 4); i++) {
    m = rotateCw(m);
  }
  return m;
}

/// Entry side for water flow: 0=N, 1=E, 2=S, 3=W, -1=none/source.
typedef EntrySide = int;

/// Geometry for a single tile: the tube path and optional source ring.
class PipeGeometry {
  const PipeGeometry({
    required this.tubePath,
    this.sourceRingPath,
    this.bulbPath,
  });

  final Path tubePath;
  final Path? sourceRingPath;
  final Path? bulbPath;
}

/// Cache key for pipe geometry.
class _PipeCacheKey {
  const _PipeCacheKey(this.kind, this.rotation, this.tileSize);

  final PipeKind kind;
  final int rotation;
  final double tileSize;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PipeCacheKey &&
          other.kind == kind &&
          other.rotation == rotation &&
          other.tileSize == tileSize;

  @override
  int get hashCode => Object.hash(kind, rotation, tileSize);
}

final Map<_PipeCacheKey, PipeGeometry> _geometryCache = {};

/// Builds the tube path for a given mask, rotation, and tile size.
/// Returns a PipeGeometry with tubePath (and sourceRingPath for cross).
PipeGeometry buildPipeGeometry(PipeMask mask, int rotation, double tileSize) {
  final kind = kindFromMask(mask);
  final key = _PipeCacheKey(kind, rotation, tileSize);
  final cached = _geometryCache[key];
  if (cached != null) return cached;

  final double half = tileSize / 2;
  final double tubeRadius = tileSize * 0.26 / 2; // tubeWidthRatio / 2
  final double center = half;
  final Path tubePath = Path();

  // Build path based on kind
  switch (kind) {
    case PipeKind.empty:
      break;
    case PipeKind.endCap:
      // Single arm from center to edge with round bulb at edge
      tubePath.addPath(_buildEndCap(center, tubeRadius, mask), Offset.zero);
      break;
    case PipeKind.straight:
      // Two opposite arms through center
      tubePath.addPath(_buildStraight(center, tubeRadius, mask), Offset.zero);
      break;
    case PipeKind.corner:
      // Quarter arc connecting two adjacent sides
      tubePath.addPath(_buildCorner(center, tubeRadius, mask), Offset.zero);
      break;
    case PipeKind.tJunction:
      // Three arms + center hub
      tubePath.addPath(_buildTJunction(center, tubeRadius, mask), Offset.zero);
      break;
    case PipeKind.cross:
      // Four arms + center hub + source ring
      tubePath.addPath(_buildCross(center, tubeRadius), Offset.zero);
      break;
  }

  Path? sourceRing;
  Path? bulb;
  if (kind == PipeKind.cross) {
    sourceRing = _buildSourceRing(center, tileSize);
  }
  if (kind == PipeKind.endCap) {
    bulb = _buildBulb(center, tileSize, mask);
  }

  final geometry = PipeGeometry(
    tubePath: tubePath,
    sourceRingPath: sourceRing,
    bulbPath: bulb,
  );
  _geometryCache[key] = geometry;
  return geometry;
}

Path _buildEndCap(double center, double tubeRadius, PipeMask mask) {
  final path = Path();
  final double r = center;
  final double bulbRadius = center * 0.19; // bulb radius = 0.19 * tileSize

  // Determine which side is open
  Offset start;
  Offset end;
  if ((mask & 1) != 0) { // North
    start = Offset(center, center);
    end = Offset(center, center - r + bulbRadius);
  } else if ((mask & 2) != 0) { // East
    start = Offset(center, center);
    end = Offset(center + r - bulbRadius, center);
  } else if ((mask & 4) != 0) { // South
    start = Offset(center, center);
    end = Offset(center, center + r - bulbRadius);
  } else { // West
    start = Offset(center, center);
    end = Offset(center - r + bulbRadius, center);
  }

  // Tube line
  path.moveTo(start.dx, start.dy);
  path.lineTo(end.dx, end.dy);

  // Bulb at the end (round cap)
  path.addOval(Rect.fromCircle(center: end, radius: bulbRadius));

  return path;
}

Path _buildStraight(double center, double tubeRadius, PipeMask mask) {
  final path = Path();
  final double r = center;

  if ((mask & 1) != 0 && (mask & 4) != 0) { // N-S
    path.moveTo(center, center - r);
    path.lineTo(center, center + r);
  } else { // E-W
    path.moveTo(center - r, center);
    path.lineTo(center + r, center);
  }
  return path;
}

Path _buildCorner(double center, double tubeRadius, PipeMask mask) {
  final path = Path();
  final double r = center;
  final double arcRadius = r - tubeRadius;

  // Determine the two adjacent open sides
  // N+E (3), E+S (6), S+W (12), W+N (9)
  if ((mask & 3) == 3) { // N+E
    path.moveTo(center, center - r);
    path.arcTo(
      Rect.fromCircle(center: Offset(center, center), radius: arcRadius),
      -math.pi / 2,
      -math.pi / 2,
      false,
    );
    path.lineTo(center + r, center);
  } else if ((mask & 6) == 6) { // E+S
    path.moveTo(center + r, center);
    path.arcTo(
      Rect.fromCircle(center: Offset(center, center), radius: arcRadius),
      0,
      -math.pi / 2,
      false,
    );
    path.lineTo(center, center + r);
  } else if ((mask & 12) == 12) { // S+W
    path.moveTo(center, center + r);
    path.arcTo(
      Rect.fromCircle(center: Offset(center, center), radius: arcRadius),
      math.pi / 2,
      -math.pi / 2,
      false,
    );
    path.lineTo(center - r, center);
  } else { // W+N (9)
    path.moveTo(center - r, center);
    path.arcTo(
      Rect.fromCircle(center: Offset(center, center), radius: arcRadius),
      math.pi,
      -math.pi / 2,
      false,
    );
    path.lineTo(center, center - r);
  }
  return path;
}

Path _buildTJunction(double center, double tubeRadius, PipeMask mask) {
  final path = Path();
  final double r = center;
  final double hubRadius = tubeRadius;

  // Draw center hub
  path.addOval(Rect.fromCircle(center: Offset(center, center), radius: hubRadius));

  // Three arms
  if ((mask & 1) != 0) { // North
    path.moveTo(center, center - r);
    path.lineTo(center, center - hubRadius);
  }
  if ((mask & 2) != 0) { // East
    path.moveTo(center + r, center);
    path.lineTo(center + hubRadius, center);
  }
  if ((mask & 4) != 0) { // South
    path.moveTo(center, center + r);
    path.lineTo(center, center + hubRadius);
  }
  if ((mask & 8) != 0) { // West
    path.moveTo(center - r, center);
    path.lineTo(center - hubRadius, center);
  }
  return path;
}

Path _buildCross(double center, double tubeRadius) {
  final path = Path();
  final double r = center;
  final double hubRadius = tubeRadius;

  // Center hub
  path.addOval(Rect.fromCircle(center: Offset(center, center), radius: hubRadius));

  // Four arms
  path.moveTo(center, center - r);
  path.lineTo(center, center - hubRadius);
  path.moveTo(center + r, center);
  path.lineTo(center + hubRadius, center);
  path.moveTo(center, center + r);
  path.lineTo(center, center + hubRadius);
  path.moveTo(center - r, center);
  path.lineTo(center - hubRadius, center);

  return path;
}

Path _buildSourceRing(double center, double tileSize) {
  final path = Path();
  final double ringRadius = center * 0.85;
  path.addOval(Rect.fromCircle(center: Offset(center, center), radius: ringRadius));
  return path;
}

Path _buildBulb(double center, double tileSize, PipeMask mask) {
  final path = Path();
  final double r = center;
  final double bulbRadius = center * 0.19;

  Offset bulbCenter;
  if ((mask & 1) != 0) { // North
    bulbCenter = Offset(center, center - r + bulbRadius);
  } else if ((mask & 2) != 0) { // East
    bulbCenter = Offset(center + r - bulbRadius, center);
  } else if ((mask & 4) != 0) { // South
    bulbCenter = Offset(center, center + r - bulbRadius);
  } else { // West
    bulbCenter = Offset(center - r + bulbRadius, center);
  }

  path.addOval(Rect.fromCircle(center: bulbCenter, radius: bulbRadius));
  return path;
}

/// Clears the geometry cache (useful for tests or memory pressure).
void clearPipeGeometryCache() {
  _geometryCache.clear();
}
