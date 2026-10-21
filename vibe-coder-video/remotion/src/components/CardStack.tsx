import React from "react";
import { interpolate } from "remotion";
import { easings, getStaggerDelay } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface Card {
  id: string;
  icon: React.ReactNode;
  label: string;
  color?: string;
}

interface CardStackProps {
  cards: Card[];
  startFrame: number;
  frame: number;
  cardDuration?: number;    // Duration per card animation
  staggerDelay?: number;    // Delay between cards
  y?: number;
  x?: number;
}

const CARD_WIDTH = 280;
const CARD_HEIGHT = 180;
const CARD_GAP = 20;

export const CardStack: React.FC<CardStackProps> = ({
  cards,
  startFrame,
  frame,
  cardDuration = 30,    // 30 frames = 1s at 30fps
  staggerDelay = 4,     // 4 frames = ~133ms
  y = SAFE_ZONES.CONTENT_CENTER_Y,
  x = SAFE_ZONES.CENTER_X,
}) => {
  const totalWidth = cards.length * CARD_WIDTH + (cards.length - 1) * CARD_GAP;
  const startX = x - totalWidth / 2 + CARD_WIDTH / 2;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      {cards.map((card, i) => {
        const cardStartFrame = startFrame + getStaggerDelay(i, staggerDelay, 0.1);
        const elapsed = frame - cardStartFrame;
        
        if (elapsed <= 0) return null;
        if (elapsed > cardDuration * 2) {
          // Static position after animation
          return (
            <g key={card.id} transform={`translate(${startX + i * (CARD_WIDTH + CARD_GAP)}, ${y})`}>
              <CardComponent card={card} index={i} />
            </g>
          );
        }
        
        // Animation progress
        const progress = Math.min(1, elapsed / cardDuration);
        const eased = easings.punch(progress);
        
        // Slide up + scale
        const translateY = interpolate(eased, [0, 1], [100, 0]);
        const scale = interpolate(eased, [0, 1], [0.5, 1]);
        const rotation = interpolate(eased, [0, 1], [-5, 0]);
        const opacity = eased;
        
        const cardX = startX + i * (CARD_WIDTH + CARD_GAP);
        
        return (
          <g
            key={card.id}
            transform={`translate(${cardX}, ${y}) translate(0, ${translateY}) scale(${scale}) rotate(${rotation})`}
            opacity={opacity}
          >
            <CardComponent card={card} index={i} />
          </g>
        );
      })}
    </svg>
  );
};

const CardComponent: React.FC<{ card: Card; index: number }> = ({ card, index }) => {
  const cardColor = card.color || ["#007AFF", "#FF2D92", "#00E676"][index % 3];
  
  return (
    <g>
      <!-- Card background -->
      <rect
        x={-CARD_WIDTH / 2}
        y={-CARD_HEIGHT / 2}
        width={CARD_WIDTH}
        height={CARD_HEIGHT}
        rx={16}
        fill="#FFFFFF"
        filter="url(#cardShadow)"
      />
      
      <!-- Top accent bar -->
      <rect
        x={-CARD_WIDTH / 2}
        y={-CARD_HEIGHT / 2}
        width={CARD_WIDTH}
        height={6}
        rx={16}
        ry={0}
        fill={cardColor}
      />
      
      <!-- Icon -->
      <foreignObject
        x={-48}
        y={-CARD_HEIGHT / 2 + 30}
        width={96}
        height={96}
      >
        <div style={{ display: "flex", justifyContent: "center", alignItems: "center", width: "100%", height: "100%" }}>
          {card.icon}
        </div>
      </foreignObject>
      
      <!-- Label -->
      <text
        x={0}
        y={CARD_HEIGHT / 2 - 30}
        textAnchor="middle"
        fontFamily="Poppins, sans-serif"
        fontSize="36"
        fontWeight="600"
        fill="#1A1A2E"
      >
        {card.label}
      </text>
      
      <!-- Shadow filter -->
      <defs>
        <filter id="cardShadow" x="-20%" y="-20%" width="140%" height="140%">
          <feDropShadow dx="0" dy="8" stdDeviation="16" flood-color="#000000" flood-opacity="0.08"/>
        </filter>
      </defs>
    </g>
  );
};

export default CardStack;
