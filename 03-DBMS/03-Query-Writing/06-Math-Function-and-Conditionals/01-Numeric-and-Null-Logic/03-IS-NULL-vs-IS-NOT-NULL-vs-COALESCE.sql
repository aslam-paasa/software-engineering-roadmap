/**
 * ============================================================================
 * COALESCE AND NULL HANDLING - COMPLETE REVISION GUIDE
 * (COALESCE, IS NULL, IS NOT NULL, NULLIF)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. COALESCE() -------------------------------- (First non-NULL value)
 *    - 1.1 Basic COALESCE (single backup)
 *    - 1.2 Multiple backups (priority list)
 *    - 1.3 COALESCE with default value
 * 
 * 2. IS NULL vs IS NOT NULL -------------------- (Filtering NULL values)
 *    - 2.1 Finding rows with NULL
 *    - 2.2 Finding rows without NULL
 *    - 2.3 The "= NULL" Mistake
 * 
 * 3. REAL-WORLD SCENARIOS ---------------------- (Practical use cases)
 *    - 3.1 Contact Priority List
 *    - 3.2 Safe Math with Default Values
 *    - 3.3 Cleaning Data for Aggregation
 *    - 3.4 Identifying truly "Empty" Rows
 *    - 3.5 Advanced Cleanup with NULLIF
 * 
 * 4. IS NULL vs IS NOT NULL vs COALESCE -------- (When to use what)
 * 
 * 5. COMMON MISTAKES --------------------------- (What to avoid)
 * 
 * 6. GOLDEN RULES ------------------------------ (Key principles)
 * 
 * 7. QUICK REFERENCE CARD ---------------------- (Cheat sheet)
 * 
 * 8. PRACTICE EXERCISES ------------------------ (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SOURCE TABLE: COALESCE_DEMO
-- ============================================================================

CREATE TABLE coalesce_demo (
    id INT PRIMARY KEY,
    primary_email VARCHAR(80),
    work_email VARCHAR(80),
    personal_email VARCHAR(80),
    hours_logged DECIMAL(10,2),
    default_hours DECIMAL(10,2)
);

INSERT INTO coalesce_demo VALUES
(1, 'aisha@company.com', NULL, 'aisha@gmail.com', 5.0, 0.0),
(2, NULL, 'rohan@company.com', NULL, NULL, 0.0),
(3, NULL, NULL, 'meera@yahoo.com', 2.5, 0.0),
(4, NULL, NULL, NULL, NULL, 0.0),
(5, '', NULL, 'raj@gmail.com', 5.0, 0.0);

-- Display the data
SELECT id, primary_email, work_email, personal_email, hours_logged, default_hours 
FROM coalesce_demo 
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┬─────────────────────┬─────────────────┬──────────────┬───────────────┐
 * │ id │ primary_email       │ work_email          │ personal_email  │ hours_logged │ default_hours │
 * ├────┼─────────────────────┼─────────────────────┼─────────────────┼──────────────┼───────────────┤
 * │ 1  │ aisha@company.com   │ NULL                │ aisha@gmail.com │ 5.0          │ 0.0           │
 * │ 2  │ NULL                │ rohan@company.com   │ NULL            │ NULL         │ 0.0           │
 * │ 3  │ NULL                │ NULL                │ meera@yahoo.com │ 2.5          │ 0.0           │
 * │ 4  │ NULL                │ NULL                │ NULL            │ NULL         │ 0.0           │
 * │ 5  │                     │ NULL                │ raj@gmail.com   │ 5.0          │ 0.0           │
 * └────┴─────────────────────┴─────────────────────┴─────────────────┴──────────────┴───────────────┘
 * 
 * IMPORTANT: Row 5 has an empty string ('') in primary_email, NOT NULL!
 */

-- ============================================================================
-- PART 1: COALESCE() - First non-NULL value
-- ============================================================================

/**
 * COALESCE returns the first non-NULL value from a list.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COALESCE() - EXPLANATION                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(value1, value2, value3, ..., value_n)                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   RULES:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Returns the FIRST value that is NOT NULL                      │   │
 * │   │ • If all values are NULL, returns NULL                          │   │
 * │   │ • Can take 2 or more arguments                                  │   │
 * │   │ • Empty string ('') is NOT NULL (it's a valid value!)           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(NULL, 'hello', 'world') = 'hello'                      │   │
 * │   │ COALESCE(NULL, NULL, 'default') = 'default'                     │   │
 * │   │ COALESCE('', 'fallback') = '' (empty string NOT NULL!)          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 1.1 Basic COALESCE (single backup)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              COALESCE - Basic (Single Backup)                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Replace NULL hours_logged with default_hours                  │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, hours_logged, default_hours,                         │   │
 * │   │        COALESCE(hours_logged, default_hours) AS effective_hours │   │
 * │   │ FROM coalesce_demo                                              │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────────┬───────────────┬─────────────────┐             │
 * │   │ id │ hours_logged │ default_hours │ effective_hours │             │
 * │   ├────┼──────────────┼───────────────┼─────────────────┤             │
 * │   │ 1  │ 5.0          │ 0.0           │ 5.0             │             │
 * │   │ 2  │ NULL         │ 0.0           │ 0.0             │             │
 * │   │ 3  │ 2.5          │ 0.0           │ 2.5             │             │
 * │   │ 4  │ NULL         │ 0.0           │ 0.0             │             │
 * │   │ 5  │ 5.0          │ 0.0           │ 5.0             │             │
 * │   └────┴──────────────┴───────────────┴─────────────────┘             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    id, 
    hours_logged, 
    default_hours,
    COALESCE(hours_logged, default_hours) AS effective_hours
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────────┬───────────────┬─────────────────┐
 * │ id │ hours_logged │ default_hours │ effective_hours │
 * ├────┼──────────────┼───────────────┼─────────────────┤
 * │ 1  │ 5.0          │ 0.0           │ 5.0             │
 * │ 2  │ NULL         │ 0.0           │ 0.0             │
 * │ 3  │ 2.5          │ 0.0           │ 2.5             │
 * │ 4  │ NULL         │ 0.0           │ 0.0             │
 * │ 5  │ 5.0          │ 0.0           │ 5.0             │
 * └────┴──────────────┴───────────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Row 1: hours_logged = 5.0 (not NULL) → returns 5.0
 * - Row 2: hours_logged = NULL → returns default_hours = 0.0
 * - Row 3: hours_logged = 2.5 → returns 2.5
 * - Row 4: hours_logged = NULL → returns default_hours = 0.0
 * - Row 5: hours_logged = 5.0 → returns 5.0
 */

-- ============================================================================
-- 1.2 Multiple backups (priority list)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              COALESCE - Multiple Backups (Priority List)               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find first available email (priority: primary > work > personal)│
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id,                                                     │   │
 * │   │        COALESCE(primary_email, work_email, personal_email)      │   │
 * │   │        AS contact_email                                         │   │
 * │   │ FROM coalesce_demo                                              │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬─────────────────────┐                                        │
 * │   │ id │ contact_email       │                                        │
 * │   ├────┼─────────────────────┤                                        │
 * │   │ 1  │ aisha@company.com   │  (primary available)                  │
 * │   │ 2  │ rohan@company.com   │  (primary NULL, work available)        │
 * │   │ 3  │ meera@yahoo.com     │  (primary & work NULL, personal avail) │
 * │   │ 4  │ NULL                │  (all NULL)                           │
 * │   │ 5  │                     │  (empty string! NOT replaced)         │
 * │   └────┴─────────────────────┘                                        │
 * │                                                                          │
 * │   NOTE: Row 5 shows empty string because '' is NOT NULL!               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    id,
    COALESCE(primary_email, work_email, personal_email) AS contact_email
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┐
 * │ id │ contact_email       │
 * ├────┼─────────────────────┤
 * │ 1  │ aisha@company.com   │
 * │ 2  │ rohan@company.com   │
 * │ 3  │ meera@yahoo.com     │
 * │ 4  │ NULL                │
 * │ 5  │                     │  ← empty string (NOT replaced!)
 * └────┴─────────────────────┘
 */

-- ============================================================================
-- 1.3 COALESCE with default value (when all are NULL)
-- ============================================================================

SELECT 
    id,
    COALESCE(primary_email, work_email, personal_email, 'No Email Found') AS contact_info
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┐
 * │ id │ contact_info        │
 * ├────┼─────────────────────┤
 * │ 1  │ aisha@company.com   │
 * │ 2  │ rohan@company.com   │
 * │ 3  │ meera@yahoo.com     │
 * │ 4  │ No Email Found      │  ← default used
 * │ 5  │                     │  ← empty string (still NOT replaced!)
 * └────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Row 4: all emails NULL → returns default 'No Email Found'
 * - Row 5: primary_email is '' (empty string, not NULL) → returns ''
 */

-- ============================================================================
-- PART 2: IS NULL and IS NOT NULL (Filtering NULL values)
-- ============================================================================

/**
 * IS NULL and IS NOT NULL are used in WHERE clause to filter rows.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              IS NULL and IS NOT NULL - EXPLANATION                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ WHERE column IS NULL        -- Find rows where column is NULL   │   │
 * │   │ WHERE column IS NOT NULL    -- Find rows where column has value │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   CRITICAL: NEVER use = NULL                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ❌ WHERE column = NULL    ← Always returns FALSE!               │   │
 * │   │ ✅ WHERE column IS NULL   ← Correct way                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 2.1 Finding rows with NULL (IS NULL)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              IS NULL - Finding Missing Data                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find rows where ALL email fields are NULL                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id                                                        │   │
 * │   │ FROM coalesce_demo                                              │   │
 * │   │ WHERE primary_email IS NULL                                     │   │
 * │   │   AND work_email IS NULL                                        │   │
 * │   │   AND personal_email IS NULL;                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┐                                                              │
 * │   │ id │                                                              │
 * │   ├────┤                                                              │
 * │   │ 4  │                                                              │
 * │   └────┘                                                              │
 * │                                                                          │
 * │   EXPLANATION: Only row 4 has all three emails as NULL                 │
 * │   Row 5 has empty string in primary_email (NOT NULL!)                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find rows where all emails are NULL
SELECT id
FROM coalesce_demo
WHERE primary_email IS NULL 
  AND work_email IS NULL 
  AND personal_email IS NULL;

/**
 * OUTPUT:
 * ┌────┐
 * │ id │
 * ├────┤
 * │ 4  │
 * └────┘
 * 
 * EXPLANATION: Only row 4 has all three emails as NULL
 */

-- Find rows where hours_logged is NULL
SELECT id, hours_logged
FROM coalesce_demo
WHERE hours_logged IS NULL;

/**
 * OUTPUT:
 * ┌────┬──────────────┐
 * │ id │ hours_logged │
 * ├────┼──────────────┤
 * │ 2  │ NULL         │
 * │ 4  │ NULL         │
 * └────┴──────────────┘
 */

-- ============================================================================
-- 2.2 Finding rows without NULL (IS NOT NULL)
-- ============================================================================

-- Find rows that have at least one email
SELECT id, primary_email, work_email, personal_email
FROM coalesce_demo
WHERE primary_email IS NOT NULL 
   OR work_email IS NOT NULL 
   OR personal_email IS NOT NULL;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┬─────────────────────┬─────────────────┐
 * │ id │ primary_email       │ work_email          │ personal_email  │
 * ├────┼─────────────────────┼─────────────────────┼─────────────────┤
 * │ 1  │ aisha@company.com   │ NULL                │ aisha@gmail.com │
 * │ 2  │ NULL                │ rohan@company.com   │ NULL            │
 * │ 3  │ NULL                │ NULL                │ meera@yahoo.com │
 * │ 5  │                     │ NULL                │ raj@gmail.com   │
 * └────┴─────────────────────┴─────────────────────┴─────────────────┘
 * 
 * NOTE: Row 5 is included because empty string is NOT NULL!
 */

-- ============================================================================
-- 2.3 The "= NULL" Mistake (NEVER do this!)
-- ============================================================================

/**
 * ⚠️  CRITICAL: = NULL does NOT work!
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              The "= NULL" Mistake - NEVER DO THIS!                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT * FROM coalesce_demo WHERE hours_logged = NULL;           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   → Returns NO rows (even though there ARE NULLs!)                    │
 * │                                                                          │
 * │   WHY? In SQL, NULL = NULL is FALSE (not TRUE)                        │
 * │                                                                          │
 * │   ✅ CORRECT:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT * FROM coalesce_demo WHERE hours_logged IS NULL;         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │   → Returns rows with NULL hours_logged (ids 2 and 4)                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ WRONG - Returns no rows
SELECT * FROM coalesce_demo WHERE hours_logged = NULL;

-- ✅ CORRECT - Returns rows with NULL
SELECT * FROM coalesce_demo WHERE hours_logged IS NULL;

-- ============================================================================
-- PART 3: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Contact Priority List
 * 
 * Send automated alert using priority: primary > work > personal
 */

SELECT 
    id, 
    COALESCE(primary_email, work_email, personal_email, 'Manual Reachout') AS target_email
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┐
 * │ id │ target_email        │
 * ├────┼─────────────────────┤
 * │ 1  │ aisha@company.com   │
 * │ 2  │ rohan@company.com   │
 * │ 3  │ meera@yahoo.com     │
 * │ 4  │ Manual Reachout     │
 * │ 5  │                     │  ← empty string (not handled!)
 * └────┴─────────────────────┘
 */

-- Better: Handle empty string too
SELECT 
    id, 
    COALESCE(NULLIF(primary_email, ''), work_email, personal_email, 'Manual Reachout') AS target_email
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┐
 * │ id │ target_email        │
 * ├────┼─────────────────────┤
 * │ 1  │ aisha@company.com   │
 * │ 2  │ rohan@company.com   │
 * │ 3  │ meera@yahoo.com     │
 * │ 4  │ Manual Reachout     │
 * │ 5  │ raj@gmail.com       │  ← now uses personal email!
 * └────┴─────────────────────┘
 */

-- ============================================================================
-- SCENARIO 2: Safe Math with Default Values
-- ============================================================================

/**
 * PROBLEM: 5 + NULL = NULL (not 5!)
 * Calculate total hours, ensuring result is never NULL
 */

SELECT 
    id, 
    hours_logged,
    default_hours,
    COALESCE(hours_logged, 0) + COALESCE(default_hours, 0) AS total_hours
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────────┬───────────────┬─────────────┐
 * │ id │ hours_logged │ default_hours │ total_hours │
 * ├────┼──────────────┼───────────────┼─────────────┤
 * │ 1  │ 5.0          │ 0.0           │ 5.0         │
 * │ 2  │ NULL         │ 0.0           │ 0.0         │
 * │ 3  │ 2.5          │ 0.0           │ 2.5         │
 * │ 4  │ NULL         │ 0.0           │ 0.0         │
 * │ 5  │ 5.0          │ 0.0           │ 5.0         │
 * └────┴──────────────┴───────────────┴─────────────┘
 * 
 * EXPLANATION: NULLs treated as 0, so no NULL results
 */

-- ============================================================================
-- SCENARIO 3: Cleaning Data for Aggregation
-- ============================================================================

/**
 * PROBLEM: AVG ignores NULLs, which may not be what we want
 * Calculate average hours, treating NULLs as 0
 */

-- Regular AVG (ignores NULLs)
SELECT AVG(hours_logged) AS regular_avg FROM coalesce_demo;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ regular_avg │
 * ├─────────────┤
 * │ 4.166666667 │  (only rows 1,3,5 considered: (5+2.5+5)/3 = 4.17)
 * └─────────────┘
 */

-- Adjusted AVG (treats NULLs as 0)
SELECT AVG(COALESCE(hours_logged, 0)) AS adjusted_company_avg
FROM coalesce_demo;

/**
 * OUTPUT:
 * ┌─────────────────────┐
 * │ adjusted_company_avg │
 * ├─────────────────────┤
 * │ 2.5                 │  (all rows: (5+0+2.5+0+5)/5 = 2.5)
 * └─────────────────────┘
 * 
 * EXPLANATION: Now rows 2 and 4 are included with 0 value
 */

-- ============================================================================
-- SCENARIO 4: Identifying truly "Empty" Rows
-- ============================================================================

/**
 * Find rows where every single email field is missing (NULL)
 */

SELECT id
FROM coalesce_demo
WHERE primary_email IS NULL 
  AND work_email IS NULL 
  AND personal_email IS NULL;

/**
 * OUTPUT:
 * ┌────┐
 * │ id │
 * ├────┤
 * │ 4  │
 * └────┘
 * 
 * EXPLANATION: Only row 4 has all three emails as NULL
 * Row 5 has empty string (not NULL) so not included
 */

-- ============================================================================
-- SCENARIO 5: Advanced Cleanup with NULLIF
-- ============================================================================

/**
 * PROBLEM: COALESCE fails with empty strings
 * SOLUTION: Use NULLIF to convert empty strings to NULL first
 */

-- Without NULLIF (fails for row 5)
SELECT 
    id, 
    COALESCE(primary_email, work_email, personal_email) AS email
FROM coalesce_demo
WHERE id = 5;

/**
 * OUTPUT:
 * ┌────┬───────┐
 * │ id │ email │
 * ├────┼───────┤
 * │ 5  │       │  ← empty string!
 * └────┴───────┘
 */

-- With NULLIF (works correctly)
SELECT 
    id, 
    COALESCE(NULLIF(primary_email, ''), work_email, personal_email) AS cleaned_email
FROM coalesce_demo
WHERE id = 5;

/**
 * OUTPUT:
 * ┌────┬─────────────────┐
 * │ id │ cleaned_email   │
 * ├────┼─────────────────┤
 * │ 5  │ raj@gmail.com   │  ← now gets personal email!
 * └────┴─────────────────┘
 * 
 * EXPLANATION: 
 * 1. NULLIF converts '' to NULL
 * 2. COALESCE sees NULL and moves to work_email (NULL)
 * 3. Then moves to personal_email (raj@gmail.com)
 */

-- ============================================================================
-- PART 4: IS NULL vs IS NOT NULL vs COALESCE (When to use what)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHEN TO USE WHAT - COMPLETE GUIDE                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ USE IS NULL / IS NOT NULL when:                                    ││
 * │ │ → Filtering rows in WHERE clause                                   ││
 * │ │ → "Show me only rows with missing data"                            ││
 * │ │ → "Exclude rows with NULL values"                                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ USE COALESCE when:                                                  ││
 * │ │ → Replacing NULLs in SELECT output                                 ││
 * │ │ → "Show 'No Phone' instead of NULL"                                ││
 * │ │ → Providing fallback/default values                                ││
 * │ │ → Safe math calculations (5 + NULL should be 5)                     ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ USE NULLIF when:                                                    ││
 * │ │ → Converting specific values (empty string, zero) to NULL          ││
 * │ │ → "Treat empty string as missing"                                  ││
 * │ │ → Preventing division by zero                                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 5: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Using = NULL instead of IS NULL                            │
 * │                                                                          │
 * │   ❌ WHERE column = NULL    ← Always returns FALSE!                    │
 * │   ✅ WHERE column IS NULL   ← Correct                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Returns no rows
SELECT * FROM coalesce_demo WHERE hours_logged = NULL;

-- ✅ Returns rows with NULL
SELECT * FROM coalesce_demo WHERE hours_logged IS NULL;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Assuming COALESCE replaces empty strings                  │
 * │                                                                          │
 * │   ❌ COALESCE(column, 'default') → empty string NOT replaced!          │
 * │                                                                          │
 * │   ✅ COALESCE(NULLIF(column, ''), 'default') → works correctly         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Empty string NOT replaced
SELECT COALESCE('', 'default') AS result;  -- '' (empty string)

-- ✅ Empty string replaced
SELECT COALESCE(NULLIF('', ''), 'default') AS result;  -- 'default'

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Mixing data types in COALESCE                             │
 * │                                                                          │
 * │   ❌ COALESCE(column, 0, 'text') → different data types!               │
 * │                                                                          │
 * │   ✅ Keep all values same data type:                                   │
 * │      COALESCE(column, '0', 'text') or                                 │
 * │      COALESCE(CAST(column AS TEXT), '0', 'text')                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Performance issues in WHERE clause                         │
 * │                                                                          │
 * │   ❌ WHERE COALESCE(column, 0) > 100  (can't use index)                │
 * │                                                                          │
 * │   ✅ WHERE column > 100 OR column IS NULL  (may use index)             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 6: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: NULL is not zero, not empty string, not false                  │
 * │         → NULL means "unknown" or "missing"                            │
 * │                                                                          │
 * │ RULE 2: NEVER use = NULL                                               │
 * │         → Always use IS NULL or IS NOT NULL                            │
 * │                                                                          │
 * │ RULE 3: COALESCE returns first non-NULL value                          │
 * │         → Empty strings are NOT NULL (not replaced)                    │
 * │                                                                          │
 * │ RULE 4: NULLIF converts specific value to NULL                         │
 * │         → Use to convert empty strings or zero to NULL                 │
 * │                                                                          │
 * │ RULE 5: Complete pattern for handling empty strings:                   │
 * │         → COALESCE(NULLIF(column, ''), 'Default')                      │
 * │                                                                          │
 * │ RULE 6: Use IS NULL/IS NOT NULL for filtering (WHERE)                  │
 * │         → Use COALESCE for displaying (SELECT)                         │
 * │                                                                          │
 * │ RULE 7: AVG, SUM, COUNT(column) ignore NULLs                           │
 * │         → Use COALESCE to include them with a default value            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ IS NULL / IS NOT NULL:                                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ WHERE column IS NULL        → Find missing data                    ││
 * │ │ WHERE column IS NOT NULL    → Find data that exists                ││
 * │ │ WHERE column = NULL         → NEVER use this!                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COALESCE():                                                            │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ COALESCE(col, 'default')              → Single backup              ││
 * │ │ COALESCE(col1, col2, col3, 'default') → Priority list              ││
 * │ │ COALESCE(col, 0) + COALESCE(col2, 0)  → Safe math                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ NULLIF():                                                              │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ NULLIF(col, '')     → Convert empty string to NULL                 ││
 * │ │ NULLIF(col, 0)      → Convert zero to NULL                         ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Complete Pattern:                                                       │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ COALESCE(NULLIF(phone, ''), 'No Phone')                            ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Aggregation with NULLs:                                                 │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ AVG(COALESCE(hours, 0))     → Include NULLs as 0                   ││
 * │ │ COUNT(*)                    → Counts all rows (including NULL)     ││
 * │ │ COUNT(column)               → Counts non-NULL rows                 ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 8: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find rows where hours_logged is NULL
 * 
 * Answer:
 *   SELECT * FROM coalesce_demo WHERE hours_logged IS NULL;
 */

/**
 * EXERCISE 2: Replace NULL hours_logged with 0
 * 
 * Answer:
 *   SELECT id, COALESCE(hours_logged, 0) FROM coalesce_demo;
 */

/**
 * EXERCISE 3: Find first available email (priority: work > personal > primary)
 * 
 * Answer:
 *   SELECT id, COALESCE(work_email, personal_email, primary_email) 
 *   FROM coalesce_demo;
 */

/**
 * EXERCISE 4: Replace empty strings in primary_email with 'Missing'
 * 
 * Answer:
 *   SELECT id, COALESCE(NULLIF(primary_email, ''), 'Missing') 
 *   FROM coalesce_demo;
 */

/**
 * EXERCISE 5: Calculate total hours including NULLs as 0
 * 
 * Answer:
 *   SELECT id, COALESCE(hours_logged, 0) + COALESCE(default_hours, 0) 
 *   FROM coalesce_demo;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS coalesce_demo;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ IS NULL / IS NOT NULL:                                                 │
 * │ • Used in WHERE clause for filtering                                   │
 * │ • NEVER use = NULL                                                     │
 * │ • IS NULL finds missing data                                           │
 * │ • IS NOT NULL finds existing data                                      │
 * │                                                                          │
 * │ COALESCE():                                                            │
 * │ • Returns first non-NULL value                                         │
 * │ • Used in SELECT for displaying clean data                             │
 * │ • Can have 2+ arguments (priority list)                                │
 * │ • Does NOT replace empty strings                                       │
 * │                                                                          │
 * │ NULLIF():                                                              │
 * │ • Converts specific value to NULL                                      │
 * │ • Use to convert empty strings to NULL                                 │
 * │ • Use to convert zero to NULL                                          │
 * │                                                                          │
 * │ Complete formula for handling empty strings:                           │
 * │ COALESCE(NULLIF(column, ''), 'Default Value')                          │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │ - NULL is not zero or empty string                                     │
 * │ - Use IS NULL, not = NULL                                              │
 * │ - COALESCE for display, IS NULL for filtering                          │
 * │ - Use NULLIF to convert empty strings to NULL                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF COALESCE AND NULL HANDLING REVISION GUIDE
-- ============================================================================