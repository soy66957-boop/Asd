# Step 2 Scene: 8-15s (frames 240-450)
# "Describe your idea in plain English." - Chat box + phone app build

from manim import *
from scenes.base import VibeCoderScene, frame_to_timecode
from config import VIDEO_CONFIG, COLORS, TIMING, SCENES
from easings import (punch_rate_func, bounce_rate_func, smooth_rate_func, 
                     get_stagger_delay)
from safe_zones import (CONTENT_CENTER_Y, safe_y_to_manim, CENTER_X, CONTENT_WIDTH)
from audio_timing import SFX_MAP


class Step2(VibeCoderScene):
    """Step 2 scene: 8-15 seconds."""
    
    def construct(self):
        scene_start, scene_end = SCENES["step2"]
        
        # Background
        self.add_background()
        self.add_film_grain()
        
        # Transition
        self.play_transition_whoosh()
        
        # Header "Step 2"
        self.show_step_header("Step 2", delay=6/30)
        
        # Main text
        self.show_main_text(
            "Describe your idea in plain English.",
            highlight_words=["plain English"],
            delay=15/30
        )
        
        # Chat box (left side)
        self.show_chat_box(delay=30/30)
        
        # Phone mockup (right side)
        self.show_phone_mockup(delay=120/30)
        
        # App build animation
        self.play_app_build(delay=135/30)
        
        # Camera push on phone
        self.play_camera_push_on_phone(delay=180/30)
        
        # Hold to end
        self.wait((scene_end - scene_start - 210) / 30)
    
    def play_transition_whoosh(self):
        flash = Rectangle(
            width=VIDEO_CONFIG["width"] / 100 * 2,
            height=VIDEO_CONFIG["height"] / 100 * 2,
            fill_color=WHITE, fill_opacity=0, stroke_width=0,
        )
        self.play(
            flash.animate.set_fill_opacity(0.2), rate_func=lambda t: 1 - (1 - t)**2, run_time=3/30,
        )
        self.play(
            flash.animate.set_fill_opacity(0), rate_func=lambda t: (1-t)**2, run_time=6/30,
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
    
    def show_chat_box(self, delay: float):
        """Create chat box with typing animation."""
        chat_width = 8
        chat_height = 1.2
        
        # Chat box background
        chat_bg = RoundedRectangle(
            width=chat_width, height=chat_height, corner_radius=0.16,
            fill_color=WHITE, fill_opacity=1, stroke_color=COLORS["lavender"], stroke_width=0.02
        )
        chat_bg.set_shadow(dx=0, dy=0.08, blur_radius=0.16, opacity=0.08)
        chat_bg.move_to([-2, safe_y_to_manim(CONTENT_CENTER_Y - 150) / 100, 0])
        chat_bg.scale(0.8).shift(DOWN * 0.5).set_opacity(0)
        
        # User bubble
        bubble = RoundedRectangle(
            width=5.5, height=0.8, corner_radius=0.16,
            fill_color=COLORS["electric_blue"], fill_opacity=1, stroke_width=0
        )
        bubble.move_to(chat_bg.get_center() + LEFT * 0.2)
        
        # Prompt text (will be typed)
        prompt = "Build a habit tracker with streaks and reminders"
        self.prompt_text = prompt
        self.typed_chars = 0
        
        prompt_display = Text("", font=FONTS["regular"], font_size=FONT_SIZES["body"],
                            color=WHITE, weight="REGULAR")
        prompt_display.move_to(bubble.get_center())
        
        # Send button
        send_btn = Circle(radius=0.28, fill_color=COLORS["electric_blue"], fill_opacity=1, stroke_width=0)
        send_btn.move_to(chat_bg.get_right() + LEFT * 0.6 + DOWN * 0.05)
        send_icon = Text("▶", font_size=24, color=WHITE).move_to(send_btn.get_center())
        send_btn_group = VGroup(send_btn, send_icon).scale(0).set_opacity(0)
        
        # Typing indicator
        typing_dots = VGroup()
        for j in range(3):
            dot = Dot(radius=0.06, color=COLORS["electric_blue"])
            dot.move_to(chat_bg.get_center() + LEFT * 2 + RIGHT * j * 0.3)
            dot.phase = j * 0.5
            typing_dots.add(dot)
        typing_dots.set_opacity(0)
        
        chat_group = VGroup(chat_bg, bubble, prompt_display, send_btn_group, typing_dots)
        self.add(chat_group)
        self.chat_group = chat_group
        self.chat_bg = chat_bg
        self.bubble = bubble
        self.prompt_display = prompt_display
        self.send_btn = send_btn_group
        self.typing_dots = typing_dots
        
        # Animate entrance
        self.wait(delay)
        self.play(
            chat_bg.animate.scale(1.25).shift(UP * 0.5).set_opacity(1),
            rate_func=punch_rate_func, run_time=20/30,
        )
        self.wait(10/30)
        
        # Show typing indicator
        self.play(typing_dots.animate.set_opacity(1), run_time=5/30)
        
        # Typewriter animation
        self.play_typing_animation()
        
        # Send
        self.play_send()
    
    def play_typing_animation(self):
        """Animate typing the prompt."""
        def update_typing(mob, dt):
            if self.typed_chars < len(self.prompt_text):
                self.typed_chars += dt * 33  # ~33 chars/sec
                self.typed_chars = min(self.typed_chars, len(self.prompt_text))
                self.prompt_display.set_text(self.prompt_text[:int(self.typed_chars)])
                
                # Blinking cursor
                if int(self.typed_chars * 2) % 2 == 0:
                    self.prompt_display.set_text(self.prompt_display.text + "|")
        
        self.prompt_display.add_updater(update_typing)
        self.wait(75/30)  # Typing duration
        self.prompt_display.clear_updaters()
        self.prompt_display.set_text(self.prompt_text)
    
    def play_send(self):
        """Animate send button press."""
        self.play(self.typing_dots.animate.set_opacity(0), run_time=5/30)
        
        self.play(
            self.send_btn.animate.scale(1).set_opacity(1),
            rate_func=punch_rate_func, run_time=15/30,
        )
        
        # Pulse
        self.play(
            self.send_btn.animate.scale(1.1),
            rate_func=smooth_rate_func, run_time=5/30,
        )
        self.play(
            self.send_btn.animate.scale(1/1.1),
            rate_func=ease_out_rate_func, run_time=10/30,
        )
    
    def show_phone_mockup(self, delay: float):
        """Create phone mockup sliding in from right."""
        phone_width = 3.2
        phone_height = 6.4
        bezel = 0.16
        
        # Phone body
        phone_body = RoundedRectangle(
            width=phone_width, height=phone_height, corner_radius=0.32,
            fill_color=COLORS["dark_text"], fill_opacity=1, stroke_width=0
        )
        
        # Screen
        screen_width = phone_width - 2 * bezel
        screen_height = phone_height - 2 * bezel - 0.6  # Dynamic island
        screen = RoundedRectangle(
            width=screen_width, height=screen_height, corner_radius=0.24,
            fill_color=WHITE, fill_opacity=1, stroke_width=0
        )
        screen.move_to(phone_body.get_center() + UP * 0.3)
        
        # Dynamic island
        island = RoundedRectangle(width=1.4, height=0.28, corner_radius=0.14,
                                fill_color="#0A0A0A", fill_opacity=1, stroke_width=0)
        island.move_to(phone_body.get_top() + DOWN * 0.2)
        
        # Home indicator
        home = RoundedRectangle(width=0.5, height=0.05, corner_radius=0.025,
                              fill_color="#D0D0D0", fill_opacity=1, stroke_width=0)
        home.move_to(phone_body.get_bottom() + UP * 0.3)
        
        phone_group = VGroup(phone_body, screen, island, home)
        phone_group.move_to([4, safe_y_to_manim(CONTENT_CENTER_Y + 100) / 100, 0])
        phone_group.shift(RIGHT * 4).scale(0.8).set_opacity(0)
        
        self.add(phone_group)
        self.phone_group = phone_group
        self.phone_screen = screen
        
        # Animate entrance
        self.wait(delay)
        self.play(
            phone_group.animate.shift(LEFT * 4).scale(1.25).set_opacity(1),
            rate_func=punch_rate_func, run_time=20/30,
        )
    
    def play_app_build(self, delay: float):
        """Animate app UI building on phone screen."""
        screen = self.phone_screen
        screen_center = screen.get_center()
        screen_width = 2.88
        screen_height = 5.6
        
        # Header
        header = Rectangle(width=screen_width, height=0.7, fill_color="#FAFAFA", fill_opacity=1, stroke_width=0)
        header.move_to(screen.get_top() + DOWN * 0.35)
        header_text = Text("Streak", font=FONTS["heading"], font_size=24, color=COLORS["dark_text"], weight="EXTRA_BOLD")
        header_text.move_to(header.get_center() + LEFT * 0.5)
        header_sub = Text("7 day streak! 🔥", font=FONTS["regular"], font_size=13, color=COLORS["code_comment"])
        header_sub.move_to(header.get_center() + LEFT * 0.5 + DOWN * 0.15)
        
        # Habit cards data
        habits = [
            {"icon": "💻", "title": "Coding", "subtitle": "7 day streak • 2h today", "color": COLORS["electric_blue"], "bg": "#E8E0FF", "checked": True},
            {"icon": "💪", "title": "Workout", "subtitle": "3 day streak • 45 min", "color": COLORS["hot_pink"], "bg": "#FFE0E0", "checked": False},
            {"icon": "📚", "title": "Reading", "subtitle": "1 day streak • 20 min", "color": COLORS["mint_green"], "bg": "#E0FFE0", "checked": False},
        ]
        
        card_height = 1.0
        card_gap = 0.2
        start_y = screen.get_top()[1] - 0.7 - 0.2 - card_height/2
        
        habit_cards = VGroup()
        for i, h in enumerate(habits):
            card = self.create_habit_card(screen_width, card_height, h)
            y_pos = start_y - i * (card_height + card_gap)
            card.move_to([screen_center[0], y_pos, 0])
            card.scale(0).set_opacity(0)
            habit_cards.add(card)
            self.add(card)
        
        # Bottom nav
        nav = RoundedRectangle(width=screen_width, height=0.7, corner_radius=0.24,
                              fill_color="#FAFAFA", fill_opacity=1, stroke_color=COLORS["lavender"], stroke_width=0.01)
        nav.move_to(screen.get_bottom() + UP * 0.35)
        
        plus_btn = Circle(radius=0.2, fill_color=COLORS["electric_blue"], fill_opacity=1, stroke_width=0)
        plus_btn.move_to(nav.get_left() + RIGHT * 0.8)
        plus_text = Text("+", font_size=16, color=WHITE).move_to(plus_btn.get_center())
        
        settings_btn = Circle(radius=0.2, fill_color=COLORS["lavender"], fill_opacity=1, stroke_width=0)
        settings_btn.move_to(nav.get_right() + LEFT * 0.8)
        settings_text = Text("⚙", font_size=16, color=COLORS["electric_blue"]).move_to(settings_btn.get_center())
        
        nav_group = VGroup(nav, plus_btn, plus_text, settings_btn, settings_text)
        nav_group.scale(0).set_opacity(0)
        self.add(nav_group)
        
        self.wait(delay)
        
        # Build sequence
        self.play(
            header.animate.scale(1).set_opacity(1),
            header_text.animate.scale(1).set_opacity(1),
            header_sub.animate.scale(1).set_opacity(1),
            rate_func=punch_rate_func, run_time=15/30,
        )
        
        for i, card in enumerate(habit_cards):
            self.wait(get_stagger_delay(i, 5/30, 0.1))
            self.play(
                card.animate.scale(1).set_opacity(1),
                rate_func=punch_rate_func, run_time=15/30,
            )
        
        self.play(nav_group.animate.scale(1).set_opacity(1), rate_func=punch_rate_func, run_time=15/30)
        
        # Sparkles from screen
        self.play_sparkles_from_screen(screen_center)
    
    def create_habit_card(self, width: float, height: float, habit: dict) -> VGroup:
        """Create a habit card for phone screen."""
        card = RoundedRectangle(width=width - 0.32, height=height, corner_radius=0.16,
                               fill_color=WHITE, fill_opacity=1, stroke_color=COLORS["lavender"], stroke_width=0.02)
        
        icon_circle = Circle(radius=0.24, fill_color=habit["bg"], fill_opacity=1, stroke_width=0)
        icon_circle.move_to(card.get_left() + RIGHT * 0.5)
        icon_text = Text(habit["icon"], font_size=20).move_to(icon_circle.get_center())
        
        title = Text(habit["title"], font=FONTS["body"], font_size=18, color=COLORS["dark_text"], weight="SEMI_BOLD")
        title.move_to(card.get_left() + RIGHT * 1.2 + UP * 0.15)
        
        subtitle = Text(habit["subtitle"], font=FONTS["regular"], font_size=13, color=COLORS["code_comment"])
        subtitle.move_to(card.get_left() + RIGHT * 1.2 + DOWN * 0.15)
        
        # Checkbox
        if habit["checked"]:
            checkbox = RoundedRectangle(width=0.3, height=0.3, corner_radius=0.08,
                                      fill_color=COLORS["mint_green"], fill_opacity=1, stroke_width=0)
            check = VMobject()
            check.set_points_as_corners([LEFT*0.08, ORIGIN, RIGHT*0.1+UP*0.1])
            check.set_stroke(WHITE, width=0.03)
            check.move_to(checkbox.get_center())
            checkbox_group = VGroup(checkbox, check)
        else:
            checkbox = RoundedRectangle(width=0.3, height=0.3, corner_radius=0.08,
                                      fill_opacity=0, stroke_color="#E0E0E0", stroke_width=0.02)
            checkbox_group = VGroup(checkbox)
        
        checkbox_group.move_to(card.get_right() + LEFT * 0.4)
        
        return VGroup(card, icon_circle, icon_text, title, subtitle, checkbox_group)
    
    def play_sparkles_from_screen(self, screen_center):
        """Sparkles emitting from phone screen."""
        sparkles = VGroup()
        for i in range(15):
            sparkle = self.create_sparkle(1.2, COLORS["sunny_yellow"])
            angle = i * (2 * PI / 15)
            sparkle.move_to(screen_center)
            sparkle.target = np.array([
                screen_center[0] + np.cos(angle) * 1.5,
                screen_center[1] + np.sin(angle) * 1.5,
                0
            ])
            sparkles.add(sparkle)
        
        self.add(sparkles)
        self.wait(30/30)
        self.remove(sparkles)
    
    def play_camera_push_on_phone(self, delay: float):
        """Camera push on phone area."""
        self.wait(delay)
        self.play_camera_push_in(scale=1.08, duration=30/30)


# For direct rendering
if __name__ == "__main__":
    scene = Step2()
    scene.render()
