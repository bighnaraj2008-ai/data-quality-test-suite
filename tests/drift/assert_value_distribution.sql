-- ============================================================================
-- TEST:       assert_value_distribution
-- CATEGORY:   drift
-- TABLE:      events
-- ASSERTION:  The categorical mix of `event_type` over the most recent 7
--             complete days must match the mix over the preceding 30-day
--             baseline within 15 percentage points per category.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per shifted category: (event_type, recent_share, baseline_share, share_shift, max_shift).
-- THRESHOLD:  max_shift = 0.15 (absolute share change, i.e. 15 percentage points)
-- SEVERITY:   warn-first-line (blocking in CI)
-- ============================================================================

WITH recent_counts AS (
    SELECT e.event_type,
           COUNT(*) AS n
    FROM events AS e
    WHERE e.occurred_at IS NOT NULL
      AND date(e.occurred_at) >= date('now', '-7 day')
      AND date(e.occurred_at) <  date('now')
    GROUP BY 1
),
recent_total AS (
    SELECT SUM(rc.n) AS total
    FROM recent_counts AS rc
),
baseline_counts AS (
    SELECT e.event_type,
           COUNT(*) AS n
    FROM events AS e
    WHERE e.occurred_at IS NOT NULL
      AND date(e.occurred_at) >= date('now', '-37 day')
      AND date(e.occurred_at) <  date('now', '-7 day')
    GROUP BY 1
),
baseline_total AS (
    SELECT SUM(bc.n) AS total
    FROM baseline_counts AS bc
)
SELECT rc.event_type                                                          AS event_type,
       ROUND(rc.n * 1.0 / rt.total, 4)                                        AS recent_share,
       ROUND(bc.n * 1.0 / bt.total, 4)                                        AS baseline_share,
       ROUND(ABS(rc.n * 1.0 / rt.total - bc.n * 1.0 / bt.total), 4)           AS share_shift,
       0.15                                                                   AS max_shift
FROM recent_counts   AS rc
JOIN baseline_counts AS bc ON bc.event_type = rc.event_type
CROSS JOIN recent_total   AS rt
CROSS JOIN baseline_total AS bt
WHERE bt.total > 0
  AND rt.total > 0
  AND ABS(rc.n * 1.0 / rt.total - bc.n * 1.0 / bt.total) > 0.15;
