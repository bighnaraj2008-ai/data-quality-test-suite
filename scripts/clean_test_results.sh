#!/usr/bin/env bash
# ============================================================================
# clean_test_results.sh — Clean temporary test artifacts and databases
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

rm -rf "$PROJECT_ROOT/target"
find "$PROJECT_ROOT" -type f -name '*.log' -delete
find "$PROJECT_ROOT" -type f -name '*.db' -delete
find "$PROJECT_ROOT" -type f -name '*.sqlite*' -delete
echo "Cleaned all test outputs."
