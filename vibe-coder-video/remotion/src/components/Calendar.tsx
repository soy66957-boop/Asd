import React from "react";
import { interpolate } from "remotion";
import { easings, getStaggerDelay } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface CalendarProps {
  startFrame: number;
  frame: number;
  fillStartFrame: number;      // When checkmarks start filling
  fillDuration: number;        // Duration per checkmark
  totalDays: number;           // Total days to fill (28)
  filledDays: number;          // How many days are already filled
  y?: number;
  x?: number;
  scale?: number;
}

const CELL_SIZE = 100;
const CELL_GAP = 8;
const COLS = 7;
const ROWS = 4;
const GRID_WIDTH = COLS * CELL_SIZE + (COLS - 1) * CELL_GAP;
const GRID_HEIGHT = ROWS * CELL_SIZE + (ROWS - 1) * CELL_GAP + 40; // +40 for day names

const DAY_NAMES = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

export const Calendar: React.FC<CalendarProps> = ({
  startFrame,
  frame,
  fillStartFrame,
  fillDuration = 10,
  totalDays = 28,
  filledDays = 7,
  y = SAFE_ZONES.CONTENT_CENTER_Y,
  x = SAFE_ZONES.CENTER_X,
  scale = 1,
}) => {
  // Calendar entrance
  const entranceElapsed = frame - startFrame;
  const entranceProgress = entranceElapsed > 0 ? Math.min(1, entranceElapsed / 30) : 0;
  const entranceEased = easings.punch(entranceProgress);
  const entranceScale = interpolate(entranceEased, [0, 1], [0.8, 1]);
  const entranceOpacity = entranceEased;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g
        transform={`translate(${x}, ${y}) scale(${entranceScale * scale})`}
        opacity={entranceOpacity}
      >
        {/* Day names header */}
        <g transform={`translate(${-GRID_WIDTH / 2}, ${-GRID_HEIGHT / 2})`}>
          {DAY_NAMES.map((day, i) => (
            <text
              key={day}
              x={i * (CELL_SIZE + CELL_GAP) + CELL_SIZE / 2}
              y={25}
              textAnchor="middle"
              fontFamily="Poppins, sans-serif"
              fontSize="18"
              fontWeight="600"
              fill="#6A737D"
            >
              {day}
            </text>
          ))}
          
          {/* Grid cells */}
          {Array.from({ length: totalDays }, (_, dayIndex) => {
            const day = dayIndex + 1;
            const col = dayIndex % COLS;
            const row = Math.floor(dayIndex / COLS);
            
            const cellX = col * (CELL_SIZE + CELL_GAP);
            const cellY = 40 + row * (CELL_SIZE + CELL_GAP);
            
            const isFilled = day <= filledDays;
            const fillFrame = fillStartFrame + getStaggerDelay(dayIndex, fillDuration, 0.1);
            const fillElapsed = frame - fillFrame;
            const fillProgress = fillElapsed > 0 ? Math.min(1, fillElapsed / 15) : 0;
            const fillEased = isFilled ? easings.spring(fillProgress) : 0;
            const fillScale = isFilled ? 0.2 + fillEased * 1.1 : 0; // Spring overshoot
            const fillOpacity = isFilled ? fillEased : 0;
            
            // Today indicator (day 7)
            const isToday = day === 7;
            
            return (
              <g key={day} transform={`translate(${cellX}, ${cellY})`}>
                {/* Cell background */}
                <rect
                  x={0}
                  y={0}
                  width={CELL_SIZE}
                  height={CELL_SIZE}
                  rx={12}
                  fill="#FFFFFF"
                  stroke="#E8E0FF"
                  strokeWidth={isToday ? 3 : 2}
                  strokeDasharray={isToday ? "0" : "0"}
                />
                
                {/* Today ring */}
                {isToday && (
                  <rect
                    x={4}
                    y={4}
                    width={CELL_SIZE - 8}
                    height={CELL_SIZE - 8}
                    rx={10}
                    fill="none"
                    stroke="#007AFF"
                    strokeWidth="2"
                    strokeDasharray="8 4"
                  />
                )}
                
                {/* Day number */}
                <text
                  x={CELL_SIZE / 2}
                  y={38}
                  textAnchor="middle"
                  fontFamily="Poppins, sans-serif"
                  fontSize="28"
                  fontWeight="600"
                  fill="#1A1A2E"
                >
                  {day}
                </text>
                
                {/* Checkmark */}
                {isFilled && (
                  <g
                    transform={`translate(${CELL_SIZE / 2}, ${CELL_SIZE / 2 + 10}) scale(${fillScale})`}
                    opacity={fillOpacity}
                  >
                    <circle cx={0} cy={0} r={22} fill="#00E676"/>
                    <path d="M-8 0 L-1 7 L10 -10" stroke="#FFFFFF" strokeWidth="4" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
                  </g>
                )}
                
                {/* Mini confetti burst on fill */}
                {isFilled && fillProgress > 0 && fillProgress < 1 && (
                  <ConfettiBurst 
                    x={CELL_SIZE / 2} 
                    y={CELL_SIZE / 2 + 10} 
                    progress={fillProgress}
                    count={5}
                  />
                )}
              </g>
            );
          })}
        </g>
      </g>
    </svg>
  );
};

const ConfettiBurst: React.FC<{ x: number; y: number; progress: number; count: number }> = ({ 
  x, y, progress, count 
}) => {
  const colors = ["#007AFF", "#FF2D92", "#FFD600", "#00E676", "#FFFFFF"];
  const shapes = ["square", "circle", "triangle"];
  
  return (
    <g>
      {Array.from({ length: count }, (_, i) => {
        const angle = (i / count) * Math.PI * 2 - Math.PI / 2;
        const distance = progress * 60;
        const particleX = x + Math.cos(angle) * distance;
        const particleY = y + Math.sin(angle) * distance;
        const particleScale = 1 - progress;
        const particleOpacity = 1 - progress;
        const color = colors[i % colors.length];
        const shape = shapes[i % shapes.length];
        
        return (
          <g key={i} transform={`translate(${particleX}, ${particleY}) scale(${particleScale}) rotate(${progress * 360 * (i % 2 === 0 ? 1 : -1)})`} opacity={particleOpacity}>
            {shape === "square" && <rect x={-6} y={-6} width={12} height={12} rx={2} fill={color}/>}
            {shape === "circle" && <circle cx={0} cy={0} r={6} fill={color}/>}
            {shape === "triangle" && <polygon points="0,-8 7,7 -7,7" fill={color}/>}
          </g>
        );
      })}
    </g>
  );
};

export default Calendar;
