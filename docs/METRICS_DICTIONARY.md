# Data Quality Metrics Dictionary

| Metric | Category | Definition | Criticality |
|---|---|---|---|
| Null Count | Nullability | Number of unexpected NULL entries | Critical |
| Uniqueness Violation | Entity Integrity | Duplicate occurrences of unique key | Critical |
| Volume Drift | Statistical Drift | Daily count deviation from 30d baseline | Warning |
| Distribution Drift | Statistical Drift | Categorical percentage deviation | Warning |
