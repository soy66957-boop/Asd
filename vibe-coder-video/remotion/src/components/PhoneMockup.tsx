import React from "react";
import { interpolate } from "remotion";
import { easings, getStaggerDelay } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface PhoneMockupProps {
  startFrame: number;
  frame: number;
  buildStartFrame?: number;     // When app UI starts building
  buildDuration?: number;       // Total build animation duration
  y?: number;
  x?: number;
  scale?: number;
}

const PHONE_WIDTH = 320;
const PHONE_HEIGHT = 640;
const SCREEN_WIDTH = 288;
const SCREEN_HEIGHT = 560;
const BEZEL = 16;

export const PhoneMockup: React.FC<PhoneMockupProps> = ({
  startFrame,
  frame,
  buildStartFrame = startFrame + 30,
  buildDuration = 120,   // 4 seconds
  y = SAFE_ZONES.CONTENT_CENTER_Y + 100,
  x = SAFE_ZONES.CENTER_X + 400,
  scale = 1,
}) => {
  // Phone entrance (slide from right)
  const entranceElapsed = frame - startFrame;
  const entranceProgress = entranceElapsed > 0 ? Math.min(1, entranceElapsed / 20) : 0;
  const entranceEased = easings.punch(entranceProgress);
  const entranceX = interpolate(entranceEased, [0, 1], [400, 0]);
  const entranceOpacity = entranceEased;
  
  // App UI build progress
  const buildElapsed = frame - buildStartFrame;
  const buildProgress = buildElapsed > 0 ? Math.min(1, buildElapsed / buildDuration) : 0;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g
        transform={`translate(${x + entranceX}, ${y}) scale(${scale})`}
        opacity={entranceOpacity}
      >
        <!-- Phone shadow -->
        <ellipse cx="0" cy={PHONE_HEIGHT / 2 + 20} rx={120} ry={8} fill="#00000015"/>
        
        <!-- Phone body -->
        <rect
          x={-PHONE_WIDTH / 2}
          y={-PHONE_HEIGHT / 2}
          width={PHONE_WIDTH}
          height={PHONE_HEIGHT}
          rx={32}
          fill="#1A1A2E"
        />
        <rect
          x={-PHONE_WIDTH / 2}
          y={-PHONE_HEIGHT / 2}
          width={PHONE_WIDTH}
          height={PHONE_HEIGHT}
          rx={32}
          stroke="#3A3A4A"
          strokeWidth="2"
          fill="none"
        />
        
        <!-- Dynamic Island -->
        <rect
          x={-70}
          y={-PHONE_HEIGHT / 2 + 20}
          width={140}
          height={28}
          rx={14}
          fill="#0A0A0A"
        />
        
        <!-- Screen -->
        <rect
          x={-SCREEN_WIDTH / 2}
          y={-PHONE_HEIGHT / 2 + 60}
          width={SCREEN_WIDTH}
          height={SCREEN_HEIGHT}
          rx={24}
          fill="#FFFFFF"
        >
          <animate attributeName="opacity" from="0" to="1" dur="0.3s" begin={`${buildStartFrame / 30}s`} fill="freeze"/>
        </rect>
        
        {/* Screen Content - Habit Tracker App */}
        <PhoneScreenContent 
          buildProgress={buildProgress} 
          screenWidth={SCREEN_WIDTH} 
          screenHeight={SCREEN_HEIGHT}
          buildDuration={buildDuration}
        />
        
        <!-- Home indicator -->
        <rect
          x={-25}
          y={PHONE_HEIGHT / 2 - 30}
          width={50}
          height={5}
          rx={2.5}
          fill="#D0D0D0"
        />
      </g>
    </svg>
  );
};

const PhoneScreenContent: React.FC<{ 
  buildProgress: number; 
  screenWidth: number; 
  screenHeight: number;
  buildDuration: number;
}> = ({ buildProgress, screenWidth, screenHeight, buildDuration }) => {
  const headerHeight = 70;
  const cardHeight = 100;
  const cardGap = 20;
  const navHeight = 70;
  
  // Staggered build for each UI element
  const elements = [
    { id: "header", start: 0, duration: 0.15 },
    { id: "card1", start: 0.2, duration: 0.15 },
    { id: "card2", start: 0.35, duration: 0.15 },
    { id: "card3", start: 0.5, duration: 0.15 },
    { id: "nav", start: 0.7, duration: 0.15 },
  ];
  
  return (
    <g transform={`translate(${-screenWidth / 2}, ${-screenHeight / 2 + 60})`}>
      {/* Header */}
      <g opacity={getElementProgress(buildProgress, elements[0])}>
        <rect x="0" y="0" width={screenWidth} height={headerHeight} fill="#FAFAFA"/>
        <text x="32" y={headerHeight * 0.45} fontFamily="Poppins, sans-serif" fontSize="24" fontWeight="800" fill="#1A1A2E">Streak</text>
        <text x="32" y={headerHeight * 0.75} fontFamily="Poppins, sans-serif" fontSize="13" fill="#6A737D">7 day streak! 🔥</text>
      </g>
      
      {/* Card 1: Coding */}
      <g 
        transform={`translate(0, ${headerHeight + cardGap})`} 
        opacity={getElementProgress(buildProgress, elements[1])}
      >
        <HabitCard 
          width={screenWidth} 
          height={cardHeight}
          icon="💻"
          color="#007AFF"
          bgColor="#E8E0FF"
          title="Coding"
          subtitle="7 day streak • 2h today"
          checked={true}
        />
      </g>
      
      {/* Card 2: Workout */}
      <g 
        transform={`translate(0, ${headerHeight + cardGap + cardHeight + cardGap})`} 
        opacity={getElementProgress(buildProgress, elements[2])}
      >
        <HabitCard 
          width={screenWidth} 
          height={cardHeight}
          icon="💪"
          color="#FF2D92"
          bgColor="#FFE0E0"
          title="Workout"
          subtitle="3 day streak • 45 min"
          checked={false}
        />
      </g>
      
      {/* Card 3: Reading */}
      <g 
        transform={`translate(0, ${headerHeight + cardGap + (cardHeight + cardGap) * 2})`} 
        opacity={getElementProgress(buildProgress, elements[3])}
      >
        <HabitCard 
          width={screenWidth} 
          height={cardHeight}
          icon="📚"
          color="#00E676"
          bgColor="#E0FFE0"
          title="Reading"
          subtitle="1 day streak • 20 min"
          checked={false}
        />
      </g>
      
      {/* Bottom Nav */}
      <g 
        transform={`translate(0, ${screenHeight - navHeight})`} 
        opacity={getElementProgress(buildProgress, elements[4])}
      >
        <rect x="0" y="0" width={screenWidth} height={navHeight} rx={24} fill="#FAFAFA" stroke="#E8E0FF" strokeWidth="1"/>
        <circle cx={80} cy={navHeight / 2} r="20" fill="#007AFF"/>
        <text x={80} y={navHeight / 2 + 6} fontFamily="Poppins, sans-serif" fontSize="16" fill="#FFFFFF" textAnchor="middle">+</text>
        <text x={screenWidth / 2} y={navHeight / 2 + 12} fontFamily="Poppins, sans-serif" fontSize="12" fill="#6A737D" textAnchor="middle">Add Habit</text>
        <circle cx={screenWidth - 80} cy={navHeight / 2} r="20" fill="#E8E0FF"/>
        <text x={screenWidth - 80} y={navHeight / 2 + 6} fontFamily="Poppins, sans-serif" fontSize="16" fill="#007AFF" textAnchor="middle">⚙</text>
      </g>
    </g>
  );
};

function getElementProgress(overallProgress: number, element: { start: number; duration: number }): number {
  const elapsed = overallProgress - element.start;
  if (elapsed <= 0) return 0;
  if (elapsed >= element.duration) return 1;
  return easings.punch(elapsed / element.duration);
}

const HabitCard: React.FC<{
  width: number;
  height: number;
  icon: string;
  color: string;
  bgColor: string;
  title: string;
  subtitle: string;
  checked: boolean;
}> = ({ width, height, icon, color, bgColor, title, subtitle, checked }) => {
  const padding = 16;
  const iconSize = 48;
  
  return (
    <g>
      <rect x={padding} y={0} width={width - padding * 2} height={height} rx={16} fill="#FFFFFF" stroke="#E8E0FF" strokeWidth="2"/>
      <circle cx={padding + iconSize / 2} cy={height / 2} r={iconSize / 2} fill={bgColor}/>
      <text x={padding + iconSize / 2} y={height / 2 + 8} fontFamily="Poppins, sans-serif" fontSize="20" fill={color} textAnchor="middle">{icon}</text>
      <text x={padding + iconSize + 16} y={height / 2 - 10} fontFamily="Poppins, sans-serif" fontSize="18" fontWeight="600" fill="#1A1A2E">{title}</text>
      <text x={padding + iconSize + 16} y={height / 2 + 15} fontFamily="Poppins, sans-serif" fontSize="13" fill="#6A737D">{subtitle}</text>
      <g transform={`translate(${width - padding - 40}, ${height / 2 - 15})`}>
        {checked ? (
          <>
            <rect x={0} y={0} width={30} height={30} rx={8} fill="#00E676"/>
            <path d="M6 15 L12 21 L24 9" stroke="#FFFFFF" strokeWidth="3" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
          </>
        ) : (
          <rect x={0} y={0} width={30} height={30} rx={8} stroke="#E0E0E0" strokeWidth="2" fill="none"/>
        )}
      </g>
    </g>
  );
};

export default PhoneMockup;
