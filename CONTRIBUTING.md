# Contributing Guidelines

## Adding New Test Assertions
1. Place tests under the appropriate `tests/<category>/` directory.
2. Follow the dbt contract: **Zero rows returned = PASS**.
3. Include standard metadata header (TEST, CATEGORY, TABLE, ASSERTION, THRESHOLD).
4. Run `bash scripts/run_tests.sh --seed` before submitting a PR.
