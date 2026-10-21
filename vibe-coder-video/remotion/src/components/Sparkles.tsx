import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface SparklesProps {
  startFrame: number;
  frame: number;
  duration?: number;
  count?: number;
  x?: number;
  y?: number;
  color?: string;
  size?: number;
  loop?: boolean;
}

export const Sparkles: React.FC<SparklesProps> = ({
  startFrame,
  frame,
  duration = 90,      // 3 seconds
  count = 15,
  x = SAFE_ZONES.CENTER_X,
  y = SAFE_ZONES.CONTENT_CENTER_Y,
  color = "#FFD600",
  size = 1,
  loop = false,
}) => {
  const elapsed = frame - startFrame;
  if (elapsed < 0) return null;
  
  const progress = loop ? (elapsed % duration) / duration : elapsed / duration;
  if (!loop && progress > 1) return null;
  
  // Pre-generate sparkles
  const sparkles = React.useMemo(() => {
    return Array.from({ length: count }, (_, i) => {
      const angle = (i / count) * Math.PI * 2;
      const radius = 40 + Math.random() * 80;
      const delay = Math.random() * 0.5;
      const durationMult = 0.5 + Math.random() * 0.5;
      const twinklePhase = Math.random() * Math.PI * 2;
      const sizeMult = 0.5 + Math.random() * 1.5;
      
      return { angle, radius, delay, durationMult, twinklePhase, sizeMult };
    });
  }, [count]);
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g transform={`translate(${x}, ${y}) scale(${size})`}>
        {sparkles.map((s, i) => {
          const sparkleProgress = (progress - s.delay) / s.durationMult;
          if (sparkleProgress < 0 || sparkleProgress > 1) {
            if (loop) {
              // Loop handling
              const loopProgress = (progress - s.delay) % s.durationMult / s.durationMult;
              return renderSparkle(s, loopProgress, i);
            }
            return null;
          }
          return renderSparkle(s, sparkleProgress, i);
        })}
      </g>
    </svg>
  );
};

function renderSparkle(s: any, progress: number, i: number) {
  const { angle, radius, twinklePhase, sizeMult } = s;
  
  // Eased progress for animation
  const eased = Math.sin(progress * Math.PI); // 0 -> 1 -> 0
  
  // Position
  const px = Math.cos(angle) * radius * eased;
  const py = Math.sin(angle) * radius * eased;
  
  // Scale with twinkle
  const twinkle = Math.sin(progress * Math.PI * 4 + twinklePhase) * 0.3 + 0.7;
  const scale = eased * twinkle * sizeMult;
  
  // Opacity
  const opacity = eased;
  
  // Rotation
  const rotation = progress * 360 * (i % 2 === 0 ? 1 : -1);
  
  return (
    <g key={i} transform={`translate(${px}, ${py}) rotate(${rotation}) scale(${scale})`} opacity={opacity}>
      <SparkleShape color="#FFD600" />
    </g>
  );
}

const SparkleShape: React.FC<{ color?: string }> = ({ color = "#FFD600" }) => (
  <g>
    {/* Glow */}
    <circle cx={0} cy={0} r={10} fill={color} opacity="0.3">
      <animate attributeName="r" values="10;14;10" dur="0.5s" repeatCount="indefinite"/>
      <animate attributeName="opacity" values="0.3;0;0.3" dur="0.5s" repeatCount="indefinite"/>
    </circle>
    
    {/* Cross */}
    <path d="M0 -12 L0 12 M-12 0 L12 0" stroke={color} strokeWidth="2" strokeLinecap="round"/>
    <path d="M-8 -8 L8 8 M8 -8 L-8 8" stroke={color} strokeWidth="1.5" strokeLinecap="round" opacity="0.7"/>
    
    {/* Center */}
    <circle cx={0} cy={0} r={2} fill={color}/>
  </g>
);

// Ambient sparkles for continuous effect
export const AmbientSparkles: React.FC<{ frame: number; x?: number; y?: number; count?: number }> = ({ 
  frame, 
  x = SAFE_ZONES.CENTER_X, 
  y = SAFE_ZONES.CONTENT_CENTER_Y,
  count = 8,
}) => {
  const sparkles = React.useMemo(() => {
    return Array.from({ length: count }, (_, i) => ({
      angle: (i / count) * Math.PI * 2,
      radius: 60 + Math.random() * 100,
      phase: Math.random() * Math.PI * 2,
      size: 0.5 + Math.random() * 1,
      color: ["#FFD600", "#007AFF", "#FF2D92", "#00E676"][i % 4],
    }));
  }, [count]);
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g transform={`translate(${x}, ${y})`}>
        {sparkles.map((s, i) => {
          const t = (frame / 30 + s.phase) % (Math.PI * 2) / (Math.PI * 2);
          const twinkle = Math.sin(t * Math.PI * 4) * 0.4 + 0.6;
          const radius = s.radius * (0.5 + t * 0.5);
          const angle = s.angle + t * Math.PI * 0.3;
          const px = Math.cos(angle) * radius;
          const py = Math.sin(angle) * radius;
          const opacity = twinkle * 0.5;
          const scale = s.size * twinkle;
          
          return (
            <g key={i} transform={`translate(${px}, ${py}) scale(${scale})`} opacity={opacity}>
              <SparkleShape color={s.color} />
            </g>
          );
        })}
      </g>
    </svg>
  );
};

export default Sparkles;
