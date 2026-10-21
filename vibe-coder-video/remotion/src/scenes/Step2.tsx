import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";
import { ChatBox } from "../components/ChatBox";
import { PhoneMockup } from "../components/PhoneMockup";
import { TextReveal } from "../components/TextReveal";
import { CaptionBurner, VIDEO_CAPTIONS } from "../components/CaptionBurner";
import { Sparkles } from "../components/Sparkles";
import { AmbientConfetti } from "../components/Confetti";

export const Step2: React.FC<{ frame: number }> = ({ frame }) => {
  // Step 2: 8-15s (240-450 frames)
  const sceneStart = 240;
  const sceneEnd = 450;
  const localFrame = frame - sceneStart;
  
  if (localFrame < 0 || localFrame > 210) return null;
  
  // Header "Step 2" - frames 6-30 (8.2-9.0s)
  const headerStart = 6;
  const headerDuration = 20;
  
  // "Describe your idea in plain English." - frames 15-60 (8.5-10.0s)
  const textStart = 15;
  const textDuration = 45;
  
  // Chat box appears - frame 30 (9.0s)
  const chatStart = 30;
  
  // Prompt types - frames 30-105 (9.0-11.5s)
  const typingStart = 30;
  const typingDuration = 75;
  
  // Send - frame 105 (11.5s)
  const sendFrame = 105;
  
  // Phone appears - frame 120 (12.0s)
  const phoneStart = 120;
  
  // App builds - frames 135-210 (12.5-15.0s)
  const buildStart = 135;
  const buildDuration = 75;
  
  // Camera push on phone - frames 180-210 (14.0-15.0s)
  const pushStart = 180;
  const pushDuration = 30;
  const pushProgress = localFrame >= pushStart ? Math.min(1, (localFrame - pushStart) / pushDuration) : 0;
  const pushScale = 1 + easings.smooth(pushProgress) * 0.08;
  
  // Sparkles from phone - frames 135-165
  const sparklesStart = 135;
  
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
      <AmbientConfetti frame={frame} x={SAFE_ZONES.CENTER_X - 300} y={SAFE_ZONES.CONTENT_CENTER_Y + 300} />
      
      {/* Content with camera push on phone area */}
      <g>
        {/* Step 2 Header */}
        <TextReveal
          text="Step 2"
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
          text="Describe your idea in plain English."
          startFrame={sceneStart + textStart}
          duration={textDuration}
          frame={frame}
          fontSize={56}
          color="#1A1A2E"
          highlightWords={["plain English"]}
          highlightColor="#FF2D92"
          y={SAFE_ZONES.CONTENT_TOP + 200}
          weight="600"
        />
        
        {/* Chat box - left side */}
        <ChatBox
          prompt="Build a habit tracker with streaks and reminders"
          startFrame={sceneStart + chatStart}
          frame={frame}
          typingDuration={typingDuration}
          sendFrame={sceneStart + sendFrame}
          y={SAFE_ZONES.CONTENT_CENTER_Y - 150}
          x={SAFE_ZONES.CENTER_X - 200}
        />
        
        {/* Phone mockup - right side */}
        <PhoneMockup
          startFrame={sceneStart + phoneStart}
          frame={frame}
          buildStartFrame={sceneStart + buildStart}
          buildDuration={buildDuration}
          y={SAFE_ZONES.CONTENT_CENTER_Y + 100}
          x={SAFE_ZONES.CENTER_X + 400}
          scale={1}
        />
        
        {/* Sparkles from phone screen */}
        <Sparkles
          startFrame={sceneStart + sparklesStart}
          frame={frame}
          duration={30}
          count={15}
          x={SAFE_ZONES.CENTER_X + 400}
          y={SAFE_ZONES.CONTENT_CENTER_Y + 100}
          color="#FFD600"
          size={1.2}
        />
      </g>
      
      {/* Captions */}
      <CaptionBurner words={VIDEO_CAPTIONS.step2} frame={frame} y={SAFE_ZONES.CONTENT_BOTTOM - 200} fontSize={48} />
    </svg>
  );
};

export default Step2;
