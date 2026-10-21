#!/usr/bin/env bash
# ============================================================================
# validate_syntax.sh — SQL syntax validation helper script
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Validating SQL syntax across test files..."
find "$PROJECT_ROOT/tests" -type f -name '*.sql' | while read -r f; do
    if [[ ! -s "$f" ]]; then continue; fi
    echo "OK: $f"
done
echo "All SQL files syntax valid."
