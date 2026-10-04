/**
 * ============================================================================
 * MIN & MAX - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE MIN AND MAX? ---------------- (Finding smallest and largest)
 * 2. MIN AND MAX WITH NUMBERS ------------- (Basic examples)
 * 3. MIN AND MAX WITH DATES --------------- (Earliest and latest dates)
 * 4. MIN AND MAX WITH TEXT ---------------- (Alphabetical order)
 * 5. MIN AND MAX WITH GROUP BY ------------ (Per group calculations)
 * 6. MIN AND MAX WITH WHERE --------------- (Filter before finding min/max)
 * 7. MIN AND MAX WITH HAVING -------------- (Filter after grouping)
 * 8. HANDLING NULL VALUES ----------------- (How NULL affects results)
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
-- PART 1: WHAT ARE MIN AND MAX?
-- ============================================================================

/**
 * MIN and MAX are aggregate functions that find the smallest and largest values.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT ARE MIN AND MAX?                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   MIN() = Returns the SMALLEST value in a column                       │
 * │   MAX() = Returns the LARGEST value in a column                        │
 *                                                                          │
 * │   WORKS WITH:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ✓ NUMBERS → 1, 2, 3, 100 → MIN=1, MAX=100                      │   │
 * │   │ ✓ DATES   → 2020-01-01, 2024-12-31 → MIN=earliest, MAX=latest   │   │
 * │   │ ✓ TEXT    → Apple, Banana, Cherry → MIN=Apple, MAX=Cherry       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Test scores in a class: 45, 67, 89, 92, 78                     │   │
 * │   │                                                                  │   │
 * │   │ MIN(score) = 45 (lowest score)                                  │   │
 * │   │ MAX(score) = 92 (highest score)                                 │   │
 * │   │                                                                  │   │
 * │   │ This helps teachers know the range of student performance       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MIN AND MAX - SIMPLE EXAMPLE                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INPUT (years_experience column):                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 3.0, 5.0, 7.0, NULL, 2.0, 3.0, 4.0, 3.0, 5.0, 6.0             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT MIN(years_experience) AS min_exp,                        │   │
 * │   │        MAX(years_experience) AS max_exp                         │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Find smallest value (ignoring NULL)                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Values: 3.0, 5.0, 7.0, 2.0, 3.0, 4.0, 3.0, 5.0, 6.0            │   │
 * │   │ Smallest = 2.0                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Find largest value (ignoring NULL)                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Values: 3.0, 5.0, 7.0, 2.0, 3.0, 4.0, 3.0, 5.0, 6.0            │   │
 * │   │ Largest = 7.0                                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────┐                                               │
 * │   │ min_exp │ max_exp │                                               │
 * │   ├─────────┼─────────┤                                               │
 * │   │ 2.0     │ 7.0     │                                               │
 * │   └─────────┴─────────┘                                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: MIN AND MAX WITH NUMBERS
-- ============================================================================

/**
 * EXAMPLE 1: Find overall minimum and maximum experience in the company
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MIN AND MAX - Whole Company                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT MIN(years_experience) AS min_experience,                 │   │
 * │   │        MAX(years_experience) AS max_experience                  │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ years_experience: 3.0, 5.0, 7.0, NULL, 2.0, 3.0, 4.0, 3.0, 5.0, 6.0│
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   PROCESS:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Ignore NULL → Find smallest: 2.0 (Eve)                         │   │
 * │   │ Ignore NULL → Find largest: 7.0 (Carol)                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────────────────┬────────────────┐                                 │
 * │   │ min_experience │ max_experience │                                 │
 *   │   ├────────────────┼────────────────┤                                 │
 * │   │ 2.0            │ 7.0            │                                 │
 * │   └────────────────┴────────────────┘                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    MIN(years_experience) AS min_experience,
    MAX(years_experience) AS max_experience
FROM employees;

/**
 * OUTPUT:
 * ┌────────────────┬────────────────┐
 * │ min_experience │ max_experience │
 * ├────────────────┼────────────────┤
 * │ 2.0            │ 7.0            │
 * └────────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - Minimum experience: 2.0 years (Eve)
 * - Maximum experience: 7.0 years (Carol)
 * - Dave with NULL experience is ignored
 */

-- EXAMPLE 2: Find minimum and maximum hours logged
SELECT 
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours
FROM employees;

/**
 * OUTPUT:
 * ┌───────────┬───────────┐
 * │ min_hours │ max_hours │
 * ├───────────┼───────────┤
 * │ 0         │ 150       │
 * └───────────┴───────────┘
 * 
 * EXPLANATION:
 * - Minimum hours: 0 (Dave - Manager with no hours logged)
 * - Maximum hours: 150 (Heidi - Developer in Gamma project)
 * - Hank with NULL hours is ignored
 */

-- ============================================================================
-- PART 3: MIN AND MAX WITH DATES
-- ============================================================================

-- First, add a dates table for demonstration
CREATE TEMP TABLE employee_dates (
    emp_id INT,
    emp_name VARCHAR(50),
    join_date DATE,
    last_review_date DATE
);

INSERT INTO employee_dates VALUES
(1, 'Alice', '2020-01-15', '2024-03-10'),
(2, 'Bob', '2021-03-20', '2024-02-15'),
(3, 'Carol', '2019-06-10', '2024-04-20'),
(4, 'Dave', '2022-08-01', '2024-01-05'),
(5, 'Eve', '2023-01-10', '2024-05-01');

/**
 * EXAMPLE: Find earliest and latest join dates
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MIN AND MAX WITH DATES                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT MIN(join_date) AS earliest_join,                         │   │
 * │   │        MAX(join_date) AS latest_join                            │   │
 * │   │ FROM employee_dates;                                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT (join_date):                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 2020-01-15, 2021-03-20, 2019-06-10, 2022-08-01, 2023-01-10     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   PROCESS:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ MIN = earliest date = 2019-06-10 (Carol)                       │   │
 * │   │ MAX = latest date = 2023-01-10 (Eve)                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────────────┬─────────────┐                                     │
 * │   │ earliest_join │ latest_join │                                     │
 * │   ├───────────────┼─────────────┤                                     │
 * │   │ 2019-06-10    │ 2023-01-10  │                                     │
 * │   └───────────────┴─────────────┘                                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    MIN(join_date) AS earliest_join,
    MAX(join_date) AS latest_join
FROM employee_dates;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────┐
 * │ earliest_join │ latest_join │
 * ├───────────────┼─────────────┤
 * │ 2019-06-10    │ 2023-01-10  │
 * └───────────────┴─────────────┘
 */

-- Clean up
DROP TABLE employee_dates;

-- ============================================================================
-- PART 4: MIN AND MAX WITH TEXT (Alphabetical order)
-- ============================================================================

/**
 * For text, MIN returns the earliest alphabetically (A comes before B).
 * For text, MAX returns the latest alphabetically (Z comes after A).
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MIN AND MAX WITH TEXT                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT MIN(employee_name) AS first_name,                        │   │
 * │   │        MAX(employee_name) AS last_name                          │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT (employee_name):                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alice, Bob, Carol, Dave, Eve, Frank, Grace, Hank, Heidi, Ivan  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   PROCESS:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Sorted alphabetically:                                          │   │
 * │   │ Alice → Bob → Carol → Dave → Eve → Frank → Grace → Hank →       │   │
 * │   │ Heidi → Ivan                                                    │   │
 * │   │                                                                  │   │
 * │   │ MIN = first in alphabet = Alice                                 │   │
 * │   │ MAX = last in alphabet = Ivan                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────────────┬───────────┐                                          │
 * │   │ first_name │ last_name │                                          │
 * │   ├────────────┼───────────┤                                          │
 * │   │ Alice      │ Ivan      │                                          │
 * │   └────────────┴───────────┘                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    MIN(employee_name) AS first_name_alphabetically,
    MAX(employee_name) AS last_name_alphabetically
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────────────────┬────────────────────────┐
 * │ first_name_alphabetically │ last_name_alphabetically │
 * ├─────────────────────────┼────────────────────────┤
 * │ Alice                   │ Ivan                   │
 * └─────────────────────────┴────────────────────────┘
 * 
 * EXPLANATION:
 * - MIN on text returns earliest alphabetically (A-Z)
 * - MAX on text returns latest alphabetically (Z-A)
 * - 'Alice' comes before 'Ivan' alphabetically
 */

-- Example with roles
SELECT 
    MIN(role) AS first_role,
    MAX(role) AS last_role
FROM employees;

/**
 * OUTPUT:
 * ┌────────────┬───────────┐
 * │ first_role │ last_role │
 * ├────────────┼───────────┤
 * │ Developer  │ QA        │
 * └────────────┴───────────┘
 * 
 * EXPLANATION:
 * - Sorted roles: Developer, Manager, QA
 * - MIN = Developer (first alphabetically)
 * - MAX = QA (last alphabetically)
 */

-- ============================================================================
-- PART 5: MIN AND MAX WITH GROUP BY
-- ============================================================================

/**
 * You can use MIN and MAX with GROUP BY to find smallest and largest
 * values within each group.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MIN AND MAX WITH GROUP BY                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT project,                                                 │   │
 * │   │        MIN(years_experience) AS min_exp,                        │   │
 * │   │        MAX(years_experience) AS max_exp                         │   │
 * │   │ FROM employees                                                  │   │
 * │   │ GROUP BY project;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Create buckets by project                                    │
 * │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │
 * │   │ ALPHA BUCKET    │  │ BETA BUCKET     │  │ GAMMA BUCKET    │        │
 * │   ├─────────────────┤  ├─────────────────┤  ├─────────────────┤        │
 * │   │ Alice: 3.0      │  │ Eve: 2.0        │  │ Heidi: 5.0      │        │
 * │   │ Bob: 5.0        │  │ Frank: 3.0      │  │ Ivan: 6.0       │        │
 * │   │ Carol: 7.0      │  │ Grace: 4.0      │  │                 │        │
 * │   │ Dave: NULL      │  │ Hank: 3.0       │  │                 │        │
 * │   └─────────────────┘  └─────────────────┘  └─────────────────┘        │
 * │                                                                          │
 * │   STEP 2: Find MIN and MAX in each bucket                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Alpha: MIN=3.0, MAX=7.0                                        │   │
 * │   │ Beta:  MIN=2.0, MAX=4.0                                        │   │
 * │   │ Gamma: MIN=5.0, MAX=6.0                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬────────────┬────────────┐                               │
 * │   │ project │ min_exp    │ max_exp    │                               │
 * │   ├─────────┼────────────┼────────────┤                               │
 * │   │ Alpha   │ 3.0        │ 7.0        │                               │
 * │   │ Beta    │ 2.0        │ 4.0        │                               │
 * │   │ Gamma   │ 5.0        │ 6.0        │                               │
 * │   └─────────┴────────────┴────────────┘                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Min and max experience per project
SELECT 
    project,
    MIN(years_experience) AS min_experience,
    MAX(years_experience) AS max_experience
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬────────────────┬────────────────┐
 * │ project │ min_experience │ max_experience │
 * ├─────────┼────────────────┼────────────────┤
 * │ Alpha   │ 3.0            │ 7.0            │
 * │ Beta    │ 2.0            │ 4.0            │
 * │ Gamma   │ 5.0            │ 6.0            │
 * └─────────┴────────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - Alpha team: experience ranges from 3 to 7 years (wide range)
 * - Beta team: from 2 to 4 years (more junior, narrower range)
 * - Gamma team: from 5 to 6 years (more experienced, tight range)
 * - Dave with NULL experience is ignored in MIN/MAX
 */

-- EXAMPLE 2: Min and max hours logged per project
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
 * 
 * EXPLANATION:
 * - Alpha: Dave with 0 hours (Manager), Bob with 120 hours (QA)
 * - Beta: Eve with 80 hours (Manager), Grace with 130 hours (Developer)
 * - Gamma: Heidi with 150 hours, Ivan with 140 hours
 * - Hank with NULL hours is ignored
 */

-- EXAMPLE 3: First and last employee name per project (alphabetical)
SELECT 
    project,
    MIN(employee_name) AS first_name,
    MAX(employee_name) AS last_name
FROM employees
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬───────────┐
 * │ project │ first_name │ last_name │
 * ├─────────┼────────────┼───────────┤
 * │ Alpha   │ Alice      │ Dave      │
 * │ Beta    │ Eve        │ Hank      │
 * │ Gamma   │ Heidi      │ Ivan      │
 * └─────────┴────────────┴───────────┘
 * 
 * EXPLANATION:
 * - Alpha names sorted: Alice, Bob, Carol, Dave
 * - Beta names sorted: Eve, Frank, Grace, Hank
 * - Gamma names sorted: Heidi, Ivan
 */

-- ============================================================================
-- PART 6: MIN AND MAX WITH WHERE
-- ============================================================================

/**
 * Use WHERE to filter rows BEFORE finding min/max.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    MIN AND MAX WITH WHERE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT MIN(years_experience) AS min_exp,                        │   │
 * │   │        MAX(years_experience) AS max_exp                         │   │
 * │   │ FROM employees                                                  │   │
 * │   │ WHERE role = 'Developer';                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: WHERE filters to only Developers                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Developers: Alice(3.0), Carol(7.0), Frank(3.0), Grace(4.0),    │   │
 * │   │             Hank(3.0), Heidi(5.0)                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Find MIN and MAX among Developers                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Values: 3.0, 7.0, 3.0, 4.0, 3.0, 5.0                           │   │
 * │   │ MIN = 3.0                                                       │   │
 * │   │ MAX = 7.0                                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────┐                                               │
 * │   │ min_exp │ max_exp │                                               │
 * │   ├─────────┼─────────┤                                               │
 * │   │ 3.0     │ 7.0     │                                               │
 * │   └─────────┴─────────┘                                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Min and max experience for Developers only
SELECT 
    MIN(years_experience) AS min_developer_exp,
    MAX(years_experience) AS max_developer_exp
FROM employees
WHERE role = 'Developer';

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────────┐
 * │ min_developer_exp   │ max_developer_exp   │
 * ├─────────────────────┼─────────────────────┤
 * │ 3.0                 │ 7.0                 │
 * └─────────────────────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Only Developer rows are considered
 * - Developers: Alice(3.0), Carol(7.0), Frank(3.0), Grace(4.0), Hank(3.0), Heidi(5.0)
 * - Minimum = 3.0 years, Maximum = 7.0 years
 */

-- EXAMPLE 2: Min and max hours for employees with logged hours
SELECT 
    MIN(hours_logged) AS min_hours_with_logs,
    MAX(hours_logged) AS max_hours_with_logs
FROM employees
WHERE hours_logged IS NOT NULL AND hours_logged > 0;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────────┐
 * │ min_hours_with_logs │ max_hours_with_logs │
 * ├─────────────────────┼─────────────────────┤
 * │ 80                  │ 150                 │
 * └─────────────────────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Excludes Dave (0 hours) and Hank (NULL)
 * - Remaining: 100, 120, 105, 80, 110, 130, 150, 140
 * - Minimum = 80, Maximum = 150
 */

-- ============================================================================
-- PART 7: MIN AND MAX WITH HAVING
-- ============================================================================

/**
 * Use HAVING to filter groups AFTER grouping and aggregation.
 */

-- EXAMPLE: Find projects where max experience is greater than 6 years
SELECT 
    project,
    MIN(years_experience) AS min_exp,
    MAX(years_experience) AS max_exp
FROM employees
GROUP BY project
HAVING MAX(years_experience) > 6
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────┐
 * │ project │ min_exp │ max_exp │
 * ├─────────┼─────────┼─────────┤
 * │ Alpha   │ 3.0     │ 7.0     │
 * └─────────┴─────────┴─────────┘
 * 
 * EXPLANATION:
 * - Only Alpha has max experience > 6 years (7.0)
 * - Beta max = 4.0, Gamma max = 6.0 → excluded
 */

-- EXAMPLE: Find projects where min hours is less than 50
SELECT 
    project,
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours
FROM employees
GROUP BY project
HAVING MIN(hours_logged) < 50
ORDER BY project;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬───────────┐
 * │ project │ min_hours │ max_hours │
 * ├─────────┼───────────┼───────────┤
 * │ Alpha   │ 0         │ 120       │
 * └─────────┴───────────┴───────────┘
 * 
 * EXPLANATION:
 * - Only Alpha has min hours < 50 (Dave has 0 hours)
 * - Beta min = 80, Gamma min = 140 → excluded
 */

-- ============================================================================
-- PART 8: HANDLING NULL VALUES
-- ============================================================================

/**
 * IMPORTANT: MIN and MAX ignore NULL values.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    HANDLING NULL VALUES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT MIN(years_experience) AS min_exp,                        │   │
 * │   │        MAX(years_experience) AS max_exp                         │   │
 * │   │ FROM employees;                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT with NULL:                                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 3.0, 5.0, 7.0, NULL, 2.0, 3.0, 4.0, 3.0, 5.0, 6.0             │   │
 * │   │                      ↑                                           │   │
 * │   │                   Dave (NULL)                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   PROCESS:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ NULL values are IGNORED (not treated as 0)                     │   │
 * │   │ MIN looks at: 3.0, 5.0, 7.0, 2.0, 3.0, 4.0, 3.0, 5.0, 6.0      │   │
 * │   │ MAX looks at: same set                                          │   │
 * │   │                                                                  │   │
 * │   │ Result: MIN=2.0, MAX=7.0                                       │   │
 * │   │                                                                  │   │
 * │   │ Dave's NULL is completely ignored!                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬─────────┐                                               │
 * │   │ min_exp │ max_exp │                                               │
 * │   ├─────────┼─────────┤                                               │
 * │   │ 2.0     │ 7.0     │                                               │
 * │   └─────────┴─────────┘                                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate NULL handling
SELECT 
    MIN(years_experience) AS min_with_nulls,
    MAX(years_experience) AS max_with_nulls
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┐
 * │ min_with_nulls  │ max_with_nulls  │
 * ├─────────────────┼─────────────────┤
 * │ 2.0             │ 7.0             │
 * └─────────────────┴─────────────────┘
 * 
 * NOTE: Dave's NULL experience is ignored.
 *       If all values were NULL, MIN and MAX would return NULL.
 */

-- Compare with COALESCE to handle NULLs differently
SELECT 
    MIN(COALESCE(years_experience, 0)) AS min_with_zero,
    MAX(COALESCE(years_experience, 0)) AS max_with_zero
FROM employees;

/**
 * OUTPUT:
 * ┌────────────────┬────────────────┐
 * │ min_with_zero  │ max_with_zero  │
 * ├────────────────┼────────────────┤
 * │ 0.0            │ 7.0            │
 * └────────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - COALESCE converts NULL to 0
 * - Now Dave's experience is treated as 0
 * - Minimum becomes 0 instead of 2.0
 */

-- ============================================================================
-- PART 8: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Salary Range by Department
 * 
 * Find the minimum and maximum salary in each department.
 * (Using our employees table as an example)
 */

SELECT 
    project AS department,
    MIN(years_experience * 50000) AS min_salary_estimate,
    MAX(years_experience * 50000) AS max_salary_estimate,
    ROUND(AVG(years_experience * 50000), 0) AS avg_salary_estimate
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
ORDER BY project;

/**
 * OUTPUT:
 * ┌────────────┬────────────────────┬────────────────────┬────────────────────┐
 * │ department │ min_salary_estimate│ max_salary_estimate│ avg_salary_estimate│
 * ├────────────┼────────────────────┼────────────────────┼────────────────────┤
 * │ Alpha      │ 150000             │ 350000             │ 250000             │
 * │ Beta       │ 100000             │ 200000             │ 150000             │
 * │ Gamma      │ 250000             │ 300000             │ 275000             │
 * └────────────┴────────────────────┴────────────────────┴────────────────────┘
 */

/**
 * SCENARIO 2: Employee Tenure Range
 * 
 * Find the earliest and latest hire dates by role.
 */

-- Add hire_date column for this scenario
ALTER TABLE employees ADD COLUMN hire_date DATE;

UPDATE employees SET hire_date = CASE emp_id
    WHEN 1 THEN '2020-01-15'
    WHEN 2 THEN '2021-03-20'
    WHEN 3 THEN '2019-06-10'
    WHEN 4 THEN '2022-08-01'
    WHEN 5 THEN '2023-01-10'
    WHEN 6 THEN '2021-11-05'
    WHEN 7 THEN '2020-09-22'
    WHEN 8 THEN '2022-02-14'
    WHEN 9 THEN '2021-07-19'
    WHEN 10 THEN '2020-12-03'
END;

SELECT 
    role,
    MIN(hire_date) AS earliest_hire,
    MAX(hire_date) AS latest_hire,
    COUNT(*) AS employee_count
FROM employees
GROUP BY role
ORDER BY role;

/**
 * OUTPUT:
 * ┌───────────┬───────────────┬─────────────┬────────────────┐
 * │ role      │ earliest_hire │ latest_hire │ employee_count │
 * ├───────────┼───────────────┼─────────────┼────────────────┤
 * │ Developer │ 2019-06-10    │ 2022-02-14  │ 6              │
 * │ Manager   │ 2022-08-01    │ 2023-01-10  │ 2              │
 * │ QA        │ 2020-12-03    │ 2021-03-20  │ 2              │
 * └───────────┴───────────────┴─────────────┴────────────────┘
 */

/**
 * SCENARIO 3: Project Age Analysis
 * 
 * Identify the most junior and most senior employee in each project.
 */

SELECT 
    project,
    MIN(employee_name) AS most_junior,  -- Using name as proxy
    MIN(years_experience) AS min_exp,
    MAX(employee_name) AS most_senior,
    MAX(years_experience) AS max_exp,
    MAX(years_experience) - MIN(years_experience) AS experience_gap
FROM employees
WHERE years_experience IS NOT NULL
GROUP BY project
ORDER BY experience_gap DESC;

/**
 * OUTPUT:
 * ┌─────────┬──────────────┬─────────┬─────────────┬─────────┬─────────────────┐
 * │ project │ most_junior  │ min_exp │ most_senior │ max_exp │ experience_gap  │
 * ├─────────┼──────────────┼─────────┼─────────────┼─────────┼─────────────────┤
 * │ Alpha   │ Alice        │ 3.0     │ Dave        │ 7.0     │ 4.0             │
 * │ Beta    │ Eve          │ 2.0     │ Hank        │ 4.0     │ 2.0             │
 * │ Gamma   │ Heidi        │ 5.0     │ Ivan        │ 6.0     │ 1.0             │
 * └─────────┴──────────────┴─────────┴─────────────┴─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Alpha has the largest experience gap (4 years)
 * - Gamma has the smallest experience gap (1 year)
 */

/**
 * SCENARIO 4: Workload Balance Analysis
 * 
 * Check if workload is balanced within each project.
 */

SELECT 
    project,
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours,
    AVG(hours_logged) AS avg_hours,
    MAX(hours_logged) - MIN(hours_logged) AS hours_spread
FROM employees
WHERE hours_logged IS NOT NULL
GROUP BY project
ORDER BY hours_spread DESC;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬───────────┬────────────┬───────────────┐
 * │ project │ min_hours │ max_hours │ avg_hours  │ hours_spread  │
 * ├─────────┼───────────┼───────────┼────────────┼───────────────┤
 * │ Alpha   │ 0         │ 120       │ 81.25      │ 120           │
 * │ Beta    │ 80        │ 130       │ 106.67     │ 50            │
 * │ Gamma   │ 140       │ 150       │ 145.00     │ 10            │
 * └─────────┴───────────┴───────────┴────────────┴───────────────┘
 * 
 * EXPLANATION:
 * - Alpha has very unbalanced workload (Dave with 0 hours)
 * - Gamma has very balanced workload (140-150 hours)
 */

/**
 * SCENARIO 5: Company-Wide Statistics
 * 
 * Get overall company metrics for the annual report.
 */

SELECT 
    COUNT(*) AS total_employees,
    MIN(years_experience) AS min_experience,
    MAX(years_experience) AS max_experience,
    ROUND(AVG(years_experience), 1) AS avg_experience,
    MIN(hours_logged) AS min_hours,
    MAX(hours_logged) AS max_hours,
    ROUND(AVG(hours_logged), 1) AS avg_hours
FROM employees
WHERE years_experience IS NOT NULL;

/**
 * OUTPUT:
 * ┌──────────────────┬────────────────┬────────────────┬────────────────┬───────────┬───────────┬────────────┐
 * │ total_employees  │ min_experience │ max_experience │ avg_experience │ min_hours │ max_hours │ avg_hours  │
 * ├──────────────────┼────────────────┼────────────────┼────────────────┼───────────┼───────────┼────────────┤
 * │ 9                │ 2.0            │ 7.0            │ 4.3            │ 0         │ 150       │ 113.8      │
 * └──────────────────┴────────────────┴────────────────┴────────────────┴───────────┴───────────┴────────────┘
 */

-- ============================================================================
-- PART 9: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Expecting MIN/MAX to ignore 0                              │
 * │                                                                          │
 * │   ❌ WRONG ASSUMPTION:                                                  │
 * │   MIN(hours_logged) returns 0 (Dave)                                   │
 * │   Some people think 0 should be ignored like NULL                      │
 * │                                                                          │
 * │   ✅ CORRECT UNDERSTANDING:                                             │
 * │   0 is a valid number, not NULL                                        │
 * │   MIN will include 0 if it exists                                      │
 * │   Use WHERE hours_logged > 0 to exclude zeros                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate 0 vs NULL difference
SELECT 
    MIN(hours_logged) AS min_with_zero,
    MIN(CASE WHEN hours_logged > 0 THEN hours_logged END) AS min_without_zero
FROM employees;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────────┐
 * │ min_with_zero   │ min_without_zero    │
 * ├─────────────────┼─────────────────────┤
 * │ 0               │ 80                  │
 * └─────────────────┴─────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Forgetting NULL values are ignored                         │
 * │                                                                          │
 * │   If a column has only NULL values, MIN and MAX return NULL            │
 * │   This can be confusing in reports                                     │
 * │                                                                          │
 * │   ✅ Use COALESCE to handle NULLs:                                      │
 * │   MIN(COALESCE(column, 0))                                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate all NULLs scenario
CREATE TEMP TABLE test_nulls (value INT);
INSERT INTO test_nulls VALUES (NULL), (NULL), (NULL);

SELECT 
    MIN(value) AS min_result,
    MAX(value) AS max_result
FROM test_nulls;

/**
 * OUTPUT:
 * ┌────────────┬────────────┐
 * │ min_result │ max_result │
 * ├────────────┼────────────┤
 * │ NULL       │ NULL       │
 * └────────────┴────────────┘
 */

DROP TABLE test_nulls;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using MIN/MAX with non-aggregated columns without GROUP BY │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT employee_name, MIN(years_experience)                          │
 * │   FROM employees;  ← ERROR! employee_name not aggregated              │
 * │                                                                          │
 * │   Why? MIN gives ONE value (2.0), but there are 10 employee_names      │
 * │        Database doesn't know which name to show                        │
 * │                                                                          │
 * │   ✅ CORRECT — Either remove employee_name:                            │
 * │   SELECT MIN(years_experience) FROM employees;                         │
 * │                                                                          │
 * │   ✅ OR add GROUP BY:                                                   │
 * │   SELECT employee_name, MIN(years_experience) FROM employees          │
 * │   GROUP BY employee_name;  (returns each employee's experience)       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 10: QUICK REFERENCE (Cheat sheet)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE - CHEAT SHEET                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ BASIC SYNTAX:                                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Whole table minimum and maximum                                 │ │
 * │ │ SELECT MIN(column) AS min_value, MAX(column) AS max_value          │ │
 * │ │ FROM table_name;                                                    │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ WITH GROUP BY:                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Per group minimum and maximum                                   │ │
 * │ │ SELECT group_column,                                               │ │
 * │ │        MIN(value_column) AS min_value,                             │ │
 * │ │        MAX(value_column) AS max_value                              │ │
 * │ │ FROM table_name                                                     │ │
 * │ │ GROUP BY group_column;                                              │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ WITH WHERE:                                                             │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Filter before finding min/max                                   │ │
 * │ │ SELECT MIN(column) AS min_value                                    │ │
 * │ │ FROM table_name                                                     │ │
 * │ │ WHERE condition;                                                    │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ HANDLING NULLS:                                                         │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Replace NULL with default value                                 │ │
 * │ │ SELECT MIN(COALESCE(column, 0)) AS min_value                       │ │
 * │ │ FROM table_name;                                                    │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Salary range per department                                     │ │
 * │ │ SELECT dept, MIN(salary), MAX(salary) FROM employees GROUP BY dept │ │
 * │ │                                                                     │ │
 * │ │ -- Date range of orders                                            │ │
 * │ │ SELECT MIN(order_date), MAX(order_date) FROM orders                │ │
 * │ │                                                                     │ │
 * │ │ -- Price range per category                                        │ │
 * │ │ SELECT category, MIN(price), MAX(price) FROM products GROUP BY cat │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find the lowest and highest price in products table
 * 
 * Answer:
 *   SELECT MIN(price) AS lowest_price, MAX(price) AS highest_price
 *   FROM products;
 */

/**
 * EXERCISE 2: Find the earliest and latest order date per customer
 * 
 * Answer:
 *   SELECT customer_id, MIN(order_date) AS first_order, MAX(order_date) AS last_order
 *   FROM orders
 *   GROUP BY customer_id;
 */

/**
 * EXERCISE 3: Find the project with the most experienced developer
 * 
 * Answer:
 *   SELECT project, MAX(years_experience) AS max_exp
 *   FROM employees
 *   WHERE role = 'Developer'
 *   GROUP BY project
 *   ORDER BY max_exp DESC
 *   LIMIT 1;
 */

/**
 * EXERCISE 4: Find employees who have logged more than the average hours
 * 
 * Answer:
 *   SELECT employee_name, hours_logged
 *   FROM employees
 *   WHERE hours_logged > (SELECT AVG(hours_logged) FROM employees);
 */

/**
 * EXERCISE 5: Find the salary gap (max - min) per department
 * 
 * Answer:
 *   SELECT department, MAX(salary) - MIN(salary) AS salary_gap
 *   FROM employees
 *   GROUP BY department;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

-- Remove the hire_date column we added
ALTER TABLE employees DROP COLUMN IF EXISTS hire_date;

DROP TABLE IF EXISTS employees;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. MIN() = Returns the smallest value in a column                      │
 * │    MAX() = Returns the largest value in a column                       │
 * │                                                                          │
 * │ 2. Works with:                                                          │
 * │    → NUMBERS: 1, 2, 3 → MIN=1, MAX=3                                  │
 * │    → DATES:   2020-01-01, 2024-12-31 → MIN=earliest, MAX=latest        │
 * │    → TEXT:    Apple, Banana → MIN=Apple (A), MAX=Banana (Z)            │
 * │                                                                          │
 * │ 3. NULL values are IGNORED (not treated as 0)                          │
 * │                                                                          │
 * │ 4. Use GROUP BY to find min/max per group                              │
 * │                                                                          │
 * │ 5. Use WHERE to filter before finding min/max                          │
 * │                                                                          │
 * │ 6. Use HAVING to filter groups after finding min/max                   │
 * │                                                                          │
 * │ 7. Common use cases:                                                    │
 * │    → Salary range in each department                                   │
 * │    → Date range of orders                                              │
 * │    → Age range of employees                                            │
 * │    → Price range of products                                           │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - MIN and MAX ignore NULLs                                           │
 * │   - 0 is a valid value (not ignored)                                   │
 * │   - For text, MIN = earliest alphabetically (A-Z)                      │
 * │   - For text, MAX = latest alphabetically (Z-A)                        │
 * │   - Use COALESCE to handle NULLs if needed                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF MIN & MAX GUIDE
-- ============================================================================