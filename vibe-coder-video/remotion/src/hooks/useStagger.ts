import { useMemo } from "react";

// Staggered animation hook for Remotion
// Based on PRODUCTION_SPEC.md: 80-120ms stagger with slight uneven timing

interface StaggerConfig {
  baseDelay?: number;      // Base delay in frames (default: 4 frames = ~133ms at 30fps)
  jitter?: number;         // Jitter factor 0-1 (default: 0.15 = ±15%)
  staggerFrames?: number;  // Frames between each item (default: 4)
}

interface StaggerResult {
  delays: number[];        // Start frame for each item
  progresses: number[];    // Progress (0-1) for each item at current frame
  isActive: boolean[];     // Whether each item has started
  allComplete: boolean;    // Whether all items have completed
}

export function useStagger(
  frame: number,
  itemCount: number,
  startFrame: number,
  duration: number,
  config: StaggerConfig = {}
): StaggerResult {
  const { 
    baseDelay = 4,       // ~133ms
    jitter = 0.15,       // ±15%
    staggerFrames = 4    // ~133ms between items
  } = config;
  
  const delays = useMemo(() => {
    const result: number[] = [];
    for (let i = 0; i < itemCount; i++) {
      const jitterAmount = (Math.random() - 0.5) * 2 * jitter * staggerFrames;
      result.push(startFrame + baseDelay + i * staggerFrames + jitterAmount);
    }
    return result;
  }, [itemCount, startFrame, baseDelay, staggerFrames, jitter]);
  
  const progresses = useMemo(() => {
    return delays.map(delay => {
      const elapsed = frame - delay;
      if (elapsed <= 0) return 0;
      if (elapsed >= duration) return 1;
      return elapsed / duration;
    });
  }, [frame, delays, duration]);
  
  const isActive = useMemo(() => 
    progresses.map(p => p > 0),
    [progresses]
  );
  
  const allComplete = useMemo(() => 
    progresses.every(p => p >= 1),
    [progresses]
  );
  
  return { delays, progresses, isActive, allComplete };
}

// Stagger with custom easing per item
export function useStaggerEased(
  frame: number,
  itemCount: number,
  startFrame: number,
  duration: number,
  easing: (t: number) => number = (t) => t,
  config: StaggerConfig = {}
): StaggerResult {
  const { delays, progresses, isActive, allComplete } = useStagger(
    frame, itemCount, startFrame, duration, config
  );
  
  const easedProgresses = useMemo(() => 
    progresses.map(p => easing(p)),
    [progresses, easing]
  );
  
  return { delays, progresses: easedProgresses, isActive, allComplete };
}

// Helper to get progress for single item index
export function useStaggerItem(
  frame: number,
  index: number,
  startFrame: number,
  duration: number,
  config: StaggerConfig = {}
): number {
  const { baseDelay = 4, staggerFrames = 4, jitter = 0.15 } = config;
  
  const jitterAmount = (Math.random() - 0.5) * 2 * jitter * staggerFrames;
  const delay = startFrame + baseDelay + index * staggerFrames + jitterAmount;
  
  const elapsed = frame - delay;
  if (elapsed <= 0) return 0;
  if (elapsed >= duration) return 1;
  return elapsed / duration;
}

// Sequential stagger - each item waits for previous to reach threshold
export function useSequentialStagger(
  frame: number,
  itemCount: number,
  startFrame: number,
  itemDuration: number,
  threshold = 0.3,  // Start next when previous reaches 30%
  config: StaggerConfig = {}
): StaggerResult {
  const { baseDelay = 4, staggerFrames = 4, jitter = 0.15 } = config;
  
  const delays = useMemo(() => {
    const result: number[] = [startFrame + baseDelay];
    for (let i = 1; i < itemCount; i++) {
      // Next item starts when previous reaches threshold
      const prevDelay = result[i - 1];
      const triggerFrame = prevDelay + itemDuration * threshold;
      const jitterAmount = (Math.random() - 0.5) * 2 * jitter * staggerFrames;
      result.push(triggerFrame + staggerFrames + jitterAmount);
    }
    return result;
  }, [itemCount, startFrame, baseDelay, staggerFrames, jitter, itemDuration, threshold]);
  
  const progresses = useMemo(() => 
    delays.map(delay => {
      const elapsed = frame - delay;
      if (elapsed <= 0) return 0;
      if (elapsed >= itemDuration) return 1;
      return elapsed / itemDuration;
    }),
    [frame, delays, itemDuration]
  );
  
  const isActive = useMemo(() => 
    progresses.map(p => p > 0),
    [progresses]
  );
  
  const allComplete = useMemo(() => 
    progresses.every(p => p >= 1),
    [progresses]
  );
  
  return { delays, progresses, isActive, allComplete };
}
