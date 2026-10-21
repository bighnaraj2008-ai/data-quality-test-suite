-- ============================================================================
-- TEST:       assert_unique_event_ids
-- CATEGORY:   duplicates
-- TABLE:      events
-- ASSERTION:  The id column is the primary key of `events` — every value must appear once.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per duplicated value: (duplicate_value, occurrences, offending_keys).
-- SEVERITY:   error (blocking)
-- ============================================================================

SELECT e.id                                      AS duplicate_value,
       COUNT(*)                                  AS occurrences,
       GROUP_CONCAT(e.occurred_at)               AS offending_keys
FROM events AS e
WHERE e.id IS NOT NULL
GROUP BY e.id
HAVING COUNT(*) > 1;
