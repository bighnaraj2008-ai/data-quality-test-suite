-- ============================================================================
-- TEST:       assert_categorical_drift
-- CATEGORY:   drift
-- TABLE:      users
-- ASSERTION:  Country distribution over recent registrations must not deviate
--             by more than 20 percentage points from baseline history.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

WITH recent AS (
    SELECT country, COUNT(*) * 1.0 / (SELECT COUNT(*) FROM users WHERE date(created_at) >= date('now', '-14 day')) AS share
    FROM users
    WHERE date(created_at) >= date('now', '-14 day')
    GROUP BY country
),
baseline AS (
    SELECT country, COUNT(*) * 1.0 / (SELECT COUNT(*) FROM users WHERE date(created_at) < date('now', '-14 day')) AS share
    FROM users
    WHERE date(created_at) < date('now', '-14 day')
    GROUP BY country
)
SELECT r.country,
       ROUND(r.share, 4) AS recent_share,
       ROUND(b.share, 4) AS baseline_share,
       ROUND(ABS(r.share - b.share), 4) AS deviation,
       0.20 AS max_deviation
FROM recent r
JOIN baseline b ON r.country = b.country
WHERE ABS(r.share - b.share) > 0.20;
