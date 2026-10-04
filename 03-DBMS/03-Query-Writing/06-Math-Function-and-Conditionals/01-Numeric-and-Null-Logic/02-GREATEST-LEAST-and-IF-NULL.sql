/**
 * ============================================================================
 * GREATEST, LEAST, COALESCE, NULLIF - COMPLETE REVISION GUIDE
 * (Horizontal comparison and NULL handling functions)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. GREATEST() and LEAST() ----------------- (Compare across columns in a row)
 *    - 1.1 Finding highest test score
 *    - 1.2 Finding lowest test score
 *    - 1.3 GREATEST with minimum threshold
 *    - 1.4 Handling NULL values in GREATEST/LEAST
 * 
 * 2. COALESCE() / IFNULL() ------------------ (Replace NULL with default)
 *    - 2.1 Basic NULL replacement
 *    - 2.2 The Empty String Problem
 *    - 2.3 Replacing NULLs in calculations
 * 
 * 3. NULLIF() ------------------------------- (Convert specific value to NULL)
 *    - 3.1 Converting empty strings to NULL
 * 
 * 4. Handling Both NULL and Empty Strings --- (Complete solution)
 * 
 * 5. Multi-Column Labeling ------------------ (COALESCE for display)
 * 
 * 6. COMMON MISTAKES ----------------------- (What to avoid)
 * 
 * 7. GOLDEN RULES -------------------------- (Key principles)
 * 
 * 8. QUICK REFERENCE CARD ------------------ (Cheat sheet)
 * 
 * 9. PRACTICE EXERCISES -------------------- (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SOURCE TABLE: STUDENTS
-- ============================================================================

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(40),
    city VARCHAR(30),
    phone VARCHAR(20),
    test1 INT,
    test2 INT,
    test3 INT
);

INSERT INTO students (id, name, city, phone, test1, test2, test3) VALUES
(1,  'Aisha',   'Delhi',     NULL,         55, 60, 58),
(2,  'Rohan',   'Mumbai',    '',           40, NULL, 52),
(3,  'Meenal',  NULL,        '8888000004', NULL, NULL, 35),
(4,  'Arjun',   'Pune',      '9777000005', 72, 70, 75),
(5,  'Neha',    'Jaipur',    NULL,         10, 15, 12),
(6,  'Vikas',   'Hyderabad', '9666000007', 88, 91, 95),
(7,  'Sana',    'Ahmedabad', NULL,         65, 64, NULL),
(8,  'Imran',   'Kolkata',   '',           50, 49, 51),
(9,  'Pallavi', '',          '9555000010', 92, 90, 91),
(10, 'Deepak',  'Chennai',   NULL,         33, 40, 38),
(11, 'Ananya',  'Bengaluru', '9444000012', 78, NULL, NULL),
(12, 'Tanya',   'Kolkata',   '',           45, 42, 48);

-- Display the data
SELECT id, name, city, phone, test1, test2, test3 
FROM students 
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────────┬────────────┬───────┬───────┬───────┐
 * │ id │ name     │ city      │ phone      │ test1 │ test2 │ test3 │
 * ├────┼──────────┼───────────┼────────────┼───────┼───────┼───────┤
 * │ 1  │ Aisha    │ Delhi     │ NULL       │ 55    │ 60    │ 58    │
 * │ 2  │ Rohan    │ Mumbai    │            │ 40    │ NULL  │ 52    │
 * │ 3  │ Meenal   │ NULL      │ 8888000004 │ NULL  │ NULL  │ 35    │
 * │ 4  │ Arjun    │ Pune      │ 9777000005 │ 72    │ 70    │ 75    │
 * │ 5  │ Neha     │ Jaipur    │ NULL       │ 10    │ 15    │ 12    │
 * │ 6  │ Vikas    │ Hyderabad │ 9666000007 │ 88    │ 91    │ 95    │
 * │ 7  │ Sana     │ Ahmedabad │ NULL       │ 65    │ 64    │ NULL  │
 * │ 8  │ Imran    │ Kolkata   │            │ 50    │ 49    │ 51    │
 * │ 9  │ Pallavi  │           │ 9555000010 │ 92    │ 90    │ 91    │
 * │ 10 │ Deepak   │ Chennai   │ NULL       │ 33    │ 40    │ 38    │
 * │ 11 │ Ananya   │ Bengaluru │ 9444000012 │ 78    │ NULL  │ NULL  │
 * │ 12 │ Tanya    │ Kolkata   │            │ 45    │ 42    │ 48    │
 * └────┴──────────┴───────────┴────────────┴───────┴───────┴───────┘
 */

-- ============================================================================
-- PART 1: GREATEST() and LEAST() - Compare across columns in a row
-- ============================================================================

/**
 * GREATEST() and LEAST() work HORIZONTALLY across columns in a single row.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              GREATEST() and LEAST() - EXPLANATION                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GREATEST(value1, value2, value3, ...)                           │   │
 * │   │ LEAST(value1, value2, value3, ...)                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   DIFFERENCE FROM MAX/MIN:                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ MAX() / MIN() → Work VERTICALLY (down a column)                 │   │
 * │   │ GREATEST() / LEAST() → Work HORIZONTALLY (across columns)       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   IMPORTANT: If ANY value is NULL → result is NULL!                    │
 * │                                                                          │
 * │   EXAMPLE: For Aisha (55, 60, 58):                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GREATEST(55, 60, 58) = 60  (largest)                           │   │
 * │   │ LEAST(55, 60, 58) = 55    (smallest)                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 1.1 GREATEST() - Finding highest test score for each student
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              GREATEST() - Finding Highest Test Score                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, test1, test2, test3,                          │   │
 * │   │        GREATEST(test1, test2, test3) AS highest_score           │   │
 * │   │ FROM students                                                   │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬───────┬───────┬───────┬───────────────┐           │
 * │   │ id │ name     │ test1 │ test2 │ test3 │ highest_score │           │
 * │   ├────┼──────────┼───────┼───────┼───────┼───────────────┤           │
 * │   │ 1  │ Aisha    │ 55    │ 60    │ 58    │ 60            │           │
 * │   │ 2  │ Rohan    │ 40    │ NULL  │ 52    │ NULL          │  (has NULL)│
 * │   │ 4  │ Arjun    │ 72    │ 70    │ 75    │ 75            │           │
 * │   │ 5  │ Neha     │ 10    │ 15    │ 12    │ 15            │           │
 * │   │ 6  │ Vikas    │ 88    │ 91    │ 95    │ 95            │           │
 * │   └────┴──────────┴───────┴───────┴───────┴───────────────┘           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    id,
    name,
    test1,
    test2,
    test3,
    GREATEST(test1, test2, test3) AS highest_score
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────┬───────┬───────┬───────────────┐
 * │ id │ name     │ test1 │ test2 │ test3 │ highest_score │
 * ├────┼──────────┼───────┼───────┼───────┼───────────────┤
 * │ 1  │ Aisha    │ 55    │ 60    │ 58    │ 60            │
 * │ 2  │ Rohan    │ 40    │ NULL  │ 52    │ NULL          │
 * │ 3  │ Meenal   │ NULL  │ NULL  │ 35    │ NULL          │
 * │ 4  │ Arjun    │ 72    │ 70    │ 75    │ 75            │
 * │ 5  │ Neha     │ 10    │ 15    │ 12    │ 15            │
 * │ 6  │ Vikas    │ 88    │ 91    │ 95    │ 95            │
 * │ 7  │ Sana     │ 65    │ 64    │ NULL  │ NULL          │
 * │ 8  │ Imran    │ 50    │ 49    │ 51    │ 51            │
 * │ 9  │ Pallavi  │ 92    │ 90    │ 91    │ 92            │
 * │ 10 │ Deepak   │ 33    │ 40    │ 38    │ 40            │
 * │ 11 │ Ananya   │ 78    │ NULL  │ NULL  │ NULL          │
 * │ 12 │ Tanya    │ 45    │ 42    │ 48    │ 48            │
 * └────┴──────────┴───────┴───────┴───────┴───────────────┘
 * 
 * EXPLANATION:
 * - Aisha: GREATEST(55, 60, 58) = 60 ✓
 * - Arjun: GREATEST(72, 70, 75) = 75 ✓
 * - Vikas: GREATEST(88, 91, 95) = 95 ✓
 * - Rohan: Has NULL in test2 → result is NULL
 * - Sana: Has NULL in test3 → result is NULL
 */

-- ============================================================================
-- 1.2 LEAST() - Finding lowest test score for each student
-- ============================================================================

SELECT
    id,
    name,
    test1,
    test2,
    test3,
    LEAST(test1, test2, test3) AS lowest_score
FROM students
WHERE test1 IS NOT NULL AND test2 IS NOT NULL AND test3 IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────┬───────┬───────┬──────────────┐
 * │ id │ name     │ test1 │ test2 │ test3 │ lowest_score │
 * ├────┼──────────┼───────┼───────┼───────┼──────────────┤
 * │ 1  │ Aisha    │ 55    │ 60    │ 58    │ 55           │
 * │ 4  │ Arjun    │ 72    │ 70    │ 75    │ 70           │
 * │ 5  │ Neha     │ 10    │ 15    │ 12    │ 10           │
 * │ 6  │ Vikas    │ 88    │ 91    │ 95    │ 88           │
 * │ 8  │ Imran    │ 50    │ 49    │ 51    │ 49           │
 * │ 9  │ Pallavi  │ 92    │ 90    │ 91    │ 90           │
 * │ 10 │ Deepak   │ 33    │ 40    │ 38    │ 33           │
 * │ 12 │ Tanya    │ 45    │ 42    │ 48    │ 42           │
 * └────┴──────────┴───────┴───────┴───────┴──────────────┘
 * 
 * EXPLANATION:
 * - Aisha: LEAST(55, 60, 58) = 55 ✓ (lowest is 55)
 * - Neha: LEAST(10, 15, 12) = 10 ✓ (lowest is 10)
 * - Vikas: LEAST(88, 91, 95) = 88 ✓ (lowest is 88)
 * - Students with NULLs are excluded (WHERE clause filters them out)
 */

-- ============================================================================
-- 1.3 GREATEST with minimum threshold (Passing mark)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              GREATEST with Minimum Threshold                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: Show each student's best score, but ensure at least 35      │
 * │   (passing mark) is shown even if they scored lower.                   │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name,                                                    │   │
 * │   │        GREATEST(test1, test2, test3, 35) AS adjusted_best_score │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE test1 IS NOT NULL                                         │   │
 * │   │   AND test2 IS NOT NULL                                         │   │
 * │   │   AND test3 IS NOT NULL;                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬─────────────────────┐                                  │
 * │   │ name     │ adjusted_best_score │                                  │
 * │   ├──────────┼─────────────────────┤                                  │
 * │   │ Aisha    │ 60                  │  (max of 55,60,58,35 = 60)      │
 * │   │ Arjun    │ 75                  │  (max of 72,70,75,35 = 75)      │
 * │   │ Neha     │ 35                  │  (max of 10,15,12,35 = 35)      │
 * │   │ Vikas    │ 95                  │  (max of 88,91,95,35 = 95)      │
 * │   └──────────┴─────────────────────┘                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Show best score with minimum threshold of 35 (passing mark)
SELECT 
    name, 
    test1, test2, test3,
    GREATEST(test1, test2, test3, 35) AS adjusted_best_score
FROM students
WHERE test1 IS NOT NULL 
  AND test2 IS NOT NULL 
  AND test3 IS NOT NULL;

/**
 * OUTPUT:
 * ┌──────────┬───────┬───────┬───────┬─────────────────────┐
 * │ name     │ test1 │ test2 │ test3 │ adjusted_best_score │
 * ├──────────┼───────┼───────┼───────┼─────────────────────┤
 * │ Aisha    │ 55    │ 60    │ 58    │ 60                  │
 * │ Arjun    │ 72    │ 70    │ 75    │ 75                  │
 * │ Neha     │ 10    │ 15    │ 12    │ 35                  │
 * │ Vikas    │ 88    │ 91    │ 95    │ 95                  │
 * │ Imran    │ 50    │ 49    │ 51    │ 51                  │
 * │ Pallavi  │ 92    │ 90    │ 91    │ 92                  │
 * │ Deepak   │ 33    │ 40    │ 38    │ 40                  │
 * │ Tanya    │ 45    │ 42    │ 48    │ 48                  │
 * └──────────┴───────┴───────┴───────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Neha's best score was 15, but 35 is higher → returns 35
 * - Aisha's best score is 60 > 35 → returns 60
 * - GREATEST compares all values including the threshold
 */

-- ============================================================================
-- 1.4 Handling NULL values in GREATEST/LEAST
-- ============================================================================

/**
 * CRITICAL: GREATEST/LEAST return NULL if ANY argument is NULL!
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              Handling NULL in GREATEST/LEAST                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: Rohan has NULL in test2 → GREATEST returns NULL              │
 * │                                                                          │
 * │   SOLUTION: Replace NULLs with 0 before using GREATEST                  │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name, test1, test2, test3,                               │   │
 * │   │        GREATEST(COALESCE(test1,0),                              │   │
 * │   │                 COALESCE(test2,0),                              │   │
 * │   │                 COALESCE(test3,0)) AS best_with_default         │   │
 * │   │ FROM students;                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Without NULL handling (returns NULL)
SELECT 
    name, 
    test1, test2, test3,
    GREATEST(test1, test2, test3) AS best_raw
FROM students
WHERE id = 2;  -- Rohan has NULL in test2

/**
 * OUTPUT:
 * ┌─────────┬───────┬───────┬───────┬──────────┐
 * │ name    │ test1 │ test2 │ test3 │ best_raw │
 * ├─────────┼───────┼───────┼───────┼──────────┤
 * │ Rohan   │ 40    │ NULL  │ 52    │ NULL     │
 * └─────────┴───────┴───────┴───────┴──────────┘
 */

-- With NULL handling (treat NULL as 0)
SELECT 
    name, 
    test1, test2, test3,
    GREATEST(COALESCE(test1, 0), 
             COALESCE(test2, 0), 
             COALESCE(test3, 0)) AS best_with_default
FROM students
WHERE id = 2;

/**
 * OUTPUT:
 * ┌─────────┬───────┬───────┬───────┬──────────────────┐
 * │ name    │ test1 │ test2 │ test3 │ best_with_default │
 * ├─────────┼───────┼───────┼───────┼──────────────────┤
 * │ Rohan   │ 40    │ NULL  │ 52    │ 52                │
 * └─────────┴───────┴───────┴───────┴──────────────────┘
 */

-- ============================================================================
-- PART 2: COALESCE() / IFNULL() - Replace NULL with default
-- ============================================================================

/**
 * COALESCE replaces NULL values with a default.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              COALESCE() - EXPLANATION                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX (PostgreSQL uses COALESCE):                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(value, replacement)                                    │   │
 * │   │ -- Returns replacement if value is NULL, else returns value     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   IMPORTANT: Empty string ('') is NOT NULL!                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(NULL, 'default')  = 'default'  (NULL replaced)         │   │
 * │   │ COALESCE('', 'default')    = ''         (empty string NOT replaced)│
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 2.1 Basic NULL replacement (Phone numbers)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              COALESCE - Basic NULL Replacement                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, phone,                                        │   │
 * │   │        COALESCE(phone, 'Not Provided') AS phone_status          │   │
 * │   │ FROM students                                                   │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬────────────┬──────────────┐                       │
 * │   │ id │ name     │ phone      │ phone_status │                       │
 * │   ├────┼──────────┼────────────┼──────────────┤                       │
 * │   │ 1  │ Aisha    │ NULL       │ Not Provided │  (NULL replaced)      │
 * │   │ 2  │ Rohan    │            │              │  (empty string NOT!)  │
 * │   │ 3  │ Meenal   │ 8888000004 │ 8888000004   │                       │
 * │   └────┴──────────┴────────────┴──────────────┘                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    id, 
    name, 
    phone, 
    COALESCE(phone, 'Not Provided') AS phone_status
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬────────────┬──────────────┐
 * │ id │ name     │ phone      │ phone_status │
 * ├────┼──────────┼────────────┼──────────────┤
 * │ 1  │ Aisha    │ NULL       │ Not Provided │
 * │ 2  │ Rohan    │            │              │  ← empty string NOT replaced!
 * │ 3  │ Meenal   │ 8888000004 │ 8888000004   │
 * │ 4  │ Arjun    │ 9777000005 │ 9777000005   │
 * │ 5  │ Neha     │ NULL       │ Not Provided │
 * │ 6  │ Vikas    │ 9666000007 │ 9666000007   │
 * │ 7  │ Sana     │ NULL       │ Not Provided │
 * │ 8  │ Imran    │            │              │  ← empty string NOT replaced!
 * │ 9  │ Pallavi  │ 9555000010 │ 9555000010   │
 * │ 10 │ Deepak   │ NULL       │ Not Provided │
 * │ 11 │ Ananya   │ 9444000012 │ 9444000012   │
 * │ 12 │ Tanya    │            │              │  ← empty string NOT replaced!
 * └────┴──────────┴────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - NULL values (Aisha, Neha, Sana, Deepak) → replaced with 'Not Provided'
 * - Empty strings (Rohan, Imran, Tanya) → NOT replaced!
 * - Actual phone numbers → displayed as is
 */

-- ============================================================================
-- 2.2 The Empty String Problem
-- ============================================================================

/**
 * IMPORTANT: COALESCE does NOT replace empty strings!
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              The Empty String Problem                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   WHY? Empty string ('') is a VALID value, not NULL                     │
 * │   NULL = Unknown / Missing data                                         │
 * │   ''   = Data exists but is empty                                       │
 * │                                                                          │
 * │   To handle empty strings, first convert them to NULL using NULLIF()    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 2.3 Replacing NULLs in calculations (Total Score)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              Replacing NULLs in Calculations                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: Calculate total score, treating NULL as 0                    │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name,                                                    │   │
 * │   │        COALESCE(test1, 0) + COALESCE(test2, 0) +                │   │
 * │   │        COALESCE(test3, 0) AS total_score                        │   │
 * │   │ FROM students;                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬─────────────┐                                          │
 * │   │ name     │ total_score │                                          │
 * │   ├──────────┼─────────────┤                                          │
 * │   │ Aisha    │ 173         │  (55+60+58)                             │
 * │   │ Rohan    │ 92          │  (40+0+52)                              │
 * │   │ Meenal   │ 35          │  (0+0+35)                               │
 * │   │ Arjun    │ 217         │  (72+70+75)                             │
 * │   │ Neha     │ 37          │  (10+15+12)                             │
 * │   │ Vikas    │ 274         │  (88+91+95)                             │
 * │   └──────────┴─────────────┘                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    name, 
    COALESCE(test1, 0) + COALESCE(test2, 0) + COALESCE(test3, 0) AS total_score
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┐
 * │ name     │ total_score │
 * ├──────────┼─────────────┤
 * │ Aisha    │ 173         │
 * │ Rohan    │ 92          │
 * │ Meenal   │ 35          │
 * │ Arjun    │ 217         │
 * │ Neha     │ 37          │
 * │ Vikas    │ 274         │
 * │ Sana     │ 129         │
 * │ Imran    │ 150         │
 * │ Pallavi  │ 273         │
 * │ Deepak   │ 111         │
 * │ Ananya   │ 78          │
 * │ Tanya    │ 135         │
 * └──────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Rohan: 40 + 0 + 52 = 92 (test2 NULL treated as 0)
 * - Meenal: 0 + 0 + 35 = 35 (test1, test2 NULL treated as 0)
 * - Ananya: 78 + 0 + 0 = 78 (test2, test3 NULL treated as 0)
 */

-- ============================================================================
-- PART 3: NULLIF() - Convert specific value to NULL
-- ============================================================================

/**
 * NULLIF(value1, value2) returns NULL if value1 equals value2.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    NULLIF() - EXPLANATION                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ NULLIF(value, compare_value)                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   RULES:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • If value equals compare_value → returns NULL                  │   │
 * │   │ • If value does NOT equal compare_value → returns value         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ NULLIF('', '')      → NULL  (empty string becomes NULL)         │   │
 * │   │ NULLIF('hello', '') → 'hello' (not equal)                       │   │
 * │   │ NULLIF(0, 0)        → NULL  (zero becomes NULL)                 │   │
 * │   │ NULLIF(5, 0)        → 5     (not equal)                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 3.1 Converting empty strings to NULL
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              NULLIF - Converting Empty Strings to NULL                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, phone,                                        │   │
 * │   │        NULLIF(phone, '') AS phone_nullified                     │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE id IN (1, 2, 3);                                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬────────────┬─────────────────┐                    │
 * │   │ id │ name     │ phone      │ phone_nullified │                    │
 * │   ├────┼──────────┼────────────┼─────────────────┤                    │
 * │   │ 1  │ Aisha    │ NULL       │ NULL            │  (NULL stays NULL) │
 * │   │ 2  │ Rohan    │            │ NULL            │  ('' → NULL)       │
 * │   │ 3  │ Meenal   │ 8888000004 │ 8888000004      │  (value unchanged) │
 * │   └────┴──────────┴────────────┴─────────────────┘                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    id, 
    name, 
    phone, 
    NULLIF(phone, '') AS phone_nullified
FROM students
WHERE id IN (1, 2, 3);

/**
 * OUTPUT:
 * ┌────┬──────────┬────────────┬─────────────────┐
 * │ id │ name     │ phone      │ phone_nullified │
 * ├────┼──────────┼────────────┼─────────────────┤
 * │ 1  │ Aisha    │ NULL       │ NULL            │
 * │ 2  │ Rohan    │            │ NULL            │
 * │ 3  │ Meenal   │ 8888000004 │ 8888000004      │
 * └────┴──────────┴────────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Aisha: phone is NULL → NULLIF returns NULL
 * - Rohan: phone is '' (empty string) → NULLIF returns NULL
 * - Meenal: phone has value → NULLIF returns the value
 */

-- ============================================================================
-- PART 4: Handling Both NULL and Empty Strings (Complete Solution)
-- ============================================================================

/**
 * Complete solution: Convert empty strings to NULL, then replace NULL with default.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              Handling Both NULL and Empty Strings                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   FORMULA:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(NULLIF(column, ''), 'Default Value')                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEPS:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. NULLIF(phone, '') → converts empty string to NULL           │   │
 * │   │ 2. COALESCE(..., 'Missing') → replaces NULL with 'Missing'     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Clean phone numbers (handle NULL and empty strings)
SELECT 
    id,
    name,
    phone,
    COALESCE(NULLIF(phone, ''), 'Missing') AS clean_phone
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬────────────┬─────────────┐
 * │ id │ name     │ phone      │ clean_phone │
 * ├────┼──────────┼────────────┼─────────────┤
 * │ 1  │ Aisha    │ NULL       │ Missing     │
 * │ 2  │ Rohan    │            │ Missing     │
 * │ 3  │ Meenal   │ 8888000004 │ 8888000004  │
 * │ 4  │ Arjun    │ 9777000005 │ 9777000005  │
 * │ 5  │ Neha     │ NULL       │ Missing     │
 * │ 6  │ Vikas    │ 9666000007 │ 9666000007  │
 * │ 7  │ Sana     │ NULL       │ Missing     │
 * │ 8  │ Imran    │            │ Missing     │
 * │ 9  │ Pallavi  │ 9555000010 │ 9555000010  │
 * │ 10 │ Deepak   │ NULL       │ Missing     │
 * │ 11 │ Ananya   │ 9444000012 │ 9444000012  │
 * │ 12 │ Tanya    │            │ Missing     │
 * └────┴──────────┴────────────┴─────────────┘
 * 
 * EXPLANATION:
 * - NULL values (Aisha, Neha, etc.) → 'Missing'
 * - Empty strings (Rohan, Imran, Tanya) → 'Missing'
 * - Actual phone numbers → displayed as is
 */

-- ============================================================================
-- PART 5: Multi-Column Labeling (COALESCE for display)
-- ============================================================================

/**
 * Use COALESCE to show the first available value from multiple columns.
 */

-- Clean city names (handle NULL and empty strings)
SELECT 
    id,
    name,
    city,
    COALESCE(NULLIF(city, ''), 'Remote') AS location
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────────┬──────────┐
 * │ id │ name     │ city      │ location │
 * ├────┼──────────┼───────────┼──────────┤
 * │ 1  │ Aisha    │ Delhi     │ Delhi    │
 * │ 2  │ Rohan    │ Mumbai    │ Mumbai   │
 * │ 3  │ Meenal   │ NULL      │ Remote   │
 * │ 4  │ Arjun    │ Pune      │ Pune     │
 * │ 5  │ Neha     │ Jaipur    │ Jaipur   │
 * │ 6  │ Vikas    │ Hyderabad │ Hyderabad│
 * │ 7  │ Sana     │ Ahmedabad │ Ahmedabad│
 * │ 8  │ Imran    │ Kolkata   │ Kolkata  │
 * │ 9  │ Pallavi  │           │ Remote   │
 * │ 10 │ Deepak   │ Chennai   │ Chennai  │
 * │ 11 │ Ananya   │ Bengaluru │ Bengaluru│
 * │ 12 │ Tanya    │ Kolkata   │ Kolkata  │
 * └────┴──────────┴───────────┴──────────┘
 * 
 * EXPLANATION:
 * - Meenal: NULL city → 'Remote'
 * - Pallavi: empty string city → 'Remote'
 * - Others: actual city names displayed
 */

-- ============================================================================
-- PART 6: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Assuming GREATEST/LEAST ignores NULLs                      │
 * │                                                                          │
 * │   ❌ GREATEST(55, NULL, 58) → Expecting 58, but returns NULL!          │
 * │                                                                          │
 * │   ✅ GREATEST(COALESCE(55,0), COALESCE(NULL,0), COALESCE(58,0)) = 58   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Returns NULL
SELECT GREATEST(55, NULL, 58) AS result;  -- NULL

-- ✅ Returns 58
SELECT GREATEST(COALESCE(55,0), COALESCE(NULL,0), COALESCE(58,0)) AS result;  -- 58

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: COALESCE does NOT replace empty strings                    │
 * │                                                                          │
 * │   ❌ COALESCE(phone, 'Missing') → empty string stays empty!            │
 * │                                                                          │
 * │   ✅ COALESCE(NULLIF(phone, ''), 'Missing') → replaces empty strings   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Empty string NOT replaced
SELECT COALESCE('', 'Missing') AS result;  -- '' (empty string)

-- ✅ Empty string replaced
SELECT COALESCE(NULLIF('', ''), 'Missing') AS result;  -- 'Missing'

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: COALESCE vs WHERE - Different purposes                     │
 * │                                                                          │
 * │   COALESCE changes how data LOOKS (does not filter)                    │
 * │   WHERE filters which rows are SHOWN                                   │
 * │                                                                          │
 * │   ✅ Use COALESCE to replace NULLs in output                           │
 * │   ✅ Use WHERE to exclude rows with NULLs                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ GREATEST() / LEAST() RULES:                                            │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 1. Work HORIZONTALLY across columns (per row)                      ││
 * │ │ 2. If ANY value is NULL → result is NULL                           ││
 * │ │ 3. Use COALESCE to replace NULLs before using GREATEST/LEAST       ││
 * │ │ 4. Can include literal values as thresholds (e.g., 35)             ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COALESCE() RULES:                                                      │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 1. Returns first non-NULL value                                    ││
 * │ │ 2. Empty string ('') is NOT NULL (not replaced)                    ││
 * │ │ 3. Use NULLIF to convert empty strings to NULL first               ││
 * │ │ 4. Use for replacing NULLs in calculations                         ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ NULLIF() RULES:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 1. Returns NULL if two values are equal                            ││
 * │ │ 2. Useful for converting empty strings or zero to NULL             ││
 * │ │ 3. Often used with COALESCE for complete NULL handling             ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMPLETE PATTERN for handling empty strings:                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ COALESCE(NULLIF(column, ''), 'Default Value')                       ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 8: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ GREATEST() - Largest value across columns                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ GREATEST(55, 60, 58)      → 60                                      ││
 * │ │ GREATEST(10, 15, 12, 35)  → 35 (with threshold)                    ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ LEAST() - Smallest value across columns                                 │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LEAST(55, 60, 58)         → 55                                      ││
 * │ │ LEAST(72, 70, 75)         → 70                                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COALESCE() - First non-NULL value                                       │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ COALESCE(NULL, 'default') → 'default'                               ││
 * │ │ COALESCE('', 'default')   → '' (empty string NOT replaced)          ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ NULLIF() - Convert specific value to NULL                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ NULLIF('', '')            → NULL                                    ││
 * │ │ NULLIF(0, 0)              → NULL                                    ││
 * │ │ NULLIF('hello', '')       → 'hello'                                 ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ Complete NULL & Empty String Handling:                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ COALESCE(NULLIF(phone, ''), 'Missing')                             ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ NULL-safe GREATEST/LEAST:                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ GREATEST(COALESCE(c1,0), COALESCE(c2,0), COALESCE(c3,0))           ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 9: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find the highest test score for each student
 * 
 * Answer:
 *   SELECT name, GREATEST(test1, test2, test3) FROM students;
 */

/**
 * EXERCISE 2: Find the lowest test score for each student (excluding NULLs)
 * 
 * Answer:
 *   SELECT name, LEAST(test1, test2, test3) FROM students
 *   WHERE test1 IS NOT NULL AND test2 IS NOT NULL AND test3 IS NOT NULL;
 */

/**
 * EXERCISE 3: Replace NULL phone numbers with 'No Phone'
 * 
 * Answer:
 *   SELECT name, COALESCE(phone, 'No Phone') FROM students;
 */

/**
 * EXERCISE 4: Replace both NULL and empty string phone numbers with 'Missing'
 * 
 * Answer:
 *   SELECT name, COALESCE(NULLIF(phone, ''), 'Missing') FROM students;
 */

/**
 * EXERCISE 5: Calculate total score treating NULLs as 0
 * 
 * Answer:
 *   SELECT name, COALESCE(test1,0) + COALESCE(test2,0) + COALESCE(test3,0)
 *   FROM students;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS students;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ GREATEST() / LEAST():                                                   │
 * │ • Work horizontally across columns (per row)                           │
 * │ • Return NULL if ANY argument is NULL                                  │
 * │ • Use COALESCE to handle NULLs before using                            │
 * │ • Can include literal values as thresholds                             │
 * │                                                                          │
 * │ COALESCE():                                                            │
 * │ • Returns first non-NULL value                                         │
 * │ • Does NOT replace empty strings ('')                                  │
 * │ • Use for replacing NULLs in calculations                              │
 * │                                                                          │
 * │ NULLIF():                                                              │
 * │ • Returns NULL if two values are equal                                 │
 * │ • Converts empty strings to NULL                                       │
 * │ • Converts zero to NULL                                                │
 * │ • Often used with COALESCE                                             │
 * │                                                                          │
 * │ Complete pattern for handling empty strings:                           │
 * │ COALESCE(NULLIF(column, ''), 'Default')                                │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │ - GREATEST with NULL returns NULL                                      │
 * │ - COALESCE doesn't replace empty strings                               │
 * │ - Use NULLIF to convert empty strings to NULL                          │
 * │ - Combine COALESCE + NULLIF for complete NULL/empty handling          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF GREATEST, LEAST, COALESCE, NULLIF REVISION GUIDE
-- ============================================================================