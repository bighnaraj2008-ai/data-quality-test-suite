#!/usr/bin/env bash
# ============================================================================
# benchmark_tests.sh — performance benchmarking script
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Benchmarking test suite execution latency..."
START=$(date +%s)
bash "$SCRIPT_DIR/run_tests.sh" --seed --quiet
END=$(date +%s)
echo "Execution time: $((END - START)) seconds"
