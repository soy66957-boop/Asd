# Vibe Coder Video - Remotion Project

A programmatically generated 30-second vertical motion graphics video (9:16, 1080×1920) about "How to become a vibe coder using AI".

## Quick Start

```bash
cd vibe-coder-video/remotion

# Install dependencies
npm install

# Development preview (opens Remotion Studio)
npm run dev

# Render final video (30fps)
npm run render

# Render 60fps version
npm run render:60fps
```

## Project Structure

```
remotion/
├── src/
│   ├── index.ts                      # Entry point
│   ├── compositions/
│   │   └── VibeCoderVideo.tsx        # Main composition (30s, 900 frames)
│   ├── scenes/
│   │   ├── Hook.tsx                  # 0-3s: "No degree? No problem."
│   │   ├── Step1.tsx                 # 3-8s: Pick an AI coding tool
│   │   ├── Step2.tsx                 # 8-15s: Describe idea in plain English
│   │   ├── Step3.tsx                 # 15-22s: Run it, spot bugs, ask AI to fix
│   │   ├── Step4.tsx                 # 22-27s: Ship something small every day
│   │   └── CTA.tsx                   # 27-30s: Follow to become a vibe coder
│   ├── components/
│   │   ├── TextReveal.tsx            # Word-by-word animated text
│   │   ├── CardStack.tsx             # Staggered card animations
│   │   ├── ChatBox.tsx               # Typing chat animation
│   │   ├── PhoneMockup.tsx           # Phone with app build animation
│   │   ├── CodeWindow.tsx            # Code editor with error/fix
│   │   ├── Calendar.tsx              # Calendar with checkmark fills
│   │   ├── Confetti.tsx              # Physics-based confetti
│   │   ├── Sparkles.tsx              # Twinkling sparkles
│   │   ├── BouncingArrow.tsx         # Spring bounce arrow
│   │   └── CaptionBurner.tsx         # Word-synced captions
│   ├── hooks/
│   │   ├── useSpring.ts              # Spring physics hook
│   │   └── useStagger.ts             # Staggered animation hook
│   └── utils/
│       ├── easing.ts                 # Custom easing curves (punch, bounce, smooth)
│       ├── safeZones.ts              # TikTok/Reels safe zones
│       └── audio.ts                  # Audio timing cues
├── public/fonts/                     # Poppins, JetBrains Mono fonts
├── package.json
├── tsconfig.json
└── remotion.config.ts
```

## Video Specifications

| Property | Value |
|----------|-------|
| Resolution | 1080×1920 (9:16) |
| Frame Rate | 30 fps (60 fps optional) |
| Duration | 30 seconds (900 frames) |
| Format | MP4 (H.264) |
| Codec | libx264, CRF 18 |
| Audio | AAC 192kbps, -14 LUFS |

## Animation Principles (from spec)

- **Easing**: Punch (overshoot), Bounce (entrance), Smooth (camera), EaseOut (exits)
- **Stagger**: 80-120ms between elements, never perfectly uniform
- **Motion Blur**: On fast moves (>800px/s)
- **Parallax**: Background moves 10% of foreground
- **Film Grain**: 3% opacity animated noise
- **Hand-placed Offsets**: ±2-4px micro-variations

## Safe Zones

- **Top**: 250px from top edge
- **Bottom**: 400px from bottom edge
- **Content Area**: 1080×1270px (y: 250-1520)

## Audio Cues (for post-production)

| Time | Cue |
|------|-----|
| 0.0s | Riser swell |
| 0.5s | Whoosh + "No degree?" pop |
| 1.0s | "No problem." pop |
| 1.5s | Camera punch |
| 2.0s | Confetti burst |
| 3.0s | Whoosh transition + Music starts |
| ... | See `src/utils/audio.ts` for full list |

## Fonts Required

Place in `public/fonts/`:
- Poppins-ExtraBold.ttf (800)
- Poppins-SemiBold.ttf (600)
- Poppins-Regular.ttf (400)
- JetBrainsMono-Regular.ttf

## Color Palette

| Role | Hex |
|------|-----|
| Electric Blue | #007AFF |
| Hot Pink | #FF2D92 |
| Sunny Yellow | #FFD600 |
| Mint Green | #00E676 |
| Dark Text | #1A1A2E |
| Soft White | #FAFAFA |
| Lavender | #E8E0FF |

## Post-Production

After rendering `out/video.mp4`, mix audio with FFmpeg:

```bash
ffmpeg -i video.mp4 -i voiceover.wav -i sfx.wav -i music.wav \
  -filter_complex "[1:a]volume=1.0[v];[2:a]volume=0.5[s];[3:a]volume=0.15[m];[v][s][m]amix=inputs=3:duration=first:dropout_transition=2[a]" \
  -map 0:v -map "[a]" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k \
  -af "loudnorm=I=-14:TP=-1:LRA=11" final.mp4
```

## Customization

- Modify `VIDEO_CONFIG` in `VibeCoderVideo.tsx` for different durations/fps
- Adjust easing curves in `src/utils/easing.ts`
- Change colors in component files
- Update caption timing in `CaptionBurner.ts`

## Troubleshooting

**Render fails with "out of memory"**: Reduce concurrency in `remotion.config.ts`:
```ts
Config.setConcurrency(2);
```

**Fonts not rendering**: Ensure fonts are in `public/fonts/` and referenced correctly.

**Animation timing off**: Check `useCurrentFrame()` usage and frame calculations.
