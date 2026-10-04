/**
 * ============================================================================
 * STRING & NUMERIC FUNCTIONS - COMPLETE BEGINNER'S GUIDE
 * (ROUND, ABS, GREATEST, LEAST, COALESCE, NULLIF, IS NULL)
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. ROUND() ------------------------------- (Round numbers to decimal places)
 * 2. ABS() --------------------------------- (Absolute value - remove negative sign)
 * 3. GREATEST() and LEAST() ---------------- (Find largest/smallest values)
 * 4. COALESCE() ---------------------------- (First non-NULL value)
 * 5. NULLIF() ------------------------------ (Convert specific value to NULL)
 * 6. IFNULL() (MySQL) / COALESCE (PG) ------ (Replace NULL with default)
 * 7. IS NULL vs IS NOT NULL ---------------- (Check for NULL values)
 * 8. Handling Empty Strings vs NULL -------- (Important distinction!)
 * 9. TRIM() with NULLIF -------------------- (Clean and handle empty strings)
 * 10. REAL-WORLD SCENARIOS ----------------- (Practical examples)
 * 11. COMMON MISTAKES ---------------------- (What to avoid)
 * 12. GOLDEN RULES ------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLE FOR ALL EXAMPLES
-- ============================================================================

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    city VARCHAR(30),
    phone VARCHAR(20),
    fee_paid NUMERIC(10,2),
    score_change NUMERIC(10,2),
    test1 INT,
    test2 INT,
    test3 INT
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

INSERT INTO students (id, name, city, phone, fee_paid, score_change, test1, test2, test3) VALUES
(1,  'Aisha',   'Delhi',     NULL,           2804.45,  -12.25, 55, 60, 58),
(2,  'Rohan',   'Mumbai',    '',             3303.06,  -80.00, 40, NULL, 52),
(3,  'Meenal',  NULL,        '8888000004',   7999.00,   NULL,  NULL, NULL, 35),
(4,  'Arjun',   'Pune',      '9777000005',   3717.94,   10.00, 72, 70, 75),
(5,  'Neha',    'Jaipur',    NULL,           3499.00,  -30.75, 10, 15, 12),
(6,  'Vikas',   'Hyderabad', '9666000007',   5099.00,  120.75, 88, 91, 95),
(7,  'Sana',    'Ahmedabad', NULL,           7085.13,  -15.00, 65, 64, NULL),
(8,  'Imran',   'Kolkata',   '',             3303.06,   -1.00, 50, 49, 51),
(9,  'Pallavi', '',          '9555000010',   3303.06,    5.25, 92, 90, 91),
(10, 'Deepak',  'Chennai',   NULL,           NULL,     -22.00, 33, 40, 38),
(11, 'Ananya',  'Bengaluru', '9444000012',   3504.16,   18.50, 78, NULL, NULL),
(12, 'Tanya',   'Kolkata',   '',             3303.06,  -10.00, 45, 42, 48);

-- Display the data
SELECT * FROM students ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────────┬────────────┬──────────┬──────────────┬───────┬───────┬───────┐
 * │ id │ name     │ city      │ phone      │ fee_paid │ score_change │ test1 │ test2 │ test3 │
 * ├────┼──────────┼───────────┼────────────┼──────────┼──────────────┼───────┼───────┼───────┤
 * │ 1  │ Aisha    │ Delhi     │ NULL       │ 2804.45  │ -12.25       │ 55    │ 60    │ 58    │
 * │ 2  │ Rohan    │ Mumbai    │            │ 3303.06  │ -80.00       │ 40    │ NULL  │ 52    │
 * │ 3  │ Meenal   │ NULL      │ 8888000004 │ 7999.00  │ NULL         │ NULL  │ NULL  │ 35    │
 * │ 4  │ Arjun    │ Pune      │ 9777000005 │ 3717.94  │ 10.00        │ 72    │ 70    │ 75    │
 * │ 5  │ Neha     │ Jaipur    │ NULL       │ 3499.00  │ -30.75       │ 10    │ 15    │ 12    │
 * │ 6  │ Vikas    │ Hyderabad │ 9666000007 │ 5099.00  │ 120.75       │ 88    │ 91    │ 95    │
 * │ 7  │ Sana     │ Ahmedabad │ NULL       │ 7085.13  │ -15.00       │ 65    │ 64    │ NULL  │
 * │ 8  │ Imran    │ Kolkata   │            │ 3303.06  │ -1.00        │ 50    │ 49    │ 51    │
 * │ 9  │ Pallavi  │           │ 9555000010 │ 3303.06  │ 5.25         │ 92    │ 90    │ 91    │
 * │ 10 │ Deepak   │ Chennai   │ NULL       │ NULL     │ -22.00       │ 33    │ 40    │ 38    │
 * │ 11 │ Ananya   │ Bengaluru │ 9444000012 │ 3504.16  │ 18.50        │ 78    │ NULL  │ NULL  │
 * │ 12 │ Tanya    │ Kolkata   │            │ 3303.06  │ -10.00       │ 45    │ 42    │ 48    │
 * └────┴──────────┴───────────┴────────────┴──────────┴──────────────┴───────┴───────┴───────┘
 */

-- ============================================================================
-- PART 1: ROUND() - Round numbers to decimal places
-- ============================================================================

/**
 * ROUND(number, decimals) rounds a number to specified decimal places.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    ROUND() - EXPLANATION                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   SYNTAX:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ROUND(number, decimal_places)                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                         │
 * │   RULES:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • 0.5 and above → rounds UP                                     │   │
 * │   │ • Below 0.5 → rounds DOWN                                       │   │
 * │   │ • If decimal_places is 0 → rounds to nearest integer            │   │
 * │   │ • If decimal_places is 2 → rounds to 2 decimal places           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                         │
 * │   EXAMPLES:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ROUND(2804.45, 0) = 2804  (0.45 < 0.5 → rounds down)            │   │
 * │   │ ROUND(3717.94, 0) = 3718  (0.94 ≥ 0.5 → rounds up)              │   │
 * │   │ ROUND(2804.45, 2) = 2804.45 (no change)                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    ROUND() - EXAMPLE                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, fee_paid,                                      │   │
 * │   │        ROUND(fee_paid, 0) AS fee_rupees,                        │   │
 * │   │        ROUND(fee_paid, 2) AS fee_2dp                            │   │
 * │   │ FROM students                                                   │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬──────────┬────────────┬─────────┐                 │
 * │   │ id │ name     │ fee_paid │ fee_rupees │ fee_2dp │                 │
 * │   ├────┼──────────┼──────────┼────────────┼─────────┤                 │
 * │   │ 1  │ Aisha    │ 2804.45  │ 2804       │ 2804.45 │                 │
 * │   │ 2  │ Rohan    │ 3303.06  │ 3303       │ 3303.06 │                 │
 * │   │ 3  │ Meenal   │ 7999.00  │ 7999       │ 7999.00 │                 │
 * │   │ 4  │ Arjun    │ 3717.94  │ 3718       │ 3717.94 │                 │
 * │   │ 5  │ Neha     │ 3499.00  │ 3499       │ 3499.00 │                 │
 * │   │ 6  │ Vikas    │ 5099.00  │ 5099       │ 5099.00 │                 │
 * │   │ 7  │ Sana     │ 7085.13  │ 7085       │ 7085.13 │                 │
 * │   │ 8  │ Imran    │ 3303.06  │ 3303       │ 3303.06 │                 │
 * │   │ 9  │ Pallavi  │ 3303.06  │ 3303       │ 3303.06 │                 │
 * │   │ 10 │ Deepak   │ NULL     │ NULL       │ NULL    │                 │
 * │   │ 11 │ Ananya   │ 3504.16  │ 3504       │ 3504.16 │                 │
 * │   │ 12 │ Tanya    │ 3303.06  │ 3303       │ 3303.06 │                 │
 * │   └────┴──────────┴──────────┴────────────┴─────────┘                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ROUND examples
SELECT 
    id,
    name,
    fee_paid,
    ROUND(fee_paid, 0) AS fee_rupees,
    ROUND(fee_paid, 2) AS fee_2dp
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────┬────────────┬─────────┐
 * │ id │ name     │ fee_paid │ fee_rupees │ fee_2dp │
 * ├────┼──────────┼──────────┼────────────┼─────────┤
 * │ 1  │ Aisha    │ 2804.45  │ 2804       │ 2804.45 │
 * │ 2  │ Rohan    │ 3303.06  │ 3303       │ 3303.06 │
 * │ 3  │ Meenal   │ 7999.00  │ 7999       │ 7999.00 │
 * │ 4  │ Arjun    │ 3717.94  │ 3718       │ 3717.94 │
 * │ 5  │ Neha     │ 3499.00  │ 3499       │ 3499.00 │
 * │ 6  │ Vikas    │ 5099.00  │ 5099       │ 5099.00 │
 * │ 7  │ Sana     │ 7085.13  │ 7085       │ 7085.13 │
 * │ 8  │ Imran    │ 3303.06  │ 3303       │ 3303.06 │
 * │ 9  │ Pallavi  │ 3303.06  │ 3303       │ 3303.06 │
 * │ 10 │ Deepak   │ NULL     │ NULL       │ NULL    │
 * │ 11 │ Ananya   │ 3504.16  │ 3504       │ 3504.16 │
 * │ 12 │ Tanya    │ 3303.06  │ 3303       │ 3303.06 │
 * └────┴──────────┴──────────┴────────────┴─────────┘
 */

-- ============================================================================
-- PART 2: ABS() - Absolute value (remove negative sign)
-- ============================================================================

/**
 * ABS(number) returns the distance from zero (always non-negative).
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    ABS() - EXPLANATION                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ABS(number)                                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 *   │   RULES:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Positive numbers → stay positive                              │   │
 * │   │ • Negative numbers → become positive                            │   │
 * │   │ • Zero → stays zero                                             │   │
 * │   │ • NULL → stays NULL                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ABS(-12.25) = 12.25                                            │   │
 * │   │ ABS(10.00)  = 10.00                                            │   │
 * │   │ ABS(0)      = 0                                                │   │
 * │   │ ABS(NULL)   = NULL                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    ABS() - EXAMPLE                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, score_change, ABS(score_change) AS abs_change  │   │
 * │   │ FROM students                                                   │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬──────────────┬────────────┐                       │
 * │   │ id │ name     │ score_change │ abs_change │                       │
 * │   ├────┼──────────┼──────────────┼────────────┤                       │
 * │   │ 1  │ Aisha    │ -12.25       │ 12.25      │                       │
 * │   │ 2  │ Rohan    │ -80.00       │ 80.00      │                       │
 * │   │ 3  │ Meenal   │ NULL         │ NULL       │                       │
 * │   │ 4  │ Arjun    │ 10.00        │ 10.00      │                       │
 * │   │ 5  │ Neha     │ -30.75       │ 30.75      │                       │
 * │   │ 6  │ Vikas    │ 120.75       │ 120.75     │                       │
 * │   │ 7  │ Sana     │ -15.00       │ 15.00      │                       │
 * │   │ 8  │ Imran    │ -1.00        │ 1.00       │                       │
 * │   │ 9  │ Pallavi  │ 5.25         │ 5.25       │                       │
 * │   │ 10 │ Deepak   │ -22.00       │ 22.00      │                       │
 * │   │ 11 │ Ananya   │ 18.50        │ 18.50      │                       │
 * │   │ 12 │ Tanya    │ -10.00       │ 10.00      │                       │
 * │   └────┴──────────┴──────────────┴────────────┘                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    id,
    name,
    score_change,
    ABS(score_change) AS abs_score_change
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────────┬──────────────────┐
 * │ id │ name     │ score_change │ abs_score_change │
 * ├────┼──────────┼──────────────┼──────────────────┤
 * │ 1  │ Aisha    │ -12.25       │ 12.25            │
 * │ 2  │ Rohan    │ -80.00       │ 80.00            │
 * │ 3  │ Meenal   │ NULL         │ NULL             │
 * │ 4  │ Arjun    │ 10.00        │ 10.00            │
 * │ 5  │ Neha     │ -30.75       │ 30.75            │
 * │ 6  │ Vikas    │ 120.75       │ 120.75           │
 * │ 7  │ Sana     │ -15.00       │ 15.00            │
 * │ 8  │ Imran    │ -1.00        │ 1.00             │
 * │ 9  │ Pallavi  │ 5.25         │ 5.25             │
 * │ 10 │ Deepak   │ -22.00       │ 22.00            │
 * │ 11 │ Ananya   │ 18.50        │ 18.50            │
 * │ 12 │ Tanya    │ -10.00       │ 10.00            │
 * └────┴──────────┴──────────────┴──────────────────┘
 */

-- ============================================================================
-- PART 3: GREATEST() and LEAST() - Find largest/smallest values
-- ============================================================================

/**
 * GREATEST() returns the largest value from a list.
 * LEAST() returns the smallest value from a list.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    GREATEST() and LEAST() - EXPLANATION                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GREATEST(value1, value2, value3, ...)                           │   │
 * │   │ LEAST(value1, value2, value3, ...)                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   IMPORTANT: If ANY value is NULL, the result is NULL!                 │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ GREATEST(55, 60, 58) = 60                                       │   │
 * │   │ LEAST(55, 60, 58) = 55                                          │   │
 * │   │ GREATEST(40, NULL, 52) = NULL (because of NULL)                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    GREATEST() and LEAST() - EXAMPLE                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, test1, test2, test3,                          │   │
 * │   │        GREATEST(test1, test2, test3) AS highest,                │   │
 * │   │        LEAST(test1, test2, test3) AS lowest                     │   │
 * │   │ FROM students                                                   │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬───────┬───────┬───────┬─────────┬────────┐        │
 * │   │ id │ name     │ test1 │ test2 │ test3 │ highest │ lowest │        │
 * │   ├────┼──────────┼───────┼───────┼───────┼─────────┼────────┤        │
 * │   │ 1  │ Aisha    │ 55    │ 60    │ 58    │ 60      │ 55     │        │
 * │   │ 2  │ Rohan    │ 40    │ NULL  │ 52    │ NULL    │ NULL   │        │
 * │   │ 3  │ Meenal   │ NULL  │ NULL  │ 35    │ NULL    │ NULL   │        │
 * │   │ 4  │ Arjun    │ 72    │ 70    │ 75    │ 75      │ 70     │        │
 * │   │ 5  │ Neha     │ 10    │ 15    │ 12    │ 15      │ 10     │        │
 * │   │ 6  │ Vikas    │ 88    │ 91    │ 95    │ 95      │ 88     │        │
 * │   │ 7  │ Sana     │ 65    │ 64    │ NULL  │ NULL    │ NULL   │        │
 * │   │ 8  │ Imran    │ 50    │ 49    │ 51    │ 51      │ 49     │        │
 * │   │ 9  │ Pallavi  │ 92    │ 90    │ 91    │ 92      │ 90     │        │
 * │   │ 10 │ Deepak   │ 33    │ 40    │ 38    │ 40      │ 33     │        │
 * │   │ 11 │ Ananya   │ 78    │ NULL  │ NULL  │ NULL    │ NULL   │        │
 * │   │ 12 │ Tanya    │ 45    │ 42    │ 48    │ 48      │ 42     │        │
 * │   └────┴──────────┴───────┴───────┴───────┴─────────┴────────┘        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    id,
    name,
    test1,
    test2,
    test3,
    GREATEST(test1, test2, test3) AS greatest_score,
    LEAST(test1, test2, test3) AS least_score
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────┬───────┬───────┬────────────────┬─────────────┐
 * │ id │ name     │ test1 │ test2 │ test3 │ greatest_score │ least_score │
 * ├────┼──────────┼───────┼───────┼───────┼────────────────┼─────────────┤
 * │ 1  │ Aisha    │ 55    │ 60    │ 58    │ 60             │ 55          │
 * │ 2  │ Rohan    │ 40    │ NULL  │ 52    │ NULL           │ NULL        │
 * │ 3  │ Meenal   │ NULL  │ NULL  │ 35    │ NULL           │ NULL        │
 * │ 4  │ Arjun    │ 72    │ 70    │ 75    │ 75             │ 70          │
 * │ 5  │ Neha     │ 10    │ 15    │ 12    │ 15             │ 10          │
 * │ 6  │ Vikas    │ 88    │ 91    │ 95    │ 95             │ 88          │
 * │ 7  │ Sana     │ 65    │ 64    │ NULL  │ NULL           │ NULL        │
 * │ 8  │ Imran    │ 50    │ 49    │ 51    │ 51             │ 49          │
 * │ 9  │ Pallavi  │ 92    │ 90    │ 91    │ 92             │ 90          │
 * │ 10 │ Deepak   │ 33    │ 40    │ 38    │ 40             │ 33          │
 * │ 11 │ Ananya   │ 78    │ NULL  │ NULL  │ NULL           │ NULL        │
 * │ 12 │ Tanya    │ 45    │ 42    │ 48    │ 48             │ 42          │
 * └────┴──────────┴───────┴───────┴───────┴────────────────┴─────────────┘
 */

-- ============================================================================
-- PART 4: COALESCE() - First non-NULL value
-- ============================================================================

/**
 * COALESCE() returns the first non-NULL value from a list.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COALESCE() - EXPLANATION                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(value1, value2, value3, ..., default_value)            │   │
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
 * │   EXAMPLE:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ COALESCE(NULL, 'hello', 'world') = 'hello'                      │   │
 * │   │ COALESCE(NULL, NULL, 'default') = 'default'                     │   │
 *   │   │ COALESCE('', 'fallback') = '' (empty string is NOT NULL)       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Create COALESCE demo table
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

-- SCENARIO 1: Basic COALESCE to get first non-NULL email
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
 * │ 5  │                     │ ← empty string (not NULL!)
 * └────┴─────────────────────┘
 */

-- SCENARIO 2: COALESCE with default email
SELECT 
    id,
    COALESCE(primary_email, work_email, personal_email, 'hello@tuf') AS contact_email
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
 * │ 4  │ hello@tuf           │ ← default used (all NULL)
 * │ 5  │                     │ ← empty string (still not NULL!)
 * └────┴─────────────────────┘
 */

-- ============================================================================
-- PART 5: NULLIF() - Convert specific value to NULL
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
 * │   EXAMPLE:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ NULLIF('', '') = NULL (empty string becomes NULL)              │   │
 * │   │ NULLIF('hello', '') = 'hello' (not equal)                       │   │
 * │   │ NULLIF(0, 0) = NULL                                            │   │
 * │   │ NULLIF(5, 0) = 5                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Convert empty strings to NULL
SELECT 
    id,
    phone,
    NULLIF(phone, '') AS phone_nullified
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬────────────┬─────────────────┐
 * │ id │ phone      │ phone_nullified │
 * ├────┼────────────┼─────────────────┤
 * │ 1  │ NULL       │ NULL            │
 * │ 2  │            │ NULL            │ ← empty string becomes NULL
 * │ 3  │ 8888000004 │ 8888000004      │
 * │ 4  │ 9777000005 │ 9777000005      │
 * │ 5  │ NULL       │ NULL            │
 * │ 6  │ 9666000007 │ 9666000007      │
 * │ 7  │ NULL       │ NULL            │
 * │ 8  │            │ NULL            │ ← empty string becomes NULL
 * │ 9  │ 9555000010 │ 9555000010      │
 * │ 10 │ NULL       │ NULL            │
 * │ 11 │ 9444000012 │ 9444000012      │
 * │ 12 │            │ NULL            │ ← empty string becomes NULL
 * └────┴────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 6: Handling Empty Strings vs NULL (Important distinction!)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              EMPTY STRING vs NULL - IMPORTANT DIFFERENCE                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   NULL          = Missing / Unknown data                               │
 * │   Empty String ('') = Data exists but is empty                         │
 * │                                                                          │
 * │   COALESCE() treats empty string as a VALID value (not NULL)           │
 * │   IFNULL() also treats empty string as valid                           │
 * │                                                                          │
 * │   SOLUTION: Use NULLIF() to convert empty strings to NULL              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              HANDLING EMPTY STRINGS - CORRECT WAY                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, phone,                                         │   │
 * │   │        COALESCE(NULLIF(phone, ''), 'Not Provided') AS final_phone│   │
 * │   │ FROM students                                                   │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬────────────┬──────────────┐                       │
 * │   │ id │ name     │ phone      │ final_phone  │                       │
 * │   ├────┼──────────┼────────────┼──────────────┤                       │
 * │   │ 1  │ Aisha    │ NULL       │ Not Provided │                       │
 * │   │ 2  │ Rohan    │            │ Not Provided │ ← handled!            │
 * │   │ 3  │ Meenal   │ 8888000004 │ 8888000004   │                       │
 * │   │ 4  │ Arjun    │ 9777000005 │ 9777000005   │                       │
 * │   │ 5  │ Neha     │ NULL       │ Not Provided │                       │
 * │   │ 6  │ Vikas    │ 9666000007 │ 9666000007   │                       │
 * │   │ 7  │ Sana     │ NULL       │ Not Provided │                       │
 * │   │ 8  │ Imran    │            │ Not Provided │ ← handled!            │
 * │   │ 9  │ Pallavi  │ 9555000010 │ 9555000010   │                       │
 * │   │ 10 │ Deepak   │ NULL       │ Not Provided │                       │
 * │   │ 11 │ Ananya   │ 9444000012 │ 9444000012   │                       │
 * │   │ 12 │ Tanya    │            │ Not Provided │ ← handled!            │
 * │   └────┴──────────┴────────────┴──────────────┘                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Handle both NULL and empty strings
SELECT 
    id,
    name,
    phone,
    COALESCE(NULLIF(phone, ''), 'Not Provided') AS final_phone
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬────────────┬──────────────┐
 * │ id │ name     │ phone      │ final_phone  │
 * ├────┼──────────┼────────────┼──────────────┤
 * │ 1  │ Aisha    │ NULL       │ Not Provided │
 * │ 2  │ Rohan    │            │ Not Provided │
 * │ 3  │ Meenal   │ 8888000004 │ 8888000004   │
 * │ 4  │ Arjun    │ 9777000005 │ 9777000005   │
 * │ 5  │ Neha     │ NULL       │ Not Provided │
 * │ 6  │ Vikas    │ 9666000007 │ 9666000007   │
 * │ 7  │ Sana     │ NULL       │ Not Provided │
 * │ 8  │ Imran    │            │ Not Provided │
 * │ 9  │ Pallavi  │ 9555000010 │ 9555000010   │
 * │ 10 │ Deepak   │ NULL       │ Not Provided │
 * │ 11 │ Ananya   │ 9444000012 │ 9444000012   │
 * │ 12 │ Tanya    │            │ Not Provided │
 * └────┴──────────┴────────────┴──────────────┘
 */

-- ============================================================================
-- PART 7: IS NULL vs IS NOT NULL (Check for NULL values)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              IS NULL vs IS NOT NULL - EXPLANATION                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ WHERE column IS NULL        -- Check if value is NULL           │   │
 * │   │ WHERE column IS NOT NULL    -- Check if value is NOT NULL       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   CRITICAL: = NULL does NOT work!                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ❌ WHERE phone = NULL    ← Always returns FALSE!                │   │
 *   │   │ ✅ WHERE phone IS NULL   ← Correct way to check for NULL       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              IS NULL vs IS NOT NULL - EXAMPLE                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find students with no phone (NULL)                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, phone FROM students WHERE phone IS NULL;       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬───────┐                                          │
 * │   │ id │ name     │ phone │                                          │
 *   │   ├────┼──────────┼───────┤                                          │
 * │   │ 1  │ Aisha    │ NULL  │                                          │
 * │   │ 5  │ Neha     │ NULL  │                                          │
 * │   │ 7  │ Sana     │ NULL  │                                          │
 * │   │ 10 │ Deepak   │ NULL  │                                          │
 * │   └────┴──────────┴───────┘                                          │
 * │                                                                          │
 * │   NOTE: Students with empty string ('') are NOT included!              │
 * │         (Rohan, Imran, Tanya have empty string, not NULL)              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find students with NULL phone (not empty string)
SELECT id, name, phone
FROM students
WHERE phone IS NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────┐
 * │ id │ name     │ phone │
 * ├────┼──────────┼───────┤
 * │ 1  │ Aisha    │ NULL  │
 * │ 5  │ Neha     │ NULL  │
 * │ 7  │ Sana     │ NULL  │
 * │ 10 │ Deepak   │ NULL  │
 * └────┴──────────┴───────┘
 */

-- Find students with phone value (both actual numbers AND empty strings)
SELECT id, name, phone
FROM students
WHERE phone IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬────────────┐
 * │ id │ name     │ phone      │
 * ├────┼──────────┼────────────┤
 * │ 2  │ Rohan    │            │ ← empty string
 * │ 3  │ Meenal   │ 8888000004 │
 * │ 4  │ Arjun    │ 9777000005 │
 * │ 6  │ Vikas    │ 9666000007 │
 * │ 8  │ Imran    │            │ ← empty string
 * │ 9  │ Pallavi  │ 9555000010 │
 * │ 11 │ Ananya   │ 9444000012 │
 * │ 12 │ Tanya    │            │ ← empty string
 * └────┴──────────┴────────────┘
 */

-- ============================================================================
-- PART 8: COALESCE with NULLIF and TRIM (Clean and handle empty strings)
-- ============================================================================

/**
 * Combine NULLIF, TRIM, and COALESCE to handle whitespace and empty strings.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              COALESCE with NULLIF and TRIM - Complete Solution          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, primary_email, work_email, personal_email,    │   │
 * │   │        COALESCE(NULLIF(TRIM(primary_email), ''),                │   │
 * │   │                 work_email,                                     │   │
 * │   │                 personal_email) AS contact_email                │   │
 * │   │ FROM coalesce_demo                                              │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────────┬─────────────────────┐                         │
 * │   │ id │ primary_email│ contact_email       │                         │
 * │   ├────┼──────────────┼─────────────────────┤                         │
 * │   │ 1  │ aisha@...    │ aisha@company.com   │                         │
 * │   │ 2  │ NULL         │ rohan@company.com   │                         │
 * │   │ 3  │ NULL         │ meera@yahoo.com     │                         │
 * │   │ 4  │ NULL         │ NULL                │                         │
 * │   │ 5  │ ''           │ raj@gmail.com       │ ← empty string handled! │
 * │   └────┴──────────────┴─────────────────────┘                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Complete solution: Handle NULL, empty strings, and whitespace
SELECT 
    id,
    primary_email,
    work_email,
    personal_email,
    COALESCE(
        NULLIF(TRIM(primary_email), ''),
        work_email,
        personal_email
    ) AS contact_email
FROM coalesce_demo
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┬─────────────────────┬─────────────────┬─────────────────────┐
 * │ id │ primary_email       │ work_email          │ personal_email  │ contact_email       │
 * ├────┼─────────────────────┼─────────────────────┼─────────────────┼─────────────────────┤
 * │ 1  │ aisha@company.com   │ NULL                │ aisha@gmail.com │ aisha@company.com   │
 * │ 2  │ NULL                │ rohan@company.com   │ NULL            │ rohan@company.com   │
 * │ 3  │ NULL                │ NULL                │ meera@yahoo.com │ meera@yahoo.com     │
 * │ 4  │ NULL                │ NULL                │ NULL            │ NULL                │
 * │ 5  │                     │ NULL                │ raj@gmail.com   │ raj@gmail.com       │
 * └────┴─────────────────────┴─────────────────────┴─────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 9: COALESCE for Hours Logged (Replace NULL with default)
-- ============================================================================

-- SCENARIO 3: COALESCE with hours_logged
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
 */

-- ============================================================================
-- PART 10: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Student Report Card - Best and Worst Scores
 * 
 * For each student, show highest and lowest test score
 */

SELECT 
    id,
    name,
    test1,
    test2,
    test3,
    GREATEST(test1, test2, test3) AS highest_score,
    LEAST(test1, test2, test3) AS lowest_score,
    ROUND((test1 + test2 + test3) / 3.0, 1) AS average_score
FROM students
WHERE test1 IS NOT NULL AND test2 IS NOT NULL AND test3 IS NOT NULL
ORDER BY average_score DESC;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────┬───────┬───────┬───────────────┬──────────────┬───────────────┐
 * │ id │ name     │ test1 │ test2 │ test3 │ highest_score │ lowest_score │ average_score │
 * ├────┼──────────┼───────┼───────┼───────┼───────────────┼──────────────┼───────────────┤
 * │ 6  │ Vikas    │ 88    │ 91    │ 95    │ 95            │ 88           │ 91.3          │
 * │ 9  │ Pallavi  │ 92    │ 90    │ 91    │ 92            │ 90           │ 91.0          │
 * │ 4  │ Arjun    │ 72    │ 70    │ 75    │ 75            │ 70           │ 72.3          │
 * │ 1  │ Aisha    │ 55    │ 60    │ 58    │ 60            │ 55           │ 57.7          │
 * │ 8  │ Imran    │ 50    │ 49    │ 51    │ 51            │ 49           │ 50.0          │
 * │ 12 │ Tanya    │ 45    │ 42    │ 48    │ 48            │ 42           │ 45.0          │
 * │ 5  │ Neha     │ 10    │ 15    │ 12    │ 15            │ 10           │ 12.3          │
 * └────┴──────────┴───────┴───────┴───────┴───────────────┴──────────────┴───────────────┘
 */

/**
 * SCENARIO 2: Fee Payment Summary
 * 
 * Round fees to nearest rupee and show absolute change
 */

SELECT 
    id,
    name,
    fee_paid,
    ROUND(fee_paid, 0) AS rounded_fee,
    score_change,
    ABS(score_change) AS absolute_change,
    CASE 
        WHEN score_change > 0 THEN 'Increased'
        WHEN score_change < 0 THEN 'Decreased'
        WHEN score_change = 0 THEN 'No Change'
        ELSE 'Unknown'
    END AS change_direction
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY absolute_change DESC;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────┬─────────────┬──────────────┬─────────────────┬──────────────────┐
 * │ id │ name     │ fee_paid │ rounded_fee │ score_change │ absolute_change │ change_direction │
 * ├────┼──────────┼──────────┼─────────────┼──────────────┼─────────────────┼──────────────────┤
 * │ 6  │ Vikas    │ 5099.00  │ 5099        │ 120.75       │ 120.75          │ Increased        │
 * │ 2  │ Rohan    │ 3303.06  │ 3303        │ -80.00       │ 80.00           │ Decreased        │
 * │ 5  │ Neha     │ 3499.00  │ 3499        │ -30.75       │ 30.75           │ Decreased        │
 * │ 10 │ Deepak   │ NULL     │ NULL        │ -22.00       │ 22.00           │ Decreased        │
 * │ 11 │ Ananya   │ 3504.16  │ 3504        │ 18.50        │ 18.50           │ Increased        │
 * │ 7  │ Sana     │ 7085.13  │ 7085        │ -15.00       │ 15.00           │ Decreased        │
 * │ 1  │ Aisha    │ 2804.45  │ 2804        │ -12.25       │ 12.25           │ Decreased        │
 * │ 12 │ Tanya    │ 3303.06  │ 3303        │ -10.00       │ 10.00           │ Decreased        │
 * │ 4  │ Arjun    │ 3717.94  │ 3718        │ 10.00        │ 10.00           │ Increased        │
 * │ 9  │ Pallavi  │ 3303.06  │ 3303        │ 5.25         │ 5.25            │ Increased        │
 * │ 8  │ Imran    │ 3303.06  │ 3303        │ -1.00        │ 1.00            │ Decreased        │
 * │ 3  │ Meenal   │ 7999.00  │ 7999        │ NULL         │ NULL            │ Unknown          │
 * └────┴──────────┴──────────┴─────────────┴──────────────┴─────────────────┴──────────────────┘
 */

/**
 * SCENARIO 3: Contact Information (Handle Missing Phone Numbers)
 * 
 * Display phone number or 'No Phone' for missing/empty values
 */

SELECT 
    id,
    name,
    COALESCE(NULLIF(phone, ''), 'No Phone') AS contact_phone,
    COALESCE(NULLIF(city, ''), 'City Unknown') AS student_city
FROM students
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────────┬───────────────┐
 * │ id │ name     │ contact_phone │ student_city  │
 * ├────┼──────────┼──────────────┼───────────────┤
 * │ 1  │ Aisha    │ No Phone     │ Delhi         │
 * │ 2  │ Rohan    │ No Phone     │ Mumbai        │
 * │ 3  │ Meenal   │ 8888000004   │ City Unknown  │
 * │ 4  │ Arjun    │ 9777000005   │ Pune          │
 * │ 5  │ Neha     │ No Phone     │ Jaipur        │
 * │ 6  │ Vikas    │ 9666000007   │ Hyderabad     │
 * │ 7  │ Sana     │ No Phone     │ Ahmedabad     │
 * │ 8  │ Imran    │ No Phone     │ Kolkata       │
 * │ 9  │ Pallavi  │ 9555000010   │ City Unknown  │
 * │ 10 │ Deepak   │ No Phone     │ Chennai       │
 * │ 11 │ Ananya   │ 9444000012   │ Bengaluru     │
 * │ 12 │ Tanya    │ No Phone     │ Kolkata       │
 * └────┴──────────┴──────────────┴───────────────┘
 */

/**
 * SCENARIO 4: Fee Analysis with ROUND and ABS
 * 
 * Analyze fee payments and score changes
 */

SELECT 
    name,
    fee_paid,
    ROUND(fee_paid, -2) AS fee_hundreds,  -- Round to nearest hundred
    score_change,
    ABS(score_change) AS magnitude,
    CASE 
        WHEN ABS(score_change) > 50 THEN 'Dramatic Change'
        WHEN ABS(score_change) > 20 THEN 'Significant Change'
        WHEN ABS(score_change) > 5 THEN 'Moderate Change'
        WHEN score_change IS NOT NULL THEN 'Small Change'
        ELSE 'No Data'
    END AS change_severity
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY magnitude DESC;

/**
 * OUTPUT:
 * ┌──────────┬──────────┬──────────────┬──────────────┬──────────┬─────────────────────┐
 * │ name     │ fee_paid │ fee_hundreds │ score_change │ magnitude │ change_severity     │
 * ├──────────┼──────────┼──────────────┼──────────────┼──────────┼─────────────────────┤
 * │ Vikas    │ 5099.00  │ 5100         │ 120.75       │ 120.75   │ Dramatic Change     │
 * │ Rohan    │ 3303.06  │ 3300         │ -80.00       │ 80.00    │ Dramatic Change     │
 * │ Neha     │ 3499.00  │ 3500         │ -30.75       │ 30.75    │ Significant Change  │
 * │ Ananya   │ 3504.16  │ 3500         │ 18.50        │ 18.50    │ Moderate Change     │
 * │ Sana     │ 7085.13  │ 7100         │ -15.00       │ 15.00    │ Moderate Change     │
 * │ Aisha    │ 2804.45  │ 2800         │ -12.25       │ 12.25    │ Moderate Change     │
 * │ Tanya    │ 3303.06  │ 3300         │ -10.00       │ 10.00    │ Moderate Change     │
 * │ Arjun    │ 3717.94  │ 3700         │ 10.00        │ 10.00    │ Moderate Change     │
 * │ Pallavi  │ 3303.06  │ 3300         │ 5.25         │ 5.25     │ Small Change        │
 * │ Imran    │ 3303.06  │ 3300         │ -1.00        │ 1.00     │ Small Change        │
 * └──────────┴──────────┴──────────────┴──────────────┴──────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 11: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Using = NULL instead of IS NULL                            │
 * │                                                                          │
 * │   ❌ SELECT * FROM students WHERE phone = NULL;                         │
 * │      → Returns NO rows (always FALSE!)                                 │
 * │                                                                          │
 * │   ✅ SELECT * FROM students WHERE phone IS NULL;                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ WRONG - This returns no rows even if NULLs exist
SELECT * FROM students WHERE phone = NULL;

-- ✅ CORRECT
SELECT * FROM students WHERE phone IS NULL;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Assuming COALESCE handles empty strings                    │
 * │                                                                          │
 * │   ❌ COALESCE(phone, 'Not Provided')                                   │
 * │      → Empty string ('') stays as '' (not replaced!)                   │
 * │                                                                          │
 * │   ✅ COALESCE(NULLIF(phone, ''), 'Not Provided')                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Empty strings not replaced
SELECT COALESCE(phone, 'Not Provided') FROM students WHERE id = 2;  -- Returns ''

-- ✅ Empty strings converted to NULL then replaced
SELECT COALESCE(NULLIF(phone, ''), 'Not Provided') FROM students WHERE id = 2;  -- Returns 'Not Provided'

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: GREATEST/LEAST with NULL values                           │
 * │                                                                          │
 *   │   ❌ GREATEST(55, NULL, 58) → Returns NULL (not 58!)                  │
 * │                                                                          │
 * │   ✅ Use COALESCE to handle NULLs before GREATEST:                      │
 * │      GREATEST(COALESCE(test1, 0), COALESCE(test2, 0), COALESCE(test3, 0))│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- This returns NULL if any test is NULL
SELECT GREATEST(55, NULL, 58) AS result;  -- Returns NULL

-- Better: Replace NULLs with 0
SELECT GREATEST(COALESCE(55, 0), COALESCE(NULL, 0), COALESCE(58, 0)) AS result;  -- Returns 58

-- ============================================================================
-- PART 12: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Use IS NULL / IS NOT NULL to check for NULL                    │
 * │         → NEVER use = NULL                                             │
 * │                                                                          │
 * │ RULE 2: COALESCE does NOT treat empty strings as NULL                  │
 * │         → Use NULLIF(column, '') to convert empty strings to NULL      │
 * │                                                                          │
 * │ RULE 3: GREATEST/LEAST return NULL if ANY argument is NULL             │
 * │         → Use COALESCE to replace NULLs before using GREATEST/LEAST    │
 * │                                                                          │
 * │ RULE 4: ROUND(0.5) rounds UP (0.5 and above → up)                      │
 * │         → ROUND(0.49) rounds DOWN                                      │
 * │                                                                          │
 * │ RULE 5: ABS removes negative sign (distance from zero)                 │
 * │         → Useful for measuring magnitude regardless of direction       │
 * │                                                                          │
 * │ RULE 6: COALESCE can have 2 or more arguments                          │
 * │         → Returns first non-NULL value                                 │
 * │                                                                          │
 * │ RULE 7: NULLIF(value1, value2) returns NULL if equal                   │
 * │         → Useful for converting specific values (like 0, '', -1) to NULL│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ -- ROUND: Round numbers                                                 │
 * │ ROUND(2804.45, 0)      → 2804                                          │
 * │ ROUND(3717.94, 0)      → 3718                                          │
 * │ ROUND(3504.16, 1)      → 3504.2                                        │
 * │                                                                          │
 * │ -- ABS: Absolute value (remove negative sign)                          │
 * │ ABS(-12.25)            → 12.25                                         │
 * │ ABS(120.75)            → 120.75                                        │
 * │                                                                          │
 * │ -- GREATEST/LEAST: Largest/smallest from list                          │
 * │ GREATEST(55, 60, 58)   → 60                                            │
 * │ LEAST(55, 60, 58)      → 55                                            │
 * │                                                                          │
 * │ -- COALESCE: First non-NULL                                             │
 * │ COALESCE(NULL, 'hello', 'world') → 'hello'                             │
 * │ COALESCE(hours, 0)     → hours if not NULL, else 0                     │
 * │                                                                          │
 * │ -- NULLIF: Convert specific value to NULL                              │
 * │ NULLIF('', '')         → NULL                                          │
 * │ NULLIF(0, 0)           → NULL                                          │
 * │                                                                          │
 * │ -- Handle empty strings properly                                        │
 * │ COALESCE(NULLIF(phone, ''), 'Not Provided')                            │
 * │                                                                          │
 * │ -- Check for NULL (NEVER use = NULL)                                   │
 * │ WHERE phone IS NULL      -- Correct                                    │
 * │ WHERE phone = NULL       -- WRONG!                                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Round all fee_paid values to 2 decimal places
 * 
 * Answer:
 *   SELECT id, name, ROUND(fee_paid, 2) FROM students;
 */

/**
 * EXERCISE 2: Find absolute value of score_change for all students
 * 
 * Answer:
 *   SELECT id, name, ABS(score_change) FROM students;
 */

/**
 * EXERCISE 3: Find highest test score for each student
 * 
 * Answer:
 *   SELECT id, name, GREATEST(test1, test2, test3) FROM students;
 */

/**
 * EXERCISE 4: Display phone number or 'No Phone' for missing/empty phones
 * 
 * Answer:
 *   SELECT id, name, COALESCE(NULLIF(phone, ''), 'No Phone') FROM students;
 */

/**
 * EXERCISE 5: Find students with NULL phone numbers
 * 
 * Answer:
 *   SELECT * FROM students WHERE phone IS NULL;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS coalesce_demo;
DROP TABLE IF EXISTS students;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. ROUND() → Rounds numbers to specified decimal places                │
 * │    → 0.5 and above rounds UP, below 0.5 rounds DOWN                    │
 * │                                                                          │
 * │ 2. ABS() → Returns absolute value (removes negative sign)              │
 * │    → Useful for measuring magnitude                                    │
 * │                                                                          │
 * │ 3. GREATEST() / LEAST() → Returns largest/smallest from list           │
 * │    → Returns NULL if ANY argument is NULL                              │
 * │                                                                          │
 * │ 4. COALESCE() → Returns first non-NULL value                           │
 * │    → Does NOT treat empty strings as NULL                              │
 * │                                                                          │
 * │ 5. NULLIF() → Returns NULL if two values are equal                     │
 * │    → Useful for converting empty strings to NULL                       │
 * │                                                                          │
 * │ 6. IS NULL / IS NOT NULL → Check for NULL values                       │
 * │    → NEVER use = NULL                                                  │
 * │                                                                          │
 * │ 7. Handle empty strings: COALESCE(NULLIF(column, ''), 'default')       │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - NULL is different from empty string ('')                           │
 * │   - GREATEST/LEAST fail with NULL                                      │
 * │   - COALESCE sees empty string as valid                                │
 * │   - Use IS NULL, not = NULL                                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF STRING & NUMERIC FUNCTIONS GUIDE
-- ============================================================================