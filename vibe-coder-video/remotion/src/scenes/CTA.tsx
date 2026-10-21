import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";
import { TextReveal } from "../components/TextReveal";
import { BouncingArrow } from "../components/BouncingArrow";
import { CaptionBurner, VIDEO_CAPTIONS } from "../components/CaptionBurner";
import { Confetti } from "../components/Confetti";
import { AmbientConfetti } from "../components/Confetti";

export const CTA: React.FC<{ frame: number }> = ({ frame }) => {
  // CTA: 27-30s (810-900 frames)
  const sceneStart = 810;
  const sceneEnd = 900;
  const localFrame = frame - sceneStart;
  
  if (localFrame < 0 || localFrame > 90) return null;
  
  // "Follow to become a vibe coder." - frames 6-45 (27.2-28.5s)
  const textStart = 6;
  const textDuration = 39;
  
  // "vibe coder" highlight - frame 30 (28.0s)
  const vibeCoderFrame = 30;
  
  // Bouncing arrow - frame 36 (28.2s)
  const arrowStart = 36;
  
  // Fade to logo - frames 75-90 (29.5-30.0s)
  const fadeStart = 75;
  const fadeDuration = 15;
  const fadeProgress = localFrame >= fadeStart ? Math.min(1, (localFrame - fadeStart) / fadeDuration) : 0;
  const fadeOpacity = 1 - easings.easeOut(fadeProgress);
  
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
        <linearGradient id="vibeGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stop-color="#FF2D92"/>
          <stop offset="50%" stop-color="#007AFF"/>
          <stop offset="100%" stop-color="#00E676"/>
        </linearGradient>
      </defs>
      
      <rect width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT} fill="url(#bgGradient)" filter="url(#filmGrain)" opacity={fadeOpacity}/>
      
      {/* Ambient confetti */}
      <AmbientConfetti frame={frame} x={SAFE_ZONES.CENTER_X} y={SAFE_ZONES.CONTENT_CENTER_Y} />
      
      {/* Main content */}
      <g opacity={fadeOpacity}>
        {/* CTA Text */}
        <TextReveal
          text="Follow to become a vibe coder."
          startFrame={sceneStart + textStart}
          duration={textDuration}
          frame={frame}
          fontSize={64}
          color="#1A1A2E"
          highlightWords={["vibe coder", "Follow"]}
          highlightColor="#FF2D92"
          y={SAFE_ZONES.CONTENT_CENTER_Y - 100}
          weight="800"
        />
        
        {/* Gradient "vibe coder" text - separate for emphasis */}
        {frame >= sceneStart + vibeCoderFrame && (
          <text
            x={SAFE_ZONES.CENTER_X}
            y={SAFE_ZONES.CONTENT_CENTER_Y - 100}
            textAnchor="middle"
            fontFamily="Poppins, sans-serif"
            fontSize="96"
            fontWeight="800"
            fill="url(#vibeGradient)"
            opacity={interpolate(Math.min(1, (frame - sceneStart - vibeCoderFrame) / 10), [0, 1], [0, 1])}
            style={{ filter: "drop-shadow(0 0 16px #FF2D92)" }}
          >
            vibe coder
          </text>
        )}
        
        {/* Bouncing arrow pointing to follow button zone */}
        <BouncingArrow
          startFrame={sceneStart + arrowStart}
          frame={frame}
          x={SAFE_ZONES.CENTER_X}
          y={SAFE_ZONES.CONTENT_BOTTOM - 180}
          color="#FF2D92"
          size={1.2}
          bounceHeight={25}
          loopDuration={90}
          pointTo="down"
        />
        
        {/* Follow button mockup */}
        {frame >= sceneStart + arrowStart + 15 && (
          <g
            transform={`translate(${SAFE_ZONES.CENTER_X}, ${SAFE_ZONES.CONTENT_BOTTOM - 80})`}
            opacity={interpolate(Math.min(1, (frame - sceneStart - arrowStart - 15) / 20), [0, 1], [0, 1])}
          >
            <rect x={-120} y={-36} width={240} height={72} rx={36} fill="#FF2D92" filter="url(#buttonGlow)"/>
            <text x={0} y={12} textAnchor="middle" fontFamily="Poppins, sans-serif" fontSize="28" fontWeight="800" fill="#FFFFFF">Follow</text>
            <defs>
              <filter id="buttonGlow" x="-50%" y="-50%" width="200%" height="200%">
                <feDropShadow dx="0" dy="4" stdDeviation="12" flood-color="#FF2D92" flood-opacity="0.4"/>
              </filter>
            </defs>
          </g>
        )}
        
        {/* Logo/handle at end */}
        {frame >= sceneStart + fadeStart - 10 && (
          <g
            transform={`translate(${SAFE_ZONES.CENTER_X}, ${SAFE_ZONES.CONTENT_CENTER_Y + 200})`}
            opacity={interpolate(Math.min(1, (frame - sceneStart - fadeStart + 10) / 20), [0, 1], [0, 1]) * fadeOpacity}
          >
            <circle cx={0} cy={0} r={40} fill="url(#vibeGradient)"/>
            <text x={0} y={12} textAnchor="middle" fontFamily="Poppins, sans-serif" fontSize="24" fontWeight="800" fill="#FFFFFF">@</text>
            <text x={0} y={40} textAnchor="middle" fontFamily="Poppins, sans-serif" fontSize="18" fontWeight="600" fill="#FFFFFF">vibecoder</text>
          </g>
        )}
        
        {/* Final confetti burst */}
        <Confetti
          startFrame={sceneStart + fadeStart - 10}
          frame={frame}
          duration={30}
          count={40}
          x={SAFE_ZONES.CENTER_X}
          y={SAFE_ZONES.CONTENT_CENTER_Y}
          burst={true}
        />
      </g>
      
      {/* Captions */}
      <CaptionBurner words={VIDEO_CAPTIONS.cta} frame={frame} y={SAFE_ZONES.CONTENT_BOTTOM - 200} fontSize={48} opacity={fadeOpacity} />
    </svg>
  );
};

export default CTA;
