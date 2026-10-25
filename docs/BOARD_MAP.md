# Board Map — Phase 5A Recon

This document maps the files, data flow, and logic hooks for the game board. No logic changes are made here.

---

## 1. Files that draw and handle the board

| File | Role |
|------|------|
| `lib/ui/core/widgets/pipe_widget.dart` | Contains `PipePainter` (CustomPainter), `PipeGameBoard`, `PipeTile`, `PipeWidget`, `PipeLogoWidget`. All drawing logic lives here. |
| `lib/ui/features/game/views/game_view.dart` | ConsumerStatefulWidget. Holds `_GameViewState` with `_shakeController`, `_shockwaveController`. Renders `PipeGameBoard` inside a `RepaintBoundary`. Handles win flow (confetti, shockwave, dialog). Calls `ref.read(gameViewModelProvider.notifier).rotateTile(r, c)` on tap. |
| `lib/ui/features/game/view_models/game_view_model.dart` | `GameViewModel` (Riverpod Notifier). Owns `GameViewModelState` (board, waterFlow, isComplete, moveCount, elapsedSeconds, hintsRemaining, etc.). Rotates tiles, computes water flow via `PipeRules.computeWaterFlow`, checks `PipeRules.isComplete`, manages timer, persists progress. |

---

## 2. Tile kinds and rotation storage

- **Mask encoding** (4-bit): bit 0 = North, 1 = East, 2 = South, 3 = West.
- **Base kinds** (from `PipeRulesHelper.getBaseMask`):
  - `0` = empty (unused)
  - `1,2,4,8` = end cap (1 open side)
  - `5,10` = straight (2 opposite sides): 5 = N+S, 10 = E+W
  - `3,6,12,9` = corner (2 adjacent sides): 3 = N+E, 6 = E+S, 12 = S+W, 9 = W+N
  - `7,14,13,11` = T-junction (3 sides)
  - `15` = cross / source (4 sides)
- **Rotation**: stored as `0..3` (0 = 0°, 1 = 90°, 2 = 180°, 3 = 270° CW). `PipeRules.rotateCw(mask)` rotates mask 90° CW. The board stores the **already-rotated mask** directly in `state.board[r][c]`. `GameViewModel.rotateTile` does `board[r][c] = PipeRules.rotateCw(board[r][c])`.

---

## 3. Logic exposes

| Need | Exposed via |
|------|-------------|
| (a) Each tile's open sides | `board[r][c]` — the 4-bit mask after rotation. `PipeRules` helpers: bit checks `(mask & 1) != 0` for N, etc. |
| (b) Which tiles are connected to source | `waterFlow[r][c]` — `List<List<bool>>` from `PipeRules.computeWaterFlow(board, sourceRow, sourceCol)`. `true` = water reaches this tile. |
| (c) Solved state | `PipeRules.isComplete(board, level)` — returns `true` iff every tile has water AND all open sides connect to a neighbor (or board edge for source). `GameViewModelState.isComplete` mirrors this. |

---

## 4. Tap → logic flow

1. `GameView` builds `PipeGameBoard` with `onTileTap: (r, c) => ref.read(gameViewModelProvider.notifier).rotateTile(r, c)`.
2. `GameViewModel.rotateTile(r, c)`:
   - Increments `moveCount`
   - Rotates `board[r][c]` via `PipeRules.rotateCw`
   - Recomputes `waterFlow = PipeRules.computeWaterFlow(board, sourceRow, sourceCol)`
   - Checks `PipeRules.isComplete`; if true sets `isComplete = true`, triggers `_startWinSequence()`
   - Calls `_persistInProgress()`

---

## 5. Current drawing approach

`PipePainter` (CustomPainter) draws per-tile:
- Background rect (surface color)
- Tube paths via `Path`:
  - Straight: `moveTo` center of one side → `lineTo` center of opposite side
  - Corner: `arcTo` quarter circle (radius = `size * 0.5 - tubeWidth/2`)
  - T / cross: straight arms + center circle
  - End cap: straight line to center + circle bulb
  - Source (mask 15): cross + pulsing ring
- Paint layers:
  1. Tube body: stroke, `pipeIdle` color, round caps/joins
  2. Highlight: thin white stroke offset top-left
  3. Water core: `activeColor` (accent), drawn only if `hasWater`, using `PathMetric.extractPath(0, progress * length)`
  4. Glow: three wider strokes with `MaskFilter.blur` (BlurStyle.normal, 8–16)
  5. Source ring: accent ring + core pulse animation

**Performance notes**: `MaskFilter.blur` and `saveLayer` used inside paint loop. No `RepaintBoundary` per tile (only board-level). One `AnimationController` per tile for water fill (created in `PipeTile` via `PipeWidget`? No — currently `PipeWidget` is stateless; water progress is not animated, it's instant `hasWater` boolean).

---

## 6. Win flow and exact timing (from `game_view.dart`)

```dart
void _startWinSequence() {
  _shockwaveController.forward();        // 220ms (state token)
  await Future.delayed(Duration(milliseconds: 300));
  _confettiController.forward();         // celebration token (3000ms)
  await Future.delayed(Duration(milliseconds: 500));
  if (mounted) _showVictoryDialog();     // dialog appears ~800ms after win
  await completeLevel();                 // persist
}
```

- **Shockwave**: `VictoryShockwavePainter` — expanding ring from source, `MaskFilter.blur(8)`, 220ms.
- **Confetti**: `ConfettiPainter` — 50 particles, 3000ms.
- **Dialog**: `showDialog` with `PipesSurface`, appears after 500ms additional delay (total ~1020ms from win detection).

---

## 7. Logic gaps for the painter

The painter needs the following that are **not** currently exposed by the logic layer:

| Needed by painter | Available? | Notes |
|-------------------|------------|-------|
| Per-tile fill progress (0.0–1.0) for water front animation | ❌ | Only boolean `hasWater` from `waterFlow`. Need continuous progress per tile. |
| Per-tile rotation animation progress (spring) | ❌ | Logic rotates instantly; visual rotation must spring from old angle to new. |
| Per-tile "visually connected" flag (logic connected AND not rotating) | ❌ | Must be derived in UI: `waterFlow[r][c] && !isRotating[r][c]`. |
| Distance from source (BFS order) for fill stagger / win wave | ❌ | `waterFlow` is boolean; no distance. Need `flow_order.dart` pure function. |
| Entry side per tile (which side water enters from) | ❌ | Needed to draw water core from correct entry point. |

**Do not change logic.** The shared painter (Step 3) will compute these from the existing `board` + `waterFlow` + `level` data.
