import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";
import { CardStack } from "../components/CardStack";
import { TextReveal } from "../components/TextReveal";
import { CaptionBurner, VIDEO_CAPTIONS } from "../components/CaptionBurner";
import { AmbientSparkles } from "../components/Sparkles";
import { AmbientConfetti } from "../components/Confetti";

export const Step1: React.FC<{ frame: number }> = ({ frame }) => {
  // Step 1: 3-8s (90-240 frames)
  const sceneStart = 90;
  const sceneEnd = 240;
  const localFrame = frame - sceneStart;
  
  if (localFrame < 0 || localFrame > 150) return null;
  
  // Background
  const bgProgress = localFrame / 150;
  
  // Header "Step 1" - frames 6-30 (3.2-4.0s)
  const headerStart = 6;
  const headerDuration = 20;
  
  // "Pick an AI coding tool." - frames 15-60 (3.5-5.0s)
  const textStart = 15;
  const textDuration = 45;
  
  // Card stack - frames 36-72 (4.2-5.4s)
  const cardsStart = 36;
  
  // Camera push - frames 120-150 (7.0-8.0s)
  const pushStart = 120;
  const pushDuration = 30;
  const pushProgress = localFrame >= pushStart ? Math.min(1, (localFrame - pushStart) / pushDuration) : 0;
  const pushScale = 1 + easings.smooth(pushProgress) * 0.05;
  
  const cards = [
    { id: "cursor", icon: "🎯", label: "Cursor", color: "#007AFF" },
    { id: "copilot", icon: "🤖", label: "Copilot", color: "#FF2D92" },
    { id: "windsurf", icon: "🌊", label: "Windsurf", color: "#00E676" },
  ];
  
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
      <AmbientSparkles frame={frame} x={SAFE_ZONES.CENTER_X} y={SAFE_ZONES.CONTENT_CENTER_Y - 300} count={5} />
      <AmbientConfetti frame={frame} x={SAFE_ZONES.CENTER_X} y={SAFE_ZONES.CONTENT_CENTER_Y + 200} />
      
      {/* Content with camera push */}
      <g transform={`translate(${SAFE_ZONES.CENTER_X}, ${SAFE_ZONES.CONTENT_CENTER_Y}) scale(${pushScale}) translate(${-SAFE_ZONES.CENTER_X}, ${-SAFE_ZONES.CONTENT_CENTER_Y})`}>
        {/* Step 1 Header */}
        <TextReveal
          text="Step 1"
          startFrame={sceneStart + headerStart}
          duration={headerDuration}
          frame={frame}
          fontSize={72}
          color="#007AFF"
          y={SAFE_ZONES.CONTENT_CENTER_Y - 400}
          weight="800"
        />
        
        {/* Main text */}
        <TextReveal
          text="Pick an AI coding tool."
          startFrame={sceneStart + textStart}
          duration={textDuration}
          frame={frame}
          fontSize={64}
          color="#1A1A2E"
          highlightWords={["AI coding tool"]}
          highlightColor="#007AFF"
          y={SAFE_ZONES.CONTENT_CENTER_Y - 300}
          weight="600"
        />
        
        {/* Card stack */}
        <CardStack
          cards={cards}
          startFrame={sceneStart + cardsStart}
          frame={frame}
          cardDuration={20}
          staggerDelay={4}
          y={SAFE_ZONES.CONTENT_CENTER_Y + 50}
        />
      </g>
      
      {/* Captions */}
      <CaptionBurner words={VIDEO_CAPTIONS.step1} frame={frame} y={SAFE_ZONES.CONTENT_BOTTOM - 200} fontSize={48} />
    </svg>
  );
};

export default Step1;
