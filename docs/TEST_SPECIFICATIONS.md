# Data Quality Test Specifications

Comprehensive catalog of all modular test queries, contracts, and assertion rules.

## Overview
Every test is a pure ANSI/SQLite SQL query following the dbt-style contract:
> **A test PASSES iff its query returns ZERO rows. Any row it returns is a violation.**

## 1. Null Checks (`tests/nulls/`)
- `assert_no_null_users.sql`: Validates `id`, `email`, `created_at`, `age`, and `country` are non-null.
- `assert_no_null_events.sql`: Validates `id`, `user_id`, `event_type`, and `occurred_at` are non-null.
- `assert_no_null_foreign_keys.sql`: Validates all foreign key references are non-null.
