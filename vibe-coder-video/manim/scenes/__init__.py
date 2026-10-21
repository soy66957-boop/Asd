# Vibe Coder Video - Scenes Package
# Import all scenes for easy access

from scenes.hook import Hook
from scenes.step1 import Step1
from scenes.step2 import Step2
from scenes.step3 import Step3
from scenes.step4 import Step4
from scenes.cta import CTA

__all__ = [
    "Hook",
    "Step1", 
    "Step2",
    "Step3",
    "Step4",
    "CTA",
]

# Scene order for sequential rendering
SCENE_ORDER = [
    ("hook", Hook),
    ("step1", Step1),
    ("step2", Step2),
    ("step3", Step3),
    ("step4", Step4),
    ("cta", CTA),
]

# Scene frame ranges (at 30fps)
SCENE_FRAMES = {
    "hook": (0, 90),
    "step1": (90, 240),
    "step2": (240, 450),
    "step3": (450, 660),
    "step4": (660, 810),
    "cta": (810, 900),
}
