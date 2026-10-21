# Vibe Coder Video - Production Specification
**Format:** 9:16 vertical (1080×1920), 30 fps (60 fps preferred), MP4 H.264, 30 seconds
**Topic:** "How to become a vibe coder using AI"

---

## Visual Design System

### Color Palette
| Role | Hex | RGB | Usage |
|------|-----|-----|-------|
| Electric Blue | #007AFF | 0, 122, 255 | Primary actions, links, highlights |
| Hot Pink | #FF2D92 | 255, 45, 146 | Accent, CTAs, keyword highlights |
| Sunny Yellow | #FFD600 | 255, 214, 0 | Energy, warnings, sparkles |
| Mint Green | #00E676 | 0, 230, 118 | Success states, checkmarks |
| Soft White | #FAFAFA | 250, 250, 250 | Background base |
| Lavender | #E8E0FF | 232, 224, 255 | Gradient end |
| Dark Text | #1A1A2E | 26, 26, 46 | Body text, code |
| Code Comment | #6A737D | 106, 115, 125 | Code comments |

### Background Gradient
```css
background: linear-gradient(180deg, #FAFAFA 0%, #E8E0FF 100%);
```
Subtle film grain overlay: 3% opacity, animated noise texture.

### Typography
- **Font Family:** Poppins (fallback: Montserrat)
- **Weights:** ExtraBold (800) for headlines, SemiBold (600) for UI text, Regular (400) for code
- **Headline Size:** 96px (clamped to fit safe zones)
- **Body/UI Size:** 48px
- **Code Size:** 36px (monospace: JetBrains Mono)
- **Line Height:** 1.2 (headlines), 1.5 (body)
- **Letter Spacing:** -0.02em (headlines), 0 (body)

### Safe Zones (TikTok/Reels UI)
- **Top Safe Zone:** Keep all critical content below 250px from top
- **Bottom Safe Zone:** Keep all critical content above 400px from bottom
- **Effective Content Area:** 1080px × 1270px (y: 250–1520)

### Visual Style
- Flat 2D vector, clean edges, no gradients on shapes (except background)
- Rounded corners: 16px radius on cards, 8px on buttons
- Soft shadows: `0 8px 32px rgba(0,0,0,0.08)` on elevated elements
- Light film grain: animated, 3% opacity
- No 3D, no skeuomorphism, no plastic textures

---

## Animation Specifications

### Easing Curves (CSS/JS notation)
| Name | Curve | Usage |
|------|-------|-------|
| **Punch** | `cubic-bezier(0.34, 1.56, 0.64, 1)` | Zoom punch-ins, confetti pops |
| **Bounce** | `cubic-bezier(0.68, -0.55, 0.27, 1.55)` | Text entrances, icon slides |
| **Smooth** | `cubic-bezier(0.25, 0.46, 0.45, 0.94)` | Parallax, camera push |
| **EaseOut** | `cubic-bezier(0.16, 1, 0.3, 1)` | Exits, fades |
| **Spring** | `spring(1, 80, 10)` (Remotion) | Bouncing arrow, checkmarks |

### Motion Principles
- **Stagger:** 80–120ms between successive elements (never perfectly uniform)
- **Overshoot:** 10–15% on scale animations (Punch easing)
- **Parallax:** Background moves 10% of foreground speed on camera push
- **Motion Blur:** On fast moves (>800px/s), use directional blur (length: 20px)
- **Hand-placed Offsets:** ±2–4px random micro-offsets on repeated elements

### Timing Constants
- **Text Pop Duration:** 400ms (Bounce)
- **Icon Slide Duration:** 500ms (Punch)
- **Card Stack Reveal:** 120ms stagger per card
- **Typewriter Speed:** 30ms per character ±10ms jitter
- **Camera Push:** 800ms (Smooth)
- **Transition Whoosh:** 300ms
- **Confetti Burst:** 600ms total, particles fade 300–800ms

---

## Scene Breakdown

### Scene 0: Hook (0.0s – 3.0s) — "No degree? No problem."

| Time | Visual | Audio |
|------|--------|-------|
| 0.00 | Black frame, riser swell begins | Riser: pitch-up synth, 2s |
| 0.50 | **WHOOSH** — Text "No degree?" slams in from top (Bounce, 400ms) | WHOOSH SFX + Pop on text |
| 1.00 | **POP** — "No problem." slams in below (Bounce, 400ms, staggered 100ms) | POP SFX |
| 1.50 | **PUNCH** — Camera zoom 1.0 → 1.15 on text (Punch, 500ms) | Low-frequency impact |
| 2.00 | Confetti burst from text center (30 particles, mint/pink/yellow/blue) | Confetti rustle + chime |
| 2.50 | Confetti settles, subtle camera push-in continues | Music drops in (beat 1) |
| 3.00 | Hard cut to Scene 1 | — |

**Text Specs:**
- "No degree?" — Poppins ExtraBold, 96px, #1A1A2E, centered at y=500
- "No problem." — Poppins ExtraBold, 96px, #FF2D92, centered at y=620
- Word-by-word captions burned in, "degree" and "problem" highlighted in Hot Pink

---

### Scene 1: Step 1 (3.0s – 8.0s) — "Pick an AI coding tool."

| Time | Visual | Audio |
|------|--------|-------|
| 3.00 | **WHOOSH** transition | WHOOSH |
| 3.20 | Header "Step 1" slides down (Bounce, 400ms) | POP |
| 3.50 | "Pick an AI coding tool." types out (typewriter, 30ms/char) | Keyboard clicks per char |
| 4.20 | Card stack enters: 3 cards slide up + scale (Punch, stagger 120ms) | 3× POP |
| 4.60 | Card 1: Cursor logo + "Cursor" | — |
| 4.72 | Card 2: GitHub Copilot logo + "Copilot" | — |
| 4.84 | Card 3: Windsurf logo + "Windsurf" | — |
| 5.50 | Cards fan out slightly (parallax 5° rotation, staggered) | Subtle whoosh |
| 6.50 | Floating emojis drift up: ✨ 🚀 💡 (slow, 8s loop) | — |
| 7.50 | Camera push-in 1.0 → 1.05 (Smooth, 800ms) | — |
| 8.00 | **WHOOSH** to Scene 2 | WHOOSH |

**Card Specs:**
- Size: 280×180px, rounded 16px, white bg, soft shadow
- Icons: 64px, centered top, label below in Poppins SemiBold 36px #1A1A2E
- Stack offset: 20px vertical, 8px horizontal

**Captions:** "Pick an AI coding tool" — "AI coding tool" in Electric Blue

---

### Scene 2: Step 2 (8.0s – 15.0s) — "Describe your idea in plain English."

| Time | Visual | Audio |
|------|--------|-------|
| 8.00 | **WHOOSH** transition | WHOOSH |
| 8.20 | Header "Step 2" slides down | POP |
| 8.50 | "Describe your idea in plain English." types out | Keyboard clicks |
| 9.50 | Chat box appears (slide up, Punch, 500ms) | POP |
| 10.00 | Prompt types in chat: "Build a habit tracker with streaks and reminders" | Keyboard clicks (faster) |
| 11.50 | **ENTER** — message sends, subtle pulse on send button | Ding (soft) |
| 12.00 | Phone mockup slides in from right (Punch, 500ms) | WHOOSH |
| 12.50 | App UI builds on phone: frames appear → fill with content (stagger 150ms) | 4× POP |
| 13.50 | Sparkles emit from phone screen (15 particles, 1s) | Sparkle chimes |
| 14.00 | Floating emojis: 📱 ✨ 🎉 | — |
| 14.50 | Camera push-in on phone (1.0 → 1.08, Smooth) | — |
| 15.00 | **WHOOSH** to Scene 3 | WHOOSH |

**Chat Box Specs:**
- Width: 800px, height: 120px, rounded 16px, white bg
- User bubble: Electric Blue bg, white text, right-aligned
- Font: Poppins Regular 40px
- Typing indicator: 3 bouncing dots (Electric Blue)

**Phone Mockup:**
- Frame: 320×640px (9:16 ratio), rounded 32px, dark gray #1A1A2E bezel
- Screen content: habit tracker UI with cards, checkboxes, streak counter
- Build animation: wireframe → color fill (stagger per element)

**Captions:** "plain English" in Hot Pink

---

### Scene 3: Step 3 (15.0s – 22.0s) — "Run it. Spot bugs. Ask AI to fix."

| Time | Visual | Audio |
|------|--------|-------|
| 15.00 | **WHOOSH** transition | WHOOSH |
| 15.20 | Header "Step 3" slides down | POP |
| 15.50 | "Run it. Spot bugs. Ask AI to fix." types out | Keyboard clicks |
| 16.50 | Code window appears (slide up, Punch) | POP |
| 17.00 | Code syntax highlighted (Poppins Mono 36px) | — |
| 17.50 | **Red error banner** slides down from top of code window (Bounce) | Error buzz (low) |
| 18.00 | Error text: "TypeError: Cannot read property 'map' of undefined" | — |
| 18.50 | Cursor highlights error line (pulse animation) | — |
| 19.00 | "Ask AI to fix" button pulses (Hot Pink, 1s loop) | — |
| 19.50 | Click → loading spinner (Electric Blue, 800ms) | Keyboard click + spinner hum |
| 20.50 | **Green checkmark** scales in (Spring, overshoot 1.3) | **DING** (success, 880Hz) |
| 21.00 | Error banner → Success banner (morph, 400ms) | — |
| 21.50 | Success text: "Fixed! Added null check ✓" | — |
| 22.00 | **WHOOSH** to Scene 4 | WHOOSH |

**Code Window Specs:**
- Width: 900px, height: 500px, rounded 16px, dark bg #1E1E2E
- Syntax colors: Keywords #FF79C6, Strings #F1FA8C, Functions #8BE9FD, Comments #6272A4
- Error banner: #FF4444 bg, white text, rounded 8px
- Success banner: #00E676 bg, white text

**Captions:** "bugs" in Hot Pink, "AI" in Electric Blue, "fix" in Mint Green

---

### Scene 4: Step 4 (22.0s – 27.0s) — "Ship something small every day."

| Time | Visual | Audio |
|------|--------|-------|
| 22.00 | **WHOOSH** transition | WHOOSH |
| 22.20 | Header "Step 4" slides down | POP |
| 22.50 | "Ship something small every day." types out | Keyboard clicks |
| 23.50 | Calendar grid appears (slide up, Punch, 600ms) | POP |
| 24.00 | Checkmarks fill days 1–7 (stagger 100ms, Spring) | 7× POP (ascending pitch) |
| 24.70 | Checkmarks: Mint Green with pop scale 0→1.2→1.0 | — |
| 25.00 | Confetti burst from each checkmark (mini, 5 particles each) | Confetti rustle |
| 25.50 | Week 2 starts filling (auto-animate, faster) | — |
| 26.00 | Floating emojis: 📦 🚀 ✅ 🔥 | — |
| 26.50 | Camera push-out slightly (1.05 → 1.0, Smooth) | — |
| 27.00 | **WHOOSH** to CTA | WHOOSH |

**Calendar Specs:**
- 4 rows × 7 cols, each cell 100×100px, gap 8px
- Day numbers: Poppins SemiBold 28px #1A1A2E
- Checkmark: 48px, Mint Green, centered in cell
- Today indicator: Electric Blue ring (2px) around current day

**Captions:** "every day" in Hot Pink, "Ship" in Electric Blue

---

### Scene 5: CTA (27.0s – 30.0s) — "Follow to become a vibe coder."

| Time | Visual | Audio |
|------|--------|-------|
| 27.00 | **WHOOSH** transition | WHOOSH |
| 27.20 | "Follow to become a vibe coder." types out (center) | Keyboard clicks |
| 28.00 | **"vibe coder"** in Hot Pink, ExtraBold 96px | — |
| 28.20 | Bouncing arrow enters from bottom (Spring, loop 1.5s) | POP |
| 28.50 | Arrow points to follow button zone (bottom 200px) | — |
| 29.00 | Arrow bounce peaks, then settles | — |
| 29.50 | Clean fade to logo + handle @vibecoder | Music fade starts |
| 30.00 | Black frame, end | Music ends at -∞ dB |

**CTA Specs:**
- Text: Poppins ExtraBold 72px, centered at y=800
- "vibe coder" — Hot Pink gradient text (clip-path)
- Arrow: 60px, Hot Pink, bounce: y: 0 → -20 → 0 (1.5s, Spring)
- Follow button mockup: rounded pill, Hot Pink bg, white text "Follow"

**Captions:** "vibe coder" in Hot Pink (larger), "Follow" in Electric Blue

---

## Audio Specification

### Voiceover
- **Voice:** Energetic young adult, friendly, natural breaths/pauses
- **Pace:** ~150 WPM
- **Duration:** ~24 seconds of speech (6s breathing room)
- **Script:**
  > "Think you need a CS degree to build apps? Nope. Welcome to vibe coding. Step one: pick an AI coding tool. Step two: describe your idea in plain English. Step three: run it, spot the bugs, and let AI fix them. Step four: ship something small every single day. Do that, and you're a vibe coder. Follow for more."

### Voiceover Timing Map
| Segment | Start | End | Duration |
|---------|-------|-----|----------|
| "Think you need a CS degree to build apps?" | 0.5s | 2.5s | 2.0s |
| "Nope." | 2.5s | 2.8s | 0.3s |
| "Welcome to vibe coding." | 3.0s | 4.0s | 1.0s |
| "Step one: pick an AI coding tool." | 4.0s | 5.5s | 1.5s |
| "Step two: describe your idea in plain English." | 6.0s | 8.0s | 2.0s |
| "Step three: run it, spot the bugs, and let AI fix them." | 9.0s | 12.0s | 3.0s |
| "Step four: ship something small every single day." | 13.0s | 15.5s | 2.5s |
| "Do that, and you're a vibe coder." | 16.0s | 18.0s | 2.0s |
| "Follow for more." | 28.0s | 29.5s | 1.5s |

### Sound Effects
| SFX | Trigger | Level | Notes |
|-----|---------|-------|-------|
| Riser | 0.0s–0.5s | -6 dB | Pitch-up synth swell |
| Whoosh | Every scene transition (×5) | -12 dB | 300ms, white noise sweep |
| Pop | Text/icon entrances (×20+) | -10 dB | Short pluck, varied pitch |
| Keyboard clicks | Typing sequences | -18 dB | Mechanical, per character ±10ms jitter |
| Ding (success) | 20.5s (green checkmark) | -6 dB | 880Hz sine, 200ms decay |
| Error buzz | 17.5s (red banner) | -14 dB | Low square wave, 150ms |
| Sparkle chimes | 13.5s (phone build) | -16 dB | High bell tones, staggered |
| Confetti rustle | 2.0s, 25.0s | -14 dB | Paper shuffle texture |

### Background Music
- **Genre:** Upbeat lo-fi pop/electronic
- **BPM:** 120
- **Key:** F Major (bright, energetic)
- **Structure:** 4-bar loops, cuts on beat at scene transitions
- **Instruments:** Drums (boom-bap), bass (plucky synth), chords (rhodes), lead (pluck), vinyl crackle
- **Level:** -18 dBFS (15–18 dB below voice)
- **Fade:** Start 3.0s (beat 1), fade out 29.0s–30.0s (linear -∞ dB)
- **Loudness Target:** -14 LUFS integrated (streaming standard)

### Mix Balance
| Element | Level (dBFS) | Notes |
|---------|--------------|-------|
| Voiceover | -6 dBFS (peak) | Normalize to -16 LUFS |
| Music | -24 dBFS | Ducked during VO |
| SFX | -16 to -10 dBFS | Momentary peaks |
| Master | -14 LUFS | True peak -1 dBTP |

---

## Asset List (SVG Required)

### UI Mockups
1. **laptop.svg** — MacBook-style, screen shows code editor, 600×400px viewBox
2. **phone.svg** — iPhone 15 Pro style, 320×640px viewBox, screen area marked
3. **code-window.svg** — Dark theme editor chrome + tab bar, 900×500px viewBox

### Icons & Illustrations
4. **cursor-logo.svg** — Cursor AI logo
5. **copilot-logo.svg** — GitHub Copilot logo
6. **windsurf-logo.svg** — Windsurf logo
7. **chat-bubble.svg** — Rounded chat bubble, user style
8. **send-button.svg** — Paper plane icon
9. **error-banner.svg** — Red alert banner with ✕
10. **success-banner.svg** — Green success banner with ✓
11. **checkmark.svg** — Bold checkmark, 48px
12. **calendar-grid.svg** — 4×7 grid template
13. **follow-button.svg** — Pill CTA button

### Decorative
14. **confetti.svg** — 5 shapes (square, circle, triangle, strip, star) in palette colors
15. **sparkle.svg** — 4-point star with glow, 3 sizes
16. **arrow-bounce.svg** — Upward chevron, Hot Pink
17. **emoji-rocket.svg** 🚀
18. **emoji-sparkles.svg** ✨
19. **emoji-lightbulb.svg** 💡
20. **emoji-phone.svg** 📱
21. **emoji-party.svg** 🎉
22. **emoji-box.svg** 📦
23. **emoji-fire.svg** 🔥

### UI States
24. **typing-indicator.svg** — 3 bouncing dots
25. **spinner.svg** — 3-ring loader, Electric Blue

---

## Technical Delivery

### Remotion Composition
- **File:** `src/compositions/VibeCoderVideo.tsx`
- **Duration:** 900 frames @ 30fps (1800 @ 60fps)
- **Dimensions:** 1080×1920
- **Audio:** Separate tracks for VO, SFX, Music → mixed in post

### Render Command
```bash
npx remotion render VibeCoderVideo out/video.mp4 \
  --concurrency=4 --image-format=png --jpeg-quality=100
```

### FFmpeg Final Mix
```bash
ffmpeg -i video.mp4 -i voiceover.wav -i sfx.wav -i music.wav \
  -filter_complex "[1:a]volume=1.0[v];[2:a]volume=0.5[s];[3:a]volume=0.15[m];[v][s][m]amix=inputs=3:duration=first:dropout_transition=2[a]" \
  -map 0:v -map "[a]" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k \
  -af "loudnorm=I=-14:TP=-1:LRA=11" final.mp4
```

### Quality Checklist
- [ ] All text sharp at 1080×1920 (no sub-pixel rendering issues)
- [ ] No content in top 250px / bottom 400px safe zones
- [ ] Captions word-perfect, synced ±50ms to VO
- [ ] Keywords highlighted correctly per spec
- [ ] Easing curves match spec (overshoot, bounce, stagger)
- [ ] Motion blur on fast moves
- [ ] Film grain visible but subtle
- [ ] Audio mix: VO clear, music -18dB, SFX punchy
- [ ] Final loudness -14 LUFS ±0.5
- [ ] No watermarks, glitches, or morphing artifacts

---

## File Structure
```
vibe-coder-video/
├── PRODUCTION_SPEC.md          # This file
├── assets/
│   ├── svg/                    # All SVG assets (25 files)
│   ├── audio/
│   │   ├── voiceover.wav       # 48kHz 24-bit mono
│   │   ├── sfx/                # Individual SFX files
│   │   └── music.wav           # 48kHz 24-bit stereo loop
│   └── fonts/
│       ├── Poppins-ExtraBold.ttf
│       ├── Poppins-SemiBold.ttf
│       ├── Poppins-Regular.ttf
│       └── JetBrainsMono-Regular.ttf
├── remotion/
│   ├── package.json
│   ├── tsconfig.json
│   ├── remotion.config.ts
│   ├── src/
│   │   ├── compositions/
│   │   │   └── VibeCoderVideo.tsx
│   │   ├── scenes/
│   │   │   ├── Hook.tsx
│   │   │   ├── Step1.tsx
│   │   │   ├── Step2.tsx
│   │   │   ├── Step3.tsx
│   │   │   ├── Step4.tsx
│   │   │   └── CTA.tsx
│   │   ├── components/
│   │   │   ├── TextReveal.tsx
│   │   │   ├── CardStack.tsx
│   │   │   ├── ChatBox.tsx
│   │   │   ├── PhoneMockup.tsx
│   │   │   ├── CodeWindow.tsx
│   │   │   ├── Calendar.tsx
│   │   │   ├── Confetti.tsx
│   │   │   ├── Sparkles.tsx
│   │   │   ├── BouncingArrow.tsx
│   │   │   └── CaptionBurner.tsx
│   │   ├── hooks/
│   │   │   ├── useSpring.ts
│   │   │   └── useStagger.ts
│   │   └── utils/
│   │       ├── easing.ts
│   │       ├── safeZones.ts
│   │       └── audio.ts
│   └── public/
│       └── fonts/              # Copied from assets/fonts
├── manim/
│   ├── vibe_coder_video.py
│   ├── scenes/
│   │   ├── hook.py
│   │   ├── step1.py
│   │   ├── step2.py
│   │   ├── step3.py
│   │   ├── step4.py
│   │   └── cta.py
│   └── assets/                 # SVGs copied here
├── html-prototype/
│   ├── index.html
│   ├── styles.css
│   ├── app.js
│   └── assets/                 # SVGs copied here
└── render-output/
    └── final.mp4               # Final deliverable
```
