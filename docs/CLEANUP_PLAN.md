# Pipes - Cleanup Plan

Each item: file, line, what, why safe to remove.

---

## Safe to Remove (Auto-approve)

| # | File | Line | What | Why Safe |
|---|------|------|------|----------|
| 1 | `android/app/build.gradle.kts` | 33-34 | `TODO: Specify your own unique Application ID` comment | Boilerplate comment, app ID already set |
| 2 | `android/app/build.gradle.kts` | 54-55 | `TODO: Add your own signing config for the release build` comment | Boilerplate comment, signing config exists |
| 3 | `lib/ui/core/widgets/pipe_widget.dart` | 625-644 | `ConfettiPainter` class | Unused - no confetti trigger in game_view.dart |
| 4 | `lib/ui/core/widgets/pipe_widget.dart` | 646-687 | `VictoryShockwavePainter` class | Unused - game_view has its own shockwave (lines 300-330) |
| 5 | `lib/ui/features/game/views/game_view.dart` | 20-21 | `import 'dart:math' as math;` | Unused import (math not used in file) |
| 6 | `lib/ui/features/game/views/game_view.dart` | 11 | `import 'package:url_launcher/url_launcher.dart';` | Unused import |
| 7 | `lib/ui/features/game/views/game_view.dart` | 9 | `import 'package:pipes/ui/core/widgets/tangible_button.dart';` | Unused import (TangibleButton not used in game_view) |
| 8 | `lib/ui/features/home/views/home_view.dart` | 11 | `import 'package:pipes/ui/features/game/views/game_view.dart';` | Used only in type annotation, can be removed if not instantiating |
| 9 | `lib/ui/features/home/views/home_view.dart` | 27-32 | `_launchUrl` method | Duplicated in settings_view.dart and how_to_play_view.dart (3 copies) |
| 10 | `lib/ui/features/settings/views/settings_view.dart` | 329-340 | `_openUrl` method | Duplicated in home_view.dart and how_to_play_view.dart |
| 11 | `lib/ui/features/how_to_play/views/how_to_play_view.dart` | - | No URL launcher usage | Can remove url_launcher import if not used |
| 12 | `analysis_options.yaml` | 34-35 | Commented lint rules (`avoid_print`, `prefer_single_quotes`) | Placeholder comments, not active |

---

## Needs My Decision

| # | File | Line | What | Question |
|---|------|------|------|----------|
| A | `README.md` | 9 | Ko-fi badge/button (`<a href='https://ko-fi.com/M4M01C1R6J'...`) | Plain link to developer page. Remove? |
| B | `lib/ui/features/home/views/home_view.dart` | 193 | Ko-fi link in "Become a Backer" dialog (`https://ko-fi.com/sidhant947`) | Button in dialog. Remove dialog entirely or just the link? |
| C | `lib/ui/features/game/views/game_view.dart` | 467 | Ko-fi link in win dialog (`https://ko-fi.com/sidhant947`) | Button in win dialog. Remove? |
| D | `lib/ui/features/settings/views/settings_view.dart` | 158 | Liberapay donate link (`https://liberapay.com/sidhant947/donate`) | "Support the Developer" section. Remove entire section? |
| E | `.github/FUNDING.yml` | 3-15 | All funding platform entries (Ko-fi, Liberapay, etc.) | GitHub-native funding config. Keep or remove? |
| F | `.github/workflows/test.yml` | - | Entire workflow (manual build with keystore secrets) | Dev-only release build workflow. Delete? |
| G | `fastlane/` | - | Entire directory (Play Store metadata) | Store deployment config. Keep for releases? |

---

## Never Delete (Protected)

- `LICENSE` / credits / attribution
- `lib/domain/use_cases/pipe_rules.dart` (game logic)
- `lib/domain/use_cases/level_generator.dart` (game logic)
- `lib/domain/models/game_level.dart`
- `lib/domain/models/user_progress.dart`
- `lib/domain/models/app_settings.dart`
- `lib/data/services/hive_service.dart`
- `lib/data/services/settings_service.dart`
- `lib/data/services/user_progress_adapter.dart`
- `lib/data/repositories/progress_repository.dart`
- Audio assets (none exist yet)
- `.github/workflows/build.yml` (our CI)
- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`
- `android/` (except the two TODO comments above)
- Any file gameplay needs
