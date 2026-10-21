// Easing functions matching production spec
// All curves from PRODUCTION_SPEC.md

export const easings = {
  // Punch: cubic-bezier(0.34, 1.56, 0.64, 1) - for zoom punch-ins, confetti pops
  punch: (t: number): number => {
    const c1 = 0.34;
    const c2 = 1.56;
    const c3 = 0.64;
    const c4 = 1;
    return cubicBezier(t, c1, c2, c3, c4);
  },

  // Bounce: cubic-bezier(0.68, -0.55, 0.27, 1.55) - for text entrances, icon slides
  bounce: (t: number): number => {
    const c1 = 0.68;
    const c2 = -0.55;
    const c3 = 0.27;
    const c4 = 1.55;
    return cubicBezier(t, c1, c2, c3, c4);
  },

  // Smooth: cubic-bezier(0.25, 0.46, 0.45, 0.94) - for parallax, camera push
  smooth: (t: number): number => {
    const c1 = 0.25;
    const c2 = 0.46;
    const c3 = 0.45;
    const c4 = 0.94;
    return cubicBezier(t, c1, c2, c3, c4);
  },

  // EaseOut: cubic-bezier(0.16, 1, 0.3, 1) - for exits, fades
  easeOut: (t: number): number => {
    const c1 = 0.16;
    const c2 = 1;
    const c3 = 0.3;
    const c4 = 1;
    return cubicBezier(t, c1, c2, c3, c4);
  },

  // Spring simulation for Remotion spring()
  spring: (t: number, stiffness = 1, damping = 80, mass = 10): number => {
    // Simplified spring for interpolation
    const omega = Math.sqrt(stiffness / mass);
    const zeta = damping / (2 * Math.sqrt(stiffness * mass));
    
    if (zeta < 1) {
      // Underdamped - oscillates
      const omegaD = omega * Math.sqrt(1 - zeta * zeta);
      const envelope = Math.exp(-zeta * omega * t);
      return 1 - envelope * (Math.cos(omegaD * t) + (zeta / Math.sqrt(1 - zeta * zeta)) * Math.sin(omegaD * t));
    } else {
      // Overdamped - no oscillation
      return 1 - Math.exp(-omega * t);
    }
  },

  // Linear
  linear: (t: number): number => t,
};

// Cubic bezier implementation
function cubicBezier(t: number, p1x: number, p1y: number, p2x: number, p2y: number): number {
  // Newton-Raphson iteration for x(t) = target
  // Simplified: use pre-computed approximation for common curves
  const x = t;
  
  // For our specific curves, use direct polynomial approximation
  // These are the exact cubic-bezier functions
  const cx = 3 * p1x;
  const bx = 3 * (p2x - p1x) - cx;
  const ax = 1 - cx - bx;
  
  const cy = 3 * p1y;
  const by = 3 * (p2y - p1y) - cy;
  const ay = 1 - cy - by;
  
  // Solve for t given x using Newton's method
  let tGuess = x;
  for (let i = 0; i < 8; i++) {
    const xGuess = ((ax * tGuess + bx) * tGuess + cx) * tGuess;
    const dx = (3 * ax * tGuess + 2 * bx) * tGuess + cx;
    if (dx === 0) break;
    tGuess -= (xGuess - x) / dx;
  }
  
  return ((ay * tGuess + by) * tGuess + cy) * tGuess;
}

// Stagger helper - returns delay for index with jitter
export function getStaggerDelay(index: number, baseDelay: number, jitter = 0.02): number {
  const jitterAmount = (Math.random() - 0.5) * 2 * jitter;
  return baseDelay + index * (baseDelay + jitterAmount);
}

// Overshoot helper - returns scale with overshoot
export function withOvershoot(progress: number, overshoot = 0.15): number {
  if (progress >= 1) return 1;
  const eased = easings.punch(progress);
  if (eased > 1) return 1 + (eased - 1) * overshoot;
  return eased;
}

// Motion blur helper - returns blur amount based on velocity
export function getMotionBlur(velocity: number, maxBlur = 20): number {
  const threshold = 800; // px/s
  if (velocity < threshold) return 0;
  return Math.min(maxBlur, (velocity - threshold) / 100);
}
