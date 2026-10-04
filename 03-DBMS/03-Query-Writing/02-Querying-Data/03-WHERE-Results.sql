/**
 * WHERE — Filtering rows with conditions
 *
 * What it does:
 *   WHERE restricts rows by applying one or more logical conditions.
 *   Only rows that satisfy the condition(s) are included in the result.
 *   Think of WHERE as a gatekeeper — it decides which rows are allowed
 *   to pass through to the output.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Filter rows where region equals 'Oceania'                       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT *                                                      │
 * │   FROM countries                                                │
 * │   WHERE region = 'Oceania';                                     │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+----------+---------+---------+                    │
 * │ | country   | population | area  | region  |                    │
 * │ +-----------+----------+---------+---------+                    │
 * │ | Australia |  25700000 | 7692000 | Oceania |                   │
 * │ +-----------+----------+---------+---------+                    │
 * │                                                                 │
 * │ WHERE decides which rows are allowed to stay.                   │
 * └─────────────────────────────────────────────────────────────────┘
 */