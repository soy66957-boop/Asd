#!/usr/bin/env python3
"""
Vibe Coder Video - Main Entry Point
30-second vertical motion graphics video (9:16, 1080x1920) about "How to become a vibe coder using AI"

Usage:
    # Render all scenes
    manim render vibe_coder_video.py -qh
    
    # Render specific scene
    manim render vibe_coder_video.py Hook -qh
    manim render vibe_coder_video.py Step1 -qh
    manim render vibe_coder_video.py Step2 -qh
    manim render vibe_coder_video.py Step3 -qh
    manim render vibe_coder_video.py Step4 -qh
    manim render vibe_coder_video.py CTA -qh
    
    # Render at 60fps
    manim render vibe_coder_video.py -qh --fps 60
    
    # Preview (low quality)
    manim render vibe_coder_video.py -ql --preview
"""

from manim import *
from config import config, VIDEO_CONFIG, COLORS, FONTS
from scenes import SCENE_ORDER, SCENE_FRAMES

# Configure Manim
config.frame_width = VIDEO_CONFIG["width"]
config.frame_height = VIDEO_CONFIG["height"]
config.frame_rate = VIDEO_CONFIG["fps"]
config.pixel_width = VIDEO_CONFIG["width"]
config.pixel_height = VIDEO_CONFIG["height"]
config.background_color = COLORS["soft_white"]
config.format = "mp4"
config.codec = "h264"
config.quality = "high_quality"
config.output_file = "vibe_coder_video"
config.media_dir = "./media"


class VibeCoderVideo(Scene):
    """
    Master scene that renders the complete 30-second video.
    This combines all scenes sequentially.
    """
    
    def construct(self):
        # This master scene is for reference - individual scenes should be rendered separately
        # and concatenated in post-production for best quality
        
        self.add_background()
        self.add_film_grain()
        
        # Show scene breakdown as reference
        title = Text(
            "Vibe Coder Video - 30s Breakdown",
            font=FONTS["heading"],
            font_size=FONT_SIZES["headline"],
            color=COLORS["dark_text"],
            weight="EXTRA_BOLD"
        ).scale(0.5).to_edge(UP, buff=1)
        
        scenes_info = [
            ("Hook", "0-3s", "No degree? No problem. + Confetti"),
            ("Step 1", "3-8s", "Pick an AI coding tool. Card stack"),
            ("Step 2", "8-15s", "Describe idea. Chat + Phone app build"),
            ("Step 3", "15-22s", "Run it. Spot bugs. Ask AI to fix. Code window"),
            ("Step 4", "22-27s", "Ship daily. Calendar fills with checkmarks"),
            ("CTA", "27-30s", "Follow to become a vibe coder. Bouncing arrow"),
        ]
        
        info_group = VGroup()
        for i, (name, time, desc) in enumerate(scenes_info):
            row = VGroup(
                Text(f"{name} ({time})", font=FONTS["body"], font_size=FONT_SIZES["ui"], 
                     color=COLORS["electric_blue"], weight="SEMI_BOLD"),
                Text(desc, font=FONTS["regular"], font_size=FONT_SIZES["small"], 
                     color=COLORS["dark_text"]),
            ).arrange(DOWN, aligned_edge=LEFT, buff=0.1)
            info_group.add(row)
        
        info_group.arrange(DOWN, buff=0.5, aligned_edge=LEFT)
        info_group.next_to(title, DOWN, buff=0.5)
        
        self.play(Write(title), run_time=1)
        self.play(Write(info_group), run_time=2)
        self.wait(2)
        
        # Render each scene name as it would appear
        for name, time, desc in scenes_info:
            scene_text = Text(
                f"▶ {name} ({time})",
                font=FONTS["heading"],
                font_size=FONT_SIZES["subhead"],
                color=COLORS["hot_pink"],
                weight="EXTRA_BOLD"
            ).move_to(ORIGIN)
            
            self.play(FadeIn(scene_text, scale=0.8), run_time=0.5)
            self.wait(0.5)
            self.play(FadeOut(scene_text, scale=1.2), run_time=0.3)
        
        self.wait(1)
    
    def add_background(self):
        """Add gradient background."""
        gradient = Rectangle(
            width=config.frame_width,
            height=config.frame_height,
            fill_opacity=1, stroke_width=0,
        )
        gradient.set_fill(color=[COLORS["soft_white"], COLORS["lavender"]], opacity=1)
        gradient.set_sheen_direction(DOWN)
        self.add(gradient)
    
    def add_film_grain(self, opacity=0.03):
        """Add subtle film grain."""
        grain = Rectangle(
            width=config.frame_width * 2,
            height=config.frame_height * 2,
            fill_color=WHITE, fill_opacity=opacity, stroke_width=0,
        )
        grain.add_updater(lambda m, dt: m.shift(
            np.array([np.random.uniform(-0.01, 0.01), 
                     np.random.uniform(-0.01, 0.01), 0]) * dt * 10
        ))
        self.add(grain)


# Individual scene classes are imported from scenes package
# They can be rendered individually with: manim render vibe_coder_video.py SceneName -qh

if __name__ == "__main__":
    # This allows running the file directly for testing
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        scene = VibeCoderVideo()
        scene.render()
    else:
        print("Vibe Coder Video - Manim Project")
        print("================================")
        print("Render individual scenes:")
        for name, cls in SCENE_ORDER:
            print(f"  manim render vibe_coder_video.py {name} -qh")
        print("\nOr render master breakdown:")
        print("  manim render vibe_coder_video.py VibeCoderVideo -qh")
        print("\nFor 60fps:")
        print("  manim render vibe_coder_video.py Hook -qh --fps 60")
