import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";
import { CodeWindow } from "../components/CodeWindow";
import { TextReveal } from "../components/TextReveal";
import { CaptionBurner, VIDEO_CAPTIONS } from "../components/CaptionBurner";
import { Sparkles } from "../components/Sparkles";
import { AmbientConfetti } from "../components/Confetti";

export const Step3: React.FC<{ frame: number }> = ({ frame }) => {
  // Step 3: 15-22s (450-660 frames)
  const sceneStart = 450;
  const sceneEnd = 660;
  const localFrame = frame - sceneStart;
  
  if (localFrame < 0 || localFrame > 210) return null;
  
  // Header "Step 3" - frames 6-30 (15.2-16.0s)
  const headerStart = 6;
  const headerDuration = 20;
  
  // "Run it. Spot bugs. Ask AI to fix." - frames 15-60 (15.5-17.0s)
  const textStart = 15;
  const textDuration = 45;
  
  // Code window appears - frame 30 (16.0s)
  const codeStart = 30;
  
  // Error banner - frame 75 (17.5s)
  const errorFrame = 75;
  
  // Fix click - frame 120 (19.0s)
  const fixFrame = 120;
  
  // Success - frame 150 (20.5s)
  const successFrame = 150;
  
  // Camera push - frames 180-210 (21.0-22.0s)
  const pushStart = 180;
  const pushDuration = 30;
  const pushProgress = localFrame >= pushStart ? Math.min(1, (localFrame - pushStart) / pushDuration) : 0;
  const pushScale = 1 + easings.smooth(pushProgress) * 0.05;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      {/* Background */}
      <defs>
        <linearGradient id="bgGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stop-color="#FAFAFA"/>
          <stop offset="100%" stop-color="#E8E0FF"/>
        </linearGradient>
        <filter id="filmGrain">
          <feTurbulence type="fractalNoise" baseFrequency="0.9" numStitches="1" result="noise"/>
          <feColorMatrix type="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0.03 0"/>
          <feBlend in="SourceGraphic" in2="noise" mode="overlay"/>
        </filter>
      </defs>
      
      <rect width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT} fill="url(#bgGradient)" filter="url(#filmGrain)"/>
      
      {/* Ambient decorative elements */}
      <AmbientConfetti frame={frame} x={SAFE_ZONES.CENTER_X + 300} y={SAFE_ZONES.CONTENT_CENTER_Y - 200} />
      
      {/* Content with camera push */}
      <g transform={`translate(${SAFE_ZONES.CENTER_X}, ${SAFE_ZONES.CONTENT_CENTER_Y}) scale(${pushScale}) translate(${-SAFE_ZONES.CENTER_X}, ${-SAFE_ZONES.CONTENT_CENTER_Y})`}>
        {/* Step 3 Header */}
        <TextReveal
          text="Step 3"
          startFrame={sceneStart + headerStart}
          duration={headerDuration}
          frame={frame}
          fontSize={72}
          color="#007AFF"
          y={SAFE_ZONES.CONTENT_TOP + 100}
          weight="800"
        />
        
        {/* Main text */}
        <TextReveal
          text="Run it. Spot bugs. Ask AI to fix."
          startFrame={sceneStart + textStart}
          duration={textDuration}
          frame={frame}
          fontSize={56}
          color="#1A1A2E"
          highlightWords={["bugs", "AI", "fix"]}
          highlightColor="#FF2D92"
          y={SAFE_ZONES.CONTENT_TOP + 200}
          weight="600"
        />
        
        {/* Code window */}
        <CodeWindow
          startFrame={sceneStart + codeStart}
          frame={frame}
          errorFrame={sceneStart + errorFrame}
          fixFrame={sceneStart + fixFrame}
          successFrame={sceneStart + successFrame}
          y={SAFE_ZONES.CONTENT_CENTER_Y + 100}
          x={SAFE_ZONES.CENTER_X}
          scale={1}
        />
        
        {/* Success sparkles */}
        <Sparkles
          startFrame={sceneStart + successFrame}
          frame={frame}
          duration={45}
          count={20}
          x={SAFE_ZONES.CENTER_X}
          y={SAFE_ZONES.CONTENT_CENTER_Y + 150}
          color="#00E676"
          size={1.5}
        />
      </g>
      
      {/* Captions */}
      <CaptionBurner words={VIDEO_CAPTIONS.step3} frame={frame} y={SAFE_ZONES.CONTENT_BOTTOM - 200} fontSize={48} />
    </svg>
  );
};

export default Step3;
