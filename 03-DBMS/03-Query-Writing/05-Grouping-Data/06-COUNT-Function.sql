/**
 * ============================================================================
 * COUNT FUNCTION - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS COUNT? ------------------------ (Counting rows explained)
 * 2. COUNT(*) ------------------------------ (Count all rows)
 * 3. COUNT(column) ------------------------- (Count non-NULL values)
 * 4. COUNT(DISTINCT column) ---------------- (Count unique values)
 * 5. COUNT with GROUP BY ------------------- (Count per group)
 * 6. COUNT with WHERE ---------------------- (Count filtered rows)
 * 7. COUNT with HAVING --------------------- (Filter groups by count)
 * 8. COUNT with Multiple Columns ----------- (Comparing different counts)
 * 9. COUNT with CASE ----------------------- (Conditional counting)
 * 10. COUNT vs COUNT(DISTINCT) ------------- (Important differences)
 * 11. REAL-WORLD SCENARIOS ----------------- (Practical examples)
 * 12. COMMON MISTAKES ---------------------- (What to avoid)
 * 13. QUICK REFERENCE ---------------------- (Cheat sheet)
 * 14. GOLDEN RULES ------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLE FOR ALL EXAMPLES
-- ============================================================================

/**
 * REGISTRATIONS TABLE - Event registration data
 * 
 * ┌────────┬───────────┬────────────────────────┬───────────┬─────────────┬────────────┐
 * │ reg_id │ user_name │ email                  │ event     │ ticket_type │ referrer   │
 * ├────────┼───────────┼────────────────────────┼───────────┼─────────────┼────────────┤
 * │    1   │ Aisha     │ aisha@example.com      │ TechFest  │ Paid        │ Instagram  │
 * │    2   │ Rohan     │ rohan@example.com      │ TechFest  │ Free        │ NULL       │
 * │    3   │ Aisha     │ aisha@example.com      │ CodeCamp  │ Paid        │ Instagram  │
 * │    4   │ Mohit     │ NULL                   │ TechFest  │ Free        │ LinkedIn   │
 * │    5   │ Neha      │ neha@example.com       │ CodeCamp  │ Free        │ Instagram  │
 * │    6   │ NULL      │ unknown@example.com    │ DesignCon │ Paid        │ Twitter    │
 * │    7   │ Aisha     │ aisha@example.com      │ TechFest  │ Paid        │ Instagram  │
 * │    8   │ Vishal    │ NULL                   │ DesignCon │ Free        │ NULL       │
 * │    9   │ Rohan     │ rohan@example.com      │ TechFest  │ Free        │ Instagram  │
 * │   10   │ Aisha     │ aisha@example.com      │ CodeCamp  │ Paid        │ NULL       │
 * └────────┴───────────┴────────────────────────┴───────────┴─────────────┴────────────┘
 */

CREATE TABLE registrations (
    reg_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    email VARCHAR(100),
    event VARCHAR(20),
    ticket_type VARCHAR(10),
    referrer VARCHAR(20)
);

INSERT INTO registrations VALUES
(1, 'Aisha', 'aisha@example.com', 'TechFest', 'Paid', 'Instagram'),
(2, 'Rohan', 'rohan@example.com', 'TechFest', 'Free', NULL),
(3, 'Aisha', 'aisha@example.com', 'CodeCamp', 'Paid', 'Instagram'),
(4, 'Mohit', NULL, 'TechFest', 'Free', 'LinkedIn'),
(5, 'Neha', 'neha@example.com', 'CodeCamp', 'Free', 'Instagram'),
(6, NULL, 'unknown@example.com', 'DesignCon', 'Paid', 'Twitter'),
(7, 'Aisha', 'aisha@example.com', 'TechFest', 'Paid', 'Instagram'),
(8, 'Vishal', NULL, 'DesignCon', 'Free', NULL),
(9, 'Rohan', 'rohan@example.com', 'TechFest', 'Free', 'Instagram'),
(10, 'Aisha', 'aisha@example.com', 'CodeCamp', 'Paid', NULL);

-- ============================================================================
-- PART 1: WHAT IS COUNT?
-- ============================================================================

/**
 * COUNT is an aggregate function that counts rows.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS COUNT?                                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   COUNT() = Counts number of rows                                       │
 * │                                                                          │
 * │   THREE MAIN VARIATIONS:                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. COUNT(*)     → Counts ALL rows (including NULLs)            │   │
 * │   │ 2. COUNT(column)→ Counts rows where column is NOT NULL         │   │
 *   │   │ 3. COUNT(DISTINCT column) → Counts UNIQUE non-NULL values     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Class attendance sheet:                                         │   │
 * │   │                                                                  │   │
 * │   │ COUNT(*) = Total number of rows = 30 students                  │   │
 * │   │ COUNT(email) = Students who provided email = 25                │   │
 * │   │ COUNT(DISTINCT city) = Number of different cities = 8          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COUNT - SIMPLE EXAMPLE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   TABLE: registrations (10 rows total)                                  │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Rows 1-10: All rows                                             │   │
 * │   │                                                                  │   │
 * │   │ NULL values exist in:                                           │   │
 * │   │ - user_name: row 6 (NULL)                                       │   │
 * │   │ - email: rows 4 and 8 (NULL)                                    │   │
 * │   │ - referrer: rows 2, 8, 10 (NULL)                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   QUERY 1: COUNT(*)                                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(*) FROM registrations;                             │   │
 * │   │ Result: 10 (all rows counted)                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   QUERY 2: COUNT(email)                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(email) FROM registrations;                         │   │
 * │   │ Result: 8 (rows 4 and 8 have NULL email → excluded)            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   QUERY 3: COUNT(DISTINCT user_name)                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(DISTINCT user_name) FROM registrations;            │   │
 * │   │ Result: 5 (Aisha, Rohan, Mohit, Neha, Vishal)                  │   │
 * │   │        (NULL and duplicates removed)                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: COUNT(*) (Count all rows)
-- ============================================================================

/**
 * COUNT(*) counts EVERY row in the table, including NULL values.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COUNT(*) - All Rows                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(*) AS total_registrations                          │   │
 * │   │ FROM registrations;                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT: 10 rows (reg_id 1 to 10)                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Row 1:  ✓ count                                                │   │
 * │   │ Row 2:  ✓ count                                                │   │
 * │   │ Row 3:  ✓ count                                                │   │
 * │   │ Row 4:  ✓ count (even though email is NULL)                    │   │
 * │   │ Row 5:  ✓ count                                                │   │
 * │   │ Row 6:  ✓ count (even though user_name is NULL)                │   │
 * │   │ Row 7:  ✓ count                                                │   │
 * │   │ Row 8:  ✓ count (even though email is NULL)                    │   │
 * │   │ Row 9:  ✓ count                                                │   │
 * │   │ Row 10: ✓ count                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────────────┐                                             │
 * │   │ total_registrations │                                             │
 *   │   ├─────────────────────┤                                             │
 * │   │ 10                  │                                             │
 * │   └─────────────────────┘                                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT COUNT(*) AS total_registrations
FROM registrations;

/**
 * OUTPUT:
 * ┌─────────────────────┐
 * │ total_registrations │
 * ├─────────────────────┤
 * │ 10                  │
 * └─────────────────────┘
 * 
 * EXPLANATION:
 * - Counts ALL 10 rows in the table
 * - NULL values are INCLUDED in COUNT(*)
 * - This answers: "How many total registrations exist?"
 */

-- ============================================================================
-- PART 3: COUNT(column) (Count non-NULL values)
-- ============================================================================

/**
 * COUNT(column) counts only rows where the specified column is NOT NULL.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COUNT(column) - Non-NULL Values                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(email) AS emails_provided                          │   │
 * │   │ FROM registrations;                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Row 1: email = 'aisha@example.com'  → COUNT ✓                  │   │
 * │   │ Row 2: email = 'rohan@example.com'  → COUNT ✓                  │   │
 * │   │ Row 3: email = 'aisha@example.com'  → COUNT ✓                  │   │
 * │   │ Row 4: email = NULL                 → NOT COUNT ✗              │   │
 * │   │ Row 5: email = 'neha@example.com'   → COUNT ✓                  │   │
 * │   │ Row 6: email = 'unknown@example.com'→ COUNT ✓                  │   │
 * │   │ Row 7: email = 'aisha@example.com'  → COUNT ✓                  │   │
 * │   │ Row 8: email = NULL                 → NOT COUNT ✗              │   │
 * │   │ Row 9: email = 'rohan@example.com'  → COUNT ✓                  │   │
 * │   │ Row 10: email = 'aisha@example.com' → COUNT ✓                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────────┐                                                 │
 * │   │ emails_provided │                                                 │
 * │   ├─────────────────┤                                                 │
 * │   │ 8               │                                                 │
 * │   └─────────────────┘                                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    COUNT(email) AS emails_provided
FROM registrations;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ emails_provided │
 * ├─────────────────┤
 * │ 8               │
 * └─────────────────┘
 * 
 * EXPLANATION:
 * - Only counts rows where email IS NOT NULL
 * - Rows 4 (Mohit) and 8 (Vishal) have NULL email → excluded
 * - Total non-NULL emails = 8
 * - This answers: "How many users provided their email address?"
 */

-- Compare COUNT(*) vs COUNT(column)
SELECT 
    COUNT(*) AS total_rows,
    COUNT(email) AS emails_provided,
    COUNT(referrer) AS referrer_provided,
    COUNT(user_name) AS names_provided
FROM registrations;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────┬───────────────────┬────────────────┐
 * │ total_rows │ emails_provided │ referrer_provided │ names_provided │
 * ├────────────┼─────────────────┼───────────────────┼────────────────┤
 * │ 10         │ 8               │ 7                 │ 9              │
 * └────────────┴─────────────────┴───────────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - total_rows: 10 (all rows)
 * - emails_provided: 8 (rows 4 and 8 have NULL email)
 * - referrer_provided: 7 (rows 2, 8, 10 have NULL referrer)
 * - names_provided: 9 (row 6 has NULL user_name)
 */

-- ============================================================================
-- PART 4: COUNT(DISTINCT column) (Count unique values)
-- ============================================================================

/**
 * COUNT(DISTINCT column) counts unique non-NULL values in a column.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COUNT(DISTINCT) - Unique Values                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(DISTINCT user_name) AS unique_users               │   │
 * │   │ FROM registrations;                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT:                                                               │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ user_name values:                                                │   │
 * │   │ Row 1: Aisha                                                    │   │
 * │   │ Row 2: Rohan                                                    │   │
 * │   │ Row 3: Aisha (duplicate)                                        │   │
 * │   │ Row 4: Mohit                                                    │   │
 * │   │ Row 5: Neha                                                     │   │
 * │   │ Row 6: NULL (ignored)                                           │   │
 * │   │ Row 7: Aisha (duplicate)                                        │   │
 * │   │ Row 8: Vishal                                                   │   │
 * │   │ Row 9: Rohan (duplicate)                                        │   │
 * │   │ Row 10: Aisha (duplicate)                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   PROCESS:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Step 1: Remove duplicates → {Aisha, Rohan, Mohit, Neha, Vishal}│   │
 * │   │ Step 2: Remove NULL → (NULL already removed)                   │   │
 * │   │ Step 3: Count remaining → 5                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────────┐                                                    │
 * │   │ unique_users │                                                    │
 * │   ├──────────────┤                                                    │
 * │   │ 5            │                                                    │
 * │   └──────────────┘                                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    COUNT(DISTINCT user_name) AS unique_users
FROM registrations;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ unique_users │
 * ├──────────────┤
 * │ 5            │
 * └──────────────┘
 * 
 * EXPLANATION:
 * - DISTINCT removes duplicate user_names before counting
 * - Aisha appears 4 times → counted once
 * - Rohan appears 2 times → counted once
 * - NULL user_name (row 6) is ignored
 * - Unique users: Aisha, Rohan, Mohit, Neha, Vishal = 5
 */

-- Compare COUNT vs COUNT(DISTINCT)
SELECT 
    COUNT(user_name) AS total_names,
    COUNT(DISTINCT user_name) AS unique_names,
    COUNT(email) AS total_emails,
    COUNT(DISTINCT email) AS unique_emails
FROM registrations;

/**
 * OUTPUT:
 * ┌─────────────┬──────────────┬──────────────┬───────────────┐
 * │ total_names │ unique_names │ total_emails │ unique_emails │
 * ├─────────────┼──────────────┼──────────────┼───────────────┤
 * │ 9           │ 5            │ 8            │ 6             │
 * └─────────────┴──────────────┴──────────────┴───────────────┘
 * 
 * EXPLANATION:
 * - total_names: 9 (all non-NULL user_name)
 * - unique_names: 5 (Aisha, Rohan, Mohit, Neha, Vishal)
 * - total_emails: 8 (all non-NULL emails)
 * - unique_emails: 6 (aisha@example.com counted once, etc.)
 */

-- ============================================================================
-- PART 5: COUNT with GROUP BY (Count per group)
-- ============================================================================

/**
 * Use GROUP BY with COUNT to count rows in each group.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COUNT with GROUP BY                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT event, COUNT(*) AS registrations                        │   │
 * │   │ FROM registrations                                              │   │
 * │   │ GROUP BY event                                                  │   │
 * │   │ ORDER BY registrations DESC;                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Group rows by event                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ TECHFEST GROUP:          CODECAMP GROUP:      DESIGNCON GROUP:  │   │
 * │   │ Row 1 (Aisha)            Row 3 (Aisha)        Row 6 (NULL)      │   │
 * │   │ Row 2 (Rohan)            Row 5 (Neha)         Row 8 (Vishal)    │   │
 * │   │ Row 4 (Mohit)            Row 10 (Aisha)                         │   │
 * │   │ Row 7 (Aisha)                                                  │   │
 * │   │ Row 9 (Rohan)                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Count rows in each group                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ TechFest: 5 rows                                                │   │
 * │   │ CodeCamp: 3 rows                                                │   │
 * │   │ DesignCon: 2 rows                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────────┬──────────────┐                                        │
 * │   │ event     │ registrations │                                        │
 * │   ├───────────┼──────────────┤                                        │
 * │   │ TechFest  │ 5            │                                        │
 * │   │ CodeCamp  │ 3            │                                        │
 * │   │ DesignCon │ 2            │                                        │
 * │   └───────────┴──────────────┘                                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Registrations per event
SELECT 
    event,
    COUNT(*) AS registrations
FROM registrations
GROUP BY event
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌───────────┬──────────────┐
 * │ event     │ registrations │
 * ├───────────┼──────────────┤
 * │ TechFest  │ 5            │
 * │ CodeCamp  │ 3            │
 * │ DesignCon │ 2            │
 * └───────────┴──────────────┘
 * 
 * EXPLANATION:
 * - TechFest: rows 1,2,4,7,9 = 5 registrations
 * - CodeCamp: rows 3,5,10 = 3 registrations
 * - DesignCon: rows 6,8 = 2 registrations
 */

-- EXAMPLE 2: Registrations per ticket type
SELECT 
    ticket_type,
    COUNT(*) AS count,
    COUNT(DISTINCT user_name) AS unique_users
FROM registrations
GROUP BY ticket_type
ORDER BY count DESC;

/**
 * OUTPUT:
 * ┌─────────────┬───────┬──────────────┐
 * │ ticket_type │ count │ unique_users │
 * ├─────────────┼───────┼──────────────┤
 * │ Paid        │ 4     │ 2            │
 * │ Free        │ 6     │ 5            │
 * └─────────────┴───────┴──────────────┘
 * 
 * EXPLANATION:
 * - Paid tickets: rows 1,3,7,10 = 4 tickets (all by Aisha except one)
 * - Free tickets: rows 2,4,5,8,9 = 6 tickets
 */

-- EXAMPLE 3: Registrations per referrer
SELECT 
    referrer,
    COUNT(*) AS registrations,
    COUNT(DISTINCT user_name) AS unique_users
FROM registrations
WHERE referrer IS NOT NULL
GROUP BY referrer
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌───────────┬──────────────┬──────────────┐
 * │ referrer  │ registrations │ unique_users │
 * ├───────────┼──────────────┼──────────────┤
 * │ Instagram │ 5            │ 3            │
 * │ LinkedIn  │ 1            │ 1            │
 * │ Twitter   │ 1            │ 1            │
 * └───────────┴──────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - Instagram: rows 1,3,5,7,9 = 5 registrations
 * - LinkedIn: row 4 = 1 registration
 * - Twitter: row 6 = 1 registration
 * - NULL referrers (rows 2,8,10) excluded by WHERE
 */

-- ============================================================================
-- PART 6: COUNT with WHERE (Count filtered rows)
-- ============================================================================

/**
 * Use WHERE to count only rows that meet specific conditions.
 */

-- EXAMPLE 1: Count only Paid registrations
SELECT 
    COUNT(*) AS paid_registrations
FROM registrations
WHERE ticket_type = 'Paid';

/**
 * OUTPUT:
 * ┌────────────────────┐
 * │ paid_registrations │
 * ├────────────────────┤
 * │ 4                  │
 * └────────────────────┘
 * 
 * EXPLANATION:
 * - Only rows with ticket_type = 'Paid' are counted
 * - Paid tickets: rows 1,3,7,10 = 4
 */

-- EXAMPLE 2: Count registrations from Instagram referrer
SELECT 
    COUNT(*) AS instagram_registrations
FROM registrations
WHERE referrer = 'Instagram';

/**
 * OUTPUT:
 * ┌────────────────────────┐
 * │ instagram_registrations │
 * ├────────────────────────┤
 * │ 5                       │
 * └────────────────────────┘
 * 
 * EXPLANATION:
 * - Instagram referrer: rows 1,3,5,7,9 = 5
 */

-- EXAMPLE 3: Count registrations with email provided
SELECT 
    COUNT(*) AS with_email
FROM registrations
WHERE email IS NOT NULL;

/**
 * OUTPUT:
 * ┌────────────┐
 * │ with_email │
 * ├────────────┤
 * │ 8          │
 * └────────────┘
 */

-- ============================================================================
-- PART 7: COUNT with HAVING (Filter groups by count)
-- ============================================================================

/**
 * Use HAVING to filter groups after counting.
 */

-- EXAMPLE 1: Events with more than 3 registrations
SELECT 
    event,
    COUNT(*) AS registrations,
    COUNT(DISTINCT user_name) AS unique_users
FROM registrations
GROUP BY event
HAVING COUNT(*) > 3
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌──────────┬──────────────┬──────────────┐
 * │ event    │ registrations │ unique_users │
 * ├──────────┼──────────────┼──────────────┤
 * │ TechFest │ 5            │ 3            │
 * └──────────┴──────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - First: GROUP BY event and COUNT
 * - Then: HAVING keeps only events with >3 registrations
 * - TechFest: 5 ✓, CodeCamp: 3 ✗, DesignCon: 2 ✗
 */

-- EXAMPLE 2: Referrers with at least 2 registrations
SELECT 
    referrer,
    COUNT(*) AS registrations,
    COUNT(DISTINCT user_name) AS unique_users
FROM registrations
WHERE referrer IS NOT NULL
GROUP BY referrer
HAVING COUNT(*) >= 2
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌───────────┬──────────────┬──────────────┐
 * │ referrer  │ registrations │ unique_users │
 * ├───────────┼──────────────┼──────────────┤
 * │ Instagram │ 5            │ 3            │
 * └───────────┴──────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - Instagram has 5 registrations ≥ 2 → kept
 * - LinkedIn has 1 registration → excluded
 * - Twitter has 1 registration → excluded
 */

-- ============================================================================
-- PART 8: COUNT with Multiple Columns
-- ============================================================================

/**
 * Compare different counts in the same query.
 */

-- EXAMPLE: Compare total vs email-provided per event
SELECT 
    event,
    COUNT(*) AS total_regs,
    COUNT(email) AS with_email,
    COUNT(referrer) AS with_referrer,
    ROUND(COUNT(email) * 100.0 / COUNT(*), 1) AS email_completion_pct
FROM registrations
GROUP BY event
ORDER BY email_completion_pct DESC;

/**
 * OUTPUT:
 * ┌───────────┬────────────┬────────────┬───────────────┬──────────────────────┐
 * │ event     │ total_regs │ with_email │ with_referrer │ email_completion_pct │
 * ├───────────┼────────────┼────────────┼───────────────┼──────────────────────┤
 * │ CodeCamp  │ 3          │ 3          │ 2             │ 100.0                │
 * │ TechFest  │ 5          │ 4          │ 4             │ 80.0                 │
 * │ DesignCon │ 2          │ 1          │ 1             │ 50.0                 │
 * └───────────┴────────────┴────────────┴───────────────┴──────────────────────┘
 * 
 * EXPLANATION:
 * - CodeCamp: All 3 have email (100%)
 * - TechFest: 4 out of 5 have email (80%) - Mohit missing
 * - DesignCon: 1 out of 2 have email (50%) - Vishal missing
 */

-- ============================================================================
-- PART 9: COUNT with CASE (Conditional counting)
-- ============================================================================

/**
 * Use CASE inside COUNT to count rows that meet specific conditions.
 */

-- EXAMPLE 1: Count Paid and Free registrations per event
SELECT 
    event,
    COUNT(*) AS total,
    COUNT(CASE WHEN ticket_type = 'Paid' THEN 1 END) AS paid,
    COUNT(CASE WHEN ticket_type = 'Free' THEN 1 END) AS free
FROM registrations
GROUP BY event
ORDER BY event;

/**
 * OUTPUT:
 * ┌───────────┬───────┬──────┬──────┐
 * │ event     │ total │ paid │ free │
 * ├───────────┼───────┼──────┼──────┤
 * │ CodeCamp  │ 3     │ 2    │ 1    │
 * │ DesignCon │ 2     │ 1    │ 1    │
 * │ TechFest  │ 5     │ 2    │ 3    │
 * └───────────┴───────┴──────┴──────┘
 */

-- EXAMPLE 2: Count registrations by referrer source
SELECT 
    event,
    COUNT(*) AS total,
    COUNT(CASE WHEN referrer = 'Instagram' THEN 1 END) AS from_instagram,
    COUNT(CASE WHEN referrer = 'LinkedIn' THEN 1 END) AS from_linkedin,
    COUNT(CASE WHEN referrer = 'Twitter' THEN 1 END) AS from_twitter,
    COUNT(CASE WHEN referrer IS NULL THEN 1 END) AS no_referrer
FROM registrations
GROUP BY event
ORDER BY event;

/**
 * OUTPUT:
 * ┌───────────┬───────┬───────────────┬──────────────┬─────────────┬─────────────┐
 * │ event     │ total │ from_instagram │ from_linkedin │ from_twitter │ no_referrer │
 * ├───────────┼───────┼───────────────┼──────────────┼─────────────┼─────────────┤
 * │ CodeCamp  │ 3     │ 2             │ 0            │ 0           │ 1           │
 * │ DesignCon │ 2     │ 0             │ 0            │ 1           │ 1           │
 * │ TechFest  │ 5     │ 3             │ 1            │ 0           │ 1           │
 * └───────────┴───────┴───────────────┴──────────────┴─────────────┴─────────────┘
 */

-- ============================================================================
-- PART 10: COUNT vs COUNT(DISTINCT) (Important differences)
-- ============================================================================

/**
 * COUNT(column) vs COUNT(DISTINCT column)
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COUNT vs COUNT(DISTINCT)                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   COUNT(column)        → Number of non-NULL rows                       │
 * │   COUNT(DISTINCT col)  → Number of unique non-NULL values             │
 * │                                                                          │
 * │   EXAMPLE with user_name:                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Values: Aisha, Rohan, Aisha, Mohit, Neha, NULL, Aisha,         │   │
 *   │   │         Vishal, Rohan, Aisha                                   │   │
 * │   │                                                                  │   │
 * │   │ COUNT(user_name)        = 9 (all non-NULL)                      │   │
 * │   │ COUNT(DISTINCT user_name) = 5 (Aisha, Rohan, Mohit, Neha, Vishal)│   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate the difference
SELECT 
    COUNT(user_name) AS total_names,
    COUNT(DISTINCT user_name) AS unique_names,
    COUNT(email) AS total_emails,
    COUNT(DISTINCT email) AS unique_emails
FROM registrations;

/**
 * OUTPUT:
 * ┌─────────────┬──────────────┬──────────────┬───────────────┐
 * │ total_names │ unique_names │ total_emails │ unique_emails │
 * ├─────────────┼──────────────┼──────────────┼───────────────┤
 * │ 9           │ 5            │ 8            │ 6             │
 * └─────────────┴──────────────┴──────────────┴───────────────┘
 * 
 * EXPLANATION:
 * - total_names: 9 (all non-NULL user_name)
 * - unique_names: 5 (Aisha, Rohan, Mohit, Neha, Vishal)
 * - total_emails: 8 (all non-NULL emails)
 * - unique_emails: 6 (duplicate emails removed)
 */

-- ============================================================================
-- PART 11: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Event Popularity Report
 * 
 * Which event had the most registrations? Which had the most unique attendees?
 */

SELECT 
    event,
    COUNT(*) AS total_registrations,
    COUNT(DISTINCT user_name) AS unique_attendees,
    ROUND(COUNT(DISTINCT user_name) * 100.0 / COUNT(*), 1) AS unique_percentage,
    COUNT(CASE WHEN ticket_type = 'Paid' THEN 1 END) AS paid_tickets
FROM registrations
GROUP BY event
ORDER BY total_registrations DESC;

/**
 * OUTPUT:
 * ┌───────────┬─────────────────────┬─────────────────┬─────────────────────┬──────────────┐
 * │ event     │ total_registrations │ unique_attendees │ unique_percentage   │ paid_tickets │
 * ├───────────┼─────────────────────┼─────────────────┼─────────────────────┼──────────────┤
 * │ TechFest  │ 5                   │ 3               │ 60.0                │ 2            │
 * │ CodeCamp  │ 3                   │ 2               │ 66.7                │ 2            │
 * │ DesignCon │ 2                   │ 1               │ 50.0                │ 1            │
 * └───────────┴─────────────────────┴─────────────────┴─────────────────────┴──────────────┘
 */

/**
 * SCENARIO 2: Referral Source Analysis
 * 
 * Which marketing channel is bringing the most registrations?
 */

SELECT 
    COALESCE(referrer, 'Direct/Unknown') AS source,
    COUNT(*) AS registrations,
    COUNT(DISTINCT user_name) AS unique_users,
    COUNT(DISTINCT event) AS events_attended
FROM registrations
GROUP BY referrer
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌─────────────────┬──────────────┬──────────────┬──────────────────┐
 * │ source          │ registrations │ unique_users │ events_attended  │
 * ├─────────────────┼──────────────┼──────────────┼──────────────────┤
 * │ Instagram       │ 5            │ 3            │ 3                │
 * │ Direct/Unknown  │ 3            │ 2            │ 2                │
 * │ LinkedIn        │ 1            │ 1            │ 1                │
 * │ Twitter         │ 1            │ 1            │ 1                │
 * └─────────────────┴──────────────┴──────────────┴──────────────────┘
 */

/**
 * SCENARIO 3: Data Quality Report
 * 
 * Check how many registrations have missing information.
 */

SELECT 
    COUNT(*) AS total_registrations,
    COUNT(CASE WHEN user_name IS NULL THEN 1 END) AS missing_names,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS missing_emails,
    COUNT(CASE WHEN referrer IS NULL THEN 1 END) AS missing_referrers,
    ROUND(COUNT(CASE WHEN email IS NULL THEN 1 END) * 100.0 / COUNT(*), 1) AS email_missing_pct
FROM registrations;

/**
 * OUTPUT:
 * ┌─────────────────────┬───────────────┬────────────────┬───────────────────┬────────────────────┐
 * │ total_registrations │ missing_names │ missing_emails │ missing_referrers │ email_missing_pct  │
 * ├─────────────────────┼───────────────┼────────────────┼───────────────────┼────────────────────┤
 * │ 10                  │ 1             │ 2              │ 3                 │ 20.0               │
 * └─────────────────────┴───────────────┴────────────────┴───────────────────┴────────────────────┘
 */

/**
 * SCENARIO 4: Repeat Attendees
 * 
 * Find users who registered for multiple events.
 */

SELECT 
    user_name,
    COUNT(*) AS registrations,
    COUNT(DISTINCT event) AS events_count,
    STRING_AGG(DISTINCT event, ', ' ORDER BY event) AS events_list
FROM registrations
WHERE user_name IS NOT NULL
GROUP BY user_name
HAVING COUNT(DISTINCT event) > 1
ORDER BY registrations DESC;

/**
 * OUTPUT:
 * ┌───────────┬──────────────┬─────────────┬────────────────────────┐
 * │ user_name │ registrations │ events_count │ events_list            │
 * ├───────────┼──────────────┼─────────────┼────────────────────────┤
 * │ Aisha     │ 4            │ 2           │ CodeCamp, TechFest     │
 * │ Rohan     │ 2            │ 1           │ TechFest               │
 * └───────────┴──────────────┴─────────────┴────────────────────────┘
 * 
 * EXPLANATION:
 * - Aisha registered for both TechFest and CodeCamp (multiple events)
 * - Rohan registered twice but both for TechFest (same event)
 * - HAVING filters to users with >1 distinct events
 */

/**
 * SCENARIO 5: Event Performance Summary
 * 
 * Complete report card for each event.
 */

SELECT 
    event,
    COUNT(*) AS total_regs,
    COUNT(DISTINCT user_name) AS unique_attendees,
    ROUND(AVG(CASE WHEN ticket_type = 'Paid' THEN 1 ELSE 0 END) * 100, 1) AS paid_percentage,
    COUNT(CASE WHEN referrer = 'Instagram' THEN 1 END) AS instagram_regs,
    COUNT(CASE WHEN referrer IS NULL THEN 1 END) AS direct_regs
FROM registrations
GROUP BY event
ORDER BY total_regs DESC;

/**
 * OUTPUT:
 * ┌───────────┬────────────┬───────────────────┬─────────────────┬─────────────────┬─────────────┐
 * │ event     │ total_regs │ unique_attendees  │ paid_percentage │ instagram_regs  │ direct_regs │
 * ├───────────┼────────────┼───────────────────┼─────────────────┼─────────────────┼─────────────┤
 * │ TechFest  │ 5          │ 3                 │ 40.0            │ 3               │ 1           │
 * │ CodeCamp  │ 3          │ 2                 │ 66.7            │ 2               │ 1           │
 * │ DesignCon │ 2          │ 1                 │ 50.0            │ 0               │ 1           │
 * └───────────┴────────────┴───────────────────┴─────────────────┴─────────────────┴─────────────┘
 */

-- ============================================================================
-- PART 12: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Thinking COUNT(column) counts NULLs                        │
 * │                                                                          │
 * │   ❌ WRONG ASSUMPTION:                                                  │
 * │   COUNT(email) counts rows with NULL email as 0                        │
 * │                                                                          │
 * │   ✅ CORRECT UNDERSTANDING:                                             │
 * │   COUNT(email) only counts rows where email IS NOT NULL                │
 * │   NULL values are completely ignored                                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate the difference
SELECT 
    COUNT(*) AS all_rows,
    COUNT(email) AS email_count
FROM registrations;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┐
 * │ all_rows │ email_count │
 * ├──────────┼─────────────┤
 * │ 10       │ 8           │
 * └──────────┴─────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Confusing COUNT(*) with COUNT(1)                           │
 * │                                                                          │
 * │   COUNT(*) and COUNT(1) are the SAME!                                  │
 * │   Both count all rows.                                                 │
 * │   COUNT(1) doesn't mean "count where column = 1"                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    COUNT(*) AS count_star,
    COUNT(1) AS count_one,
    COUNT(100) AS count_hundred
FROM registrations;
-- All return the same value: 10

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using column alias in HAVING                               │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT event, COUNT(*) AS total                                      │
 * │   FROM registrations                                                   │
 * │   GROUP BY event                                                       │
 * │   HAVING total > 3;  ← ERROR! Cannot use alias in HAVING               │
 * │                                                                          │
 * │   ✅ CORRECT:                                                           │
 * │   SELECT event, COUNT(*) AS total                                      │
 * │   FROM registrations                                                   │
 * │   GROUP BY event                                                       │
 * │   HAVING COUNT(*) > 3;                                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 13: QUICK REFERENCE (Cheat sheet)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE - CHEAT SHEET                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ BASIC COUNT SYNTAX:                                                     │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ -- Count all rows                                                  │ │
 * │ │ SELECT COUNT(*) FROM table;                                        │ │
 * │ │                                                                     │ │
 * │ │ -- Count non-NULL values in column                                 │ │
 * │ │ SELECT COUNT(column) FROM table;                                   │ │
 * │ │                                                                     │ │
 * │ │ -- Count unique values                                             │ │
 * │ │ SELECT COUNT(DISTINCT column) FROM table;                          │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COUNT WITH GROUP BY:                                                    │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ SELECT group_column, COUNT(*)                                       │ │
 * │ │ FROM table                                                          │ │
 * │ │ GROUP BY group_column;                                              │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COUNT WITH WHERE:                                                       │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ SELECT COUNT(*) FROM table WHERE condition;                         │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COUNT WITH HAVING:                                                      │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ SELECT group_column, COUNT(*)                                       │ │
 * │ │ FROM table                                                          │ │
 * │ │ GROUP BY group_column                                               │ │
 * │ │ HAVING COUNT(*) > value;                                            │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ COUNT WITH CASE (Conditional counting):                                 │
 * │ ┌─────────────────────────────────────────────────────────────────────┐ │
 * │ │ SELECT COUNT(CASE WHEN condition THEN 1 END) FROM table;            │ │
 * │ └─────────────────────────────────────────────────────────────────────┘ │
 * │                                                                          │
 * │ QUICK REFERENCE TABLE:                                                  │
 * │ ┌───────────────────────────┬────────────────────────────────────────┐ │
 * │ │ COUNT(*)                  │ All rows (including NULLs)             │ │
 * │ ├───────────────────────────┼────────────────────────────────────────┤ │
 * │ │ COUNT(column)             │ Non-NULL rows in column                │ │
 * │ ├───────────────────────────┼────────────────────────────────────────┤ │
 * │ │ COUNT(DISTINCT column)    │ Unique non-NULL values                 │ │
 * │ └───────────────────────────┴────────────────────────────────────────┘ │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Count total number of registrations
 * 
 * Answer:
 *   SELECT COUNT(*) FROM registrations;
 */

/**
 * EXERCISE 2: Count how many users provided their name
 * 
 * Answer:
 *   SELECT COUNT(user_name) FROM registrations;
 */

/**
 * EXERCISE 3: Count how many unique events are there
 * 
 * Answer:
 *   SELECT COUNT(DISTINCT event) FROM registrations;
 */

/**
 * EXERCISE 4: Count registrations per event, only show events with >2 registrations
 * 
 * Answer:
 *   SELECT event, COUNT(*) AS reg_count
 *   FROM registrations
 *   GROUP BY event
 *   HAVING COUNT(*) > 2;
 */

/**
 * EXERCISE 5: Count how many registrations came from each referrer
 * 
 * Answer:
 *   SELECT referrer, COUNT(*) AS count
 *   FROM registrations
 *   WHERE referrer IS NOT NULL
 *   GROUP BY referrer;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS registrations;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. COUNT(*) = Counts ALL rows (including NULLs)                        │
 * │                                                                          │
 * │ 2. COUNT(column) = Counts only rows where column is NOT NULL           │
 * │                                                                          │
 * │ 3. COUNT(DISTINCT column) = Counts UNIQUE non-NULL values              │
 * │                                                                          │
 * │ 4. Use GROUP BY to count per group                                     │
 * │                                                                          │
 * │ 5. Use WHERE to filter rows BEFORE counting                            │
 * │                                                                          │
 * │ 6. Use HAVING to filter groups AFTER counting                          │
 * │                                                                          │
 * │ 7. Use CASE inside COUNT for conditional counting:                      │
 * │    COUNT(CASE WHEN condition THEN 1 END)                               │
 * │                                                                          │
 * │ 8. COUNT(1) is the SAME as COUNT(*)                                    │
 * │                                                                          │
 * │ 9. Common use cases:                                                    │
 * │    → Total number of records                                           │
 * │    → Number of completed forms (non-NULL fields)                       │
 * │    → Unique visitors, customers, products                              │
 * │    → Sales count per product                                           │
 * │    → Registrations per event                                           │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - COUNT(*) includes NULLs                                            │
 * │   - COUNT(column) excludes NULLs                                       │
 * │   - COUNT(DISTINCT) removes duplicates                                 │
 * │   - NULLs are ignored in all COUNT variations except COUNT(*)         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF COUNT FUNCTION GUIDE
-- ============================================================================