# Pipes - Development Rules

These rules are mandatory for all modernization work. Violations block merge.

---

## 1. Token-First Design
All colors, text sizes, spacing, radii, and animation durations come from `core/tokens` (ThemeExtension). No hard-coded values in screens or widgets.

## 2. Shared Components Only
Screens use only `core/ui` components (Button, Card, IconButton, Scaffold, Sheet). Never raw `MaterialButton`, `Card`, `Container` with decoration, or `InkWell` directly.

## 3. Centralized Audio & Haptics
Every sound and haptic goes through `core/audio` service using named events: `tap`, `rotate`, `connect`, `win`. Screens never call a player directly.

## 4. Game Logic Immutable
`game/logic` (`lib/domain/use_cases/pipe_rules.dart`, `level_generator.dart`) is not touched unless explicitly asked. No refactors, no "cleanup" there.

## 5. Accessibility & Motion
- Dark theme first. Light theme derived.
- Text contrast ≥ 4.5:1 (WCAG AA).
- Respect `MediaQuery.of(context).disableAnimations` (system reduce-motion). All non-essential animation must opt out when true.

## 6. One Phase Per Session
- Plan first, then small edits.
- Push each batch and wait for a green CI run (analyze + test + APK + web).
- No bundling multiple phases in one PR.

## 7. Proof Required
Never claim something works without a green CI run. Show real output (run URL, artifact name, log excerpt).

---

## Enforcement
- CI `analyze` job enforces `flutter_lints` + these conventions via custom lints (to be added in Phase 2).
- Code review checks for violations.
- Any violation = request changes, no exceptions.

## 8. No Local Flutter/Dart
Never download, install, or run a local Flutter or Dart SDK. The official arm64 binaries cannot run on Android. CI on GitHub is the ONLY compiler and test runner. To see test failures, read the CI job log through the GitHub API.
