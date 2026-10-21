-- ============================================================================
-- TEST:       assert_percentage_bounds
-- CATEGORY:   range
-- TABLE:      events
-- ASSERTION:  Event distribution share percentages must fall in [0.0, 100.0].
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

WITH shares AS (
    SELECT event_type,
           COUNT(*) * 100.0 / (SELECT COUNT(*) FROM events) AS share_pct
    FROM events
    GROUP BY event_type
)
SELECT event_type,
       share_pct,
       'out_of_percentage_bounds' AS reason
FROM shares
WHERE share_pct < 0.0 OR share_pct > 100.0;
