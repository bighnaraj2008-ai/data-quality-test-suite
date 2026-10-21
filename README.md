# data-quality-test-suite

Production-grade, **pure SQL** data-quality test suite with dbt-style modular test queries.

## Core Philosophy
Every test is a single portable SQL query following one simple contract:
> **A test PASSES iff its query returns ZERO rows. Any row it returns is a violation.**

## Local Execution

### Quick Start
```bash
# 1. Seed database and run complete test suite
bash scripts/run_tests.sh --db target/quality.db --seed
```

## CI Integration
Automated workflow `.github/workflows/ci.yml` runs on every pull request and push to `main`.

## Frequently Asked Questions
See [docs/FAQ.md](docs/FAQ.md) for architectural FAQs.

## Troubleshooting
See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for triage playbooks.
