# Pipes design direction: LIQUID NEON MINIMAL
Screen mode: Experience (a game). One signature motion for the whole product: water flowing through neon pipes. Everything else is quiet feedback.

MINIMAL
- One plane plus hairlines (white @ 10%). A card or panel only when raising it means something.
- One accent per screen. Max two font weights per screen. Generous empty space.
- No four identical tiles, no gradient text, no emoji as icons, no stock illustrations.

NEON
- Background near black with a faint hue tint. Accents bright and saturated.
- Glow only on things that are alive: connected pipes, the primary button, the current level. Never on text.
- Glow = the accent at 40% opacity, blur 20, no spread.

LIQUID
- Water moves like liquid: a soft gradient front fills the pipes, springs overshoot and settle, shapes morph between screens, a win sends a wave through the whole network.
- Nothing snaps. Nothing is linear.

COLOR, DARK (default)
- background = hue, 30% sat, 4% light; surface = hue, 26%, 8%; hairline = white @ 10%
- text #EAF2FF; secondary text #93A4BF; idle pipe #5B6E8F
- neon accent = the palette's own hue at 95% sat, 58% light, then ensureContrast >= 3:1 on background
- onAccent = #07090F or white, whichever contrasts more (>= 4.5:1)
COLOR, LIGHT
- background = hue, 40% sat, 97% light; surface = white; hairline = black @ 10%
- text #0F1B2D; secondary text #475569; idle pipe #6B7C99
- accent = the palette's hue, darkened until white text on it is >= 4.5:1 and the accent on background is >= 3:1
RULES FOR BOTH
- text >= 4.5:1, borders and icons >= 3:1, computed by formula for ALL token pairs
- default palette for new installs: the blue/aqua one

SHAPE AND TYPE
- Radius 12 / 20 / pill. Pipes are tubes with round caps. No sharp corners.
- Outfit, bundled in assets/fonts (keep its OFL license file), weights 400 and 600 only. Display style for the title only.
- Icons: one family, one weight (outline/light). No emoji, no unicode arrows.

MOTION
- feedback 120ms, state change 220ms, screen change 420ms. Exit faster than enter.
- Animate only transform and opacity (glow opacity counts as opacity).
- Reduce-motion means LESS motion, not none: keep opacity fades, drop movement and glow pulses.

STATES
- Every tappable element: default, pressed, focused, disabled, loading, selected, error, hover (web).
- Every screen with data: loading (skeleton in the real shape), empty (why + one action), error (what broke + what to do), success.

TEXT
- Buttons are verbs. Zero dashes in visible strings. No invented numbers or names. One voice.

TOKENS
- Three layers: primitive (raw palette numbers) -> semantic (background, surface, text, accent, glow, danger) -> component (button.primary.background, etc.). Screens use only semantic and component tokens.

MENU HERO (phase 5)
- Replace the static image assets/icon.png with a neon glass-tube cross junction drawn in code by the same pipe painter as the board, colored from tokens (water = accent), so it recolors with every palette.
- Idle: floats about 6px over about 3s, sways about 10 degrees side to side and 5 degrees up and down with perspective, a light streak slides along the water, glow pulses slowly.
- Tap: 90 degree spring spin plus a haptic tick. Drag: tilts toward the finger and springs back on release. Three quick taps: shake. Reduce-motion: static.

SOUND (phase 7)
- Short, soft, liquid sounds for tap, rotate, connect, win. CC0 sources only. All through core/audio. On/off switch in Settings. Respect the device's silent mode.
