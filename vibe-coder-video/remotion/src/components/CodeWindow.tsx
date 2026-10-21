import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface CodeWindowProps {
  startFrame: number;
  frame: number;
  errorFrame: number;           // When error banner appears
  fixFrame: number;             // When "Ask AI to fix" is clicked
  successFrame: number;         // When success checkmark appears
  y?: number;
  x?: number;
  scale?: number;
}

const WINDOW_WIDTH = 900;
const WINDOW_HEIGHT = 500;
const TITLE_BAR_HEIGHT = 48;
const TAB_BAR_HEIGHT = 40;
const EDITOR_TOP = TITLE_BAR_HEIGHT + TAB_BAR_HEIGHT;

export const CodeWindow: React.FC<CodeWindowProps> = ({
  startFrame,
  frame,
  errorFrame,
  fixFrame,
  successFrame,
  y = SAFE_ZONES.CONTENT_CENTER_Y,
  x = SAFE_ZONES.CENTER_X,
  scale = 1,
}) => {
  // Window entrance
  const entranceElapsed = frame - startFrame;
  const entranceProgress = entranceElapsed > 0 ? Math.min(1, entranceElapsed / 20) : 0;
  const entranceEased = easings.punch(entranceProgress);
  const entranceScale = interpolate(entranceEased, [0, 1], [0.8, 1]);
  const entranceOpacity = entranceEased;
  
  // Error banner animation
  const errorElapsed = frame - errorFrame;
  const errorProgress = errorElapsed > 0 ? Math.min(1, errorElapsed / 15) : 0;
  const errorEased = easings.bounce(errorProgress);
  const errorY = interpolate(errorEased, [0, 1], [-80, 0]);
  const errorOpacity = errorEased;
  
  // Fix click - spinner
  const fixElapsed = frame - fixFrame;
  const fixProgress = fixElapsed > 0 ? Math.min(1, fixElapsed / 30) : 0;
  const spinnerRotation = fixProgress * 360;
  const spinnerOpacity = fixElapsed > 0 && fixElapsed < 60 ? 1 : 0;
  
  // Success checkmark
  const successElapsed = frame - successFrame;
  const successProgress = successElapsed > 0 ? Math.min(1, successElapsed / 20) : 0;
  const successEased = easings.spring(successProgress);
  const successScale = 0.3 + successEased * 1.2; // Overshoot to 1.3 then settle
  const successOpacity = successEased;
  
  // Error -> Success morph
  const morphProgress = frame > successFrame ? Math.min(1, (frame - successFrame) / 15) : 0;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g
        transform={`translate(${x}, ${y}) scale(${entranceScale * scale})`}
        opacity={entranceOpacity}
      >
        {/* Window shadow */}
        <rect
          x={-WINDOW_WIDTH / 2 + 4}
          y={-WINDOW_HEIGHT / 2 + 4}
          width={WINDOW_WIDTH}
          height={WINDOW_HEIGHT}
          rx={16}
          fill="#00000020"
          filter="url(#windowShadow)"
        />
        
        {/* Window chrome */}
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2}
          width={WINDOW_WIDTH}
          height={WINDOW_HEIGHT}
          rx={16}
          fill="#1E1E2E"
        />
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2}
          width={WINDOW_WIDTH}
          height={WINDOW_HEIGHT}
          rx={16}
          stroke="#3A3A4A"
          strokeWidth="2"
          fill="none"
        />
        
        {/* Title bar */}
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2}
          width={WINDOW_WIDTH}
          height={TITLE_BAR_HEIGHT}
          rx={16}
          fill="#252536"
        >
          <animate attributeName="ry" from="16" to="0" dur="0.01s" begin="0.01s" fill="freeze"/>
        </rect>
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2 + TITLE_BAR_HEIGHT - 8}
          width={WINDOW_WIDTH}
          height={8}
          fill="#252536"
        />
        
        {/* Traffic lights */}
        <circle cx={-WINDOW_WIDTH / 2 + 20} cy={-WINDOW_HEIGHT / 2 + 24} r="7" fill="#FF5F57"/>
        <circle cx={-WINDOW_WIDTH / 2 + 40} cy={-WINDOW_HEIGHT / 2 + 24} r="7" fill="#FEBC2E"/>
        <circle cx={-WINDOW_WIDTH / 2 + 60} cy={-WINDOW_HEIGHT / 2 + 24} r="7" fill="#28CA42"/>
        
        {/* Tab bar */}
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2 + TITLE_BAR_HEIGHT}
          width={WINDOW_WIDTH}
          height={TAB_BAR_HEIGHT}
          fill="#1E1E2E"
        />
        <rect
          x={-WINDOW_WIDTH / 2 + 8}
          y={-WINDOW_HEIGHT / 2 + TITLE_BAR_HEIGHT + 2}
          width={140}
          height={36}
          rx={6}
          fill="#2D2D3A"
        />
        <text x={-WINDOW_WIDTH / 2 + 18} y={-WINDOW_HEIGHT / 2 + TITLE_BAR_HEIGHT + 26} fontFamily="JetBrains Mono, monospace" fontSize="12" fill="#F8F8F2">main.py</text>
        <circle cx={-WINDOW_WIDTH / 2 + 18} cy={-WINDOW_HEIGHT / 2 + TITLE_BAR_HEIGHT + 20} r="4" fill="#28CA42"/>
        
        {/* Tab divider */}
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2 + EDITOR_TOP}
          width={WINDOW_WIDTH}
          height={1}
          fill="#3A3A4A"
        />
        
        {/* Editor area */}
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2 + EDITOR_TOP}
          width={WINDOW_WIDTH}
          height={WINDOW_HEIGHT - EDITOR_TOP}
          fill="#16161D"
        />
        
        {/* Line numbers gutter */}
        <rect
          x={-WINDOW_WIDTH / 2}
          y={-WINDOW_HEIGHT / 2 + EDITOR_TOP}
          width={60}
          height={WINDOW_HEIGHT - EDITOR_TOP}
          fill="#1E1E2E"
        />
        
        {/* Code content - simplified for performance */}
        <CodeContent 
          x={-WINDOW_WIDTH / 2 + 75} 
          y={-WINDOW_HEIGHT / 2 + EDITOR_TOP + 36}
          width={WINDOW_WIDTH - 85}
        />
        
        {/* Blinking cursor */}
        <Cursor x={-WINDOW_WIDTH / 2 + 300} y={-WINDOW_HEIGHT / 2 + EDITOR_TOP + 36 + 14 * 14} />
        
        {/* Error banner */}
        <g 
          transform={`translate(0, ${errorY})`} 
          opacity={errorOpacity * (1 - morphProgress)}
        >
          <ErrorBanner 
            x={-WINDOW_WIDTH / 2 + 20} 
            y={-WINDOW_HEIGHT / 2 + EDITOR_TOP + 20}
            width={WINDOW_WIDTH - 40}
          />
        </g>
        
        {/* Success banner (morphs from error) */}
        <g 
          transform={`translate(0, ${interpolate(morphProgress, [0, 1], [errorY, 0])})`} 
          opacity={morphProgress}
        >
          <SuccessBanner 
            x={-WINDOW_WIDTH / 2 + 20} 
            y={-WINDOW_HEIGHT / 2 + EDITOR_TOP + 20}
            width={WINDOW_WIDTH - 40}
          />
        </g>
        
        {/* Fix spinner */}
        <g
          transform={`translate(${WINDOW_WIDTH / 2 - 100}, ${-WINDOW_HEIGHT / 2 + TITLE_BAR_HEIGHT + 20}) scale(${1 + fixProgress * 0.2})`}
          opacity={spinnerOpacity}
        >
          <Spinner rotation={spinnerRotation} />
        </g>
        
        {/* Success checkmark */}
        <g
          transform={`translate(0, ${-WINDOW_HEIGHT / 2 + EDITOR_TOP + 20}) scale(${successScale})`}
          opacity={successOpacity}
        >
          <SuccessCheckmark size={60} color="#00E676" />
        </g>
        
        {/* Minimap */}
        <rect
          x={WINDOW_WIDTH / 2 - 30}
          y={-WINDOW_HEIGHT / 2 + EDITOR_TOP}
          width={30}
          height={WINDOW_HEIGHT - EDITOR_TOP}
          fill="#1E1E2E"
        />
        <rect
          x={WINDOW_WIDTH / 2 - 28}
          y={-WINDOW_HEIGHT / 2 + EDITOR_TOP + 20}
          width={26}
          height={200}
          rx={2}
          fill="#3A3A4A"
        />
        
        {/* Defs */}
        <defs>
          <filter id="windowShadow" x="-20%" y="-20%" width="140%" height="140%">
            <feDropShadow dx="0" dy="16" stdDeviation="32" flood-color="#000000" flood-opacity="0.1"/>
          </filter>
        </defs>
      </g>
    </svg>
  );
};

const CodeContent: React.FC<{ x: number; y: number; width: number }> = ({ x, y, width }) => {
  const lines = [
    { indent: 0, parts: [
      { text: "def ", color: "#FF79C6" },
      { text: "process_habits", color: "#50FA7B" },
      { text: "(habit_list: ", color: "#F8F8F2" },
      { text: "List", color: "#8BE9FD" },
      { text: "[Habit]", color: "#8BE9FD" },
      { text: ") -> Dict:", color: "#F8F8F2" },
    ]},
    { indent: 1, parts: [{ text: "# Process habits and calculate streaks", color: "#6272A4" }] },
    { indent: 1, parts: [{ text: "results = {", color: "#F8F8F2" }] },
    { indent: 2, parts: [
      { text: '"coding": ', color: "#F1FA8C" },
      { text: "calculate_streak(habit_list[0]),", color: "#F8F8F2" },
    ]},
    { indent: 2, parts: [
      { text: '"workout": ', color: "#F1FA8C" },
      { text: "calculate_streak(habit_list[1]),", color: "#F8F8F2" },
    ]},
    { indent: 1, parts: [{ text: "}", color: "#FF79C6" }] },
    { indent: 1, parts: [{ text: "return results", color: "#F8F8F2" }] },
    { indent: 0, parts: [] },
    { indent: 0, parts: [
      { text: "def ", color: "#FF79C6" },
      { text: "calculate_streak", color: "#50FA7B" },
      { text: "(habit):", color: "#F8F8F2" },
    ]},
    { indent: 1, parts: [{ text: "# Returns current streak count", color: "#6272A4" }] },
    { indent: 1, parts: [{ text: "streak = 0", color: "#F8F8F2" }] },
    { indent: 1, parts: [{ text: "for day in habit.days:", color: "#F8F8F2" }] },
    { indent: 2, parts: [
      { text: "if day.completed: ", color: "#FF79C6" },
      { text: "streak += 1", color: "#F8F8F2" },
    ]},
    { indent: 2, parts: [
      { text: "else: break", color: "#FF79C6" },
    ]},
    { indent: 1, parts: [{ text: "return streak", color: "#F8F8F2" }] },
  ];
  
  return (
    <g transform={`translate(${x}, ${y})`}>
      {lines.map((line, i) => (
        <text key={i} x={line.indent * 20} y={i * 25} fontFamily="JetBrains Mono, monospace" fontSize="14" fill="#F8F8F2">
          {line.parts.map((part, j) => (
            <tspan key={j} fill={part.color}>{part.text}</tspan>
          ))}
        </text>
      ))}
    </g>
  );
};

const Cursor: React.FC<{ x: number; y: number }> = ({ x, y }) => (
  <rect x={x} y={y - 2} width={2} height={18} fill="#F8F8F2" opacity="0.8">
    <animate attributeName="opacity" values="0.8;0;0.8" dur="1s" repeatCount="indefinite"/>
  </rect>
);

const ErrorBanner: React.FC<{ x: number; y: number; width: number }> = ({ x, y, width }) => (
  <g transform={`translate(${x}, ${y})`}>
    <rect x={0} y={0} width={width} height={50} rx={8} fill="#FF4444"/>
    <circle cx={25} cy={25} r="10" fill="#CC0000"/>
    <path d="M18 18 L32 32 M32 18 L18 32" stroke="#FFFFFF" strokeWidth="2.5" strokeLinecap="round"/>
    <text x={50} y={32} fontFamily="Poppins, sans-serif" fontSize="14" fontWeight="600" fill="#FFFFFF">
      TypeError: Cannot read property &apos;map&apos; of undefined
    </text>
  </g>
);

const SuccessBanner: React.FC<{ x: number; y: number; width: number }> = ({ x, y, width }) => (
  <g transform={`translate(${x}, ${y})`}>
    <rect x={0} y={0} width={width} height={50} rx={8} fill="#00E676"/>
    <circle cx={25} cy={25} r="10" fill="#00B35E"/>
    <path d="M16 25 L23 32 L34 16" stroke="#FFFFFF" strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
    <text x={50} y={32} fontFamily="Poppins, sans-serif" fontSize="14" fontWeight="600" fill="#FFFFFF">
      Fixed! Added null check ✓
    </text>
  </g>
);

const Spinner: React.FC<{ rotation: number }> = ({ rotation }) => (
  <g>
    <circle cx="0" cy="0" r="18" fill="none" stroke="#007AFF" strokeWidth="3" strokeDasharray="70 20" strokeLinecap="round">
      <animateTransform attributeName="transform" type="rotate" from="0 0 0" to="360 0 0" dur="1s" repeatCount="indefinite"/>
    </circle>
    <circle cx="0" cy="0" r="12" fill="none" stroke="#007AFF" strokeWidth="2.5" strokeDasharray="50 15" strokeLinecap="round" opacity="0.6">
      <animateTransform attributeName="transform" type="rotate" from="360 0 0" to="0 0 0" dur="0.8s" repeatCount="indefinite"/>
    </circle>
    <circle cx="0" cy="0" r="6" fill="none" stroke="#007AFF" strokeWidth="2" strokeDasharray="25 8" strokeLinecap="round" opacity="0.4">
      <animateTransform attributeName="transform" type="rotate" from="0 0 0" to="360 0 0" dur="0.6s" repeatCount="indefinite"/>
    </circle>
  </g>
);

const SuccessCheckmark: React.FC<{ size: number; color: string }> = ({ size, color }) => (
  <g>
    <circle cx="0" cy="0" r={size / 2 - 2} fill={color}/>
    <path d={`M${-size * 0.3} 0 L${-size * 0.1} ${size * 0.25} L${size * 0.35} ${-size * 0.3}`} stroke="#FFFFFF" strokeWidth={size * 0.08} fill="none" strokeLinecap="round" strokeLinejoin="round"/>
  </g>
);

export default CodeWindow;
