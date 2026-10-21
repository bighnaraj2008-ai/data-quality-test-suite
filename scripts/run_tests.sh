#!/usr/bin/env bash
# ============================================================================
# run_tests.sh — automated pure SQL test suite runner script
# ============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

DB="${DQ_DB:-$PROJECT_ROOT/target/quality.db}"
TESTS_ROOT="${DQ_TESTS_ROOT:-$PROJECT_ROOT/tests}"
ENGINE="${DQ_ENGINE:-sqlite}"

echo "Discovering tests under $TESTS_ROOT..."
