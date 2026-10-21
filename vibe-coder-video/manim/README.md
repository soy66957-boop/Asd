# Vibe Coder Video - Manim Project

A mathematically precise 30-second vertical motion graphics video (9:16, 1080×1920) generated with Manim.

## Quick Start

```bash
cd vibe-coder-video/manim

# Install dependencies
pip install manim

# Render all scenes
manim render vibe_coder_video.py -qh

# Render specific scene
manim render vibe_coder_video.py Hook -qh
manim render vibe_coder_video.py Step1 -qh
# etc.

# Render 60fps
manim render vibe_coder_video.py -qh --fps 60
```

## Project Structure

```
manim/
├── vibe_coder_video.py           # Main entry point
├── config.py                     # Video configuration
├── easings.py                    # Custom easing functions
├── safe_zones.py                 # TikTok/Reels safe zones
├── audio_timing.py               # Audio cues and timing
├── assets/                       # SVG assets (copied from ../assets/svg/)
└── scenes/
    ├── __init__.py
    ├── base.py                   # Base scene class with common utilities
    ├── hook.py                   # 0-3s: "No degree? No problem."
    ├── step1.py                  # 3-8s: Pick an AI coding tool
    ├── step2.py                  # 8-15s: Describe idea in plain English
    ├── step3.py                  # 15-22s: Run it, spot bugs, ask AI to fix
    ├── step4.py                  # 22-27s: Ship something small every day
    └── cta.py                    # 27-30s: Follow to become a vibe coder
```

## Video Specifications

| Property | Value |
|----------|-------|
| Resolution | 1080×1920 (9:16) |
| Frame Rate | 30 fps (60 fps optional) |
| Duration | 30 seconds |
| Format | MP4 (H.264) |
| Quality | High (1080p) |

## Animation Principles

- **Easing**: Punch (overshoot), Bounce (entrance), Smooth (camera), EaseOut (exits)
- **Stagger**: 80-120ms between elements, never perfectly uniform
- **Motion Blur**: On fast moves (>800px/s)
- **Parallax**: Background moves 10% of foreground
- **Film Grain**: 3% opacity animated noise
- **Hand-placed Offsets**: ±2-4px micro-variations

## Color Palette

```python
COLORS = {
    "electric_blue": "#007AFF",
    "hot_pink": "#FF2D92",
    "sunny_yellow": "#FFD600",
    "mint_green": "#00E676",
    "dark_text": "#1A1A2E",
    "soft_white": "#FAFAFA",
    "lavender": "#E8E0FF",
    "code_bg": "#1E1E2E",
    "code_comment": "#6272A4",
}
```

## Scene Breakdown

| Scene | Time | Frames (30fps) | Description |
|-------|------|----------------|-------------|
| Hook | 0-3s | 0-90 | "No degree? No problem." with confetti |
| Step 1 | 3-8s | 90-240 | AI tool cards stack |
| Step 2 | 8-15s | 240-450 | Chat + phone app build |
| Step 3 | 15-22s | 450-660 | Code window error→fix |
| Step 4 | 22-27s | 660-810 | Calendar fills with checkmarks |
| CTA | 27-30s | 810-900 | Follow arrow + logo |

## Safe Zones

- **Top**: 250px from top
- **Bottom**: 400px from bottom
- **Content Area**: y ∈ [250, 1520]

## Audio Integration

Audio cues defined in `audio_timing.py` for post-production mixing:
- Voiceover segments with exact frame timing
- SFX triggers (whoosh, pop, ding, keyboard clicks)
- Music start/fade points

## Requirements

- Python 3.8+
- Manim Community Edition
- FFmpeg (for video encoding)
- Cairo/Pango (for text rendering)

## Fonts

Requires Poppins and JetBrains Mono installed system-wide, or place in `assets/fonts/`.

## Post-Production

After rendering individual scenes, concatenate and mix audio:

```bash
# Concatenate scenes
ffmpeg -f concat -safe 0 -i scenes.txt -c copy combined.mp4

# Mix audio (see PRODUCTION_SPEC.md for full command)
ffmpeg -i combined.mp4 -i voiceover.wav -i sfx.wav -i music.wav \
  -filter_complex "..." -af "loudnorm=I=-14:TP=-1:LRA=11" final.mp4
```

## Customization

- Modify `config.py` for resolution, fps, duration
- Adjust easing curves in `easings.py`
- Change colors in scene files
- Update caption timing in `CaptionBurner` class
