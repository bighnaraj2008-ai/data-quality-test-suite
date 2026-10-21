-- ============================================================================
-- TEST:       assert_metric_ranges
-- CATEGORY:   range
-- TABLE:      users, events
-- ASSERTION:  Primary IDs and age metrics must strictly reside in positive bounds.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

SELECT id AS record_key,
       age AS invalid_metric,
       'age_out_of_range' AS violation_reason
FROM users
WHERE age <= 0 OR age > 120

UNION ALL

SELECT id AS record_key,
       id AS invalid_metric,
       'negative_or_zero_id' AS violation_reason
FROM events
WHERE id <= 0;
