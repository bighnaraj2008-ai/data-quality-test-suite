# Data Quality Test Specifications

Comprehensive catalog of all modular test queries, contracts, and assertion rules.

## Overview
Every test is a pure ANSI/SQLite SQL query following the dbt-style contract:
> **A test PASSES iff its query returns ZERO rows. Any row it returns is a violation.**

## 1. Null Checks (`tests/nulls/`)
- `assert_no_null_users.sql`: Validates `id`, `email`, `created_at`, `age`, and `country` are non-null.
- `assert_no_null_events.sql`: Validates `id`, `user_id`, `event_type`, and `occurred_at` are non-null.
- `assert_no_null_foreign_keys.sql`: Validates all foreign key references are non-null.

## 2. Uniqueness Checks (`tests/duplicates/`)
- `assert_unique_user_emails.sql`: Validates uniqueness of user emails natural key.
- `assert_unique_event_ids.sql`: Validates primary key uniqueness on events.
- `assert_unique_composite_keys.sql`: Validates uniqueness of composite tuples.

## 3. Drift & Distribution Checks (`tests/drift/`)
- `assert_row_count_drift.sql`: Validates daily row count stays within ±50% of the 30-day baseline average.
- `assert_value_distribution.sql`: Categorical share of `event_type` must stay within 15 percentage points of baseline.
- `assert_categorical_drift.sql`: Country distribution must remain within 20 percentage points of baseline.
