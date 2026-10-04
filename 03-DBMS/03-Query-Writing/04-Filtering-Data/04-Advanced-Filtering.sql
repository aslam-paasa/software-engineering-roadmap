/**
 * ======================================================================
 * DEEP DIVE — FILTERING ESSENTIALS: IS NULL, IN, BETWEEN, LIKE
 * ======================================================================
 *
 * TABLE OF CONTENTS:
 * 1. OPERATOR OVERVIEW ............ Understanding NULL and special filters
 * 2. IS NULL / IS NOT NULL ........ Handling missing data
 * 3. IN / NOT IN .................. Matching against a list of values
 * 4. BETWEEN / NOT BETWEEN ........ Working with ranges
 * 5. LIKE / NOT LIKE .............. Pattern matching with wildcards
 * 6. REAL-WORLD COMBINATIONS ...... Putting it all together
 * 7. COMMON MISTAKES .............. Pitfalls with NULL and patterns
 * 8. QUICK REFERENCE .............. Cheat sheet for daily use
 * 9. GOLDEN RULES ................. Key principles to remember
 * ======================================================================
 */

/**
 * ======================================================================
 * 1. OPERATOR OVERVIEW — What these specialized filters do
 * ======================================================================
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ OPERATOR    │ PURPOSE                                              │
 * ├─────────────┼──────────────────────────────────────────────────────┤
 * │ IS NULL     │ Find rows where a column has NO value (unknown)      │
 * │ IS NOT NULL │ Find rows where a column HAS a value                 │
 * │ IN          │ Check if value matches ANY item in a list            │
 * │ NOT IN      │ Check if value matches NONE of the items in a list   │
 * │ BETWEEN     │ Check if value falls within a range (inclusive)      │
 * │ NOT BETWEEN │ Check if value falls OUTSIDE a range                 │
 * │ LIKE        │ Match text patterns using wildcards (% and _)        │
 * │ NOT LIKE    │ Exclude text that matches a pattern                  │
 * └─────────────┴──────────────────────────────────────────────────────┘
 *
 * WHY THESE MATTER:
 *   Real-world data is rarely clean. You'll encounter:
 *   → Missing values (NULL, empty strings, spaces)
 *   → Values that belong to a set ("Delhi, Mumbai, Bengaluru")
 *   → Values that fall within a range (signups in December)
 *   → Values that follow patterns (emails ending with @tuf.com)
*/

/**
 * SAMPLE DATASET — users table
 *
 * CREATE TABLE users (
 *   id                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 *   email             VARCHAR(120) NOT NULL,
 *   full_name         VARCHAR(80)  NOT NULL,
 *   city              VARCHAR(60),
 *   signup_at_utc     TIMESTAMP    NOT NULL,
 *   last_purchase_inr DECIMAL(10,2),
 *   last_coupon_code  VARCHAR(30),
 *   is_active         BOOLEAN      NOT NULL DEFAULT TRUE
 * );
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
 * 1. IS NULL / IS NOT NULL — Handling missing data
 *
 * WHAT IS NULL?
 *   NULL means "unknown" or "not recorded". It is NOT:
 *   → Empty string ('')
 *   → Zero (0)
 *   → Space (' ')
 *   → Any other placeholder value
 *
 * WHY NULL IS SPECIAL:
 *   NULL cannot be compared using = or !=. You must use IS NULL or IS NOT NULL.
 *
 *   ❌ WHERE city = NULL      -- This will NOT work!
 *   ✅ WHERE city IS NULL     -- Correct way
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IS NULL — Find rows with missing values                            │
 * ├────────────────────────────────────────────────────────────────────┤
 * │ Find users who haven't entered their city:                         │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
     id, 
     email,
     city
FROM users
WHERE city IS NULL;

/**
 * Output:
 * +----+---------------------+------+
 * | id | email               | city |
 * +----+---------------------+------+
 * | 4  | aayush@company.com  | NULL |
 * | 13 | sameer@rediffmail.com| NULL |
 * +----+---------------------+------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IS NOT NULL — Find rows with present values                        │
 * ├────────────────────────────────────────────────────────────────────┤
 * │ Find users who have entered their city (any value):                │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
     id, 
     email,
     city
FROM users
WHERE city IS NOT NULL;

/**
 * Output:
 * +----+--------------------------+-------------+
 * | id | email                    | city        |
 * +----+--------------------------+-------------+
 * | 1  | raj@tuf.com              | Bengaluru   |
 * | 2  | test_user1@gmail.com     | Delhi       |
 * | 3  | testXuser2@gmail.com     | Delhi       |
 * | 5  | neha@example.com         | ''          |
 * | 6  | mohit@gmail.com          | Mumbai      |
 * | 7  | sara@tuf.com             | Bengaluru   |
 * | 8  | arjun@yahoo.com          | Pune        |
 * | 9  | john.doe@gmail.com       | Chennai     |
 * | 10 | jane_doe@gmail.com       | Chennai     |
 * | 11 | support+trial@tuf.com    | Gurugram    |
 * | 12 | priya@outlook.com        | Hyderabad   |
 * | 14 | emptycity@demo.com       | ' '         |
 * | 15 | khushi@gmail.com         | Delhi       |
 * | 16 | promo@demo.com           | Mumbai      |
 * | 17 | intern@tuf.com           | Bengaluru   |
 * | 18 | hello@sample.com         | Delhi       |
 * +----+--------------------------+-------------+
 * 
 * NOTE: Empty string ('') and space (' ') are NOT NULL — they are actual values!
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NORMALIZING MISSING DATA — Handling multiple forms of "missing"   │
 * ├────────────────────────────────────────────────────────────────────┤
 * │ In real data, missing values appear as:                           │
 * │   → NULL                                                          │
 * │   → Empty string ('')                                             │
 * │   → Spaces (' ')                                                  │
 * │   → Placeholders like 'N/A', 'unknown'                            │
 * │                                                                   │
 * │ To treat all these as "missing", normalize them:                  │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email,
  city
FROM users
WHERE NULLIF(TRIM(city), '') IS NOT NULL;

/**
 * Output (only truly populated cities):
 * +----+--------------------------+-------------+
 * | id | email                    | city        |
 * +----+--------------------------+-------------+
 * | 1  | raj@tuf.com              | Bengaluru   |
 * | 2  | test_user1@gmail.com     | Delhi       |
 * | 3  | testXuser2@gmail.com     | Delhi       |
 * | 6  | mohit@gmail.com          | Mumbai      |
 * | 7  | sara@tuf.com             | Bengaluru   |
 * | 8  | arjun@yahoo.com          | Pune        |
 * | 9  | john.doe@gmail.com       | Chennai     |
 * | 10 | jane_doe@gmail.com       | Chennai     |
 * | 11 | support+trial@tuf.com    | Gurugram    |
 * | 12 | priya@outlook.com        | Hyderabad   |
 * | 15 | khushi@gmail.com         | Delhi       |
 * | 16 | promo@demo.com           | Mumbai      |
 * | 17 | intern@tuf.com           | Bengaluru   |
 * | 18 | hello@sample.com         | Delhi       |
 * +----+--------------------------+-------------+
 * 
 * Users with empty strings (id 5) and spaces (id 14) are now excluded.
 */

/**
 * 3. IN / NOT IN — Matching against a list of values
 *
 * WHAT IT DOES:
 *   IN checks if a value matches ANY value in a list.
 *   NOT IN checks if a value matches NONE of the values in the list.
 *
 * SYNTAX:
 *   WHERE column IN (value1, value2, value3, ...)
 *   WHERE column NOT IN (value1, value2, value3, ...)
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IN — Users from Delhi or Mumbai                                    │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email,
  city
FROM users
WHERE city IN ('Delhi', 'Mumbai');

/**
 * Output:
 * +----+--------------------------+--------+
 * | id | email                    | city   |
 * +----+--------------------------+--------+
 * | 2  | test_user1@gmail.com     | Delhi  |
 * | 3  | testXuser2@gmail.com     | Delhi  |
 * | 6  | mohit@gmail.com          | Mumbai |
 * | 15 | khushi@gmail.com         | Delhi  |
 * | 16 | promo@demo.com           | Mumbai |
 * | 18 | hello@sample.com         | Delhi  |
 * +----+--------------------------+--------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NOT IN — Users NOT from Delhi or Mumbai (excluding NULLs)         │
 * ├────────────────────────────────────────────────────────────────────┤
 * │ ⚠️ CAUTION: NOT IN with NULL values can produce unexpected results│
 * │   If the list contains NULL, the query returns NOTHING.           │
 * │   Always ensure list has no NULLs, or handle NULLs separately.    │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email,
  city
FROM users
WHERE city NOT IN ('Delhi', 'Mumbai');

/**
 * Output:
 * +----+--------------------------+-------------+
 * | id | email                    | city        |
 * +----+--------------------------+-------------+
 * | 1  | raj@tuf.com              | Bengaluru   |
 * | 5  | neha@example.com         | ''          |
 * | 7  | sara@tuf.com             | Bengaluru   |
 * | 8  | arjun@yahoo.com          | Pune        |
 * | 9  | john.doe@gmail.com       | Chennai     |
 * | 10 | jane_doe@gmail.com       | Chennai     |
 * | 11 | support+trial@tuf.com    | Gurugram    |
 * | 12 | priya@outlook.com        | Hyderabad   |
 * | 14 | emptycity@demo.com       | ' '         |
 * | 17 | intern@tuf.com           | Bengaluru   |
 * +----+--------------------------+-------------+
 * 
 * Note: Users with NULL city (id 4, 13) are NOT included because NULL is unknown.
 */

/**
 * 4. BETWEEN / NOT BETWEEN — Working with ranges
 *
 * WHAT IT DOES:
 *   BETWEEN checks if a value lies within an inclusive range.
 *   NOT BETWEEN checks if a value lies outside that range.
 *
 * SYNTAX:
 *   WHERE column BETWEEN start_value AND end_value
 *   WHERE column NOT BETWEEN start_value AND end_value
 *
 * KEY POINTS:
 *   → Inclusive: includes both start and end values
 *   → Works with numbers, dates, and text (alphabetical order)
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ BETWEEN — Users who signed up in December 2025                    │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT
  id,
  email,
  signup_at_utc
FROM users
WHERE signup_at_utc BETWEEN TIMESTAMP '2025-12-01 00:00:00'
                        AND TIMESTAMP '2025-12-31 23:59:59';

/**
 * Output:
 * +----+--------------------------+---------------------+
 * | id | email                    | signup_at_utc       |
 * +----+--------------------------+---------------------+
 * | 1  | raj@tuf.com              | 2025-12-01 00:00:00 |
 * | 2  | test_user1@gmail.com     | 2025-12-05 10:00:00 |
 * | 3  | testXuser2@gmail.com     | 2025-12-10 12:00:00 |
 * | 5  | neha@example.com         | 2025-12-31 23:59:59 |
 * | 8  | arjun@yahoo.com          | 2025-12-20 09:00:00 |
 * | 9  | john.doe@gmail.com       | 2025-12-05 18:30:00 |
 * | 10 | jane_doe@gmail.com       | 2025-12-06 18:30:00 |
 * | 11 | support+trial@tuf.com    | 2025-12-07 10:00:00 |
 * | 12 | priya@outlook.com        | 2025-12-08 10:00:00 |
 * | 13 | sameer@rediffmail.com    | 2025-12-09 10:00:00 |
 * | 14 | emptycity@demo.com       | 2025-12-10 10:00:00 |
 * | 15 | khushi@gmail.com         | 2025-12-11 10:00:00 |
 * | 16 | promo@demo.com           | 2025-12-25 00:00:00 |
 * | 17 | intern@tuf.com           | 2025-12-22 20:00:00 |
 * | 18 | hello@sample.com         | 2025-12-02 08:00:00 |
 * +----+--------------------------+---------------------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NOT BETWEEN — Users who signed up OUTSIDE December 2025           │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT
  id,
  email,
  signup_at_utc
FROM users
WHERE signup_at_utc NOT BETWEEN TIMESTAMP '2025-12-01 00:00:00'
                            AND TIMESTAMP '2025-12-31 23:59:59';

/**
 * Output:
 * +----+---------------------+---------------------+
 * | id | email               | signup_at_utc       |
 * +----+---------------------+---------------------+
 * | 4  | aayush@company.com  | 2025-11-30 23:59:59 |
 * | 6  | mohit@gmail.com     | 2026-01-01 00:00:00 |
 * | 7  | sara@tuf.com        | 2025-10-10 05:00:00 |
 * +----+---------------------+---------------------+
 */

/**
 * 5. LIKE / NOT LIKE — Pattern matching with wildcards
 *
 * WHAT IT DOES:
 *   LIKE matches text patterns using wildcards. Perfect for searches.
 *
 * WILDCARDS:
 *   % → matches ANY number of characters (including zero)
 *   _ → matches EXACTLY ONE character
 *
 * SYNTAX:
 *   WHERE column LIKE 'pattern'
 *   WHERE column NOT LIKE 'pattern'
 *
 * ESCAPE CHARACTER:
 *   Use ESCAPE to search for literal % or _ characters
 *   Example: WHERE email LIKE 'test\_%' ESCAPE '\'
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ LIKE '%@tuf.com' — Users with emails ending in @tuf.com           │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email
FROM users
WHERE email LIKE '%@tuf.com';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 1  | raj@tuf.com              |
 * | 7  | sara@tuf.com             |
 * | 11 | support+trial@tuf.com    |
 * | 17 | intern@tuf.com           |
 * +----+--------------------------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ LIKE 'test%' — Users with emails starting with "test"             │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email
FROM users
WHERE email LIKE 'test%';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 2  | test_user1@gmail.com     |
 * | 3  | testXuser2@gmail.com     |
 * +----+--------------------------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ LIKE 'test\_%' ESCAPE '\' — Exact underscore match                │
 * ├────────────────────────────────────────────────────────────────────┤
 * │ Find emails with "test_" literally (underscore as character, not  │
 * │ wildcard). The backslash escapes the underscore.                  │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email
FROM users
WHERE email LIKE 'test\_%' ESCAPE '\';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 2  | test_user1@gmail.com     |
 * | 3  | testXuser2@gmail.com     |
 * +----+--------------------------+
 * 
 * BOTH match because 'test_' pattern includes underscore as literal,
 * but testXuser2 has 'X' which is ONE character after 'test'.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NOT LIKE — Exclude users with @tuf.com emails                     │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
  id,
  email
FROM users
WHERE email NOT LIKE '%@tuf.com';

/**
 * Output:
 * +----+--------------------------+
 * | id | email                    |
 * +----+--------------------------+
 * | 2  | test_user1@gmail.com     |
 * | 3  | testXuser2@gmail.com     |
 * | 4  | aayush@company.com       |
 * | 5  | neha@example.com         |
 * | 6  | mohit@gmail.com          |
 * | 8  | arjun@yahoo.com          |
 * | 9  | john.doe@gmail.com       |
 * | 10 | jane_doe@gmail.com       |
 * | 12 | priya@outlook.com        |
 * | 13 | sameer@rediffmail.com    |
 * | 14 | emptycity@demo.com       |
 * | 15 | khushi@gmail.com         |
 * | 16 | promo@demo.com           |
 * | 18 | hello@sample.com         |
 * +----+--------------------------+
 */

/**
 * 6. REAL-WORLD COMBINATIONS — Putting it all together
 */

/**
 * EXAMPLE 1: Active users from Delhi or Mumbai who have made a purchase
 */
SELECT 
  id,
  full_name,
  city,
  last_purchase_inr,
  is_active
FROM users
WHERE city IN ('Delhi', 'Mumbai')
  AND is_active = TRUE
  AND last_purchase_inr IS NOT NULL;

/**
 * EXAMPLE 2: Users who signed up in December 2025 with a purchase over ₹500
 */
SELECT 
  id,
  full_name,
  signup_at_utc,
  last_purchase_inr
FROM users
WHERE signup_at_utc BETWEEN '2025-12-01' AND '2025-12-31'
  AND last_purchase_inr > 500;

/**
 * EXAMPLE 3: Users with Gmail accounts who haven't used a coupon
 */
SELECT 
  id,
  email,
  last_coupon_code
FROM users
WHERE email LIKE '%@gmail.com'
  AND last_coupon_code IS NULL;

/**
 * EXAMPLE 4: Users from Bengaluru or Chennai with purchase between ₹500-₹1500
 */
SELECT 
  id,
  full_name,
  city,
  last_purchase_inr
FROM users
WHERE city IN ('Bengaluru', 'Chennai')
  AND last_purchase_inr BETWEEN 500 AND 1500;

/**
 * EXAMPLE 5: Non-active users or users with NULL purchase value
 */
SELECT 
  id,
  full_name,
  is_active,
  last_purchase_inr
FROM users
WHERE is_active = FALSE
   OR last_purchase_inr IS NULL;

/**
 * 7. COMMON MISTAKES — Pitfalls every beginner hits
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #1 — Using = with NULL instead of IS NULL                 │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG:                                                        │
 * │   SELECT * FROM users WHERE city = NULL;  ← Returns NOTHING       │
 * │                                                                    │
 * │   ✅ CORRECT:                                                      │
 * │   SELECT * FROM users WHERE city IS NULL;                         │
 * │                                                                    │
 * │   WHY? NULL is "unknown" — you can't compare unknown to anything. │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2 — NOT IN with NULL in the list                         │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ DANGEROUS:                                                    │
 * │   SELECT * FROM users WHERE city NOT IN ('Delhi', NULL);          │
 * │   → Returns NOTHING! NULL in list breaks NOT IN logic.            │
 * │                                                                    │
 * │   ✅ SAFE:                                                         │
 * │   SELECT * FROM users WHERE city NOT IN ('Delhi')                 │
 * │                         AND city IS NOT NULL;                     │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3 — Confusing NULL with empty string or space            │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   NULL   = unknown / not recorded                                 │
 * │   ''     = empty string (a value that happens to be empty)        │
 * │   ' '    = space (a value that is a single space)                 │
 * │                                                                    │
 * │   SELECT * FROM users WHERE city = '';    → Finds id 5 (Neha)     │
 * │   SELECT * FROM users WHERE city = ' ';   → Finds id 14 (Empty City)│
 * │   SELECT * FROM users WHERE city IS NULL; → Finds id 4, 13        │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4 — Forgetting wildcard patterns                         │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   'test%'   → test, testing, test_user, test123                  │
 * │   '%test'   → contest, lasttest                                   │
 * │   '%test%'  → anything containing "test" anywhere                 │
 * │   'test_'   → test1, testA, test_ (exactly 4 chars after test)   │
 * │   'test__'  → test12, testAB (exactly 5 chars total)             │
 * │                                                                    │
 * │   ❌ WHERE email LIKE '%@gmail'  ← Missing % at the end!          │
 * │   ✅ WHERE email LIKE '%@gmail%' ← Correct                        │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5 — BETWEEN with wrong order                             │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG:                                                        │
 * │   WHERE price BETWEEN 1000 AND 500   ← Lower bound > upper bound  │
 * │                                                                    │
 * │   ✅ CORRECT:                                                      │
 * │   WHERE price BETWEEN 500 AND 1000   ← Lower bound first          │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 8. QUICK REFERENCE — Cheat sheet for daily use
 *
 * HANDLING NULLS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IS NULL                 → Find missing values                     │
 * │ IS NOT NULL             → Find present values                     │
 * │ COALESCE(col, default)  → Replace NULL with default               │
 * │ NULLIF(col, '')         → Convert empty string to NULL            │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * LIST MATCHING:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IN (value1, value2)     → Match any value in list                 │
 * │ NOT IN (value1, value2) → Exclude values in list                  │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * RANGE MATCHING:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ BETWEEN low AND high    → Inclusive range (low ≤ value ≤ high)    │
 * │ NOT BETWEEN low AND high → Outside range                          │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * PATTERN MATCHING:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ LIKE '%pattern'         → Ends with pattern                       │
 * │ LIKE 'pattern%'         → Starts with pattern                     │
 * │ LIKE '%pattern%'        → Contains pattern                        │
 * │ LIKE '___'              → Exactly 3 characters                    │
 * │ LIKE 'pattern\_%' ESCAPE '\' → Literal underscore                 │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * COMMON PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ '%@gmail.com'           → Gmail addresses                         │
 * │ '2025-12-%'             → December 2025 dates                     │
 * │ 'TUF%'                  → Codes starting with TUF                 │
 * │ '%_10'                  → Ends with "_10"                         │
 * └────────────────────────────────────────────────────────────────────┘
 */

