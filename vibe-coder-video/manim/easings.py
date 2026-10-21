# Custom easing functions for Manim
# Matches PRODUCTION_SPEC.md exactly

import numpy as np
from manim import *


def cubic_bezier(t: float, p1x: float, p1y: float, p2x: float, p2y: float) -> float:
    """Evaluate cubic bezier at parameter t."""
    # Solve for t given x using Newton's method
    cx = 3 * p1x
    bx = 3 * (p2x - p1x) - cx
    ax = 1 - cx - bx
    
    cy = 3 * p1y
    by = 3 * (p2y - p1y) - cy
    ay = 1 - cy - by
    
    # Newton-Raphson to find t for given x
    t_guess = t
    for _ in range(8):
        x_guess = ((ax * t_guess + bx) * t_guess + cx) * t_guess
        dx = (3 * ax * t_guess + 2 * bx) * t_guess + cx
        if dx == 0:
            break
        t_guess -= (x_guess - t) / dx
        t_guess = max(0, min(1, t_guess))
    
    return ((ay * t_guess + by) * t_guess + cy) * t_guess


# Easing curves from spec
def punch(t: float) -> float:
    """cubic-bezier(0.34, 1.56, 0.64, 1) - zoom punch-ins, confetti pops"""
    return cubic_bezier(t, 0.34, 1.56, 0.64, 1)


def bounce(t: float) -> float:
    """cubic-bezier(0.68, -0.55, 0.27, 1.55) - text entrances, icon slides"""
    return cubic_bezier(t, 0.68, -0.55, 0.27, 1.55)


def smooth(t: float) -> float:
    """cubic-bezier(0.25, 0.46, 0.45, 0.94) - parallax, camera push"""
    return cubic_bezier(t, 0.25, 0.46, 0.45, 0.94)


def ease_out(t: float) -> float:
    """cubic-bezier(0.16, 1, 0.3, 1) - exits, fades"""
    return cubic_bezier(t, 0.16, 1, 0.3, 1)


def spring(t: float, stiffness: float = 1, damping: float = 80, mass: float = 10) -> float:
    """Spring physics simulation for bounce with overshoot."""
    omega = np.sqrt(stiffness / mass)
    zeta = damping / (2 * np.sqrt(stiffness * mass))
    
    if zeta < 1:
        # Underdamped - oscillates
        omega_d = omega * np.sqrt(1 - zeta * zeta)
        envelope = np.exp(-zeta * omega * t)
        oscillation = np.cos(omega_d * t) + (zeta / np.sqrt(1 - zeta * zeta)) * np.sin(omega_d * t)
        return 1 - envelope * oscillation
    else:
        # Overdamped
        return 1 - np.exp(-omega * t)


def spring_with_overshoot(t: float, overshoot: float = 0.15) -> float:
    """Spring that overshoots and settles."""
    val = spring(t)
    if val > 1 - overshoot:
        return 1 + (val - (1 - overshoot)) / overshoot * overshoot
    return val


def linear(t: float) -> float:
    """Linear interpolation."""
    return t


def ease_in_out(t: float) -> float:
    """Standard ease in-out."""
    return 3 * t * t - 2 * t * t * t


# Manim rate_func wrappers
def punch_rate_func(t: float) -> float:
    return punch(t)


def bounce_rate_func(t: float) -> float:
    return bounce(t)


def smooth_rate_func(t: float) -> float:
    return smooth(t)


def ease_out_rate_func(t: float) -> float:
    return ease_out(t)


def spring_rate_func(t: float) -> float:
    return spring(t)


def spring_overshoot_rate_func(t: float) -> float:
    return spring_with_overshoot(t)


# Stagger helper
def get_stagger_delay(index: int, base_delay: float = 4/30, jitter: float = 0.15) -> float:
    """Get delay for staggered animation with slight randomness."""
    import random
    jitter_amount = (random.random() - 0.5) * 2 * jitter * base_delay
    return base_delay + index * (base_delay + jitter_amount)


# Motion blur helper
def get_motion_blur(velocity: float, max_blur: float = 20) -> float:
    """Calculate motion blur amount based on velocity (pixels/frame)."""
    threshold = 800 / 30  # px/frame at 30fps
    if velocity < threshold:
        return 0
    return min(max_blur, (velocity - threshold) / 3.33)


# Parallax helper
def get_parallax_offset(foreground_offset: float, factor: float = 0.1) -> float:
    """Background moves at fraction of foreground speed."""
    return foreground_offset * factor


# Hand-placed offset
def get_hand_offset(max_offset: float = 4) -> tuple:
    """Random micro-offset for human feel."""
    import random
    return (
        (random.random() - 0.5) * 2 * max_offset,
        (random.random() - 0.5) * 2 * max_offset,
    )


# Overshoot scale
def with_overshoot(progress: float, overshoot: float = 0.15) -> float:
    """Scale with overshoot effect."""
    if progress >= 1:
        return 1
    eased = punch(progress)
    if eased > 1:
        return 1 + (eased - 1) * overshoot
    return eased


# Export all as dict for easy access
EASING_FUNCTIONS = {
    "punch": punch,
    "bounce": bounce,
    "smooth": smooth,
    "ease_out": ease_out,
    "spring": spring,
    "spring_overshoot": spring_with_overshoot,
    "linear": linear,
    "ease_in_out": ease_in_out,
}

RATE_FUNCS = {
    "punch": punch_rate_func,
    "bounce": bounce_rate_func,
    "smooth": smooth_rate_func,
    "ease_out": ease_out_rate_func,
    "spring": spring_rate_func,
    "spring_overshoot": spring_overshoot_rate_func,
}
