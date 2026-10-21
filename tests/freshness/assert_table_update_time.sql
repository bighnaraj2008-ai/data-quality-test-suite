-- ============================================================================
-- TEST:       assert_table_update_time
-- CATEGORY:   freshness
-- TABLE:      users
-- ASSERTION:  Users table must have registrations within the last 7 days.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

WITH max_user AS (
    SELECT MAX(date(created_at)) AS latest_created_date
    FROM users
)
SELECT latest_created_date,
       ROUND(julianday('now') - julianday(latest_created_date), 2) AS lag_days,
       7.0 AS max_allowed_lag_days
FROM max_user
WHERE julianday('now') - julianday(latest_created_date) > 7.0;
