# CTA Scene: 27-30s (frames 810-900)
# "Follow to become a vibe coder." - Bouncing arrow + logo

from manim import *
from scenes.base import VibeCoderScene, frame_to_timecode
from config import VIDEO_CONFIG, COLORS, TIMING, SCENES
from easings import (punch_rate_func, bounce_rate_func, smooth_rate_func, 
                     spring_overshoot_rate_func, spring_rate_func)
from safe_zones import (CONTENT_CENTER_Y, CONTENT_BOTTOM, safe_y_to_manim, CENTER_X)
from audio_timing import SFX_MAP


class CTA(VibeCoderScene):
    """CTA scene: 27-30 seconds."""
    
    def construct(self):
        scene_start, scene_end = SCENES["cta"]
        
        # Background
        self.add_background()
        self.add_film_grain()
        
        # Transition
        self.play_transition_whoosh()
        
        # CTA Text
        self.show_cta_text(delay=6/30)
        
        # Gradient "vibe coder" highlight
        self.show_vibe_coder_highlight(delay=30/30)
        
        # Bouncing arrow
        self.show_bouncing_arrow(delay=36/30)
        
        # Follow button
        self.show_follow_button(delay=51/30)
        
        # Fade to logo
        self.fade_to_logo(delay=75/30)
        
        # Final confetti
        self.play_final_confetti()
        
        # Hold to end
        self.wait((scene_end - scene_start - 90) / 30)
    
    def play_transition_whoosh(self):
        flash = Rectangle(
            width=VIDEO_CONFIG["width"] / 100 * 2,
            height=VIDEO_CONFIG["height"] / 100 * 2,
            fill_color=WHITE, fill_opacity=0, stroke_width=0,
        )
        self.play(
            flash.animate.set_fill_opacity(0.2), rate_func=lambda t: 1 - (1-t)**2, run_time=3/30,
        )
        self.play(
            flash.animate.set_opacity(0), rate_func=lambda t: (1-t)**2, run_time=6/30,
        )
        self.remove(flash)
    
    def show_cta_text(self, delay: float):
        """Show main CTA text."""
        cta_text = self.create_headline(
            "Follow to become a vibe coder.",
            y_offset=-100,
            highlight_words=["vibe coder", "Follow"],
            highlight_color=COLORS["hot_pink"],
            scale=0.9
        )
        cta_text.set_opacity(0).scale(0.8)
        
        self.wait(delay)
        self.play(
            cta_text.animate.set_opacity(1).scale(1),
            rate_func=bounce_rate_func, run_time=TIMING["text_pop"]/30,
        )
        self.cta_text = cta_text
    
    def show_vibe_coder_highlight(self, delay: float):
        """Show gradient 'vibe coder' text for emphasis."""
        self.wait(delay)
        
        vibe_text = Text(
            "vibe coder",
            font=FONTS["heading"],
            font_size=FONT_SIZES["headline"],
            weight="EXTRA_BOLD",
        )
        # Apply gradient manually by creating colored segments
        vibe_text.set_color_by_gradient(COLORS["hot_pink"], COLORS["electric_blue"], COLORS["mint_green"])
        vibe_text.move_to([0, safe_y_to_manim(CONTENT_CENTER_Y - 100) / 100, 0])
        vibe_text.set_opacity(0).scale(0.8)
        
        self.add(vibe_text)
        
        self.play(
            vibe_text.animate.set_opacity(1).scale(1.2),
            rate_func=punch_rate_func, run_time=10/30,
        )
        self.play(
            vibe_text.animate.scale(1/1.2),
            rate_func=ease_out_rate_func, run_time=10/30,
        )
        
        # Glow pulse
        for _ in range(2):
            self.play(
                vibe_text.animate.scale(1.02),
                rate_func=smooth_rate_func, run_time=15/30,
            )
            self.play(
                vibe_text.animate.scale(1/1.02),
                rate_func=ease_out_rate_func, run_time=15/30,
            )
        
        self.vibe_text = vibe_text
    
    def show_bouncing_arrow(self, delay: float):
        """Show bouncing arrow pointing to follow button zone."""
        self.wait(delay)
        
        # Arrow
        arrow = self.create_bouncing_arrow()
        arrow.move_to([0, safe_y_to_manim(CONTENT_BOTTOM - 180) / 100, 0])
        arrow.scale(1.2)
        
        self.add(arrow)
        self.arrow = arrow
        
        # Continuous bounce loop
        arrow.phase = 0
        arrow.bounce_height = 0.25  # Manim units
        
        def bounce_arrow(mob, dt):
            mob.phase += dt * 2  # 2 cycles per second
            bounce = np.sin(mob.phase * PI)  # 0 -> 1 -> 0
            spring_val = 1 - (1 - bounce) ** 2  # ease out
            y_offset = -mob.bounce_height * spring_val
            mob.move_to([0, safe_y_to_manim(CONTENT_BOTTOM - 180) / 100 + y_offset, 0])
            # Subtle scale pulse
            scale_pulse = 1 + 0.05 * np.sin(mob.phase * 2 * PI)
            mob.scale(scale_pulse)
        
        arrow.add_updater(bounce_arrow)
    
    def create_bouncing_arrow(self) -> VGroup:
        """Create the bouncing arrow graphic."""
        arrow_color = COLORS["hot_pink"]
        
        # Arrow head
        head = VMobject()
        head.set_points_as_corners([
            UP * 0.3,
            LEFT * 0.2,
            DOWN * 0.15,
            RIGHT * 0.4,
            DOWN * 0.15,
            LEFT * 0.2,
        ])
        head.set_fill(arrow_color, opacity=1).set_stroke(width=0)
        
        # Shaft
        shaft = Rectangle(width=0.08, height=0.35, fill_color=arrow_color, fill_opacity=1, stroke_width=0)
        shaft.move_to(DOWN * 0.1)
        
        # Shadow
        shadow = VGroup(head.copy(), shaft.copy())
        shadow.set_fill(arrow_color, opacity=0.15)
        shadow.shift(DOWN * 0.04)
        
        # Glow
        glow = Circle(radius=0.5, fill_color=arrow_color, fill_opacity=0.1, stroke_width=0)
        
        return VGroup(glow, shadow, shaft, head)
    
    def show_follow_button(self, delay: float):
        """Show follow button mockup."""
        self.wait(delay)
        
        btn_width = 2.4
        btn_height = 0.72
        
        btn_bg = RoundedRectangle(
            width=btn_width, height=btn_height, corner_radius=btn_height/2,
            fill_color=COLORS["hot_pink"], fill_opacity=1, stroke_width=0
        )
        btn_bg.set_shadow(dx=0, dy=0.04, blur_radius=0.12, opacity=0.4)
        btn_bg.move_to([0, safe_y_to_manim(CONTENT_BOTTOM - 80) / 100, 0])
        btn_bg.scale(0).set_opacity(0)
        
        btn_text = Text("Follow", font=FONTS["heading"], font_size=FONT_SIZES["ui"],
                       color=WHITE, weight="EXTRA_BOLD")
        btn_text.move_to(btn_bg.get_center())
        
        btn_group = VGroup(btn_bg, btn_text)
        self.add(btn_group)
        
        self.play(
            btn_group.animate.scale(1).set_opacity(1),
            rate_func=spring_overshoot_rate_func, run_time=20/30,
        )
        
        self.follow_btn = btn_group
    
    def fade_to_logo(self, delay: float):
        """Fade out everything and show logo."""
        self.wait(delay)
        
        # Stop arrow bounce
        if hasattr(self, 'arrow'):
            self.arrow.clear_updaters()
        
        # Fade out main content
        fade_group = VGroup(
            self.cta_text, self.vibe_text, self.arrow, self.follow_btn
        )
        
        self.play(
            fade_group.animate.set_opacity(0),
            rate_func=lambda t: 1 - t, run_time=15/30,
        )
        
        # Logo
        self.show_logo()
    
    def show_logo(self):
        """Show @vibecoder logo."""
        logo_circle = Circle(radius=0.4, fill_opacity=1, stroke_width=0)
        logo_circle.set_fill_by_gradient(COLORS["hot_pink"], COLORS["electric_blue"], COLORS["mint_green"])
        
        at_symbol = Text("@", font=FONTS["heading"], font_size=24, color=WHITE, weight="EXTRA_BOLD")
        at_symbol.move_to(logo_circle.get_center() + UP * 0.12)
        
        handle = Text("vibecoder", font=FONTS["body"], font_size=18, color=WHITE, weight="SEMI_BOLD")
        handle.move_to(logo_circle.get_center() + DOWN * 0.15)
        
        logo_group = VGroup(logo_circle, at_symbol, handle)
        logo_group.move_to([0, safe_y_to_manim(CONTENT_CENTER_Y + 200) / 100, 0])
        logo_group.set_opacity(0).scale(0.8)
        
        self.add(logo_group)
        
        self.play(
            logo_group.animate.set_opacity(1).scale(1),
            rate_func=spring_overshoot_rate_func, run_time=20/30,
        )
        
        self.logo_group = logo_group
    
    def play_final_confetti(self):
        """Final confetti burst."""
        colors = [COLORS["electric_blue"], COLORS["hot_pink"], COLORS["sunny_yellow"], 
                 COLORS["mint_green"], WHITE]
        shapes = ["square", "circle", "triangle", "strip", "star"]
        
        particles = VGroup()
        for i in range(40):
            shape = shapes[i % len(shapes)]
            color = colors[i % len(colors)]
            piece = self.create_confetti_piece(shape, color, 16)
            
            angle = i * (2 * PI / 40)
            distance = 3 + np.random.uniform(0, 2)
            
            piece.move_to([0, 0, 0])
            piece.target = np.array([
                np.cos(angle) * distance,
                np.sin(angle) * distance,
                0
            ])
            piece.rotation_speed = np.random.uniform(-3, 3)
            piece.fade_start = np.random.uniform(0.4, 0.7)
            
            particles.add(piece)
        
        self.add(particles)
        
        def update(mob, dt):
            for p in mob:
                if not hasattr(p, 'progress'):
                    p.progress = 0
                p.progress += dt / 1.5
                if p.progress > 1:
                    p.set_opacity(0)
                    continue
                
                eased = 1 - (1 - p.progress) ** 2
                pos = p.target * eased
                p.move_to(pos)
                p.rotate(p.rotation_speed * dt)
                
                if p.progress > p.fade_start:
                    fade = (p.progress - p.fade_start) / (1 - p.fade_start)
                    p.set_opacity(1 - fade)
        
        particles.add_updater(update)
        self.wait(15/30)
        particles.clear_updaters()
        self.remove(particles)


# For direct rendering
if __name__ == "__main__":
    scene = CTA()
    scene.render()
