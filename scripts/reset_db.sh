#!/usr/bin/env bash
# ============================================================================
# reset_db.sh — database reset and re-seeding utility script
# ============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DB="${1:-$PROJECT_ROOT/target/quality.db}"
SEED_FILE="$PROJECT_ROOT/tests/seed_test_data.sql"

echo "Resetting database: $DB"
mkdir -p "$(dirname "$DB")"
rm -f "$DB"

if command -v sqlite3 >/dev/null 2>&1; then
    sqlite3 "$DB" < "$SEED_FILE"
elif command -v python >/dev/null 2>&1; then
    python -c "import sqlite3; conn=sqlite3.connect('$DB'); conn.executescript(open('$SEED_FILE', 'r', encoding='utf-8').read()); conn.commit(); conn.close()"
elif command -v python3 >/dev/null 2>&1; then
    python3 -c "import sqlite3; conn=sqlite3.connect('$DB'); conn.executescript(open('$SEED_FILE', 'r', encoding='utf-8').read()); conn.commit(); conn.close()"
fi

echo "Database reset complete."
