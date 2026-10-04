/**
 * IS NULL vs IS NOT NULL — Understanding Missing Data
 *
 * DEEP DIVE — Handling NULL Values in SQL
 * 1. WHAT IS NULL? ................. Understanding the concept of missing data
 * 2. IS NULL ....................... Finding rows with missing values
 * 3. IS NOT NULL ................... Finding rows with present values
 * 4. REAL-WORLD SCENARIOS .......... Practical business use cases
 * 5. DATA CLEANING ................. Handling messy real-world data
 * 6. COMMON MISTAKES ............... Pitfalls with NULL handling
 * 7. QUICK REFERENCE ............... Cheat sheet
 * 8. GOLDEN RULES .................. Key principles to remember
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
 * 1. WHAT IS NULL? — Understanding the concept of missing data
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NULL is a special marker in SQL that represents the ABSENCE of     │
 * │ data. It means "unknown", "not recorded", or "not applicable".     │
 * │                                                                    │
 * │ NULL IS NOT:                                                       │
 * │   ┌─────────────────────────────────────────────────────────┐      │
 * │   │ ✗ Empty string ('')     ← This is a value (an empty one)│     │
 * │   │ ✗ Zero (0)              ← This is a number (zero exists)│     │
 * │   │ ✗ Space (' ')           ← This is a character (a space) │     │
 * │   │ ✗ 'N/A' or 'unknown'    ← These are text values         │     │
 * │   └─────────────────────────────────────────────────────────┘      │
 * │                                                                    │
 * │ REAL-WORLD ANALOGY:                                                │
 * │   Imagine a form where users enter their city:                     │
 * │   → User writes "Delhi"     = Has value (present)                  │
 * │   → User leaves it blank    = Could be NULL or empty string        │
 * │   → User enters a space     = Has value (a space character)        │
 * │   → User never saw the form = NULL (never recorded)                │
 * │                                                                    │
 * │ WHY NULL IS SPECIAL:                                               │
 * │   Because NULL represents the unknown, you cannot compare it       │
 * │   using standard operators like =, !=, >, or <.                    │
 * │                                                                    │
 * │   ❌ WHERE city = NULL      ← This will NEVER work!               │
 * │   ❌ WHERE city != NULL     ← This will NEVER work!               │
 * │   ✅ WHERE city IS NULL     ← Correct way to find NULLs           │
 * │   ✅ WHERE city IS NOT NULL ← Correct way to exclude NULLs        │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 2. IS NULL — Finding rows with missing values
 *
 * WHAT IT DOES:
 *   IS NULL checks whether a column value is unknown (NULL).
 *   It returns all rows where the specified column has no value recorded.
 *
 * SYNTAX:
 *   WHERE column IS NULL
 *
 * USE CASES:
 *   → Finding users with incomplete profiles
 *   → Identifying missing purchase data
 *   → Finding customers who haven't taken an action
 *   → Data quality checks
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Find users who have NOT entered their city             │
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
 * 
 * EXPLANATION:
 *   Only users with truly NULL city values appear.
 *   Notice: Neha (id 5) with empty string '' does NOT appear.
 *   Empty City (id 14) with space ' ' does NOT appear.
 *   NULL is different from empty string or space!
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Find users who have NEVER made a purchase              │
 * │ (last_purchase_inr is NULL)                                        │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    id, 
    full_name,
    last_purchase_inr,
    signup_at_utc
FROM users
WHERE last_purchase_inr IS NULL;

/**
 * Output:
 * +----+-----------------+-------------------+---------------------+
 * | id | full_name       | last_purchase_inr | signup_at_utc       |
 * +----+-----------------+-------------------+---------------------+
 * | 4  | Aayush          | NULL              | 2025-11-30 23:59:59 |
 * | 11 | Support Trial   | NULL              | 2025-12-07 10:00:00 |
 * | 18 | Hello           | NULL              | 2025-12-02 08:00:00 |
 * +----+-----------------+-------------------+---------------------+
 * 
 * BUSINESS VALUE: These 3 users signed up but never purchased.
 * They are candidates for a re-engagement campaign.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 3 — Find users who have NEVER used a coupon                │
 * │ (last_coupon_code is NULL)                                         │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name, 
    email,
    last_coupon_code
FROM users
WHERE last_coupon_code IS NULL;

/**
 * Output:
 * +-----------------+--------------------------+------------------+
 * | full_name       | email                    | last_coupon_code |
 * +-----------------+--------------------------+------------------+
 * | Test User One   | test_user1@gmail.com     | NULL             |
 * | Aayush          | aayush@company.com       | NULL             |
 * | Sara            | sara@tuf.com             | NULL             |
 * | John Doe        | john.doe@gmail.com       | NULL             |
 * | Support Trial   | support+trial@tuf.com    | NULL             |
 * | Sameer          | sameer@rediffmail.com    | NULL             |
 * | Empty City      | emptycity@demo.com       | NULL             |
 * | Hello           | hello@sample.com         | NULL             |
 * +-----------------+--------------------------+------------------+
 * 
 * BUSINESS VALUE: 8 users have never used a coupon.
 * Send them a "First-time coupon" campaign.
 */

/**
 * 3. IS NOT NULL — Finding rows with present values
 *
 * WHAT IT DOES:
 *   IS NOT NULL checks whether a column value is present.
 *   It filters out any row where the data is missing or unknown.
 *
 * SYNTAX:
 *   WHERE column IS NOT NULL
 *
 * USE CASES:
 *   → Finding users who have completed their profile
 *   → Identifying customers with purchase history
 *   → Finding users who performed an action
 *   → Data validation
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Find all users who HAVE entered a city                 │
 * │ (any value including empty strings and spaces)                     │
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
 * EXPLANATION:
 *   Returns 16 rows — every user whose city column is NOT NULL.
 *   This includes empty strings ('') and spaces (' ') because they are
 *   actual values (even though they appear empty or are just spaces).
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Find users who HAVE made at least one purchase         │
 * │ (last_purchase_inr has a value)                                    │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    email,
    last_purchase_inr
FROM users
WHERE last_purchase_inr IS NOT NULL;

/**
 * Output:
 * +-----------------+--------------------------+-------------------+
 * | full_name       | email                    | last_purchase_inr |
 * +-----------------+--------------------------+-------------------+
 * | Raj             | raj@tuf.com              | 999.00            |
 * | Test User One   | test_user1@gmail.com     | 499.00            |
 * | Test User Two   | testXuser2@gmail.com     | 750.00            |
 * | Neha            | neha@example.com         | 1500.00           |
 * | Mohit           | mohit@gmail.com          | 299.00            |
 * | Sara            | sara@tuf.com             | 2000.00           |
 * | Arjun           | arjun@yahoo.com          | 799.00            |
 * | John Doe        | john.doe@gmail.com       | 300.00            |
 * | Jane Doe        | jane_doe@gmail.com       | 1200.00           |
 * | Priya           | priya@outlook.com        | 999.00            |
 * | Sameer          | sameer@rediffmail.com    | 100.00            |
 * | Empty City      | emptycity@demo.com       | 499.00            |
 * | Khushi          | khushi@gmail.com         | 500.00            |
 * | Promo           | promo@demo.com           | 1499.00           |
 * | Intern          | intern@tuf.com           | 899.00            |
 * +-----------------+--------------------------+-------------------+
 * 
 * BUSINESS VALUE: 15 users have made purchases.
 * They are your active customer base for analysis.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 3 — Find users who HAVE used a coupon at least once        │
 * │ (last_coupon_code has a value)                                     │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    email,
    last_coupon_code
FROM users
WHERE last_coupon_code IS NOT NULL;

/**
 * Output:
 * +-----------------+--------------------------+------------------+
 * | full_name       | email                    | last_coupon_code |
 * +-----------------+--------------------------+------------------+
 * | Raj             | raj@tuf.com              | WELCOME10        |
 * | Test User Two   | testXuser2@gmail.com     | WELCOME_2026     |
 * | Neha            | neha@example.com         | TUF_50           |
 * | Mohit           | mohit@gmail.com          | NEWYEAR10        |
 * | Arjun           | arjun@yahoo.com          | FLASH_SALE       |
 * | Jane Doe        | jane_doe@gmail.com       | WELCOME_BACK     |
 * | Priya           | priya@outlook.com        | WELCOME10        |
 * | Khushi          | khushi@gmail.com         | REFERRAL5        |
 * | Promo           | promo@demo.com           | TUF_50           |
 * | Intern          | intern@tuf.com           | WELCOME_BACK     |
 * +-----------------+--------------------------+------------------+
 * 
 * BUSINESS VALUE: 10 users are coupon users.
 * Analyze which coupons drive the most purchases.
 */

/**
 * 4. REAL-WORLD SCENARIOS — Practical business use cases
 */

/**
 * SCENARIO 1: Customer Retention — Incomplete profiles
 * 
 * Find users who haven't completed their profile (missing city)
 * and send them a reminder to update their information.
 */
SELECT full_name, email, signup_at_utc
FROM users
WHERE city IS NULL
ORDER BY signup_at_utc DESC;

/**
 * Output:
 * +----------+--------------------------+---------------------+
 * | full_name| email                    | signup_at_utc       |
 * +----------+--------------------------+---------------------+
 * | Sameer   | sameer@rediffmail.com    | 2025-12-09 10:00:00 |
 * | Aayush   | aayush@company.com       | 2025-11-30 23:59:59 |
 * +----------+--------------------------+---------------------+
 */

/**
 * SCENARIO 2: Sales Analysis — Customers who never purchased
 * 
 * Find users who signed up but never made a purchase.
 * These are potential customers for a first-purchase discount.
 */
SELECT 
    full_name,
    email,
    signup_at_utc,
    EXTRACT(DAY FROM (CURRENT_DATE - signup_at_utc)) AS days_since_signup
FROM users
WHERE last_purchase_inr IS NULL
ORDER BY signup_at_utc;

/**
 * Output:
 * +-----------------+--------------------------+---------------------+------------------+
 * | full_name       | email                    | signup_at_utc       | days_since_signup|
 * +-----------------+--------------------------+---------------------+------------------+
 * | Aayush          | aayush@company.com       | 2025-11-30 23:59:59 | 117              |
 * | Hello           | hello@sample.com         | 2025-12-02 08:00:00 | 115              |
 * | Support Trial   | support+trial@tuf.com    | 2025-12-07 10:00:00 | 110              |
 * +-----------------+--------------------------+---------------------+------------------+
 */

/**
 * SCENARIO 3: Data Quality Check — Multiple NULL columns
 * 
 * Find users with incomplete data across multiple fields.
 * These records may need manual review or data enrichment.
 */
SELECT 
    id,
    full_name,
    email,
    CASE WHEN city IS NULL THEN '✗' ELSE '✓' END AS has_city,
    CASE WHEN last_purchase_inr IS NULL THEN '✗' ELSE '✓' END AS has_purchase,
    CASE WHEN last_coupon_code IS NULL THEN '✗' ELSE '✓' END AS has_coupon
FROM users
WHERE city IS NULL OR last_purchase_inr IS NULL OR last_coupon_code IS NULL
ORDER BY has_city, has_purchase, has_coupon;

/**
 * Output:
 * +----+-----------------+--------------------------+----------+-------------+-----------+
 * | id | full_name       | email                    | has_city | has_purchase| has_coupon|
 * +----+-----------------+--------------------------+----------+-------------+-----------+
 * | 4  | Aayush          | aayush@company.com       | ✗        | ✗           | ✗         |
 * | 13 | Sameer          | sameer@rediffmail.com    | ✗        | ✓           | ✗         |
 * | 2  | Test User One   | test_user1@gmail.com     | ✓        | ✓           | ✗         |
 * | 7  | Sara            | sara@tuf.com             | ✓        | ✓           | ✗         |
 * | 9  | John Doe        | john.doe@gmail.com       | ✓        | ✓           | ✗         |
 * | 11 | Support Trial   | support+trial@tuf.com    | ✓        | ✗           | ✗         |
 * | 14 | Empty City      | emptycity@demo.com       | ✓        | ✓           | ✗         |
 * | 18 | Hello           | hello@sample.com         | ✓        | ✗           | ✗         |
 * +----+-----------------+--------------------------+----------+-------------+-----------+
 */

/**
 * SCENARIO 4: Marketing Segmentation — Engaged users
 * 
 * Find users who are fully engaged (have city, purchase, and coupon)
 * for premium offers and loyalty programs.
 */
SELECT 
    full_name,
    email,
    city,
    last_purchase_inr,
    last_coupon_code
FROM users
WHERE city IS NOT NULL
  AND last_purchase_inr IS NOT NULL
  AND last_coupon_code IS NOT NULL
ORDER BY last_purchase_inr DESC;

/**
 * Output:
 * +-----------------+--------------------------+-----------+-------------------+------------------+
 * | full_name       | email                    | city      | last_purchase_inr | last_coupon_code |
 * +-----------------+--------------------------+-----------+-------------------+------------------+
 * | Jane Doe        | jane_doe@gmail.com       | Chennai   | 1200.00           | WELCOME_BACK     |
 * | Priya           | priya@outlook.com        | Hyderabad | 999.00            | WELCOME10        |
 * | Intern          | intern@tuf.com           | Bengaluru | 899.00            | WELCOME_BACK     |
 * | Test User Two   | testXuser2@gmail.com     | Delhi     | 750.00            | WELCOME_2026     |
 * | Khushi          | khushi@gmail.com         | Delhi     | 500.00            | REFERRAL5        |
 * | Mohit           | mohit@gmail.com          | Mumbai    | 299.00            | NEWYEAR10        |
 * +-----------------+--------------------------+-----------+-------------------+------------------+
 */

/**
 * 5. DATA CLEANING — Handling messy real-world data
 *
 * REAL-WORLD PROBLEM:
 *   In production databases, missing data appears in many forms:
 *   → NULL (database NULL)
 *   → Empty string ('')
 *   → Spaces (' ')
 *   → Multiple spaces ('   ')
 *   → Placeholder text ('N/A', 'unknown', 'TBD')
 *
 * SOLUTION — Normalize your data:
 *   Use TRIM() to remove leading/trailing spaces
 *   Use NULLIF() to convert empty strings to NULL
 *   Then filter with IS NOT NULL for truly populated data
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Find users with TRULY valid city names                   │
 * │ (excludes NULL, empty strings, and strings with only spaces)       │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    id,
    email,
    city,
    TRIM(city) AS trimmed_city,
    NULLIF(TRIM(city), '') AS normalized_city
FROM users
WHERE NULLIF(TRIM(city), '') IS NOT NULL;

/**
 * Output:
 * +----+--------------------------+-------------+---------------+------------------+
 * | id | email                    | city        | trimmed_city  | normalized_city  |
 * +----+--------------------------+-------------+---------------+------------------+
 * | 1  | raj@tuf.com              | Bengaluru   | Bengaluru     | Bengaluru        |
 * | 2  | test_user1@gmail.com     | Delhi       | Delhi         | Delhi            |
 * | 3  | testXuser2@gmail.com     | Delhi       | Delhi         | Delhi            |
 * | 6  | mohit@gmail.com          | Mumbai      | Mumbai        | Mumbai           |
 * | 7  | sara@tuf.com             | Bengaluru   | Bengaluru     | Bengaluru        |
 * | 8  | arjun@yahoo.com          | Pune        | Pune          | Pune             |
 * | 9  | john.doe@gmail.com       | Chennai     | Chennai       | Chennai          |
 * | 10 | jane_doe@gmail.com       | Chennai     | Chennai       | Chennai          |
 * | 11 | support+trial@tuf.com    | Gurugram    | Gurugram      | Gurugram         |
 * | 12 | priya@outlook.com        | Hyderabad   | Hyderabad     | Hyderabad        |
 * | 15 | khushi@gmail.com         | Delhi       | Delhi         | Delhi            |
 * | 16 | promo@demo.com           | Mumbai      | Mumbai        | Mumbai           |
 * | 17 | intern@tuf.com           | Bengaluru   | Bengaluru     | Bengaluru        |
 * | 18 | hello@sample.com         | Delhi       | Delhi         | Delhi            |
 * +----+--------------------------+-------------+---------------+------------------+
 * 
 * EXPLANATION:
 *   TRIM(city) removes leading/trailing spaces
 *   NULLIF(..., '') converts empty strings to NULL
 *   IS NOT NULL keeps only truly populated cities
 *   
 *   Notice: Neha (id 5 with '') and Empty City (id 14 with ' ') are
 *   now excluded because they are not truly valid city names.
 */

/**
 * DATA CLEANING PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Replace empty strings with NULL                                 │
 * │ UPDATE table SET column = NULL WHERE TRIM(column) = '';            │
 * │                                                                    │
 * │ -- Clean data in SELECT                                            │
 * │ SELECT COALESCE(NULLIF(TRIM(column), ''), 'N/A') AS cleaned        │
 * │ FROM table;                                                        │
 * │                                                                    │
 * │ -- Filter for truly populated values                               │
 * │ WHERE NULLIF(TRIM(column), '') IS NOT NULL                         │
 * │                                                                    │
 * │ -- Count missing values (including empty strings)                  │
 * │ SELECT COUNT(*) FROM table                                         │
 * │ WHERE NULLIF(TRIM(column), '') IS NULL;                            │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ======================================================================
 * 6. COMMON MISTAKES — Pitfalls with NULL handling
 * ======================================================================
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #1 — Using = with NULL instead of IS NULL                  │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG: ❌                                                    │
 * │   SELECT * FROM users WHERE city = NULL;                           │
 * │   → Returns NO rows (even if NULLs exist)                          │
 * │                                                                    │
 * │   ✅ CORRECT: ✅                                                  │
 * │   SELECT * FROM users WHERE city IS NULL;                          │
 * │   → Returns rows with NULL city                                    │
 * │                                                                    │
 * │   WHY? NULL is unknown — any comparison with NULL results in       │
 * │   UNKNOWN, which is treated as FALSE in WHERE clause.              │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2 — Using != with NULL                                    │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG:                                                        │
 * │   SELECT * FROM users WHERE city != 'Delhi';                       │
 * │   → This will NOT return rows where city IS NULL!                  │
 * │                                                                    │
 * │   WHY? NULL != 'Delhi' is UNKNOWN, so NULL rows are excluded.      │
 * │                                                                    │
 * │   ✅ CORRECT — If you want to include NULLs:                       │
 * │   SELECT * FROM users WHERE city != 'Delhi' OR city IS NULL;       │
 * │                                                                    │
 * │   ✅ CORRECT — If you want to exclude NULLs:                       │
 * │   SELECT * FROM users WHERE city IS NOT NULL AND city != 'Delhi';  │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌──────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3 — Confusing NULL with empty string or space               │
 * ├──────────────────────────────────────────────────────────────────────┤
 * │                                                                      │
 * │   Different values — they are NOT the same:                          │
 * │                                                                      │
 * │   ┌──────────┬────────────────────────────────────────────────┐      │
 * │   │ Value    │ Meaning                                        │      │
 * │   ├──────────┼────────────────────────────────────────────────┤      │
 * │   │ NULL     │ Unknown / not recorded                         │      │
 * │   │ ''       │ Empty string (a value that exists but is empty)│      │
 * │   │ ' '      │ Space character (a value that is a space)      │      │
 * │   │ '  '     │ Multiple spaces (still a value)                │      │
 * │   └──────────┴────────────────────────────────────────────────┘      │
 * │                                                                      │
 * │   SELECT * FROM users WHERE city = '';     → Finds id 5 (Neha)       │
 * │   SELECT * FROM users WHERE city = ' ';    → Finds id 14 (Empty City)│
 * │   SELECT * FROM users WHERE city IS NULL;  → Finds id 4, 13          │
 * └──────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4 — Assuming NULLs are included in aggregate functions    │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   Aggregate functions (COUNT, SUM, AVG, etc.) ignore NULLs:        │
 * │                                                                    │
 * │   SELECT COUNT(last_purchase_inr) FROM users;                      │
 * │   → Returns 15 (ignores the 3 NULLs)                               │
 * │                                                                    │
 * │   SELECT COUNT(*) FROM users;                                      │
 * │   → Returns 18 (counts all rows regardless of NULLs)               │
 * │                                                                    │
 * │   SELECT AVG(last_purchase_inr) FROM users;                        │
 * │   → Calculates average of only the 15 non-NULL values              │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5 — Using IS NULL on a column that contains empty strings │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   If your data has empty strings instead of NULLs:                 │
 * │                                                                    │
 * │   ❌ This will miss empty strings:                                │
 * │   SELECT * FROM users WHERE city IS NULL;                          │
 * │   → Only finds actual NULLs, not users with '' or ' '              │
 * │                                                                    │
 * │   ✅ This finds both NULLs and empty strings:                      │
 * │   SELECT * FROM users WHERE NULLIF(TRIM(city), '') IS NULL;        │
 * │   → Finds id 4, 13 (NULLs) and id 5, 14 (empty/space)              │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * 7. QUICK REFERENCE — Cheat sheet
 *
 * NULL HANDLING OPERATORS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ IS NULL              → Find missing/unknown values                 │
 * │ IS NOT NULL          → Find values that exist                      │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * HELPER FUNCTIONS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ NULLIF(col, '')      → Convert empty string to NULL                │
 * │ COALESCE(col, 'N/A') → Replace NULL with default value             │
 * │ TRIM(col)            → Remove leading/trailing spaces              │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * COMMON PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Clean missing data in SELECT                                    │
 * │ SELECT COALESCE(NULLIF(TRIM(city), ''), 'Not Provided') AS city    │
 * │                                                                    │
 * │ -- Filter for truly populated data                                 │
 * │ WHERE NULLIF(TRIM(city), '') IS NOT NULL                           │
 * │                                                                    │
 * │ -- Count truly missing values (including empty strings)            │
 * │ SELECT COUNT(*) FROM users                                         │
 * │ WHERE NULLIF(TRIM(city), '') IS NULL                               │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * BEHAVIOR WITH AGGREGATES:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ COUNT(*)           → Counts all rows (including NULLs)             │
 * │ COUNT(column)      → Counts only non-NULL values                   │
 * │ SUM(column)        → Ignores NULLs                                 │
 * │ AVG(column)        → Ignores NULLs                                 │
 * │ MIN(column)        → Ignores NULLs                                 │
 * │ MAX(column)        → Ignores NULLs                                 │
 * └────────────────────────────────────────────────────────────────────┘
 */
