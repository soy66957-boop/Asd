# Step 4 Scene: 22-27s (frames 660-810)
# "Ship something small every day." - Calendar filling with checkmarks

from manim import *
from scenes.base import VibeCoderScene, frame_to_timecode
from config import VIDEO_CONFIG, COLORS, TIMING, SCENES
from easings import (punch_rate_func, bounce_rate_func, smooth_rate_func, 
                     spring_overshoot_rate_func, get_stagger_delay)
from safe_zones import (CONTENT_CENTER_Y, safe_y_to_manim, CENTER_X, CONTENT_WIDTH)
from audio_timing import SFX_MAP


class Step4(VibeCoderScene):
    """Step 4 scene: 22-27 seconds."""
    
    def construct(self):
        scene_start, scene_end = SCENES["step4"]
        
        # Background
        self.add_background()
        self.add_film_grain()
        
        # Transition
        self.play_transition_whoosh()
        
        # Header "Step 4"
        self.show_step_header("Step 4", delay=6/30)
        
        # Main text
        self.show_main_text(
            "Ship something small every day.",
            highlight_words=["Ship", "every day"],
            delay=15/30
        )
        
        # Calendar
        self.show_calendar(delay=30/30)
        
        # Fill checkmarks
        self.fill_checkmarks(delay=45/30)
        
        # Camera pull back
        self.play_camera_pull(delay=120/30)
        
        # Hold to end
        self.wait((scene_end - scene_start - 150) / 30)
    
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
    
    def show_step_header(self, text: str, delay: float):
        header = self.create_headline(text, y_offset=-380, color=COLORS["electric_blue"], scale=1.5)
        header.set_opacity(0).scale(0.8)
        self.wait(delay)
        self.play(header.animate.set_opacity(1).scale(1), rate_func=bounce_rate_func, run_time=TIMING["text_pop"]/30)
        self.header = header
    
    def show_main_text(self, text: str, highlight_words: list, delay: float):
        main_text = self.create_headline(text, y_offset=-280, highlight_words=highlight_words, scale=0.85)
        main_text.set_opacity(0).scale(0.8)
        self.wait(delay)
        self.play(main_text.animate.set_opacity(1).scale(1), rate_func=bounce_rate_func, run_time=TIMING["text_pop"]/30)
        self.main_text = main_text
    
    def show_calendar(self, delay: float):
        """Create calendar grid."""
        cell_size = 1.0
        cell_gap = 0.08
        cols = 7
        rows = 4
        day_names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        grid_width = cols * cell_size + (cols - 1) * cell_gap
        grid_height = rows * cell_size + (rows - 1) * cell_gap + 0.4  # + day names
        
        calendar_group = VGroup()
        
        # Day names
        for i, day in enumerate(day_names):
            x = -grid_width/2 + i * (cell_size + cell_gap) + cell_size/2
            y = grid_height/2 - 0.2
            label = Text(day, font=FONTS["body"], font_size=18, color=COLORS["code_comment"], weight="SEMI_BOLD")
            label.move_to([x, y, 0])
            calendar_group.add(label)
        
        # Grid cells
        self.cells = []
        self.checkmarks = []
        
        for day_idx in range(28):  # 4 weeks
            day = day_idx + 1
            col = day_idx % cols
            row = day_idx // cols
            
            x = -grid_width/2 + col * (cell_size + cell_gap) + cell_size/2
            y = grid_height/2 - 0.4 - row * (cell_size + cell_gap) - cell_size/2
            
            # Cell background
            cell = RoundedRectangle(
                width=cell_size, height=cell_size, corner_radius=0.12,
                fill_color=WHITE, fill_opacity=1, stroke_color=COLORS["lavender"], stroke_width=0.02
            )
            cell.move_to([x, y, 0])
            
            # Today indicator (day 7)
            if day == 7:
                today_ring = RoundedRectangle(
                    width=cell_size - 0.08, height=cell_size - 0.08, corner_radius=0.1,
                    fill_opacity=0, stroke_color=COLORS["electric_blue"], stroke_width=0.02
                )
                today_ring.move_to(cell.get_center())
                calendar_group.add(today_ring)
            
            # Day number
            num = Text(str(day), font=FONTS["body"], font_size=28, color=COLORS["dark_text"], weight="SEMI_BOLD")
            num.move_to(cell.get_center() + UP * 0.15)
            
            # Checkmark (initially hidden)
            checkmark = self.create_checkmark(size=48, color=COLORS["mint_green"])
            checkmark.move_to(cell.get_center() + DOWN * 0.05)
            checkmark.scale(0.2).set_opacity(0)
            
            cell_group = VGroup(cell, num, checkmark)
            calendar_group.add(cell_group)
            self.cells.append(cell_group)
            self.checkmarks.append(checkmark)
        
        # Position calendar
        calendar_group.move_to([0, safe_y_to_manim(CONTENT_CENTER_Y + 80) / 100, 0])
        calendar_group.scale(0.8).set_opacity(0)
        
        self.add(calendar_group)
        self.calendar_group = calendar_group
        
        # Animate entrance
        self.wait(delay)
        self.play(
            calendar_group.animate.scale(1.25).set_opacity(1),
            rate_func=punch_rate_func, run_time=30/30,
        )
    
    def fill_checkmarks(self, delay: float):
        """Fill checkmarks for first 14 days (2 weeks)."""
        self.wait(delay)
        
        filled_days = 14
        
        for day_idx in range(filled_days):
            stagger_delay = get_stagger_delay(day_idx, TIMING["card_stagger"] / 30, 0.1)
            
            if day_idx > 0:
                self.wait(stagger_delay)
            
            checkmark = self.checkmarks[day_idx]
            
            # Spring animation with overshoot
            self.play(
                checkmark.animate.scale(5).set_opacity(1),
                rate_func=spring_overshoot_rate_func, run_time=15/30,
            )
            
            # Mini confetti burst
            self.play_mini_confetti(checkmark.get_center())
            
            # Ascending pitch pops (handled in audio post)
            print(f"[SOUND] Checkmark {day_idx + 1} pop")
    
    def play_mini_confetti(self, center):
        """Mini confetti burst from checkmark."""
        colors = [COLORS["electric_blue"], COLORS["hot_pink"], COLORS["sunny_yellow"], COLORS["mint_green"], WHITE]
        shapes = ["square", "circle", "triangle", "strip", "star"]
        
        particles = VGroup()
        for i in range(5):
            shape = shapes[i % len(shapes)]
            color = colors[i % len(colors)]
            piece = self.create_confetti_piece(shape, color, 10)
            piece.move_to(center)
            
            angle = i * (2 * PI / 5)
            piece.velocity = np.array([np.cos(angle) * 1.5, np.sin(angle) * 1.5, 0])
            piece.gravity = np.array([0, -1, 0])
            piece.life = 1.0
            
            particles.add(piece)
        
        self.add(particles)
        
        def update(mob, dt):
            for p in mob:
                p.life -= dt
                if p.life <= 0:
                    p.set_opacity(0)
                    continue
                p.velocity += p.gravity * dt
                p.shift(p.velocity * dt)
                p.set_opacity(p.life)
        
        particles.add_updater(update)
        self.wait(15/30)
        particles.clear_updaters()
        self.remove(particles)
    
    def play_camera_pull(self, delay: float):
        """Camera pull out slightly."""
        self.wait(delay)
        self.play_camera_pull_out(scale=1.0, duration=30/30)
    
    def play_camera_pull_out(self, scale: float = 1.0, duration: float = 1):
        """Pull camera out."""
        target_width = VIDEO_CONFIG["width"] / 100 / scale
        self.play(
            self.camera.frame.animate.set(width=target_width),
            rate_func=smooth_rate_func, run_time=duration,
        )


# For direct rendering
if __name__ == "__main__":
    scene = Step4()
    scene.render()
