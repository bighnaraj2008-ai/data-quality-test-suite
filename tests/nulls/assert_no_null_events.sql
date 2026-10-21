-- ============================================================================
-- TEST:       assert_no_null_events
-- CATEGORY:   nulls
-- TABLE:      events
-- ASSERTION:  Critical columns of `events` must never contain unexpected NULLs.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per violation: (record_key, violated_column).
-- SEVERITY:   error (blocking)
-- ============================================================================

SELECT e.id AS record_key,
       'id' AS violated_column
FROM events AS e
WHERE e.id IS NULL

UNION ALL

SELECT e.id AS record_key,
       'user_id' AS violated_column
FROM events AS e
WHERE e.user_id IS NULL

UNION ALL

SELECT e.id AS record_key,
       'event_type' AS violated_column
FROM events AS e
WHERE e.event_type IS NULL

UNION ALL

SELECT e.id AS record_key,
       'occurred_at' AS violated_column
FROM events AS e
WHERE e.occurred_at IS NULL;
