// Safe zone constants for TikTok/Reels 9:16 video
// From PRODUCTION_SPEC.md

export const SAFE_ZONES = {
  // Video dimensions
  WIDTH: 1080,
  HEIGHT: 1920,
  
  // Safe zones (keep critical content within these bounds)
  TOP_SAFE: 250,      // px from top
  BOTTOM_SAFE: 400,   // px from bottom
  
  // Effective content area
  CONTENT_TOP: 250,
  CONTENT_BOTTOM: 1520,  // 1920 - 400
  CONTENT_HEIGHT: 1270,  // 1520 - 250
  CONTENT_LEFT: 50,
  CONTENT_RIGHT: 1030,   // 1080 - 50
  CONTENT_WIDTH: 980,    // 1030 - 50
  
  // Center points
  CENTER_X: 540,
  CENTER_Y: 960,
  CONTENT_CENTER_Y: 885, // (250 + 1520) / 2
};

// Helper to clamp Y position within safe zone
export function clampToSafeZone(y: number, elementHeight: number = 0): number {
  const minY = SAFE_ZONES.CONTENT_TOP;
  const maxY = SAFE_ZONES.CONTENT_BOTTOM - elementHeight;
  return Math.max(minY, Math.min(maxY, y));
}

// Helper to get safe Y position for centered text
export function getSafeCenterY(elementHeight: number): number {
  return SAFE_ZONES.CONTENT_CENTER_Y - elementHeight / 2;
}

// Check if element is in safe zone
export function isInSafeZone(y: number, height: number): boolean {
  return y >= SAFE_ZONES.CONTENT_TOP && y + height <= SAFE_ZONES.CONTENT_BOTTOM;
}

// Get random offset for "hand-placed" feel (±2-4px)
export function getHandOffset(max = 4): { x: number; y: number } {
  return {
    x: (Math.random() - 0.5) * 2 * max,
    y: (Math.random() - 0.5) * 2 * max,
  };
}

// Parallax helper - background moves at fraction of foreground
export function getParallaxOffset(foregroundOffset: number, factor = 0.1): number {
  return foregroundOffset * factor;
}
