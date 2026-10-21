# data-quality-test-suite

Production-grade, **pure SQL** data-quality test suite with dbt-style modular test queries.

## Core Philosophy
Every test is a single portable SQL query following one simple contract:
> **A test PASSES iff its query returns ZERO rows. Any row it returns is a violation.**
