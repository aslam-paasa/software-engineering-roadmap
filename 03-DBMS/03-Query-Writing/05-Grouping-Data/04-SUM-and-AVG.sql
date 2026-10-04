/**
 * ============================================================================
 * SUM & AVG - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE SUM AND AVG? ---------------- (Totals and averages explained)
 * 2. SUM FUNCTION ------------------------- (Adding up numbers)
 * 3. AVG FUNCTION ------------------------- (Finding averages)
 * 4. SUM AND AVG WITH GROUP BY ------------ (Per group calculations)
 * 5. SUM AND AVG WITH WHERE --------------- (Filter before calculating)
 * 6. SUM AND AVG WITH HAVING -------------- (Filter after grouping)
 * 7. HANDLING NULL VALUES ----------------- (How NULL affects calculations)
 * 8. SUM WITH DISTINCT -------------------- (Sum of unique values)
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
 * EMPLOYEES TABLE - Company employee data with hours logged and inventory
 * 
 * ┌────────┬───────────────┬─────────┬───────────────────┬──────────────┬───────────┬─────────┐
 * │ emp_id │ employee_name │ project │ years_experience  │ hours_logged │ role      │ quantity│
 * ├────────┼───────────────┼─────────┼───────────────────┼──────────────┼───────────┼─────────┤
 * │    1   │ Alice         │ Alpha   │ 3.0               │ 100          │ Developer │    5    │
 * │    2   │ Bob           │ Alpha   │ 5.0               │ 120          │ QA        │    3    │
 * │    3   │ Carol         │ Alpha   │ 7.0               │ 105          │ Developer │    7    │
 * │    4   │ Dave          │ Alpha   │ NULL              │ 0            │ Manager   │    2    │
 * │    5   │ Eve           │ Beta    │ 2.0               │ 80           │ Manager   │    4    │
 * │    6   │ Frank         │ Beta    │ 3.0               │ 110          │ Developer │    6    │
 * │    7   │ Grace         │ Beta    │ 4.0               │ 130          │ Developer │    8    │
 * │    8   │ Hank          │ Beta    │ 3.0               │ NULL         │ Developer │    0    │
 * │    9   │ Heidi         │ Gamma   │ 5.0               │ 150          │ Developer │    9    │
 * │   10   │ Ivan          │ Gamma   │ 6.0               │ 140          │ QA        │    1    │
 * └────────┴───────────────┴─────────┴───────────────────┴──────────────┴───────────┴─────────┘
 */

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    project VARCHAR(20),
    years_experience DECIMAL(3,1),
    hours_logged INT,
    role VARCHAR(20),
    quantity INT
);

INSERT INTO employees VALUES
(1, 'Alice', 'Alpha', 3.0, 100, 'Developer', 5),
(2, 'Bob', 'Alpha', 5.0, 120, 'QA', 3),
(3, 'Carol', 'Alpha', 7.0, 105, 'Developer', 7),
(4, 'Dave', 'Alpha', NULL, 0, 'Manager', 2),
(5, 'Eve', 'Beta', 2.0, 80, 'Manager', 4),
(6, 'Frank', 'Beta', 3.0, 110, 'Developer', 6),
(7, 'Grace', 'Beta', 4.0, 130, 'Developer', 8),
(8, 'Hank', 'Beta', 3.0, NULL, 'Developer', 0),
(9, 'Heidi', 'Gamma', 5.0, 150, 'Developer', 9),
(10, 'Ivan', 'Gamma', 6.0, 140, 'QA', 1);

-- ============================================================================
-- PART 1: WHAT ARE SUM AND AVG?
-- ============================================================================

/**
 * SUM and AVG are aggregate functions for numeric calculations.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT ARE SUM AND AVG?                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SUM() = Adds up ALL values in a column                               │
 * │   AVG() = Calculates the AVERAGE (mean) of values in a column         │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                    │
 *   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   Monthly sales: 100, 200, 150, 300, 250                          │   │
 * │                                                                  │   │
 * │   SUM(sales) = 100 + 200 + 150 + 300 + 250 = 1000 (Total sales)  │   │
 * │   AVG(sales) = 1000 / 5 = 200 (Average monthly sales)            │   │
 * │                                                                  │   │
 * │   This helps businesses understand total revenue and typical     │   │
 * │   monthly performance                                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   KEY POINTS:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ✓ Only works with NUMERIC columns (INT, DECIMAL, etc.)         │   │
 * │   │ ✓ NULL values are IGNORED (not counted as 0)                   │   │
 * │   │ ✓ AVG = SUM(column) / COUNT(column) where column is NOT NULL  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUM AND AVG - SIMPLE EXAMPLE                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INPUT (hours_logged column):                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 100, 120, 105, 0, 80, 110, 130, NULL, 150, 140                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT SUM(hours_logged) AS total_hours,                        │   │
 * │   │        AVG(hours_logged) AS avg_hours                           │   │
 *   │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: SUM - Add all values (ignoring NULL)                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 100 + 120 + 105 + 0 + 80 + 110 + 130 + 150 + 140 = 935         │   │
 * │   │ (Hank's NULL is ignored)                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: AVG - Sum divided by count of non-NULL values               │   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Non-NULL values: 9 values                                       │   │
 * │   │ 935 / 9 = 103.89                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────┬───────────┐                                         │
 * │   │ total_hours │ avg_hours │                                         │
 * │   ├─────────────┼───────────┤                                         │
 * │   │ 935         │ 103.89    │                                         │
 * │   └─────────────┴───────────┘                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: SUM FUNCTION (Adding up numbers)
-- ============================================================================

/**
 * EXAMPLE 1: Total hours logged by all employees
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUM - Total Hours                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT SUM(hours_logged) AS total_hours                         │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ hours_logged: 100, 120, 105, 0, 80, 110, 130, NULL, 150, 140   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   CALCULATION:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 100 + 120 = 220                                                │   │
 * │   │ 220 + 105 = 325                                                │   │
 *   │   │ 325 + 0 = 325                                                  │   │
 * │   │ 325 + 80 = 405                                                 │   │
 * │   │ 405 + 110 = 515                                                │   │
 * │   │ 515 + 130 = 645                                                │   │
 * │   │ 645 + 150 = 795                                                │   │
 * │   │ 795 + 140 = 935                                                │   │
 * │   │                                                                  │   │
 * │   │ NULL is ignored (not added)                                     │   │
 * │   │ Total = 935                                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────┐                                                     │
 * │   │ total_hours │                                                     │
 * │   ├─────────────┤                                                     │
 * │   │ 935         │                                                     │
 * │   └─────────────┘                                                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    SUM(hours_logged) AS total_hours
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ total_hours │
 * ├─────────────┤
 * │ 935         │
 * └─────────────┘
 * 
 * EXPLANATION:
 * - All hours logged added together
 * - Hank's NULL is ignored
 * - Dave's 0 hours is included (0 is a valid number)
 */

-- EXAMPLE 2: Total quantity of items (like inventory)
SELECT 
    SUM(quantity) AS total_inventory
FROM employees;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ total_inventory  │
 * ├──────────────────┤
 * │ 45               │
 * └──────────────────┘
 * 
 * EXPLANATION:
 * - 5 + 3 + 7 + 2 + 4 + 6 + 8 + 0 + 9 + 1 = 45
 * - Hank's 0 quantity is included
 */

-- ============================================================================
-- PART 3: AVG FUNCTION (Finding averages)
-- ============================================================================

/**
 * EXAMPLE 1: Average hours logged per employee
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    AVG - Average Hours                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT AVG(hours_logged) AS avg_hours                           │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ hours_logged: 100, 120, 105, 0, 80, 110, 130, NULL, 150, 140   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   CALCULATION:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Step 1: SUM = 935 (as calculated above)                        │   │
 * │   │ Step 2: COUNT non-NULL values = 9                              │   │
 * │   │ Step 3: 935 ÷ 9 = 103.888...                                   │   │
 * │   │                                                                  │   │
 * │   │ Result = 103.89 (rounded)                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────────┐                                                       │
 * │   │ avg_hours │                                                       │
 * │   ├───────────┤                                                       │
 *   │   │ 103.89    │                                                       │
 * │   └───────────┘                                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    ROUND(AVG(hours_logged), 2) AS avg_hours
FROM employees;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ avg_hours │
 * ├───────────┤
 * │ 103.89    │
 * └───────────┘
 * 
 * EXPLANATION:
 * - Sum of hours = 935
 * - Count of employees with hours (non-NULL) = 9
 * - Average = 935 / 9 = 103.89
 * - Hank (NULL) is excluded from count
 */

-- EXAMPLE 2: Average experience (shows NULL handling)
SELECT 
    ROUND(AVG(years_experience), 2) AS avg_experience
FROM employees;

/**
 * OUTPUT:
 * ┌────────────────┐
 * │ avg_experience │
 * ├────────────────┤
 * │ 4.33           │
 * └────────────────┘
 * 
 * EXPLANATION:
 * - Sum of experiences = 3+5+7+2+3+4+3+5+6 = 39
 * - Count of non-NULL = 9 (Dave's NULL excluded)
 * - Average = 39 / 9 = 4.33
 */

-- ============================================================================
-- PART 4: SUM AND AVG WITH GROUP BY
-- ============================================================================

/**
 * Use GROUP BY to calculate totals and averages per group.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUM AND AVG WITH GROUP BY                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project,                                                 │   │
 * │   │        SUM(hours_logged) AS total_hours,                        │   │
 * │   │        AVG(years_experience) AS avg_experience                  │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Create buckets by project                                    │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice: 100h,3y  │  │ Eve: 80h,2y     │  │ Heidi: 150h,5y  │        │
 * │   │ Bob: 120h,5y    │  │ Frank: 110h,3y  │  │ Ivan: 140h,6y   │        │
 * │   │ Carol: 105h,7y  │  │ Grace: 130h,4y  │  │                 │        │
 * │   │ Dave: 0h,NULL   │  │ Hank: NULL,3y   │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 2: Calculate SUM and AVG for each bucket                        │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ALPHA: SUM hours = 100+120+105+0 = 325                         │   │
 * │   │        AVG exp = (3+5+7)/3 = 5.0                               │   │
 * │   │                                                                  │   │
 * │   │ BETA:  SUM hours = 80+110+130 = 320 (NULL ignored)             │   │
 * │   │        AVG exp = (2+3+4+3)/4 = 3.0                             │   │
 * │   │                                                                  │   │
 * │   │ GAMMA: SUM hours = 150+140 = 290                               │   │
 * │   │        AVG exp = (5+6)/2 = 5.5                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────────┬────────────────┐                          │
 * │   │ project │ total_hours │ avg_experience │                          │
 * │   ├─────────┼─────────────┼────────────────┤                          │
 * │   │ Alpha   │ 325         │ 5.0            │                          │
 * │   │ Beta    │ 320         │ 3.0            │                          │
 * │   │ Gamma   │ 290         │ 5.5            │                          │
 * │   └─────────┴─────────────┴────────────────┘                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Total hours and average experience per project
SELECT 
    project,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_experience
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬────────────────┐
 * │ project │ total_hours │ avg_experience │
 * ├─────────┼─────────────┼────────────────┤
 * │ Alpha   │ 325         │ 5.0            │
 * │ Beta    │ 320         │ 3.0            │
 * │ Gamma   │ 290         │ 5.5            │
 * └─────────┴─────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - Alpha total: 100 + 120 + 105 + 0 = 325
 * - Alpha average experience: (3 + 5 + 7) / 3 = 5.0 (Dave NULL excluded)
 * - Beta total: 80 + 110 + 130 = 320 (Hank NULL excluded)
 * - Beta average: (2 + 3 + 4 + 3) / 4 = 3.0
 * - Gamma total: 150 + 140 = 290
 * - Gamma average: (5 + 6) / 2 = 5.5
 */

-- EXAMPLE 2: Average hours per role (workload distribution)
SELECT 
    role,
    ROUND(AVG(hours_logged), 1) AS avg_hours,
    COUNT(*) AS employee_count,
    SUM(hours_logged) AS total_hours
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY role
ORDER BY avg_hours DESC;

/**
 * OUTPUT:
 * ┌───────────┬───────────┬─────────────────┬─────────────┐
 * │ role      │ avg_hours │ employee_count  │ total_hours │
 * ├───────────┼───────────┼─────────────────┼─────────────┤
 * │ QA        │ 130.0     │ 2               │ 260         │
 * │ Developer │ 119.0     │ 5               │ 595         │
 * │ Manager   │ 40.0      │ 2               │ 80          │
 * └───────────┴───────────┴─────────────────┴─────────────┘
 * 
 * EXPLANATION:
 * - QA: Bob(120) + Ivan(140) = 260 / 2 = 130
 * - Developer: 100+105+110+130+150 = 595 / 5 = 119
 * - Manager: Eve(80) + Dave(0) = 80 / 2 = 40
 * - Hank (NULL hours) is excluded from calculation
 */

-- EXAMPLE 3: Total inventory per project
SELECT 
    project,
    SUM(quantity) AS total_inventory,
    AVG(quantity) AS avg_inventory,
    COUNT(*) AS employee_count
FROM employees
GROUP BY project
ORDER BY total_inventory DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┬───────────────┬────────────────┐
 * │ project │ total_inventory │ avg_inventory │ employee_count │
 * ├─────────┼─────────────────┼───────────────┼────────────────┤
 * │ Beta    │ 18              │ 4.5           │ 4              │
 * │ Alpha   │ 17              │ 4.25          │ 4              │
 * │ Gamma   │ 10              │ 5.0           │ 2              │
 * └─────────┴─────────────────┴───────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - Beta: 4+6+8+0 = 18, average = 18/4 = 4.5
 * - Alpha: 5+3+7+2 = 17, average = 17/4 = 4.25
 * - Gamma: 9+1 = 10, average = 10/2 = 5.0
 */

-- ============================================================================
-- PART 5: SUM AND AVG WITH WHERE
-- ============================================================================

/**
 * Use WHERE to filter rows BEFORE calculating SUM or AVG.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUM AND AVG WITH WHERE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project,                                                 │   │
 * │   │        SUM(hours_logged) AS developer_hours                     │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE role = 'Developer'                                        │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: WHERE filters to only Developers                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Developers: Alice(100), Carol(105), Frank(110), Grace(130),    │   │
 * │   │             Hank(NULL), Heidi(150)                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: GROUP BY project on remaining rows                          │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice: 100      │  │ Frank: 110      │  │ Heidi: 150      │        │
 * │   │ Carol: 105      │  │ Grace: 130      │  │                 │        │
 * │   │                 │  │ Hank: NULL      │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 3: SUM hours in each bucket (ignoring NULL)                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: 100 + 105 = 205                                         │   │
 * │   │ Beta:  110 + 130 = 240 (Hank NULL ignored)                     │   │
 * │   │ Gamma: 150 = 150                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────────────┐                                       │
 * │   │ project │ developer_hours │                                       │
 * │   ├─────────┼─────────────────┤                                       │
 * │   │ Alpha   │ 205             │                                       │
 * │   │ Beta    │ 240             │                                       │
 * │   │ Gamma   │ 150             │                                       │
 * │   └─────────┴─────────────────┘                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Total hours by Developers only
SELECT 
    project,
    SUM(hours_logged) AS developer_hours
FROM employees
WHERE role = 'Developer'
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┐
 * │ project │ developer_hours │
 * ├─────────┼─────────────────┤
 * │ Alpha   │ 205             │
 * │ Beta    │ 240             │
 * │ Gamma   │ 150             │
 * └─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - WHERE filters to only Developers BEFORE grouping
 * - Alpha: Alice(100) + Carol(105) = 205
 * - Beta: Frank(110) + Grace(130) = 240 (Hank NULL excluded)
 * - Gamma: Heidi(150) = 150
 */

-- EXAMPLE 2: Average experience of Managers only
SELECT 
    ROUND(AVG(years_experience), 1) AS avg_manager_exp
FROM employees
WHERE role = 'Manager';

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ avg_manager_exp  │
 * ├──────────────────┤
 * │ 2.0              │
 * └──────────────────┘
 * 
 * EXPLANATION:
 * - Managers: Eve(2.0), Dave(NULL)
 * - NULL excluded, so average = 2.0 / 1 = 2.0
 */

-- EXAMPLE 3: Total hours for employees with > 100 hours
SELECT 
    SUM(hours_logged) AS total_high_performers_hours,
    COUNT(*) AS high_performer_count,
    ROUND(AVG(hours_logged), 1) AS avg_high_performer_hours
FROM employees
WHERE hours_logged > 100;

/**
 * OUTPUT:
 * ┌────────────────────────────┬───────────────────────┬────────────────────────────┐
 * │ total_high_performers_hours │ high_performer_count │ avg_high_performer_hours │
 * ├────────────────────────────┼───────────────────────┼────────────────────────────┤
 * │ 615                         │ 5                     │ 123.0                      │
 * └────────────────────────────┴───────────────────────┴────────────────────────────┘
 * 
 * EXPLANATION:
 * - Employees with >100 hours: Bob(120), Carol(105), Frank(110), Grace(130), Heidi(150)
 * - Total = 120+105+110+130+150 = 615
 * - Count = 5
 * - Average = 615/5 = 123.0
 */

-- ============================================================================
-- PART 6: SUM AND AVG WITH HAVING
-- ============================================================================

/**
 * Use HAVING to filter groups AFTER aggregation.
 * 
 * EXAMPLE: Find projects with total hours greater than 300
 */

SELECT 
    project,
    SUM(hours_logged) AS total_hours,
    AVG(years_experience) AS avg_exp,
    COUNT(*) AS team_size
FROM employees
GROUP BY project
HAVING SUM(hours_logged) > 300
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬─────────┬───────────┐
 * │ project │ total_hours │ avg_exp │ team_size │
 * ├─────────┼─────────────┼─────────┼───────────┤
 * │ Alpha   │ 325         │ 5.0     │ 4         │
 * │ Beta    │ 320         │ 3.0     │ 4         │
 * └─────────┴─────────────┴─────────┴───────────┘
 * 
 * EXPLANATION:
 * - Gamma has 290 total hours → excluded by HAVING
 * - Alpha and Beta have >300 hours → included
 */

-- EXAMPLE: Find roles with average experience greater than 4 years
SELECT 
    role,
    ROUND(AVG(years_experience), 1) AS avg_exp,
    COUNT(*) AS count
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY role
HAVING AVG(years_experience) > 4
ORDER BY avg_exp DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────┬───────┐
 * │ role      │ avg_exp │ count │
 * ├───────────┼─────────┼───────┤
 * │ QA        │ 5.5     │ 2     │
 * │ Developer │ 4.4     │ 5     │
 * └───────────┴─────────┴───────┘
 * 
 * EXPLANATION:
 * - QA average = 5.5 (>4) → included
 * - Developer average = 4.4 (>4) → included
 * - Manager average = 2.0 (<4) → excluded
 */

-- ============================================================================
-- PART 7: HANDLING NULL VALUES
-- ============================================================================

/**
 * IMPORTANT: SUM and AVG ignore NULL values.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HANDLING NULL VALUES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT SUM(hours_logged) AS total,                              │   │
 * │   │        AVG(hours_logged) AS average                             │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT with NULL:                                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 100, 120, 105, 0, 80, 110, 130, NULL, 150, 140                 │   │
 * │   │                                   ↑                             │   │
 * │   │                                Hank (NULL)                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   PROCESS:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SUM: All non-NULL values added = 935                           │   │
 * │   │      NULL is completely ignored (not treated as 0)             │   │
 * │   │                                                                  │   │
 * │   │ AVG: Sum(935) ÷ Count of non-NULL values(9) = 103.89           │   │
 * │   │      NULL rows are NOT counted in denominator                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────┬─────────┐                                                 │
 * │   │ total │ average │                                                 │
 * │   ├───────┼─────────┤                                                 │
 * │   │ 935   │ 103.89  │                                                 │
 *   │   └───────┴─────────┘                                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate NULL handling in SUM and AVG
SELECT 
    SUM(hours_logged) AS sum_with_nulls,
    AVG(hours_logged) AS avg_with_nulls,
    COUNT(hours_logged) AS count_non_null,
    COUNT(*) AS total_rows
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┬─────────────────┬────────────┐
 * │ sum_with_nulls  │ avg_with_nulls  │ count_non_null  │ total_rows │
 * ├─────────────────┼─────────────────┼─────────────────┼────────────┤
 * │ 935             │ 103.8889        │ 9               │ 10         │
 * └─────────────────┴─────────────────┴─────────────────┴────────────┘
 * 
 * EXPLANATION:
 * - SUM = 935 (NULL ignored, 0 is included)
 * - AVG = 935 / 9 = 103.89 (NULL not counted)
 * - COUNT(hours_logged) = 9 (NULL not counted)
 * - COUNT(*) = 10 (all rows, including NULL)
 */

-- Compare with COALESCE to replace NULL with 0
SELECT 
    SUM(COALESCE(hours_logged, 0)) AS sum_with_zero,
    AVG(COALESCE(hours_logged, 0)) AS avg_with_zero,
    COUNT(*) AS total_rows
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┬────────────┐
 * │ sum_with_zero   │ avg_with_zero   │ total_rows │
 * ├─────────────────┼─────────────────┼────────────┤
 * │ 935             │ 93.5            │ 10         │
 * └─────────────────┴─────────────────┴────────────┘
 * 
 * EXPLANATION:
 * - COALESCE replaces Hank's NULL with 0
 * - SUM same (0 doesn't change total)
 * - AVG = 935 / 10 = 93.5 (now includes Hank as 0)
 */

-- ============================================================================
-- PART 8: SUM WITH DISTINCT (Sum of unique values)
-- ============================================================================

/**
 * SUM(DISTINCT column) adds up only unique values.
 * Useful when you don't want to count duplicates.
 */

-- First, let's add some duplicate data for demonstration
CREATE TEMP TABLE sales (
    product_id INT,
    sale_amount DECIMAL(10,2)
);

INSERT INTO sales VALUES
(1, 100), (1, 100), (1, 100),  -- Same product, same amount
(2, 200), (2, 200),
(3, 300);

-- SUM of all sales (including duplicates)
SELECT SUM(sale_amount) AS total_all_sales FROM sales;
-- Output: 100+100+100+200+200+300 = 1000

-- SUM of DISTINCT sales (each amount counted once)
SELECT SUM(DISTINCT sale_amount) AS total_distinct_sales FROM sales;
-- Output: 100+200+300 = 600

DROP TABLE sales;

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Project Budget Allocation
 * 
 * Calculate total hours and average experience per project
 * to help with budget and resource planning.
 */

SELECT 
    project,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(years_experience), 1) AS avg_experience,
    SUM(hours_logged) * 50 AS estimated_budget  -- Assuming $50 per hour
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY project
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬────────────────┬────────────────────┐
 * │ project │ total_hours │ avg_experience │ estimated_budget   │
 * ├─────────┼─────────────┼────────────────┼────────────────────┤
 * │ Alpha   │ 325         │ 5.0            │ 16250              │
 * │ Beta    │ 320         │ 3.0            │ 16000              │
 * │ Gamma   │ 290         │ 5.5            │ 14500              │
 * └─────────┴─────────────┴────────────────┴────────────────────┘
 */

/**
 * SCENARIO 2: Workload Analysis by Role
 * 
 * Understand which roles are logging the most hours.
 */

SELECT 
    role,
    SUM(hours_logged) AS total_hours,
    ROUND(AVG(hours_logged), 1) AS avg_hours,
    COUNT(*) AS employee_count,
    SUM(hours_logged) * 1.0 / SUM(SUM(hours_logged)) OVER() * 100 AS percentage_of_total
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY role
ORDER BY total_hours DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────────┬───────────┬─────────────────┬────────────────────┐
 * │ role      │ total_hours │ avg_hours │ employee_count  │ percentage_of_total│
 * ├───────────┼─────────────┼───────────┼─────────────────┼────────────────────┤
 * │ Developer │ 595         │ 119.0     │ 5               │ 63.64              │
 * │ QA        │ 260         │ 130.0     │ 2               │ 27.81              │
 * │ Manager   │ 80          │ 40.0      │ 2               │ 8.56               │
 * └───────────┴─────────────┴───────────┴─────────────────┴────────────────────┘
 * 
 * EXPLANATION:
 * - Developers contribute 63.64% of all hours logged
 * - QA contributes 27.81% despite having only 2 people
 * - Managers contribute only 8.56% of hours
 */

/**
 * SCENARIO 3: Inventory Valuation
 * 
 * Calculate total inventory value assuming each item is worth $10.
 */

SELECT 
    project,
    SUM(quantity) AS total_units,
    SUM(quantity) * 10 AS total_value,
    AVG(quantity) AS avg_units_per_employee
FROM employees
GROUP BY project
ORDER BY total_value DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬─────────────┬────────────────────────┐
 * │ project │ total_units │ total_value │ avg_units_per_employee │
 * ├─────────┼─────────────┼─────────────┼────────────────────────┤
 * │ Beta    │ 18          │ 180         │ 4.5                    │
 * │ Alpha   │ 17          │ 170         │ 4.25                   │
 * │ Gamma   │ 10          │ 100         │ 5.0                    │
 * └─────────┴─────────────┴─────────────┴────────────────────────┘
 */

/**
 * SCENARIO 4: Performance Bonus Calculation
 * 
 * Give bonus to projects with average experience > 4 years.
 */

SELECT 
    project,
    ROUND(AVG(years_experience), 1) AS avg_exp,
    SUM(hours_logged) AS total_hours,
    CASE 
        WHEN AVG(years_experience) > 4 THEN SUM(hours_logged) * 2
        ELSE SUM(hours_logged) * 1
    END AS bonus_multiplier,
    CASE 
        WHEN AVG(years_experience) > 4 THEN 'Eligible for Bonus'
        ELSE 'Not Eligible'
    END AS bonus_status
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
ORDER BY avg_exp DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────────┬─────────────────┬─────────────────────┐
 * │ project │ avg_exp │ total_hours │ bonus_multiplier│ bonus_status        │
 * ├─────────┼─────────┼─────────────┼─────────────────┼─────────────────────┤
 * │ Gamma   │ 5.5     │ 290         │ 580             │ Eligible for Bonus  │
 * │ Alpha   │ 5.0     │ 325         │ 650             │ Eligible for Bonus  │
 * │ Beta    │ 3.0     │ 320         │ 320             │ Not Eligible        │
 * └─────────┴─────────┴─────────────┴─────────────────┴─────────────────────┘
 */

/**
 * SCENARIO 5: Monthly Sales Report (Using a sales table)
 * 
 * Let's create a sales table for this example.
 */

CREATE TEMP TABLE monthly_sales (
    month VARCHAR(10),
    product VARCHAR(30),
    sales_amount DECIMAL(10,2)
);

INSERT INTO monthly_sales VALUES
('Jan', 'Laptop', 50000), ('Jan', 'Mouse', 5000), ('Jan', 'Keyboard', 3000),
('Feb', 'Laptop', 45000), ('Feb', 'Mouse', 6000), ('Feb', 'Keyboard', 3500),
('Mar', 'Laptop', 55000), ('Mar', 'Mouse', 5500), ('Mar', 'Keyboard', 4000);

-- Total sales per month
SELECT 
    month,
    SUM(sales_amount) AS total_sales,
    AVG(sales_amount) AS avg_sale_per_product,
    COUNT(*) AS products_sold
FROM monthly_sales
GROUP BY month
ORDER BY month;

/**
 * OUTPUT:
 * ┌───────┬─────────────┬─────────────────────┬───────────────┐
 * │ month │ total_sales │ avg_sale_per_product │ products_sold │
 * ├───────┼─────────────┼─────────────────────┼───────────────┤
 * │ Feb   │ 54500       │ 18166.67            │ 3             │
 * │ Jan   │ 58000       │ 19333.33            │ 3             │
 * │ Mar   │ 64500       │ 21500.00            │ 3             │
 * └───────┴─────────────┴─────────────────────┴───────────────┘
 */

DROP TABLE monthly_sales;

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting that NULLs are ignored                          │
 * │                                                                          │
 * │   ❌ WRONG ASSUMPTION:                                                  │
 * │   AVG(hours_logged) treats NULL as 0                                   │
 * │                                                                          │
 * │   ✅ CORRECT UNDERSTANDING:                                             │
 * │   NULL values are completely ignored                                   │
 * │   AVG = SUM(non-NULL) / COUNT(non-NULL)                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate the difference
SELECT 
    AVG(hours_logged) AS avg_ignoring_nulls,
    AVG(COALESCE(hours_logged, 0)) AS avg_treating_nulls_as_zero
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────────────┬──────────────────────────┐
 * │ avg_ignoring_nulls  │ avg_treating_nulls_as_zero│
 * ├─────────────────────┼──────────────────────────┤
 * │ 103.8889            │ 93.5                     │
 * └─────────────────────┴──────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Using AVG on non-numeric columns                           │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT AVG(employee_name) FROM employees;  -- ERROR!                 │
 * │                                                                          │
 * │   ✅ CORRECT:                                                           │
 * │   AVG only works with numeric columns (INT, DECIMAL, etc.)             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting GROUP BY with non-aggregated columns            │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT project, SUM(hours_logged)                                    │
 * │   FROM employees;  -- ERROR! project not in GROUP BY                   │
 * │                                                                          │
 * │   Why? SUM gives ONE value, but there are 3 projects                   │
 * │        Database doesn't know which project to show                     │
 * │                                                                          │
 * │   ✅ CORRECT:                                                           │
 * │   SELECT project, SUM(hours_logged)                                    │
 * │   FROM employees                                                       │
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
 * │ BASIC SYNTAX:                                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Total of all values                                             │ │
 * │ │ SELECT SUM(column) FROM table_name;                                │ │
 * │ │                                                                     │ │
 * │ │ -- Average of all values                                           │ │
 * │ │ SELECT AVG(column) FROM table_name;                                │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ WITH GROUP BY:                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Per group total and average                                     │ │
 * │ │ SELECT group_column,                                               │ │
 * │ │        SUM(value_column) AS total,                                 │ │
 * │ │        AVG(value_column) AS average                                │ │
 * │ │ FROM table_name                                                     │ │
 * │ │ GROUP BY group_column;                                              │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ WITH WHERE:                                                             │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Filter before calculating                                       │ │
 * │ │ SELECT SUM(column) FROM table_name WHERE condition;                │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ WITH HAVING:                                                            │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Filter groups after aggregation                                 │ │
 * │ │ SELECT group_column, SUM(column) AS total                          │ │
 * │ │ FROM table_name                                                     │ │
 * │ │ GROUP BY group_column                                               │ │
 * │ │ HAVING SUM(column) > 100;                                           │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ HANDLING NULLS:                                                         │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Replace NULL with 0 before calculation                          │ │
 * │ │ SELECT AVG(COALESCE(column, 0)) FROM table_name;                   │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Total sales per product                                         │ │
 * │ │ SELECT product, SUM(sales) FROM orders GROUP BY product            │ │
 * │ │                                                                     │ │
 * │ │ -- Average order value per customer                                │ │
 * │ │ SELECT customer_id, AVG(order_total) FROM orders GROUP BY cust_id  │ │
 * │ │                                                                     │ │
 * │ │ -- Total revenue by month                                          │ │
 * │ │ SELECT MONTH(date), SUM(amount) FROM sales GROUP BY MONTH(date)    │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Calculate total inventory value
 * 
 * Answer:
 *   SELECT SUM(quantity * 100) AS total_value FROM employees;
 */

/**
 * EXERCISE 2: Find average years of experience by role
 * 
 * Answer:
 *   SELECT role, AVG(years_experience) AS avg_exp
 *   FROM employees
 *   GROUP BY role;
 */

/**
 * EXERCISE 3: Find projects with total hours > 300
 * 
 * Answer:
 *   SELECT project, SUM(hours_logged) AS total_hours
 *   FROM employees
 *   GROUP BY project
 *   HAVING SUM(hours_logged) > 300;
 */

/**
 * EXERCISE 4: Calculate average hours for Developers only
 * 
 * Answer:
 *   SELECT AVG(hours_logged) AS avg_dev_hours
 *   FROM employees
 *   WHERE role = 'Developer';
 */

/**
 * EXERCISE 5: Find total hours and average experience per project,
 *            only for projects with at least 3 employees
 * 
 * Answer:
 *   SELECT project, 
 *          SUM(hours_logged) AS total_hours,
 *          AVG(years_experience) AS avg_exp
 *   FROM employees
 *   GROUP BY project
 *   HAVING COUNT(*) >= 3;
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
 * │ 1. SUM() = Adds up all values in a column                              │
 * │    AVG() = Calculates the average (mean) of values                     │
 * │                                                                          │
 * │ 2. Only work with NUMERIC columns (INT, DECIMAL, etc.)                 │
 * │                                                                          │
 * │ 3. NULL values are IGNORED (not treated as 0)                          │
 * │    → AVG = SUM(non-NULL) / COUNT(non-NULL)                             │
 * │                                                                          │
 * │ 4. Use GROUP BY to calculate per group                                 │
 * │                                                                          │
 * │ 5. Use WHERE to filter BEFORE calculating                              │
 * │                                                                          │
 * │ 6. Use HAVING to filter groups AFTER calculating                       │
 * │                                                                          │
 * │ 7. Use COALESCE to replace NULL with a value (like 0)                  │
 * │                                                                          │
 * │ 8. Common use cases:                                                    │
 * │    → Total sales, revenue, hours                                       │
 * │    → Average order value, rating, score                                │
 * │    → Budget planning, resource allocation                              │
 * │    → Performance metrics, KPIs                                         │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - SUM and AVG ignore NULLs                                           │
 * │   - AVG of all NULLs returns NULL                                      │
 * │   - Use COALESCE if you want NULL treated as 0                         │
 * │   - Always use GROUP BY with non-aggregated columns                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF SUM & AVG GUIDE
-- ============================================================================