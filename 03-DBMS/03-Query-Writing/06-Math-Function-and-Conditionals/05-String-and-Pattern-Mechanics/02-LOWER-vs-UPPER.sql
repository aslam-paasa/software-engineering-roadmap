/**
 * ============================================================================
 * LOWER() and UPPER() - COMPLETE REVISION GUIDE
 * (Case Conversion, Standardization, Case-Insensitive Search)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT ARE LOWER() and UPPER()? ---------------- (Changing text case)
 *    - 1.1 Basic syntax and examples
 *    - 1.2 Why case standardization matters
 * 
 * 2. REAL-WORLD SCENARIOS ------------------------- (Practical examples)
 *    - 2.1 Creating a standardized name list
 *    - 2.2 Formatting cities for a heading
 *    - 2.3 Case-insensitive email searching
 *    - 2.4 Identifying "Shouting" users
 *    - 2.5 Building formatted email subjects
 * 
 * 3. LOWER() vs UPPER() --------------------------- (Comparison)
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
-- PART 1: WHAT ARE LOWER() and UPPER()?
-- ============================================================================

/**
 * LOWER() converts all letters to lowercase.
 * UPPER() converts all letters to uppercase.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    LOWER() and UPPER()                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ LOWER(string)   → converts to lowercase                         │   │
 * │   │ UPPER(string)   → converts to uppercase                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLES:                                                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ LOWER('RAjstriveR')  → 'rajstriver'                            │   │
 * │   │ UPPER('RAjstriveR')  → 'RAJSTRIVER'                             │   │
 * │   │ UPPER('raj123!')     → 'RAJ123!'  (numbers/symbols unchanged)   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Basic LOWER example
SELECT LOWER('RAjstriveR') AS lower_result;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ lower_result │
 * ├──────────────┤
 * │ rajstriver   │
 * └──────────────┘
 */

-- Basic UPPER example
SELECT UPPER('RAjstriveR') AS upper_result;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ upper_result │
 * ├──────────────┤
 * │ RAJSTRIVER   │
 * └──────────────┘
 */

-- Numbers and symbols remain unchanged
SELECT UPPER('raj123!') AS upper_with_numbers;

/**
 * OUTPUT:
 * ┌────────────────────┐
 * │ upper_with_numbers │
 * ├────────────────────┤
 * │ RAJ123!            │
 * └────────────────────┘
 */

-- ============================================================================
-- 1.2 Why Case Standardization Matters
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHY CASE STANDARDIZATION MATTERS                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEMS WITH MIXED CASE:                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • Reports look unprofessional (ALICE smith, bob MARTIN)        │   │
 * │   │ • Searches may fail ('Raj' vs 'raj')                            │   │
 * │   │ • Data migration issues                                        │   │
 * │   │ • Inconsistent sorting                                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SOLUTIONS:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • LOWER() → Standardize to lowercase for consistency           │   │
 * │   │ • UPPER() → Make text stand out (headings, alerts)             │   │
 *   │   │ • Case-insensitive search → LOWER(column) = LOWER(search)      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- SOURCE TABLE: USERS_DATA
-- ============================================================================

CREATE TABLE users_data (
    id INT PRIMARY KEY,
    full_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO users_data (id, full_name, city, email) VALUES
(1, 'ALICE smith', 'bengaluru', 'Alice.S@Tuf.Com'),
(2, 'bob MARTIN', 'DELHI', 'BOB@gmail.com'),
(3, 'Carol Danvers', 'Pune', 'carol@Company.org');

-- Display users_data
SELECT id, full_name, city, email FROM users_data ORDER BY id;

/**
 * OUTPUT:
 * ┌────┬───────────────┬───────────┬─────────────────────┐
 * │ id │ full_name     │ city      │ email               │
 * ├────┼───────────────┼───────────┼─────────────────────┤
 * │ 1  │ ALICE smith   │ bengaluru │ Alice.S@Tuf.Com     │
 * │ 2  │ bob MARTIN    │ DELHI     │ BOB@gmail.com       │
 * │ 3  │ Carol Danvers │ Pune      │ carol@Company.org   │
 * └────┴───────────────┴───────────┴─────────────────────┘
 * 
 * NOTE: Inconsistent case in all columns!
 */

-- ============================================================================
-- PART 2: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Creating a Standardized Name List
 * 
 * Show all user names converted to lowercase for data migration
 */

SELECT 
    id, 
    LOWER(full_name) AS normalized_name
FROM users_data;

/**
 * OUTPUT:
 * ┌────┬─────────────────┐
 * │ id │ normalized_name │
 * ├────┼─────────────────┤
 * │ 1  │ alice smith     │
 * │ 2  │ bob martin      │
 * │ 3  │ carol danvers   │
 * └────┴─────────────────┘
 * 
 * EXPLANATION: All names are now consistently lowercase
 */

/**
 * SCENARIO 2: Formatting Cities for a Heading
 * 
 * Display cities in uppercase for bold report headers
 */

SELECT 
    id, 
    UPPER(city) AS city_header
FROM users_data;

/**
 * OUTPUT:
 * ┌────┬─────────────┐
 * │ id │ city_header │
 * ├────┼─────────────┤
 * │ 1  │ BENGALURU   │
 * │ 2  │ DELHI       │
 * │ 3  │ PUNE        │
 * └────┴─────────────┘
 * 
 * EXPLANATION: All cities are now uppercase, perfect for headings
 */

/**
 * SCENARIO 3: Case-Insensitive Email Searching
 * 
 * User typed "alice.s@tuf.com" but database has "Alice.S@Tuf.Com"
 * Convert both to lowercase to find the match
 */

SELECT 
    id, 
    full_name
FROM users_data
WHERE LOWER(email) = LOWER('alice.s@tuf.com');

/**
 * OUTPUT:
 * ┌────┬─────────────┐
 * │ id │ full_name   │
 * ├────┼─────────────┤
 * │ 1  │ ALICE smith │
 * └────┴─────────────┘
 * 
 * EXPLANATION: 
 * - LOWER(email) converts 'Alice.S@Tuf.Com' → 'alice.s@tuf.com'
 * - LOWER(search) converts 'alice.s@tuf.com' → 'alice.s@tuf.com'
 * - They match, so user is found!
 */

-- Another example: Find user by name (case-insensitive)
SELECT 
    id, 
    full_name, 
    email
FROM users_data
WHERE LOWER(full_name) = LOWER('BOB MARTIN');

/**
 * OUTPUT:
 * ┌────┬─────────────┬─────────────────┐
 * │ id │ full_name   │ email           │
 * ├────┼─────────────┼─────────────────┤
 * │ 2  │ bob MARTIN  │ BOB@gmail.com   │
 * └────┴─────────────┴─────────────────┘
 */

/**
 * SCENARIO 4: Identifying "Shouting" Users
 * 
 * Find users who entered their city in all uppercase.
 * This helps identify data copied from old legacy systems.
 */

SELECT 
    id, 
    full_name, 
    city
FROM users_data
WHERE city = UPPER(city) AND city != LOWER(city);

/**
 * OUTPUT:
 * ┌────┬─────────────┬───────┐
 * │ id │ full_name   │ city  │
 * ├────┼─────────────┼───────┤
 * │ 2  │ bob MARTIN  │ DELHI │
 * └────┴─────────────┴───────┘
 * 
 * EXPLANATION: 
 * - city = UPPER(city) → city is all uppercase
 * - city != LOWER(city) → city is NOT all lowercase
 * - This finds DELHI (uppercase) but not bengaluru or Pune
 */

/**
 * SCENARIO 5: Building Formatted Email Subjects
 * 
 * Create a welcome message with uppercase name
 */

SELECT 
    CONCAT('WELCOME ', UPPER(full_name), '!') AS greeting
FROM users_data
WHERE id = 3;

/**
 * OUTPUT:
 * ┌─────────────────────────┐
 * │ greeting                │
 * ├─────────────────────────┤
 * │ WELCOME CAROL DANVERS!  │
 * └─────────────────────────┘
 */

-- Create personalized email subjects for all users
SELECT 
    CONCAT('Hello ', full_name, ', your account is ready!') AS standard,
    CONCAT('HELLO ', UPPER(full_name), ', YOUR ACCOUNT IS READY!') AS urgent
FROM users_data;

/**
 * OUTPUT:
 * ┌─────────────────────────────────────────┬─────────────────────────────────────────────┐
 * │ standard                                │ urgent                                      │
 * ├─────────────────────────────────────────┼─────────────────────────────────────────────┤
 * │ Hello ALICE smith, your account is ready│ HELLO ALICE SMITH, YOUR ACCOUNT IS READY!  │
 * │ Hello bob MARTIN, your account is ready │ HELLO BOB MARTIN, YOUR ACCOUNT IS READY!   │
 * │ Hello Carol Danvers, your account is... │ HELLO CAROL DANVERS, YOUR ACCOUNT IS READY!│
 * └─────────────────────────────────────────┴─────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 3: LOWER() vs UPPER() - COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              LOWER() vs UPPER()                                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────┬────────────────────────┬───────────────────────┐ │
 * │ │ Feature            │ LOWER()                │ UPPER()               │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Converts to       │ Lowercase (small letters)│ Uppercase (CAPITAL)   │ │
 * │ │ Use case          │ Data normalization      │ Headings, alerts      │ │
 * │ │                   │ Case-insensitive search │ Emphasis              │ │
 * ├────────────────────┼────────────────────────┼───────────────────────┤ │
 * │ │ Example           │ 'Raj' → 'raj'          │ 'Raj' → 'RAJ'         │ │
 * │ └────────────────────┴────────────────────────┴───────────────────────┘ │
 *                                                                          │
 *   WHEN TO USE WHICH:                                                     │
 *   ┌─────────────────────────────────────────────────────────────────────┐│
 *   │                                                                     ││
 *   │ Use LOWER() when:                                                   ││
 *   │   → Standardizing data for storage                                  ││
 *   │   → Performing case-insensitive searches                            ││
 *   │   → Preparing data for migration                                    ││
 *   │   → Creating consistent reports                                     ││
 *   │                                                                     ││
 *   │ Use UPPER() when:                                                   ││
 *   │   → Creating headings or titles                                     ││
 *   │   → Sending alert/urgent messages                                   ││
 *   │   → Making text stand out                                           ││
 *   │   → Generating codes or IDs                                         ││
 *   │                                                                     ││
 * └─────────────────────────────────────────────────────────────────────┘│
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate both side by side
SELECT 
    full_name,
    LOWER(full_name) AS lowercase,
    UPPER(full_name) AS uppercase
FROM users_data;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────────┬─────────────────┐
 * │ full_name     │ lowercase       │ uppercase       │
 * ├───────────────┼─────────────────┼─────────────────┤
 * │ ALICE smith   │ alice smith     │ ALICE SMITH     │
 * │ bob MARTIN    │ bob martin      │ BOB MARTIN      │
 * │ Carol Danvers │ carol danvers   │ CAROL DANVERS   │
 * └───────────────┴─────────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 4: PERFORMANCE CONSIDERATIONS (Important Warning!)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              PERFORMANCE WARNING!                                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   ⚠️  Using LOWER() or UPPER() on a column in WHERE clause          │
 * │      can make your query SLOW on large tables!                         │
 * │                                                                          │
 * │   WHY?                                                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Database must convert EVERY row to lowercase/uppercase         │   │
 * │   │ BEFORE it can compare.                                          │   │
 * │   │ Index on the column cannot be used efficiently.                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   EXAMPLE:                                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ ❌ SLOW: WHERE LOWER(email) = LOWER('user@email.com')          │   │
 * │   │                                                                  │   │
 * │   │ ✅ FAST: WHERE email = 'user@email.com' (if case-insensitive)   │   │
 * │   │    OR store emails in lowercase in the database                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SOLUTION:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Store data in consistent case (e.g., all lowercase)         │   │
 * │   │ 2. Use case-insensitive collation                              │   │
 * │   │ 3. Create indexes on LOWER(column) (expression index)          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ SLOW on large tables (cannot use index efficiently)
-- SELECT * FROM users_data WHERE LOWER(email) = LOWER('alice.s@tuf.com');

-- ✅ FAST (if email is stored consistently or collation is case-insensitive)
-- SELECT * FROM users_data WHERE email = 'alice.s@tuf.com';

-- Create an expression index for faster case-insensitive searches (PostgreSQL)
-- CREATE INDEX idx_users_email_lower ON users_data (LOWER(email));

-- ============================================================================
-- PART 5: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Assuming LOWER/UPPER affect non-letter characters          │
 * │                                                                          │
 * │   LOWER('RAJ123!') → 'raj123!' (numbers/symbols unchanged)             │
 * │   UPPER('raj123!') → 'RAJ123!' (numbers/symbols unchanged)             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    LOWER('RAJ123!') AS lower_result,
    UPPER('raj123!') AS upper_result;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┐
 * │ lower_result│ upper_result│
 * ├─────────────┼─────────────┤
 * │ raj123!     │ RAJ123!     │
 * └─────────────┴─────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Forgetting that collation affects equality                 │
 * │                                                                          │
 * │   If database uses case-sensitive collation:                           │
 * │   'Raj' = 'raj' is FALSE                                               │
 * │                                                                          │
 * │   ✅ Use LOWER() for comparison: LOWER('Raj') = LOWER('raj')           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- With case-sensitive collation, this would be false
-- SELECT 'Raj' = 'raj' AS is_equal;  -- May return false

-- Safe way
SELECT LOWER('Raj') = LOWER('raj') AS is_equal;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ is_equal│
 * ├─────────┤
 * │ true    │
 * └─────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Overusing LOWER/UPPER in WHERE clause on large tables      │
 * │                                                                          │
 * │   ❌ WHERE LOWER(name) = LOWER('search')  (slow on large tables)       │
 * │   ✅ Store data in consistent case                                     │
 * │   ✅ Use case-insensitive collation                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Forgetting to apply LOWER/UPPER to BOTH sides              │
 * │                                                                          │
 *   │   ❌ WHERE LOWER(email) = 'USER@EMAIL.COM'  (right side not converted)│
 * │   ✅ WHERE LOWER(email) = LOWER('USER@EMAIL.COM')                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong - only left side converted
-- SELECT * FROM users_data WHERE LOWER(email) = 'ALICE.S@TUF.COM';

-- ✅ Correct - both sides converted
SELECT * FROM users_data WHERE LOWER(email) = LOWER('ALICE.S@TUF.COM');

/**
 * OUTPUT:
 * ┌────┬─────────────┬───────────┬───────────────────┐
 * │ id │ full_name   │ city      │ email             │
 * ├────┼─────────────┼───────────┼───────────────────┤
 * │ 1  │ ALICE smith │ bengaluru │ Alice.S@Tuf.Com   │
 * └────┴─────────────┴───────────┴───────────────────┘
 */

-- ============================================================================
-- PART 6: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Use LOWER() for data normalization                             │
 * │         → Standardize names, emails, usernames to lowercase            │
 * │                                                                          │
 * │ RULE 2: Use UPPER() for emphasis                                       │
 * │         → Headings, alerts, important messages                         │
 * │                                                                          │
 * │ RULE 3: For case-insensitive search, convert BOTH sides                │
 * │         → WHERE LOWER(column) = LOWER(search_value)                    │
 * │                                                                          │
 * │ RULE 4: Be aware of performance impact                                 │
 * │         → LOWER/UPPER on indexed columns in WHERE can be slow          │
 * │         → Consider storing data in consistent case                     │
 * │                                                                          │
 * │ RULE 5: Numbers and symbols are unchanged                              │
 * │         → LOWER('RAJ123!') = 'raj123!'                                 │
 * │         → UPPER('raj123!') = 'RAJ123!'                                 │
 * │                                                                          │
 * │ RULE 6: Understand your collation                                      │
 * │         → Case-insensitive collation may not need LOWER/UPPER          │
 * │         → Case-sensitive collation definitely needs it                 │
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
 * │ LOWER():                                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ LOWER('RAjstriveR') → 'rajstriver'                                 ││
 * │ │ LOWER('HELLO')       → 'hello'                                      ││
 * │ │ LOWER('Alice.S@Tuf.Com') → 'alice.s@tuf.com'                       ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ UPPER():                                                               │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ UPPER('RAjstriveR') → 'RAJSTRIVER'                                 ││
 * │ │ UPPER('hello')       → 'HELLO'                                      ││
 * │ │ UPPER('alice.s@tuf.com') → 'ALICE.S@TUF.COM'                       ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ CASE-INSENSITIVE SEARCH:                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ WHERE LOWER(email) = LOWER('USER@EMAIL.COM')                        ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ -- Normalize names for display                                      ││
 * │ │ SELECT LOWER(full_name) FROM users;                                 ││
 * │ │                                                                     ││
 * │ │ -- Create uppercase headers                                         ││
 * │ │ SELECT UPPER(city) AS city_header FROM locations;                   ││
 * │ │                                                                     ││
 * │ │ -- Case-insensitive login check                                     ││
 * │ │ SELECT * FROM users WHERE LOWER(username) = LOWER('Raj');           ││
 * │ │                                                                     ││
 * │ │ -- Find all-uppercase entries                                       ││
 * │ │ SELECT * FROM table WHERE column = UPPER(column);                   ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ PERFORMANCE TIP:                                                        │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ For large tables, consider:                                         ││
 * │ │ 1. Storing data in consistent case                                 ││
 * │ │ 2. Using case-insensitive collation                                 ││
 * │ │ 3. Creating expression indexes on LOWER(column)                     ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 8: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Convert all user names to lowercase
 * 
 * Answer:
 *   SELECT LOWER(full_name) FROM users_data;
 */

/**
 * EXERCISE 2: Convert all city names to uppercase for a report header
 * 
 * Answer:
 *   SELECT UPPER(city) FROM users_data;
 */

/**
 * EXERCISE 3: Find user by email (case-insensitive)
 * 
 * Answer:
 *   SELECT * FROM users_data WHERE LOWER(email) = LOWER('Alice.S@Tuf.Com');
 */

/**
 * EXERCISE 4: Create a greeting with uppercase name
 * 
 * Answer:
 *   SELECT CONCAT('HELLO ', UPPER(full_name)) FROM users_data;
 */

/**
 * EXERCISE 5: Find all uppercase city names (legacy data)
 * 
 * Answer:
 *   SELECT * FROM users_data WHERE city = UPPER(city) AND city != LOWER(city);
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS users_data;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. LOWER() = Converts text to lowercase                                │
 * │    → Use for data normalization, consistent storage                    │
 * │                                                                          │
 * │ 2. UPPER() = Converts text to uppercase                                │
 * │    → Use for headings, alerts, emphasis                                │
 * │                                                                          │
 * │ 3. Case-insensitive search:                                            │
 * │    → WHERE LOWER(column) = LOWER(search_value)                         │
 * │    → Always convert BOTH sides!                                        │
 * │                                                                          │
 * │ 4. Performance warning:                                                │
 * │    → LOWER/UPPER in WHERE can be slow on large tables                  │
 * │    → Consider storing data in consistent case                          │
 * │                                                                          │
 * │ 5. Numbers and symbols are unchanged                                   │
 * │    → LOWER('RAJ123!') = 'raj123!'                                      │
 * │    → UPPER('raj123!') = 'RAJ123!'                                      │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - LOWER for normalization                                            │
 * │   - UPPER for emphasis                                                 │
 * │   - Convert BOTH sides for search                                      │
 * │   - Be careful with performance                                        │
 * │   - Know your collation                                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF LOWER AND UPPER REVISION GUIDE
-- ============================================================================