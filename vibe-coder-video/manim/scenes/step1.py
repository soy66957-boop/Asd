# Step 1 Scene: 3-8s (frames 90-240)
# "Pick an AI coding tool." - Card stack with AI tool icons

from manim import *
from scenes.base import VibeCoderScene, frame_to_timecode
from config import VIDEO_CONFIG, COLORS, TIMING, SCENES
from easings import (punch_rate_func, bounce_rate_func, smooth_rate_func, 
                     get_stagger_delay, get_hand_offset)
from safe_zones import (CONTENT_CENTER_Y, safe_y_to_manim, CENTER_X, CONTENT_WIDTH)
from audio_timing import SFX_MAP


class Step1(VibeCoderScene):
    """Step 1 scene: 3-8 seconds."""
    
    def construct(self):
        scene_start, scene_end = SCENES["step1"]
        
        # Background
        self.add_background()
        self.add_film_grain()
        
        # Transition whoosh
        self.play_transition_whoosh()
        
        # Header "Step 1"
        self.show_step_header("Step 1", delay=6/30)
        
        # Main text
        self.show_main_text(
            "Pick an AI coding tool.",
            highlight_words=["AI coding tool"],
            delay=15/30
        )
        
        # Card stack
        self.show_card_stack(delay=36/30)
        
        # Camera push (7-8s)
        self.play_camera_push(delay=120/30)
        
        # Hold to end
        self.wait((scene_end - scene_start - 150) / 30)
    
    def play_transition_whoosh(self):
        """Quick whoosh transition."""
        flash = Rectangle(
            width=VIDEO_CONFIG["width"] / 100 * 2,
            height=VIDEO_CONFIG["height"] / 100 * 2,
            fill_color=WHITE, fill_opacity=0, stroke_width=0,
        )
        self.play(
            flash.animate.set_fill_opacity(0.2),
            rate_func=lambda t: 1 - (1 - t) ** 2,
            run_time=3/30,
        )
        self.play(
            flash.animate.set_fill_opacity(0),
            rate_func=lambda t: (1 - t) ** 2,
            run_time=6/30,
        )
        self.remove(flash)
    
    def show_step_header(self, text: str, delay: float):
        """Show step header."""
        header = self.create_headline(
            text, y_offset=-350, color=COLORS["electric_blue"], scale=1.5
        )
        header.set_opacity(0).scale(0.8)
        
        self.wait(delay)
        self.play(
            header.animate.set_opacity(1).scale(1),
            rate_func=bounce_rate_func,
            run_time=TIMING["text_pop"] / 30,
        )
        self.header = header
    
    def show_main_text(self, text: str, highlight_words: list, delay: float):
        """Show main descriptive text."""
        main_text = self.create_headline(
            text, y_offset=-250, highlight_words=highlight_words,
            highlight_color=COLORS["electric_blue"], scale=1.0
        )
        main_text.set_opacity(0).scale(0.8)
        
        self.wait(delay)
        self.play(
            main_text.animate.set_opacity(1).scale(1),
            rate_func=bounce_rate_func,
            run_time=TIMING["text_pop"] / 30,
        )
        self.main_text = main_text
    
    def show_card_stack(self, delay: float):
        """Show staggered card stack with AI tool cards."""
        cards_data = [
            {"icon": "🎯", "label": "Cursor", "color": COLORS["electric_blue"]},
            {"icon": "🤖", "label": "Copilot", "color": COLORS["hot_pink"]},
            {"icon": "🌊", "label": "Windsurf", "color": COLORS["mint_green"]},
        ]
        
        card_width = 280
        card_height = 180
        card_gap = 20
        total_width = len(cards_data) * card_width + (len(cards_data) - 1) * card_gap
        start_x = -total_width / 2 + card_width / 2
        
        cards = VGroup()
        
        for i, data in enumerate(cards_data):
            card = self.create_card(
                card_width, card_height,
                icon=data["icon"], label=data["label"],
                color=data["color"], icon_scale=1.5
            )
            
            # Position
            x = start_x + i * (card_width + card_gap)
            card.move_to([x / 100, safe_y_to_manim(CONTENT_CENTER_Y + 50) / 100, 0])
            
            # Start off-screen below
            card.shift(DOWN * 1.5).scale(0.5).set_opacity(0)
            
            cards.add(card)
            self.add(card)
        
        # Staggered animation
        self.wait(delay)
        
        for i, card in enumerate(cards):
            stagger_delay = get_stagger_delay(i, TIMING["card_stagger"] / 30, 0.1)
            
            # Wait for this card's turn
            if i > 0:
                self.wait(stagger_delay)
            
            self.play(
                card.animate.shift(UP * 1.5).scale(2).set_opacity(1),
                rate_func=punch_rate_func,
                run_time=TIMING["icon_slide"] / 30,
            )
            
            # Add slight fan rotation
            self.play(
                card.animate.rotate(-0.05 * (i - 1)),
                rate_func=smooth_rate_func,
                run_time=10/30,
            )
        
        self.cards = cards
        
        # Add ambient sparkles
        self.add_ambient_sparkles()
    
    def add_ambient_sparkles(self):
        """Add subtle floating sparkles around cards."""
        sparkles = VGroup()
        for i in range(5):
            sparkle = self.create_sparkle(0.8, COLORS["sunny_yellow"])
            x = np.random.uniform(-3, 3)
            y = safe_y_to_manim(CONTENT_CENTER_Y + 50) / 100 + np.random.uniform(-1, 1)
            sparkle.move_to([x, y, 0])
            sparkle.phase = np.random.uniform(0, 2 * PI)
            sparkles.add(sparkle)
        
        self.add(sparkles)
        
        def update_sparkles(mob, dt):
            for s in mob:
                s.phase += dt * 2
                s.set_opacity(0.3 + 0.3 * np.sin(s.phase))
                s.shift(UP * dt * 0.1)
        
        sparkles.add_updater(update_sparkles)
        self.ambient_sparkles = sparkles
    
    def play_camera_push(self, delay: float):
        """Subtle camera push-in."""
        self.wait(delay)
        self.play_camera_push_in(scale=1.05, duration=30/30)


# For direct rendering
if __name__ == "__main__":
    scene = Step1()
    scene.render()
