# Pipes - Progress Log

| Date | Step | Result |
|------|------|--------|
| 2025-01-XX | 1. Recon | Created PROJECT_MAP.md |
| 2025-01-XX | 2. Rules & Log | Created RULES.md, PROGRESS.md |
| 2025-10-22 | 3. Smoke Test | Created test/smoke_test.dart |
| 2025-10-22 | 4. Cleanup Plan | Created CLEANUP_PLAN.md |
| 2025-10-22 | 5. Cleanup Batch 1 | Removed TODO comments (android/app/build.gradle.kts:33, 54), placeholder lint rules (analysis_options.yaml), unused imports (game_view.dart:1, 8, 11). CI green (run #39816746902). |
| 2025-10-22 | 5. Cleanup Batch 2 | Consolidated URL launcher into shared utility (lib/ui/core/url_launcher.dart), removed duplicate _launchUrl/_openUrl methods from home_view.dart, settings_view.dart, game_view.dart. CI green (run #39818847072). |
| 2025-10-22 | 5. Cleanup Batch 3 | Fixed test imports and adapter registration. CI green (run #39819853734). |

| 2025-10-23 | 6. Cleanup Part A | Removed all donation/support UI (Ko-fi badge, Backer dialog, heart button, win dialog Ko-fi link, Liberapay section), deleted .github/FUNDING.yml and .github/workflows/test.yml, kept url_launcher for star button. CI green (run #39899579252). Web: https://soy66957-boop.github.io/Asd/ |

*Update this file after every step.*
