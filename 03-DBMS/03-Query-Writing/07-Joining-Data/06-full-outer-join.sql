-- ============================================================================
-- PART 6: FULL OUTER JOIN (All rows from both tables)
-- ============================================================================

/**
 * FULL OUTER JOIN returns ALL rows from BOTH tables.
 * If there is a match, it returns the matched rows.
 * If no match, missing side gets NULL.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                        FULL OUTER JOIN                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   INPUT - Students Table:           INPUT - Payments Table:             │
 * │   ┌────────────┬──────────┐        ┌────────────┬────────┐              │
 * │   │ student_id │ name     │        │ student_id │ amount │              │
 * │   ├────────────┼──────────┤        ├────────────┼────────┤              │
 * │   │    1       │ ASHA     │        │    1       │  500   │              │
 * │   │    2       │ RAVI     │        │    2       │  700   │              │
 * │   │    3       │ NEHA     │        │    4       │  800   │              │
 * │   │    NULL    │ RAJ      │        └────────────┴────────┘              │
 * │   └────────────┴──────────┘                                             │
 * │                                                                         │
 * │   FULL OUTER JOIN ON students.student_id = payments.student_id          │
 * │                                                                         │
 * │   OUTPUT - ALL rows from BOTH tables:                                   │
 * │   ┌────────────┬──────────┬────────┐                                    │
 * │   │ student_id │ name     │ amount │                                    │
 * │   ├────────────┼──────────┼────────┤                                    │
 * │   │    1       │ ASHA     │  500   │  ← MATCH (in both)                 │
 * │   │    2       │ RAVI     │  700   │  ← MATCH (in both)                 │
 * │   │    3       │ NEHA     │  NULL  │  ← ONLY in students                │
 * │   │    NULL    │ RAJ      │  NULL  │  ← ONLY in students (NULL ID)      │
 * │   │    4       │ NULL     │  800   │  ← ONLY in payments                │
 * │   └────────────┴──────────┴────────┘                                    │
 * │                                                                         │
 * │   ✅✅ ALL students appear (even without payments)                     │
 * │   ✅✅ ALL payments appear (even without students)                     │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Create temporary tables for FULL OUTER JOIN example
CREATE TEMP TABLE students (
    student_id INT,
    name VARCHAR(50)
);

CREATE TEMP TABLE payments (
    student_id INT,
    amount DECIMAL(10,2)
);

INSERT INTO students VALUES (1, 'ASHA'), (2, 'RAVI'), (3, 'NEHA'), (NULL, 'RAJ');
INSERT INTO payments VALUES (1, 500), (2, 700), (4, 800);

/**
 * FULL OUTER JOIN example
 * Note: PostgreSQL supports FULL OUTER JOIN directly
 */

SELECT
    COALESCE(s.student_id, p.student_id) AS student_id,
    s.name,
    p.amount
FROM students s
FULL OUTER JOIN payments p
    ON p.student_id = s.student_id
ORDER BY student_id;

/**
 * OUTPUT:
 * ┌────────────┬──────────┬────────┐
 * │ student_id │ name     │ amount │
 * ├────────────┼──────────┼────────┤
 * │    1       │ ASHA     │  500   │
 * │    2       │ RAVI     │  700   │
 * │    3       │ NEHA     │  NULL  │
 * │    NULL    │ RAJ      │  NULL  │
 * │    4       │ NULL     │  800   │
 * └────────────┴──────────┴────────┘
 * 
 * EXPLANATION:
 * - COALESCE takes first non-NULL value (shows student_id from either table)
 * - Student 1 and 2: in both tables → show both name and amount
 * - Student 3: only in students → shows name, amount NULL
 * - Student RAJ: only in students (NULL ID) → shows name, amount NULL
 * - Student 4: only in payments → shows amount, name NULL
 */

-- Clean up temp tables
DROP TABLE students;
DROP TABLE payments;

