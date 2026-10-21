# data-quality-test-suite

[![CI](https://github.com/bighnaraj2008-ai/data-quality-test-suite/actions/workflows/ci.yml/badge.svg)](https://github.com/bighnaraj2008-ai/data-quality-test-suite/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Pure SQL](https://img.shields.io/badge/Dialect-Pure%20SQL-blue.svg)](tests/)
[![Tests](https://img.shields.io/badge/Tests-16%20Passed-brightgreen.svg)](tests/)

Production-grade, **pure SQL** data-quality test suite with dbt-style modular test queries for:

- **Null checks** — critical primary keys and foreign keys must never be NULL
- **Duplicate / uniqueness assertions** — natural keys and primary keys must be unique
- **Statistical drift detection** — daily row counts and categorical distributions compared against 30-day historical baselines
- **Referential integrity** — orphan records and chronological sequence assertions
- **Data freshness & bounds** — SLA lag boundaries and range constraints

Every test is a single portable SQL query following one simple, dbt-style contract:

> **A test PASSES iff its query returns ZERO rows. Any row it returns is a violation.**

A bash runner evaluates all test queries and **exits non-zero if any test fails**, making the suite a drop-in CI gate. No frameworks, no ORMs, no compiled tooling — just pure SQL files.

---

## Project Structure

```
data-quality-test-suite/
├── .github/workflows/
│   ├── ci.yml                           # CI: quality gate + postgres service
│   └── lint.yml                         # SQLFluff linting workflow
├── tests/
│   ├── seed_test_data.sql               # deterministic sample warehouse
│   ├── nulls/
│   │   ├── assert_no_null_users.sql
│   │   ├── assert_no_null_events.sql
│   │   └── assert_no_null_foreign_keys.sql
│   ├── duplicates/
│   │   ├── assert_unique_user_emails.sql
│   │   ├── assert_unique_event_ids.sql
│   │   └── assert_unique_composite_keys.sql
│   ├── drift/
│   │   ├── assert_row_count_drift.sql
│   │   ├── assert_value_distribution.sql
│   │   └── assert_categorical_drift.sql
│   ├── integrity/
│   │   ├── assert_orphan_records.sql
│   │   └── assert_date_logic.sql
│   ├── freshness/
│   │   ├── assert_event_freshness.sql
│   │   └── assert_table_update_time.sql
│   ├── range/
│   │   ├── assert_metric_ranges.sql
│   │   └── assert_percentage_bounds.sql
│   ├── custom/
│   │   └── assert_custom_business_rule.sql
│   ├── schema_metadata_tests.sql
│   └── test_summary_view.sql
├── scripts/
│   ├── run_tests.sh                     # primary test suite runner
│   ├── reset_db.sh                      # database reset utility
│   ├── generate_report.sh               # Markdown test report generator
│   ├── benchmark_tests.sh               # performance latency benchmark
│   ├── validate_syntax.sh               # SQL syntax validator
│   ├── clean_test_results.sh            # output cleaning utility
│   ├── smoke_test.sql                   # pre-flight smoke test
│   └── health_check.sql                 # warehouse diagnostics
├── docs/                                # full documentation catalog
│   ├── TEST_SPECIFICATIONS.md
│   ├── ARCHITECTURE.md
│   ├── DATA_GOVERNANCE.md
│   ├── PERFORMANCE.md
│   ├── ALERTING.md
│   ├── TROUBLESHOOTING.md
│   ├── TEST_WRITING_GUIDE.md
│   ├── METRICS_DICTIONARY.md
│   ├── FAQ.md
│   └── BENCHMARK_TEMPLATE.md
├── docker/
│   ├── docker-compose.yml
│   └── init_db.sql
├── Dockerfile
├── .dockerignore
├── .sqlfluff
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
├── README.md
└── .gitignore
```

## Local Execution

### Quick Start

```bash
# Clone the repository
git clone https://github.com/bighnaraj2008-ai/data-quality-test-suite.git
cd data-quality-test-suite

# Build clean database, seed it, and execute all 16 assertions
bash scripts/run_tests.sh --db target/quality.db --seed
# Expected output: "16 test(s) run, 16 passed, 0 failed" -> exit code 0
```

## Documentation
- [Architecture Guide](docs/ARCHITECTURE.md)
- [Test Specifications Catalog](docs/TEST_SPECIFICATIONS.md)
- [Data Governance & SLAs](docs/DATA_GOVERNANCE.md)
- [Performance Tuning](docs/PERFORMANCE.md)
- [Writing Custom Tests](docs/TEST_WRITING_GUIDE.md)
- [Metrics Dictionary](docs/METRICS_DICTIONARY.md)
- [Troubleshooting Playbook](docs/TROUBLESHOOTING.md)
- [Alerting & Incident Response](docs/ALERTING.md)
- [Frequently Asked Questions](docs/FAQ.md)

## License
Distributed under the MIT License. See [LICENSE](LICENSE) for details.
