# Pipes - Project Map

## Folder Tree (2 levels)

```
Pipes/
├── .github/
│   └── workflows/
│       └── build.yml          # CI: analyze, test, APK, web
├── android/
│   ├── app/
│   │   ├── build.gradle.kts
│   │   └── src/
│   │       ├── debug/AndroidManifest.xml
│   │       ├── main/
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── kotlin/com/sidhant/pipes/MainActivity.kt
│   │       │   ├── res/
│   │       │   │   ├── drawable-v21/launch_background.xml
│   │       │   │   ├── drawable/launch_background.xml
│   │       │   │   ├── mipmap-anydpi-v26/ic_launcher.xml
│   │       │   │   ├── values-night/styles.xml
│   │       │   │   └── values/styles.xml
│   │       └── profile/AndroidManifest.xml
│   ├── build.gradle.kts
│   └── settings.gradle.kts
├── assets/
│   └── icon.png               # App icon
├── lib/
│   ├── main.dart              # App entry, providers, theme init
│   ├── data/
│   │   ├── repositories/
│   │   │   └── progress_repository.dart
│   │   └── services/
│   │       ├── hive_service.dart
│   │       ├── settings_service.dart
│   │       └── user_progress_adapter.dart
│   ├── domain/
│   │   ├── models/
│   │   │   ├── app_settings.dart      # AppThemePreset, AppSettings
│   │   │   ├── game_level.dart        # GameLevel model
│   │   │   └── user_progress.dart     # UserProgress model
│   │   └── use_cases/
│   │       ├── level_generator.dart   # Level generation (do not touch)
│   │       └── pipe_rules.dart        # Pipe rotation, connectivity (do not touch)
│   └── ui/
│       ├── core/
│       │   ├── theme/
│       │   │   ├── app_colors.dart    # AppColors, GameColors, theme presets
│       │   │   └── app_theme.dart     # ThemeData builder, no-transition pages
│       │   └── widgets/
│       │       ├── pipe_widget.dart   # PipePainter, PipeWidget, PipeGameBoard
│       │       └── tangible_button.dart
│       ├── features/
│       │   ├── home/
│       │   │   ├── view_models/home_view_model.dart
│       │   │   └── views/home_view.dart
│       │   ├── game/
│       │   │   ├── view_models/game_view_model.dart
│       │   │   └── views/game_view.dart
│       │   ├── how_to_play/
│       │   │   └── views/how_to_play_view.dart
│       │   ├── level_select/
│       │   │   └── views/level_select_view.dart
│       │   └── settings/
│       │       ├── view_models/settings_view_model.dart
│       │       └── views/settings_view.dart
│       └── providers.dart             # Riverpod providers
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── LICENSE
├── README.md
└── AI-DECLARATION.md
```

## Key Locations

| Category | Location |
|----------|----------|
| **Screens** | `lib/ui/features/*/views/` |
| **Theme/Colors** | `lib/ui/core/theme/app_colors.dart`, `lib/ui/core/theme/app_theme.dart` |
| **Game Logic** | `lib/domain/use_cases/pipe_rules.dart`, `lib/domain/use_cases/level_generator.dart` |
| **Game Models** | `lib/domain/models/game_level.dart`, `lib/domain/models/user_progress.dart` |
| **Assets** | `assets/icon.png` (only asset) |
| **Audio** | None (no sound files, no audio dependencies) |
| **Storage** | Hive boxes: `pipes_settings`, `pipes_user_progress` via `lib/data/services/hive_service.dart`, `settings_service.dart` |

## Plugins Used (from pubspec.yaml)

| Plugin | Version | Purpose |
|--------|---------|---------|
| flutter_riverpod | ^2.5.1 | State management |
| hive | ^2.2.3 | Local storage (key-value) |
| hive_flutter | ^1.1.0 | Hive Flutter integration |
| url_launcher | ^6.3.3 | External links (Ko-fi, etc.) |
| cupertino_icons | ^1.0.8 | iOS icons |
| flutter_lints | ^6.0.0 | Linting (dev) |

## Existing Sound Code / Audio Assets

**None found.** The project has:
- No audio dependencies (audioplayers, just_audio, etc.)
- No sound files in assets/
- No audio service or sound-related code
- Haptic feedback only via `HapticFeedback.selectionClick()` and `HapticFeedback.lightImpact()` in UI widgets
