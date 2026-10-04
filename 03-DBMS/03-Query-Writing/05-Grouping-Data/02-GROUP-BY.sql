/**
 * ============================================================================
 * GROUP BY - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS GROUP BY? -------------------- (The bucket mental model)
 * 2. BASIC GROUPING ----------------------- (Listing unique values)
 * 3. GROUP BY WITH AGGREGATES ------------- (COUNT, SUM, AVG, MIN, MAX)
 * 4. MULTI-COLUMN GROUPING ---------------- (Grouping by combinations)
 * 5. GROUP BY WITH WHERE ------------------ (Filter BEFORE grouping)
 * 6. GROUP BY WITH HAVING ----------------- (Filter AFTER grouping)
 * 7. WHERE vs HAVING ---------------------- (Important difference)
 * 8. EXECUTION ORDER ---------------------- (How SQL processes GROUP BY)
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
-- PART 1: WHAT IS GROUP BY? (The Bucket Mental Model)
-- ============================================================================

/**
 * GROUP BY divides rows into groups (buckets) based on one or more columns.
 * Once grouped, you can perform calculations on each group using aggregate
 * functions like COUNT, SUM, AVG, MIN, MAX.
 * 
 * THE BUCKET MENTAL MODEL:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                        THE BUCKET MENTAL MODEL                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   Imagine you have a pile of colored balls (your rows).                │
 * │   Each ball has:                                                        │
 * │     → Color (like project)                                             │
 * │     → Size (like hours_logged)                                         │
 * │     → Type (like role)                                                 │
 * │                                                                          │
 * │   When you say GROUP BY color:                                         │
 * │     → All red balls go in one bucket                                   │
 * │     → All blue balls go in another bucket                              │
 * │     → All green balls go in a third bucket                             │
 * │                                                                          │
 * │   Once in buckets, you can:                                            │
 * │     → COUNT how many balls in each bucket                              │
 * │     → SUM the sizes of balls in each bucket                            │
 * │     → AVG the sizes of balls in each bucket                            │
 * │     → Find the MIN or MAX size in each bucket                          │
 * │                                                                          │
 * │   You can also create MORE SPECIFIC buckets by grouping by             │
 * │   multiple fields: GROUP BY color, type                                │
 * │     → Red-Developer bucket                                             │
 * │     → Red-QA bucket                                                    │
 * │     → Blue-Developer bucket                                            │
 * │     → etc.                                                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    GROUP BY - VISUAL EXAMPLE                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INPUT (All 10 rows):                                                  │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alice(Alpha), Bob(Alpha), Carol(Alpha), Dave(Alpha),            │   │
 * │   │ Eve(Beta), Frank(Beta), Grace(Beta), Hank(Beta),                │   │
 * │   │ Heidi(Gamma), Ivan(Gamma)                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   GROUP BY project:                                                     │
 * │                                                                          │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │  ALPHA BUCKET   │  │  BETA BUCKET    │  │  GAMMA BUCKET   │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice           │  │ Eve             │  │ Heidi           │        │
 * │   │ Bob             │  │ Frank           │  │ Ivan            │        │
 * │   │ Carol           │  │ Grace           │  │                 │        │
 * │   │ Dave            │  │ Hank            │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   OUTPUT (3 rows - one per bucket):                                     │
 * │   ┌─────────┐                                                          │
 * │   │ project │                                                          │
 * │   ├─────────┤                                                          │
 * │   │ Alpha   │                                                          │
 * │   │ Beta    │                                                          │
 * │   │ Gamma   │                                                          │
 * │   └─────────┘                                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: BASIC GROUPING (Listing unique values)
-- ============================================================================

/**
 * GROUP BY merges all rows with the same value into a single group.
 * Even without aggregate functions, GROUP BY returns unique values.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    BASIC GROUPING - Unique Projects                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project FROM employees GROUP BY project;                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT (10 rows):                      OUTPUT (3 unique rows):        │
 * │   ┌───────────────────┐                ┌─────────┐                    │
 * │   │ project           │                │ project │                    │
 * │   ├───────────────────┤                ├─────────┤                    │
 * │   │ Alpha (Alice)     │                │ Alpha   │                    │
 * │   │ Alpha (Bob)       │                │ Beta    │                    │
 * │   │ Alpha (Carol)     │                │ Gamma   │                    │
 * │   │ Alpha (Dave)      │                └─────────┘                    │
 * │   │ Beta (Eve)        │                                               │
 * │   │ Beta (Frank)      │                                               │
 * │   │ Beta (Grace)      │                                               │
 * │   │ Beta (Hank)       │                                               │
 * │   │ Gamma (Heidi)     │                                               │
 * │   │ Gamma (Ivan)      │                                               │
 * │   └───────────────────┘                                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: List all unique projects (active projects)
SELECT project
FROM employees
GROUP BY project;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ project │
 * ├─────────┤
 * │ Alpha   │
 * │ Beta    │
 * │ Gamma   │
 * └─────────┘
 * 
 * EXPLANATION:
 * - GROUP BY project creates one group per unique project name
 * - Even though there are 4 Alpha rows, they collapse into 1 group
 * - Beta has 4 rows → 1 group, Gamma has 2 rows → 1 group
 * - Result: 3 rows (one per distinct project)
 * 
 * EQUIVALENT TO: SELECT DISTINCT project FROM employees;
 */

-- EXAMPLE 2: List all unique roles in the company
SELECT role
FROM employees
GROUP BY role;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ role      │
 * ├───────────┤
 * │ Developer │
 * │ Manager   │
 * │ QA        │
 * └───────────┘
 * 
 * EXPLANATION:
 * - Groups by role, collapses duplicates
 * - Developer appears 5 times → 1 group
 * - Manager appears 2 times → 1 group
 * - QA appears 2 times → 1 group
 */

-- ============================================================================
-- PART 3: GROUP BY WITH AGGREGATES (COUNT, SUM, AVG, MIN, MAX)
-- ============================================================================

/**
 * Once you have groups (buckets), you can calculate things for each group.
 * 
 * AGGREGATE FUNCTIONS:
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ Function │ What it does                        │ Example               │
 * ├──────────┼─────────────────────────────────────┼───────────────────────┤
 * │ COUNT(*) │ Number of rows in group            │ How many employees?   │
 * │ SUM(col) │ Total of column values in group     │ Total hours logged    │
 * │ AVG(col) │ Average of column values in group   │ Average experience    │
 * │ MIN(col) │ Smallest value in group             │ Minimum hours logged  │
 * │ MAX(col) │ Largest value in group              │ Maximum hours logged  │
 * └──────────┴─────────────────────────────────────┴───────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    GROUP BY WITH COUNT - Team Size                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) AS team_size                          │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Create buckets by project                                    │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice           │  │ Eve             │  │ Heidi           │        │
 * │   │ Bob             │  │ Frank           │  │ Ivan            │        │
 * │   │ Carol           │  │ Grace           │  │                 │        │
 * │   │ Dave            │  │ Hank            │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 2: COUNT rows in each bucket                                     │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ Alpha: 4 rows   │  │ Beta: 4 rows    │  │ Gamma: 2 rows   │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   OUTPUT:                                                               │
 * │   ┌─────────┬────────────┐                                             │
 * │   │ project │ team_size  │                                             │
 * │   ├─────────┼────────────┤                                             │
 * │   │ Alpha   │ 4          │                                             │
 * │   │ Beta    │ 4          │                                             │
 * │   │ Gamma   │ 2          │                                             │
 * │   └─────────┴────────────┘                                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Team size per project (COUNT)
SELECT 
    project,
    COUNT(*) AS team_size
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬────────────┐
 * │ project │ team_size  │
 * ├─────────┼────────────┤
 * │ Alpha   │ 4          │
 * │ Beta    │ 4          │
 * │ Gamma   │ 2          │
 * └─────────┴────────────┘
 */

-- EXAMPLE 2: Total hours logged per project (SUM)
SELECT 
    project,
    SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ project │ total_hours │
 * ├─────────┼─────────────┤
 * │ Alpha   │ 325         │  (100 + 120 + 105 + 0)
 * │ Beta    │ 320         │  (80 + 110 + 130 + NULL)
 * │ Gamma   │ 290         │  (150 + 140)
 * └─────────┴─────────────┘
 * 
 * NOTE: NULL values are ignored in SUM
 */

-- EXAMPLE 3: Average experience per project (AVG)
SELECT 
    project,
    ROUND(AVG(years_experience), 1) AS avg_experience
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬────────────────┐
 * │ project │ avg_experience │
 * ├─────────┼────────────────┤
 * │ Alpha   │ 5.0            │  (3 + 5 + 7 + NULL) / 3 = 5.0
 * │ Beta    │ 3.0            │  (2 + 3 + 4 + 3) / 4 = 3.0
 * │ Gamma   │ 5.5            │  (5 + 6) / 2 = 5.5
 * └─────────┴────────────────┘
 * 
 * NOTE: NULL values are ignored in AVG
 */

-- EXAMPLE 4: Minimum and Maximum hours per project (MIN, MAX)
SELECT 
    project,
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬───────────┐
 * │ project │ min_hours │ max_hours │
 * ├─────────┼───────────┼───────────┤
 * │ Alpha   │ 0         │ 120       │
 * │ Beta    │ 80        │ 130       │
 * │ Gamma   │ 140       │ 150       │
 * └─────────┴───────────┴───────────┘
 */

-- EXAMPLE 5: Multiple aggregates together
SELECT 
    project,
    COUNT(*) AS team_size,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_exp,
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┬──────────┬───────────┬───────────┐
 * │ project │ team_size │ total_hours │ avg_exp  │ min_hours │ max_hours │
 * ├─────────┼───────────┼─────────────┼──────────┼───────────┼───────────┤
 * │ Alpha   │ 4         │ 325         │ 5.0      │ 0         │ 120       │
 * │ Beta    │ 4         │ 320         │ 3.0      │ 80        │ 130       │
 * │ Gamma   │ 2         │ 290         │ 5.5      │ 140       │ 150       │
 * └─────────┴───────────┴─────────────┴──────────┴───────────┴───────────┘
 */

-- ============================================================================
-- PART 4: MULTI-COLUMN GROUPING (Grouping by combinations)
-- ============================================================================

/**
 * Grouping by multiple columns creates more specific buckets.
 * Each unique combination of column values becomes its own group.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MULTI-COLUMN GROUPING - Project & Role               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, role, COUNT(*) AS count                         │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project, role;                                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Create buckets by (project, role) pair                       │
 * │                                                                          │
 * │   ┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐│
 * │   │ ALPHA-DEVELOPER    │  │ ALPHA-MANAGER      │  │ ALPHA-QA           ││
 * │   ├────────────────────┤  ├────────────────────┤  ├────────────────────┤│
 * │   │ Alice              │  │ Dave               │  │ Bob                ││
 * │   │ Carol              │  │                    │  │                    ││
 * │   └────────────────────┘  └────────────────────┘  └────────────────────┘│
 * │                                                                          │
 * │   ┌────────────────────┐  ┌────────────────────┐                        │
 * │   │ BETA-DEVELOPER     │  │ BETA-MANAGER       │                        │
 * │   ├────────────────────┤  ├────────────────────┤                        │
 * │   │ Frank              │  │ Eve                │                        │
 * │   │ Grace              │  │                    │                        │
 * │   │ Hank               │  │                    │                        │
 * │   └────────────────────┘  └────────────────────┘                        │
 * │                                                                          │
 * │   ┌────────────────────┐  ┌────────────────────┐                        │
 * │   │ GAMMA-DEVELOPER    │  │ GAMMA-QA           │                        │
 * │   ├────────────────────┤  ├────────────────────┤                        │
 * │   │ Heidi              │  │ Ivan               │                        │
 * │   └────────────────────┘  └────────────────────┘                        │
 * │                                                                          │
 * │   OUTPUT (7 rows - one per unique combination):                         │
 * │   ┌─────────┬───────────┬───────┐                                      │
 * │   │ project │ role      │ count │                                      │
 * │   ├─────────┼───────────┼───────┤                                      │
 * │   │ Alpha   │ Developer │ 2     │                                      │
 * │   │ Alpha   │ Manager   │ 1     │                                      │
 * │   │ Alpha   │ QA        │ 1     │                                      │
 * │   │ Beta    │ Developer │ 3     │                                      │
 * │   │ Beta    │ Manager   │ 1     │                                      │
 * │   │ Gamma   │ Developer │ 1     │                                      │
 * │   │ Gamma   │ QA        │ 1     │                                      │
 * │   └─────────┴───────────┴───────┘                                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Count of each role per project
SELECT 
    project,
    role,
    COUNT(*) AS employee_count
FROM employees
GROUP BY project, role
ORDER BY project, role;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬────────────────┐
 * │ project │ role      │ employee_count │
 * ├─────────┼───────────┼────────────────┤
 * │ Alpha   │ Developer │ 2              │
 * │ Alpha   │ Manager   │ 1              │
 * │ Alpha   │ QA        │ 1              │
 * │ Beta    │ Developer │ 3              │
 * │ Beta    │ Manager   │ 1              │
 * │ Gamma   │ Developer │ 1              │
 * │ Gamma   │ QA        │ 1              │
 * └─────────┴───────────┴────────────────┘
 */

-- EXAMPLE 2: Total hours per role per project
SELECT 
    project,
    role,
    SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project, role
ORDER BY project, role;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┐
 * │ project │ role      │ total_hours │
 * ├─────────┼───────────┼─────────────┤
 * │ Alpha   │ Developer │ 205         │  (100 + 105)
 * │ Alpha   │ Manager   │ 0           │  (0)
 * │ Alpha   │ QA        │ 120         │  (120)
 * │ Beta    │ Developer │ 240         │  (110 + 130 + NULL)
 * │ Beta    │ Manager   │ 80          │  (80)
 * │ Gamma   │ Developer │ 150         │  (150)
 * │ Gamma   │ QA        │ 140         │  (140)
 * └─────────┴───────────┴─────────────┘
 */

-- ============================================================================
-- PART 5: GROUP BY WITH WHERE (Filter BEFORE grouping)
-- ============================================================================

/**
 * WHERE filters rows BEFORE they are placed into groups.
 * Only rows that pass the WHERE condition will be included in grouping.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    GROUP BY WITH WHERE - Filter First                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) AS developer_count                    │   │
 * │   │ FROM employees                                                  │   │
 *   │   │ WHERE role = 'Developer'                                       │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: WHERE filters to only Developer rows                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Developers: Alice, Carol, Frank, Grace, Hank, Heidi (6 rows)   │   │
 * │   │ (Bob, Dave, Eve, Ivan are removed)                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: GROUP BY project on remaining rows                          │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice           │  │ Frank           │  │ Heidi           │        │
 * │   │ Carol           │  │ Grace           │  │                 │        │
 * │   │                 │  │ Hank            │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 3: COUNT rows in each bucket                                     │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ Alpha: 2        │  │ Beta: 3         │  │ Gamma: 1        │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   OUTPUT:                                                               │
 * │   ┌─────────┬─────────────────┐                                        │
 * │   │ project │ developer_count │                                        │
 * │   ├─────────┼─────────────────┤                                        │
 * │   │ Alpha   │ 2               │                                        │
 * │   │ Beta    │ 3               │                                        │
 * │   │ Gamma   │ 1               │                                        │
 * │   └─────────┴─────────────────┘                                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Count of Developers per project
SELECT 
    project,
    COUNT(*) AS developer_count
FROM employees
WHERE role = 'Developer'
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┐
 * │ project │ developer_count │
 * ├─────────┼─────────────────┤
 * │ Alpha   │ 2               │
 * │ Beta    │ 3               │
 * │ Gamma   │ 1               │
 * └─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - WHERE filters to only 'Developer' rows first
 * - Alpha originally had 4 employees, but only 2 are Developers
 * - Beta originally had 4 employees, but 3 are Developers
 * - Gamma originally had 2 employees, but 1 is Developer
 */

-- EXAMPLE 2: Projects with active employees (hours_logged > 0)
SELECT 
    project,
    COUNT(*) AS active_employees
FROM employees
WHERE hours_logged > 0 AND hours_logged IS NOT NULL
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬──────────────────┐
 * │ project │ active_employees │
 * ├─────────┼──────────────────┤
 * │ Alpha   │ 3                │  (Alice, Bob, Carol)
 * │ Beta    │ 3                │  (Eve, Frank, Grace) - Hank excluded
 * │ Gamma   │ 2                │  (Heidi, Ivan)
 * └─────────┴──────────────────┘
 */

-- ============================================================================
-- PART 6: GROUP BY WITH HAVING (Filter AFTER grouping)
-- ============================================================================

/**
 * HAVING filters groups AFTER aggregation.
 * This is like WHERE, but for groups instead of individual rows.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    GROUP BY WITH HAVING - Filter After                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project, COUNT(*) AS team_size                          │   │
 * │   │ FROM employees                                                  │   │
 *   │   │ GROUP BY project                                               │   │
 * │   │ HAVING COUNT(*) >= 3;                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: GROUP BY project (create buckets)                            │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ 4 rows          │  │ 4 rows          │  │ 2 rows          │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 2: Apply HAVING filter (keep groups with >= 3 rows)             │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA: 4 ✅     │  │ BETA: 4 ✅      │  │ GAMMA: 2 ❌     │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   OUTPUT:                                                               │
 * │   ┌─────────┬────────────┐                                             │
 * │   │ project │ team_size  │                                             │
 * │   ├─────────┼────────────┤                                             │
 * │   │ Alpha   │ 4          │                                             │
 * │   │ Beta    │ 4          │                                             │
 * │   └─────────┴────────────┘                                             │
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
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬────────────┐
 * │ project │ team_size  │
 * ├─────────┼────────────┤
 * │ Alpha   │ 4          │
 * │ Beta    │ 4          │
 * └─────────┴────────────┘
 * 
 * EXPLANATION:
 * - Gamma has only 2 members, so it's filtered out by HAVING
 */

-- EXAMPLE 2: Projects with total hours > 300
SELECT 
    project,
    SUM(hours_logged) AS total_hours
FROM employees
GROUP BY project
HAVING SUM(hours_logged) > 300
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ project │ total_hours │
 * ├─────────┼─────────────┤
 * │ Alpha   │ 325         │
 * │ Beta    │ 320         │
 * └─────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Gamma has 290 total hours, so it's filtered out
 */

-- EXAMPLE 3: Projects with average experience > 4 years
SELECT 
    project,
    ROUND(AVG(years_experience), 1) AS avg_exp
FROM employees
GROUP BY project
HAVING AVG(years_experience) > 4
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────┐
 * │ project │ avg_exp │
 * ├─────────┼─────────┤
 * │ Alpha   │ 5.0     │
 * │ Gamma   │ 5.5     │
 * └─────────┴─────────┘
 */

-- ============================================================================
-- PART 7: WHERE vs HAVING (Important difference)
-- ============================================================================

/**
 * WHERE vs HAVING - INPUT/OUTPUT COMPARISON:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                      WHERE vs HAVING - KEY DIFFERENCES                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    WHERE (Filter rows)                          │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied BEFORE GROUP BY                                   │   │
 * │   │ PURPOSE: Filter individual rows                                 │   │
 * │   │ CAN USE: Regular columns only (not aggregates)                  │   │
 * │   │ BEST FOR: Removing rows you don't want to group                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                   HAVING (Filter groups)                        │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied AFTER GROUP BY                                     │   │
 * │   │ PURPOSE: Filter groups (buckets)                                 │   │
 * │   │ CAN USE: Aggregate functions (COUNT, SUM, AVG, etc.)            │   │
 * │   │ BEST FOR: Keeping only groups that meet certain criteria        │   │
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
-- WHERE filters individual rows before grouping
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

-- HAVING filters groups after grouping
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
-- PART 8: EXECUTION ORDER (How SQL processes GROUP BY)
-- ============================================================================

/**
 * SQL EXECUTION ORDER - COMPLETE SEQUENCE:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SQL EXECUTION ORDER                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   WRITTEN ORDER:                      ACTUAL EXECUTION ORDER:          │
 * │                                                                          │
 * │   SELECT                             1. FROM                           │
 * │   FROM                               2. WHERE                          │
 * │   WHERE                              3. GROUP BY                       │
 * │   GROUP BY                           4. HAVING                         │
 * │   HAVING                             5. SELECT                         │
 * │   ORDER BY                           6. ORDER BY                       │
 * │                                                                          │
 * │   CRITICAL INSIGHTS:                                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. WHERE executes BEFORE GROUP BY                               │   │
 * │   │    → You cannot use aggregates in WHERE                         │   │
 * │   │                                                                  │   │
 * │   │ 2. HAVING executes AFTER GROUP BY                               │   │
 * │   │    → You CAN use aggregates in HAVING                           │   │
 * │   │                                                                  │   │
 * │   │ 3. SELECT executes after GROUP BY                               │   │
 * │   │    → Column aliases in SELECT cannot be used in WHERE           │   │
 * │   │    → Column aliases CAN be used in ORDER BY                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * VISUAL REPRESENTATION:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                                                                          │
 * │   Original Table (10 rows)                                              │
 * │         ↓                                                               │
 * │   ┌─────────────────────────────────────────┐                          │
 * │   │ 1. FROM — employees (all 10 rows)       │                          │
 * │   └─────────────────────────────────────────┘                          │
 * │         ↓                                                               │
 * │   ┌─────────────────────────────────────────┐                          │
 * │   │ 2. WHERE — filter rows                  │                          │
 * │   │    (e.g., role = 'Developer') → 6 rows  │                          │
 * │   └─────────────────────────────────────────┘                          │
 * │         ↓                                                               │
 * │   ┌─────────────────────────────────────────┐                          │
 * │   │ 3. GROUP BY — create buckets            │                          │
 * │   │    Alpha: Alice, Carol                  │                          │
 * │   │    Beta: Frank, Grace, Hank             │                          │
 * │   │    Gamma: Heidi                         │                          │
 * │   └─────────────────────────────────────────┘                          │
 * │         ↓                                                               │
 * │   ┌─────────────────────────────────────────┐                          │
 * │   │ 4. HAVING — filter groups               │                          │
 * │   │    (e.g., COUNT(*) >= 2)                │                          │
 * │   │    → Keep Alpha and Beta                │                          │
 * │   └─────────────────────────────────────────┘                          │
 * │         ↓                                                               │
 * │   ┌─────────────────────────────────────────┐                          │
 * │   │ 5. SELECT — choose columns to show      │                          │
 * │   └─────────────────────────────────────────┘                          │
 * │         ↓                                                               │
 * │   ┌─────────────────────────────────────────┐                          │
 * │   │ 6. ORDER BY — sort final result         │                          │
 * │   └─────────────────────────────────────────┘                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example demonstrating execution order
SELECT 
    project,
    COUNT(*) AS team_size,
    AVG(years_experience) AS avg_exp
FROM employees
WHERE years_experience IS NOT NULL     -- 1. Remove NULL experience rows
GROUP BY project                        -- 2. Group by project
HAVING COUNT(*) >= 2                    -- 3. Keep groups with 2+ members
ORDER BY team_size DESC;                -- 4. Sort by team size (largest first)

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────┐
 * │ project │ team_size │ avg_exp │
 * ├─────────┼───────────┼─────────┤
 * │ Beta    │ 4         │ 3.0     │
 * │ Alpha   │ 3         │ 5.0     │
 * └─────────┴───────────┴─────────┘
 * 
 * EXPLANATION OF EXECUTION:
 * 1. WHERE: Remove Dave (NULL experience) → 9 rows left
 * 2. GROUP BY: Create buckets by project
 *    Alpha: Alice, Bob, Carol (3 rows)
 *    Beta: Eve, Frank, Grace, Hank (4 rows)
 *    Gamma: Heidi, Ivan (2 rows)
 * 3. HAVING: Keep only groups with >=2 members
 *    Alpha (3) ✅, Beta (4) ✅, Gamma (2) ✅ (all kept)
 * 4. SELECT: Show project, team_size, avg_exp
 * 5. ORDER BY: Sort by team_size DESC (Beta first)
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Project Team Composition Report
 * 
 * Understand the skill mix in each project for resource planning.
 */

SELECT 
    project,
    COUNT(CASE WHEN role = 'Developer' THEN 1 END) AS developers,
    COUNT(CASE WHEN role = 'QA' THEN 1 END) AS qa_count,
    COUNT(CASE WHEN role = 'Manager' THEN 1 END) AS managers,
    COUNT(*) AS total_team
FROM employees
GROUP BY project
ORDER BY total_team DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬──────────┬─────────┬────────────┐
 * │ project │ developers  │ qa_count │ managers │ total_team │
 * ├─────────┼─────────────┼──────────┼─────────┼────────────┤
 * │ Alpha   │ 2           │ 1        │ 1       │ 4          │
 * │ Beta    │ 3           │ 0        │ 1       │ 4          │
 * │ Gamma   │ 1           │ 1        │ 0       │ 2          │
 * └─────────┴─────────────┴──────────┴─────────┴────────────┘
 */

/**
 * SCENARIO 2: Projects with Role Diversity
 * 
 * Identify which projects have multiple different roles.
 */

SELECT 
    project,
    COUNT(DISTINCT role) AS distinct_roles,
    STRING_AGG(DISTINCT role, ', ' ORDER BY role) AS roles_list
FROM employees
GROUP BY project
HAVING COUNT(DISTINCT role) > 1
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬────────────────┬─────────────────────────┐
 * │ project │ distinct_roles │ roles_list              │
 * ├─────────┼────────────────┼─────────────────────────┤
 * │ Alpha   │ 3              │ Developer, Manager, QA  │
 * │ Beta    │ 2              │ Developer, Manager      │
 * │ Gamma   │ 2              │ Developer, QA           │
 * └─────────┴────────────────┴─────────────────────────┘
 */

/**
 * SCENARIO 3: Team Size Analysis by Project
 * 
 * Categorize projects by team size for management reporting.
 */

SELECT 
    project,
    COUNT(*) AS team_size,
    CASE 
        WHEN COUNT(*) >= 4 THEN 'Large Team'
        WHEN COUNT(*) >= 2 THEN 'Medium Team'
        ELSE 'Small Team'
    END AS team_category
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬──────────────┐
 * │ project │ team_size │ team_category│
 * ├─────────┼───────────┼──────────────┤
 * │ Alpha   │ 4         │ Large Team   │
 * │ Beta    │ 4         │ Large Team   │
 * │ Gamma   │ 2         │ Medium Team  │
 * └─────────┴───────────┴──────────────┘
 */

/**
 * SCENARIO 4: Project Assignment Summary
 * 
 * Get a quick overview of all projects and their roles.
 */

SELECT 
    project,
    ARRAY_AGG(DISTINCT role ORDER BY role) AS roles_in_project,
    COUNT(*) AS member_count
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────────────┬──────────────┐
 * │ project │ roles_in_project        │ member_count │
 * ├─────────┼─────────────────────────┼──────────────┤
 * │ Alpha   │ {Developer, Manager, QA}│ 4            │
 * │ Beta    │ {Developer, Manager}    │ 4            │
 * │ Gamma   │ {Developer, QA}         │ 2            │
 * └─────────┴─────────────────────────┴──────────────┘
 */

/**
 * SCENARIO 5: Experience Level Analysis by Role
 * 
 * Group by role to understand experience distribution.
 */

SELECT 
    role,
    COUNT(*) AS employee_count,
    ROUND(AVG(years_experience), 1) AS avg_experience,
    MIN(years_experience) AS min_experience,
    MAX(years_experience) AS max_experience
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY role
ORDER BY avg_experience DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────────────┬────────────────┬────────────────┬────────────────┐
 * │ role      │ employee_count  │ avg_experience │ min_experience │ max_experience │
 * ├───────────┼─────────────────┼────────────────┼────────────────┼────────────────┤
 * │ QA        │ 2               │ 5.5            │ 5.0            │ 6.0            │
 * │ Developer │ 5               │ 4.4            │ 3.0            │ 7.0            │
 * │ Manager   │ 2               │ 2.0            │ 2.0            │ 2.0            │
 * └───────────┴─────────────────┴────────────────┴────────────────┴────────────────┘
 */

/**
 * SCENARIO 6: Project Health Check
 * 
 * Identify projects that might need attention based on metrics.
 */

SELECT 
    project,
    COUNT(*) AS team_size,
    COUNT(CASE WHEN hours_logged IS NULL THEN 1 END) AS missing_hours,
    COUNT(CASE WHEN years_experience IS NULL THEN 1 END) AS missing_exp,
    COUNT(CASE WHEN hours_logged = 0 THEN 1 END) AS zero_hours
FROM employees
GROUP BY project
HAVING missing_hours > 0 OR missing_exp > 0 OR zero_hours > 0;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬───────────────┬─────────────┬────────────┐
 * │ project │ team_size │ missing_hours │ missing_exp │ zero_hours │
 * ├─────────┼───────────┼───────────────┼─────────────┼────────────┤
 * │ Alpha   │ 4         │ 0             │ 1           │ 1          │
 * │ Beta    │ 4         │ 1             │ 0           │ 0          │
 * └─────────┴───────────┴───────────────┴─────────────┴────────────┘
 * 
 * EXPLANATION:
 * - Alpha: Dave has NULL experience and 0 hours
 * - Beta: Hank has NULL hours
 * - Gamma: No data quality issues
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Selecting non-grouped columns without aggregation          │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT project, employee_name                                        │
 * │   FROM employees                                                       │
 * │   GROUP BY project;                                                    │
 * │   → ERROR! employee_name is not in GROUP BY and not aggregated         │
 * │                                                                          │
 * │   WHY? Each project bucket has MULTIPLE employee_names.                │
 * │        Which one should the database show?                             │
 * │                                                                          │
 * │   ✅ CORRECT — Either group by the column:                              │
 * │   SELECT project, employee_name                                        │
 * │   FROM employees                                                       │
 * │   GROUP BY project, employee_name;                                     │
 * │                                                                          │
 * │   ✅ OR use an aggregate function:                                      │
 * │   SELECT project, COUNT(employee_name) AS employee_count               │
 * │   FROM employees                                                       │
 * │   GROUP BY project;                                                    │
 * │                                                                          │
 * │   RULE: Every column in SELECT must either be in GROUP BY              │
 * │         OR be wrapped in an aggregate function.                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example of MISTAKE #1 (This will cause an error in most databases)
-- SELECT project, employee_name FROM employees GROUP BY project;  -- ERROR!

-- Correct way:
SELECT project, COUNT(employee_name) AS employee_count
FROM employees
GROUP BY project;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Confusing GROUP BY with ORDER BY                           │
 * │                                                                          │
 * │   GROUP BY is for CATEGORIZING data into buckets.                      │
 * │   ORDER BY is for SORTING the final result.                            │
 * │                                                                          │
 * │   ❌ DON'T RELY ON GROUP BY FOR SORTING:                                │
 * │   SELECT project FROM employees GROUP BY project;                      │
 * │   → May appear sorted, but NOT guaranteed!                             │
 * │                                                                          │
 * │   ✅ ALWAYS use ORDER BY for consistent sorting:                        │
 * │   SELECT project FROM employees GROUP BY project ORDER BY project;     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Not guaranteed to be sorted
SELECT project FROM employees GROUP BY project;

-- Guaranteed to be sorted
SELECT project FROM employees GROUP BY project ORDER BY project;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using WHERE with aggregate conditions                      │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT project, COUNT(*) AS emp_count                                │
 * │   FROM employees                                                       │
 * │   WHERE COUNT(*) > 2  ← ERROR!                                         │
 * │   GROUP BY project;                                                    │
 * │                                                                          │
 * │   WHY? WHERE executes BEFORE grouping, so aggregates don't exist yet.  │
 * │                                                                          │
 * │   ✅ CORRECT — Use HAVING for aggregate conditions:                     │
 * │   SELECT project, COUNT(*) AS emp_count                                │
 * │   FROM employees                                                       │
 * │   GROUP BY project                                                     │
 * │   HAVING COUNT(*) > 2;                                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Correct way to filter by aggregate
SELECT 
    project, 
    COUNT(*) AS emp_count
FROM employees
GROUP BY project
HAVING COUNT(*) > 2;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Grouping by primary key or unique columns                  │
 * │                                                                          │
 * │   ❌ USELESS GROUP BY:                                                  │
 * │   SELECT emp_id, COUNT(*)                                              │
 * │   FROM employees                                                       │
 * │   GROUP BY emp_id;                                                     │
 * │   → Each group has exactly ONE row (emp_id is unique)                  │
 * │   → COUNT(*) will always be 1                                          │
 * │   → Pointless grouping!                                                │
 * │                                                                          │
 * │   ✅ ALWAYS group by columns that have REPEATING values:                │
 * │   SELECT project, role, COUNT(*)                                       │
 * │   FROM employees                                                       │
 * │   GROUP BY project, role;                                              │
 * │   → Meaningful grouping with multiple rows per group                   │
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
 * │ BASIC GROUP BY:                                                         │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- List unique values                                              │ │
 * │ │ SELECT column FROM table GROUP BY column;                          │ │
 * │ │                                                                     │ │
 * │ │ -- Group by multiple columns                                       │ │
 * │ │ SELECT col1, col2 FROM table GROUP BY col1, col2;                  │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ GROUP BY WITH AGGREGATES:                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Count per group                                                 │ │
 * │ │ SELECT project, COUNT(*) FROM employees GROUP BY project;          │ │
 * │ │                                                                     │ │
 * │ │ -- Multiple aggregates                                             │ │
 * │ │ SELECT project,                                                    │ │
 * │ │        COUNT(*) AS team_size,                                      │ │
 * │ │        AVG(years_experience) AS avg_exp                            │ │
 * │ │ FROM employees GROUP BY project;                                   │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ GROUP BY WITH FILTERING:                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- WHERE filters BEFORE grouping                                   │ │
 * │ │ SELECT project, COUNT(*)                                           │ │
 * │ │ FROM employees                                                     │ │
 * │ │ WHERE role = 'Developer'                                           │ │
 * │ │ GROUP BY project;                                                  │ │
 * │ │                                                                     │ │
 * │ │ -- HAVING filters AFTER grouping                                   │ │
 * │ │ SELECT project, COUNT(*)                                           │ │
 * │ │ FROM employees                                                     │ │
 * │ │ GROUP BY project                                                   │ │
 * │ │ HAVING COUNT(*) > 2;                                               │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ CONDITIONAL COUNTING:                                                   │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Count only specific values                                      │ │
 * │ │ SELECT project,                                                    │ │
 * │ │        COUNT(CASE WHEN role = 'Developer' THEN 1 END) AS devs     │ │
 * │ │ FROM employees GROUP BY project;                                   │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ EXECUTION ORDER (Remember this!):                                       │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ 1. FROM      → Pick table(s)                                       │ │
 * │ │ 2. WHERE     → Filter rows (BEFORE grouping)                       │ │
 * │ │ 3. GROUP BY  → Create groups                                       │ │
 * │ │ 4. HAVING    → Filter groups (AFTER aggregation)                   │ │
 * │ │ 5. SELECT    → Choose output columns                               │ │
 * │ │ 6. ORDER BY  → Sort final results                                  │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 12: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. ✅ GROUP BY creates "buckets" — all rows with the same value in     │
 * │      the grouped column(s) go into the same bucket.                    │
 * │                                                                          │
 * │ 2. ✅ The "SELECT Rule": Every column in SELECT must either be:        │
 * │      → Listed in GROUP BY, OR                                          │
 * │      → Wrapped in an aggregate function (COUNT, SUM, AVG, etc.)        │
 * │                                                                          │
 * │ 3. ✅ WHERE happens BEFORE GROUP BY — it filters which rows go into    │
 * │      the buckets. HAVING happens AFTER GROUP BY — it filters which     │
 * │      buckets appear in results.                                        │
 * │                                                                          │
 * │ 4. ✅ GROUP BY is for CATEGORIZING, ORDER BY is for SORTING.           │
 * │      Never rely on GROUP BY to sort your results — use ORDER BY.       │
 * │                                                                          │
 * │ 5. ✅ Group by columns that have REPEATING values (like project, role, │
 * │      city, department). Grouping by unique IDs is usually pointless.   │
 * │                                                                          │
 * │ 6. ✅ You can group by multiple columns to create more specific buckets.│
 * │      Each unique combination becomes its own group.                    │
 * │                                                                          │
 * │ 7. 💡 Use conditional counting with CASE inside aggregates:            │
 * │      COUNT(CASE WHEN condition THEN 1 END)                             │
 * │                                                                          │
 * │ 8. 💡 When grouping, consider what question you're answering:          │
 * │      "How many per X?" → GROUP BY X, COUNT(*)                          │
 * │      "What's the average per X?" → GROUP BY X, AVG(column)             │
 * │                                                                          │
 * │ 9. ✅ GROUP BY without aggregates still works — it's essentially       │
 * │      SELECT DISTINCT, but with more flexibility for adding aggregates. │
 * │                                                                          │
 * │ 10. 💡 Visualize the bucket model: each GROUP BY column creates a      │
 * │       new level of bucket nesting. GROUP BY color, size = buckets      │
 * │       for each color, then sub-buckets for each size within each color.│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Count employees per role
 * 
 * Answer:
 *   SELECT role, COUNT(*) AS employee_count
 *   FROM employees
 *   GROUP BY role;
 */

/**
 * EXERCISE 2: Find average experience per project
 * 
 * Answer:
 *   SELECT project, ROUND(AVG(years_experience), 1) AS avg_exp
 *   FROM employees
 *   GROUP BY project;
 */

/**
 * EXERCISE 3: Find projects with more than 2 developers
 * 
 * Answer:
 *   SELECT project, COUNT(*) AS developer_count
 *   FROM employees
 *   WHERE role = 'Developer'
 *   GROUP BY project
 *   HAVING COUNT(*) > 2;
 */

/**
 * EXERCISE 4: Show each project's role composition
 * 
 * Answer:
 *   SELECT project, role, COUNT(*) AS count
 *   FROM employees
 *   GROUP BY project, role
 *   ORDER BY project, role;
 */

/**
 * EXERCISE 5: Find total hours logged per project for delivered work
 * 
 * Answer:
 *   SELECT project, SUM(hours_logged) AS total_hours
 *   FROM employees
 *   WHERE hours_logged > 0
 *   GROUP BY project;
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
 * │ 1. GROUP BY = Creates buckets (groups) of rows with same values        │
 * │                                                                          │
 * │ 2. AGGREGATE FUNCTIONS = Calculate things per bucket                   │
 * │    → COUNT, SUM, AVG, MIN, MAX                                         │
 * │                                                                          │
 * │ 3. WHERE = Filter rows BEFORE grouping                                 │
 * │    → Cannot use aggregate functions                                     │
 * │                                                                          │
 * │ 4. HAVING = Filter groups AFTER grouping                               │
 * │    → Can use aggregate functions                                        │
 * │                                                                          │
 * │ 5. EXECUTION ORDER:                                                     │
 * │    FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY                │
 * │                                                                          │
 * │ 6. MULTI-COLUMN GROUPING = Each unique combination becomes a group     │
 * │                                                                          │
 * │ 7. COMMON PATTERNS:                                                     │
 * │    → "How many per X?" → GROUP BY X, COUNT(*)                          │
 * │    → "What's the total per X?" → GROUP BY X, SUM(column)               │
 * │    → "What's the average per X?" → GROUP BY X, AVG(column)             │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Every SELECT column must be in GROUP BY or in an aggregate         │
 * │   - Use WHERE for row filters, HAVING for group filters                │
 * │   - Always use ORDER BY for sorting (don't rely on GROUP BY)           │
 * │   - Visualize the bucket model for understanding                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF GROUP BY GUIDE
-- ============================================================================