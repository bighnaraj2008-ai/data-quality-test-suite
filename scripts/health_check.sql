-- ============================================================================
-- Warehouse Health Check Diagnostics
-- ============================================================================
SELECT 'users' AS entity, COUNT(*) AS total_rows, MIN(created_at) AS earliest, MAX(created_at) AS latest FROM users
UNION ALL
SELECT 'events' AS entity, COUNT(*) AS total_rows, MIN(occurred_at) AS earliest, MAX(occurred_at) AS latest FROM events;
