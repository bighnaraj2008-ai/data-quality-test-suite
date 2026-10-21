# Test Suite Performance Optimization Guide

## Performance Techniques
1. **Partition Pruning**: Always scope time-series scans with date filter boundaries.
2. **Selective CTEs**: Avoid repeated full table scans across drift calculations.
3. **Index Optimization**: Maintain secondary indexes on `(user_id, occurred_at)` for large production tables.
