# Manim Configuration for Vibe Coder Video
# 9:16 vertical video, 1080x1920, 30fps

from manim import config

# Video configuration
config.frame_width = 1080
config.frame_height = 1920
config.frame_rate = 30
config.pixel_width = 1080
config.pixel_height = 1920

# Quality settings
config.quality = "high_quality"
config.format = "mp4"
config.codec = "h264"
config.bitrate = "8000k"

# Output
config.output_file = "vibe_coder_video"
config.media_dir = "./media"

# Background
config.background_color = "#FAFAFA"

# Disable GUI
config.disable_caching = False
config.write_to_movie = True
config.save_as_gif = False
config.gif_options = {}

# Progress bar
config.progress_bar = "display"

# Logging
config.log_level = "INFO"
config.verbosity = "INFO"

# Transparency
config.transparent = False

# Custom constants
VIDEO_CONFIG = {
    "width": 1080,
    "height": 1920,
    "fps": 30,
    "duration_seconds": 30,
    "total_frames": 900,
    "safe_top": 250,
    "safe_bottom": 400,
    "content_top": 250,
    "content_bottom": 1520,
    "content_height": 1270,
    "center_x": 540,
    "center_y": 960,
    "content_center_y": 885,
}

# Color palette
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
    "code_keyword": "#FF79C6",
    "code_string": "#F1FA8C",
    "code_function": "#8BE9FD",
    "code_variable": "#F8F8F2",
    "error_red": "#FF4444",
    "success_green": "#00E676",
    "white": "#FFFFFF",
    "black": "#000000",
}

# Gradient backgrounds
GRADIENTS = {
    "background": ["#FAFAFA", "#E8E0FF"],
    "vibe_gradient": ["#FF2D92", "#007AFF", "#00E676"],
    "chassis": ["#F0F0F0", "#D0D0D0"],
    "tab_bar": ["#2D2D3A", "#1E1E2E"],
    "card_blue": ["#007AFF", "#0056CC"],
    "card_pink": ["#FF2D92", "#CC1F75"],
    "card_green": ["#00E676", "#00B35E"],
}

# Font settings
FONTS = {
    "heading": "Poppins ExtraBold",
    "body": "Poppins SemiBold",
    "regular": "Poppins Regular",
    "code": "JetBrains Mono",
    "fallback": "DejaVu Sans",
}

# Font sizes (in pixels, converted to Manim units)
FONT_SIZES = {
    "headline": 96,
    "subhead": 72,
    "body": 48,
    "ui": 36,
    "code": 28,
    "caption": 48,
    "small": 24,
}

# Animation timing constants (in frames at 30fps)
TIMING = {
    "text_pop": 12,          # 400ms
    "icon_slide": 15,        # 500ms
    "card_stagger": 4,       # ~133ms
    "typewriter_per_char": 1, # ~33ms
    "camera_push": 24,       # 800ms
    "transition_whoosh": 9,  # 300ms
    "confetti_burst": 18,    # 600ms
    "spring_bounce": 30,     # 1s
    "fade": 15,              # 500ms
}

# Easing curve names
EASING = {
    "punch": "punch",
    "bounce": "bounce",
    "smooth": "smooth",
    "ease_out": "ease_out",
    "spring": "spring",
    "linear": "linear",
}

# Asset paths
ASSET_DIR = "./assets/svg"

# Audio cues (frame numbers at 30fps)
AUDIO_CUES = {
    "riser_start": 0,
    "riser_end": 15,
    "whoosh_transitions": [90, 240, 450, 660, 810],
    "pops": [
        15, 30,      # Hook texts
        96, 105,     # Step 1 header + text
        126, 130, 134,  # Card stack
        246, 255,    # Step 2 header + text
        270, 285, 315, 330, 345,  # Chat, typing, send, phone, build
        456, 465,    # Step 3 header + text
        480, 495, 540, 570,  # Code, error, click, success
        666, 675,    # Step 4 header + text
        690,         # Calendar
        705, 708, 711, 714, 717, 720, 723,  # 7 checkmarks
        816, 826,    # CTA text + vibe coder
        826,         # Arrow
    ],
    "keyboard_clicks": [],  # Generated dynamically
    "success_ding": 570,
    "error_buzz": 495,
    "sparkle_chimes": 345,
    "confetti_rustle": [60, 705],
    "music_start": 90,
    "music_fade_start": 870,
    "music_fade_end": 900,
}

# Voiceover segments (start_frame, end_frame, text)
VOICEOVER = [
    (15, 75, "Think you need a CS degree to build apps?"),
    (75, 84, "Nope."),
    (90, 120, "Welcome to vibe coding."),
    (120, 165, "Step one: pick an AI coding tool."),
    (180, 240, "Step two: describe your idea in plain English."),
    (270, 360, "Step three: run it, spot the bugs, and let AI fix them."),
    (390, 465, "Step four: ship something small every single day."),
    (480, 540, "Do that, and you're a vibe coder."),
    (840, 885, "Follow for more."),
]

# Scene frame ranges
SCENES = {
    "hook": (0, 90),
    "step1": (90, 240),
    "step2": (240, 450),
    "step3": (450, 660),
    "step4": (660, 810),
    "cta": (810, 900),
}
