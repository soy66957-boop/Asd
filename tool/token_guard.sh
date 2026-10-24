#!/usr/bin/env bash
# tool/token_guard.sh
#
# Scans lib/ui (excluding lib/ui/core/theme) for hard-coded design values that
# should come from tokens instead. Prints file:line for each hit and exits 1
# on any hit.
#
# Patterns scanned:
#   - Color(0x        hard-coded ARGB color literal
#   - Colors.         any Colors.* usage except Colors.transparent
#   - TextStyle(      inline text style
#   - fontSize:       hard-coded font size
#   - BorderRadius.circular( N  hard-coded radius number
#   - EdgeInsets ... N  hard-coded edge inset number
#   - Duration(milliseconds  hard-coded duration
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCAN_DIR="$ROOT/lib/ui"
EXCLUDE_PATTERN="/lib/ui/core/theme/"

if [ ! -d "$SCAN_DIR" ]; then
  echo "token_guard: $SCAN_DIR not found" >&2
  exit 1
fi

ALL_HITS=""

# Run one pattern over the scan dir, excluding theme dir, append file:line hits.
scan() {
  local label="$1"; shift
  local pattern="$1"; shift
  local out
  out=$(grep -r -n -I -E -- "$pattern" "$SCAN_DIR" 2>/dev/null \
    | grep -v "$EXCLUDE_PATTERN" || true)
  if [ -n "$out" ]; then
    while IFS= read -r line; do
      ALL_HITS+="token_guard [$label]: $line"$'\n'
    done <<< "$out"
  fi
}

# 1. Hard-coded ARGB color literal
scan "Color(0x" 'Color\(0x'

# 2. Colors.* usage except Colors.transparent
all_colors=$(grep -r -n -I -E -- 'Colors\.' "$SCAN_DIR" 2>/dev/null \
  | grep -v "$EXCLUDE_PATTERN" || true)
if [ -n "$all_colors" ]; then
  while IFS= read -r line; do
    case "$line" in
      *Colors.transparent*) ;;
      *) ALL_HITS+="token_guard [Colors.]: $line"$'\n' ;;
    esac
  done <<< "$all_colors"
fi

# 3. Inline text style
scan "TextStyle(" 'TextStyle\('

# 4. Hard-coded font size
scan "fontSize:" 'fontSize:'

# 5. Hard-coded radius number
scan "BorderRadius.circular(number)" 'BorderRadius\.circular\([0-9]'

# 6. Hard-coded edge inset number
scan "EdgeInsets(number)" 'EdgeInsets.*[0-9]'

# 7. Hard-coded duration
scan "Duration(milliseconds" 'Duration\(milliseconds'

if [ -n "$ALL_HITS" ]; then
  printf '%s' "$ALL_HITS"
  hits=$(printf '%s' "$ALL_HITS" | grep -c . || true)
  echo "token_guard: $hits violation(s) found" >&2
  exit 1
fi

echo "token_guard: no violations found"
exit 0
