-- ============================================================================
-- Pre-flight smoke test assertion query
-- ============================================================================
SELECT 'warehouse_empty' AS failure_reason
WHERE (SELECT COUNT(*) FROM users) = 0 OR (SELECT COUNT(*) FROM events) = 0;
