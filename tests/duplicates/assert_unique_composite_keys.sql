-- ============================================================================
-- TEST:       assert_unique_composite_keys
-- CATEGORY:   duplicates
-- TABLE:      events
-- ASSERTION:  Composite key (id, event_type) must be strictly unique.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per duplicate: (duplicate_key, count).
-- SEVERITY:   error (blocking)
-- ============================================================================

SELECT e.id || '-' || e.event_type AS duplicate_key,
       COUNT(*) AS occurrences
FROM events AS e
GROUP BY e.id, e.event_type
HAVING COUNT(*) > 1;
