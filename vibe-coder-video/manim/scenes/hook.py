# Hook Scene: 0-3s (frames 0-90)
# "No degree? No problem." with confetti burst

from manim import *
from scenes.base import VibeCoderScene, frame_to_timecode
from config import VIDEO_CONFIG, COLORS, TIMING, SCENES
from easings import (punch_rate_func, bounce_rate_func, spring_overshoot_rate_func, 
                     get_stagger_delay)
from safe_zones import (CONTENT_CENTER_Y, safe_y_to_manim, CENTER_X, CENTER_Y)
from audio_timing import SFX_MAP, VOICEOVER_SEGMENTS


class Hook(VibeCoderScene):
    """Hook scene: 0-3 seconds."""
    
    def construct(self):
        # Scene timing
        scene_start, scene_end = SCENES["hook"]
        total_frames = scene_end - scene_start  # 90 frames = 3 seconds
        
        # Set up frame tracking
        self.frame_counter = 0
        
        # --- BACKGROUND ---
        self.setup_background()
        
        # --- RISER SWELL (0-0.5s / frames 0-15) ---
        self.play_riser()
        
        # --- "NO DEGREE?" (0.5-1.5s / frames 15-45) ---
        text1 = self.create_headline(
            "No degree?",
            y_offset=-80,
            color=COLORS["dark_text"],
            highlight_words=["degree"],
            highlight_color=COLORS["hot_pink"],
        )
        
        self.play(
            text1.animate.scale(1).set_opacity(1),
            rate_func=bounce_rate_func,
            run_time=TIMING["text_pop"] / 30,
        )
        self.wait((30 - 15 - TIMING["text_pop"]) / 30)
        
        # --- "NO PROBLEM." (1.0-1.83s / frames 30-55) ---
        text2 = self.create_headline(
            "No problem.",
            y_offset=40,
            color=COLORS["hot_pink"],
            highlight_words=["problem"],
            highlight_color=COLORS["hot_pink"],
        )
        
        self.play(
            text2.animate.scale(1).set_opacity(1),
            rate_func=bounce_rate_func,
            run_time=TIMING["text_pop"] / 30,
        )
        self.wait((45 - 30 - TIMING["text_pop"]) / 30)
        
        # --- CAMERA PUNCH-IN (1.5-2.0s / frames 45-60) ---
        self.play_camera_punch(text1, text2)
        
        # --- CONFETTI BURST (2.0-3.0s / frames 60-90) ---
        self.play_confetti_burst()
        
        # --- HOLD TO END ---
        self.wait((scene_end - 90) / 30)
    
    def setup_background(self):
        """Set up gradient background with film grain."""
        self.add_background()
        self.add_film_grain()
    
    def play_riser(self):
        """Visual riser swell - expanding ring."""
        riser = Circle(radius=0, color=COLORS["sunny_yellow"], stroke_width=0.08)
        riser.move_to([0, 0, 0])
        
        self.play(
            riser.animate.scale(4).set_stroke_width(0),
            rate_func=lambda t: 1 - (1 - t) ** 2,  # ease out
            run_time=15/30,
        )
        self.remove(riser)
    
    def play_camera_punch(self, *text_mobs):
        """Camera punch-in with slight overshoot."""
        group = VGroup(*text_mobs)
        
        # Punch in
        self.play(
            group.animate.scale(1.15).shift(DOWN * 0.05),
            rate_func=punch_rate_func,
            run_time=TIMING["camera_push"] / 30,
        )
        # Settle
        self.play(
            group.animate.scale(1/1.15).shift(UP * 0.05),
            rate_func=ease_out_rate_func,
            run_time=5/30,
        )
    
    def play_confetti_burst(self):
        """Confetti burst from center of text."""
        confetti_colors = [
            COLORS["electric_blue"], COLORS["hot_pink"], 
            COLORS["sunny_yellow"], COLORS["mint_green"], WHITE
        ]
        shapes = ["square", "circle", "triangle", "strip", "star"]
        
        particles = VGroup()
        for i in range(30):
            shape = shapes[i % len(shapes)]
            color = confetti_colors[i % len(confetti_colors)]
            piece = self.create_confetti_piece(shape, color, 16)
            
            # Random angle and distance
            angle = i * (2 * PI / 30)
            distance = 2.5 + np.random.uniform(0, 1.5)
            
            piece.move_to([0, 0, 0])
            piece.target_position = np.array([
                np.cos(angle) * distance,
                np.sin(angle) * distance,
                0
            ])
            piece.rotation_speed = np.random.uniform(-2, 2)
            piece.fade_start = np.random.uniform(0.5, 0.8)
            
            particles.add(piece)
        
        self.add(particles)
        
        # Animate confetti
        def update_confetti(mob, dt):
            for piece in mob:
                alpha = self.frame_counter / 30  # seconds
                if alpha > 1:
                    piece.set_opacity(0)
                    continue
                
                # Physics: initial velocity + gravity
                progress = min(1, alpha / 0.6)
                eased = 1 - (1 - progress) ** 2  # ease out
                
                pos = piece.target_position * eased
                piece.move_to(pos)
                piece.rotate(piece.rotation_speed * dt)
                
                # Fade out
                if progress > piece.fade_start:
                    fade_progress = (progress - piece.fade_start) / (1 - piece.fade_start)
                    piece.set_opacity(1 - fade_progress)
        
        particles.add_updater(update_confetti)
        
        # Wait for confetti to settle
        self.wait(30/30)
        particles.clear_updaters()
        self.remove(particles)
        
        # Final confetti on ground
        self.add_final_confetti()
    
    def add_final_confetti(self):
        """Add settled confetti pieces."""
        confetti_colors = [
            COLORS["electric_blue"], COLORS["hot_pink"], 
            COLORS["sunny_yellow"], COLORS["mint_green"], WHITE
        ]
        shapes = ["square", "circle", "triangle", "strip", "star"]
        
        settled = VGroup()
        for i in range(20):
            shape = shapes[i % len(shapes)]
            color = confetti_colors[i % len(confetti_colors)]
            piece = self.create_confetti_piece(shape, color, 12)
            
            # Random position near bottom of text area
            x = np.random.uniform(-2, 2)
            y = np.random.uniform(-1.5, 0.5)
            rotation = np.random.uniform(0, 2 * PI)
            
            piece.move_to([x, y, 0])
            piece.rotate(rotation)
            settled.add(piece)
        
        self.add(settled)
    
    def update_frame(self):
        """Called each frame for frame counter."""
        self.frame_counter += 1
        if self.frame_counter in SFX_MAP:
            print(f"[SOUND] Frame {self.frame_counter}: {SFX_MAP[self.frame_counter]}")


# For direct rendering
if __name__ == "__main__":
    scene = Hook()
    scene.render()
