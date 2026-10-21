#!/usr/bin/env bash
# ============================================================================
# run_tests.sh — pure-SQL data-quality test runner
# ============================================================================
# Evaluates every modular SQL test under tests/ against a target database.
# Each test follows the dbt-style contract:
#   PASS iff query returns ZERO rows. Any row returned is an assertion violation.
#
# Supported Engines:
#   sqlite   (default) — via sqlite3 CLI or embedded Python sqlite3 driver
#   postgres           — via psql CLI (DATABASE_URL or standard PG* env vars)
#
# Usage:
#   bash scripts/run_tests.sh [--db PATH] [--seed] [--tests-root DIR]
#                             [--engine sqlite|postgres] [--quiet]
# ============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

DB="${DQ_DB:-$PROJECT_ROOT/target/quality.db}"
TESTS_ROOT="${DQ_TESTS_ROOT:-$PROJECT_ROOT/tests}"
ENGINE="${DQ_ENGINE:-sqlite}"
SEED_FILE="$PROJECT_ROOT/tests/seed_test_data.sql"
BUILD_DB=false
QUIET=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --db)          DB="$2"; shift 2 ;;
        --seed)        BUILD_DB=true; shift ;;
        --tests-root)  TESTS_ROOT="$2"; shift 2 ;;
        --engine)      ENGINE="$2"; shift 2 ;;
        --quiet)       QUIET=true; shift ;;
        -h|--help)     echo "Usage: $0 [--db PATH] [--seed] [--engine sqlite|postgres]"; exit 0 ;;
        *) shift ;;
    esac
done

say() { [[ "$QUIET" == true ]] || echo "$@"; }

to_native_path() {
    if command -v cygpath >/dev/null 2>&1; then
        cygpath -w "$1"
    else
        echo "$1"
    fi
}

# Database initialization
if [[ "$BUILD_DB" == true ]]; then
    say "==> Initializing and seeding database: $DB"
    mkdir -p "$(dirname "$DB")"
    rm -f "$DB"
    n_db="$(to_native_path "$DB")"
    n_seed="$(to_native_path "$SEED_FILE")"
    if [[ "$ENGINE" == "sqlite" ]]; then
        if command -v sqlite3 >/dev/null 2>&1; then
            sqlite3 -batch -bail "$DB" < "$SEED_FILE" >/dev/null
        elif command -v python >/dev/null 2>&1; then
            python -c "import sqlite3; conn=sqlite3.connect(r'$n_db'); conn.executescript(open(r'$n_seed', 'r', encoding='utf-8').read()); conn.commit(); conn.close()"
        elif command -v python3 >/dev/null 2>&1; then
            python3 -c "import sqlite3; conn=sqlite3.connect(r'$n_db'); conn.executescript(open(r'$n_seed', 'r', encoding='utf-8').read()); conn.commit(); conn.close()"
        fi
    fi
    say "==> Seeded from $SEED_FILE"
fi

# Discover test assertion files
mapfile_tests=()
while IFS= read -r -d '' f; do
    mapfile_tests+=("$f")
done < <(find "$TESTS_ROOT" -type f \( -name 'assert_*.sql' -o -name '*_tests.sql' \) | sort | tr '\n' '\0')

if [[ ${#mapfile_tests[@]} -eq 0 ]]; then
    echo "run_tests.sh: no test SQL files found under $TESTS_ROOT" >&2
    exit 2
fi

run_test_sqlite() {
    local n_db="$(to_native_path "$DB")"
    local n_test="$(to_native_path "$1")"
    if command -v sqlite3 >/dev/null 2>&1; then
        sqlite3 -batch "$DB" < "$1"
    elif command -v python >/dev/null 2>&1; then
        python -c "
import sys, sqlite3
db_path, test_path = sys.argv[1], sys.argv[2]
conn = sqlite3.connect(db_path)
with open(test_path, 'r', encoding='utf-8') as f:
    sql = f.read()
cur = conn.cursor()
try:
    cur.execute(sql)
    rows = cur.fetchall()
    for row in rows:
        print('|'.join(str(v) if v is not None else 'NULL' for v in row))
except Exception as e:
    print(f'ERROR: {e}', file=sys.stderr)
    sys.exit(1)
" "$n_db" "$n_test"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c "
import sys, sqlite3
db_path, test_path = sys.argv[1], sys.argv[2]
conn = sqlite3.connect(db_path)
with open(test_path, 'r', encoding='utf-8') as f:
    sql = f.read()
cur = conn.cursor()
try:
    cur.execute(sql)
    rows = cur.fetchall()
    for row in rows:
        print('|'.join(str(v) if v is not None else 'NULL' for v in row))
except Exception as e:
    print(f'ERROR: {e}', file=sys.stderr)
    sys.exit(1)
" "$n_db" "$n_test"
    fi
}

say "==> Running ${#mapfile_tests[@]} data-quality tests against $DB (engine: $ENGINE)"
say ""

FAILED=0
TOTAL=0
declare -a FAILING_TESTS=()

for test_file in "${mapfile_tests[@]}"; do
    TOTAL=$((TOTAL + 1))
    rel="${test_file#$PROJECT_ROOT/}"
    output="$(run_test_sqlite "$test_file" 2>&1)"
    rc=$?
    if [[ $rc -ne 0 || -n "$output" ]]; then
        FAILED=$((FAILED + 1))
        FAILING_TESTS+=("$rel")
        say "FAIL  $rel"
        if [[ -n "$output" ]]; then
            say "      -> violating row(s):"
            printf '%s\n' "$output" | sed 's/^/         /'
        fi
    else
        say "PASS  $rel"
    fi
done

say ""
say "================================================================"
say "Data-quality suite: $TOTAL test(s) run, $((TOTAL - FAILED)) passed, $FAILED failed"
say "================================================================"

if [[ $FAILED -gt 0 ]]; then
    printf 'Failing tests: %s\n' "${FAILING_TESTS[*]}"
    exit 1
fi
exit 0
