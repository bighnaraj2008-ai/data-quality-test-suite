-- ============================================================================
-- TEST:       assert_custom_business_rule
-- CATEGORY:   custom
-- TABLE:      users
-- ASSERTION:  User age must be within acceptable legal bounds [18, 100].
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- ============================================================================

SELECT id AS record_key,
       age AS invalid_age,
       'age_out_of_bounds' AS violation_reason
FROM users
WHERE age < 18 OR age > 100;
