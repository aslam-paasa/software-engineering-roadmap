/**
 * ============================================================================
 * LOCATE and INSTR (POSITION and STRPOS) - COMPLETE REVISION GUIDE
 * (Finding substring positions, 1-based indexing)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE LOCATE and INSTR? ------------------- (Finding substring position)
 *    - 1.1 Basic syntax and examples
 *    - 1.2 1-based indexing (returns 0 if not found)
 * 
 * 2. REAL-WORLD SCENARIOS ------------------------- (Practical examples)
 *    - 2.1 Identifying email symbols (find '@')
 *    - 2.2 Finding separators in codes (find '_')
 *    - 2.3 Locating the end of a username (find '.')
 *    - 2.4 Checking for prohibited characters (find ' ')
 *    - 2.5 Advanced search (finding second occurrence)
 * 
 * 3. LOCATE() vs INSTR() vs POSITION() ------------ (Syntax differences)
 * 
 * 4. COMMON MISTAKES ------------------------------ (What to avoid)
 * 
 * 5. GOLDEN RULES --------------------------------- (Key principles)
 * 
 * 6. QUICK REFERENCE CARD ------------------------- (Cheat sheet)
 * 
 * 7. PRACTICE EXERCISES --------------------------- (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT ARE LOCATE and INSTR?
-- ============================================================================

/**
 * These functions find the position of a substring within a string.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LOCATE and INSTR - EXPLANATION                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX (different databases):                                        │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ PostgreSQL: POSITION('substr' IN 'string')                      │   │
 * │   │ PostgreSQL: STRPOS('string', 'substr')                          │   │
 * │   │ MySQL:      LOCATE('substr', 'string')                          │   │
 * │   │ MySQL:      INSTR('string', 'substr')                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  IMPORTANT: Returns 0 if NOT found (not NULL)                     │
 * │   ⚠️  SQL uses 1-based indexing (first character = position 1)         │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ POSITION('@' IN 'Raj@gmail.com')  → 4                          │   │
 * │   │ STRPOS('Raj@gmail.com', '@')      → 4                          │   │
 *   │   │ POSITION('7' IN 'Raj@gmail.com')   → 0  (not found)            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- PostgreSQL syntax examples
SELECT POSITION('@' IN 'Raj@gmail.com') AS position_of_at;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ position_of_at  │
 * ├─────────────────┤
 * │ 4               │
 * └─────────────────┘
 * 
 * EXPLANATION: '@' is at position 4 (R=1, a=2, j=3, @=4)
 */

SELECT STRPOS('Raj@gmail.com', '@') AS strpos_example;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ strpos_example  │
 * ├─────────────────┤
 * │ 4               │
 * └─────────────────┘
 */

-- Character not found returns 0
SELECT POSITION('7' IN 'Raj@gmail.com') AS not_found;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ not_found │
 * ├───────────┤
 * │ 0         │
 * └───────────┘
 * 
 * EXPLANATION: '7' does not exist, returns 0 (not NULL)
 */

-- MySQL syntax examples (for reference)
-- SELECT LOCATE('@', 'Raj@gmail.com') AS locate_example;
-- SELECT INSTR('Raj@gmail.com', '@') AS instr_example;

-- ============================================================================
-- 1.2 1-based Indexing (Important Rule!)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              1-BASED INDEXING - VISUAL GUIDE                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   String: "Raj@gmail.com"                                               │
 * │                                                                          │
 * │   ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐  │
 * │   │ R   │ a   │ j   │ @   │ g   │ m   │ a   │ i   │ l   │ .   │ c   │  │
 * │   │     │     │     │     │     │     │     │     │     │     │ o   │  │
 * │   │     │     │     │     │     │     │     │     │     │     │ m   │  │
 * │   └─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘  │
 * │   1     2     3     4     5     6     7     8     9     10    11    12 │
 * │                                                                          │
 * │   POSITION('@') = 4 (not 3!)                                           │
 * │   POSITION('g') = 5                                                     │
 * │   POSITION('com') = 10                                                  │
 * │   POSITION('xyz') = 0 (not found)                                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate positions
SELECT 
    POSITION('R' IN 'Raj@gmail.com') AS pos_R,
    POSITION('a' IN 'Raj@gmail.com') AS pos_a,
    POSITION('j' IN 'Raj@gmail.com') AS pos_j,
    POSITION('@' IN 'Raj@gmail.com') AS pos_at,
    POSITION('g' IN 'Raj@gmail.com') AS pos_g,
    POSITION('com' IN 'Raj@gmail.com') AS pos_com;

/**
 * OUTPUT:
 * ┌───────┬───────┬───────┬────────┬───────┬─────────┐
 * │ pos_R │ pos_a │ pos_j │ pos_at │ pos_g │ pos_com │
 * ├───────┼───────┼───────┼────────┼───────┼─────────┤
 * │ 1     │ 2     │ 3     │ 4      │ 5     │ 10      │
 * └───────┴───────┴───────┴────────┴───────┴─────────┘
 */

-- ============================================================================
-- SOURCE TABLE: USER_DIRECTORY
-- ============================================================================

CREATE TABLE user_directory (
    id INT PRIMARY KEY,
    email_address VARCHAR(100),
    full_name VARCHAR(100),
    job_code VARCHAR(50)
);

INSERT INTO user_directory (id, email_address, full_name, job_code) VALUES
(1, 'raj.patel@gmail.com', 'Raj Patel', 'ENG_LEVEL1'),
(2, 'neha_99@outlook.com', 'Neha Gupta', 'MKT_LEAD'),
(3, 'aayush#test.com', 'Aayush Sharma', 'HR_EXEC'),
(4, 'support@tuf.com', 'Support Team', 'OPS_MGR'),
(5, 'invalid email', 'Unknown', 'TEMP');

-- Display data
SELECT id, email_address, full_name, job_code FROM user_directory ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┬───────────────┬───────────┐
 * │ id │ email_address       │ full_name     │ job_code  │
 * ├────┼─────────────────────┼───────────────┼───────────┤
 * │ 1  │ raj.patel@gmail.com │ Raj Patel     │ ENG_LEVEL1│
 * │ 2  │ neha_99@outlook.com │ Neha Gupta    │ MKT_LEAD  │
 * │ 3  │ aayush#test.com     │ Aayush Sharma │ HR_EXEC   │
 * │ 4  │ support@tuf.com     │ Support Team  │ OPS_MGR   │
 * │ 5  │ invalid email       │ Unknown       │ TEMP      │
 * └────┴─────────────────────┴───────────────┴───────────┘
 */

-- ============================================================================
-- PART 2: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Identifying Email Symbols (Find '@')
 * 
 * Find position of '@' symbol in emails to identify valid/invalid records
 */

SELECT 
    id,
    email_address, 
    POSITION('@' IN email_address) AS at_symbol_pos
FROM user_directory;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┬───────────────┐
 * │ id │ email_address       │ at_symbol_pos │
 * ├────┼─────────────────────┼───────────────┤
 * │ 1  │ raj.patel@gmail.com │ 10            │
 * │ 2  │ neha_99@outlook.com │ 8             │
 * │ 3  │ aayush#test.com     │ 0             │
 * │ 4  │ support@tuf.com     │ 8             │
 * │ 5  │ invalid email       │ 0             │
 * └────┴─────────────────────┴───────────────┘
 * 
 * EXPLANATION: 
 * - 0 means '@' not found (invalid email format for IDs 3 and 5)
 * - Valid emails have position > 0
 */

-- Find only invalid emails
SELECT id, email_address
FROM user_directory
WHERE POSITION('@' IN email_address) = 0;

/**
 * OUTPUT:
 * ┌────┬─────────────────┐
 * │ id │ email_address   │
 * ├────┼─────────────────┤
 * │ 3  │ aayush#test.com │
 * │ 5  │ invalid email   │
 * └────┴─────────────────┘
 */

/**
 * SCENARIO 2: Finding Separators in Codes (Find '_')
 * 
 * Every job code has underscore separating department from level
 */

SELECT 
    id,
    job_code, 
    POSITION('_' IN job_code) AS separator_pos
FROM user_directory;

/**
 * OUTPUT:
 * ┌────┬───────────┬───────────────┐
 * │ id │ job_code  │ separator_pos │
 * ├────┼───────────┼───────────────┤
 * │ 1  │ ENG_LEVEL1│ 4             │
 * │ 2  │ MKT_LEAD  │ 4             │
 * │ 3  │ HR_EXEC   │ 3             │
 * │ 4  │ OPS_MGR   │ 4             │
 * │ 5  │ TEMP      │ 0             │
 * └────┴───────────┴───────────────┘
 * 
 * EXPLANATION: 
 * - TEMP has no underscore (position 0)
 * - HR_EXEC has underscore at position 3 (H=1, R=2, _=3)
 */

/**
 * SCENARIO 3: Locating the End of a Username (Find '.')
 * 
 * Find position of first dot in email address
 */

SELECT 
    id,
    email_address, 
    POSITION('.' IN email_address) AS dot_pos
FROM user_directory;

/**
 * OUTPUT:
 * ┌────┬─────────────────────┬─────────┐
 * │ id │ email_address       │ dot_pos │
 * ├────┼─────────────────────┼─────────┤
 * │ 1  │ raj.patel@gmail.com │ 4       │
 * │ 2  │ neha_99@outlook.com │ 0       │
 * │ 3  │ aayush#test.com     │ 0       │
 * │ 4  │ support@tuf.com     │ 0       │
 * │ 5  │ invalid email       │ 0       │
 * └────┴─────────────────────┴─────────┘
 * 
 * EXPLANATION: Only 'raj.patel@gmail.com' has a dot (at position 4)
 */

/**
 * SCENARIO 4: Checking for Prohibited Characters (Find ' ')
 * 
 * Email addresses should not contain spaces
 * Find rows where space exists in email
 */

SELECT 
    id,
    email_address, 
    POSITION(' ' IN email_address) AS space_found_at
FROM user_directory
WHERE POSITION(' ' IN email_address) > 0;

/**
 * OUTPUT:
 * ┌────┬─────────────────┬───────────────┐
 * │ id │ email_address   │ space_found_at│
 * ├────┼─────────────────┼───────────────┤
 * │ 5  │ invalid email   │ 8             │
 * └────┴─────────────────┴───────────────┘
 * 
 * EXPLANATION: Only row 5 has a space (at position 8)
 */

/**
 * SCENARIO 5: Advanced Search (Finding Second Occurrence)
 * 
 * Find position of the second dot in 'raj.patel@gmail.com'
 * First dot is at position 4, second dot is after 'patel'
 */

-- Using SUBSTRING to find second occurrence
SELECT 
    email_address,
    POSITION('.' IN email_address) AS first_dot,
    POSITION('.' IN SUBSTRING(email_address, 5)) + 4 AS second_dot
FROM user_directory
WHERE id = 1;

/**
 * OUTPUT:
 * ┌─────────────────────┬───────────┬────────────┐
 * │ email_address       │ first_dot │ second_dot │
 * ├─────────────────────┼───────────┼────────────┤
 * │ raj.patel@gmail.com │ 4         │ 10         │
 * └─────────────────────┴───────────┴────────────┘
 * 
 * EXPLANATION:
 * - First dot at position 4 (after 'raj')
 * - Second dot: search in substring starting after first dot
 *   SUBSTRING from position 5 = 'patel@gmail.com'
 *   Dot in this substring is at position 6
 *   Add 4 = position 10 in original string
 */

-- Alternative: Using STRPOS with substring
SELECT 
    email_address,
    STRPOS(email_address, '.') AS first_dot,
    STRPOS(SUBSTRING(email_address, 5), '.') + 4 AS second_dot
FROM user_directory
WHERE id = 1;

/**
 * OUTPUT:
 * ┌─────────────────────┬───────────┬────────────┐
 * │ email_address       │ first_dot │ second_dot │
 * ├─────────────────────┼───────────┼────────────┤
 * │ raj.patel@gmail.com │ 4         │ 10         │
 * └─────────────────────┴───────────┴────────────┘
 */

-- ============================================================================
-- PART 3: LOCATE() vs INSTR() vs POSITION() - COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LOCATE vs INSTR vs POSITION - COMPARISON                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────┬────────────────────────┬───────────────────────┐ │
 * │ │ Database           │ Function               │ Syntax                │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ PostgreSQL        │ POSITION()             │ POSITION('@' IN email)│ │
 * │ │ PostgreSQL        │ STRPOS()               │ STRPOS(email, '@')    │ │
 * │ ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ MySQL              │ LOCATE()               │ LOCATE('@', email)    │ │
 * │ │ MySQL              │ INSTR()                │ INSTR(email, '@')     │ │
 * │ └────────────────────┴────────────────────────┴───────────────────────┘ │
 *                                                                          │
 *   ARGUMENT ORDER (Important!):                                           │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ POSITION('substring' IN 'string')  ← substring FIRST               ││
 *   │ STRPOS('string', 'substring')      ← string FIRST, substring SECOND││
 *   │ LOCATE('substring', 'string')      ← substring FIRST, string SECOND││
 *   │ INSTR('string', 'substring')       ← string FIRST, substring SECOND││
 *   │                                                                     ││
 *   │ ⚠️  Confusing order is a common source of bugs!                    ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 *   RETURN VALUE:                                                          │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │ • Position of first character (1-based) if found                   ││
 *   │ • 0 if NOT found                                                   ││
 *   │ • NULL if either argument is NULL                                  ││
 *   └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- PostgreSQL examples
SELECT 
    POSITION('@' IN 'user@example.com') AS position_method,
    STRPOS('user@example.com', '@') AS strpos_method;

/**
 * OUTPUT:
 * ┌─────────────────┬───────────────┐
 * │ position_method │ strpos_method │
 * ├─────────────────┼───────────────┤
 * │ 5               │ 5             │
 * └─────────────────┴───────────────┘
 * 
 * EXPLANATION: Both return the same result (5)
 */

-- ============================================================================
-- PART 4: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Confusing argument order                                   │
 * │                                                                          │
 * │   ❌ STRPOS('@', 'user@example.com')  ← wrong order!                   │
 * │   ✅ STRPOS('user@example.com', '@')  ← correct                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong order
SELECT STRPOS('@', 'user@example.com') AS wrong_order;

/**
 * OUTPUT:
 * ┌────────────┐
 * │ wrong_order│
 * ├────────────┤
 * │ 0          │
 * └────────────┘
 * 
 * EXPLANATION: Looking for 'user@example.com' inside '@' → not found
 */

-- ✅ Correct order
SELECT STRPOS('user@example.com', '@') AS correct_order;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ correct_order │
 * ├───────────────┤
 * │ 5             │
 * └───────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Assuming 0 means first character                          │
 * │                                                                          │
 * │   ❌ Thinking POSITION('@') = 0 means '@' is at position 0             │
 * │   ✅ 0 means NOT FOUND                                                 │
 * │   ✅ First character is always position 1                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate that first character is position 1, not 0
SELECT 
    POSITION('R' IN 'Raj') AS first_char_position,
    POSITION('x' IN 'Raj') AS not_found_returns_0;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────────────────┐
 * │ first_char_position │ not_found_returns_0 │
 * ├─────────────────────┼─────────────────────┤
 * │ 1                   │ 0                   │
 * └─────────────────────┴─────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Case sensitivity issues                                    │
 * │                                                                          │
 * │   Depending on collation, 'A' may or may not match 'a'                 │
 * │   Use LOWER() to make case-insensitive                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Case-insensitive search using LOWER
SELECT 
    POSITION('A' IN 'Raj') AS case_sensitive,
    POSITION(LOWER('A') IN LOWER('Raj')) AS case_insensitive;

/**
 * OUTPUT:
 * ┌────────────────┬───────────────────┐
 * │ case_sensitive │ case_insensitive  │
 * ├────────────────┼───────────────────┤
 * │ 0              │ 2                 │
 * └────────────────┴───────────────────┘
 * 
 * EXPLANATION: 'A' (uppercase) not found, but 'a' (lowercase) is at position 2
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: NULL values break the function                             │
 * │                                                                          │
 * │   POSITION('@' IN NULL) → NULL (not 0)                                 │
 * │   Always handle NULLs with COALESCE                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- NULL handling
SELECT 
    POSITION('@' IN NULL) AS null_returns_null,
    COALESCE(POSITION('@' IN NULL), 0) AS null_handled;

/**
 * OUTPUT:
 * ┌───────────────────┬──────────────┐
 * │ null_returns_null │ null_handled │
 * ├───────────────────┼──────────────┤
 * │ NULL              │ 0            │
 * └───────────────────┴──────────────┘
 */

-- ============================================================================
-- PART 5: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Returns 0 if NOT found (not NULL)                              │
 * │         → Use > 0 to check if substring exists                         │
 * │                                                                          │
 * │ RULE 2: 1-based indexing                                               │
 * │         → First character is position 1, NOT 0                         │
 * │                                                                          │
 * │ RULE 3: Know your function's argument order                            │
 * │         → POSITION('substr' IN 'string')                               │
 * │         → STRPOS('string', 'substr')                                   │
 * │         → LOCATE('substr', 'string')                                   │
 * │         → INSTR('string', 'substr')                                    │
 * │                                                                          │
 * │ RULE 4: Use LOWER() for case-insensitive search                        │
 * │         → POSITION(LOWER('A') IN LOWER('Raj'))                         │
 * │                                                                          │
 * │ RULE 5: Handle NULLs with COALESCE                                     │
 * │         → COALESCE(POSITION('@' IN email), 0)                          │
 * │                                                                          │
 * │ RULE 6: Use with SUBSTRING for advanced extraction                     │
 * │         → SUBSTRING(email, POSITION('@' IN email) + 1) for domain      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Extract domain from email using POSITION
SELECT 
    email_address,
    POSITION('@' IN email_address) AS at_pos,
    SUBSTRING(email_address, POSITION('@' IN email_address) + 1) AS domain
FROM user_directory
WHERE POSITION('@' IN email_address) > 0;

/**
 * OUTPUT:
 * ┌─────────────────────┬────────┬─────────────┐
 * │ email_address       │ at_pos │ domain      │
 * ├─────────────────────┼────────┼─────────────┤
 * │ raj.patel@gmail.com │ 10     │ gmail.com   │
 * │ neha_99@outlook.com │ 8      │ outlook.com │
 * │ support@tuf.com     │ 8      │ tuf.com     │
 * └─────────────────────┴────────┴─────────────┘
 */

-- Extract username from email
SELECT 
    email_address,
    LEFT(email_address, POSITION('@' IN email_address) - 1) AS username
FROM user_directory
WHERE POSITION('@' IN email_address) > 0;

/**
 * OUTPUT:
 * ┌─────────────────────┬───────────────┐
 * │ email_address       │ username      │
 * ├─────────────────────┼───────────────┤
 * │ raj.patel@gmail.com │ raj.patel     │
 * │ neha_99@outlook.com │ neha_99       │
 * │ support@tuf.com     │ support       │
 * └─────────────────────┴───────────────┘
 */

-- ============================================================================
-- PART 6: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ PostgreSQL:                                                             │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ POSITION('@' IN 'user@example.com')  → 5                          ││
 * │ │ STRPOS('user@example.com', '@')      → 5                          ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ MySQL:                                                                 │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LOCATE('@', 'user@example.com')  → 5                               ││
 * │ │ INSTR('user@example.com', '@')   → 5                               ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ RETURN VALUES:                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ Found      → position (1, 2, 3, ...)                               ││
 * │ │ Not found  → 0                                                     ││
 * │ │ NULL input → NULL                                                  ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Check if character exists                                       ││
 * │ │ WHERE POSITION('@' IN email) > 0                                   ││
 * │ │                                                                     ││
 * │ │ -- Extract domain                                                  ││
 * │ │ SUBSTRING(email, POSITION('@' IN email) + 1)                       ││
 * │ │                                                                     ││
 * │ │ -- Extract username                                                ││
 * │ │ LEFT(email, POSITION('@' IN email) - 1)                            ││
 * │ │                                                                     ││
 * │ │ -- Find second occurrence                                          ││
 * │ │ POSITION('.' IN SUBSTRING(email, first_pos + 1)) + first_pos       ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find position of '@' in 'user@example.com'
 * 
 * Answer:
 *   SELECT POSITION('@' IN 'user@example.com');
 */

/**
 * EXERCISE 2: Check if 'Raj@gmail.com' contains '@' symbol
 * 
 * Answer:
 *   SELECT POSITION('@' IN 'Raj@gmail.com') > 0;
 */

/**
 * EXERCISE 3: Find position of first dot in 'john.doe@example.com'
 * 
 * Answer:
 *   SELECT POSITION('.' IN 'john.doe@example.com');
 */

/**
 * EXERCISE 4: Extract domain name from 'test@database.com'
 * 
 * Answer:
 *   SELECT SUBSTRING('test@database.com', POSITION('@' IN 'test@database.com') + 1);
 */

/**
 * EXERCISE 5: Find emails without '@' symbol in user_directory
 * 
 * Answer:
 *   SELECT * FROM user_directory WHERE POSITION('@' IN email_address) = 0;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS user_directory;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. POSITION() / STRPOS() / LOCATE() / INSTR() = Find substring position │
 * │                                                                          │
 * │ 2. Returns 0 if NOT found (not NULL)                                   │
 * │                                                                          │
 * │ 3. 1-based indexing: first character = position 1                      │
 * │                                                                          │
 * │ 4. Different databases have different syntax and argument order        │
 * │    → PostgreSQL: POSITION('sub' IN 'str') or STRPOS('str', 'sub')      │
 * │    → MySQL: LOCATE('sub', 'str') or INSTR('str', 'sub')                │
 * │                                                                          │
 * │ 5. Use with SUBSTRING to extract parts of strings                      │
 * │    → Domain: SUBSTRING(email, POSITION('@' IN email) + 1)              │
 * │    → Username: LEFT(email, POSITION('@' IN email) - 1)                 │
 * │                                                                          │
 * │ 6. Use LOWER() for case-insensitive search                             │
 * │                                                                          │
 * │ 7. Handle NULLs with COALESCE                                          │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - 0 = Not Found                                                      │
 * │   - 1 = First character                                                │
 * │   - Check argument order for your database                             │
 * │   - Combine with SUBSTRING for extraction                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF LOCATE AND INSTR REVISION GUIDE
-- ============================================================================