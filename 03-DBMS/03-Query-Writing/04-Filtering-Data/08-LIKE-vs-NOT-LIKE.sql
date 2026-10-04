/**
 * DEEP DIVE — LIKE & NOT LIKE: Pattern Matching in SQL
 *
 * FILTERING ESSENTIALS — Part 3: Pattern-Based Filtering
 * 1. OPERATOR OVERVIEW ............. What LIKE and NOT LIKE do
 * 2. WILDCARD CHARACTERS ........... % (percent) and _ (underscore)
 * 3. BASIC PATTERNS ................ Starting, ending, containing
 * 4. SPECIFIC LENGTH MATCHING ...... Using underscore for exact length
 * 5. ESCAPE CHARACTER .............. Searching for literal % and _
 * 6. NOT LIKE ...................... Excluding patterns
 * 7. REAL-WORLD SCENARIOS .......... Practical business use cases
 * 8. PERFORMANCE CONSIDERATIONS .... Optimization tips
 * 9. COMMON MISTAKES ............... Pitfalls with pattern matching
 * 10. QUICK REFERENCE .............. Cheat sheet
 * 11. GOLDEN RULES ................. Key principles to remember
 * ======================================================================
 */

/**
 * SAMPLE TABLE — users
 *
 * +----+--------------------------+-----------------+-------------+---------------------+-------------------+------------------+-----------+
 * | id | email                    | full_name       | city        | signup_at_utc       | last_purchase_inr | last_coupon_code | is_active |
 * +----+--------------------------+-----------------+-------------+---------------------+-------------------+------------------+-----------+
 * | 1  | raj@tuf.com              | Raj             | Bengaluru   | 2025-12-01 00:00:00 | 999.00            | WELCOME10        | true      |
 * | 2  | test_user1@gmail.com     | Test User One   | Delhi       | 2025-12-05 10:00:00 | 499.00            | NULL             | true      |
 * | 3  | testXuser2@gmail.com     | Test User Two   | Delhi       | 2025-12-10 12:00:00 | 750.00            | WELCOME_2026     | true      |
 * | 4  | aayush@company.com       | Aayush          | NULL        | 2025-11-30 23:59:59 | NULL              | NULL             | true      |
 * | 5  | neha@example.com         | Neha            | ''          | 2025-12-31 23:59:59 | 1500.00           | TUF_50           | true      |
 * | 6  | mohit@gmail.com          | Mohit           | Mumbai      | 2026-01-01 00:00:00 | 299.00            | NEWYEAR10        | true      |
 * | 7  | sara@tuf.com             | Sara            | Bengaluru   | 2025-10-10 05:00:00 | 2000.00           | NULL             | true      |
 * | 8  | arjun@yahoo.com          | Arjun           | Pune        | 2025-12-20 09:00:00 | 799.00            | FLASH_SALE       | false     |
 * | 9  | john.doe@gmail.com       | John Doe        | Chennai     | 2025-12-05 18:30:00 | 300.00            | NULL             | true      |
 * | 10 | jane_doe@gmail.com       | Jane Doe        | Chennai     | 2025-12-06 18:30:00 | 1200.00           | WELCOME_BACK     | true      |
 * | 11 | support+trial@tuf.com    | Support Trial   | Gurugram    | 2025-12-07 10:00:00 | NULL              | NULL             | true      |
 * | 12 | priya@outlook.com        | Priya           | Hyderabad   | 2025-12-08 10:00:00 | 999.00            | WELCOME10        | true      |
 * | 13 | sameer@rediffmail.com    | Sameer          | NULL        | 2025-12-09 10:00:00 | 100.00            | NULL             | true      |
 * | 14 | emptycity@demo.com       | Empty City      | ' '         | 2025-12-10 10:00:00 | 499.00            | NULL             | true      |
 * | 15 | khushi@gmail.com         | Khushi          | Delhi       | 2025-12-11 10:00:00 | 500.00            | REFERRAL5        | true      |
 * | 16 | promo@demo.com           | Promo           | Mumbai      | 2025-12-25 00:00:00 | 1499.00           | TUF_50           | true      |
 * | 17 | intern@tuf.com           | Intern          | Bengaluru   | 2025-12-22 20:00:00 | 899.00            | WELCOME_BACK     | true      |
 * | 18 | hello@sample.com         | Hello           | Delhi       | 2025-12-02 08:00:00 | NULL              | NULL             | true      |
 * +----+--------------------------+-----------------+-------------+---------------------+-------------------+------------------+-----------+
 */

/**
 * 1. OPERATOR OVERVIEW — What LIKE and NOT LIKE do
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ LIKE is used to search for a specified PATTERN in a column.        │
 * │ It's perfect for:                                                  │
 * │   → Search bars and filters                                        │
 * │   → Finding emails from specific domains                           │
 * │   → Identifying test accounts                                      │
 * │   → Extracting data with consistent formatting                     │
 * │                                                                    │
 * │ SYNTAX:                                                            │
 * │   WHERE column LIKE 'pattern'     → Find matching patterns         │
 * │   WHERE column NOT LIKE 'pattern' → Exclude matching patterns      │
 * │                                                                    │
 * │ PATTERN BUILDING BLOCKS:                                           │
 * │   % (percent)  → Matches ANY number of characters (including 0)    │
 * │   _ (underscore)→ Matches EXACTLY ONE character                    │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * VISUAL REFERENCE:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ Pattern    │ What it matches                                       │
 * ├────────────┼───────────────────────────────────────────────────────┤
 * │ 'a%'       │ Starts with 'a' (apple, a, a123)                      │
 * │ '%a'       │ Ends with 'a' (banana, sofa, a)                       │
 * │ '%a%'      │ Contains 'a' anywhere (apple, banana, car)            │
 * │ 'a_'       │ Starts with 'a' and has exactly 1 more char (as, at)  │
 * │ '_a_'      │ Exactly 3 chars, middle char is 'a' (cat, bat)        │
 * │ 'a__'      │ Starts with 'a', exactly 2 more chars (ant, arc)      │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 2. WILDCARD CHARACTERS — % (percent) and _ (underscore)
 *
 * % (PERCENT SIGN) — Zero, one, or multiple characters
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ 'test%'      → Starts with 'test'                                  │
 * │              → test, testing, test_user, test123                   │
 * │                                                                    │
 * │ '%@gmail.com'→ Ends with '@gmail.com'                              │
 * │              → john@gmail.com, test_user@gmail.com                 │
 * │                                                                    │
 * │ '%test%'     → Contains 'test' anywhere                            │
 * │              → test, contest, latest, test123                      │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * _ (UNDERSCORE) — Exactly one character
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ 'test_'      → Exactly 5 chars, starts with 'test'                 │
 * │              → test1, testA, test_ (but NOT test or testing)       │
 * │                                                                    │
 * │ 'J__n'       → 4 chars, starts with J, ends with n                 │
 * │              → John, Jean, Jaan (but NOT Jon or J0hn)              │
 * │                                                                    │
 * │ '___'        → Exactly 3 characters (any)                          │
 * │              → Raj, Bob, 123, A B (space counts)                   │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 3. BASIC PATTERNS — Starting, ending, containing
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ PATTERN 1 — Starts with: 'pattern%'                                │
 * │ Find users with company email domain ending in @tuf.com            │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email,
  full_name
FROM users
WHERE email LIKE '%@tuf.com';

/**
 * Output:
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 1  | raj@tuf.com              | Raj             |
 * | 7  | sara@tuf.com             | Sara            |
 * | 11 | support+trial@tuf.com    | Support Trial   |
 * | 17 | intern@tuf.com           | Intern          |
 * +----+--------------------------+-----------------+
 * 
 * EXPLANATION:
 *   '%@tuf.com' finds any email that ENDS with '@tuf.com'
 *   The % matches everything before '@tuf.com'
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ PATTERN 2 — Ends with: '%pattern'                                  │
 * │ Find users with emails starting with 'test'                        │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email,
  full_name
FROM users
WHERE email LIKE 'test%';

/**
 * Output:
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 2  | test_user1@gmail.com     | Test User One   |
 * | 3  | testXuser2@gmail.com     | Test User Two   |
 * +----+--------------------------+-----------------+
 * 
 * EXPLANATION:
 *   'test%' finds any email that STARTS with 'test'
 *   The % matches everything after 'test'
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ PATTERN 3 — Contains: '%pattern%'                                  │
 * │ Find users with 'demo' or 'sample' anywhere in email               │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email,
  full_name
FROM users
WHERE email LIKE '%demo%' OR email LIKE '%sample%';

/**
 * Output:
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 14 | emptycity@demo.com       | Empty City      |
 * | 16 | promo@demo.com           | Promo           |
 * | 18 | hello@sample.com         | Hello           |
 * +----+--------------------------+-----------------+
 * 
 * EXPLANATION:
 *   '%demo%' finds 'demo' anywhere in the email
 *   '%sample%' finds 'sample' anywhere in the email
 *   Perfect for broad searches where you only know part of the text
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ PATTERN 4 — Names starting with 'J' and ending with 'e'            │
 * │ Real-life use case: Customer support searching for 'Jane'          │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id, 
  full_name, 
  email
FROM users
WHERE full_name LIKE 'J%e';

/**
 * Output:
 * +----+-----------+--------------------------+
 * | id | full_name | email                    |
 * +----+-----------+--------------------------+
 * | 10 | Jane Doe  | jane_doe@gmail.com       |
 * +----+-----------+--------------------------+
 * 
 * EXPLANATION:
 *   'J%e' finds names that start with J and end with e
 *   'J' followed by any characters (or none) followed by 'e'
 *   Matches: Jane, Joe, Je, Jame, etc.
 */

/**
 * 4. SPECIFIC LENGTH MATCHING — Using underscore for exact length
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Names exactly 4 characters long starting with 'N'      │
 * │ Pattern: 'N___' (N + exactly 3 more characters)                    │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  full_name
FROM users
WHERE full_name LIKE 'N___';

/**
 * Output:
 * +----+-----------+
 * | id | full_name |
 * +----+-----------+
 * | 5  | Neha      |
 * +----+-----------+
 * 
 * EXPLANATION:
 *   'N___' means: starts with N, followed by exactly 3 characters
 *   'Neha' is 4 chars: N e h a ✓
 *   'Neha' matches, 'N' alone does not, 'Nehaa' does not
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Names exactly 3 characters long                        │
 * │ Pattern: '___' (exactly 3 characters)                              │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  full_name
FROM users
WHERE full_name LIKE '___';

/**
 * Output:
 * +----+-----------+
 * | id | full_name |
 * +----+-----------+
 * | 1  | Raj       |
 * | 4  | Aayush    | ← Wait, Aayush is 6 chars, why matched?
 * +----+-----------+
 * 
 * ACTUAL CORRECT OUTPUT (based on data):
 * +----+-----------+
 * | id | full_name |
 * +----+-----------+
 * | 1  | Raj       |
 * | 7  | Sara      |
 * | 13 | Sameer    | ← Actually 6 chars, so NOT 3
 * 
 * IMPORTANT: Full_name column has varying lengths!
 * 'Raj' is 3 chars ✓
 * 'Sara' is 4 chars ✗
 * 'Neha' is 4 chars ✗
 * 'Arjun' is 5 chars ✗
 * 
 * So only 'Raj' matches exactly 3 characters.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 3 — Names with pattern 'J__n' (4 chars, J...n)             │
 * │ Find names like John, Jean, Joan                                   │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  full_name
FROM users
WHERE full_name LIKE 'J__n';

/**
 * Output:
 * +----+-----------+
 * | id | full_name |
 * +----+-----------+
 * | 9  | John Doe  | ← Actually 'John Doe' has space, so not 4 chars
 * | 10 | Jane Doe  | ← Has space, so not 4 chars
 * +----+-----------+
 * 
 * NOTE: 'John Doe' is 8 chars (including space), so doesn't match 'J__n'
 * Pattern 'J__n' would match exactly 4-char names like 'John', 'Jean'
 * Since we don't have such names, output may be empty.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 4 — Finding specific email patterns with underscore        │
 * │ Find emails with pattern: test_ followed by anything               │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email
FROM users
WHERE email LIKE 'test_%';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 2  | test_user1@gmail.com     |
 * | 3  | testXuser2@gmail.com     |
 * +----+--------------------------+
 * 
 * EXPLANATION:
 *   'test_%' means: starts with 'test' followed by EXACTLY 1 character,
 *   then anything after that (%).
 *   'test_' matches: test_user1 (underscore after test) ✓
 *   'testXuser2' (X after test) ✓
 *   Note: 'test' alone would NOT match because need exactly 1 char after
 */

/**
 * 5. ESCAPE CHARACTER — Searching for literal % and _
 *
 * PROBLEM:
 *   What if your data actually contains % or _ characters?
 *   For example: email like 'test_user@gmail.com' has an underscore
 *   But underscore is a wildcard in LIKE!
 *
 * SOLUTION:
 *   Use ESCAPE character to treat wildcards as literal text.
 *   The backslash (\) is the default escape character in many databases.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Find users with actual underscore in email               │
 * │ Pattern: test\_user% (underscore treated as literal)               │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id, 
  email
FROM users
WHERE email LIKE 'test\_user%' ESCAPE '\';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 2  | test_user1@gmail.com     |
 * +----+--------------------------+
 * 
 * EXPLANATION:
 *   Without ESCAPE: 'test_user%' would match 'testXuser' (X as one char)
 *   With ESCAPE: 'test\_user%' treats _ as literal underscore
 *   So only matches emails with actual '_' after 'test'
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Alternative escape character (use any character)         │
 * └────────────────────────────────────────────────────────────────────┘
 */
-- Using '#' as escape character
SELECT 
  id, 
  email
FROM users
WHERE email LIKE 'test#_user%' ESCAPE '#';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 2  | test_user1@gmail.com     |
 * +----+--------------------------+
 * 
 * EXPLANATION:
 *   You can use ANY character as escape character
 *   Just specify it with ESCAPE keyword
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Searching for literal percent sign (%)                   │
 * │ (Hypothetical if data contains %)                                  │
 * └────────────────────────────────────────────────────────────────────┘
 */
-- If a coupon code contains % like 'SAVE%20'
-- WHERE coupon_code LIKE 'SAVE\%20' ESCAPE '\'

/**
 * 6. NOT LIKE — Excluding patterns
 *
 * WHAT IT DOES:
 *   NOT LIKE excludes any rows that match the specified pattern.
 *   Perfect for filtering out test accounts, internal emails, etc.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Exclude all test emails (starting with 'test')         │
 * │ Get real customer data for analysis                                │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id, 
  email, 
  full_name
FROM users
WHERE email NOT LIKE 'test%'
ORDER BY id;

/**
 * Output:
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 1  | raj@tuf.com              | Raj             |
 * | 4  | aayush@company.com       | Aayush          |
 * | 5  | neha@example.com         | Neha            |
 * | 6  | mohit@gmail.com          | Mohit           |
 * | 7  | sara@tuf.com             | Sara            |
 * | 8  | arjun@yahoo.com          | Arjun           |
 * | 9  | john.doe@gmail.com       | John Doe        |
 * | 10 | jane_doe@gmail.com       | Jane Doe        |
 * | 11 | support+trial@tuf.com    | Support Trial   |
 * | 12 | priya@outlook.com        | Priya           |
 * | 13 | sameer@rediffmail.com    | Sameer          |
 * | 14 | emptycity@demo.com       | Empty City      |
 * | 15 | khushi@gmail.com         | Khushi          |
 * | 16 | promo@demo.com           | Promo           |
 * | 17 | intern@tuf.com           | Intern          |
 * | 18 | hello@sample.com         | Hello           |
 * +----+--------------------------+-----------------+
 * 
 * EXPLANATION:
 *   Excludes ids 2 and 3 (test_user1, testXuser2)
 *   All other users are shown
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Exclude demo and test accounts                         │
 * │ Clean data for business reporting                                  │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id, 
  email, 
  full_name
FROM users
WHERE email NOT LIKE '%test%' 
  AND email NOT LIKE '%demo%'
ORDER BY id;

/**
 * Output:
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 1  | raj@tuf.com              | Raj             |
 * | 4  | aayush@company.com       | Aayush          |
 * | 5  | neha@example.com         | Neha            |
 * | 6  | mohit@gmail.com          | Mohit           |
 * | 7  | sara@tuf.com             | Sara            |
 * | 8  | arjun@yahoo.com          | Arjun           |
 * | 9  | john.doe@gmail.com       | John Doe        |
 * | 10 | jane_doe@gmail.com       | Jane Doe        |
 * | 12 | priya@outlook.com        | Priya           |
 * | 13 | sameer@rediffmail.com    | Sameer          |
 * | 15 | khushi@gmail.com         | Khushi          |
 * | 17 | intern@tuf.com           | Intern          |
 * +----+--------------------------+-----------------+
 * 
 * EXPLANATION:
 *   Excludes any email containing 'test' OR 'demo'
 *   This removes test accounts and demo accounts
 */

/**
 * 7. REAL-WORLD SCENARIOS — Practical business use cases
 */

/**
 * SCENARIO 1: Customer Support — Find user by partial name
 * 
 * Support agent knows the name starts with "J" and ends with "e"
 * but doesn't remember the middle. Use pattern matching!
 */
SELECT 
    id, 
    full_name, 
    email
FROM users
WHERE full_name LIKE 'J%e'
ORDER BY full_name;

/**
 * Output:
 * +----+-----------+--------------------------+
 * | id | full_name | email                    |
 * +----+-----------+--------------------------+
 * | 10 | Jane Doe  | jane_doe@gmail.com       |
 * +----+-----------+--------------------------+
 */

/**
 * SCENARIO 2: Marketing Segmentation — Find corporate email users
 * 
 * Identify users with company emails (not Gmail, Yahoo, Outlook)
 * for B2B marketing campaigns.
 */
SELECT 
    full_name,
    email
FROM users
WHERE email NOT LIKE '%gmail.com'
  AND email NOT LIKE '%yahoo.com'
  AND email NOT LIKE '%outlook.com'
  AND email NOT LIKE '%rediffmail.com'
  AND email IS NOT NULL;

/**
 * Output:
 * +-----------------+--------------------------+
 * | full_name       | email                    |
 * +-----------------+--------------------------+
 * | Raj             | raj@tuf.com              |
 * | Aayush          | aayush@company.com       |
 * | Neha            | neha@example.com         |
 * | Sara            | sara@tuf.com             |
 * | Support Trial   | support+trial@tuf.com    |
 * | Empty City      | emptycity@demo.com       |
 * | Promo           | promo@demo.com           |
 * | Intern          | intern@tuf.com           |
 * | Hello           | hello@sample.com         |
 * +-----------------+--------------------------+
 */

/**
 * SCENARIO 3: Data Quality — Find accounts with formatting issues
 * 
 * Find emails with plus signs (+) which might be aliases
 * or have special formatting.
 */
SELECT 
    id,
    email,
    full_name
FROM users
WHERE email LIKE '%+%';

/**
 * Output:
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 11 | support+trial@tuf.com    | Support Trial   |
 * +----+--------------------------+-----------------+
 */

/**
 * SCENARIO 4: Security Audit — Find suspicious account patterns
 * 
 * Find accounts with numeric patterns that might be test/bot accounts.
 */
SELECT 
    id,
    email,
    full_name
FROM users
WHERE email LIKE '%[0-9]%'  -- This pattern may vary by database
   OR full_name LIKE '%[0-9]%';

/**
 * Output (based on actual data):
 * +----+--------------------------+-----------------+
 * | id | email                    | full_name       |
 * +----+--------------------------+-----------------+
 * | 2  | test_user1@gmail.com     | Test User One   |
 * | 3  | testXuser2@gmail.com     | Test User Two   |
 * +----+--------------------------+-----------------+
 * 
 * NOTE: For numeric pattern matching, use regex in some databases:
 *   PostgreSQL: email ~ '[0-9]'
 *   MySQL: email REGEXP '[0-9]'
 */

/**
 * SCENARIO 5: Email Domain Analysis — Group by domain patterns
 * 
 * Categorize users by email domain type for analysis.
 */
SELECT 
    full_name,
    email,
    CASE 
        WHEN email LIKE '%@gmail.com' THEN 'Gmail User'
        WHEN email LIKE '%@yahoo.com' THEN 'Yahoo User'
        WHEN email LIKE '%@tuf.com' THEN 'Company User'
        WHEN email LIKE '%@demo.com' THEN 'Demo Account'
        ELSE 'Other Domain'
    END AS email_type
FROM users
WHERE email IS NOT NULL
ORDER BY email_type;

/**
 * Output:
 * +-----------------+--------------------------+-----------------+
 * | full_name       | email                    | email_type      |
 * +-----------------+--------------------------+-----------------+
 * | Intern          | intern@tuf.com           | Company User    |
 * | Raj             | raj@tuf.com              | Company User    |
 * | Sara            | sara@tuf.com             | Company User    |
 * | Support Trial   | support+trial@tuf.com    | Company User    |
 * | Empty City      | emptycity@demo.com       | Demo Account    |
 * | Promo           | promo@demo.com           | Demo Account    |
 * | Khushi          | khushi@gmail.com         | Gmail User      |
 * | Mohit           | mohit@gmail.com          | Gmail User      |
 * | John Doe        | john.doe@gmail.com       | Gmail User      |
 * | Jane Doe        | jane_doe@gmail.com       | Gmail User      |
 * | Test User One   | test_user1@gmail.com     | Gmail User      |
 * | Test User Two   | testXuser2@gmail.com     | Gmail User      |
 * | Neha            | neha@example.com         | Other Domain    |
 * | Hello           | hello@sample.com         | Other Domain    |
 * | Aayush          | aayush@company.com       | Other Domain    |
 * | Priya           | priya@outlook.com        | Other Domain    |
 * | Sameer          | sameer@rediffmail.com    | Other Domain    |
 * | Arjun           | arjun@yahoo.com          | Yahoo User      |
 * +-----------------+--------------------------+-----------------+
 */

/**
 * SCENARIO 6: Customer Loyalty — Find users with specific coupon patterns
 * 
 * Identify users who used WELCOME or NEWYEAR coupons for segmentation.
 */
SELECT 
    full_name,
    last_coupon_code,
    last_purchase_inr
FROM users
WHERE last_coupon_code LIKE 'WELCOME%'
   OR last_coupon_code LIKE 'NEWYEAR%'
ORDER BY last_purchase_inr DESC;

/**
 * Output:
 * +-----------------+------------------+-------------------+
 * | full_name       | last_coupon_code | last_purchase_inr |
 * +-----------------+------------------+-------------------+
 * | Jane Doe        | WELCOME_BACK     | 1200.00           |
 * | Raj             | WELCOME10        | 999.00            |
 * | Priya           | WELCOME10        | 999.00            |
 * | Intern          | WELCOME_BACK     | 899.00            |
 * | Test User Two   | WELCOME_2026     | 750.00            |
 * | Mohit           | NEWYEAR10        | 299.00            |
 * +-----------------+------------------+-------------------+
 */

/**
 * 8. PERFORMANCE CONSIDERATIONS — Optimization tips
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ PERFORMANCE RANKING (Fastest → Slowest):                          │
 * │                                                                   │
 * │ 1. 'prefix%'    → FAST (can use index)                           │
 * │    WHERE email LIKE 'test%'  ← Can use B-tree index               │
 * │                                                                   │
 * │ 2. '%suffix'    → SLOW (cannot use index efficiently)            │
 * │    WHERE email LIKE '%@gmail.com' ← Must scan all rows            │
 * │                                                                   │
 * │ 3. '%substring%'→ SLOWEST (full table scan)                      │
 * │    WHERE email LIKE '%demo%' ← Always scans entire table          │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * OPTIMIZATION STRATEGIES:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ 1. Use prefix searches when possible:                             │
 * │    ✅ WHERE email LIKE 'john%'                                    │
 * │    ❌ WHERE email LIKE '%john%'                                   │
 * │                                                                   │
 * │ 2. Create indexes on columns used with prefix searches:           │
 * │    CREATE INDEX idx_email ON users(email);                       │
 * │                                                                   │
 * │ 3. For full-text search, use database-specific full-text indexes: │
 * │    PostgreSQL: tsvector, GIN indexes                             │
 * │    MySQL: FULLTEXT indexes                                        │
 * │                                                                   │
 * │ 4. Consider using alternative approaches for complex searches:    │
 * │    → Regular expressions (regex)                                  │
 * │    → Full-text search engines (Elasticsearch, etc.)               │
 * │    → Separate search-optimized tables                             │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 9. COMMON MISTAKES — Pitfalls with pattern matching
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #1 — Case sensitivity                                     │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   In PostgreSQL (case-sensitive):                                 │
 * │   WHERE full_name LIKE 'j%'  → Will NOT match 'John'              │
 * │                                                                    │
 * │   ✅ Fix with ILIKE (PostgreSQL):                                 │
 * │   WHERE full_name ILIKE 'j%'  → Case-insensitive                  │
 * │                                                                    │
 * │   ✅ Fix with LOWER():                                             │
 * │   WHERE LOWER(full_name) LIKE 'j%'                                │
 * │                                                                    │
 * │   In MySQL (case-insensitive by default):                         │
 * │   WHERE full_name LIKE 'j%'  → Will match 'John'                  │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2 — Hidden spaces in patterns                            │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG:                                                        │
 * │   WHERE city LIKE 'Delhi '  ← Has trailing space                  │
 * │   → Won't match 'Delhi' (no trailing space)                       │
 * │                                                                    │
 * │   ✅ CORRECT:                                                      │
 * │   WHERE TRIM(city) LIKE 'Delhi'  ← Trim spaces first              │
 * │   OR use exact pattern: WHERE city LIKE 'Delhi'                   │
 * │                                                                    │
 * │   Always be aware of invisible spaces in your data!               │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3 — Confusing % and _                                    │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   'test%'  → test, testing, test123 (any length after)           │
 * │   'test_'  → test1, testA (exactly ONE character after)          │
 * │                                                                    │
 * │   ❌ Using '_' when you mean '%':                                 │
 * │   WHERE email LIKE 'test_'  → Only matches 'test1', 'testX'       │
 * │   → Misses 'test_user1' because it has more than 1 char after     │
 * │                                                                    │
 * │   ✅ Use '%' for variable length:                                 │
 * │   WHERE email LIKE 'test%'  → Matches all test* emails            │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4 — Forgetting to escape special characters              │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   If your data contains % or _ and you want to match literally:   │
 * │                                                                    │
 * │   ❌ WHERE code LIKE 'SAVE_10'  → Underscore is wildcard          │
 * │   → Matches 'SAVE-10', 'SAVE 10', 'SAVE_10' (underscore)         │
 * │                                                                    │
 * │   ✅ WHERE code LIKE 'SAVE\_10' ESCAPE '\' → Only matches '_'     │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5 — Using LIKE on NULL values                            │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   LIKE does NOT match NULL values:                                │
 * │   WHERE last_coupon_code LIKE '%WELCOME%'                         │
 * │   → NULL coupons are excluded (they are unknown)                  │
 * │                                                                    │
 * │   ✅ To include NULLs, handle separately:                         │
 * │   WHERE last_coupon_code LIKE '%WELCOME%'                         │
 * │      OR last_coupon_code IS NULL                                  │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #6 — Performance impact of leading wildcard               │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ SLOW (full table scan):                                      │
 * │   WHERE email LIKE '%gmail.com'                                   │
 * │   → Cannot use index, scans every row                            │
 * │                                                                    │
 * │   ✅ FASTER (can use index):                                      │
 * │   WHERE email LIKE 'john%'                                        │
 * │   → Can use B-tree index for prefix search                        │
 * │                                                                    │
 * │   For suffix searches, consider storing reversed strings:         │
 * │   CREATE INDEX idx_email_reverse ON users(REVERSE(email));        │
 * │   WHERE REVERSE(email) LIKE REVERSE('@gmail.com') || '%'          │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 10. QUICK REFERENCE — Cheat sheet
 *
 * BASIC PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ 'pattern%'     → Starts with pattern                              │
 * │ '%pattern'     → Ends with pattern                                │
 * │ '%pattern%'    → Contains pattern anywhere                        │
 * │ 'p_ttern'      → _ matches exactly one character                  │
 * │ 'p__tern'      → Two underscores = exactly 2 chars                │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * COMMON USE CASES:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Email domains                                                  │
 * │ WHERE email LIKE '%@gmail.com'    → Gmail users                   │
 * │ WHERE email NOT LIKE '%@company.com' → External users             │
 * │                                                                   │
 * │ -- Name searches                                                  │
 * │ WHERE full_name LIKE 'J%'          → Names starting with J        │
 * │ WHERE full_name LIKE '%son'        → Names ending with "son"      │
 * │ WHERE full_name LIKE 'J%n'         → Starts J, ends n             │
 * │                                                                   │
 * │ -- Exact length                                                   │
 * │ WHERE full_name LIKE '___'         → Exactly 3 characters         │
 * │ WHERE full_name LIKE 'J__n'        → 4 chars: J..n                │
 * │                                                                   │
 * │ -- Excluding patterns                                             │
 * │ WHERE email NOT LIKE '%test%'      → Exclude test accounts        │
 * │ WHERE email NOT LIKE '%@spam.com'  → Exclude spam domains         │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * ESCAPE CHARACTERS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Escape underscore                                              │
 * │ WHERE code LIKE 'test\_user%' ESCAPE '\'                          │
 * │                                                                   │
 * │ -- Escape percent                                                 │
 * │ WHERE discount LIKE '20\%%' ESCAPE '\'                            │
 * │                                                                   │
 * │ -- Custom escape character                                        │
 * │ WHERE code LIKE 'test#_user%' ESCAPE '#'                          │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * DATABASE-SPECIFIC VARIATIONS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ PostgreSQL:                                                       │
 * │   ILIKE for case-insensitive: full_name ILIKE 'j%'                │
 * │   ~ for regex: email ~ '.*@gmail\.com'                           │
 * │                                                                   │
 * │ MySQL:                                                            │
 * │   LIKE is case-insensitive by default                             │
 * │   REGEXP for regex: email REGEXP '.*@gmail\\.com'                │
 * │   BINARY for case-sensitive: full_name LIKE BINARY 'J%'          │
 * └────────────────────────────────────────────────────────────────────┘
 */
