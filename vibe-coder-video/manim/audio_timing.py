# Audio timing and cues for Vibe Coder Video
# All times in frames at 30fps (from PRODUCTION_SPEC.md)

from config import VIDEO_CONFIG, AUDIO_CUES, VOICEOVER


# Frame rate
FPS = 30


def frames_to_seconds(frames: int) -> float:
    return frames / FPS


def seconds_to_frames(seconds: float) -> int:
    return round(seconds * FPS)


def frame_to_timecode(frame: int) -> str:
    """Convert frame number to HH:MM:SS:FF timecode."""
    total_seconds = frame / FPS
    hours = int(total_seconds // 3600)
    minutes = int((total_seconds % 3600) // 60)
    seconds = int(total_seconds % 60)
    frames_remainder = frame % FPS
    return f"{hours:02d}:{minutes:02d}:{seconds:02d}:{frames_remainder:02d}"


# Audio cue lookup
def get_audio_cues_at_frame(frame: int) -> list:
    """Get all audio cues that trigger at a specific frame."""
    cues = []
    
    # Riser
    if AUDIO_CUES["riser_start"] <= frame <= AUDIO_CUES["riser_end"]:
        cues.append(("riser", "swell"))
    
    # Whoosh transitions
    if frame in AUDIO_CUES["whoosh_transitions"]:
        cues.append(("whoosh", "transition"))
    
    # Pops
    if frame in AUDIO_CUES["pops"]:
        cues.append(("pop", "entrance"))
    
    # Special SFX
    if frame == AUDIO_CUES["success_ding"]:
        cues.append(("ding", "success"))
    if frame == AUDIO_CUES["error_buzz"]:
        cues.append(("buzz", "error"))
    if frame == AUDIO_CUES["sparkle_chimes"]:
        cues.append(("chime", "sparkle"))
    if frame in AUDIO_CUES["confetti_rustle"]:
        cues.append(("rustle", "confetti"))
    
    # Music
    if frame == AUDIO_CUES["music_start"]:
        cues.append(("music", "start"))
    if frame == AUDIO_CUES["music_fade_start"]:
        cues.append(("music", "fade_start"))
    if frame == AUDIO_CUES["music_fade_end"]:
        cues.append(("music", "fade_end"))
    
    # Voiceover
    for start, end, text in VOICEOVER:
        if start <= frame < end:
            cues.append(("voiceover", text))
            break
    
    return cues


# Voiceover timing map
VOICEOVER_SEGMENTS = {
    "hook_question": {"start": 15, "end": 75, "text": "Think you need a CS degree to build apps?"},
    "hook_nope": {"start": 75, "end": 84, "text": "Nope."},
    "welcome": {"start": 90, "end": 120, "text": "Welcome to vibe coding."},
    "step1": {"start": 120, "end": 165, "text": "Step one: pick an AI coding tool."},
    "step2": {"start": 180, "end": 240, "text": "Step two: describe your idea in plain English."},
    "step3": {"start": 270, "end": 360, "text": "Step three: run it, spot the bugs, and let AI fix them."},
    "step4": {"start": 390, "end": 465, "text": "Step four: ship something small every single day."},
    "vibe_coder": {"start": 480, "end": 540, "text": "Do that, and you're a vibe coder."},
    "cta": {"start": 840, "end": 885, "text": "Follow for more."},
}


# SFX timing map (frame -> (sfx_name, params))
SFX_MAP = {
    # Hook
    0: ("riser", {"duration": 15, "pitch_rise": True}),
    15: ("whoosh", {"intensity": 0.8}),
    15: ("pop", {"pitch": 1.0}),
    30: ("pop", {"pitch": 1.2}),
    45: ("punch", {"low_freq": True}),
    60: ("confetti", {"count": 30, "rustle": True}),
    
    # Transitions
    90: ("whoosh", {"intensity": 1.0}),
    240: ("whoosh", {"intensity": 1.0}),
    450: ("whoosh", {"intensity": 1.0}),
    660: ("whoosh", {"intensity": 1.0}),
    810: ("whoosh", {"intensity": 1.0}),
    
    # Step 1
    96: ("pop", {"pitch": 0.9}),
    105: ("pop", {"pitch": 1.0}),
    126: ("pop", {"pitch": 1.1}),
    130: ("pop", {"pitch": 1.15}),
    134: ("pop", {"pitch": 1.2}),
    
    # Step 2
    246: ("pop", {"pitch": 0.9}),
    255: ("pop", {"pitch": 1.0}),
    270: ("pop", {"pitch": 1.0}),  # Chat box
    285: ("keyboard", {"count": 48, "jitter": True}),  # Typing
    315: ("ding", {"soft": True}),  # Send
    330: ("whoosh", {"short": True}),  # Phone slide
    345: ("pop", {"pitch": 1.1}),  # App build start
    
    # Sparkles at 345
    345: ("sparkle_chime", {"count": 15}),
    
    # Step 3
    456: ("pop", {"pitch": 0.9}),
    465: ("pop", {"pitch": 1.0}),
    480: ("pop", {"pitch": 1.0}),  # Code window
    495: ("buzz", {"low": True}),  # Error
    540: ("click", {"mechanical": True}),  # Fix click
    570: ("ding", {"frequency": 880, "decay": 0.2}),  # Success
    
    # Step 4
    666: ("pop", {"pitch": 0.9}),
    675: ("pop", {"pitch": 1.0}),
    690: ("pop", {"pitch": 1.0}),  # Calendar
    705: ("pop", {"pitch": 1.1, "ascending": True}),  # Checkmark 1
    708: ("pop", {"pitch": 1.15, "ascending": True}),  # Checkmark 2
    711: ("pop", {"pitch": 1.2, "ascending": True}),  # Checkmark 3
    714: ("pop", {"pitch": 1.25, "ascending": True}),  # Checkmark 4
    717: ("pop", {"pitch": 1.3, "ascending": True}),  # Checkmark 5
    720: ("pop", {"pitch": 1.35, "ascending": True}),  # Checkmark 6
    723: ("pop", {"pitch": 1.4, "ascending": True}),  # Checkmark 7
    705: ("confetti", {"mini": True, "count": 5}),  # Per checkmark
    
    # CTA
    816: ("pop", {"pitch": 1.0}),
    826: ("pop", {"pitch": 1.2}),  # "vibe coder"
    826: ("pop", {"pitch": 1.1}),  # Arrow
    
    # Music
    90: ("music", {"action": "start", "bpm": 120}),
    870: ("music", {"action": "fade_out", "duration": 30}),
    900: ("music", {"action": "stop"}),
}


# Keyboard click generator
def generate_keyboard_clicks(start_frame: int, char_count: int, 
                              chars_per_second: float = 33) -> list:
    """Generate keyboard click frames for typing animation."""
    frames_per_char = FPS / chars_per_second
    clicks = []
    for i in range(char_count):
        frame = start_frame + round(i * frames_per_char)
        # Add slight jitter
        import random
        jitter = random.randint(-1, 1)
        clicks.append(frame + jitter)
    return clicks


# Pre-computed keyboard clicks for each typing segment
KEYBOARD_CLICKS = {
    "step1_text": generate_keyboard_clicks(105, 28),  # "Pick an AI coding tool."
    "step2_text": generate_keyboard_clicks(255, 38),  # "Describe your idea in plain English."
    "step2_prompt": generate_keyboard_clicks(285, 48),  # Chat prompt
    "step3_text": generate_keyboard_clicks(465, 35),  # "Run it. Spot bugs. Ask AI to fix."
    "step4_text": generate_keyboard_clicks(675, 30),  # "Ship something small every day."
    "cta_text": generate_keyboard_clicks(816, 32),  # "Follow to become a vibe coder."
}


# Mix levels (dBFS)
MIX_LEVELS = {
    "voiceover": -6,    # Peak
    "music": -24,       # 18dB below voice
    "sfx": -12,         # Momentary peaks
    "master_target": -14,  # LUFS
}

# Loudness normalization
LOUDNESS_TARGET = {
    "integrated": -14,   # LUFS
    "true_peak": -1,     # dBTP
    "lra": 11,           # LU
}


# Audio track durations (frames)
TRACK_DURATIONS = {
    "voiceover": 900,    # Full video
    "music": 810,        # From frame 90 to 900
    "sfx": 900,          # Full video
}


def generate_ffmpeg_mix_command(video_file: str, voiceover_file: str, 
                                 sfx_file: str, music_file: str, 
                                 output_file: str) -> str:
    """Generate FFmpeg command for final audio mix."""
    return f'''ffmpeg -i {video_file} -i {voiceover_file} -i {sfx_file} -i {music_file} \\
  -filter_complex "[1:a]volume=1.0[v];[2:a]volume=0.5[s];[3:a]volume=0.15[m];[v][s][m]amix=inputs=3:duration=first:dropout_transition=2[a]" \\
  -map 0:v -map "[a]" -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k \\
  -af "loudnorm=I=-14:TP=-1:LRA=11" {output_file}'''


# Export all
__all__ = [
    "FPS",
    "frames_to_seconds",
    "seconds_to_frames",
    "frame_to_timecode",
    "get_audio_cues_at_frame",
    "VOICEOVER_SEGMENTS",
    "SFX_MAP",
    "KEYBOARD_CLICKS",
    "MIX_LEVELS",
    "LOUDNESS_TARGET",
    "generate_ffmpeg_mix_command",
]
