-- ============================================================================
-- TEST:       assert_no_null_foreign_keys
-- CATEGORY:   nulls
-- TABLE:      events
-- ASSERTION:  Foreign key references in events must never be NULL.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per violation: (record_key, foreign_key_column).
-- SEVERITY:   error (blocking)
-- ============================================================================

SELECT e.id AS record_key,
       'user_id' AS foreign_key_column
FROM events AS e
WHERE e.user_id IS NULL;
