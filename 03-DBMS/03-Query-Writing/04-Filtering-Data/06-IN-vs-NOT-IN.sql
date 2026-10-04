/**
 * ======================================================================
 * FILE B: IN vs NOT IN — Matching Against Lists
 * ======================================================================
 *
 * DEEP DIVE — List-Based Filtering in SQL
 * ======================================================================
 *
 * TABLE OF CONTENTS:
 * 1. IN OPERATOR ................... Matching values in a list
 * 2. NOT IN OPERATOR ............... Excluding values in a list
 * 3. IN vs OR ...................... Performance and readability comparison
 * 4. REAL-WORLD SCENARIOS .......... Practical business use cases
 * 5. THE NULL TRAP ................. Critical pitfall with NOT IN
 * 6. WORKING WITH SUBQUERIES ....... Advanced list filtering
 * 7. COMMON MISTAKES ............... Pitfalls with IN and NOT IN
 * 8. QUICK REFERENCE ............... Cheat sheet
 * 9. GOLDEN RULES .................. Key principles to remember
 * ======================================================================
 */

/**
 * ======================================================================
 * SAMPLE TABLE — users
 * ======================================================================
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
 * ======================================================================
 * 1. IN OPERATOR — Matching values in a list
 * ======================================================================
 *
 * WHAT IT DOES:
 *   IN checks if a value matches ANY value from a specific list.
 *   It's a cleaner, more readable alternative to multiple OR conditions.
 *
 * SYNTAX:
 *   WHERE column IN (value1, value2, value3, ...)
 *
 * EQUIVALENT TO:
 *   WHERE column = value1 OR column = value2 OR column = value3
 *
 * ADVANTAGES:
 *   → More readable and concise
 *   → Easier to maintain (add/remove values from list)
 *   → Often better performance (database can optimize)
 *   → Works with subqueries
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Find users located in Delhi or Mumbai                 │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    id,
    full_name,
    city
FROM users
WHERE city IN ('Delhi', 'Mumbai');

/**
 * Output:
 * +----+-----------------+--------+
 * | id | full_name       | city   |
 * +----+-----------------+--------+
 * | 2  | Test User One   | Delhi  |
 * | 3  | Test User Two   | Delhi  |
 * | 6  | Mohit           | Mumbai |
 * | 15 | Khushi          | Delhi  |
 * | 16 | Promo           | Mumbai |
 * | 18 | Hello           | Delhi  |
 * +----+-----------------+--------+
 * 
 * EXPLANATION:
 *   This is equivalent to:
 *   WHERE city = 'Delhi' OR city = 'Mumbai'
 *   But much shorter and easier to read!
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Find users in multiple cities (complex list)          │
 * │ Find users in major technology hubs                               │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name, 
    city,
    email
FROM users
WHERE city IN ('Bengaluru', 'Gurugram', 'Hyderabad', 'Pune', 'Chennai');

/**
 * Output:
 * +-----------------+-------------+--------------------------+
 * | full_name       | city        | email                    |
 * +-----------------+-------------+--------------------------+
 * | Raj             | Bengaluru   | raj@tuf.com              |
 * | Sara            | Bengaluru   | sara@tuf.com             |
 * | Arjun           | Pune        | arjun@yahoo.com          |
 * | John Doe        | Chennai     | john.doe@gmail.com       |
 * | Jane Doe        | Chennai     | jane_doe@gmail.com       |
 * | Support Trial   | Gurugram    | support+trial@tuf.com    |
 * | Priya           | Hyderabad   | priya@outlook.com        |
 * | Intern          | Bengaluru   | intern@tuf.com           |
 * +-----------------+-------------+--------------------------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 3 — IN with numeric values                                │
 * │ Find users with specific purchase amounts                         │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    last_purchase_inr
FROM users
WHERE last_purchase_inr IN (499.00, 999.00, 1499.00);

/**
 * Output:
 * +-----------------+-------------------+
 * | full_name       | last_purchase_inr |
 * +-----------------+-------------------+
 * | Raj             | 999.00            |
 * | Test User One   | 499.00            |
 * | Priya           | 999.00            |
 * | Empty City      | 499.00            |
 * | Promo           | 1499.00           |
 * +-----------------+-------------------+
 */

/**
 * ======================================================================
 * 2. NOT IN OPERATOR — Excluding values from a list
 * ======================================================================
 *
 * WHAT IT DOES:
 *   NOT IN checks if a value matches NONE of the values in the list.
 *   Useful when you want to exclude specific categories or values.
 *
 * SYNTAX:
 *   WHERE column NOT IN (value1, value2, value3, ...)
 *
 * EQUIVALENT TO:
 *   WHERE column != value1 AND column != value2 AND column != value3
 *
 * ⚠️ CRITICAL WARNING:
 *   If the list contains a NULL, NOT IN returns NO rows!
 *   This is known as the "NULL Trap" (covered in detail later).
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Find users who are NOT from Delhi or Mumbai           │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    id,
    full_name,
    city
FROM users
WHERE city NOT IN ('Delhi', 'Mumbai');

/**
 * Output:
 * +----+-----------------+-------------+
 * | id | full_name       | city        |
 * +----+-----------------+-------------+
 * | 1  | Raj             | Bengaluru   |
 * | 5  | Neha            | ''          |
 * | 7  | Sara            | Bengaluru   |
 * | 8  | Arjun           | Pune        |
 * | 9  | John Doe        | Chennai     |
 * | 10 | Jane Doe        | Chennai     |
 * | 11 | Support Trial   | Gurugram    |
 * | 12 | Priya           | Hyderabad   |
 * | 14 | Empty City      | ' '         |
 * | 17 | Intern          | Bengaluru   |
 * +----+-----------------+-------------+
 * 
 * EXPLANATION:
 *   Returns all users whose city is NOT 'Delhi' or 'Mumbai'.
 *   Note: Users with NULL city (id 4, 13) are NOT included because
 *   NULL is unknown — the database can't guarantee it's not in the list.
 *   This is the NULL trap in action!
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — NOT IN with numeric values                            │
 * │ Find users who didn't purchase common amounts                     │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    last_purchase_inr
FROM users
WHERE last_purchase_inr NOT IN (299.00, 499.00, 999.00);

/**
 * Output:
 * +-----------------+-------------------+
 * | full_name       | last_purchase_inr |
 * +-----------------+-------------------+
 * | Test User Two   | 750.00            |
 * | Neha            | 1500.00           |
 * | Sara            | 2000.00           |
 * | Arjun           | 799.00            |
 * | John Doe        | 300.00            |
 * | Jane Doe        | 1200.00           |
 * | Sameer          | 100.00            |
 * | Khushi          | 500.00            |
 * | Promo           | 1499.00           |
 * | Intern          | 899.00            |
 * +-----------------+-------------------+
 * 
 * EXPLANATION:
 *   Returns users whose purchase amount is NOT 299, 499, or 999.
 *   Note: Users with NULL purchase are excluded (NULL is unknown).
 */

/**
 * ======================================================================
 * 3. IN vs OR — Performance and readability comparison
 * ======================================================================
 *
 * READABILITY COMPARISON:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ USING OR (Hard to read):                                          │
 * │   WHERE city = 'Delhi'                                            │
 * │      OR city = 'Mumbai'                                           │
 * │      OR city = 'Bengaluru'                                        │
 * │      OR city = 'Chennai'                                          │
 * │      OR city = 'Hyderabad'                                        │
 * │                                                                   │
 * │ USING IN (Clean and readable):                                    │
 * │   WHERE city IN ('Delhi', 'Mumbai', 'Bengaluru',                  │
 * │                  'Chennai', 'Hyderabad')                          │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * PERFORMANCE:
 *   Modern databases optimize IN and OR similarly.
 *   However, IN is often better because:
 *   → Database can optimize the list as a single operation
 *   → Easier for the query planner to create efficient execution plans
 *   → With large lists, IN can be significantly faster
 *
 * WHEN TO USE EACH:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ Use IN when:                                                      │
 *   → Checking against a list of 3+ values                           │
 *   → List is static or from a subquery                              │
 *   → Readability is important                                       │
 *                                                                     │
 * │ Use OR when:                                                      │
 *   → Checking only 2 values                                          │
 *   → Different columns (city = 'Delhi' OR country = 'India')        │
 *   → Complex conditions with AND/OR mixing                          │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ======================================================================
 * 4. REAL-WORLD SCENARIOS — Practical business use cases
 * ======================================================================
 */

/**
 * SCENARIO 1: Regional Campaign — Tier 1 cities
 * 
 * Find active users in top metropolitan cities for a
 * regional promotional campaign.
 */
SELECT 
    full_name, 
    email, 
    city,
    last_purchase_inr
FROM users
WHERE city IN ('Delhi', 'Mumbai', 'Bengaluru', 'Chennai', 'Hyderabad')
  AND is_active = TRUE
  AND last_purchase_inr IS NOT NULL
ORDER BY last_purchase_inr DESC;

/**
 * Output:
 * +-----------------+--------------------------+-----------+-------------------+
 * | full_name       | email                    | city      | last_purchase_inr |
 * +-----------------+--------------------------+-----------+-------------------+
 * | Sara            | sara@tuf.com             | Bengaluru | 2000.00           |
 * | Jane Doe        | jane_doe@gmail.com       | Chennai   | 1200.00           |
 * | Raj             | raj@tuf.com              | Bengaluru | 999.00            |
 * | Priya           | priya@outlook.com        | Hyderabad | 999.00            |
 * | Intern          | intern@tuf.com           | Bengaluru | 899.00            |
 * | Test User Two   | testXuser2@gmail.com     | Delhi     | 750.00            |
 * | Khushi          | khushi@gmail.com         | Delhi     | 500.00            |
 * | Test User One   | test_user1@gmail.com     | Delhi     | 499.00            |
 * | John Doe        | john.doe@gmail.com       | Chennai   | 300.00            |
 * | Mohit           | mohit@gmail.com          | Mumbai    | 299.00            |
 * +-----------------+--------------------------+-----------+-------------------+
 */

/**
 * SCENARIO 2: Exclude Test Accounts
 * 
 * Get real customer data by excluding test and demo accounts.
 */
SELECT 
    full_name,
    email,
    city,
    last_purchase_inr
FROM users
WHERE email NOT LIKE '%test%'
  AND email NOT LIKE '%demo%'
  AND city IS NOT NULL
  AND NULLIF(TRIM(city), '') IS NOT NULL
ORDER BY last_purchase_inr DESC NULLS LAST;

/**
 * Output:
 * +-----------+--------------------------+-----------+-------------------+
 * | full_name | email                    | city      | last_purchase_inr |
 * +-----------+--------------------------+-----------+-------------------+
 * | Sara      | sara@tuf.com             | Bengaluru | 2000.00           |
 * | Neha      | neha@example.com         | ''        | 1500.00           |
 * | Jane Doe  | jane_doe@gmail.com       | Chennai   | 1200.00           |
 * | Raj       | raj@tuf.com              | Bengaluru | 999.00            |
 * | Priya     | priya@outlook.com        | Hyderabad | 999.00            |
 * | Intern    | intern@tuf.com           | Bengaluru | 899.00            |
 * | Arjun     | arjun@yahoo.com          | Pune      | 799.00            |
 * | Khushi    | khushi@gmail.com         | Delhi     | 500.00            |
 * | Mohit     | mohit@gmail.com          | Mumbai    | 299.00            |
 * | John Doe  | john.doe@gmail.com       | Chennai   | 300.00            |
 * +-----------+--------------------------+-----------+-------------------+
 */

/**
 * SCENARIO 3: Specific Coupon Users Analysis
 * 
 * Analyze users who used specific high-value coupons.
 */
SELECT 
    full_name,
    email,
    last_coupon_code,
    last_purchase_inr
FROM users
WHERE last_coupon_code IN ('WELCOME10', 'WELCOME_BACK', 'TUF_50')
  AND last_purchase_inr > 500
ORDER BY last_purchase_inr DESC;

/**
 * Output:
 * +-----------+--------------------------+------------------+-------------------+
 * | full_name | email                    | last_coupon_code | last_purchase_inr |
 * +-----------+--------------------------+------------------+-------------------+
 * | Jane Doe  | jane_doe@gmail.com       | WELCOME_BACK     | 1200.00           |
 * | Raj       | raj@tuf.com              | WELCOME10        | 999.00            |
 * | Priya     | priya@outlook.com        | WELCOME10        | 999.00            |
 * | Intern    | intern@tuf.com           | WELCOME_BACK     | 899.00            |
 * | Promo     | promo@demo.com           | TUF_50           | 1499.00           |
 * +-----------+--------------------------+------------------+-------------------+
 */

/**
 * SCENARIO 4: Exclude Low-Value Cities
 * 
 * Find users not from cities with low engagement for premium offers.
 */
SELECT 
    full_name,
    email,
    city,
    last_purchase_inr
FROM users
WHERE city NOT IN ('', ' ', NULL)
  AND last_purchase_inr > 1000
ORDER BY last_purchase_inr DESC;

/**
 * Output:
 * +-----------+--------------------------+-----------+-------------------+
 * | full_name | email                    | city      | last_purchase_inr |
 * +-----------+--------------------------+-----------+-------------------+
 * | Sara      | sara@tuf.com             | Bengaluru | 2000.00           |
 * | Jane Doe  | jane_doe@gmail.com       | Chennai   | 1200.00           |
 * +-----------+--------------------------+-----------+-------------------+
 * 
 * EXPLANATION:
 *   Uses NOT IN to exclude empty strings, spaces, and NULLs.
 *   Only shows users with valid city names and high-value purchases.
 */

/**
 * ======================================================================
 * 5. THE NULL TRAP — Critical pitfall with NOT IN
 * ======================================================================
 *
 * PROBLEM:
 *   When NOT IN contains a NULL value, the query returns ZERO rows.
 *   This is one of the most dangerous and confusing SQL pitfalls.
 *
 * WHY IT HAPPENS:
 *   NOT IN is logically equivalent to multiple != conditions with AND.
 *   If any value in the list is NULL, the entire condition becomes UNKNOWN.
 *
 * DEMONSTRATION:
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ DEMO 1 — NOT IN with NULL in list (DANGEROUS)                     │
 * └────────────────────────────────────────────────────────────────────┘
 */
-- This query will return NOTHING even though many users exist!
SELECT full_name, city
FROM users
WHERE city NOT IN ('Delhi', NULL);

/**
 * Output:
 * (No rows returned)
 * 
 * WHY?
 *   This is equivalent to:
 *   WHERE city != 'Delhi' AND city != NULL
 *   
 *   city != NULL is UNKNOWN (since NULL is unknown)
 *   UNKNOWN AND anything = UNKNOWN → no rows match
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ DEMO 2 — Safe way to handle NOT IN with possible NULLs            │
 * └────────────────────────────────────────────────────────────────────┘
 */
-- Solution 1: Filter out NULLs first
SELECT full_name, city
FROM users
WHERE city NOT IN ('Delhi')
  AND city IS NOT NULL;

/**
 * Output:
 * +-----------------+-------------+
 * | full_name       | city        |
 * +-----------------+-------------+
 * | Raj             | Bengaluru   |
 * | Sara            | Bengaluru   |
 * | Arjun           | Pune        |
 * | John Doe        | Chennai     |
 * | Jane Doe        | Chennai     |
 * | Support Trial   | Gurugram    |
 * | Priya           | Hyderabad   |
 * | Intern          | Bengaluru   |
 * +-----------------+-------------+
 */

-- Solution 2: Use NOT EXISTS instead (handles NULLs safely)
SELECT full_name, city
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM (VALUES ('Delhi'), (NULL)) AS v(city)
    WHERE u.city = v.city
);

/**
 * Output:
 * +-----------------+-------------+
 * | full_name       | city        |
 * +-----------------+-------------+
 * | Raj             | Bengaluru   |
 * | Neha            | ''          |
 * | Sara            | Bengaluru   |
 * | Arjun           | Pune        |
 * | John Doe        | Chennai     |
 * | Jane Doe        | Chennai     |
 * | Support Trial   | Gurugram    |
 * | Priya           | Hyderabad   |
 * | Empty City      | ' '         |
 * | Intern          | Bengaluru   |
 * +-----------------+-------------+
 */

/**
 * RULE OF THUMB:
 *   NEVER put a NULL in your NOT IN list intentionally.
 *   If your list might contain NULLs from a subquery,
 *   use NOT EXISTS instead, or filter out NULLs explicitly.
 */

/**
 * ======================================================================
 * 6. WORKING WITH SUBQUERIES — Advanced list filtering
 * ======================================================================
 */

/**
 * IN with Subquery — Find users in cities with high-value customers
 * 
 * Find users whose city appears in the list of cities where
 * customers have spent more than ₹1000.
 */
SELECT DISTINCT full_name, city, last_purchase_inr
FROM users
WHERE city IN (
    SELECT DISTINCT city
    FROM users
    WHERE last_purchase_inr > 1000
      AND city IS NOT NULL
      AND NULLIF(TRIM(city), '') IS NOT NULL
)
AND last_purchase_inr IS NOT NULL
ORDER BY last_purchase_inr DESC;

/**
 * Output:
 * +-----------+-----------+-------------------+
 * | full_name | city      | last_purchase_inr |
 * +-----------+-----------+-------------------+
 * | Sara      | Bengaluru | 2000.00           |
 * | Jane Doe  | Chennai   | 1200.00           |
 * | Raj       | Bengaluru | 999.00            |
 * | Priya     | Hyderabad | 999.00            |
 * | Intern    | Bengaluru | 899.00            |
 * +-----------+-----------+-------------------+
 */

/**
 * NOT IN with Subquery — Find users who never used popular coupons
 * 
 * Find users who never used the top 3 most common coupons.
 */
SELECT full_name, email, last_coupon_code
FROM users
WHERE last_coupon_code NOT IN (
    SELECT last_coupon_code
    FROM users
    WHERE last_coupon_code IS NOT NULL
    GROUP BY last_coupon_code
    ORDER BY COUNT(*) DESC
    LIMIT 3
)
AND last_coupon_code IS NOT NULL;

/**
 * Output:
 * +-----------------+--------------------------+------------------+
 * | full_name       | email                    | last_coupon_code |
 * +-----------------+--------------------------+------------------+
 * | Test User Two   | testXuser2@gmail.com     | WELCOME_2026     |
 * | Mohit           | mohit@gmail.com          | NEWYEAR10        |
 * | Arjun           | arjun@yahoo.com          | FLASH_SALE       |
 * | Khushi          | khushi@gmail.com         | REFERRAL5        |
 * +-----------------+--------------------------+------------------+
 */

/**
 * ======================================================================
 * 7. COMMON MISTAKES — Pitfalls with IN and NOT IN
 * ======================================================================
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #1 — The NULL Trap (NOT IN with NULL)                     │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ DANGEROUS:                                                    │
 * │   SELECT * FROM users WHERE city NOT IN ('Delhi', NULL);          │
 * │   → Returns NOTHING (zero rows)                                   │
 * │                                                                    │
 * │   ✅ SAFE:                                                         │
 * │   SELECT * FROM users WHERE city NOT IN ('Delhi')                 │
 * │                         AND city IS NOT NULL;                     │
 * │                                                                    │
 * │   OR use NOT EXISTS instead:                                      │
 * │   SELECT * FROM users u WHERE NOT EXISTS (                        │
 * │       SELECT 1 FROM (VALUES ('Delhi'), (NULL)) AS v(city)         │
 * │       WHERE u.city = v.city                                       │
 * │   );                                                              │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2 — IN with an empty list                                │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ SYNTAX ERROR:                                                 │
 * │   SELECT * FROM users WHERE city IN ();                           │
 * │   → Syntax error in most databases                                │
 * │                                                                    │
 * │   ✅ Always ensure list has at least one value:                   │
 * │   SELECT * FROM users WHERE city IN ('Delhi');                    │
 * │   OR handle empty list in application code                        │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3 — Case sensitivity with IN                             │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   In PostgreSQL (case-sensitive by default):                      │
 * │   WHERE city IN ('delhi', 'mumbai')                               │
 * │   → Won't match 'Delhi' or 'Mumbai' (different case)             │
 * │                                                                    │
 * │   ✅ Fix by normalizing case:                                      │
 * │   WHERE LOWER(city) IN ('delhi', 'mumbai')                        │
 * │                                                                    │
 * │   In MySQL (case-insensitive by default):                         │
 * │   WHERE city IN ('delhi', 'mumbai')                               │
 * │   → Will match 'Delhi', 'DELHI', 'delhi'                          │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4 — Using IN with different data types                   │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG (mixing numbers and strings):                           │
 * │   WHERE id IN (1, 2, 'three', 4);                                 │
 * │   → May cause implicit conversion issues                          │
 * │                                                                    │
 * │   ✅ CORRECT (consistent data type):                               │
 * │   WHERE id IN (1, 2, 3, 4);                                       │
 * │   WHERE city IN ('Delhi', 'Mumbai', 'Bengaluru');                 │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5 — IN with very large lists                             │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ Poor performance:                                             │
 * │   WHERE id IN (1, 2, 3, ..., 10000);                              │
 * │                                                                    │
 * │   ✅ Better alternatives:                                          │
 * │   -- Use a temporary table                                        │
 * │   CREATE TEMP TABLE ids (id INT);                                 │
 * │   INSERT INTO ids VALUES (1), (2), ...;                           │
 * │   SELECT * FROM users WHERE id IN (SELECT id FROM ids);           │
 * │                                                                    │
 * │   -- Or use EXISTS with a derived table                           │
 * │   SELECT * FROM users WHERE EXISTS (                              │
 * │       SELECT 1 FROM (VALUES (1), (2), (3)) AS v(id)               │
 * │       WHERE users.id = v.id                                       │
 * │   );                                                              │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ======================================================================
 * 8. QUICK REFERENCE — Cheat sheet
 * ======================================================================
 *
 * IN OPERATOR:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IN (a, b, c)         → Value equals any in list                   │
 * │                      → Equivalent to col = a OR col = b OR col = c│
 * │                      → Clean, readable, performant                │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * NOT IN OPERATOR:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NOT IN (a, b, c)     → Value equals none in list                  │
 * │                      → Equivalent to col != a AND col != b        │
 * │                        AND col != c                               │
 * │                      → ⚠️ DANGEROUS with NULLs!                   │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * SAFE PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Safe NOT IN (explicitly exclude NULLs)                         │
 * │ WHERE col NOT IN ('Delhi', 'Mumbai') AND col IS NOT NULL          │
 * │                                                                   │
 * │ -- Safe IN with subquery (no NULLs in result)                     │
 * │ WHERE col IN (SELECT col FROM table WHERE col IS NOT NULL)        │
 * │                                                                   │
 * │ -- Use NOT EXISTS instead of NOT IN with potential NULLs          │
 * │ WHERE NOT EXISTS (SELECT 1 FROM other WHERE other.col = col)      │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * SUBQUERY PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- IN with subquery                                               │
 * │ WHERE city IN (SELECT city FROM cities WHERE population > 1M)     │
 * │                                                                   │
 * │ -- NOT IN with subquery (ensure no NULLs)                         │
 * │ WHERE city NOT IN (                                                │
 * │     SELECT city FROM excluded_cities WHERE city IS NOT NULL       │
 * │ )                                                                 │
 * │                                                                   │
 * │ -- EXISTS vs IN                                                   │
 * │ -- EXISTS is often better for large datasets                      │
 * │ WHERE EXISTS (SELECT 1 FROM orders WHERE orders.user_id = id)     │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ======================================================================
 * 9. GOLDEN RULES — Key principles to remember
 * ======================================================================
 *
 * 1. ✅ Use IN when checking against a list of values — it's cleaner
 *      and more readable than multiple OR conditions.
 *
 * 2. ⚠️ NEVER use NOT IN when the list might contain NULLs unless
 *      you explicitly handle them. This is the most dangerous pitfall!
 *
 * 3. ✅ Always handle NULLs explicitly with NOT IN:
 *      WHERE col NOT IN (list) AND col IS NOT NULL
 *
 * 4. ✅ For better performance with large lists, consider using
 *      a temporary table or EXISTS instead of IN.
 *
 * 5. ✅ Be aware of case sensitivity. Use LOWER() or UPPER() for
 *      case-insensitive matching if needed.
 *
 * 6. ✅ IN works with subqueries — perfect for dynamic lists:
 *      WHERE city IN (SELECT city FROM top_cities)
 *
 * 7. 💡 PRO TIP: When building dynamic IN lists in application code,
 *      always validate that the list is not empty to avoid syntax errors.
 *
 * 8. 💡 PRO TIP: For very large IN lists (1000+ items), many databases
 *      have limitations. Use a temporary table or JOIN instead.
 *
 * 9. ✅ NOT EXISTS is often a safer alternative to NOT IN when
 *      dealing with potential NULLs in subqueries.
 *
 * 10. 💡 PRO TIP: When in doubt about NULL behavior, test your query
 *       with a small dataset first to verify the results.
 *
 * ======================================================================
 */