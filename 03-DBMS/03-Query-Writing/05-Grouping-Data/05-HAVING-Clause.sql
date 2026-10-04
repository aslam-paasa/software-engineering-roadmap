/**
 * ============================================================================
 * HAVING CLAUSE - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS HAVING? ---------------------- (Filter groups after aggregation)
 * 2. HAVING vs WHERE ---------------------- (Key differences)
 * 3. HAVING WITH COUNT -------------------- (Filter by number of rows)
 * 4. HAVING WITH SUM ---------------------- (Filter by total values)
 * 5. HAVING WITH AVG ---------------------- (Filter by average values)
 * 6. HAVING WITH MIN/MAX ------------------ (Filter by smallest/largest)
 * 7. HAVING WITH MULTIPLE CONDITIONS ------ (AND, OR combinations)
 * 8. HAVING WITH WHERE -------------------- (Filter rows THEN filter groups)
 * 9. REAL-WORLD SCENARIOS ----------------- (Practical examples)
 * 10. COMMON MISTAKES --------------------- (What to avoid)
 * 11. QUICK REFERENCE --------------------- (Cheat sheet)
 * 12. GOLDEN RULES ------------------------ (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLE FOR ALL EXAMPLES
-- ============================================================================

/**
 * EMPLOYEES TABLE - Company employee data
 * 
 * ┌────────┬───────────────┬─────────┬───────────────────┬──────────────┬───────────┐
 * │ emp_id │ employee_name │ project │ years_experience  │ hours_logged │ role      │
 * ├────────┼───────────────┼─────────┼───────────────────┼──────────────┼───────────┤
 * │    1   │ Alice         │ Alpha   │ 3.0               │ 100          │ Developer │
 * │    2   │ Bob           │ Alpha   │ 5.0               │ 120          │ QA        │
 * │    3   │ Carol         │ Alpha   │ 7.0               │ 105          │ Developer │
 * │    4   │ Dave          │ Alpha   │ NULL              │ 0            │ Manager   │
 * │    5   │ Eve           │ Beta    │ 2.0               │ 80           │ Manager   │
 * │    6   │ Frank         │ Beta    │ 3.0               │ 110          │ Developer │
 * │    7   │ Grace         │ Beta    │ 4.0               │ 130          │ Developer │
 * │    8   │ Hank          │ Beta    │ 3.0               │ NULL         │ Developer │
 * │    9   │ Heidi         │ Gamma   │ 5.0               │ 150          │ Developer │
 * │   10   │ Ivan          │ Gamma   │ 6.0               │ 140          │ QA        │
 * └────────┴───────────────┴─────────┴───────────────────┴──────────────┴───────────┘
 */

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
-- PART 1: WHAT IS HAVING?
-- ============================================================================

/**
 * HAVING filters groups AFTER aggregation (GROUP BY).
 * WHERE filters rows BEFORE grouping.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS HAVING?                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   HAVING is like WHERE, but for GROUPS instead of individual rows.     │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                    │
 *   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   You have a list of students with their test scores.             │   │
 * │                                                                  │   │
 * │   WHERE: "Find students who scored above 80%"                    │   │
 * │          → Filters individual students                           │   │
 * │                                                                  │   │
 * │   GROUP BY + HAVING: "Find classes where average score is > 80%" │   │
 * │          → First group students by class                         │   │
 * │          → Calculate average per class                           │   │
 * │          → Then filter classes                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXECUTION ORDER:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. FROM      → Get all rows                                    │   │
 * │   │ 2. WHERE     → Filter individual rows (BEFORE grouping)        │   │
 * │   │ 3. GROUP BY  → Create groups                                   │   │
 * │   │ 4. HAVING    → Filter groups (AFTER aggregation)               │   │
 * │   │ 5. SELECT    → Choose columns to show                          │   │
 * │   │ 6. ORDER BY  → Sort results                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HAVING - SIMPLE EXAMPLE                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours               │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING SUM(hours_logged) > 300;                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: GROUP BY project (create buckets)                            │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice: 100      │  │ Eve: 80         │  │ Heidi: 150      │        │
 * │   │ Bob: 120        │  │ Frank: 110      │  │ Ivan: 140       │        │
 * │   │ Carol: 105      │  │ Grace: 130      │  │                 │        │
 * │   │ Dave: 0         │  │ Hank: NULL      │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 2: Calculate SUM for each bucket                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 100+120+105+0 = 325                                     │   │
 * │   │ Beta:  80+110+130 = 320 (NULL ignored)                         │   │
 * │   │ Gamma: 150+140 = 290                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 3: Apply HAVING filter (keep groups with SUM > 300)             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 325 > 300 ✅ → KEEP                                      │   │
 * │   │ Beta:  320 > 300 ✅ → KEEP                                      │   │
 * │   │ Gamma: 290 > 300 ❌ → REMOVE                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────────┐                                           │
 * │   │ project │ total_hours │                                           │
 * │   ├─────────┼─────────────┤                                           │
 * │   │ Alpha   │ 325         │                                           │
 * │   │ Beta    │ 320         │                                           │
 * │   └─────────┴─────────────┘                                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: HAVING vs WHERE (Key differences)
-- ============================================================================

/**
 * WHERE vs HAVING - COMPARISON:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                      WHERE vs HAVING                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    WHERE                                        │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied BEFORE GROUP BY                                   │   │
 * │   │ WHAT: Filters INDIVIDUAL ROWS                                   │   │
 * │   │ CAN USE: Regular columns only (NOT aggregates)                  │   │
 * │   │ EXAMPLE: WHERE role = 'Developer'                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    HAVING                                       │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied AFTER GROUP BY                                    │   │
 * │   │ WHAT: Filters GROUPS (buckets)                                  │   │
 * │   │ CAN USE: Aggregate functions (COUNT, SUM, AVG, etc.)            │   │
 * │   │ EXAMPLE: HAVING COUNT(*) > 2                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * VISUAL COMPARISON:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                                                                          │
 * │   WHERE (Filters rows before grouping)                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ All 10 rows → WHERE role='Developer' → 6 rows → GROUP BY       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HAVING (Filters groups after grouping)                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ All 10 rows → GROUP BY → 3 groups → HAVING COUNT>=3 → 2 groups │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE: Compare WHERE vs HAVING
-- WHERE filters rows BEFORE grouping
SELECT 
    project,
    COUNT(*) AS employee_count
FROM employees
WHERE role = 'Developer'  -- Only count Developers
GROUP BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┐
 * │ project │ employee_count  │
 * ├─────────┼─────────────────┤
 * │ Alpha   │ 2               │
 * │ Beta    │ 3               │
 * │ Gamma   │ 1               │
 * └─────────┴─────────────────┘
 */

-- HAVING filters groups AFTER grouping
SELECT 
    project,
    COUNT(*) AS employee_count
FROM employees
GROUP BY project
HAVING COUNT(*) >= 3;  -- Only projects with 3+ employees

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┐
 * │ project │ employee_count  │
 * ├─────────┼─────────────────┤
 * │ Alpha   │ 4               │
 * │ Beta    │ 4               │
 * └─────────┴─────────────────┘
 */

-- You can use BOTH together
SELECT 
    project,
    COUNT(*) AS developer_count
FROM employees
WHERE role = 'Developer'        -- First: filter to Developers only
GROUP BY project                 -- Second: group by project
HAVING COUNT(*) >= 2;           -- Third: keep projects with 2+ Developers

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┐
 * │ project │ developer_count │
 * ├─────────┼─────────────────┤
 * │ Alpha   │ 2               │
 * │ Beta    │ 3               │
 * └─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * 1. WHERE keeps only Developer rows (6 rows)
 * 2. GROUP BY creates buckets: Alpha(2), Beta(3), Gamma(1)
 * 3. HAVING keeps buckets with count >= 2: Alpha and Beta
 */

-- ============================================================================
-- PART 3: HAVING WITH COUNT
-- ============================================================================

/**
 * Filter groups by number of rows in each group.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HAVING WITH COUNT                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) AS team_size                          │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING COUNT(*) >= 3;                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: GROUP BY project                                             │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA: 4 rows   │  │ BETA: 4 rows    │  │ GAMMA: 2 rows   │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 2: Apply HAVING (keep groups with >=3 rows)                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 4 >= 3 ✅ → KEEP                                         │   │
 * │   │ Beta:  4 >= 3 ✅ → KEEP                                         │   │
 * │   │ Gamma: 2 >= 3 ❌ → REMOVE                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬────────────┐                                            │
 * │   │ project │ team_size  │                                            │
 * │   ├─────────┼────────────┤                                            │
 * │   │ Alpha   │ 4          │                                            │
 * │   │ Beta    │ 4          │                                            │
 * │   └─────────┴────────────┘                                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Projects with team size >= 3
SELECT 
    project,
    COUNT(*) AS team_size
FROM employees
GROUP BY project
HAVING COUNT(*) >= 3
ORDER BY team_size DESC;

/**
 * OUTPUT:
 * ┌─────────┬────────────┐
 * │ project │ team_size  │
 * ├─────────┼────────────┤
 * │ Alpha   │ 4          │
 * │ Beta    │ 4          │
 * └─────────┴────────────┘
 */

-- EXAMPLE 2: Roles with more than 2 employees
SELECT 
    role,
    COUNT(*) AS employee_count
FROM employees
GROUP BY role
HAVING COUNT(*) > 2
ORDER BY employee_count DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────────────┐
 * │ role      │ employee_count  │
 * ├───────────┼─────────────────┤
 * │ Developer │ 5               │
 * └───────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Developer: 5 employees → kept
 * - Manager: 2 employees → excluded
 * - QA: 2 employees → excluded
 */

-- EXAMPLE 3: Projects with at least 2 Developers
SELECT 
    project,
    COUNT(*) AS developer_count
FROM employees
WHERE role = 'Developer'
GROUP BY project
HAVING COUNT(*) >= 2;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┐
 * │ project │ developer_count │
 * ├─────────┼─────────────────┤
 * │ Alpha   │ 2               │
 * │ Beta    │ 3               │
 * └─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - WHERE filters to Developers first
 * - GROUP BY project
 * - HAVING keeps projects with at least 2 Developers
 * - Gamma has only 1 Developer → excluded
 */

-- ============================================================================
-- PART 4: HAVING WITH SUM
-- ============================================================================

/**
 * Filter groups by total of a numeric column.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HAVING WITH SUM                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, SUM(hours_logged) AS total_hours               │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING SUM(hours_logged) > 300;                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: GROUP BY project and calculate SUM                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 100+120+105+0 = 325                                     │   │
 * │   │ Beta:  80+110+130 = 320 (Hank NULL ignored)                    │   │
 * │   │ Gamma: 150+140 = 290                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Apply HAVING (keep groups with SUM > 300)                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 325 > 300 ✅ → KEEP                                      │   │
 * │   │ Beta:  320 > 300 ✅ → KEEP                                      │   │
 * │   │ Gamma: 290 > 300 ❌ → REMOVE                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────────┐                                           │
 * │   │ project │ total_hours │                                           │
 * │   ├─────────┼─────────────┤                                           │
 * │   │ Alpha   │ 325         │                                           │
 * │   │ Beta    │ 320         │                                           │
 * │   └─────────┴─────────────┘                                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Projects with total hours > 300
SELECT 
    project,
    SUM(hours_logged) AS total_hours,
    COUNT(*) AS team_size
FROM employees
GROUP BY project
HAVING SUM(hours_logged) > 300
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬───────────┐
 * │ project │ total_hours │ team_size │
 * ├─────────┼─────────────┼───────────┤
 * │ Alpha   │ 325         │ 4         │
 * │ Beta    │ 320         │ 4         │
 * └─────────┴─────────────┴───────────┘
 */

-- EXAMPLE 2: Roles with total hours > 200
SELECT 
    role,
    SUM(hours_logged) AS total_hours,
    COUNT(*) AS employee_count
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY role
HAVING SUM(hours_logged) > 200
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────────┬─────────────────┐
 * │ role      │ total_hours │ employee_count  │
 * ├───────────┼─────────────┼─────────────────┤
 * │ Developer │ 595         │ 5               │
 * │ QA        │ 260         │ 2               │
 * └───────────┴─────────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Developer total = 595 > 200 → kept
 * - QA total = 260 > 200 → kept
 * - Manager total = 80 < 200 → excluded
 */

-- EXAMPLE 3: Projects with total hours less than 300
SELECT 
    project,
    SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project
HAVING SUM(hours_logged) < 300;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ project │ total_hours │
 * ├─────────┼─────────────┤
 * │ Gamma   │ 290         │
 * └─────────┴─────────────┘
 */

-- ============================================================================
-- PART 5: HAVING WITH AVG
-- ============================================================================

/**
 * Filter groups by average of a numeric column.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HAVING WITH AVG                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, AVG(years_experience) AS avg_exp               │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE years_experience IS NOT NULL                              │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING AVG(years_experience) >= 4;                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: WHERE excludes NULL experiences (Dave removed)               │
 * │                                                                          │
 * │   STEP 2: GROUP BY project and calculate AVG                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: (3+5+7)/3 = 5.0                                         │   │
 * │   │ Beta:  (2+3+4+3)/4 = 3.0                                       │   │
 * │   │ Gamma: (5+6)/2 = 5.5                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 3: Apply HAVING (keep groups with AVG >= 4)                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 5.0 >= 4 ✅ → KEEP                                       │   │
 * │   │ Beta:  3.0 >= 4 ❌ → REMOVE                                     │   │
 * │   │ Gamma: 5.5 >= 4 ✅ → KEEP                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────┐                                               │
 * │   │ project │ avg_exp │                                               │
 * │   ├─────────┼─────────┤                                               │
 * │   │ Alpha   │ 5.0     │                                               │
 * │   │ Gamma   │ 5.5     │                                               │
 * │   └─────────┴─────────┘                                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Projects with average experience >= 4 years
SELECT 
    project,
    ROUND(AVG(years_experience), 1) AS avg_exp,
    COUNT(*) AS employee_count
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING AVG(years_experience) >= 4
ORDER BY avg_exp DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────────────┐
 * │ project │ avg_exp │ employee_count  │
 * ├─────────┼─────────┼─────────────────┤
 * │ Gamma   │ 5.5     │ 2               │
 * │ Alpha   │ 5.0     │ 3               │
 * └─────────┴─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Gamma average = 5.5 ≥ 4 → kept
 * - Alpha average = 5.0 ≥ 4 → kept
 * - Beta average = 3.0 < 4 → excluded
 */

-- EXAMPLE 2: Roles with average hours > 100
SELECT 
    role,
    ROUND(AVG(hours_logged), 1) AS avg_hours,
    COUNT(*) AS employee_count,
    SUM(hours_logged) AS total_hours
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY role
HAVING AVG(hours_logged) > 100
ORDER BY avg_hours DESC;

/**
 * OUTPUT:
 * ┌───────────┬───────────┬─────────────────┬─────────────┐
 * │ role      │ avg_hours │ employee_count  │ total_hours │
 * ├───────────┼───────────┼─────────────────┼─────────────┤
 * │ QA        │ 130.0     │ 2               │ 260         │
 * │ Developer │ 119.0     │ 5               │ 595         │
 * └───────────┴───────────┴─────────────────┴─────────────┘
 * 
 * EXPLANATION:
 * - QA average = 130 > 100 → kept
 * - Developer average = 119 > 100 → kept
 * - Manager average = 40 < 100 → excluded
 */

-- ============================================================================
-- PART 6: HAVING WITH MIN/MAX
-- ============================================================================

/**
 * Filter groups by minimum or maximum values.
 */

-- EXAMPLE 1: Projects where minimum experience < 3 years
SELECT 
    project,
    MIN(years_experience) AS min_exp,
    MAX(years_experience) AS max_exp,
    COUNT(*) AS team_size
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING MIN(years_experience) < 3
ORDER BY min_exp;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────┬───────────┐
 * │ project │ min_exp │ max_exp │ team_size │
 * ├─────────┼─────────┼─────────┼───────────┤
 * │ Beta    │ 2.0     │ 4.0     │ 4         │
 * └─────────┴─────────┴─────────┴───────────┘
 * 
 * EXPLANATION:
 * - Beta has min experience 2.0 (<3) → kept
 * - Alpha min = 3.0 (not <3) → excluded
 * - Gamma min = 5.0 (not <3) → excluded
 */

-- EXAMPLE 2: Projects where maximum hours < 150
SELECT 
    project,
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY project
HAVING MAX(hours_logged) < 150
ORDER BY max_hours;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬───────────┐
 * │ project │ min_hours │ max_hours │
 * ├─────────┼───────────┼───────────┤
 * │ Beta    │ 80        │ 130       │
 * │ Alpha   │ 0         │ 120       │
 * └─────────┴───────────┴───────────┘
 * 
 * EXPLANATION:
 * - Beta max = 130 (<150) → kept
 * - Alpha max = 120 (<150) → kept
 * - Gamma max = 150 (not <150) → excluded
 */

-- ============================================================================
-- PART 7: HAVING WITH MULTIPLE CONDITIONS (AND, OR)
-- ============================================================================

/**
 * Use AND, OR to combine multiple conditions in HAVING.
 */

-- EXAMPLE 1: Projects with team size >= 3 AND total hours > 300
SELECT 
    project,
    COUNT(*) AS team_size,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_exp
FROM employees
GROUP BY project
HAVING COUNT(*) >= 3 AND SUM(hours_logged) > 300
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┬─────────┐
 * │ project │ team_size │ total_hours │ avg_exp │
 * ├─────────┼───────────┼─────────────┼─────────┤
 * │ Alpha   │ 4         │ 325         │ 5.0     │
 * │ Beta    │ 4         │ 320         │ 3.0     │
 * └─────────┴───────────┴─────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Both Alpha and Beta satisfy BOTH conditions
 * - Gamma has team_size=2 (fails first condition)
 */

-- EXAMPLE 2: Projects with avg_exp > 4 OR total_hours > 300
SELECT 
    project,
    ROUND(AVG(years_experience), 1) AS avg_exp,
    SUM(hours_logged) AS total_hours
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING AVG(years_experience) > 4 OR SUM(hours_logged) > 300
ORDER BY avg_exp DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────────┐
 * │ project │ avg_exp │ total_hours │
 * ├─────────┼─────────┼─────────────┤
 * │ Gamma   │ 5.5     │ 290         │
 * │ Alpha   │ 5.0     │ 325         │
 * │ Beta    │ 3.0     │ 320         │
 * └─────────┴─────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Gamma: avg_exp > 4 (true) → kept
 * - Alpha: avg_exp > 4 (true) → kept
 * - Beta: total_hours > 300 (true) → kept
 * - All projects satisfy at least one condition
 */

-- EXAMPLE 3: Projects with team_size between 2 and 3
SELECT 
    project,
    COUNT(*) AS team_size,
    SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project
HAVING COUNT(*) BETWEEN 2 AND 3
ORDER BY team_size;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┐
 * │ project │ team_size │ total_hours │
 * ├─────────┼───────────┼─────────────┤
 * │ Gamma   │ 2         │ 290         │
 * └─────────┴───────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Gamma has 2 members (between 2 and 3) → kept
 * - Alpha and Beta have 4 members → excluded
 */

-- ============================================================================
-- PART 8: HAVING WITH WHERE (Filter rows THEN filter groups)
-- ============================================================================

/**
 * Use WHERE to filter individual rows before grouping.
 * Use HAVING to filter groups after aggregation.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HAVING WITH WHERE                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) AS developer_count                    │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE role = 'Developer'                                        │   │
 * │   │ GROUP BY project                                                │   │
 * │   │ HAVING COUNT(*) >= 2;                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: WHERE filters to only Developers                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Developers: Alice, Carol, Frank, Grace, Hank, Heidi (6 rows)   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: GROUP BY project on remaining rows                          │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA: 2        │  │ BETA: 3         │  │ GAMMA: 1        │        │
 * │   │ (Alice, Carol)  │  │ (Frank, Grace,  │  │ (Heidi)         │        │
 * │   │                 │  │  Hank)          │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 3: Apply HAVING (keep groups with >=2 Developers)               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 2 >= 2 ✅ → KEEP                                         │   │
 * │   │ Beta:  3 >= 2 ✅ → KEEP                                         │   │
 * │   │ Gamma: 1 >= 2 ❌ → REMOVE                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────────────┐                                       │
 * │   │ project │ developer_count │                                       │
 * │   ├─────────┼─────────────────┤                                       │
 * │   │ Alpha   │ 2               │                                       │
 * │   │ Beta    │ 3               │                                       │
 * │   └─────────┴─────────────────┘                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE: Projects with at least 2 active employees (hours > 0)
SELECT 
    project,
    COUNT(*) AS active_employees,
    SUM(hours_logged) AS total_hours
FROM employees
WHERE hours_logged > 0 AND hours_logged IS NOT NULL
GROUP BY project
HAVING COUNT(*) >= 2
ORDER BY active_employees DESC;

/**
 * OUTPUT:
 * ┌─────────┬──────────────────┬─────────────┐
 * │ project │ active_employees │ total_hours │
 * ├─────────┼──────────────────┼─────────────┤
 * │ Beta    │ 3                │ 320         │
 * │ Alpha   │ 3                │ 325         │
 * │ Gamma   │ 2                │ 290         │
 * └─────────┴──────────────────┴─────────────┘
 * 
 * EXPLANATION:
 * - WHERE filters to employees with hours > 0
 * - Dave (0 hours) and Hank (NULL) are excluded
 * - GROUP BY project
 * - HAVING keeps projects with at least 2 active employees
 * - All projects qualify (Alpha:3, Beta:3, Gamma:2)
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Identify Large Teams for Budget Review
 * 
 * Find projects with more than 3 employees for quarterly budget review.
 */

SELECT 
    project,
    COUNT(*) AS team_size,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_experience,
    COUNT(CASE WHEN role = 'Manager' THEN 1 END) AS managers
FROM employees
GROUP BY project
HAVING COUNT(*) > 3
ORDER BY team_size DESC;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┬────────────────┬──────────┐
 * │ project │ team_size │ total_hours │ avg_experience │ managers │
 * ├─────────┼───────────┼─────────────┼────────────────┼──────────┤
 * │ Alpha   │ 4         │ 325         │ 5.0            │ 1        │
 * │ Beta    │ 4         │ 320         │ 3.0            │ 1        │
 * └─────────┴───────────┴─────────────┴────────────────┴──────────┘
 */

/**
 * SCENARIO 2: High Performance Teams
 * 
 * Find projects with average experience > 4 years AND total hours > 300.
 */

SELECT 
    project,
    ROUND(AVG(years_experience), 1) AS avg_exp,
    SUM(hours_logged) AS total_hours,
    COUNT(*) AS team_size
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING AVG(years_experience) > 4 AND SUM(hours_logged) > 300
ORDER BY avg_exp DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────────┬───────────┐
 * │ project │ avg_exp │ total_hours │ team_size │
 * ├─────────┼─────────┼─────────────┼───────────┤
 * │ Alpha   │ 5.0     │ 325         │ 4         │
 * └─────────┴─────────┴─────────────┴───────────┘
 * 
 * EXPLANATION:
 * - Gamma avg_exp=5.5 but total_hours=290 (<300) → excluded
 * - Beta total_hours=320 but avg_exp=3.0 (<4) → excluded
 * - Alpha satisfies both conditions → kept
 */

/**
 * SCENARIO 3: Understaffed Projects
 * 
 * Find projects with less than 3 employees that need hiring.
 */

SELECT 
    project,
    COUNT(*) AS team_size,
    STRING_AGG(role, ', ') AS roles
FROM employees
GROUP BY project
HAVING COUNT(*) < 3
ORDER BY team_size;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────────┐
 * │ project │ team_size │ roles           │
 * ├─────────┼───────────┼─────────────────┤
 * │ Gamma   │ 2         │ Developer, QA   │
 * └─────────┴───────────┴─────────────────┘
 */

/**
 * SCENARIO 4: Workload Alert
 * 
 * Find roles where average hours exceed 120 (potential burnout risk).
 */

SELECT 
    role,
    COUNT(*) AS employee_count,
    ROUND(AVG(hours_logged), 1) AS avg_hours,
    SUM(hours_logged) AS total_hours,
    MAX(hours_logged) AS max_hours
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY role
HAVING AVG(hours_logged) > 120
ORDER BY avg_hours DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┬───────────┬─────────────┬───────────┐
 * │ role    │ employee_count  │ avg_hours │ total_hours │ max_hours │
 * ├─────────┼─────────────────┼───────────┼─────────────┼───────────┤
 * │ QA      │ 2               │ 130.0     │ 260         │ 140       │
 * └─────────┴─────────────────┴───────────┴─────────────┴───────────┘
 * 
 * EXPLANATION:
 * - QA average = 130 > 120 → alert
 * - Developer average = 119 < 120 → no alert
 * - Manager average = 40 < 120 → no alert
 */

/**
 * SCENARIO 5: Department Diversity Report
 * 
 * Find projects that have at least 2 different roles.
 */

SELECT 
    project,
    COUNT(DISTINCT role) AS distinct_roles,
    STRING_AGG(DISTINCT role, ', ' ORDER BY role) AS role_list,
    COUNT(*) AS total_employees
FROM employees
GROUP BY project
HAVING COUNT(DISTINCT role) >= 2
ORDER BY distinct_roles DESC, project;

/**
 * OUTPUT:
 * ┌─────────┬────────────────┬─────────────────────────┬─────────────────┐
 * │ project │ distinct_roles │ role_list               │ total_employees │
 * ├─────────┼────────────────┼─────────────────────────┼─────────────────┤
 * │ Alpha   │ 3              │ Developer, Manager, QA  │ 4               │
 * │ Beta    │ 2              │ Developer, Manager      │ 4               │
 * │ Gamma   │ 2              │ Developer, QA           │ 2               │
 * └─────────┴────────────────┴─────────────────────────┴─────────────────┘
 */

/**
 * SCENARIO 6: Experience Gap Analysis
 * 
 * Find projects with experience gap (max - min) greater than 3 years.
 */

SELECT 
    project,
    MIN(years_experience) AS min_exp,
    MAX(years_experience) AS max_exp,
    MAX(years_experience) - MIN(years_experience) AS experience_gap,
    COUNT(*) AS team_size
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
HAVING MAX(years_experience) - MIN(years_experience) > 3
ORDER BY experience_gap DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────┬─────────────────┬───────────┐
 * │ project │ min_exp │ max_exp │ experience_gap  │ team_size │
 * ├─────────┼─────────┼─────────┼─────────────────┼───────────┤
 * │ Alpha   │ 3.0     │ 7.0     │ 4.0             │ 3         │
 * └─────────┴─────────┴─────────┴─────────────────┴───────────┘
 * 
 * EXPLANATION:
 * - Alpha gap = 4.0 > 3 → kept
 * - Beta gap = 2.0 < 3 → excluded
 * - Gamma gap = 1.0 < 3 → excluded
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Using HAVING without GROUP BY                              │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT COUNT(*) FROM employees HAVING COUNT(*) > 5;                  │
 * │   → HAVING without GROUP BY works but is confusing                     │
 * │                                                                          │
 * │   ✅ CORRECT: Use WHERE for single row conditions:                      │
 * │   SELECT COUNT(*) FROM employees WHERE ...;                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- HAVING without GROUP BY (works but not common)
SELECT COUNT(*) AS total FROM employees HAVING COUNT(*) > 5;
-- Better to use WHERE if not grouping

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Using column aliases in HAVING                             │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT project, COUNT(*) AS team_size                                │
 * │   FROM employees                                                       │
 * │   GROUP BY project                                                     │
 * │   HAVING team_size > 3;  ← ERROR! Can't use alias                      │
 * │                                                                          │
 * │   ✅ CORRECT: Use the aggregate function directly:                      │
 * │   SELECT project, COUNT(*) AS team_size                                │
 * │   FROM employees                                                       │
 * │   GROUP BY project                                                     │
 * │   HAVING COUNT(*) > 3;                                                 │
 * │                                                                          │
 * │   WHY? HAVING executes BEFORE SELECT, so aliases don't exist yet.      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- This will cause an error in most databases
-- SELECT project, COUNT(*) AS team_size FROM employees GROUP BY project HAVING team_size > 3;

-- Correct way
SELECT 
    project, 
    COUNT(*) AS team_size
FROM employees
GROUP BY project
HAVING COUNT(*) > 3;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using non-aggregated columns in HAVING                     │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT project, COUNT(*)                                             │
 * │   FROM employees                                                       │
 * │   GROUP BY project                                                     │
 * │   HAVING employee_name = 'Alice';  ← ERROR! Not in GROUP BY            │
 * │                                                                          │
 * │   ✅ CORRECT: Put non-aggregated conditions in WHERE:                   │
 * │   SELECT project, COUNT(*)                                             │
 * │   FROM employees                                                       │
 * │   WHERE employee_name = 'Alice'                                        │
 * │   GROUP BY project;                                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 11: QUICK REFERENCE (Cheat sheet)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE - CHEAT SHEET                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ BASIC HAVING SYNTAX:                                                    │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ SELECT column, AGGREGATE(column)                                   │ │
 * │ │ FROM table                                                          │ │
 * │ │ GROUP BY column                                                     │ │
 * │ │ HAVING AGGREGATE(column) condition;                                 │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COMMON HAVING CONDITIONS:                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Filter by count                                                 │ │
 * │ │ HAVING COUNT(*) > 5                                                │ │
 * │ │                                                                     │ │
 * │ │ -- Filter by sum                                                   │ │
 * │ │ HAVING SUM(amount) > 1000                                          │ │
 * │ │                                                                     │ │
 * │ │ -- Filter by average                                               │ │
 * │ │ HAVING AVG(score) >= 80                                            │ │
 * │ │                                                                     │ │
 * │ │ -- Filter by min/max                                               │ │
 * │ │ HAVING MAX(price) < 500                                            │ │
 * │ │                                                                     │ │
 * │ │ -- Multiple conditions                                             │ │
 * │ │ HAVING COUNT(*) > 3 AND SUM(amount) > 5000                         │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ WHERE vs HAVING QUICK GUIDE:                                            │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ Use WHERE when:  Filtering individual rows                         │ │
 * │ │                  Condition doesn't use aggregates                  │ │
 * │ │                  Example: WHERE role = 'Developer'                 │ │
 * │ │                                                                     │ │
 * │ │ Use HAVING when: Filtering groups after aggregation                │ │
 * │ │                   Condition uses aggregate functions               │ │
 * │ │                   Example: HAVING COUNT(*) > 2                     │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ EXECUTION ORDER:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ 1. FROM      → Get all rows                                        │ │
 * │ │ 2. WHERE     → Filter individual rows (BEFORE grouping)            │ │
 * │ │ 3. GROUP BY  → Create groups                                       │ │
 * │ │ 4. HAVING    → Filter groups (AFTER aggregation)                   │ │
 * │ │ 5. SELECT    → Choose columns to show                              │ │
 * │ │ 6. ORDER BY  → Sort final results                                  │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find projects with more than 3 employees
 * 
 * Answer:
 *   SELECT project, COUNT(*) AS team_size
 *   FROM employees
 *   GROUP BY project
 *   HAVING COUNT(*) > 3;
 */

/**
 * EXERCISE 2: Find roles with average experience greater than 4 years
 * 
 * Answer:
 *   SELECT role, AVG(years_experience) AS avg_exp
 *   FROM employees
 *   WHERE years_experience IS NOT NULL
 *   GROUP BY role
 *   HAVING AVG(years_experience) > 4;
 */

/**
 * EXERCISE 3: Find projects with total hours between 300 and 350
 * 
 * Answer:
 *   SELECT project, SUM(hours_logged) AS total_hours
 *   FROM employees
 *   GROUP BY project
 *   HAVING SUM(hours_logged) BETWEEN 300 AND 350;
 */

/**
 * EXERCISE 4: Find projects where the most experienced person has > 6 years
 * 
 * Answer:
 *   SELECT project, MAX(years_experience) AS max_exp
 *   FROM employees
 *   WHERE years_experience IS NOT NULL
 *   GROUP BY project
 *   HAVING MAX(years_experience) > 6;
 */

/**
 * EXERCISE 5: Find projects with at least 2 different roles
 * 
 * Answer:
 *   SELECT project, COUNT(DISTINCT role) AS role_count
 *   FROM employees
 *   GROUP BY project
 *   HAVING COUNT(DISTINCT role) >= 2;
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
 * │ 1. HAVING filters groups AFTER aggregation (GROUP BY)                  │
 * │                                                                          │
 * │ 2. WHERE filters rows BEFORE grouping                                  │
 * │                                                                          │
 * │ 3. HAVING can use aggregate functions:                                 │
 * │    → COUNT(), SUM(), AVG(), MIN(), MAX()                               │
 * │                                                                          │
 * │ 4. WHERE cannot use aggregate functions                                │
 * │                                                                          │
 * │ 5. Common HAVING patterns:                                              │
 * │    → HAVING COUNT(*) > value     (groups with more than X rows)        │
 * │    → HAVING SUM(column) > value  (groups with total > X)               │
 * │    → HAVING AVG(column) > value  (groups with average > X)             │
 * │    → HAVING MIN(column) > value  (groups where smallest > X)           │
 * │    → HAVING MAX(column) < value  (groups where largest < X)            │
 * │                                                                          │
 * │ 6. You can use AND/OR for multiple conditions in HAVING                │
 * │                                                                          │
 * │ 7. You can use WHERE and HAVING together:                              │
 * │    → WHERE filters rows first                                          │
 * │    → GROUP BY groups the remaining rows                                │
 * │    → HAVING filters the groups                                         │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - HAVING without GROUP BY works but is rare                          │
 * │   - Cannot use column aliases in HAVING                                │
 * │   - Use WHERE for row-level filters                                    │
 * │   - Use HAVING for group-level filters                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF HAVING CLAUSE GUIDE
-- ============================================================================