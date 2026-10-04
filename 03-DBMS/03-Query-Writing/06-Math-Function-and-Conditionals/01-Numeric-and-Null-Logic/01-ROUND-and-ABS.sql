/**
 * ============================================================================
 * NUMERIC FUNCTIONS - COMPLETE REVISION GUIDE
 * (ROUND and ABS only)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. ROUND() ------------------------------- (Round numbers to decimal places)
 *    - 1.1 Basic rounding (0 decimal places)
 *    - 1.2 Rounding to 1 decimal place
 *    - 1.3 Rounding to 2 decimal places
 *    - 1.4 Rounding to nearest ten (negative decimals: -1)
 *    - 1.5 Rounding to nearest hundred (negative decimals: -2)
 *    - 1.6 Rounding to nearest thousand (negative decimals: -3)
 * 
 * 2. ABS() --------------------------------- (Absolute value - remove negative sign)
 *    - 2.1 Basic absolute value
 *    - 2.2 Finding magnitude of change
 *    - 2.3 Calculating errors or gaps
 *    - 2.4 Finding largest performance shifts
 * 
 * 3. COMMON MISTAKES ----------------------- (What to avoid)
 * 
 * 4. GOLDEN RULES -------------------------- (Key principles)
 * 
 * 5. QUICK REFERENCE CARD ------------------ (Cheat sheet)
 * 
 * 6. PRACTICE EXERCISES -------------------- (Test yourself)
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
    fee_paid NUMERIC(10,2),
    score_change NUMERIC(10,2),
    target_score INT,
    actual_score INT
);

INSERT INTO students (id, name, city, fee_paid, score_change, target_score, actual_score) VALUES
(1,  'Aisha',   'Delhi',     2804.45,  -12.25, 50, 55),
(2,  'Rohan',   'Mumbai',    3303.06,  -80.00, 50, 40),
(3,  'Meenal',  NULL,        7999.00,   NULL, 50, NULL),
(4,  'Arjun',   'Pune',      3717.94,   10.00, 50, 72),
(5,  'Neha',    'Jaipur',    3499.00,  -30.75, 50, 10),
(6,  'Vikas',   'Hyderabad', 5099.00,  120.75, 50, 88),
(7,  'Sana',    'Ahmedabad', 7085.13,  -15.00, 50, 65),
(8,  'Imran',   'Kolkata',   3303.06,   -1.00, 50, 50),
(9,  'Pallavi', '',          3303.06,    5.25, 50, 92),
(10, 'Deepak',  'Chennai',    NULL,    -22.00, 50, 33),
(11, 'Ananya',  'Bengaluru', 3504.16,   18.50, 50, 78),
(12, 'Tanya',   'Kolkata',   3303.06,  -10.00, 50, 45);

-- Display the data
SELECT id, name, city, fee_paid, score_change, target_score, actual_score 
FROM students 
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬───────────┬──────────┬──────────────┬──────────────┬──────────────┐
 * │ id │ name     │ city      │ fee_paid │ score_change │ target_score │ actual_score │
 * ├────┼──────────┼───────────┼──────────┼──────────────┼──────────────┼──────────────┤
 * │ 1  │ Aisha    │ Delhi     │ 2804.45  │ -12.25       │ 50           │ 55           │
 * │ 2  │ Rohan    │ Mumbai    │ 3303.06  │ -80.00       │ 50           │ 40           │
 * │ 3  │ Meenal   │ NULL      │ 7999.00  │ NULL         │ 50           │ NULL         │
 * │ 4  │ Arjun    │ Pune      │ 3717.94  │ 10.00        │ 50           │ 72           │
 * │ 5  │ Neha     │ Jaipur    │ 3499.00  │ -30.75       │ 50           │ 10           │
 * │ 6  │ Vikas    │ Hyderabad │ 5099.00  │ 120.75       │ 50           │ 88           │
 * │ 7  │ Sana     │ Ahmedabad │ 7085.13  │ -15.00       │ 50           │ 65           │
 * │ 8  │ Imran    │ Kolkata   │ 3303.06  │ -1.00        │ 50           │ 50           │
 * │ 9  │ Pallavi  │           │ 3303.06  │ 5.25         │ 50           │ 92           │
 * │ 10 │ Deepak   │ Chennai   │ NULL     │ -22.00       │ 50           │ 33           │
 * │ 11 │ Ananya   │ Bengaluru │ 3504.16  │ 18.50        │ 50           │ 78           │
 * │ 12 │ Tanya    │ Kolkata   │ 3303.06  │ -10.00       │ 50           │ 45           │
 * └────┴──────────┴───────────┴──────────┴──────────────┴──────────────┴──────────────┘
 */

-- ============================================================================
-- PART 1: ROUND() - Round numbers to decimal places
-- ============================================================================

/**
 * ROUND(number, decimals) rounds a number to a specific number of decimal places.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    ROUND() - EXPLANATION                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ROUND(number, decimal_places)                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   RULES:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • 0.5 and above → rounds UP                                     │   │
 * │   │ • Below 0.5 → rounds DOWN                                       │   │
 * │   │ • If decimal_places is 0 → rounds to nearest integer            │   │
 * │   │ • If decimal_places is 1 → rounds to 1 decimal place            │   │
 * │   │ • If decimal_places is -1 → rounds to nearest ten               │   │
 * │   │ • If decimal_places is -2 → rounds to nearest hundred           │   │
 * │   │ • If decimal_places is -3 → rounds to nearest thousand          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ROUND(2804.45, 0) = 2804  (0.45 < 0.5 → rounds down)           │   │
 * │   │ ROUND(3717.94, 0) = 3718  (0.94 ≥ 0.5 → rounds up)             │   │
 * │   │ ROUND(3504.16, 0) = 3504  (0.16 < 0.5 → rounds down)           │   │
 * │   │ ROUND(2804.45, 1) = 2804.5 (4.5? Actually 0.45 rounds to 0.5)  │   │
 * │   │ ROUND(5099.00, -2) = 5100 (rounds to nearest hundred)          │   │
 * │   │ ROUND(7999.00, -2) = 8000 (rounds to nearest hundred)          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 1.1 ROUND() - Basic rounding (0 decimal places)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              ROUND() - Basic Rounding to Nearest Integer                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT id, name, fee_paid, ROUND(fee_paid, 0) AS fee_rupees    │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE fee_paid IS NOT NULL                                      │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────┬──────────┬──────────┬────────────┐                           │
 * │   │ id │ name     │ fee_paid │ fee_rupees │                           │
 * │   ├────┼──────────┼──────────┼────────────┤                           │
 * │   │ 1  │ Aisha    │ 2804.45  │ 2804       │  (0.45 < 0.5 → down)      │
 * │   │ 2  │ Rohan    │ 3303.06  │ 3303       │  (0.06 < 0.5 → down)      │
 * │   │ 3  │ Meenal   │ 7999.00  │ 7999       │  (0.00 < 0.5 → down)      │
 * │   │ 4  │ Arjun    │ 3717.94  │ 3718       │  (0.94 ≥ 0.5 → up)        │
 * │   │ 5  │ Neha     │ 3499.00  │ 3499       │  (0.00 < 0.5 → down)      │
 * │   │ 6  │ Vikas    │ 5099.00  │ 5099       │  (0.00 < 0.5 → down)      │
 * │   │ 7  │ Sana     │ 7085.13  │ 7085       │  (0.13 < 0.5 → down)      │
 * │   │ 8  │ Imran    │ 3303.06  │ 3303       │  (0.06 < 0.5 → down)      │
 * │   │ 9  │ Pallavi  │ 3303.06  │ 3303       │  (0.06 < 0.5 → down)      │
 * │   │ 11 │ Ananya   │ 3504.16  │ 3504       │  (0.16 < 0.5 → down)      │
 * │   │ 12 │ Tanya    │ 3303.06  │ 3303       │  (0.06 < 0.5 → down)      │
 * │   └────┴──────────┴──────────┴────────────┘                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    id,
    name,
    fee_paid,
    ROUND(fee_paid, 0) AS fee_rupees
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────┬────────────┐
 * │ id │ name     │ fee_paid │ fee_rupees │
 * ├────┼──────────┼──────────┼────────────┤
 * │ 1  │ Aisha    │ 2804.45  │ 2804       │
 * │ 2  │ Rohan    │ 3303.06  │ 3303       │
 * │ 3  │ Meenal   │ 7999.00  │ 7999       │
 * │ 4  │ Arjun    │ 3717.94  │ 3718       │
 * │ 5  │ Neha     │ 3499.00  │ 3499       │
 * │ 6  │ Vikas    │ 5099.00  │ 5099       │
 * │ 7  │ Sana     │ 7085.13  │ 7085       │
 * │ 8  │ Imran    │ 3303.06  │ 3303       │
 * │ 9  │ Pallavi  │ 3303.06  │ 3303       │
 * │ 11 │ Ananya   │ 3504.16  │ 3504       │
 * │ 12 │ Tanya    │ 3303.06  │ 3303       │
 * └────┴──────────┴──────────┴────────────┘
 * 
 * EXPLANATION:
 * - Aisha: 2804.45 → 0.45 < 0.5 → rounds DOWN to 2804
 * - Arjun: 3717.94 → 0.94 ≥ 0.5 → rounds UP to 3718
 * - Ananya: 3504.16 → 0.16 < 0.5 → rounds DOWN to 3504
 */

-- ============================================================================
-- 1.2 ROUND() - Rounding to 1 decimal place
-- ============================================================================

SELECT
    id,
    name,
    fee_paid,
    ROUND(fee_paid, 1) AS fee_1_decimal
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────┬───────────────┐
 * │ id │ name     │ fee_paid │ fee_1_decimal │
 * ├────┼──────────┼──────────┼───────────────┤
 * │ 1  │ Aisha    │ 2804.45  │ 2804.5        │
 * │ 2  │ Rohan    │ 3303.06  │ 3303.1        │
 * │ 3  │ Meenal   │ 7999.00  │ 7999.0        │
 * │ 4  │ Arjun    │ 3717.94  │ 3717.9        │
 * │ 5  │ Neha     │ 3499.00  │ 3499.0        │
 * │ 6  │ Vikas    │ 5099.00  │ 5099.0        │
 * │ 7  │ Sana     │ 7085.13  │ 7085.1        │
 * │ 8  │ Imran    │ 3303.06  │ 3303.1        │
 * │ 9  │ Pallavi  │ 3303.06  │ 3303.1        │
 * │ 11 │ Ananya   │ 3504.16  │ 3504.2        │
 * │ 12 │ Tanya    │ 3303.06  │ 3303.1        │
 * └────┴──────────┴──────────┴───────────────┘
 * 
 * EXPLANATION:
 * - Aisha: 2804.45 → rounds to 2804.5 (0.45 rounds to 0.5)
 * - Ananya: 3504.16 → rounds to 3504.2 (0.16 rounds to 0.2)
 * - Sana: 7085.13 → rounds to 7085.1 (0.13 rounds to 0.1)
 */

-- ============================================================================
-- 1.3 ROUND() - Rounding to 2 decimal places
-- ============================================================================

SELECT
    id,
    name,
    fee_paid,
    ROUND(fee_paid, 2) AS fee_2_decimal
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬──────────┬──────────┬───────────────┐
 * │ id │ name     │ fee_paid │ fee_2_decimal │
 * ├────┼──────────┼──────────┼───────────────┤
 * │ 1  │ Aisha    │ 2804.45  │ 2804.45       │
 * │ 2  │ Rohan    │ 3303.06  │ 3303.06       │
 * │ 3  │ Meenal   │ 7999.00  │ 7999.00       │
 * │ 4  │ Arjun    │ 3717.94  │ 3717.94       │
 * │ 5  │ Neha     │ 3499.00  │ 3499.00       │
 * │ 6  │ Vikas    │ 5099.00  │ 5099.00       │
 * │ 7  │ Sana     │ 7085.13  │ 7085.13       │
 * │ 8  │ Imran    │ 3303.06  │ 3303.06       │
 * │ 9  │ Pallavi  │ 3303.06  │ 3303.06       │
 * │ 11 │ Ananya   │ 3504.16  │ 3504.16       │
 * │ 12 │ Tanya    │ 3303.06  │ 3303.06       │
 * └────┴──────────┴──────────┴───────────────┘
 * 
 * EXPLANATION:
 * - Already at 2 decimal places, so no change
 */

-- ============================================================================
-- 1.4 ROUND() - Rounding to nearest ten (negative decimals: -1)
-- ============================================================================

/**
 * ROUND with negative decimals:
 * -1 → rounds to nearest 10
 * -2 → rounds to nearest 100
 * -3 → rounds to nearest 1000
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              ROUND() - Rounding to Nearest Ten (-1)                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name, fee_paid, ROUND(fee_paid, -1) AS nearest_ten      │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE fee_paid IS NOT NULL                                      │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬──────────┬─────────────┐                               │
 * │   │ name     │ fee_paid │ nearest_ten │                               │
 * │   ├──────────┼──────────┼─────────────┤                               │
 * │   │ Aisha    │ 2804.45  │ 2800        │                               │
 * │   │ Rohan    │ 3303.06  │ 3300        │                               │
 * │   │ Meenal   │ 7999.00  │ 8000        │  (79.99 → rounds to 80)       │
 * │   │ Arjun    │ 3717.94  │ 3720        │                               │
 * │   │ Vikas    │ 5099.00  │ 5100        │                               │
 * │   └──────────┴──────────┴─────────────┘                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    name, 
    fee_paid, 
    ROUND(fee_paid, -1) AS nearest_ten
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌──────────┬──────────┬─────────────┐
 * │ name     │ fee_paid │ nearest_ten │
 * ├──────────┼──────────┼─────────────┤
 * │ Aisha    │ 2804.45  │ 2800        │
 * │ Rohan    │ 3303.06  │ 3300        │
 * │ Meenal   │ 7999.00  │ 8000        │
 * │ Arjun    │ 3717.94  │ 3720        │
 * │ Neha     │ 3499.00  │ 3500        │
 * │ Vikas    │ 5099.00  │ 5100        │
 * │ Sana     │ 7085.13  │ 7090        │
 * │ Imran    │ 3303.06  │ 3300        │
 * │ Pallavi  │ 3303.06  │ 3300        │
 * │ Ananya   │ 3504.16  │ 3500        │
 * │ Tanya    │ 3303.06  │ 3300        │
 * └──────────┴──────────┴─────────────┘
 * 
 * EXPLANATION:
 * - 2804.45 → looks at tens digit (0) → rounds to 2800
 * - 3717.94 → looks at tens digit (1) and ones digit (7) → 7 ≥ 5 → rounds UP to 3720
 * - 5099.00 → looks at tens digit (9) → rounds UP to 5100
 * - 7999.00 → looks at tens digit (9) → rounds UP to 8000
 */

-- ============================================================================
-- 1.5 ROUND() - Rounding to nearest hundred (negative decimals: -2)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              ROUND() - Rounding to Nearest Hundred (-2)                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name, fee_paid, ROUND(fee_paid, -2) AS rough_estimate    │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE fee_paid IS NOT NULL                                      │   │
 * │   │ ORDER BY id;                                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬──────────┬────────────────┐                           │
 * │   │ name     │ fee_paid │ rough_estimate │                           │
 * │   ├──────────┼──────────┼────────────────┤                           │
 * │   │ Aisha    │ 2804.45  │ 2800           │                           │
 * │   │ Rohan    │ 3303.06  │ 3300           │                           │
 * │   │ Meenal   │ 7999.00  │ 8000           │                           │
 * │   │ Arjun    │ 3717.94  │ 3700           │                           │
 * │   │ Vikas    │ 5099.00  │ 5100           │                           │
 * │   └──────────┴──────────┴────────────────┘                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    name, 
    fee_paid, 
    ROUND(fee_paid, -2) AS rough_estimate
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌──────────┬──────────┬────────────────┐
 * │ name     │ fee_paid │ rough_estimate │
 * ├──────────┼──────────┼────────────────┤
 * │ Aisha    │ 2804.45  │ 2800           │
 * │ Rohan    │ 3303.06  │ 3300           │
 * │ Meenal   │ 7999.00  │ 8000           │
 * │ Arjun    │ 3717.94  │ 3700           │
 * │ Neha     │ 3499.00  │ 3500           │
 * │ Vikas    │ 5099.00  │ 5100           │
 * │ Sana     │ 7085.13  │ 7100           │
 * │ Imran    │ 3303.06  │ 3300           │
 * │ Pallavi  │ 3303.06  │ 3300           │
 * │ Ananya   │ 3504.16  │ 3500           │
 * │ Tanya    │ 3303.06  │ 3300           │
 * └──────────┴──────────┴────────────────┘
 * 
 * EXPLANATION:
 * - 2804.45 → looks at hundreds digit (8) → rounds to 2800
 * - 3717.94 → looks at hundreds digit (7) → rounds to 3700
 * - 5099.00 → looks at hundreds digit (0) but tens digit 9 ≥ 5 → rounds UP to 5100
 * - 7999.00 → looks at hundreds digit (9) → rounds UP to 8000
 * - 7085.13 → looks at hundreds digit (0) but tens digit 8 ≥ 5 → rounds UP to 7100
 */

-- ============================================================================
-- 1.6 ROUND() - Rounding to nearest thousand (negative decimals: -3)
-- ============================================================================

SELECT 
    name, 
    fee_paid, 
    ROUND(fee_paid, -3) AS nearest_thousand
FROM students
WHERE fee_paid IS NOT NULL
ORDER BY id;

/**
 * OUTPUT:
 * ┌──────────┬──────────┬──────────────────┐
 * │ name     │ fee_paid │ nearest_thousand │
 * ├──────────┼──────────┼──────────────────┤
 * │ Aisha    │ 2804.45  │ 3000             │
 * │ Rohan    │ 3303.06  │ 3000             │
 * │ Meenal   │ 7999.00  │ 8000             │
 * │ Arjun    │ 3717.94  │ 4000             │
 * │ Neha     │ 3499.00  │ 3000             │
 * │ Vikas    │ 5099.00  │ 5000             │
 * │ Sana     │ 7085.13  │ 7000             │
 * │ Imran    │ 3303.06  │ 3000             │
 * │ Pallavi  │ 3303.06  │ 3000             │
 * │ Ananya   │ 3504.16  │ 4000             │
 * │ Tanya    │ 3303.06  │ 3000             │
 * └──────────┴──────────┴──────────────────┘
 * 
 * EXPLANATION:
 * - 2804.45 → looks at thousands digit (2) → 804 ≥ 500 → rounds UP to 3000
 * - 3303.06 → looks at thousands digit (3) → 303 < 500 → rounds DOWN to 3000
 * - 3717.94 → looks at thousands digit (3) → 717 ≥ 500 → rounds UP to 4000
 * - 7999.00 → looks at thousands digit (7) → 999 ≥ 500 → rounds UP to 8000
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
 * │   RULES:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Positive numbers → stay positive                              │   │
 * │   │ • Negative numbers → become positive                            │   │
 * │   │ • Zero → stays zero                                             │   │
 * │   │ • NULL → stays NULL                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHEN TO USE:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • When you care about MAGNITUDE of change, not direction       │   │
 * │   │ • When calculating errors or gaps (distance from target)        │   │
 * │   │ • When finding largest changes (positive OR negative)           │   │
 * │   │ • When measuring volatility                                     │   │
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
 */

-- ============================================================================
-- 2.1 ABS() - Basic absolute value (remove negative sign)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    ABS() - Basic Absolute Value                         │
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
 * │   │ 1  │ Aisha    │ -12.25       │ 12.25      │  (negative → positive)│
 * │   │ 2  │ Rohan    │ -80.00       │ 80.00      │  (negative → positive)│
 * │   │ 3  │ Meenal   │ NULL         │ NULL       │  (NULL stays NULL)    │
 * │   │ 4  │ Arjun    │ 10.00        │ 10.00      │  (positive stays)     │
 * │   │ 5  │ Neha     │ -30.75       │ 30.75      │  (negative → positive)│
 * │   │ 6  │ Vikas    │ 120.75       │ 120.75     │  (positive stays)     │
 * │   │ 7  │ Sana     │ -15.00       │ 15.00      │  (negative → positive)│
 * │   │ 8  │ Imran    │ -1.00        │ 1.00       │  (negative → positive)│
 * │   │ 9  │ Pallavi  │ 5.25         │ 5.25       │  (positive stays)     │
 * │   │ 10 │ Deepak   │ -22.00       │ 22.00      │  (negative → positive)│
 * │   │ 11 │ Ananya   │ 18.50        │ 18.50      │  (positive stays)     │
 * │   │ 12 │ Tanya    │ -10.00       │ 10.00      │  (negative → positive)│
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
 * 
 * EXPLANATION:
 * - Negative numbers become positive (-12.25 → 12.25)
 * - Positive numbers stay positive (10.00 → 10.00)
 * - NULL stays NULL
 */

-- ============================================================================
-- 2.2 ABS() - Finding magnitude of change
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              ABS() - Finding Magnitude of Change                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find students with score change magnitude > 20 points         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name, score_change, ABS(score_change) AS magnitude       │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE ABS(score_change) > 20                                    │   │
 * │   │ ORDER BY magnitude DESC;                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬──────────────┬──────────┐                              │
 * │   │ name     │ score_change │ magnitude│                              │
 * │   ├──────────┼──────────────┼──────────┤                              │
 * │   │ Vikas    │ 120.75       │ 120.75   │  (largest change)           │
 * │   │ Rohan    │ -80.00       │ 80.00    │                              │
 * │   │ Neha     │ -30.75       │ 30.75    │                              │
 * │   │ Deepak   │ -22.00       │ 22.00    │                              │
 * │   └──────────┴──────────────┴──────────┘                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find students with score change magnitude greater than 20 points
SELECT 
    name, 
    score_change, 
    ABS(score_change) AS magnitude
FROM students
WHERE ABS(score_change) > 20
ORDER BY magnitude DESC;

/**
 * OUTPUT:
 * ┌──────────┬──────────────┬──────────┐
 * │ name     │ score_change │ magnitude│
 * ├──────────┼──────────────┼──────────┤
 * │ Vikas    │ 120.75       │ 120.75   │
 * │ Rohan    │ -80.00       │ 80.00    │
 * │ Neha     │ -30.75       │ 30.75    │
 * │ Deepak   │ -22.00       │ 22.00    │
 * └──────────┴──────────────┴──────────┘
 * 
 * EXPLANATION:
 * - ABS() allows us to find largest changes regardless of direction
 * - Vikas had biggest change (120.75 points UP)
 * - Rohan had second biggest (80.00 points DOWN)
 * - Both positive AND negative changes are considered
 */

-- ============================================================================
-- 2.3 ABS() - Calculating errors or gaps (distance from target)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              ABS() - Calculating Errors or Gaps                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Calculate gap between actual score and target score (50)      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT name, target_score, actual_score,                        │   │
 * │   │        (actual_score - target_score) AS raw_gap,                │   │
 * │   │        ABS(actual_score - target_score) AS absolute_gap         │   │
 * │   │ FROM students                                                   │   │
 * │   │ WHERE actual_score IS NOT NULL                                  │   │
 * │   │ ORDER BY absolute_gap DESC;                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬──────────────┬─────────────┬─────────┬───────────────┐ │
 * │   │ name     │ target_score │ actual_score│ raw_gap │ absolute_gap  │ │
 * │   ├──────────┼──────────────┼─────────────┼─────────┼───────────────┤ │
 * │   │ Pallavi  │ 50           │ 92          │ 42      │ 42            │ │
 * │   │ Arjun    │ 50           │ 72          │ 22      │ 22            │ │
 * │   │ Neha     │ 50           │ 10          │ -40     │ 40            │ │
 * │   │ Deepak   │ 50           │ 33          │ -17     │ 17            │ │
 * │   └──────────┴──────────────┴─────────────┴─────────┴───────────────┘ │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    name, 
    target_score, 
    actual_score,
    (actual_score - target_score) AS raw_gap,
    ABS(actual_score - target_score) AS absolute_gap
FROM students
WHERE actual_score IS NOT NULL
ORDER BY absolute_gap DESC;

/**
 * OUTPUT:
 * ┌──────────┬──────────────┬─────────────┬─────────┬───────────────┐
 * │ name     │ target_score │ actual_score│ raw_gap │ absolute_gap  │
 * ├──────────┼──────────────┼─────────────┼─────────┼───────────────┤
 * │ Pallavi  │ 50           │ 92          │ 42      │ 42            │
 * │ Neha     │ 50           │ 10          │ -40     │ 40            │
 * │ Arjun    │ 50           │ 72          │ 22      │ 22            │
 * │ Vikas    │ 50           │ 88          │ 38      │ 38            │
 * │ Ananya   │ 50           │ 78          │ 28      │ 28            │
 * │ Deepak   │ 50           │ 33          │ -17     │ 17            │
 * │ Sana     │ 50           │ 65          │ 15      │ 15            │
 * │ Aisha    │ 50           │ 55          │ 5       │ 5             │
 * │ Imran    │ 50           │ 50          │ 0       │ 0             │
 * │ Rohan    │ 50           │ 40          │ -10     │ 10            │
 * │ Tanya    │ 50           │ 45          │ -5      │ 5             │
 * └──────────┴──────────────┴─────────────┴─────────┴───────────────┘
 * 
 * EXPLANATION:
 * - raw_gap shows direction (positive = above target, negative = below target)
 * - absolute_gap shows distance from target regardless of direction
 * - Pallavi is 42 points ABOVE target
 * - Neha is 40 points BELOW target
 * - Both have large absolute gaps even though directions are opposite
 */

-- ============================================================================
-- 2.4 ABS() - Finding largest performance shifts (all students)
-- ============================================================================

SELECT 
    name, 
    score_change, 
    ABS(score_change) AS magnitude,
    CASE 
        WHEN score_change > 0 THEN 'Increase'
        WHEN score_change < 0 THEN 'Decrease'
        WHEN score_change = 0 THEN 'No Change'
        ELSE 'Unknown'
    END AS direction
FROM students
WHERE score_change IS NOT NULL
ORDER BY magnitude DESC;

/**
 * OUTPUT:
 * ┌──────────┬──────────────┬──────────┬───────────┐
 * │ name     │ score_change │ magnitude │ direction │
 * ├──────────┼──────────────┼──────────┼───────────┤
 * │ Vikas    │ 120.75       │ 120.75   │ Increase  │
 * │ Rohan    │ -80.00       │ 80.00    │ Decrease  │
 * │ Neha     │ -30.75       │ 30.75    │ Decrease  │
 * │ Deepak   │ -22.00       │ 22.00    │ Decrease  │
 * │ Ananya   │ 18.50        │ 18.50    │ Increase  │
 * │ Sana     │ -15.00       │ 15.00    │ Decrease  │
 * │ Aisha    │ -12.25       │ 12.25    │ Decrease  │
 * │ Tanya    │ -10.00       │ 10.00    │ Decrease  │
 * │ Arjun    │ 10.00        │ 10.00    │ Increase  │
 * │ Pallavi  │ 5.25         │ 5.25     │ Increase  │
 * │ Imran    │ -1.00        │ 1.00     │ Decrease  │
 * └──────────┴──────────────┴──────────┴───────────┘
 * 
 * EXPLANATION:
 * - Sorted by magnitude (absolute value) to find biggest changes
 * - Vikas had biggest increase (120.75)
 * - Rohan had biggest decrease (80.00)
 * - ABS() helps identify volatile students regardless of direction
 */

-- ============================================================================
-- PART 3: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting rounding rules                                  │
 * │                                                                          │
 * │   ❌ Assuming ROUND(2.5) = 2 (actually = 3)                            │
 * │   ❌ Assuming ROUND(2.4) = 3 (actually = 2)                            │
 * │                                                                          │
 * │   ✅ Remember: 0.5 and above rounds UP                                  │
 * │   ✅ Below 0.5 rounds DOWN                                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate rounding rules
SELECT 
    ROUND(2.4, 0) AS rounds_down,  -- 2
    ROUND(2.5, 0) AS rounds_up,    -- 3
    ROUND(2.6, 0) AS rounds_up_too; -- 3

/**
 * OUTPUT:
 * ┌─────────────┬───────────┬────────────────┐
 * │ rounds_down │ rounds_up │ rounds_up_too  │
 * ├─────────────┼───────────┼────────────────┤
 * │ 2           │ 3         │ 3              │
 * └─────────────┴───────────┴────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: ABS with NULL                                              │
 * │                                                                          │
 * │   ❌ Assuming ABS(NULL) = 0 (actually = NULL)                          │
 * │                                                                          │
 * │   ✅ Handle NULLs with COALESCE if needed:                              │
 * │      COALESCE(ABS(score_change), 0)                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate ABS with NULL
SELECT 
    score_change,
    ABS(score_change) AS abs_value
FROM students
WHERE id = 3;  -- Meenal has NULL score_change

/**
 * OUTPUT:
 * ┌──────────────┬───────────┐
 * │ score_change │ abs_value │
 * ├──────────────┼───────────┤
 * │ NULL         │ NULL      │
 * └──────────────┴───────────┘
 */

-- Handle NULL properly
SELECT 
    score_change,
    COALESCE(ABS(score_change), 0) AS abs_with_default
FROM students
WHERE id = 3;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┐
 * │ score_change │ abs_with_default│
 * ├──────────────┼─────────────────┤
 * │ NULL         │ 0               │
 * └──────────────┴─────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Rounding vs Truncating (Cutting off vs rounding)          │
 * │                                                                          │
 * │   ROUND changes the value (2.9 → 3)                                    │
 * │   TRUNCATE simply cuts off decimals (2.9 → 2)                          │
 * │                                                                          │
 * │   ✅ Use ROUND when you want proper rounding                            │
 * │   ✅ Use TRUNCATE or FLOOR when you just want to remove decimals       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    2.9 AS original,
    ROUND(2.9, 0) AS rounded,      -- 3
    TRUNC(2.9) AS truncated;        -- 2 (in PostgreSQL)

/**
 * OUTPUT:
 * ┌──────────┬─────────┬───────────┐
 * │ original │ rounded │ truncated │
 * ├──────────┼─────────┼───────────┤
 * │ 2.9      │ 3       │ 2         │
 * └──────────┴─────────┴───────────┘
 */

-- ============================================================================
-- PART 4: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ROUND() RULES:                                                         │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 1. 0.5 and above → rounds UP                                        ││
 * │ │ 2. Below 0.5 → rounds DOWN                                          ││
 * │ │ 3. Negative decimals round to tens (-1), hundreds (-2), etc.        ││
 * │ │ 4. Use ROUND for presentable financial reports                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ ABS() RULES:                                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 1. Negative numbers become positive                                 ││
 * │ │ 2. Positive numbers stay positive                                   ││
 * │ │ 3. NULL stays NULL                                                  ││
 * │ │ 4. Use ABS when you care about magnitude, not direction             ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ WHEN TO USE:                                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ ROUND() → Financial reports, presentable numbers, estimates        ││
 * │ │ ABS()   → Error margins, performance volatility, gap analysis      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 5: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ROUND() - Round numbers                                                 │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ ROUND(2804.45, 0)  → 2804    (round to integer)                    ││
 * │ │ ROUND(3717.94, 0)  → 3718    (round to integer)                    ││
 * │ │ ROUND(2804.45, 1)  → 2804.5  (round to 1 decimal)                  ││
 * │ │ ROUND(5099.00, -1) → 5100    (round to nearest ten)                ││
 * │ │ ROUND(7999.00, -2) → 8000    (round to nearest hundred)            ││
 * │ │ ROUND(2804.45, -3) → 3000    (round to nearest thousand)           ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ ABS() - Absolute value                                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ ABS(-12.25)  → 12.25    (negative becomes positive)                ││
 * │ │ ABS(10.00)   → 10.00    (positive stays positive)                  ││
 * │ │ ABS(0)       → 0        (zero stays zero)                          ││
 * │ │ ABS(NULL)    → NULL     (NULL stays NULL)                          ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Round fee to rupees                                             ││
 * │ │ ROUND(fee_paid, 0)                                                 ││
 * │ │                                                                     ││
 * │ │ -- Round to nearest hundred for estimates                          ││
 * │ │ ROUND(fee_paid, -2)                                                ││
 * │ │                                                                     ││
 * │ │ -- Find magnitude of change                                        ││
 * │ │ ABS(score_change)                                                  ││
 * │ │                                                                     ││
 * │ │ -- Find distance from target                                       ││
 * │ │ ABS(actual_score - target_score)                                   ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 6: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Round all fee_paid values to the nearest integer
 * 
 * Answer:
 *   SELECT id, name, ROUND(fee_paid, 0) FROM students;
 */

/**
 * EXERCISE 2: Round all fee_paid values to the nearest hundred
 * 
 * Answer:
 *   SELECT id, name, ROUND(fee_paid, -2) FROM students;
 */

/**
 * EXERCISE 3: Find absolute value of score_change for all students
 * 
 * Answer:
 *   SELECT id, name, ABS(score_change) FROM students;
 */

/**
 * EXERCISE 4: Find students whose score changed by more than 15 points
 * (regardless of direction)
 * 
 * Answer:
 *   SELECT name, score_change FROM students 
 *   WHERE ABS(score_change) > 15;
 */

/**
 * EXERCISE 5: Calculate how far each student is from a target score of 75
 * 
 * Answer:
 *   SELECT name, actual_score, ABS(actual_score - 75) AS distance_from_75
 *   FROM students WHERE actual_score IS NOT NULL;
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
 * │ ROUND():                                                               │
 * │ • Rounds numbers to specified decimal places                           │
 * │ • 0.5 and above rounds UP                                              │
 * │ • Below 0.5 rounds DOWN                                                │
 * │ • Negative decimals round to tens, hundreds, thousands                 │
 * │ • Use for presentable financial reports                                │
 * │                                                                          │
 * │ ABS():                                                                 │
 * │ • Returns absolute value (distance from zero)                          │
 * │ • Negative → Positive, Positive → Positive, NULL → NULL                │
 * │ • Use for magnitude of change (regardless of direction)                │
 * │ • Use for error/gap analysis                                           │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │ - ROUND(2.5) = 3 (not 2)                                              │
 * │ - ABS(NULL) = NULL (not 0)                                             │
 * │ - Use negative decimals for rounding to tens/hundreds                  │
 * │ - ABS helps find largest changes regardless of direction               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF ROUND AND ABS REVISION GUIDE
-- ============================================================================