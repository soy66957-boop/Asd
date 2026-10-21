import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface CaptionWord {
  text: string;
  startFrame: number;
  endFrame: number;
  isKeyword: boolean;
}

interface CaptionBurnerProps {
  words: CaptionWord[];
  frame: number;
  y?: number;
  fontSize?: number;
  baseColor?: string;
  keywordColor?: string;
  maxWidth?: number;
  lineHeight?: number;
  weight?: "400" | "600" | "800";
}

export const CaptionBurner: React.FC<CaptionBurnerProps> = ({
  words,
  frame,
  y = SAFE_ZONES.CONTENT_BOTTOM - 200,
  fontSize = 48,
  baseColor = "#1A1A2E",
  keywordColor = "#FF2D92",
  maxWidth = SAFE_ZONES.CONTENT_WIDTH,
  lineHeight = 1.4,
  weight = "600",
}) => {
  // Find active words
  const activeWords = words.filter(w => frame >= w.startFrame && frame < w.endFrame + 15); // 15 frame hold
  const upcomingWords = words.filter(w => frame < w.startFrame);
  
  // Render all words with appropriate opacity/scale
  const renderedWords = words.map((word, i) => {
    const elapsed = frame - word.startFrame;
    const wordDuration = word.endFrame - word.startFrame;
    
    if (elapsed < 0) {
      // Not yet started - invisible
      return (
        <span key={i} style={{ opacity: 0, visibility: "hidden" }}>
          {word.text} 
        </span>
      );
    }
    
    if (elapsed > wordDuration + 15) {
      // Fully revealed - stable
      return (
        <span
          key={i}
          style={{
            display: "inline-block",
            color: word.isKeyword ? keywordColor : baseColor,
            fontWeight: word.isKeyword ? "800" : weight,
            textShadow: word.isKeyword ? "0 0 8px currentColor" : "none",
          }}
        >
          {word.text} 
        </span>
      );
    }
    
    // Animating in
    const progress = Math.min(1, elapsed / wordDuration);
    const eased = easings.bounce(progress);
    const scale = 0.3 + eased * 0.7;
    
    return (
      <span
        key={i}
        style={{
          display: "inline-block",
          transform: `scale(${scale})`,
          transformOrigin: "center bottom",
          opacity: eased,
          color: word.isKeyword ? keywordColor : baseColor,
          fontWeight: word.isKeyword ? "800" : weight,
          textShadow: word.isKeyword ? "0 0 8px currentColor" : "none",
          filter: word.isKeyword ? "drop-shadow(0 0 8px currentColor)" : "none",
        }}
      >
        {word.text} 
      </span>
    );
  });
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <foreignObject x={0} y={0} width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
        <div
          style={{
            width: SAFE_ZONES.WIDTH,
            height: SAFE_ZONES.HEIGHT,
            display: "flex",
            justifyContent: "center",
            paddingTop: y,
            pointerEvents: "none",
          }}
        >
          <div
            style={{
              maxWidth,
              lineHeight,
              textAlign: "center",
              fontFamily: "Poppins, sans-serif",
              fontWeight: weight,
              fontSize: `${fontSize}px`,
              color: baseColor,
              whiteSpace: "pre-wrap",
            }}
          >
            {renderedWords}
          </div>
        </div>
      </foreignObject>
    </svg>
  );
};

// Helper to generate caption words from voiceover script
export function generateCaptionWords(
  script: string,
  startFrame: number,
  wordsPerMinute = 150,
  fps = 30,
  keywordList: string[] = []
): CaptionWord[] {
  const words = script.trim().split(/\s+/);
  const msPerWord = (60 * 1000) / wordsPerMinute;
  const framesPerWord = Math.round(msPerWord / (1000 / fps));
  
  return words.map((word, i) => ({
    text: word + (i < words.length - 1 ? " " : ""),
    startFrame: startFrame + i * framesPerWord,
    endFrame: startFrame + (i + 1) * framesPerWord,
    isKeyword: keywordList.some(kw => word.toLowerCase().includes(kw.toLowerCase())),
  }));
}

// Pre-defined caption data for the video
export const VIDEO_CAPTIONS = {
  hook: generateCaptionWords(
    "Think you need a CS degree to build apps? Nope.",
    15,  // 0.5s at 30fps
    150,
    30,
    ["degree", "apps", "Nope"]
  ),
  welcome: generateCaptionWords(
    "Welcome to vibe coding.",
    90,  // 3.0s
    150,
    30,
    ["vibe coding"]
  ),
  step1: generateCaptionWords(
    "Step one: pick an AI coding tool.",
    120, // 4.0s
    150,
    30,
    ["AI coding tool"]
  ),
  step2: generateCaptionWords(
    "Step two: describe your idea in plain English.",
    180, // 6.0s
    150,
    30,
    ["plain English"]
  ),
  step3: generateCaptionWords(
    "Step three: run it, spot the bugs, and let AI fix them.",
    270, // 9.0s
    150,
    30,
    ["bugs", "AI", "fix"]
  ),
  step4: generateCaptionWords(
    "Step four: ship something small every single day.",
    390, // 13.0s
    150,
    30,
    ["Ship", "every day"]
  ),
  vibeCoder: generateCaptionWords(
    "Do that, and you're a vibe coder.",
    480, // 16.0s
    150,
    30,
    ["vibe coder"]
  ),
  cta: generateCaptionWords(
    "Follow for more.",
    840, // 28.0s
    150,
    30,
    ["Follow", "vibe coder"]
  ),
};

export default CaptionBurner;
