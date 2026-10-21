# Guide to Writing Modular SQL Data Tests

## Step-by-Step Tutorial
1. Define the business assertion rule.
2. Formulate query returning only records that violate the rule.
3. Return informative violation attributes (`record_key`, `violated_column`, `reason`).
4. Test locally with clean data and anomaly-injected data.
