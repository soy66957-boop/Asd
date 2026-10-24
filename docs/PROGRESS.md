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

| 2026-10-24 | Step 3 | Skill Gate installed; docs/DESIGN.md created; rules 9-15 appended to docs/RULES.md; antislop + antislop-human skills installed under docs/skills/ with REGISTRY.md and SOURCES.md |
| 2026-10-24 | Step 4 | Tokens restructured into primitive/semantic/component layers; DESIGN.md color rules applied to all 9 palettes (dark & light); glowColor (accent @ 40%) + glowBlur (20) added; motion renamed feedback/state/screen = 120/220/420ms; contrast tests added (text pairs on background & surface, onAccent on accent); Play button label uses onAccent; CI green (run #40085246813) |
| 2026-10-24 | Step 5 | tool/token_guard.sh created scanning lib/ui (excl. theme); tool/fixtures/violation.txt + tool/token_guard_selftest.sh (PASS: fails on plant, passes clean); guard wired into analyze job before tests; lib/ui guard hits before=30 after=0; CI green (run #40088022282) |
