# Base scene class with common utilities for Vibe Coder Video

from manim import *
from config import VIDEO_CONFIG, COLORS, FONTS, FONT_SIZES, TIMING
from easings import (punch_rate_func, bounce_rate_func, smooth_rate_func, 
                     ease_out_rate_func, spring_rate_func, spring_overshoot_rate_func,
                     get_stagger_delay, get_motion_blur, get_hand_offset, get_parallax_offset)
from safe_zones import (CONTENT_TOP, CONTENT_BOTTOM, CONTENT_CENTER_Y, CONTENT_WIDTH,
                        CONTENT_LEFT, CONTENT_RIGHT, CENTER_X, CENTER_Y,
                        safe_y_to_manim, clamp_to_safe_zone, get_caption_y,
                        font_size_to_scale, MANIM_FONT_SIZES)
from audio_timing import get_audio_cues_at_frame, VOICEOVER_SEGMENTS, SFX_MAP


class VibeCoderScene(Scene):
    """Base scene class with common setup and utilities."""
    
    def setup(self):
        # Set up camera for 9:16 vertical
        self.camera.frame_width = VIDEO_CONFIG["width"] / 100
        self.camera.frame_height = VIDEO_CONFIG["height"] / 100
        
        # Add film grain overlay
        self.add_film_grain()
        
        # Add background gradient
        self.add_background()
    
    def add_background(self):
        """Add the soft white-to-lavender gradient background."""
        gradient = Rectangle(
            width=VIDEO_CONFIG["width"] / 100,
            height=VIDEO_CONFIG["height"] / 100,
            fill_opacity=1,
            stroke_width=0,
        )
        gradient.set_fill(
            color=[COLORS["soft_white"], COLORS["lavender"]],
            opacity=1
        )
        gradient.set_sheen_direction(DOWN)
        self.add(gradient)
    
    def add_film_grain(self, opacity: float = 0.03):
        """Add subtle animated film grain."""
        # Create noise texture
        grain = Rectangle(
            width=VIDEO_CONFIG["width"] / 100,
            height=VIDEO_CONFIG["height"] / 100,
            fill_opacity=opacity,
            stroke_width=0,
            fill_color=WHITE,
        )
        # Animate grain position for movement
        grain.add_updater(lambda m, dt: m.shift(
            np.array([np.random.uniform(-0.01, 0.01), 
                     np.random.uniform(-0.01, 0.01), 0]) * dt * 10
        ))
        self.add(grain)
    
    def create_headline(self, text: str, y_offset: float = 0, 
                        color: str = COLORS["dark_text"], 
                        highlight_words: list = None,
                        highlight_color: str = COLORS["hot_pink"],
                        scale: float = MANIM_FONT_SIZES["headline"],
                        weight: str = "EXTRA_BOLD") -> VGroup:
        """Create headline text with optional highlighted words."""
        words = text.split()
        text_mobs = []
        
        for i, word in enumerate(words):
            is_highlight = highlight_words and any(hw.lower() in word.lower() for hw in highlight_words)
            word_color = highlight_color if is_highlight else color
            word_weight = "EXTRA_BOLD" if is_highlight else weight
            
            t = Text(
                word + (" " if i < len(words) - 1 else ""),
                font=FONTS["heading"],
                font_size=FONT_SIZES["headline"],
                color=word_color,
                weight=word_weight,
            ).scale(scale / MANIM_FONT_SIZES["headline"])
            
            text_mobs.append(t)
        
        group = VGroup(*text_mobs).arrange(RIGHT, buff=0.1)
        group.move_to([0, safe_y_to_manim(CONTENT_CENTER_Y + y_offset), 0])
        return group
    
    def create_body_text(self, text: str, y_offset: float = 0,
                         color: str = COLORS["dark_text"],
                         scale: float = MANIM_FONT_SIZES["body"],
                         weight: str = "SEMI_BOLD") -> Text:
        """Create body text."""
        return Text(
            text,
            font=FONTS["body"],
            font_size=FONT_SIZES["body"],
            color=color,
            weight=weight,
            line_spacing=1.2,
        ).scale(scale / MANIM_FONT_SIZES["body"]).move_to(
            [0, safe_y_to_manim(CONTENT_CENTER_Y + y_offset), 0]
        )
    
    def create_caption_text(self, text: str, y: float = None) -> Text:
        """Create caption text for burned-in subtitles."""
        if y is None:
            y = get_caption_y()
        return Text(
            text,
            font=FONTS["regular"],
            font_size=FONT_SIZES["caption"],
            color=COLORS["dark_text"],
            weight="SEMI_BOLD",
            line_spacing=1.4,
        ).scale(MANIM_FONT_SIZES["caption"]).move_to([0, y, 0])
    
    def create_code_text(self, lines: list, y_offset: float = 0) -> VGroup:
        """Create syntax-highlighted code block."""
        code_lines = []
        for line_data in lines:
            if isinstance(line_data, str):
                # Simple line
                t = Text(
                    line_data,
                    font=FONTS["code"],
                    font_size=FONT_SIZES["code"],
                    color=COLORS["code_variable"],
                )
            else:
                # Highlighted line: [(text, color), ...]
                parts = []
                for text, color in line_data:
                    parts.append(Text(text, font=FONTS["code"], font_size=FONT_SIZES["code"], color=color))
                t = VGroup(*parts).arrange(RIGHT, buff=0.05)
            code_lines.append(t)
        
        group = VGroup(*code_lines).arrange(DOWN, buff=0.15, aligned_edge=LEFT)
        group.move_to([0, safe_y_to_manim(CONTENT_CENTER_Y + y_offset), 0])
        return group
    
    def create_card(self, width: float, height: float, 
                    icon: str = "", label: str = "",
                    color: str = COLORS["electric_blue"],
                    icon_scale: float = 1.0) -> VGroup:
        """Create a card with icon and label."""
        card = RoundedRectangle(
            width=width / 100,
            height=height / 100,
            corner_radius=0.16,
            fill_color=WHITE,
            fill_opacity=1,
            stroke_color=COLORS["lavender"],
            stroke_width=0.02,
        )
        
        # Top accent bar
        accent = Rectangle(
            width=width / 100,
            height=0.06,
            fill_color=color,
            fill_opacity=1,
            stroke_width=0,
        ).move_to(card.get_top() + DOWN * 0.03)
        accent.stretch_to_fit_width(width / 100)
        
        # Icon
        icon_text = Text(icon, font_size=64).scale(icon_scale)
        icon_text.move_to(card.get_center() + UP * 0.3)
        
        # Label
        label_text = Text(label, font=FONTS["body"], font_size=FONT_SIZES["ui"], 
                          color=COLORS["dark_text"], weight="SEMI_BOLD")
        label_text.move_to(card.get_center() + DOWN * 0.4)
        
        # Shadow
        card.set_shadow(dx=0, dy=0.08, blur_radius=0.16, opacity=0.08)
        
        return VGroup(card, accent, icon_text, label_text)
    
    def create_button(self, width: float, height: float, 
                      label: str, color: str = COLORS["hot_pink"],
                      text_color: str = WHITE) -> VGroup:
        """Create a pill-shaped button."""
        btn = RoundedRectangle(
            width=width / 100,
            height=height / 100,
            corner_radius=height / 200,
            fill_color=color,
            fill_opacity=1,
            stroke_width=0,
        )
        btn.set_shadow(dx=0, dy=0.04, blur_radius=0.12, opacity=0.4)
        
        label_text = Text(label, font=FONTS["heading"], font_size=FONT_SIZES["ui"],
                          color=text_color, weight="EXTRA_BOLD")
        label_text.move_to(btn.get_center())
        
        return VGroup(btn, label_text)
    
    def create_checkmark(self, size: float = 48, color: str = COLORS["mint_green"]) -> VGroup:
        """Create a checkmark icon."""
        circle = Circle(radius=size / 200, color=color, fill_opacity=1, stroke_width=0)
        check = VMobject()
        check.set_points_as_corners([
            LEFT * size / 300,
            ORIGIN,
            RIGHT * size / 300 + UP * size / 300,
        ])
        check.set_stroke(WHITE, width=size / 300)
        return VGroup(circle, check)
    
    def create_sparkle(self, size: float = 1, color: str = COLORS["sunny_yellow"]) -> VGroup:
        """Create a sparkle shape."""
        cross = VGroup(
            Line(UP * size / 100, DOWN * size / 100, color=color, stroke_width=size / 50),
            Line(LEFT * size / 100, RIGHT * size / 100, color=color, stroke_width=size / 50),
        )
        diag = VGroup(
            Line(UP * size / 100 + LEFT * size / 100, DOWN * size / 100 + RIGHT * size / 100, 
                 color=color, stroke_width=size / 75),
            Line(UP * size / 100 + RIGHT * size / 100, DOWN * size / 100 + LEFT * size / 100, 
                 color=color, stroke_width=size / 75),
        ).set_opacity(0.7)
        center = Dot(radius=size / 300, color=color)
        return VGroup(cross, diag, center)
    
    def create_confetti_piece(self, shape: str = "square", 
                              color: str = COLORS["electric_blue"],
                              size: float = 16) -> VMobject:
        """Create a single confetti piece."""
        if shape == "square":
            return Square(side_length=size / 100, fill_color=color, fill_opacity=1, stroke_width=0)
        elif shape == "circle":
            return Circle(radius=size / 200, fill_color=color, fill_opacity=1, stroke_width=0)
        elif shape == "triangle":
            return Triangle().scale(size / 200).set_fill(color, opacity=1).set_stroke(width=0)
        elif shape == "strip":
            return Rectangle(width=size * 1.25 / 100, height=size * 0.375 / 100, 
                           fill_color=color, fill_opacity=1, stroke_width=0)
        elif shape == "star":
            star = VMobject()
            star.set_points_as_corners([
                UP * size / 100,
                UP * size / 300 + RIGHT * size / 300,
                RIGHT * size / 100,
                UP * size / 300 + RIGHT * size / 300,
                DOWN * size / 100,
                DOWN * size / 300 + LEFT * size / 300,
                LEFT * size / 100,
                DOWN * size / 300 + LEFT * size / 300,
            ])
            star.set_fill(color, opacity=1).set_stroke(width=0)
            return star
        return Square(side_length=size / 100, fill_color=color, fill_opacity=1, stroke_width=0)
    
    def play_with_sound(self, *animations, sound_key: str = None, **kwargs):
        """Play animation and trigger sound cue (for reference - actual audio added in post)."""
        self.play(*animations, **kwargs)
        if sound_key:
            # Log sound cue for post-production
            print(f"[SOUND] Frame {self.renderer.frame_number}: {sound_key}")
    
    def stagger_animations(self, animations: list, start_delay: float = 4/30, 
                           stagger: float = 4/30, jitter: float = 0.15) -> list:
        """Create staggered animation sequence."""
        import random
        staggered = []
        for i, anim in enumerate(animations):
            delay = start_delay + i * stagger + (random.random() - 0.5) * 2 * jitter * stagger
            staggered.append(Wait(delay))
            staggered.append(anim)
        return Succession(*staggered)
    
    def camera_push(self, scale_factor: float = 1.05, duration: float = 8/30, 
                    rate_func = smooth_rate_func) -> Animation:
        """Create camera push-in animation."""
        target_width = self.camera.frame_width / scale_factor
        target_height = self.camera.frame_height / scale_factor
        return self.camera.frame.animate.set(width=target_width).set(rate_func=rate_func).set_run_time(duration)
    
    def camera_pull(self, scale_factor: float = 1.0, duration: float = 8/30,
                    rate_func = smooth_rate_func) -> Animation:
        """Create camera pull-out animation."""
        return self.camera.frame.animate.set(width=VIDEO_CONFIG["width"] / 100).set(rate_func=rate_func).set_run_time(duration)
    
    def transition_whoosh(self, duration: float = 9/30) -> Animation:
        """Create a whoosh transition effect."""
        # Flash white frame
        flash = Rectangle(
            width=VIDEO_CONFIG["width"] / 100 * 2,
            height=VIDEO_CONFIG["height"] / 100 * 2,
            fill_color=WHITE,
            fill_opacity=0,
            stroke_width=0,
        )
        return Succession(
            flash.animate.set_fill_opacity(0.3).set_rate_func(ease_out_rate_func).set_run_time(duration/3),
            flash.animate.set_fill_opacity(0).set_rate_func(ease_out_rate_func).set_run_time(duration*2/3),
        )
    
    def get_current_frame(self) -> int:
        """Get current frame number."""
        return self.renderer.frame_number if hasattr(self, 'renderer') else 0
    
    def log_audio_cues(self):
        """Log audio cues for current frame (for post-production)."""
        frame = self.get_current_frame()
        cues = get_audio_cues_at_frame(frame)
        for cue_type, cue_data in cues:
            print(f"[AUDIO] Frame {frame} ({frame_to_timecode(frame)}): {cue_type} - {cue_data}")


def frame_to_timecode(frame: int) -> str:
    """Convert frame to timecode."""
    fps = 30
    total_seconds = frame / fps
    hours = int(total_seconds // 3600)
    minutes = int((total_seconds % 3600) // 60)
    seconds = int(total_seconds % 60)
    frames_remainder = frame % fps
    return f"{hours:02d}:{minutes:02d}:{seconds:02d}:{frames_remainder:02d}"


# Export base class
__all__ = ["VibeCoderScene", "frame_to_timecode"]
