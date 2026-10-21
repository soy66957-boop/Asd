// Audio timing and cues from PRODUCTION_SPEC.md
// All times in seconds

export const AUDIO_CUES = {
  // Scene transition whooshes
  whoosh: [3.0, 8.0, 15.0, 22.0, 27.0],
  
  // Text/icon pops (approximate times)
  pops: [
    0.5, 1.0,      // Hook texts
    3.2, 3.5,      // Step 1 header + text
    4.2, 4.32, 4.44,  // Card stack (3 cards)
    8.2, 8.5,      // Step 2 header + text
    9.5, 10.0, 11.5, 12.0, 12.5,  // Chat box, typing, send, phone, build
    15.2, 15.5,    // Step 3 header + text
    16.5, 17.5, 19.5, 20.5,  // Code window, error, click, success
    22.2, 22.5,    // Step 4 header + text
    23.5,          // Calendar
    24.0, 24.1, 24.2, 24.3, 24.4, 24.5, 24.6,  // 7 checkmarks
    27.2, 28.2,    // CTA text + vibe coder
    28.2,          // Arrow
  ],
  
  // Keyboard clicks (during typing sequences)
  keyboardClicks: [
    // Step 1: "Pick an AI coding tool." ~28 chars
    ...Array.from({ length: 28 }, (_, i) => 3.5 + i * 0.03),
    // Step 2: "Describe your idea in plain English." ~38 chars
    ...Array.from({ length: 38 }, (_, i) => 8.5 + i * 0.03),
    // Step 2 chat prompt: "Build a habit tracker with streaks and reminders" ~48 chars
    ...Array.from({ length: 48 }, (_, i) => 10.0 + i * 0.03),
    // Step 3: "Run it. Spot bugs. Ask AI to fix." ~35 chars
    ...Array.from({ length: 35 }, (_, i) => 15.5 + i * 0.03),
    // Step 4: "Ship something small every day." ~30 chars
    ...Array.from({ length: 30 }, (_, i) => 22.5 + i * 0.03),
    // CTA: "Follow to become a vibe coder." ~32 chars
    ...Array.from({ length: 32 }, (_, i) => 27.2 + i * 0.03),
  ],
  
  // Special SFX
  riser: 0.0,           // 0.0-0.5s
  confettiRustle: [2.0, 25.0],
  errorBuzz: 17.5,
  successDing: 20.5,
  sparkleChimes: 13.5,
  
  // Voiceover segments (start, end)
  voiceover: [
    { start: 0.5, end: 2.5, text: "Think you need a CS degree to build apps?" },
    { start: 2.5, end: 2.8, text: "Nope." },
    { start: 3.0, end: 4.0, text: "Welcome to vibe coding." },
    { start: 4.0, end: 5.5, text: "Step one: pick an AI coding tool." },
    { start: 6.0, end: 8.0, text: "Step two: describe your idea in plain English." },
    { start: 9.0, end: 12.0, text: "Step three: run it, spot the bugs, and let AI fix them." },
    { start: 13.0, end: 15.5, text: "Step four: ship something small every single day." },
    { start: 16.0, end: 18.0, text: "Do that, and you're a vibe coder." },
    { start: 28.0, end: 29.5, text: "Follow for more." },
  ],
  
  // Music
  musicStart: 3.0,      // Beat 1 of Scene 1
  musicFadeStart: 29.0, // Fade out
  musicFadeEnd: 30.0,   // End
  
  // Mix levels (dBFS)
  levels: {
    voiceover: -6,
    music: -24,      // 18dB below voice
    sfx: -12,
    master: -14,     // LUFS target
  },
};

// Convert seconds to frames at 30fps
export function secondsToFrames(seconds: number, fps = 30): number {
  return Math.round(seconds * fps);
}

// Convert frames to seconds
export function framesToSeconds(frames: number, fps = 30): number {
  return frames / fps;
}

// Check if a frame has an audio cue
export function hasAudioCue(frame: number, fps = 30): { type: string; time: number } | null {
  const time = frame / fps;
  
  for (const t of AUDIO_CUES.whoosh) {
    if (Math.abs(time - t) < 0.05) return { type: "whoosh", time: t };
  }
  for (const t of AUDIO_CUES.pops) {
    if (Math.abs(time - t) < 0.03) return { type: "pop", time: t };
  }
  if (Math.abs(time - AUDIO_CUES.riser) < 0.1) return { type: "riser", time: AUDIO_CUES.riser };
  for (const t of AUDIO_CUES.confettiRustle) {
    if (Math.abs(time - t) < 0.1) return { type: "confetti", time: t };
  }
  if (Math.abs(time - AUDIO_CUES.errorBuzz) < 0.05) return { type: "error", time: AUDIO_CUES.errorBuzz };
  if (Math.abs(time - AUDIO_CUES.successDing) < 0.05) return { type: "ding", time: AUDIO_CUES.successDing };
  if (Math.abs(time - AUDIO_CUES.sparkleChimes) < 0.05) return { type: "sparkle", time: AUDIO_CUES.sparkleChimes };
  
  return null;
}
