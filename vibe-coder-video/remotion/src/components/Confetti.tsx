import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface ConfettiProps {
  startFrame: number;
  frame: number;
  duration?: number;           // Total confetti animation duration
  count?: number;              // Number of particles
  x?: number;
  y?: number;
  colors?: string[];
  burst?: boolean;             // Single burst vs continuous
}

const COLORS = ["#007AFF", "#FF2D92", "#FFD600", "#00E676", "#FFFFFF"];
const SHAPES = [
  // square
  <rect key="square" x={-8} y={-8} width={16} height={16} rx={2} />,
  // circle
  <circle key="circle" cx={0} cy={0} r={8} />,
  // triangle
  <polygon key="triangle" points="0,-10 9,9 -9,9" />,
  // strip
  <rect key="strip" x={-10} y={-3} width={20} height={6} rx={1} />,
  // star
  <polygon key="star" points="0,-10 3,-3 10,-3 5,1 7,10 0,5 -7,10 -5,1 -10,-3 -3,-3" />,
];

export const Confetti: React.FC<ConfettiProps> = ({
  startFrame,
  frame,
  duration = 60,      // 2 seconds
  count = 30,
  x = SAFE_ZONES.CENTER_X,
  y = SAFE_ZONES.CONTENT_CENTER_Y,
  colors = COLORS,
  burst = true,
}) => {
  const elapsed = frame - startFrame;
  if (elapsed <= 0 || elapsed > duration) return null;
  
  const progress = elapsed / duration;
  const eased = easings.punch(progress);
  
  // Pre-generate particles for consistency
  const particles = React.useMemo(() => {
    return Array.from({ length: count }, (_, i) => {
      const angle = (i / count) * Math.PI * 2 * (burst ? 1 : 0.5) + (burst ? 0 : Math.PI);
      const initialSpeed = 200 + Math.random() * 300; // px/s
      const gravity = 400; // px/s^2
      const lifetime = 1 + Math.random() * 1.5; // seconds
      const color = colors[i % colors.length];
      const shapeIndex = i % SHAPES.length;
      const rotationSpeed = (Math.random() - 0.5) * 720; // deg/s
      const size = 0.5 + Math.random() * 1.5;
      const delay = Math.random() * 0.3 * (burst ? 1 : 0); // stagger for continuous
      
      return { angle, initialSpeed, gravity, lifetime, color, shapeIndex, rotationSpeed, size, delay };
    });
  }, [count, colors, burst]);
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g transform={`translate(${x}, ${y})`}>
        {particles.map((p, i) => {
          const particleTime = progress - p.delay;
          if (particleTime <= 0) return null;
          if (particleTime > p.lifetime / (duration / 30)) return null;
          
          const t = particleTime / (p.lifetime / (duration / 30));
          const tEased = easings.easeOut(t);
          
          // Physics: initial velocity + gravity
          const vx = Math.cos(p.angle) * p.initialSpeed;
          const vy = Math.sin(p.angle) * p.initialSpeed - p.gravity * t * (duration / 30) / 30;
          
          const px = vx * t * (duration / 30) / 30;
          const py = (Math.sin(p.angle) * p.initialSpeed * t * (duration / 30) / 30) - (0.5 * p.gravity * Math.pow(t * (duration / 30) / 30, 2));
          
          const rotation = p.rotationSpeed * t * (duration / 30) / 30;
          const scale = p.size * (1 - tEased * 0.5);
          const opacity = 1 - tEased;
          
          return (
            <g
              key={i}
              transform={`translate(${px}, ${py}) rotate(${rotation}) scale(${scale})`}
              opacity={opacity}
            >
              <g fill={p.color}>
                {SHAPES[p.shapeIndex]}
              </g>
            </g>
          );
        })}
      </g>
    </svg>
  );
};

// Continuous confetti for ambient effect
export const AmbientConfetti: React.FC<{ frame: number; x?: number; y?: number }> = ({ 
  frame, 
  x = SAFE_ZONES.CENTER_X, 
  y = SAFE_ZONES.CONTENT_CENTER_Y 
}) => {
  const cycle = 180; // 6 seconds
  const cycleFrame = frame % cycle;
  const progress = cycleFrame / cycle;
  
  const particles = React.useMemo(() => {
    return Array.from({ length: 8 }, (_, i) => ({
      angle: (i / 8) * Math.PI * 2,
      speed: 50 + Math.random() * 50,
      color: COLORS[i % COLORS.length],
      shapeIndex: i % SHAPES.length,
      phase: Math.random() * Math.PI * 2,
    }));
  }, []);
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g transform={`translate(${x}, ${y})`}>
        {particles.map((p, i) => {
          const t = (progress + p.phase / (Math.PI * 2)) % 1;
          const radius = 100 + t * 150;
          const angle = p.angle + progress * Math.PI * 0.5;
          const px = Math.cos(angle) * radius;
          const py = Math.sin(angle) * radius - t * 100;
          const opacity = Math.sin(t * Math.PI) * 0.5;
          const scale = 0.5 + t * 0.5;
          
          return (
            <g key={i} transform={`translate(${px}, ${py}) scale(${scale})`} opacity={opacity}>
              <g fill={p.color}>
                {SHAPES[p.shapeIndex]}
              </g>
            </g>
          );
        })}
      </g>
    </svg>
  );
};

export default Confetti;
