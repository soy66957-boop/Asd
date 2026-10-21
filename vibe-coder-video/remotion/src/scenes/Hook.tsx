import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";
import { Confetti } from "../components/Confetti";
import { TextReveal } from "../components/TextReveal";
import { CaptionBurner, VIDEO_CAPTIONS } from "../components/CaptionBurner";

export const Hook: React.FC<{ frame: number }> = ({ frame }) => {
  // Hook: 0-3s (0-90 frames)
  if (frame < 0 || frame > 90) return null;
  
  // Background gradient
  const bgProgress = frame / 90;
  const bgShift = interpolate(bgProgress, [0, 1], [0, -50]);
  
  // Riser swell (visual indicator)
  const riserProgress = frame < 15 ? frame / 15 : 1;
  const riserIntensity = easings.easeOut(riserProgress);
  
  // Text 1: "No degree?" - frames 15-45 (0.5-1.5s)
  const text1Start = 15;
  const text1Duration = 20;
  
  // Text 2: "No problem." - frames 30-55 (1.0-1.83s)
  const text2Start = 30;
  const text2Duration = 20;
  
  // Camera punch-in - frames 45-60 (1.5-2.0s)
  const punchStart = 45;
  const punchDuration = 15;
  const punchProgress = frame >= punchStart ? Math.min(1, (frame - punchStart) / punchDuration) : 0;
  const punchScale = 1 + easings.punch(punchProgress) * 0.15;
  
  // Confetti - frames 60-90 (2.0-3.0s)
  const confettiStart = 60;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      {/* Background gradient with subtle film grain */}
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
      
      {/* Riser visual - expanding ring */}
      {frame < 15 && (
        <circle
          cx={SAFE_ZONES.CENTER_X}
          cy={SAFE_ZONES.CENTER_Y}
          r={interpolate(riserIntensity, [0, 1], [0, 400])}
          fill="none"
          stroke="#FFD600"
          strokeWidth={interpolate(riserIntensity, [0, 1], [8, 0])}
          opacity={1 - riserIntensity}
        />
      )}
      
      {/* Main content group with camera punch */}
      <g transform={`translate(${SAFE_ZONES.CENTER_X}, ${SAFE_ZONES.CENTER_Y}) scale(${punchScale}) translate(${-SAFE_ZONES.CENTER_X}, ${-SAFE_ZONES.CENTER_Y})`}>
        {/* "No degree?" */}
        <TextReveal
          text="No degree?"
          startFrame={text1Start}
          duration={text1Duration}
          frame={frame}
          fontSize={96}
          color="#1A1A2E"
          highlightWords={["degree"]}
          highlightColor="#FF2D92"
          y={500}
          weight="800"
        />
        
        {/* "No problem." */}
        <TextReveal
          text="No problem."
          startFrame={text2Start}
          duration={text2Duration}
          frame={frame}
          fontSize={96}
          color="#FF2D92"
          highlightWords={["problem"]}
          highlightColor="#FF2D92"
          y={620}
          weight="800"
        />
        
        {/* Confetti burst */}
        <Confetti
          startFrame={confettiStart}
          frame={frame}
          duration={30}
          count={30}
          x={SAFE_ZONES.CENTER_X}
          y={560}
          burst={true}
        />
      </g>
      
      {/* Captions */}
      <CaptionBurner words={VIDEO_CAPTIONS.hook} frame={frame} y={SAFE_ZONES.CONTENT_BOTTOM - 200} fontSize={48} />
    </svg>
  );
};

export default Hook;
