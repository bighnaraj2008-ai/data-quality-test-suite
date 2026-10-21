-- ============================================================================
-- Template: Custom Data Quality Assertion Query
-- CONTRACT: PASS iff this query returns ZERO rows.
-- ============================================================================

SELECT id AS record_key,
       'custom_rule_violated' AS violation_reason
FROM users
WHERE 1 = 0;
