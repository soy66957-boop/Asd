import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface BouncingArrowProps {
  startFrame: number;
  frame: number;
  x?: number;
  y?: number;
  color?: string;
  size?: number;
  bounceHeight?: number;
  loopDuration?: number;
  pointTo?: "follow" | "down" | "up";
}

export const BouncingArrow: React.FC<BouncingArrowProps> = ({
  startFrame,
  frame,
  x = SAFE_ZONES.CENTER_X,
  y = SAFE_ZONES.CONTENT_BOTTOM - 150,
  color = "#FF2D92",
  size = 1,
  bounceHeight = 20,
  loopDuration = 90,    // 3 seconds at 30fps
  pointTo = "down",
}) => {
  const elapsed = frame - startFrame;
  if (elapsed < 0) return null;
  
  // Continuous bounce loop
  const loopProgress = (elapsed % loopDuration) / loopDuration;
  
  // Spring-like bounce: 0 -> 1 -> 0 with overshoot
  const bounceProgress = Math.sin(loopProgress * Math.PI);
  const bounceEased = easings.spring(bounceProgress);
  
  // Vertical bounce offset
  const bounceY = -bounceHeight * bounceEased;
  
  // Subtle scale pulse
  const scalePulse = 1 + Math.sin(loopProgress * Math.PI * 2) * 0.05;
  
  // Rotation based on pointTo
  const rotation = pointTo === "up" ? 180 : pointTo === "follow" ? -90 : 0;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g
        transform={`translate(${x}, ${y}) translate(0, ${bounceY}) scale(${scalePulse * size}) rotate(${rotation})`}
      >
        {/* Arrow shadow */}
        <path
          d="M0 30 L-20 -10 L20 -10 Z"
          fill={color}
          opacity="0.15"
          filter="url(#arrowShadow)"
        />
        
        {/* Main arrow */}
        <path
          d="M0 25 L-18 -10 L18 -10 Z"
          fill={color}
          filter="url(#arrowGlow)"
        />
        
        {/* Inner highlight */}
        <path
          d="M0 20 L-12 -5 L12 -5 Z"
          fill="none"
          stroke="#FFFFFF"
          strokeWidth="2"
          opacity="0.4"
        />
        
        {/* Defs */}
        <defs>
          <filter id="arrowShadow" x="-50%" y="-50%" width="200%" height="200%">
            <feDropShadow dx="0" dy="4" stdDeviation="4" flood-color={color} flood-opacity="0.3"/>
          </filter>
          <filter id="arrowGlow" x="-50%" y="-50%" width="200%" height="200%">
            <feDropShadow dx="0" dy="0" stdDeviation="8" flood-color={color} flood-opacity="0.3"/>
          </filter>
        </defs>
      </g>
    </svg>
  );
};

// Arrow that points to a specific target position
export const TargetArrow: React.FC<{
  frame: number;
  startFrame: number;
  fromX: number;
  fromY: number;
  toX: number;
  toY: number;
  color?: string;
  size?: number;
}> = ({
  frame,
  startFrame,
  fromX,
  fromY,
  toX,
  toY,
  color = "#FF2D92",
  size = 1,
}) => {
  const elapsed = frame - startFrame;
  if (elapsed < 0) return null;
  
  const progress = Math.min(1, elapsed / 30); // 1 second to appear
  const eased = easings.bounce(progress);
  
  // Calculate angle to target
  const dx = toX - fromX;
  const dy = toY - fromY;
  const angle = Math.atan2(dy, dx) * 180 / Math.PI - 90; // -90 to point up
  
  // Distance-based scale
  const distance = Math.sqrt(dx * dx + dy * dy);
  const arrowLength = Math.min(distance * 0.3, 80);
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g
        transform={`translate(${fromX}, ${fromY}) rotate(${angle}) scale(${eased * size})`}
      >
        {/* Arrow shaft */}
        <rect
          x={-4}
          y={-arrowLength}
          width={8}
          height={arrowLength - 20}
          rx={2}
          fill={color}
        />
        
        {/* Arrow head */}
        <path
          d="M0 -20 L-12 -35 L12 -35 Z"
          fill={color}
        />
        
        {/* Pulse at tip */}
        <circle
          cx={0}
          cy={-35}
          r={6}
          fill={color}
          opacity="0.5"
        >
          <animate attributeName="r" values="6;12;6" dur="1s" repeatCount="indefinite"/>
          <animate attributeName="opacity" values="0.5;0;0.5" dur="1s" repeatCount="indefinite"/>
        </circle>
      </g>
    </svg>
  );
};

export default BouncingArrow;
