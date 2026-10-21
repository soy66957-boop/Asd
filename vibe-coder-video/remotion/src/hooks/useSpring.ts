import { useMemo } from "react";
import { interpolate } from "remotion";

// Spring animation hook for Remotion
// Based on PRODUCTION_SPEC.md spring(1, 80, 10)

interface SpringConfig {
  stiffness?: number;  // default 1 (normalized)
  damping?: number;    // default 80
  mass?: number;       // default 10
  overshoot?: number;  // overshoot amount (0-1)
}

interface SpringResult {
  scale: number;
  progress: number;
  velocity: number;
}

export function useSpring(
  frame: number,
  startFrame: number,
  duration: number,
  config: SpringConfig = {}
): SpringResult {
  const { stiffness = 1, damping = 80, mass = 10, overshoot = 0.15 } = config;
  
  const progress = useMemo(() => {
    const elapsed = frame - startFrame;
    if (elapsed <= 0) return 0;
    if (elapsed >= duration) return 1;
    return elapsed / duration;
  }, [frame, startFrame, duration]);
  
  // Spring physics simulation
  const springValue = useMemo(() => {
    if (progress <= 0) return 0;
    if (progress >= 1) return 1;
    
    const omega = Math.sqrt(stiffness / mass);
    const zeta = damping / (2 * Math.sqrt(stiffness * mass));
    const t = progress * duration / 30; // Convert to seconds
    
    if (zeta < 1) {
      // Underdamped - oscillates
      const omegaD = omega * Math.sqrt(1 - zeta * zeta);
      const envelope = Math.exp(-zeta * omega * t);
      const oscillation = Math.cos(omegaD * t) + (zeta / Math.sqrt(1 - zeta * zeta)) * Math.sin(omegaD * t);
      return 1 - envelope * oscillation;
    } else {
      // Overdamped
      return 1 - Math.exp(-omega * t);
    }
  }, [progress, stiffness, damping, mass, duration]);
  
  // Apply overshoot
  const scale = useMemo(() => {
    if (springValue >= 1) return 1;
    if (springValue > 1 - overshoot) {
      // In overshoot zone
      return 1 + (springValue - (1 - overshoot)) / overshoot * overshoot;
    }
    return springValue;
  }, [springValue, overshoot]);
  
  // Approximate velocity (derivative)
  const velocity = useMemo(() => {
    const dt = 1 / 30;
    const nextProgress = Math.min(1, progress + dt);
    const nextValue = nextProgress >= 1 ? 1 : 
      (() => {
        const t = nextProgress * duration / 30;
        const omega = Math.sqrt(stiffness / mass);
        const zeta = damping / (2 * Math.sqrt(stiffness * mass));
        if (zeta < 1) {
          const omegaD = omega * Math.sqrt(1 - zeta * zeta);
          const envelope = Math.exp(-zeta * omega * t);
          const oscillation = Math.cos(omegaD * t) + (zeta / Math.sqrt(1 - zeta * zeta)) * Math.sin(omegaD * t);
          return 1 - envelope * oscillation;
        }
        return 1 - Math.exp(-omega * t);
      })();
    return (nextValue - springValue) / dt;
  }, [springValue, progress, duration, stiffness, damping, mass]);
  
  return { scale, progress: springValue, velocity };
}

// Spring interpolation for any value
export function useSpringValue<T>(
  frame: number,
  startFrame: number,
  duration: number,
  from: T,
  to: T,
  config: SpringConfig = {},
  interpolator: (from: T, to: T, progress: number) => T = (f, t, p) => 
    f + (t - f) * p as unknown as T
): T {
  const { progress } = useSpring(frame, startFrame, duration, config);
  return useMemo(() => interpolator(from, to, progress), [from, to, progress, interpolator]);
}

// Spring for 2D position
export function useSpringPosition(
  frame: number,
  startFrame: number,
  duration: number,
  from: { x: number; y: number },
  to: { x: number; y: number },
  config: SpringConfig = {}
): { x: number; y: number } {
  const { progress } = useSpring(frame, startFrame, duration, config);
  return useMemo(() => ({
    x: interpolate(progress, [0, 1], [from.x, to.x]),
    y: interpolate(progress, [0, 1], [from.y, to.y]),
  }), [progress, from, to]);
}
