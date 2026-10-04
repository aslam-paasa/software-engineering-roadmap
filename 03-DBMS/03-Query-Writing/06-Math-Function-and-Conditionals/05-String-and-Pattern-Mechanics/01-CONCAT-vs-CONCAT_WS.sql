/**
 * ============================================================================
 * CONCAT and CONCAT_WS - COMPLETE REVISION GUIDE
 * (String Concatenation, Collation, NULL Handling)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS COLLATION? ------------------------- (How SQL compares text)
 *    - 1.1 Collation flags (ai, as, ci, cs)
 * 
 * 2. CONCAT() FUNCTION -------------------------- (Basic string joining)
 *    - 2.1 The NULL trap
 *    - 2.2 Basic examples
 * 
 * 3. CONCAT_WS() FUNCTION ----------------------- (Join with separator)
 *    - 3.1 Skips NULL values automatically
 *    - 3.2 Cleaner than CONCAT
 * 
 * 4. REAL-WORLD SCENARIOS ----------------------- (Practical examples)
 *    - 4.1 Creating full name (The NULL trap)
 *    - 4.2 Using CONCAT_WS for reliable names
 *    - 4.3 Formatting mailing labels
 *    - 4.4 Building custom profile URLs
 * 
 * 5. CONCAT() vs CONCAT_WS() -------------------- (Comparison table)
 * 
 * 6. COMMON MISTAKES --------------------------- (What to avoid)
 * 
 * 7. GOLDEN RULES ------------------------------ (Key principles)
 * 
 * 8. QUICK REFERENCE CARD ---------------------- (Cheat sheet)
 * 
 * 9. PRACTICE EXERCISES ------------------------ (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT IS COLLATION?
-- ============================================================================

/**
 * Collation defines the rules for comparing and sorting strings.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS COLLATION?                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   COLLATION answers questions like:                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Is "Apple" equal to "apple"?                                  │   │
 * │   │ • Is "café" equal to "cafe"?                                    │   │
 * │   │ • Which comes first: "Zoo" or "apple"?                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   COLLATION FLAGS:                                                      │
 * │   ┌────────────┬─────────────────┬────────────────────────────────────┐│
 * │   │ Flag       │ Meaning         │ Example                            ││
 * │   ├────────────┼─────────────────┼────────────────────────────────────┤│
 * │   │ ai         │ Accent-Insensitive │ cafe = café (equal)             ││
 * │   │ as         │ Accent-Sensitive   │ cafe ≠ café (not equal)         ││
 * │   │ ci         │ Case-Insensitive   │ Apple = apple (equal)           ││
 * │   │ cs         │ Case-Sensitive     │ Apple ≠ apple (not equal)       ││
 * │   └────────────┴─────────────────┴────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: CONCAT() FUNCTION (Basic string joining)
-- ============================================================================

/**
 * CONCAT(string1, string2, ...) joins two or more strings together.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    CONCAT() - THE NULL TRAP                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   IMPORTANT RULE: If ANY argument is NULL → result is NULL             │
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT CONCAT(string1, string2, string3) AS result;             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ CONCAT('Hello', ' ', 'Raj')   → 'Hello Raj'                     │   │
 * │   │ CONCAT('Hello', NULL, 'Raj')  → NULL   (NULL trap!)             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Basic CONCAT example
SELECT CONCAT('Hello', ' ', 'Raj') AS basic_concat;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ basic_concat│
 * ├─────────────┤
 * │ Hello Raj   │
 * └─────────────┘
 */

-- The NULL trap - CONCAT with NULL returns NULL
SELECT CONCAT('Hello', NULL, 'Raj') AS concat_with_null;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ concat_with_null │
 * ├──────────────────┤
 * │ NULL             │
 * └──────────────────┘
 * 
 * EXPLANATION: Any NULL in CONCAT ruins the entire result!
 */

-- PostgreSQL uses || operator (same behavior)
SELECT 'Hello' || ' ' || 'Raj' AS basic_concat;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ basic_concat│
 * ├─────────────┤
 * │ Hello Raj   │
 * └─────────────┘
 */

SELECT 'Hello' || NULL || 'Raj' AS concat_with_null;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ concat_with_null │
 * ├──────────────────┤
 * │ NULL             │
 * └──────────────────┘
 */

-- ============================================================================
-- PART 3: CONCAT_WS() FUNCTION (Join with separator)
-- ============================================================================

/**
 * CONCAT_WS(separator, string1, string2, ...) joins strings with a separator.
 * WS = With Separator
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    CONCAT_WS() - SMART JOINING                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   TWO KEY FEATURES:                                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Separator defined ONCE at the beginning                      │   │
 * │   │ 2. Skips NULL values automatically (no NULL trap!)              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT CONCAT_WS(separator, string1, string2, string3);         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ CONCAT_WS(' ', 'Hello', NULL, 'Raj') → 'Hello Raj'              │   │
 * │   │ CONCAT_WS(', ', 'Apples', 'Oranges', NULL, 'Grapes')            │   │
 * │   │                               → 'Apples, Oranges, Grapes'        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- CONCAT_WS with space separator (skips NULL)
SELECT CONCAT_WS(' ', 'Hello', NULL, 'Raj') AS concat_ws_space;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ concat_ws_space │
 * ├─────────────────┤
 * │ Hello Raj       │
 * └─────────────────┘
 * 
 * EXPLANATION: NULL is skipped, separator only between real values
 */

-- CONCAT_WS with comma separator
SELECT CONCAT_WS(', ', 'Apples', 'Oranges', NULL, 'Grapes') AS concat_ws_comma;

/**
 * OUTPUT:
 * ┌───────────────────────────┐
 * │ concat_ws_comma           │
 * ├───────────────────────────┤
 * │ Apples, Oranges, Grapes   │
 * └───────────────────────────┘
 * 
 * EXPLANATION: NULL is completely ignored
 */

-- CONCAT_WS with dot separator and multiple NULLs
SELECT CONCAT_WS('. ', NULL, 'Hi', NULL, 'Raj', NULL) AS concat_ws_dot;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ concat_ws_dot │
 * ├───────────────┤
 * │ Hi. Raj       │
 * └───────────────┘
 * 
 * EXPLANATION: All NULLs skipped, separator only between real values
 */

-- ============================================================================
-- SOURCE TABLE: CUSTOMERS
-- ============================================================================

CREATE TABLE customers (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

INSERT INTO customers (id, first_name, middle_name, last_name, city, country) VALUES
(1, 'Raj', 'Kumar', 'Patel', 'Mumbai', 'India'),
(2, 'Neha', NULL, 'Gupta', 'Delhi', 'India'),
(3, 'Aayush', NULL, 'Sharma', NULL, 'India');

-- Display customers
SELECT id, first_name, middle_name, last_name, city, country FROM customers ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬────────────┬─────────────┬──────────┬────────┬─────────┐
 * │ id │ first_name │ middle_name │ last_name│ city   │ country │
 * ├────┼────────────┼─────────────┼──────────┼────────┼─────────┤
 * │ 1  │ Raj        │ Kumar       │ Patel    │ Mumbai │ India   │
 * │ 2  │ Neha       │ NULL        │ Gupta    │ Delhi  │ India   │
 * │ 3  │ Aayush     │ NULL        │ Sharma   │ NULL   │ India   │
 * └────┴────────────┴─────────────┴──────────┴────────┴─────────┘
 */

-- ============================================================================
-- PART 4: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Creating Full Name (The NULL Trap)
 * 
 * Problem: Using CONCAT fails when middle_name is NULL
 */

SELECT 
    id, 
    CONCAT(first_name, ' ', middle_name, ' ', last_name) AS full_name
FROM customers;

/**
 * OUTPUT:
 * ┌────┬───────────┐
 * │ id │ full_name │
 * ├────┼───────────┤
 * │ 1  │ Raj Kumar Patel │
 * │ 2  │ NULL      │  ← NULL trap! middle_name is NULL
 * │ 3  │ NULL      │  ← NULL trap! middle_name is NULL
 * └────┴───────────┘
 * 
 * EXPLANATION: Because Neha and Aayush have NULL middle names,
 *              CONCAT returns NULL for their entire names.
 *              This is NOT what you want in a report.
 */

/**
 * SCENARIO 2: Using CONCAT_WS for Reliable Names
 * 
 * Solution: CONCAT_WS ignores NULLs automatically
 */

SELECT 
    id, 
    CONCAT_WS(' ', first_name, middle_name, last_name) AS full_name
FROM customers;

/**
 * OUTPUT:
 * ┌────┬─────────────────┐
 * │ id │ full_name       │
 * ├────┼─────────────────┤
 * │ 1  │ Raj Kumar Patel │
 * │ 2  │ Neha Gupta      │
 * │ 3  │ Aayush Sharma   │
 * └────┴─────────────────┘
 * 
 * EXPLANATION: CONCAT_WS ignored the NULL middle_names and
 *              joined the remaining parts perfectly.
 */

/**
 * SCENARIO 3: Formatting Mailing Labels
 * 
 * Create location string: City - Country
 * If city is missing, just show country
 */

SELECT 
    id, 
    CONCAT_WS(' - ', city, country) AS mailing_label
FROM customers;

/**
 * OUTPUT:
 * ┌────┬─────────────────┐
 * │ id │ mailing_label   │
 * ├────┼─────────────────┤
 * │ 1  │ Mumbai - India  │
 * │ 2  │ Delhi - India   │
 * │ 3  │ India           │
 * └────┴─────────────────┘
 * 
 * EXPLANATION: For Aayush (city is NULL), the hyphen is NOT included
 *              because there's only one valid piece of data.
 *              This makes the output much cleaner!
 */

/**
 * SCENARIO 4: Building Custom Profile URLs
 * 
 * Build URL: https://tuf.com/user/id
 */

SELECT 
    first_name,
    CONCAT('https://tuf.com/user/', id) AS profile_url
FROM customers;

/**
 * OUTPUT:
 * ┌────────────┬────────────────────────────┐
 * │ first_name │ profile_url                │
 * ├────────────┼────────────────────────────┤
 * │ Raj        │ https://tuf.com/user/1     │
 * │ Neha       │ https://tuf.com/user/2     │
 * │ Aayush     │ https://tuf.com/user/3     │
 * └────────────┴────────────────────────────┘
 * 
 * EXPLANATION: Numbers are automatically converted to strings
 */

-- ============================================================================
-- PART 5: CONCAT() vs CONCAT_WS() - COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CONCAT() vs CONCAT_WS()                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────┬────────────────────────┬───────────────────────┐ │
 * │ │ Feature            │ CONCAT()               │ CONCAT_WS()           │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Separator         │ Must add manually      │ Defined once at start │ │
 * │ │                   │ each time              │                       │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ NULL handling     │ Returns NULL if any    │ Skips NULL values     │ │
 * │ │                   │ argument is NULL       │ automatically         │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Number of args    │ 2 or more              │ 3 or more (sep +      │ │
 * │ │                   │                        │ at least 2 strings)   │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Use when          │ No NULLs possible      │ NULLs may exist       │ │
 * │ │                   │ Simple joins           │ Complex joins         │ │
 * └────────────────────┴────────────────────────┴───────────────────────┘ │
 *                                                                          │
 *   VISUAL EXAMPLE:                                                        │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ CONCAT('Hello', NULL, 'World')  →  NULL                            ││
 *   │                                                                     ││
 *   │ CONCAT_WS(' ', 'Hello', NULL, 'World')  →  'Hello World'           ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate the difference side by side
SELECT 
    CONCAT('Hello', NULL, 'World') AS concat_result,
    CONCAT_WS(' ', 'Hello', NULL, 'World') AS concat_ws_result;

/**
 * OUTPUT:
 * ┌───────────────┬──────────────────┐
 * │ concat_result │ concat_ws_result │
 * ├───────────────┼──────────────────┤
 * │ NULL          │ Hello World      │
 * └───────────────┴──────────────────┘
 */

-- ============================================================================
-- PART 6: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting spaces in CONCAT                                │
 * │                                                                          │
 * │   ❌ CONCAT(first_name, last_name) → 'RajPatel'                        │
 * │   ✅ CONCAT(first_name, ' ', last_name) → 'Raj Patel'                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong - No space
SELECT CONCAT('Raj', 'Patel') AS no_space;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ no_space │
 * ├──────────┤
 * │ RajPatel │
 * └──────────┘
 */

-- ✅ Correct - With space
SELECT CONCAT('Raj', ' ', 'Patel') AS with_space;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ with_space│
 * ├───────────┤
 * │ Raj Patel │
 * └───────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Wrong argument order in CONCAT_WS                          │
 * │                                                                          │
 * │   ❌ CONCAT_WS('Raj', 'Patel', ' ') → Separator is 'Raj'!               │
 * │      Result: 'Patel  '                                                │
 * │                                                                          │
 *   │   ✅ CONCAT_WS(' ', 'Raj', 'Patel') → Correct                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong order (first argument is separator)
SELECT CONCAT_WS('Raj', 'Patel', ' ') AS wrong_order;

/**
 * OUTPUT:
 * ┌────────────┐
 * │ wrong_order│
 * ├────────────┤
 * │ Patel  Raj │
 * └────────────┘
 * 
 * EXPLANATION: 'Raj' became the separator, not part of the text!
 */

-- ✅ Correct order
SELECT CONCAT_WS(' ', 'Raj', 'Patel') AS correct_order;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ correct_order │
 * ├───────────────┤
 * │ Raj Patel     │
 * └───────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Assuming CONCAT_WS adds separator even with single value   │
 * │                                                                          │
 * │   CONCAT_WS(' - ', 'India') → 'India' (no separator)                   │
 * │   (This is actually correct behavior - no extra separator)             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- This is correct - no extra separator
SELECT CONCAT_WS(' - ', 'India') AS single_value;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ single_value│
 * ├─────────────┤
 * │ India       │
 * └─────────────┘
 * 
 * EXPLANATION: Separator is only added BETWEEN values
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Mixing numbers and text without conversion                 │
 * │                                                                          │
 * │   Most modern databases auto-convert numbers to strings                │
 * │   But some strict databases may require CAST()                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Auto-conversion works in most databases
SELECT CONCAT('User ID: ', 123) AS auto_convert;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ auto_convert │
 * ├──────────────┤
 * │ User ID: 123 │
 * └──────────────┘
 */

-- ============================================================================
-- PART 7: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Use CONCAT_WS when NULLs might exist                           │
 * │         → CONCAT_WS skips NULLs automatically                          │
 * │         → CONCAT returns NULL if any argument is NULL                  │
 * │                                                                          │
 * │ RULE 2: In CONCAT_WS, FIRST argument is ALWAYS the separator           │
 * │         → CONCAT_WS(' ', 'Hello', 'World')                            │
 * │         → NOT: CONCAT_WS('Hello', ' ', 'World')                        │
 * │                                                                          │
 * │ RULE 3: Always add spaces manually in CONCAT                           │
 * │         → CONCAT(first, ' ', last)                                     │
 * │         → NOT: CONCAT(first, last)                                     │
 * │                                                                          │
 * │ RULE 4: CONCAT_WS only adds separator BETWEEN values                   │
 * │         → No trailing separator                                        │
 * │         → No leading separator                                         │
 * │                                                                          │
 * │ RULE 5: Understand your collation                                      │
 * │         → Case-sensitive vs case-insensitive                           │
 * │         → Accent-sensitive vs accent-insensitive                       │
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
 * │ CONCAT():                                                              │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CONCAT('Hello', ' ', 'World')  → Hello World                       ││
 * │ │ CONCAT('Hello', NULL, 'World') → NULL (NULL trap!)                 ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ CONCAT_WS():                                                           │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CONCAT_WS(' ', 'Hello', NULL, 'World') → Hello World               ││
 * │ │ CONCAT_WS(', ', 'A', 'B', NULL, 'C')   → A, B, C                   ││
 * │ │ CONCAT_WS(' - ', 'India')               → India                     ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ PostgreSQL Operators:                                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ 'Hello' || ' ' || 'World' → Hello World                            ││
 * │ │ 'Hello' || NULL || 'World' → NULL                                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COLLATION FLAGS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ ai = Accent-Insensitive (cafe = café)                              ││
 * │ │ as = Accent-Sensitive   (cafe ≠ café)                              ││
 * │ │ ci = Case-Insensitive   (Apple = apple)                            ││
 * │ │ cs = Case-Sensitive     (Apple ≠ apple)                            ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Full name with CONCAT_WS (safe)                                 ││
 * │ │ CONCAT_WS(' ', first_name, middle_name, last_name)                 ││
 * │ │                                                                     ││
 * │ │ -- Full name with CONCAT (risky)                                   ││
 * │ │ CONCAT(first_name, ' ', middle_name, ' ', last_name)               ││
 * │ │                                                                     ││
 * │ │ -- Location with optional city                                     ││
 * │ │ CONCAT_WS(' - ', city, country)                                    ││
 * │ │                                                                     ││
 * │ │ -- URL from ID                                                     ││
 * │ │ CONCAT('https://site.com/user/', user_id)                          ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 9: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Create full name using CONCAT_WS for customers
 * 
 * Answer:
 *   SELECT CONCAT_WS(' ', first_name, middle_name, last_name) FROM customers;
 */

/**
 * EXERCISE 2: Create address line from city, state, country (skip NULLs)
 * 
 * Answer:
 *   SELECT CONCAT_WS(', ', city, state, country) FROM addresses;
 */

/**
 * EXERCISE 3: Create a greeting message: 'Hello, Raj!'
 * 
 * Answer:
 *   SELECT CONCAT('Hello, ', first_name, '!') FROM customers;
 */

/**
 * EXERCISE 4: Build a product code: category + '-' + id
 * 
 * Answer:
 *   SELECT CONCAT(category, '-', id) FROM products;
 */

/**
 * EXERCISE 5: Create a comma-separated list of items (skip NULLs)
 * 
 * Answer:
 *   SELECT CONCAT_WS(', ', item1, item2, item3) FROM items;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. COLLATION = Rules for comparing/sorting strings                     │
 * │    → ai = accent-insensitive, as = accent-sensitive                    │
 * │    → ci = case-insensitive, cs = case-sensitive                        │
 * │                                                                          │
 * │ 2. CONCAT() = Basic string joining                                     │
 * │    → Returns NULL if ANY argument is NULL (NULL trap)                  │
 * │    → Must add spaces manually                                          │
 * │                                                                          │
 * │ 3. CONCAT_WS() = Join with separator                                   │
 * │    → First argument is the separator                                   │
 * │    → Skips NULL values automatically                                   │
 * │    → Much safer when NULLs may exist                                   │
 * │                                                                          │
 * │ 4. Use CONCAT_WS when:                                                 │
 * │    → You have NULL values in your data                                 │
 * │    → You want clean output without NULLs                               │
 * │    → You need consistent separator                                     │
 * │                                                                          │
 * │ 5. Use CONCAT when:                                                    │
 * │    → You are sure no NULL values exist                                 │
 * │    → You need full control over formatting                             │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - CONCAT_WS skips NULLs, CONCAT doesn't                              │
 * │   - In CONCAT_WS, separator comes FIRST                                │
 * │   - Always add spaces manually in CONCAT                               │
 * │   - Numbers auto-convert to strings                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF CONCAT AND CONCAT_WS REVISION GUIDE
-- ============================================================================