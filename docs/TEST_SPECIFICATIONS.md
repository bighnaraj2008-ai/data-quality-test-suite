# Data Quality Test Specifications

Comprehensive catalog of all modular test queries, contracts, and assertion rules.

## Overview
Every test is a pure ANSI/SQLite SQL query following the dbt-style contract:
> **A test PASSES iff its query returns ZERO rows. Any row it returns is a violation.**
