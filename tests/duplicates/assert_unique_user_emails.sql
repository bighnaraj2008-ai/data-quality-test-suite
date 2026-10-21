-- ============================================================================
-- TEST:       assert_unique_user_emails
-- CATEGORY:   duplicates
-- TABLE:      users
-- ASSERTION:  The email column is a natural key — every value must appear exactly once.
-- CONTRACT:   dbt-style generic test — PASS iff this query returns ZERO rows.
-- FAILURE:    One row per duplicated value: (duplicate_value, occurrences, offending_keys).
-- SEVERITY:   error (blocking)
-- ============================================================================

SELECT u.email                                   AS duplicate_value,
       COUNT(*)                                  AS occurrences,
       GROUP_CONCAT(u.id)                        AS offending_keys
FROM users AS u
WHERE u.email IS NOT NULL
GROUP BY u.email
HAVING COUNT(*) > 1;
