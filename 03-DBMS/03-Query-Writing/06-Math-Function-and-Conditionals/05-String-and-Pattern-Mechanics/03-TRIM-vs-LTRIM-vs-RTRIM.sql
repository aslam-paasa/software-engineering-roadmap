/**
 * ============================================================================
 * TRIM, LTRIM, RTRIM - COMPLETE REVISION GUIDE
 * (Removing whitespace from string edges)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE TRIM, LTRIM, RTRIM? ---------------- (Removing spaces)
 *    - 1.1 Basic syntax and examples
 *    - 1.2 Why cleaning whitespace is critical
 * 
 * 2. REAL-WORLD SCENARIOS ------------------------- (Practical examples)
 *    - 2.1 Total cleanup for reports
 *    - 2.2 Fixing left-side padding
 *    - 2.3 Finding users by trimming search input
 *    - 2.4 Cleaning combined text
 *    - 2.5 Advanced cleaning (nested functions)
 * 
 * 3. TRIM() vs LTRIM() vs RTRIM() ---------------- (Comparison)
 * 
 * 4. PERFORMANCE CONSIDERATIONS ------------------- (Important warning)
 * 
 * 5. COMMON MISTAKES ------------------------------ (What to avoid)
 * 
 * 6. GOLDEN RULES --------------------------------- (Key principles)
 * 
 * 7. QUICK REFERENCE CARD ------------------------- (Cheat sheet)
 * 
 * 8. PRACTICE EXERCISES --------------------------- (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT ARE TRIM, LTRIM, RTRIM?
-- ============================================================================

/**
 * These functions remove whitespace from the edges of a string.
 * They do NOT affect spaces in the middle of text.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              TRIM, LTRIM, RTRIM - EXPLANATION                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ TRIM(string)   → removes spaces from BOTH sides                 │   │
 * │   │ LTRIM(string)  → removes spaces from LEFT side only             │   │
 * │   │ RTRIM(string)  → removes spaces from RIGHT side only            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ TRIM('  RAJ  ')   → 'RAJ'   (both sides)                        │   │
 * │   │ LTRIM(' RAJ ')    → 'RAJ '  (left only)                         │   │
 * │   │ RTRIM(' RAJ ')    → ' RAJ'  (right only)                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   IMPORTANT: Spaces in the MIDDLE are NOT removed!                     │
 *   │   TRIM(' Raj Patel ') → 'Raj Patel' (middle space remains)           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Basic TRIM example
SELECT TRIM('  RAJ  ') AS trimmed;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ trimmed │
 * ├─────────┤
 * │ RAJ     │
 * └─────────┘
 */

-- Basic LTRIM example (left trim)
SELECT LTRIM(' RAJ ') AS left_trimmed;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ left_trimmed │
 * ├──────────────┤
 * │ RAJ          │
 * └──────────────┘
 * 
 * EXPLANATION: Space on left removed, space on right remains
 */

-- Basic RTRIM example (right trim)
SELECT RTRIM(' RAJ ') AS right_trimmed;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ right_trimmed │
 * ├───────────────┤
 * │  RAJ          │
 * └───────────────┘
 * 
 * EXPLANATION: Space on right removed, space on left remains
 */

-- Spaces in the middle are NOT removed
SELECT TRIM(' Raj Patel ') AS middle_space_remains;

/**
 * OUTPUT:
 * ┌─────────────────────┐
 * │ middle_space_remains │
 * ├─────────────────────┤
 * │ Raj Patel           │
 * └─────────────────────┘
 * 
 * EXPLANATION: Space between 'Raj' and 'Patel' remains
 */

-- ============================================================================
-- 1.2 Why Cleaning Whitespace is Critical
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHY CLEANING WHITESPACE IS CRITICAL                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: 'Apple' and 'Apple ' are NOT the same in SQL!               │
 * │                                                                          │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 'Apple' = 'Apple '  → FALSE (different strings!)                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL WORLD IMPACT:                                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • User tries to log in with 'user@email.com ' (trailing space)  │   │
 * │   │ • Database has 'user@email.com' (no space)                      │   │
 *   │   │ • Result: "User Not Found" ❌                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SOLUTION: ALWAYS trim user input and database values!                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ WHERE TRIM(email) = TRIM('user@email.com ')                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate the problem
SELECT 'Apple' = 'Apple ' AS are_they_equal;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ are_they_equal  │
 * ├─────────────────┤
 * │ false           │
 * └─────────────────┘
 * 
 * EXPLANATION: Trailing space makes them different!
 */

-- Solution: Use TRIM
SELECT TRIM('Apple') = TRIM('Apple ') AS are_they_equal_now;

/**
 * OUTPUT:
 * ┌────────────────────┐
 * │ are_they_equal_now │
 * ├────────────────────┤
 * │ true               │
 * └────────────────────┘
 */

-- ============================================================================
-- SOURCE TABLE: RAW_REGISTRATIONS
-- ============================================================================

CREATE TABLE raw_registrations (
    id INT PRIMARY KEY,
    username VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO raw_registrations (id, username, city) VALUES
(1, ' alice', 'Bengaluru '),
(2, 'bob ', ' Delhi'),
(3, ' charlie ', 'Pune');

-- Display raw data (with spaces visible)
SELECT id, username, city FROM raw_registrations ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬───────────┬─────────────┐
 * │ id │ username  │ city        │
 * ├────┼───────────┼─────────────┤
 * │ 1  │  alice    │ Bengaluru   │  (space before alice, space after Bengaluru)
 * │ 2  │ bob       │  Delhi      │  (space after bob, space before Delhi)
 * │ 3  │  charlie  │ Pune        │  (spaces on both sides of charlie)
 * └────┴───────────┴─────────────┘
 * 
 * NOTE: The spaces are visible in the output
 */

-- ============================================================================
-- PART 2: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Total Cleanup for Reports
 * 
 * Show clean list of all usernames and cities with no leading/trailing spaces
 */

SELECT 
    id, 
    TRIM(username) AS clean_username, 
    TRIM(city) AS clean_city
FROM raw_registrations;

/**
 * OUTPUT:
 * ┌────┬───────────────┬─────────────┐
 * │ id │ clean_username│ clean_city  │
 * ├────┼───────────────┼─────────────┤
 * │ 1  │ alice         │ Bengaluru   │
 * │ 2  │ bob           │ Delhi       │
 * │ 3  │ charlie       │ Pune        │
 * └────┴───────────────┴─────────────┘
 * 
 * EXPLANATION: All leading and trailing spaces removed
 */

/**
 * SCENARIO 2: Fixing Left-Side Padding
 * 
 * Data from older systems is "Right Aligned" (spaces on the left)
 * Remove only left spaces using LTRIM
 */

SELECT 
    id, 
    LTRIM(username) AS left_cleaned
FROM raw_registrations;

/**
 * OUTPUT:
 * ┌────┬──────────────┐
 * │ id │ left_cleaned │
 * ├────┼──────────────┤
 * │ 1  │ alice        │  (space before alice removed)
 * │ 2  │ bob          │  (no space before bob, so same)
 * │ 3  │ charlie      │  (spaces before charlie removed)
 * └────┴──────────────┘
 * 
 * EXPLANATION: Only leading spaces removed, trailing spaces remain
 */

/**
 * SCENARIO 3: Finding Users by Trimming Search Input
 * 
 * User searches for "alice" but database has " alice" (with space)
 * User might also accidentally type spaces in search bar
 */

-- User types "  alice  " (spaces on both sides)
SELECT * 
FROM raw_registrations
WHERE TRIM(username) = TRIM('  alice  ');

/**
 * OUTPUT:
 * ┌────┬──────────┬─────────────┐
 * │ id │ username │ city        │
 * ├────┼──────────┼─────────────┤
 * │ 1  │  alice   │ Bengaluru   │
 * └────┴──────────┴─────────────┘
 * 
 * EXPLANATION: 
 * - TRIM(username) removes spaces from ' alice' → 'alice'
 * - TRIM('  alice  ') removes spaces → 'alice'
 * - They match, so user is found!
 */

-- Search for "bob" (database has "bob " with trailing space)
SELECT * 
FROM raw_registrations
WHERE TRIM(username) = TRIM('bob');

/**
 * OUTPUT:
 * ┌────┬──────────┬─────────┐
 * │ id │ username │ city    │
 * ├────┼──────────┼─────────┤
 * │ 2  │ bob      │  Delhi  │
 * └────┴──────────┴─────────┘
 */

/**
 * SCENARIO 4: Cleaning Combined Text
 * 
 * Create a greeting for the user without weird double spaces
 */

SELECT 
    CONCAT('Hello ', TRIM(username), ' from ', TRIM(city)) AS user_greeting
FROM raw_registrations
WHERE id = 1;

/**
 * OUTPUT:
 * ┌─────────────────────────────┐
 * │ user_greeting               │
 * ├─────────────────────────────┤
 * │ Hello alice from Bengaluru  │
 * └─────────────────────────────┘
 * 
 * EXPLANATION: No extra spaces from the dirty data
 */

-- All users with clean greetings
SELECT 
    CONCAT('Welcome ', TRIM(username), ' in ', TRIM(city), '!') AS greeting
FROM raw_registrations;

/**
 * OUTPUT:
 * ┌────────────────────────────────┐
 * │ greeting                       │
 * ├────────────────────────────────┤
 * │ Welcome alice in Bengaluru!    │
 * │ Welcome bob in Delhi!          │
 * │ Welcome charlie in Pune!       │
 * └────────────────────────────────┘
 */

/**
 * SCENARIO 5: Advanced Cleaning (Nested Functions)
 * 
 * Clean username and convert to uppercase for badge printout
 */

SELECT 
    UPPER(TRIM(username)) AS badge_name
FROM raw_registrations;

/**
 * OUTPUT:
 * ┌────────────┐
 * │ badge_name │
 * ├────────────┤
 * │ ALICE      │
 * │ BOB        │
 * │ CHARLIE    │
 * └────────────┘
 * 
 * EXPLANATION: First trim spaces, then convert to uppercase
 */

-- Combine multiple cleaning functions
SELECT 
    UPPER(TRIM(username)) AS clean_upper_name,
    LOWER(TRIM(city)) AS clean_lower_city,
    CONCAT(UPPER(TRIM(username)), ' from ', LOWER(TRIM(city))) AS badge
FROM raw_registrations;

/**
 * OUTPUT:
 * ┌─────────────────┬─────────────────┬─────────────────────────┐
 * │ clean_upper_name│ clean_lower_city│ badge                   │
 * ├─────────────────┼─────────────────┼─────────────────────────┤
 * │ ALICE           │ bengaluru       │ ALICE from bengaluru    │
 * │ BOB             │ delhi           │ BOB from delhi          │
 * │ CHARLIE         │ pune            │ CHARLIE from pune       │
 * └─────────────────┴─────────────────┴─────────────────────────┘
 */

-- ============================================================================
-- PART 3: TRIM() vs LTRIM() vs RTRIM() - COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              TRIM() vs LTRIM() vs RTRIM()                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────┬────────────────────────┬───────────────────────┐ │
 * │ │ Function           │ Removes                 │ Example (string: ' A ')│ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ TRIM()             │ Both sides              │ 'A'                   │ │
 * │ │ LTRIM()            │ Left side only          │ 'A '                  │ │
 * │ │ RTRIM()            │ Right side only         │ ' A'                  │ │
 * └────────────────────┴────────────────────────┴───────────────────────┘ │
 *                                                                          │
 *   VISUAL EXAMPLE:                                                        │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ String: "  Hello  "                                                 ││
 *   │          ↑      ↑                                                   ││
 *   │        spaces  spaces                                               ││
 *   │                                                                     ││
 *   │ TRIM("  Hello  ")   → "Hello"   (both sides removed)               ││
 *   │ LTRIM("  Hello  ")  → "Hello  "  (left removed, right remains)     ││
 *   │ RTRIM("  Hello  ")  → "  Hello"  (right removed, left remains)     ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 *   WHEN TO USE:                                                           │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ Use TRIM() when:                                                    ││
 *   │   → Cleaning user input for storage                                 ││
 *   │   → Comparing strings (both sides)                                  ││
 *   │   → Preparing data for reports                                      ││
 *   │                                                                     ││
 *   │ Use LTRIM() when:                                                   ││
 *   │   → Data has left padding from old systems                          ││
 *   │   → Fixing "right-aligned" data                                     ││
 *   │                                                                     ││
 *   │ Use RTRIM() when:                                                   ││
 *   │   → Data has trailing spaces from forms                             ││
 *   │   → Fixing CSV import issues                                        ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Side-by-side comparison
SELECT 
    '  Hello  ' AS original,
    TRIM('  Hello  ') AS trimmed,
    LTRIM('  Hello  ') AS left_trimmed,
    RTRIM('  Hello  ') AS right_trimmed;

/**
 * OUTPUT:
 * ┌──────────┬─────────┬──────────────┬───────────────┐
 * │ original │ trimmed │ left_trimmed │ right_trimmed │
 * ├──────────┼─────────┼──────────────┼───────────────┤
 * │   Hello  │ Hello   │ Hello        │   Hello       │
 * └──────────┴─────────┴──────────────┴───────────────┘
 */

-- ============================================================================
-- PART 4: PERFORMANCE CONSIDERATIONS (Important Warning!)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              PERFORMANCE WARNING!                                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   ⚠️  Using TRIM() on a column in WHERE clause can make your query    │
 * │      SLOW on large tables!                                             │
 * │                                                                          │
 * │   WHY?                                                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 *   │   │ Database must process EVERY row to remove spaces             │   │
 * │   │ BEFORE it can compare.                                          │   │
 * │   │ Index on the column cannot be used efficiently.                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLE:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ❌ SLOW: WHERE TRIM(username) = 'alice'                        │   │
 * │   │                                                                  │   │
 * │   │ ✅ FAST: WHERE username = 'alice' (if data is clean)            │   │
 * │   │    OR clean data before inserting                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BEST PRACTICE:                                                        │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Clean data BEFORE inserting (use TRIM in INSERT)            │   │
 * │   │ 2. Store data in clean format                                   │   │
 * │   │ 3. Use TRIM only for display, not for filtering                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ SLOW on large tables (cannot use index)
-- SELECT * FROM raw_registrations WHERE TRIM(username) = 'alice';

-- ✅ FAST (if data is stored cleanly)
-- SELECT * FROM raw_registrations WHERE username = 'alice';

-- Better: Clean data during INSERT
-- INSERT INTO raw_registrations (username, city) 
-- VALUES (TRIM(' alice '), TRIM(' Bengaluru '));

-- ============================================================================
-- PART 5: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Expecting TRIM to remove middle spaces                     │
 * │                                                                          │
 * │   TRIM('Raj Patel') → 'Raj Patel' (space between words remains)        │
 * │   To remove middle spaces, use REPLACE()                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- TRIM does NOT remove middle spaces
SELECT TRIM('Raj Patel') AS middle_space_remains;

/**
 * OUTPUT:
 * ┌─────────────────────┐
 * │ middle_space_remains│
 * ├─────────────────────┤
 * │ Raj Patel           │
 * └─────────────────────┘
 */

-- To remove ALL spaces, use REPLACE
SELECT REPLACE('Raj Patel', ' ', '') AS all_spaces_removed;

/**
 * OUTPUT:
 * ┌────────────────────┐
 * │ all_spaces_removed │
 * ├────────────────────┤
 * │ RajPatel           │
 * └────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Forgetting to trim BOTH sides in comparison               │
 * │                                                                          │
 *   │   ❌ WHERE username = TRIM(' alice ')  (only right side trimmed)      │
 * │   ✅ WHERE TRIM(username) = TRIM(' alice ') (both sides trimmed)        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong - only search value is trimmed
-- SELECT * FROM raw_registrations WHERE username = TRIM(' alice ');

-- ✅ Correct - both sides trimmed
SELECT * FROM raw_registrations WHERE TRIM(username) = TRIM(' alice ');

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using TRIM in WHERE clause on large tables                │
 * │                                                                          │
 * │   ❌ WHERE TRIM(username) = 'alice'  (slow)                            │
 * │   ✅ Store data cleanly, then WHERE username = 'alice' (fast)          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Forgetting that TRIM only removes spaces, not other       │
 * │            whitespace characters (tabs, newlines)                      │
 * │                                                                          │
 * │   TRIM('\tRaj\n') → '\tRaj\n' (tabs and newlines remain)              │
 * │   Use TRIM(BOTH ' \t\n' FROM string) in PostgreSQL for all whitespace │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 6: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Always TRIM user input before storing in database              │
 * │         → INSERT INTO table (name) VALUES (TRIM(' Raj '))              │
 * │                                                                          │
 * │ RULE 2: Always TRIM both sides in comparisons                          │
 * │         → WHERE TRIM(column) = TRIM(search_value)                      │
 * │                                                                          │
 * │ RULE 3: TRIM removes spaces from EDGES only                            │
 * │         → Middle spaces remain                                         │
 * │         → Use REPLACE() to remove middle spaces                        │
 * │                                                                          │
 * │ RULE 4: Use LTRIM() for left-side only cleaning                        │
 * │         → Fixes "right-aligned" data from old systems                  │
 * │                                                                          │
 * │ RULE 5: Use RTRIM() for right-side only cleaning                       │
 * │         → Fixes trailing spaces from forms                              │
 * │                                                                          │
 * │ RULE 6: Be aware of performance impact                                 │
 * │         → TRIM in WHERE clause can be slow                             │
 * │         → Clean data before inserting                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 7: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ TRIM():                                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ TRIM('  Hello  ')  → 'Hello'                                       ││
 * │ │ TRIM('  Hello')    → 'Hello'                                        ││
 * │ │ TRIM('Hello  ')    → 'Hello'                                        ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ LTRIM():                                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LTRIM('  Hello  ') → 'Hello  '                                     ││
 * │ │ LTRIM('  Hello')   → 'Hello'                                        ││
 * │ │ LTRIM('Hello  ')   → 'Hello  '                                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ RTRIM():                                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ RTRIM('  Hello  ') → '  Hello'                                      ││
 * │ │ RTRIM('  Hello')   → '  Hello'                                      ││
 * │ │ RTRIM('Hello  ')   → 'Hello'                                        ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Clean data during INSERT                                        ││
 * │ │ INSERT INTO users (name) VALUES (TRIM(' Raj '));                   ││
 * │ │                                                                     ││
 * │ │ -- Case-insensitive search with trim                               ││
 * │ │ WHERE LOWER(TRIM(username)) = LOWER(TRIM(' raj '))                 ││
 * │ │                                                                     ││
 * │ │ -- Clean and combine fields                                        ││
 * │ │ SELECT CONCAT(TRIM(first_name), ' ', TRIM(last_name)) AS full_name ││
 * │ │                                                                     ││
 * │ │ -- Fix left-padded data                                            ││
 * │ │ UPDATE table SET column = LTRIM(column);                           ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 8: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Clean usernames by removing all leading/trailing spaces
 * 
 * Answer:
 *   SELECT TRIM(username) FROM raw_registrations;
 */

/**
 * EXERCISE 2: Remove only left spaces from city names
 * 
 * Answer:
 *   SELECT LTRIM(city) FROM raw_registrations;
 */

/**
 * EXERCISE 3: Find user 'bob' even if database has spaces
 * 
 * Answer:
 *   SELECT * FROM raw_registrations WHERE TRIM(username) = TRIM('bob');
 */

/**
 * EXERCISE 4: Create greeting 'Hello alice from Bengaluru' from dirty data
 * 
 * Answer:
 *   SELECT CONCAT('Hello ', TRIM(username), ' from ', TRIM(city)) 
 *   FROM raw_registrations;
 */

/**
 * EXERCISE 5: Clean and capitalize usernames for badges
 * 
 * Answer:
 *   SELECT UPPER(TRIM(username)) FROM raw_registrations;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS raw_registrations;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. TRIM() = Removes spaces from BOTH sides                             │
 * │    → Use for complete cleanup                                          │
 * │                                                                          │
 * │ 2. LTRIM() = Removes spaces from LEFT side only                        │
 * │    → Use for fixing "right-aligned" data                               │
 * │                                                                          │
 * │ 3. RTRIM() = Removes spaces from RIGHT side only                       │
 * │    → Use for fixing trailing spaces from forms                         │
 * │                                                                          │
 * │ 4. IMPORTANT: These functions ONLY remove edge spaces                  │
 * │    → Middle spaces remain                                              │
 * │    → Use REPLACE() to remove all spaces                                │
 * │                                                                          │
 * │ 5. Performance: TRIM in WHERE can be slow                              │
 * │    → Clean data before inserting                                       │
 * │    → Store data in clean format                                        │
 * │                                                                          │
 * │ 6. Best practice: Always trim user input                               │
 * │    → INSERT INTO table VALUES (TRIM(input))                            │
 * │    → WHERE TRIM(column) = TRIM(search)                                 │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - 'Apple' ≠ 'Apple ' (trailing space)                                │
 * │   - TRIM solves this                                                   │
 * │   - Clean data early = faster queries later                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF TRIM, LTRIM, RTRIM REVISION GUIDE
-- ============================================================================