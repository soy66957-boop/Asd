import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";
import { Calendar } from "../components/Calendar";
import { TextReveal } from "../components/TextReveal";
import { CaptionBurner, VIDEO_CAPTIONS } from "../components/CaptionBurner";
import { Sparkles } from "../components/Sparkles";
import { AmbientConfetti } from "../components/Confetti";

export const Step4: React.FC<{ frame: number }> = ({ frame }) => {
  // Step 4: 22-27s (660-810 frames)
  const sceneStart = 660;
  const sceneEnd = 810;
  const localFrame = frame - sceneStart;
  
  if (localFrame < 0 || localFrame > 150) return null;
  
  // Header "Step 4" - frames 6-30 (22.2-23.0s)
  const headerStart = 6;
  const headerDuration = 20;
  
  // "Ship something small every day." - frames 15-60 (22.5-24.0s)
  const textStart = 15;
  const textDuration = 45;
  
  // Calendar appears - frame 30 (23.0s)
  const calendarStart = 30;
  
  // Checkmarks fill - frames 45-105 (23.5-25.5s)
  const fillStart = 45;
  const fillDuration = 10; // per checkmark
  
  // Camera pull back - frames 120-150 (26.0-27.0s)
  const pullStart = 120;
  const pullDuration = 30;
  const pullProgress = localFrame >= pullStart ? Math.min(1, (localFrame - pullStart) / pullDuration) : 0;
  const pullScale = 1.05 - easings.smooth(pullProgress) * 0.05;
  
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
      <AmbientConfetti frame={frame} x={SAFE_ZONES.CENTER_X - 300} y={SAFE_ZONES.CONTENT_CENTER_Y - 200} />
      
      {/* Content with camera pull back */}
      <g transform={`translate(${SAFE_ZONES.CENTER_X}, ${SAFE_ZONES.CONTENT_CENTER_Y}) scale(${pullScale}) translate(${-SAFE_ZONES.CENTER_X}, ${-SAFE_ZONES.CONTENT_CENTER_Y})`}>
        {/* Step 4 Header */}
        <TextReveal
          text="Step 4"
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
          text="Ship something small every day."
          startFrame={sceneStart + textStart}
          duration={textDuration}
          frame={frame}
          fontSize={56}
          color="#1A1A2E"
          highlightWords={["Ship", "every day"]}
          highlightColor="#FF2D92"
          y={SAFE_ZONES.CONTENT_TOP + 200}
          weight="600"
        />
        
        {/* Calendar */}
        <Calendar
          startFrame={sceneStart + calendarStart}
          frame={frame}
          fillStartFrame={sceneStart + fillStart}
          fillDuration={fillDuration}
          totalDays={28}
          filledDays={14} // Two weeks filled
          y={SAFE_ZONES.CONTENT_CENTER_Y + 80}
          x={SAFE_ZONES.CENTER_X}
          scale={1}
        />
        
        {/* Sparkles on calendar */}
        <Sparkles
          startFrame={sceneStart + fillStart + 60}
          frame={frame}
          duration={60}
          count={12}
          x={SAFE_ZONES.CENTER_X}
          y={SAFE_ZONES.CONTENT_CENTER_Y + 80}
          color="#FFD600"
          size={1}
        />
      </g>
      
      {/* Captions */}
      <CaptionBurner words={VIDEO_CAPTIONS.step4} frame={frame} y={SAFE_ZONES.CONTENT_BOTTOM - 200} fontSize={48} />
    </svg>
  );
};

export default Step4;
