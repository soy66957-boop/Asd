// Vibe Coder Video - Remotion Entry Point
// Run with: npx remotion studio
// Render with: npx remotion render VibeCoderVideo out/video.mp4

import { registerRoot } from "./compositions/VibeCoderVideo";

// Register compositions
registerRoot();

// Export for Remotion CLI
export { VibeCoderVideo } from "./compositions/VibeCoderVideo";
export { VIDEO_CONFIG } from "./compositions/VibeCoderVideo";
