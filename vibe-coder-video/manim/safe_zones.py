# Safe zone utilities for TikTok/Reels 9:16 video
# From PRODUCTION_SPEC.md

from manim import *


# Video dimensions
WIDTH = 1080
HEIGHT = 1920

# Safe zones (keep critical content within these bounds)
TOP_SAFE = 250      # px from top
BOTTOM_SAFE = 400   # px from bottom

# Effective content area
CONTENT_TOP = 250
CONTENT_BOTTOM = 1520  # 1920 - 400
CONTENT_HEIGHT = 1270  # 1520 - 250
CONTENT_LEFT = 50
CONTENT_RIGHT = 1030   # 1080 - 50
CONTENT_WIDTH = 980    # 1030 - 50

# Center points
CENTER_X = 540
CENTER_Y = 960
CONTENT_CENTER_Y = 885  # (250 + 1520) / 2


def clamp_to_safe_zone(y: float, element_height: float = 0) -> float:
    """Clamp Y position to stay within safe zone."""
    min_y = CONTENT_TOP + element_height / 2
    max_y = CONTENT_BOTTOM - element_height / 2
    return max(min_y, min(max_y, y))


def get_safe_center_y(element_height: float) -> float:
    """Get safe Y position for vertically centered element."""
    return CONTENT_CENTER_Y


def is_in_safe_zone(y: float, height: float) -> bool:
    """Check if element is fully within safe zone."""
    return y - height/2 >= CONTENT_TOP and y + height/2 <= CONTENT_BOTTOM


def get_hand_offset(max_offset: float = 4) -> tuple:
    """Get random offset for human-placed feel."""
    import random
    return (
        (random.random() - 0.5) * 2 * max_offset,
        (random.random() - 0.5) * 2 * max_offset,
    )


def get_parallax_offset(foreground_offset: float, factor: float = 0.1) -> float:
    """Background parallax offset."""
    return foreground_offset * factor


# Manim coordinate helpers
def to_manim_coords(x: float, y: float) -> np.ndarray:
    """Convert pixel coordinates (top-left origin) to Manim coordinates (center origin)."""
    return np.array([
        (x - WIDTH / 2) / 100,   # Manim units (1 unit = 100px)
        (HEIGHT / 2 - y) / 100,  # Y flipped
        0
    ])


def from_manim_coords(point: np.ndarray) -> tuple:
    """Convert Manim coordinates to pixel coordinates."""
    return (
        point[0] * 100 + WIDTH / 2,
        HEIGHT / 2 - point[1] * 100
    )


def safe_y_to_manim(y: float, element_height: float = 0) -> float:
    """Convert safe pixel Y to Manim Y coordinate."""
    safe_y = clamp_to_safe_zone(y, element_height)
    return (HEIGHT / 2 - safe_y) / 100


def manim_y_to_safe_y(manim_y: float) -> float:
    """Convert Manim Y to safe pixel Y."""
    return HEIGHT / 2 - manim_y * 100


# Safe zone boundaries as Manim coordinates
SAFE_TOP_MANIM = (HEIGHT / 2 - CONTENT_TOP) / 100
SAFE_BOTTOM_MANIM = (HEIGHT / 2 - CONTENT_BOTTOM) / 100
SAFE_LEFT_MANIM = (CONTENT_LEFT - WIDTH / 2) / 100
SAFE_RIGHT_MANIM = (CONTENT_RIGHT - WIDTH / 2) / 100


def create_safe_zone_rectangle() -> Rectangle:
    """Create a rectangle showing the safe zone for debugging."""
    return Rectangle(
        width=CONTENT_WIDTH / 100,
        height=CONTENT_HEIGHT / 100,
        stroke_color=RED,
        stroke_width=2,
        fill_opacity=0,
    ).move_to(np.array([0, (SAFE_TOP_MANIM + SAFE_BOTTOM_MANIM) / 2, 0]))


# Text positioning helpers
def get_caption_y() -> float:
    """Y position for burned-in captions (above bottom safe zone)."""
    return safe_y_to_manim(CONTENT_BOTTOM - 200)


def get_headline_y() -> float:
    """Y position for main headlines (centered in content area)."""
    return safe_y_to_manim(CONTENT_CENTER_Y)


def get_subhead_y(offset: float = 0) -> float:
    """Y position for subheadlines."""
    return safe_y_to_manim(CONTENT_CENTER_Y + offset)


# Font size to Manim scale conversion
def font_size_to_scale(font_size_px: float) -> float:
    """Convert pixel font size to Manim Text scale."""
    # Manim default font size ~48px at scale=1
    return font_size_px / 48


# Default font sizes in Manim scale
MANIM_FONT_SIZES = {
    "headline": font_size_to_scale(96),    # ~2.0
    "subhead": font_size_to_scale(72),     # ~1.5
    "body": font_size_to_scale(48),        # ~1.0
    "ui": font_size_to_scale(36),          # ~0.75
    "code": font_size_to_scale(28),        # ~0.58
    "caption": font_size_to_scale(48),     # ~1.0
    "small": font_size_to_scale(24),       # ~0.5
}
