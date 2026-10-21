# Data Quality Framework Architecture

## System Diagram
```
              ┌──────────────────────────────────────────┐
              │  tests/**/*.sql   (pure SQL, dbt-style)  │
              │  pass ⇔ query returns zero rows          │
              └───────────────┬──────────────────────────┘
                              │ discovered & executed by
              ┌───────────────▼──────────────────────────┐
              │  scripts/run_tests.sh                    │
              │  ├── SQLite Engine (cli / python stdlib) │
              │  └── PostgreSQL Engine (psql)            │
              └───────────────┬──────────────────────────┘
                              │ exit 0 (pass) / 1 (fail)
              ┌───────────────▼──────────────────────────┐
              │  CI Quality Gate: GitHub Actions         │
              └──────────────────────────────────────────┘
```

## Architectural Highlights
- **Zero ORM or Framework Overhead**: Pure portable SQL files.
- **Violation-as-Row Design**: Triaging failed assertions requires only reading the output rows.
- **Timing Independence**: Drift calculations exclude partial active days.
