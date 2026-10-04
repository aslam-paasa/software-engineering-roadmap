/**
 * SAMPLE TABLE 1 — employees (for aggregation basics)
 *
 * +--------+-----------------+---------+-------------------+-------------+-----------+
 * | emp_id | employee_name   | project | years_experience | hours_logged | role      |
 * +--------+-----------------+---------+-------------------+-------------+-----------+
 * | 1      | Alice           | Alpha   | 3.0               | 100         | Developer |
 * | 2      | Bob             | Alpha   | 5.0               | 120         | QA        |
 * | 3      | Carol           | Alpha   | 7.0               | 105         | Developer |
 * | 4      | Dave            | Alpha   | NULL              | 0           | Manager   |
 * | 5      | Eve             | Beta    | 2.0               | 80          | Manager   |
 * | 6      | Frank           | Beta    | 3.0               | 110         | Developer |
 * | 7      | Grace           | Beta    | 4.0               | 130         | Developer |
 * | 8      | Hank            | Beta    | 3.0               | NULL        | Developer |
 * | 9      | Heidi           | Gamma   | 5.0               | 150         | Developer |
 * | 10     | Ivan            | Gamma   | 6.0               | 140         | QA        |
 * +--------+-----------------+---------+-------------------+-------------+-----------+
 */

/**
 * INTRODUCTION TO AGGREGATION — From rows to insights
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ WHAT IS AGGREGATION?                                               │
 * │   Aggregation is the process of combining multiple rows into       │
 * │   a single summary value. Instead of looking at individual         │
 * │   records, we ask questions like:                                  │
 * │                                                                    │
 * │   → What's the TOTAL hours logged across all projects?             │
 * │   → What's the AVERAGE experience per team?                        │
 * │   → Which project has the HIGHEST total effort?                    │
 * │   → How many employees are in each role?                           │
 * │                                                                    │
 * │ KEY AGGREGATION FUNCTIONS:                                         │
 * │   ┌─────────────┬─────────────────────────────────────────┐        │
 * │   │ Function    │ What it does                            │        │
 * │   ├─────────────┼─────────────────────────────────────────┤        │
 * │   │ COUNT()     │ Counts rows or non-NULL values          │        │
 * │   │ SUM()       │ Adds up all numeric values              │        │
 * │   │ AVG()       │ Calculates average of numeric values    │        │
 * │   │ MIN()       │ Finds smallest value                    │        │
 * │   │ MAX()       │ Finds largest value                     │        │
 * │   └─────────────┴─────────────────────────────────────────┘        │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * SQL EXECUTION ORDER (How Database Processes Queries):
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ 1. FROM      → Identify which table(s) to query                    │
 * │ 2. WHERE     → Filter individual rows BEFORE grouping              │
 * │ 3. GROUP BY  → Divide rows into groups                             │
 * │ 4. HAVING    → Filter groups AFTER aggregation                     │
 * │ 5. SELECT    → Choose which columns/functions to display           │
 * │ 6. ORDER BY  → Sort the final result                               │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * CRITICAL: WHERE filters rows BEFORE grouping.
 *           HAVING filters groups AFTER aggregation.
 *           This order is essential to understand!
 */


/**
 * QUICK REFERENCE — Cheat sheet
 *
 * AGGREGATE FUNCTIONS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ COUNT(*)          → Total rows (including NULLs)                  │
 * │ COUNT(column)     → Non-NULL values in column                     │
 * │ COUNT(DISTINCT col)→ Unique non-NULL values                       │
 * │ SUM(column)       → Total of numeric column (ignores NULLs)       │
 * │ AVG(column)       → Average of numeric column (ignores NULLs)     │
 * │ MIN(column)       → Smallest value (ignores NULLs)                │
 * │ MAX(column)       → Largest value (ignores NULLs)                 │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * GROUP BY PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Single column                                                  │
 * │ SELECT category, COUNT(*) FROM table GROUP BY category;          │
 * │                                                                   │
 * │ -- Multiple columns                                               │
 * │ SELECT category, subcat, COUNT(*) FROM table GROUP BY 1, 2;      │
 * │                                                                   │
 * │ -- With HAVING                                                    │
 * │ SELECT category, AVG(price) FROM table                           │
 * │ GROUP BY category HAVING AVG(price) > 100;                       │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * COUNT VARIATIONS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- All rows                                                       │
 * │ SELECT COUNT(*) FROM registrations;                               │
 * │                                                                   │
 * │ -- Non-NULL emails                                                │
 * │ SELECT COUNT(email) FROM registrations;                           │
 * │                                                                   │
 * │ -- Unique users                                                   │
 * │ SELECT COUNT(DISTINCT user_name) FROM registrations;              │
 * │                                                                   │
 * │ -- Per event totals                                               │
 * │ SELECT event, COUNT(*) FROM registrations GROUP BY event;         │
 * │                                                                   │
 * │ -- Per event unique users                                         │
 * │ SELECT event, COUNT(DISTINCT user_name) FROM registrations        │
 * │ GROUP BY event;                                                   │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * EXECUTION ORDER (Critical to understand):
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ 1. FROM      → Identify source tables                            │
 * │ 2. WHERE     → Filter individual rows (no aggregates!)           │
 * │ 3. GROUP BY  → Group rows together                               │
 * │ 4. HAVING    → Filter groups (aggregates allowed!)               │
 * │ 5. SELECT    → Choose columns/aggregates to display              │
 * │ 6. ORDER BY  → Sort final results                                │
 * └────────────────────────────────────────────────────────────────────┘
 */
