#!/usr/bin/env bash
# tool/token_guard_selftest.sh
#
# Proves the token guard can fail on a planted error, then passes when clean.
# Temporarily plants the fixture violation into lib/ui (outside theme), runs the
# guard (expects exit 1), removes the plant, runs the guard again (expects exit 0).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GUARD="$ROOT/tool/token_guard.sh"
FIXTURE="$ROOT/tool/fixtures/violation.txt"
PLANT="$ROOT/lib/ui/_token_guard_selftest_plant.dart"

fail=0

cleanup() {
  rm -f "$PLANT"
}
trap cleanup EXIT

echo "=== self-test: planted violation must make the guard fail ==="
cp "$FIXTURE" "$PLANT"
# The fixture has a .txt extension; the guard greps all files under lib/ui,
# so a .dart plant matches Color(0x. Rename content into a .dart plant.
if ! bash "$GUARD" >/dev/null 2>&1; then
  echo "PASS: guard failed (exit != 0) on planted violation"
else
  echo "FAIL: guard did not fail on planted violation"
  fail=1
fi

cleanup

echo "=== self-test: clean lib/ui must make the guard pass ==="
if bash "$GUARD" >/dev/null 2>&1; then
  echo "PASS: guard passed (exit 0) on clean lib/ui"
else
  echo "FAIL: guard failed on clean lib/ui"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "SELFTEST: PASS"
  exit 0
else
  echo "SELFTEST: FAIL"
  exit 1
fi
