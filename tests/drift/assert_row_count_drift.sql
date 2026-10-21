-- ============================================================================
-- TEST:       assert_row_count_drift
-- CATEGORY:   drift
-- TABLE:      events
-- ASSERTION:  Daily row counts over the most recent 7 complete days must stay
--             within +/-50% of the 30-day historical baseline average.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per drifting day: (day, row_count, baseline_avg, deviation, max_deviation).
-- THRESHOLD:  max_deviation = 0.50 (relative deviation from baseline average)
-- SEVERITY:   warn-first-line (blocking in CI)
-- ============================================================================

WITH daily AS (
    SELECT date(e.occurred_at) AS day,
           COUNT(*)            AS row_count
    FROM events AS e
    WHERE e.occurred_at IS NOT NULL
      AND date(e.occurred_at) >= date('now', '-37 day')
      AND date(e.occurred_at) <  date('now')
    GROUP BY 1
),
baseline AS (
    SELECT AVG(d.row_count) AS baseline_avg
    FROM daily AS d
    WHERE d.day < date('now', '-7 day')
),
recent AS (
    SELECT d.day,
           d.row_count
    FROM daily AS d
    WHERE d.day >= date('now', '-7 day')
)
SELECT r.day                                                            AS day,
       r.row_count                                                      AS row_count,
       ROUND(b.baseline_avg, 2)                                         AS baseline_avg,
       ROUND(ABS(r.row_count - b.baseline_avg) / b.baseline_avg, 4)      AS deviation,
       0.50                                                             AS max_deviation
FROM recent AS r
CROSS JOIN baseline AS b
WHERE b.baseline_avg > 0
  AND ABS(r.row_count - b.baseline_avg) / b.baseline_avg > 0.50;
