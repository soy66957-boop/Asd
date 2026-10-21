import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES, clampToSafeZone } from "../utils/safeZones";

interface TextRevealProps {
  text: string;
  startFrame: number;
  duration: number;
  frame: number;
  fontSize?: number;
  color?: string;
  highlightWords?: string[];
  highlightColor?: string;
  y?: number;
  x?: number;
  align?: "center" | "left" | "right";
  lineHeight?: number;
  maxWidth?: number;
  weight?: "400" | "600" | "800";
}

interface Word {
  text: string;
  isHighlighted: boolean;
  startFrame: number;
  endFrame: number;
}

export const TextReveal: React.FC<TextRevealProps> = ({
  text,
  startFrame,
  duration,
  frame,
  fontSize = 72,
  color = "#1A1A2E",
  highlightWords = [],
  highlightColor = "#FF2D92",
  y,
  x = SAFE_ZONES.CENTER_X,
  align = "center",
  lineHeight = 1.2,
  maxWidth = SAFE_ZONES.CONTENT_WIDTH,
  weight = "800",
}) => {
  // Split text into words
  const words = useMemo(() => {
    const wordArray = text.split(/\s+/);
    const wordDuration = duration / wordArray.length;
    return wordArray.map((word, i) => ({
      text: word,
      isHighlighted: highlightWords.some(hw => word.toLowerCase().includes(hw.toLowerCase())),
      startFrame: startFrame + i * wordDuration,
      endFrame: startFrame + (i + 1) * wordDuration,
    }));
  }, [text, startFrame, duration, highlightWords]);
  
  // Calculate total text dimensions for positioning
  const textMetrics = useMemo(() => {
    // Approximate: each character ~0.6 * fontSize width
    const charWidth = fontSize * 0.6;
    const totalWidth = text.length * charWidth;
    const lines = Math.ceil(totalWidth / maxWidth);
    const height = fontSize * lineHeight * lines;
    return { width: Math.min(totalWidth, maxWidth), height, lines };
  }, [text, fontSize, lineHeight, maxWidth]);
  
  // Safe Y position
  const safeY = useMemo(() => {
    if (y !== undefined) return clampToSafeZone(y, textMetrics.height);
    return clampToSafeZone(SAFE_ZONES.CONTENT_CENTER_Y - textMetrics.height / 2, textMetrics.height);
  }, [y, textMetrics.height]);
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <foreignObject x={0} y={0} width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
        <div
          style={{
            width: SAFE_ZONES.WIDTH,
            height: SAFE_ZONES.HEIGHT,
            display: "flex",
            justifyContent: align === "center" ? "center" : align === "left" ? "flex-start" : "flex-end",
            paddingTop: safeY,
            paddingLeft: align === "left" ? SAFE_ZONES.CONTENT_LEFT : 0,
            paddingRight: align === "right" ? SAFE_ZONES.CONTENT_LEFT : 0,
            pointerEvents: "none",
          }}
        >
          <div
            style={{
              maxWidth,
              lineHeight,
              textAlign: align,
              fontFamily: "Poppins, sans-serif",
              fontWeight: weight,
              fontSize: `${fontSize}px`,
              color,
              whiteSpace: "pre-wrap",
            }}
          >
            {words.map((word, i) => {
              const elapsed = frame - word.startFrame;
              if (elapsed <= 0) return <span key={i} style={{ opacity: 0 }}>{word.text} </span>;
              
              const progress = Math.min(1, elapsed / (word.endFrame - word.startFrame));
              const eased = easings.bounce(progress);
              const scale = 0.5 + eased * 0.5; // Scale from 0.5 to 1.0
              
              return (
                <span
                  key={i}
                  style={{
                    display: "inline-block",
                    transform: `scale(${scale})`,
                    transformOrigin: "center bottom",
                    opacity: eased,
                    color: word.isHighlighted ? highlightColor : color,
                    fontWeight: word.isHighlighted ? "800" : weight,
                    filter: word.isHighlighted ? "drop-shadow(0 0 8px currentColor)" : "none",
                  }}
                >
                  {word.text} 
                </span>
              );
            })}
          </div>
        </div>
      </foreignObject>
    </svg>
  );
};

// Helper hook for word-by-word timing
function useMemo<T>(factory: () => T, deps: React.DependencyList): T {
  // Simplified - in actual Remotion this would be React.useMemo
  return factory();
}

export default TextReveal;
