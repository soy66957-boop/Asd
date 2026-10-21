import React from "react";
import { interpolate } from "remotion";
import { easings } from "../utils/easing";
import { SAFE_ZONES } from "../utils/safeZones";

interface ChatBoxProps {
  prompt: string;
  startFrame: number;
  frame: number;
  typingDuration?: number;      // Frames for typing animation
  sendFrame?: number;           // Frame when send button is pressed
  y?: number;
  x?: number;
  width?: number;
  height?: number;
}

const CHAT_WIDTH = 800;
const CHAT_HEIGHT = 120;
const BUBBLE_MAX_WIDTH = 600;

export const ChatBox: React.FC<ChatBoxProps> = ({
  prompt,
  startFrame,
  frame,
  typingDuration = 90,    // 3 seconds at 30fps
  sendFrame = startFrame + 90,
  y = SAFE_ZONES.CONTENT_CENTER_Y - 200,
  x = SAFE_ZONES.CENTER_X,
  width = CHAT_WIDTH,
  height = CHAT_HEIGHT,
}) => {
  const chatX = x - width / 2;
  const chatY = y - height / 2;
  
  // Chat box entrance
  const boxElapsed = frame - startFrame;
  const boxProgress = boxElapsed > 0 ? Math.min(1, boxElapsed / 20) : 0;
  const boxEased = easings.punch(boxProgress);
  const boxScale = interpolate(boxEased, [0, 1], [0.8, 1]);
  const boxOpacity = boxEased;
  const boxTranslateY = interpolate(boxEased, [0, 1], [50, 0]);
  
  // Typing animation
  const typingElapsed = frame - startFrame;
  const typingProgress = typingElapsed > 0 ? Math.min(1, typingElapsed / typingDuration) : 0;
  const typedChars = Math.floor(prompt.length * typingProgress);
  const displayedText = prompt.slice(0, typedChars);
  
  // Send button pulse
  const sendElapsed = frame - sendFrame;
  const sendProgress = sendElapsed > 0 ? Math.min(1, sendElapsed / 15) : 0;
  const sendPulse = sendElapsed > 0 && sendElapsed < 30 
    ? 1 + Math.sin(sendElapsed * 0.5) * 0.1 
    : 1;
  
  return (
    <svg width={SAFE_ZONES.WIDTH} height={SAFE_ZONES.HEIGHT}>
      <g
        transform={`translate(${x}, ${y}) scale(${boxScale}) translate(0, ${boxTranslateY})`}
        opacity={boxOpacity}
      >
        <!-- Chat box background -->
        <rect
          x={-width / 2}
          y={-height / 2}
          width={width}
          height={height}
          rx={16}
          fill="#FFFFFF"
          filter="url(#chatShadow)"
        />
        
        <!-- User bubble -->
        <foreignObject
          x={-width / 2 + 20}
          y={-height / 2 + 10}
          width={BUBBLE_MAX_WIDTH}
          height={height - 20}
        >
          <div style={{
            width: "100%",
            height: "100%",
            display: "flex",
            alignItems: "center",
            justifyContent: "flex-end",
            paddingRight: "20px",
          }}>
            <div style={{
              maxWidth: "100%",
              background: "#007AFF",
              borderRadius: "16px",
              padding: "16px 24px",
              color: "#FFFFFF",
              fontFamily: "Poppins, sans-serif",
              fontSize: "40px",
              fontWeight: "400",
              lineHeight: "1.3",
              wordWrap: "break-word",
              boxShadow: "0 4px 16px rgba(0,122,255,0.3)",
            }}>
              {displayedText}
              {typingProgress < 1 && <span style={{ 
                display: "inline-block", 
                width: "2px", 
                height: "1em", 
                background: "#FFFFFF",
                marginLeft: "4px",
                animation: "blink 1s infinite"
              }} />}
            </div>
          </div>
        </foreignObject>
        
        <!-- Send button -->
        <g
          transform={`translate(${width / 2 - 60}, 0) scale(${sendPulse})`}
          opacity={sendProgress > 0 ? 1 : 0}
        >
          <circle cx="0" cy="0" r="28" fill="#007AFF" filter="url(#sendGlow)"/>
          <path d="M-8 -4 L12 0 L-8 4 Z" fill="#FFFFFF" transform="scale(1.5)"/>
        </g>
        
        <!-- Defs -->
        <defs>
          <filter id="chatShadow" x="-20%" y="-20%" width="140%" height="140%">
            <feDropShadow dx="0" dy="8" stdDeviation="16" flood-color="#000000" flood-opacity="0.08"/>
          </filter>
          <filter id="sendGlow" x="-50%" y="-50%" width="200%" height="200%">
            <feDropShadow dx="0" dy="0" stdDeviation="8" flood-color="#007AFF" flood-opacity="0.5"/>
          </filter>
        </defs>
      </g>
      
      <style>
        {`@keyframes blink { 0%, 50% { opacity: 1; } 51%, 100% { opacity: 0; } }`}
      </style>
    </svg>
  );
};

export default ChatBox;
