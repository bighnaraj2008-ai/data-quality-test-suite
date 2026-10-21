-- ============================================================================
-- TEST:       assert_event_freshness
-- CATEGORY:   freshness
-- TABLE:      events
-- ASSERTION:  Maximum event lag relative to current time must not exceed 3 days.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

WITH max_event AS (
    SELECT MAX(date(occurred_at)) AS latest_event_date
    FROM events
)
SELECT latest_event_date,
       ROUND(julianday('now') - julianday(latest_event_date), 2) AS lag_days,
       3.0 AS max_allowed_lag_days
FROM max_event
WHERE julianday('now') - julianday(latest_event_date) > 3.0;
