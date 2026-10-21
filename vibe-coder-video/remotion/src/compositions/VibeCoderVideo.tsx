import React from "react";
import { Composition, useCurrentFrame } from "remotion";
import { Hook } from "./scenes/Hook";
import { Step1 } from "./scenes/Step1";
import { Step2 } from "./scenes/Step2";
import { Step3 } from "./scenes/Step3";
import { Step4 } from "./scenes/Step4";
import { CTA } from "./scenes/CTA";

// Video configuration
export const VIDEO_CONFIG = {
  width: 1080,
  height: 1920,
  fps: 30,
  durationInFrames: 900, // 30 seconds at 30fps
  // For 60fps: durationInFrames: 1800, fps: 60
};

export const VibeCoderVideo: React.FC = () => {
  const frame = useCurrentFrame();
  
  return (
    <>
      {/* Scene 0: Hook (0-3s / 0-90 frames) */}
      <Hook frame={frame} />
      
      {/* Scene 1: Step 1 (3-8s / 90-240 frames) */}
      <Step1 frame={frame} />
      
      {/* Scene 2: Step 2 (8-15s / 240-450 frames) */}
      <Step2 frame={frame} />
      
      {/* Scene 3: Step 3 (15-22s / 450-660 frames) */}
      <Step3 frame={frame} />
      
      {/* Scene 4: Step 4 (22-27s / 660-810 frames) */}
      <Step4 frame={frame} />
      
      {/* Scene 5: CTA (27-30s / 810-900 frames) */}
      <CTA frame={frame} />
    </>
  );
};

// Register the composition
export const registerRoot = () => {
  registerRootComposition();
};

function registerRootComposition() {
  // This would be called by Remotion
  return (
    <Composition
      id="VibeCoderVideo"
      component={VibeCoderVideo}
      width={VIDEO_CONFIG.width}
      height={VIDEO_CONFIG.height}
      fps={VIDEO_CONFIG.fps}
      durationInFrames={VIDEO_CONFIG.durationInFrames}
      defaultProps={{}}
    />
  );
}

export default VibeCoderVideo;
