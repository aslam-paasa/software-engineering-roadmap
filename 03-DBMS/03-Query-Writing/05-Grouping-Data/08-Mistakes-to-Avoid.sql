/**
 * ============================================================================
 * COMMON MISTAKES - PITFALLS WITH AGGREGATION
 * Complete Beginner's Guide to Avoiding SQL Errors
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. MISTAKE #1 - Non-aggregated columns without GROUP BY
 * 2. MISTAKE #2 - Using WHERE instead of HAVING
 * 3. MISTAKE #3 - Forgetting NULLs are ignored in aggregates
 * 4. MISTAKE #4 - Misunderstanding execution order
 * 5. MISTAKE #5 - Using DISTINCT unnecessarily with GROUP BY
 * 6. MISTAKE #6 - Using column aliases in WHERE or HAVING
 * 7. MISTAKE #7 - Confusing COUNT(*) with COUNT(column)
 * 8. MISTAKE #8 - Forgetting GROUP BY when using aggregates
 * 9. MISTAKE #9 - Using HAVING without GROUP BY (when not needed)
 * 10. MISTAKE #10 - Expecting ORDER BY to affect GROUP BY
 * 11. QUICK REFERENCE - Mistakes Summary Table
 * 12. GOLDEN RULES - How to avoid these mistakes
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLE FOR ALL EXAMPLES
-- ============================================================================

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    project VARCHAR(20),
    years_experience DECIMAL(3,1),
    hours_logged INT,
    role VARCHAR(20)
);

INSERT INTO employees VALUES
(1, 'Alice', 'Alpha', 3.0, 100, 'Developer'),
(2, 'Bob', 'Alpha', 5.0, 120, 'QA'),
(3, 'Carol', 'Alpha', 7.0, 105, 'Developer'),
(4, 'Dave', 'Alpha', NULL, 0, 'Manager'),
(5, 'Eve', 'Beta', 2.0, 80, 'Manager'),
(6, 'Frank', 'Beta', 3.0, 110, 'Developer'),
(7, 'Grace', 'Beta', 4.0, 130, 'Developer'),
(8, 'Hank', 'Beta', 3.0, NULL, 'Developer'),
(9, 'Heidi', 'Gamma', 5.0, 150, 'Developer'),
(10, 'Ivan', 'Gamma', 6.0, 140, 'QA');

-- ============================================================================
-- MISTAKE #1: Using non-aggregated columns without GROUP BY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #1 - Non-aggregated columns                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ You try to select a column that is not in GROUP BY and not     │   │
 * │   │ wrapped in an aggregate function.                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ WRONG QUERY:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, employee_name, COUNT(*)                         │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY IT'S WRONG:                                                       │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GROUP BY project creates ONE row per project:                    │   │
 * │   │   - Alpha project has 4 employees (Alice, Bob, Carol, Dave)     │   │
 * │   │   - Which employee_name should be shown? Database doesn't know!  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ project = 'Alpha' has employees: Alice, Bob, Carol, Dave       │   │
 * │   │ Database cannot pick one name automatically                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT WAYS:                                                      │
 * │                                                                          │
 * │   Option 1: Include column in GROUP BY                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, employee_name, COUNT(*)                         │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project, employee_name;  ← employee_name in GROUP BY   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   Option 2: Use aggregate function on the column                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(employee_name) AS emp_count, COUNT(*)     │   │
 * │   │ FROM employees                                                  │   │
 *   │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ WRONG (This will cause an error in most databases)
-- SELECT project, employee_name, COUNT(*) FROM employees GROUP BY project;

-- ✅ CORRECT - Include employee_name in GROUP BY
SELECT project, employee_name, COUNT(*) 
FROM employees 
GROUP BY project, employee_name;

/**
 * OUTPUT:
 * ┌─────────┬───────────────┬──────────┐
 * │ project │ employee_name │ count    │
 * ├─────────┼───────────────┼──────────┤
 * │ Alpha   │ Alice         │ 1        │
 * │ Alpha   │ Bob           │ 1        │
 * │ Alpha   │ Carol         │ 1        │
 * │ Alpha   │ Dave          │ 1        │
 * │ Beta    │ Eve           │ 1        │
 * │ Beta    │ Frank         │ 1        │
 * │ Beta    │ Grace         │ 1        │
 * │ Beta    │ Hank          │ 1        │
 * │ Gamma   │ Heidi         │ 1        │
 * │ Gamma   │ Ivan          │ 1        │
 * └─────────┴───────────────┴──────────┘
 */

-- ✅ CORRECT - Use aggregate function
SELECT project, COUNT(employee_name) AS emp_count
FROM employees 
GROUP BY project;

/**
 * OUTPUT:
 * ┌─────────┬───────────┐
 * │ project │ emp_count │
 * ├─────────┼───────────┤
 * │ Alpha   │ 4         │
 * │ Beta    │ 4         │
 * │ Gamma   │ 2         │
 * └─────────┴───────────┘
 */

-- ============================================================================
-- MISTAKE #2: Using WHERE instead of HAVING for aggregated filters
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #2 - WHERE instead of HAVING                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ You try to filter using an aggregate function (SUM, AVG, COUNT)│   │
 * │   │ in the WHERE clause. WHERE cannot use aggregates!              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ WRONG QUERY:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours               │   │
 * │   │ FROM employees                                                  │   │
 *   │   │ WHERE SUM(hours_logged) > 300          ← ERROR!                │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY IT'S WRONG:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ WHERE executes BEFORE GROUP BY                                  │   │
 * │   │ At the time WHERE runs, groups don't exist yet!                 │   │
 * │   │ Aggregate functions like SUM() cannot be used in WHERE          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXECUTION ORDER:                                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. FROM      → Get all rows                                     │   │
 * │   │ 2. WHERE     → Filters rows (NO aggregates allowed here!)       │   │
 * │   │ 3. GROUP BY  → Creates groups                                   │   │
 * │   │ 4. HAVING    → Filters groups (aggregates allowed here!)        │   │
 * │   │ 5. SELECT    → Shows results                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT QUERY:                                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours               │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING SUM(hours_logged) > 300;         ← Use HAVING            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ WRONG (Aggregate in WHERE - ERROR)
-- SELECT project, SUM(hours_logged) AS total_hours 
-- FROM employees 
-- WHERE SUM(hours_logged) > 300 
-- GROUP BY project;

-- ✅ CORRECT (Use HAVING for aggregate filters)
SELECT project, SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project
HAVING SUM(hours_logged) > 300;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ project │ total_hours │
 * ├─────────┼─────────────┤
 * │ Alpha   │ 325         │
 * │ Beta    │ 320         │
 * └─────────┴─────────────┘
 */

-- ============================================================================
-- MISTAKE #3: Forgetting that NULLs are ignored in aggregates
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #3 - NULLs in Aggregates                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ People often assume aggregates treat NULL as 0. They don't!    │   │
 * │   │ NULL values are completely IGNORED in AVG, SUM, COUNT(column)   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT DATA:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ years_experience values: 3.0, 5.0, 7.0, NULL, 2.0, 3.0, 4.0,   │   │
 * │   │                        3.0, 5.0, 6.0                            │   │
 * │   │                                   ↑                              │   │
 * │   │                                Dave (NULL)                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHAT HAPPENS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ AVG(years_experience) = (3+5+7+2+3+4+3+5+6) / 9 = 38/9 = 4.22  │   │
 * │   │                         ↑                                        │   │
 * │   │                    NULL is ignored!                             │   │
 * │   │                                                                  │   │
 * │   │ COUNT(*) = 10 (counts ALL rows, including NULL)                 │   │
 * │   │ COUNT(years_experience) = 9 (only non-NULL values)              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ AVG = 4.22 (not 3.8 if NULL treated as 0)                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate NULL handling
SELECT 
    AVG(years_experience) AS avg_experience,
    COUNT(*) AS total_rows,
    COUNT(years_experience) AS non_null_count,
    SUM(years_experience) AS sum_exp
FROM employees;

/**
 * OUTPUT:
 * ┌────────────────┬────────────┬─────────────────┬─────────┐
 * │ avg_experience │ total_rows │ non_null_count  │ sum_exp │
 * ├────────────────┼────────────┼─────────────────┼─────────┤
 * │ 4.22           │ 10         │ 9               │ 38.0    │
 * └────────────────┴────────────┴─────────────────┴─────────┘
 * 
 * EXPLANATION:
 * - AVG = 38 / 9 = 4.22 (NULL ignored, not treated as 0)
 * - If NULL were treated as 0, AVG would be 38/10 = 3.8
 */

-- Use COALESCE if you want NULL treated as 0
SELECT AVG(COALESCE(years_experience, 0)) AS avg_with_zero
FROM employees;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ avg_with_zero │
 * ├───────────────┤
 * │ 3.8           │
 * └───────────────┘
 */

-- ============================================================================
-- MISTAKE #4: Misunderstanding execution order
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #4 - Execution Order                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ People try to use column aliases in WHERE or HAVING before      │   │
 * │   │ they are created. Aliases are created in SELECT, which runs     │   │
 * │   │ AFTER WHERE and HAVING.                                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ WRONG QUERY:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, AVG(years_experience) AS avg_exp                │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE avg_exp > 4           ← ERROR! avg_exp doesn't exist yet!  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXECUTION ORDER (Remember this!):                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. FROM      → Get all rows from tables                        │   │
 * │   │ 2. WHERE     → Filter rows (aliases NOT available)             │   │
 * │   │ 3. GROUP BY  → Create groups                                   │   │
 * │   │ 4. HAVING    → Filter groups (aliases NOT available)           │   │
 * │   │ 5. SELECT    → Calculate expressions and create aliases        │   │
 * │   │ 6. ORDER BY  → Sort results (aliases ARE available)            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT - Use the full expression:                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, AVG(years_experience) AS avg_exp                │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING AVG(years_experience) > 4;                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT - Aliases CAN be used in ORDER BY:                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, AVG(years_experience) AS avg_exp                │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ ORDER BY avg_exp DESC;          ← Aliases OK in ORDER BY         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ✅ CORRECT - Use full expression in HAVING
SELECT 
    project, 
    AVG(years_experience) AS avg_exp
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING AVG(years_experience) > 4;

/**
 * OUTPUT:
 * ┌─────────┬─────────┐
 * │ project │ avg_exp │
 * ├─────────┼─────────┤
 * │ Alpha   │ 5.0     │
 * │ Gamma   │ 5.5     │
 * └─────────┴─────────┘
 */

-- ✅ CORRECT - Alias can be used in ORDER BY
SELECT 
    project, 
    AVG(years_experience) AS avg_exp
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING AVG(years_experience) > 4
ORDER BY avg_exp DESC;  -- Alias works here!

/**
 * OUTPUT:
 * ┌─────────┬─────────┐
 * │ project │ avg_exp │
 * ├─────────┼─────────┤
 * │ Gamma   │ 5.5     │
 * │ Alpha   │ 5.0     │
 * └─────────┴─────────┘
 */

-- ============================================================================
-- MISTAKE #5: Using DISTINCT unnecessarily with GROUP BY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #5 - DISTINCT with GROUP BY                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GROUP BY already produces unique rows per group. Adding        │   │
 * │   │ DISTINCT is redundant and wastes processing time.              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ REDUNDANT QUERY:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT DISTINCT project, COUNT(*)                               │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY IT'S REDUNDANT:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GROUP BY project already creates ONE row per unique project:    │   │
 * │   │   - Alpha → 1 row                                               │   │
 * │   │   - Beta  → 1 row                                               │   │
 * │   │   - Gamma → 1 row                                               │   │
 * │   │                                                                  │   │
 * │   │ DISTINCT does the same thing again - completely unnecessary!    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT - Remove DISTINCT:                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*)                                        │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHEN TO USE DISTINCT (without GROUP BY):                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ -- Get unique values without aggregation                        │   │
 * │   │ SELECT DISTINCT project FROM employees;                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ REDUNDANT (DISTINCT not needed with GROUP BY)
SELECT DISTINCT project, COUNT(*) AS emp_count
FROM employees
GROUP BY project;

-- ✅ CORRECT (GROUP BY already ensures uniqueness)
SELECT project, COUNT(*) AS emp_count
FROM employees
GROUP BY project;

/**
 * OUTPUT (same for both):
 * ┌─────────┬───────────┐
 * │ project │ emp_count │
 * ├─────────┼───────────┤
 * │ Alpha   │ 4         │
 * │ Beta    │ 4         │
 * │ Gamma   │ 2         │
 * └─────────┴───────────┘
 */

-- ✅ Use DISTINCT when NOT using GROUP BY
SELECT DISTINCT project FROM employees;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ project │
 * ├─────────┤
 * │ Alpha   │
 * │ Beta    │
 * │ Gamma   │
 * └─────────┘
 */

-- ============================================================================
-- MISTAKE #6: Using column aliases in WHERE or HAVING
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #6 - Aliases in WHERE/HAVING                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Column aliases are created in the SELECT clause, which runs    │   │
 * │   │ AFTER WHERE and HAVING. So aliases don't exist yet!            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ WRONG - Using alias in WHERE:                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours                │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE total_hours > 100          ← ERROR!                       │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ WRONG - Using alias in HAVING:                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours                │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING total_hours > 300         ← ERROR in some databases!     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT - Use the full expression:                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours                │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING SUM(hours_logged) > 300;                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ✅ CORRECT - Use full expression in HAVING
SELECT 
    project, 
    SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project
HAVING SUM(hours_logged) > 300;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ project │ total_hours │
 * ├─────────┼─────────────┤
 * │ Alpha   │ 325         │
 * │ Beta    │ 320         │
 * └─────────┴─────────────┘
 */

-- ============================================================================
-- MISTAKE #7: Confusing COUNT(*) with COUNT(column)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #7 - COUNT(*) vs COUNT(column)               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COUNT(*) and COUNT(column) give DIFFERENT results when there   │   │
 * │   │ are NULL values in the column.                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ years_experience: 3.0, 5.0, 7.0, NULL, 2.0, 3.0, 4.0, 3.0,    │   │
 * │   │                   5.0, 6.0                                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   DIFFERENCES:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COUNT(*) = 10 (counts EVERY row, including NULLs)              │   │
 * │   │ COUNT(years_experience) = 9 (only non-NULL values)             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   VISUAL:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Row 1: 3.0  → COUNT(*) ✓, COUNT(exp) ✓                         │   │
 * │   │ Row 2: 5.0  → COUNT(*) ✓, COUNT(exp) ✓                         │   │
 * │   │ Row 3: 7.0  → COUNT(*) ✓, COUNT(exp) ✓                         │   │
 * │   │ Row 4: NULL → COUNT(*) ✓, COUNT(exp) ✗ (NULL excluded)         │   │
 * │   │ Row 5: 2.0  → COUNT(*) ✓, COUNT(exp) ✓                         │   │
 * │   │ ...                                                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    COUNT(*) AS count_star,
    COUNT(years_experience) AS count_column
FROM employees;

/**
 * OUTPUT:
 * ┌────────────┬───────────────┐
 * │ count_star │ count_column  │
 * ├────────────┼───────────────┤
 * │ 10         │ 9             │
 * └────────────┴───────────────┘
 * 
 * EXPLANATION:
 * - COUNT(*) = 10 (all rows, including Dave's NULL)
 * - COUNT(years_experience) = 9 (NULL excluded)
 */

-- ============================================================================
-- MISTAKE #8: Forgetting GROUP BY when using aggregates
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #8 - Missing GROUP BY                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ You use an aggregate function but also want non-aggregated      │   │
 * │   │ columns without GROUP BY.                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*)                                        │   │
 * │   │ FROM employees;                    ← Missing GROUP BY!           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY IT'S WRONG:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COUNT(*) gives ONE number (total employees = 10)                │   │
 * │   │ But there are 3 different projects (Alpha, Beta, Gamma)         │   │
 * │   │ Which project should be shown? Database cannot decide!          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT - Add GROUP BY:                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*)                                        │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                    ← GROUP BY added            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ CORRECT - Only aggregates (no GROUP BY needed):                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(*) FROM employees;                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ✅ CORRECT - Only aggregates (no GROUP BY needed)
SELECT COUNT(*) AS total_employees FROM employees;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ total_employees  │
 * ├──────────────────┤
 * │ 10               │
 * └──────────────────┘
 */

-- ✅ CORRECT - With GROUP BY
SELECT project, COUNT(*) AS emp_count
FROM employees
GROUP BY project;

/**
 * OUTPUT:
 * ┌─────────┬───────────┐
 * │ project │ emp_count │
 * ├─────────┼───────────┤
 * │ Alpha   │ 4         │
 * │ Beta    │ 4         │
 * │ Gamma   │ 2         │
 * └─────────┴───────────┘
 */

-- ============================================================================
-- MISTAKE #9: Using HAVING without GROUP BY (when not needed)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #9 - HAVING without GROUP BY                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ HAVING is designed to filter GROUPS. Without GROUP BY, it's    │   │
 * │   │ confusing and can be replaced with WHERE.                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  HAVING without GROUP BY (works but not recommended):              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(*) FROM employees HAVING COUNT(*) > 5;            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ BETTER - Use WHERE for single row conditions:                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(*) FROM employees WHERE ...;                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- This works but is confusing
SELECT COUNT(*) AS total FROM employees HAVING COUNT(*) > 5;

/**
 * OUTPUT:
 * ┌───────┐
 * │ total │
 * ├───────┤
 * │ 10    │
 * └───────┘
 */

-- Better: Use WHERE if you need to filter before counting
SELECT COUNT(*) AS total FROM employees WHERE years_experience IS NOT NULL;

-- ============================================================================
-- MISTAKE #10: Expecting ORDER BY to affect GROUP BY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKE #10 - ORDER BY vs GROUP BY                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM:                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ People think GROUP BY sorts the results. It does NOT guarantee │   │
 * │   │ any specific order. Always use ORDER BY for sorting.           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ❌ DON'T RELY ON GROUP BY FOR SORTING:                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) FROM employees GROUP BY project;      │   │
 * │   │ -- Results may come in any order! Not guaranteed sorted!       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ✅ ALWAYS use ORDER BY for consistent sorting:                        │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) FROM employees                         │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ ORDER BY project;                    ← Explicit sorting          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Without ORDER BY (order NOT guaranteed)
SELECT project, COUNT(*) AS emp_count
FROM employees
GROUP BY project;

-- With ORDER BY (guaranteed order)
SELECT project, COUNT(*) AS emp_count
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT (guaranteed):
 * ┌─────────┬───────────┐
 * │ project │ emp_count │
 * ├─────────┼───────────┤
 * │ Alpha   │ 4         │
 * │ Beta    │ 4         │
 * │ Gamma   │ 2         │
 * └─────────┴───────────┘
 */

-- ============================================================================
-- QUICK REFERENCE - Mistakes Summary Table
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MISTAKES SUMMARY TABLE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────┬────────────────────────────┬────────────────────────────────┐│
 * │ │ Mistake│ Wrong                       │ Correct                        ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #1     │ SELECT col, COUNT(*)        │ SELECT col, COUNT(*)           ││
 * │        │ FROM table                  │ FROM table                     ││
 * │        │ GROUP BY other_col          │ GROUP BY col                   ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #2     │ WHERE SUM(col) > X          │ HAVING SUM(col) > X            ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #3     │ Assume AVG ignores NULLs    │ Use COALESCE for NULL handling ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #4     │ WHERE alias > X             │ Use full expression in WHERE   ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #5     │ SELECT DISTINCT col, COUNT  │ Remove DISTINCT, keep GROUP BY ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #6     │ HAVING alias > X            │ Use full expression in HAVING  ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #7     │ COUNT(*) = COUNT(col)       │ They differ with NULLs         ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #8     │ SELECT col, COUNT(*)        │ Add GROUP BY col               ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #9     │ HAVING without GROUP BY     │ Use WHERE for single rows      ││
 * ├────────┼────────────────────────────┼────────────────────────────────┤│
 * │ #10    │ Rely on GROUP BY for sort   │ Always use ORDER BY            ││
 * └────────┴────────────────────────────┴────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- GOLDEN RULES - How to avoid these mistakes
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Every column in SELECT must be in GROUP BY OR in an aggregate  │
 * │         → If you mix, you must GROUP BY the non-aggregated columns     │
 * │                                                                          │
 * │ RULE 2: Use WHERE for row filters, HAVING for group filters            │
 * │         → WHERE: filters individual rows BEFORE grouping               │
 * │         → HAVING: filters groups AFTER aggregation                     │
 * │                                                                          │
 * │ RULE 3: NULLs are ignored in AVG, SUM, COUNT(column)                   │
 * │         → COUNT(*) includes NULLs                                      │
 * │         → COUNT(column) excludes NULLs                                 │
 * │         → Use COALESCE if you want NULL treated as 0                   │
 * │                                                                          │
 * │ RULE 4: Remember execution order                                       │
 * │         → FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY         │
 * │         → Aliases don't exist in WHERE/HAVING                          │
 * │                                                                          │
 * │ RULE 5: GROUP BY already makes rows unique                             │
 * │         → Don't add DISTINCT to GROUP BY queries                       │
 * │                                                                          │
 * │ RULE 6: Always use ORDER BY for sorting                                │
 * │         → Never rely on GROUP BY for order                             │
 * │                                                                          │
 * │ RULE 7: Test your queries with EXPLAIN                                 │
 * │         → See if aggregates are working as expected                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES - Spot the Mistakes
-- ============================================================================

/**
 * EXERCISE 1: Find the mistake
 * 
 * SELECT project, employee_name, COUNT(*)
 * FROM employees
 * GROUP BY project;
 * 
 * Answer: employee_name is not in GROUP BY and not aggregated
 * Fix: GROUP BY project, employee_name
 */

/**
 * EXERCISE 2: Find the mistake
 * 
 * SELECT project, SUM(hours_logged) AS total
 * FROM employees
 * WHERE SUM(hours_logged) > 300
 * GROUP BY project;
 * 
 * Answer: Aggregate function in WHERE clause
 * Fix: Move condition to HAVING
 */

/**
 * EXERCISE 3: Find the mistake
 * 
 * SELECT project, AVG(years_experience) AS avg_exp
 * FROM employees
 * GROUP BY project
 * HAVING avg_exp > 4;
 * 
 * Answer: Cannot use alias avg_exp in HAVING (in some databases)
 * Fix: Use AVG(years_experience) > 4
 */

/**
 * EXERCISE 4: Find the mistake
 * 
 * SELECT DISTINCT project, COUNT(*) 
 * FROM employees 
 * GROUP BY project;
 * 
 * Answer: DISTINCT is redundant with GROUP BY
 * Fix: Remove DISTINCT
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS employees;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ TOP 10 MISTAKES TO REMEMBER:                                           │
 * │                                                                          │
 * │ 1. Mixing non-aggregated columns without GROUP BY                      │
 * │ 2. Using WHERE instead of HAVING for aggregate filters                 │
 * │ 3. Forgetting NULLs are ignored in aggregates                          │
 * │ 4. Misunderstanding execution order                                    │
 * │ 5. Adding unnecessary DISTINCT to GROUP BY                             │
 * │ 6. Using column aliases in WHERE/HAVING                                │
 * │ 7. Confusing COUNT(*) with COUNT(column)                               │
 * │ 8. Forgetting GROUP BY when needed                                     │
 * │ 9. Using HAVING without GROUP BY unnecessarily                         │
 * │ 10. Relying on GROUP BY for sorting                                    │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always test your queries with sample data                          │
 * │   - Use EXPLAIN to see how queries execute                             │
 * │   - NULL handling is crucial for accurate results                      │
 * │   - Execution order is key to understanding errors                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF COMMON MISTAKES GUIDE
-- ============================================================================