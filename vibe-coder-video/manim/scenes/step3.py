# Step 3 Scene: 15-22s (frames 450-660)
# "Run it. Spot bugs. Ask AI to fix." - Code window with error→fix animation

from manim import *
from scenes.base import VibeCoderScene, frame_to_timecode
from config import VIDEO_CONFIG, COLORS, TIMING, SCENES
from easings import (punch_rate_func, bounce_rate_func, smooth_rate_func, 
                     spring_overshoot_rate_func, get_stagger_delay)
from safe_zones import (CONTENT_CENTER_Y, safe_y_to_manim, CENTER_X)
from audio_timing import SFX_MAP


class Step3(VibeCoderScene):
    """Step 3 scene: 15-22 seconds."""
    
    def construct(self):
        scene_start, scene_end = SCENES["step3"]
        
        # Background
        self.add_background()
        self.add_film_grain()
        
        # Transition
        self.play_transition_whoosh()
        
        # Header "Step 3"
        self.show_step_header("Step 3", delay=6/30)
        
        # Main text
        self.show_main_text(
            "Run it. Spot bugs. Ask AI to fix.",
            highlight_words=["bugs", "AI", "fix"],
            delay=15/30
        )
        
        # Code window
        self.show_code_window(delay=30/30)
        
        # Error banner
        self.show_error_banner(delay=75/30)
        
        # Fix click + spinner
        self.play_fix_sequence(delay=120/30)
        
        # Success checkmark
        self.play_success(delay=150/30)
        
        # Camera push
        self.play_camera_push(delay=180/30)
        
        # Hold to end
        self.wait((scene_end - scene_start - 210) / 30)
    
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
    
    def show_code_window(self, delay: float):
        """Create code editor window."""
        win_width = 9
        win_height = 5
        title_h = 0.48
        tab_h = 0.4
        editor_top = title_h + tab_h
        
        # Window background
        win_bg = RoundedRectangle(
            width=win_width, height=win_height, corner_radius=0.16,
            fill_color=COLORS["code_bg"], fill_opacity=1, stroke_color="#3A3A4A", stroke_width=0.02
        )
        win_bg.set_shadow(dx=0, dy=0.16, blur_radius=0.32, opacity=0.1)
        win_bg.move_to([0, safe_y_to_manim(CONTENT_CENTER_Y + 100) / 100, 0])
        win_bg.scale(0.8).set_opacity(0)
        
        # Title bar
        title_bar = Rectangle(width=win_width, height=title_h, fill_color="#252536", fill_opacity=1, stroke_width=0)
        title_bar.move_to(win_bg.get_top() + DOWN * title_h/2)
        
        # Traffic lights
        lights = VGroup()
        for i, color in enumerate(["#FF5F57", "#FEBC2E", "#28CA42"]):
            light = Circle(radius=0.07, fill_color=color, fill_opacity=1, stroke_width=0)
            light.move_to(title_bar.get_left() + RIGHT * (0.2 + i * 0.2) + UP * 0)
            lights.add(light)
        
        # Tab bar
        tab_bar = Rectangle(width=win_width, height=tab_h, fill_color=COLORS["code_bg"], fill_opacity=1, stroke_width=0)
        tab_bar.move_to(title_bar.get_bottom() + DOWN * tab_h/2)
        
        tab_active = RoundedRectangle(width=1.4, height=0.36, corner_radius=0.06,
                                     fill_color="#2D2D3A", fill_opacity=1, stroke_width=0)
        tab_active.move_to(tab_bar.get_left() + RIGHT * 0.8)
        tab_text = Text("main.py", font=FONTS["code"], font_size=12, color=COLORS["code_variable"])
        tab_text.move_to(tab_active.get_center())
        tab_dot = Circle(radius=0.04, fill_color=COLORS["mint_green"], fill_opacity=1)
        tab_dot.move_to(tab_active.get_left() + RIGHT * 0.1 + UP * 0.08)
        
        # Editor area
        editor = Rectangle(width=win_width, height=win_height - editor_top, 
                          fill_color="#16161D", fill_opacity=1, stroke_width=0)
        editor.move_to(tab_bar.get_bottom() + DOWN * (win_height - editor_top)/2)
        
        # Line numbers
        line_nums = VGroup()
        for i in range(1, 16):
            num = Text(str(i), font=FONTS["code"], font_size=13, color=COLORS["code_comment"])
            num.move_to(editor.get_left() + RIGHT * 0.3 + UP * (0.4 - i * 0.25))
            line_nums.add(num)
        
        # Code content
        code_lines = self.create_code_content()
        code_lines.move_to(editor.get_left() + RIGHT * 0.7 + UP * 0.35)
        
        # Blinking cursor
        cursor = Rectangle(width=0.02, height=0.18, fill_color=COLORS["code_variable"], fill_opacity=0.8)
        cursor.move_to(editor.get_left() + RIGHT * 2.5 + UP * 0.35 - DOWN * 0.25 * 14)
        cursor.phase = 0
        
        def blink_cursor(mob, dt):
            mob.phase += dt * 2
            mob.set_opacity(0.8 if np.sin(mob.phase) > 0 else 0)
        
        cursor.add_updater(blink_cursor)
        
        # Minimap
        minimap = Rectangle(width=0.3, height=win_height - editor_top, fill_color="#1E1E2E", fill_opacity=1, stroke_width=0)
        minimap.move_to(win_bg.get_right() + LEFT * 0.15)
        minimap_preview = Rectangle(width=0.26, height=2, fill_color="#3A3A4A", fill_opacity=1, stroke_width=0)
        minimap_preview.move_to(minimap.get_top() + DOWN * 1.2)
        
        code_group = VGroup(win_bg, title_bar, lights, tab_bar, tab_active, tab_text, tab_dot,
                           editor, line_nums, code_lines, cursor, minimap, minimap_preview)
        self.add(code_group)
        self.code_group = code_group
        self.code_bg = win_bg
        self.editor = editor
        self.cursor = cursor
        
        # Animate entrance
        self.wait(delay)
        self.play(
            win_bg.animate.scale(1.25).set_opacity(1),
            rate_func=punch_rate_func, run_time=20/30,
        )
    
    def create_code_content(self) -> VGroup:
        """Create syntax-highlighted code lines."""
        lines_data = [
            [("def ", COLORS["code_keyword"]), ("process_habits", COLORS["code_function"]), 
             ("(habit_list: ", COLORS["code_variable"]), ("List", COLORS["code_function"]), 
             ("[Habit]", COLORS["code_function"]), (") -> Dict:", COLORS["code_variable"])],
            [("# Process habits and calculate streaks", COLORS["code_comment"])],
            [("results = {", COLORS["code_variable"])],
            [("  ", COLORS["code_variable"]), ("\"coding\"", COLORS["code_string"]), (": ", COLORS["code_variable"]),
             ("calculate_streak", COLORS["code_function"]), ("(habit_list[", COLORS["code_variable"]),
             ("0", COLORS["code_function"]), (")),", COLORS["code_variable"])],
            [("  ", COLORS["code_variable"]), ("\"workout\"", COLORS["code_string"]), (": ", COLORS["code_variable"]),
             ("calculate_streak", COLORS["code_function"]), ("(habit_list[", COLORS["code_variable"]),
             ("1", COLORS["code_function"]), (")),", COLORS["code_variable"])],
            [("}", COLORS["code_keyword"])],
            [("return results", COLORS["code_keyword"])],
            [("", COLORS["code_variable"])],  # empty line
            [("def ", COLORS["code_keyword"]), ("calculate_streak", COLORS["code_function"]), ("(habit):", COLORS["code_variable"])],
            [("# Returns current streak count", COLORS["code_comment"])],
            [("streak = 0", COLORS["code_variable"])],
            [("for day in habit.days:", COLORS["code_variable"])],
            [("  ", COLORS["code_variable"]), ("if day.completed: ", COLORS["code_keyword"]), ("streak += 1", COLORS["code_variable"])],
            [("  ", COLORS["code_variable"]), ("else: break", COLORS["code_keyword"])],
            [("return streak", COLORS["code_keyword"])],
        ]
        
        code_group = VGroup()
        for line_data in lines_data:
            if len(line_data) == 1 and line_data[0][0] == "":
                # Empty line
                spacer = Rectangle(width=0, height=0.25, fill_opacity=0)
                code_group.add(spacer)
                continue
            
            line_parts = VGroup()
            for text, color in line_data:
                t = Text(text, font=FONTS["code"], font_size=14, color=color)
                line_parts.add(t)
            
            line = VGroup(*line_parts).arrange(RIGHT, buff=0.02)
            code_group.add(line)
        
        code_group.arrange(DOWN, buff=0.05, aligned_edge=LEFT)
        return code_group
    
    def show_error_banner(self, delay: float):
        """Show red error banner sliding down."""
        self.wait(delay)
        
        # Error banner
        banner = RoundedRectangle(
            width=8.6, height=0.5, corner_radius=0.08,
            fill_color=COLORS["error_red"], fill_opacity=1, stroke_width=0
        )
        banner.move_to(self.editor.get_top() + DOWN * 0.25)
        banner.shift(UP * 0.8).set_opacity(0)
        
        # X icon
        x_circle = Circle(radius=0.1, fill_color="#CC0000", fill_opacity=1, stroke_width=0)
        x_circle.move_to(banner.get_left() + RIGHT * 0.3)
        x_cross = VGroup(
            Line(x_circle.get_left() + LEFT*0.06 + UP*0.06, x_circle.get_right() + RIGHT*0.06 + DOWN*0.06, color=WHITE, stroke_width=0.03),
            Line(x_circle.get_left() + LEFT*0.06 + DOWN*0.06, x_circle.get_right() + RIGHT*0.06 + UP*0.06, color=WHITE, stroke_width=0.03),
        )
        
        error_text = Text("TypeError: Cannot read property 'map' of undefined", 
                         font=FONTS["regular"], font_size=14, color=WHITE, weight="SEMI_BOLD")
        error_text.move_to(banner.get_left() + RIGHT * 1.2)
        
        error_group = VGroup(banner, x_circle, x_cross, error_text)
        self.add(error_group)
        self.error_group = error_group
        
        # Animate slide down with bounce
        self.play(
            banner.animate.shift(DOWN * 0.8).set_opacity(1),
            x_circle.animate.shift(DOWN * 0.8),
            x_cross.animate.shift(DOWN * 0.8),
            error_text.animate.shift(DOWN * 0.8),
            rate_func=bounce_rate_func, run_time=15/30,
        )
        
        # Pulse on error line
        self.pulse_error_line()
    
    def pulse_error_line(self):
        """Highlight the error line in code."""
        # Find line 13 (0-indexed: 12) - the problematic line
        # In our code, line 13 is "for day in habit.days:"
        # We'll just pulse the whole editor area
        pass
    
    def play_fix_sequence(self, delay: float):
        """Click 'Ask AI to fix' -> spinner -> success."""
        self.wait(delay)
        
        # Fix button (pulsing)
        fix_btn = self.create_button(2.5, 0.5, "Ask AI to fix", COLORS["hot_pink"])
        fix_btn.move_to(self.editor.get_top() + DOWN * 0.8)
        fix_btn.set_opacity(0)
        
        self.add(fix_btn)
        self.play(fix_btn.animate.set_opacity(1), run_time=10/30)
        
        # Pulse
        for _ in range(2):
            self.play(fix_btn.animate.scale(1.05), rate_func=smooth_rate_func, run_time=15/30)
            self.play(fix_btn.animate.scale(1/1.05), rate_func=ease_out_rate_func, run_time=15/30)
        
        # Click
        self.play(fix_btn.animate.scale(0.95), rate_func=smooth_rate_func, run_time=5/30)
        self.play(fix_btn.animate.scale(1/0.95), rate_func=ease_out_rate_func, run_time=5/30)
        
        # Spinner
        self.play_spinner()
        
        self.remove(fix_btn)
    
    def play_spinner(self):
        """Loading spinner animation."""
        spinner = VGroup()
        for i in range(3):
            ring = Circle(radius=0.2 + i * 0.06, stroke_color=COLORS["electric_blue"], 
                         stroke_width=0.03, stroke_opacity=1 - i * 0.2)
            ring.set_stroke(opacity=[1, 0.6, 0.4][i])
            ring.dash_length = 0.5
            ring.gap_length = 0.3
            spinner.add(ring)
        
        spinner.move_to(self.code_group.get_right() + LEFT * 1)
        spinner.set_opacity(0)
        
        self.add(spinner)
        self.play(spinner.animate.set_opacity(1), run_time=5/30)
        
        # Rotate
        def rotate_spinner(mob, dt):
            for i, ring in enumerate(mob):
                ring.rotate(dt * (2 if i % 2 == 0 else -2.5))
        
        spinner.add_updater(rotate_spinner)
        self.wait(30/30)
        spinner.clear_updaters()
        self.play(spinner.animate.set_opacity(0), run_time=5/30)
        self.remove(spinner)
    
    def play_success(self, delay: float):
        """Show success checkmark with spring animation."""
        self.wait(delay)
        
        # Success checkmark
        checkmark = self.create_checkmark(size=60, color=COLORS["mint_green"])
        checkmark.move_to(self.editor.get_top() + DOWN * 0.25)
        checkmark.scale(0.3).set_opacity(0)
        
        self.add(checkmark)
        self.play(
            checkmark.animate.scale(1/0.3).set_opacity(1),
            rate_func=spring_overshoot_rate_func, run_time=20/30,
        )
        
        # Morph error to success
        self.morph_error_to_success(checkmark)
        
        # Success sparkles
        self.play_success_sparkles()
    
    def morph_error_to_success(self, checkmark):
        """Morph error banner to success banner."""
        # Create success banner
        banner = RoundedRectangle(
            width=8.6, height=0.5, corner_radius=0.08,
            fill_color=COLORS["success_green"], fill_opacity=1, stroke_width=0
        )
        banner.move_to(self.error_group[0].get_center())
        
        check_circle = Circle(radius=0.1, fill_color="#00B35E", fill_opacity=1, stroke_width=0)
        check_circle.move_to(banner.get_left() + RIGHT * 0.3)
        check_path = VMobject()
        check_path.set_points_as_corners([LEFT*0.06, ORIGIN, RIGHT*0.1+DOWN*0.1])
        check_path.set_stroke(WHITE, width=0.03)
        check_path.move_to(check_circle.get_center())
        
        success_text = Text("Fixed! Added null check ✓", 
                           font=FONTS["regular"], font_size=14, color=WHITE, weight="SEMI_BOLD")
        success_text.move_to(banner.get_left() + RIGHT * 1.2)
        
        success_group = VGroup(banner, check_circle, check_path, success_text)
        success_group.set_opacity(0)
        
        self.add(success_group)
        
        # Crossfade
        self.play(
            self.error_group.animate.set_opacity(0),
            success_group.animate.set_opacity(1),
            rate_func=smooth_rate_func, run_time=15/30,
        )
        
        self.remove(self.error_group)
        self.success_group = success_group
    
    def play_success_sparkles(self):
        """Sparkles on success."""
        sparkles = VGroup()
        for i in range(20):
            sparkle = self.create_sparkle(1.5, COLORS["mint_green"])
            angle = i * (2 * PI / 20)
            sparkle.move_to(self.success_group.get_center())
            sparkle.target = np.array([
                np.cos(angle) * 2,
                np.sin(angle) * 2,
                0
            ])
            sparkles.add(sparkle)
        
        self.add(sparkles)
        self.wait(30/30)
        self.remove(sparkles)
    
    def play_camera_push(self, delay: float):
        self.wait(delay)
        self.play_camera_push_in(scale=1.05, duration=30/30)


# For direct rendering
if __name__ == "__main__":
    scene = Step3()
    scene.render()
