/**
 * ======================================================================
 * DEEP DIVE — BETWEEN & NOT BETWEEN: Working with Ranges
 * ======================================================================
 *
 * FILTERING ESSENTIALS — Part 2: Range-Based Filtering
 * ======================================================================
 *
 * TABLE OF CONTENTS:
 * 1. OPERATOR OVERVIEW ............. What BETWEEN and NOT BETWEEN do
 * 2. BETWEEN ....................... Finding values inside a range
 * 3. NOT BETWEEN ................... Finding values outside a range
 * 4. NUMERIC RANGES ................ Working with numbers and prices
 * 5. DATE RANGES ................... Working with timestamps and dates
 * 6. TEXT RANGES ................... Working with alphabetical ranges
 * 7. REAL-WORLD SCENARIOS .......... Practical business use cases
 * 8. COMMON MISTAKES ............... Pitfalls with BETWEEN
 * 9. QUICK REFERENCE ............... Cheat sheet
 * 10. GOLDEN RULES ................. Key principles to remember
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
 * 1. OPERATOR OVERVIEW — What BETWEEN and NOT BETWEEN do
 * ======================================================================
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ BETWEEN checks whether a value lies INSIDE a range.                │
 * │ NOT BETWEEN checks whether a value lies OUTSIDE that range.        │
 * │                                                                    │
 * │ CRITICAL: BETWEEN is INCLUSIVE — both boundaries are included!     │
 * │                                                                    │
 * │   BETWEEN 1 AND 10   → Includes 1, 10, and everything in between   │
 * │   BETWEEN 'A' AND 'Z'→ Includes 'A', 'Z', and all letters between  │
 * │                                                                    │
 * │ SYNTAX:                                                            │
 * │   WHERE column BETWEEN low AND high                                │
 * │   WHERE column NOT BETWEEN low AND high                            │
 * │                                                                    │
 * │ EQUIVALENT TO:                                                     │
 * │   WHERE column >= low AND column <= high                           │
 * │   WHERE column < low OR column > high                              │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * USE CASES:
 *   → Date ranges (signups in December, orders last week)
 *   → Price ranges (products between $50 and $100)
 *   → Age ranges (customers between 18-25 years)
 *   → Score ranges (students with grades between 80-90)
 */

/**
 * ======================================================================
 * 2. BETWEEN — Finding values inside a range
 * ======================================================================
 *
 * WHAT IT DOES:
 *   BETWEEN checks if a value lies inside an inclusive range.
 *   The range includes both the start and end values.
 *
 * SYNTAX:
 *   WHERE column BETWEEN start_value AND end_value
 *
 * EQUIVALENT TO:
 *   WHERE column >= start_value AND column <= end_value
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Users who signed up in December 2025                 │
 * │ (Date range with timestamps)                                      │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT
  id,
  full_name,
  signup_at_utc
FROM users
WHERE signup_at_utc BETWEEN '2025-12-01 00:00:00'
                        AND '2025-12-31 23:59:59'
ORDER BY signup_at_utc;

/**
 * Output:
 * +----+-----------------+---------------------+
 * | id | full_name       | signup_at_utc       |
 * +----+-----------------+---------------------+
 * | 1  | Raj             | 2025-12-01 00:00:00 |
 * | 18 | Hello           | 2025-12-02 08:00:00 |
 * | 2  | Test User One   | 2025-12-05 10:00:00 |
 * | 9  | John Doe        | 2025-12-05 18:30:00 |
 * | 10 | Jane Doe        | 2025-12-06 18:30:00 |
 * | 11 | Support Trial   | 2025-12-07 10:00:00 |
 * | 12 | Priya           | 2025-12-08 10:00:00 |
 * | 13 | Sameer          | 2025-12-09 10:00:00 |
 * | 14 | Empty City      | 2025-12-10 10:00:00 |
 * | 3  | Test User Two   | 2025-12-10 12:00:00 |
 * | 15 | Khushi          | 2025-12-11 10:00:00 |
 * | 8  | Arjun           | 2025-12-20 09:00:00 |
 * | 17 | Intern          | 2025-12-22 20:00:00 |
 * | 16 | Promo           | 2025-12-25 00:00:00 |
 * | 5  | Neha            | 2025-12-31 23:59:59 |
 * +----+-----------------+---------------------+
 * 
 * EXPLANATION:
 *   Returns 15 users who signed up in December 2025.
 *   Includes both Dec 1st (00:00:00) and Dec 31st (23:59:59).
 *   This is the power of BETWEEN with dates — clean and readable!
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Mid-range purchases (between 400 and 800 INR)        │
 * │ (Numeric range)                                                   │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name, 
    last_purchase_inr
FROM users
WHERE last_purchase_inr BETWEEN 400 AND 800
ORDER BY last_purchase_inr;

/**
 * Output:
 * +-----------------+-------------------+
 * | full_name       | last_purchase_inr |
 * +-----------------+-------------------+
 * | Test User One   | 499.00            |
 * | Empty City      | 499.00            |
 * | Khushi          | 500.00            |
 * | Test User Two   | 750.00            |
 * | Arjun           | 799.00            |
 * +-----------------+-------------------+
 * 
 * EXPLANATION:
 *   Returns users with purchase amounts between 400 and 800.
 *   Includes 400 and 800 if they existed.
 *   Much cleaner than: WHERE last_purchase_inr >= 400 
 *                      AND last_purchase_inr <= 800
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 3 — Text range (names starting with letters A-M)         │
 * │ (Alphabetical range)                                              │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    email
FROM users
WHERE full_name BETWEEN 'A' AND 'M'
ORDER BY full_name;

/**
 * Output:
 * +-----------------+--------------------------+
 * | full_name       | email                    |
 * +-----------------+--------------------------+
 * | Aayush          | aayush@company.com       |
 * | Arjun           | arjun@yahoo.com          |
 * | Empty City      | emptycity@demo.com       |
 * | Hello           | hello@sample.com         |
 * | Intern          | intern@tuf.com           |
 * | Jane Doe        | jane_doe@gmail.com       |
 * | John Doe        | john.doe@gmail.com       |
 * | Khushi          | khushi@gmail.com         |
 * | Mohit           | mohit@gmail.com          |
 * | Neha            | neha@example.com         |
 * +-----------------+--------------------------+
 * 
 * EXPLANATION:
 *   Returns names starting with letters A through M.
 *   Text BETWEEN works alphabetically (A-Z order).
 *   Includes names starting with 'A' and 'M'.
 */

/**
 * ======================================================================
 * 3. NOT BETWEEN — Finding values outside a range
 * ======================================================================
 *
 * WHAT IT DOES:
 *   NOT BETWEEN checks if a value lies outside an inclusive range.
 *   Finds outliers, extremes, and data that doesn't fit the norm.
 *
 * SYNTAX:
 *   WHERE column NOT BETWEEN start_value AND end_value
 *
 * EQUIVALENT TO:
 *   WHERE column < start_value OR column > end_value
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Users who signed up OUTSIDE December 2025            │
 * │ (Date range exclusion)                                            │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT
  id,
  full_name,
  signup_at_utc
FROM users
WHERE signup_at_utc NOT BETWEEN '2025-12-01 00:00:00'
                            AND '2025-12-31 23:59:59'
ORDER BY signup_at_utc;

/**
 * Output:
 * +----+-----------------+---------------------+
 * | id | full_name       | signup_at_utc       |
 * +----+-----------------+---------------------+
 * | 7  | Sara            | 2025-10-10 05:00:00 |
 * | 4  | Aayush          | 2025-11-30 23:59:59 |
 * | 6  | Mohit           | 2026-01-01 00:00:00 |
 * +----+-----------------+---------------------+
 * 
 * EXPLANATION:
 *   Returns users who signed up before Dec 1 or after Dec 31.
 *   These are the outliers — early adopters and new 2026 signups.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Extreme spenders (outside 300-1200 range)            │
 * │ (Numeric range exclusion)                                         │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name, 
    last_purchase_inr
FROM users
WHERE last_purchase_inr NOT BETWEEN 300 AND 1200
  AND last_purchase_inr IS NOT NULL
ORDER BY last_purchase_inr;

/**
 * Output:
 * +-----------------+-------------------+
 * | full_name       | last_purchase_inr |
 * +-----------------+-------------------+
 * | Sameer          | 100.00            |
 * | Mohit           | 299.00            |
 * | Neha            | 1500.00           |
 * | Promo           | 1499.00           |
 * | Sara            | 2000.00           |
 * +-----------------+-------------------+
 * 
 * EXPLANATION:
 *   Returns users who spent less than 300 OR more than 1200.
 *   These are the extremes — budget shoppers and high-value customers.
 */

/**
 * ======================================================================
 * 4. NUMERIC RANGES — Working with numbers and prices
 * ======================================================================
 *
 * BETWEEN is most commonly used with numeric data types:
 *   → Integers (age, quantity, score)
 *   → Decimals (price, weight, percentage)
 *   → Currency (amount, balance)
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Customer segmentation by purchase value                 │
 * │ Low: < 500 | Medium: 500-1000 | High: > 1000                     │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    last_purchase_inr,
    CASE 
        WHEN last_purchase_inr < 500 THEN 'Low Spender'
        WHEN last_purchase_inr BETWEEN 500 AND 1000 THEN 'Medium Spender'
        WHEN last_purchase_inr > 1000 THEN 'High Spender'
        ELSE 'No Purchase'
    END AS customer_segment
FROM users
WHERE last_purchase_inr IS NOT NULL
ORDER BY last_purchase_inr;

/**
 * Output:
 * +-----------------+-------------------+-----------------+
 * | full_name       | last_purchase_inr | customer_segment|
 * +-----------------+-------------------+-----------------+
 * | Sameer          | 100.00            | Low Spender     |
 * | Mohit           | 299.00            | Low Spender     |
 * | John Doe        | 300.00            | Low Spender     |
 * | Test User One   | 499.00            | Low Spender     |
 * | Empty City      | 499.00            | Low Spender     |
 * | Khushi          | 500.00            | Medium Spender  |
 * | Test User Two   | 750.00            | Medium Spender  |
 * | Arjun           | 799.00            | Medium Spender  |
 * | Intern          | 899.00            | Medium Spender  |
 * | Raj             | 999.00            | Medium Spender  |
 * | Priya           | 999.00            | Medium Spender  |
 * | Jane Doe        | 1200.00           | High Spender    |
 * | Promo           | 1499.00           | High Spender    |
 * | Neha            | 1500.00           | High Spender    |
 * | Sara            | 2000.00           | High Spender    |
 * +-----------------+-------------------+-----------------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Find products in specific price brackets                │
 * │ (Hypothetical product table example)                              │
 * └────────────────────────────────────────────────────────────────────┘
 */
-- This pattern works for any numeric column:
-- WHERE price BETWEEN 1000 AND 5000  → Mid-range products
-- WHERE quantity BETWEEN 10 AND 100  → Moderate inventory items
-- WHERE rating BETWEEN 4.0 AND 5.0   → Highly rated items

/**
 * ======================================================================
 * 5. DATE RANGES — Working with timestamps and dates
 * ======================================================================
 *
 * CRITICAL DATE HANDLING:
 *   Dates in SQL often include time components (timestamps).
 *   '2025-12-31' is interpreted as '2025-12-31 00:00:00'
 *   To include the entire day, use '2025-12-31 23:59:59'
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 1 — Users who signed up in Q4 2025 (Oct-Dec)              │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    signup_at_utc
FROM users
WHERE signup_at_utc BETWEEN '2025-10-01 00:00:00'
                        AND '2025-12-31 23:59:59'
ORDER BY signup_at_utc;

/**
 * Output:
 * +-----------------+---------------------+
 * | full_name       | signup_at_utc       |
 * +-----------------+---------------------+
 * | Sara            | 2025-10-10 05:00:00 |
 * | Aayush          | 2025-11-30 23:59:59 |
 * | Raj             | 2025-12-01 00:00:00 |
 * | Hello           | 2025-12-02 08:00:00 |
 * | Test User One   | 2025-12-05 10:00:00 |
 * | John Doe        | 2025-12-05 18:30:00 |
 * | Jane Doe        | 2025-12-06 18:30:00 |
 * | Support Trial   | 2025-12-07 10:00:00 |
 * | Priya           | 2025-12-08 10:00:00 |
 * | Sameer          | 2025-12-09 10:00:00 |
 * | Empty City      | 2025-12-10 10:00:00 |
 * | Test User Two   | 2025-12-10 12:00:00 |
 * | Khushi          | 2025-12-11 10:00:00 |
 * | Arjun           | 2025-12-20 09:00:00 |
 * | Intern          | 2025-12-22 20:00:00 |
 * | Promo           | 2025-12-25 00:00:00 |
 * | Neha            | 2025-12-31 23:59:59 |
 * +-----------------+---------------------+
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE 2 — Using DATE() function for cleaner date ranges         │
 * │ (Works in MySQL, PostgreSQL requires casting)                     │
 * └────────────────────────────────────────────────────────────────────┘
 */
-- MySQL style (DATE() function):
-- WHERE DATE(signup_at_utc) BETWEEN '2025-12-01' AND '2025-12-31'

-- PostgreSQL style (casting to date):
-- WHERE signup_at_utc::DATE BETWEEN '2025-12-01' AND '2025-12-31'

SELECT 
    full_name,
    signup_at_utc::DATE AS signup_date
FROM users
WHERE signup_at_utc::DATE BETWEEN '2025-12-01' AND '2025-12-31'
ORDER BY signup_date;

/**
 * Output:
 * +-----------------+-------------+
 * | full_name       | signup_date |
 * +-----------------+-------------+
 * | Raj             | 2025-12-01  |
 * | Hello           | 2025-12-02  |
 * | Test User One   | 2025-12-05  |
 * | John Doe        | 2025-12-05  |
 * | Jane Doe        | 2025-12-06  |
 * | Support Trial   | 2025-12-07  |
 * | Priya           | 2025-12-08  |
 * | Sameer          | 2025-12-09  |
 * | Empty City      | 2025-12-10  |
 * | Test User Two   | 2025-12-10  |
 * | Khushi          | 2025-12-11  |
 * | Arjun           | 2025-12-20  |
 * | Intern          | 2025-12-22  |
 * | Promo           | 2025-12-25  |
 * | Neha            | 2025-12-31  |
 * +-----------------+-------------+
 */

/**
 * ======================================================================
 * 6. TEXT RANGES — Working with alphabetical ranges
 * ======================================================================
 *
 * BETWEEN works with text columns too! It sorts alphabetically.
 * Useful for filtering names, categories, or any string column.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Users with names between 'J' and 'R'                    │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    email
FROM users
WHERE full_name BETWEEN 'J' AND 'R'
ORDER BY full_name;

/**
 * Output:
 * +-----------------+--------------------------+
 * | full_name       | email                    |
 * +-----------------+--------------------------+
 * | Jane Doe        | jane_doe@gmail.com       |
 * | John Doe        | john.doe@gmail.com       |
 * | Khushi          | khushi@gmail.com         |
 * | Mohit           | mohit@gmail.com          |
 * | Neha            | neha@example.com         |
 * | Priya           | priya@outlook.com        |
 * | Promo           | promo@demo.com           |
 * | Raj             | raj@tuf.com              |
 * +-----------------+--------------------------+
 * 
 * EXPLANATION:
 *   Returns names starting with J, K, L, M, N, O, P, Q, R
 *   'J' and 'R' are included in the results.
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ EXAMPLE — Email domains between 'gmail.com' and 'yahoo.com'       │
 * │ (Extracting domain and filtering)                                 │
 * └────────────────────────────────────────────────────────────────────┘
 */
SELECT 
    full_name,
    email,
    SPLIT_PART(email, '@', 2) AS domain
FROM users
WHERE SPLIT_PART(email, '@', 2) BETWEEN 'gmail.com' AND 'yahoo.com'
ORDER BY domain;

/**
 * Output:
 * +-----------------+--------------------------+---------------+
 * | full_name       | email                    | domain        |
 * +-----------------+--------------------------+---------------+
 * | Test User One   | test_user1@gmail.com     | gmail.com     |
 * | Test User Two   | testXuser2@gmail.com     | gmail.com     |
 * | John Doe        | john.doe@gmail.com       | gmail.com     |
 * | Jane Doe        | jane_doe@gmail.com       | gmail.com     |
 * | Khushi          | khushi@gmail.com         | gmail.com     |
 * | Mohit           | mohit@gmail.com          | gmail.com     |
 * | Sara            | sara@tuf.com             | tuf.com       |
 * | Raj             | raj@tuf.com              | tuf.com       |
 * | Intern          | intern@tuf.com           | tuf.com       |
 * | Support Trial   | support+trial@tuf.com    | tuf.com       |
 * | Arjun           | arjun@yahoo.com          | yahoo.com     |
 * +-----------------+--------------------------+---------------+
 */

/**
 * ======================================================================
 * 7. REAL-WORLD SCENARIOS — Practical business use cases
 * ======================================================================
 */

/**
 * SCENARIO 1: Sales Analysis — Find "Mid-Range" purchases
 * 
 * Store manager wants to understand the most popular price points.
 * Define mid-range as purchases between 400 and 800 INR.
 */
SELECT 
    full_name, 
    last_purchase_inr,
    CASE 
        WHEN last_purchase_inr BETWEEN 400 AND 600 THEN 'Budget Mid-Range'
        WHEN last_purchase_inr BETWEEN 600 AND 800 THEN 'Premium Mid-Range'
        ELSE 'Other'
    END AS sub_category
FROM users
WHERE last_purchase_inr BETWEEN 400 AND 800
ORDER BY last_purchase_inr;

/**
 * Output:
 * +-----------------+-------------------+---------------------+
 * | full_name       | last_purchase_inr | sub_category        |
 * +-----------------+-------------------+---------------------+
 * | Test User One   | 499.00            | Budget Mid-Range    |
 * | Empty City      | 499.00            | Budget Mid-Range    |
 * | Khushi          | 500.00            | Budget Mid-Range    |
 * | Test User Two   | 750.00            | Premium Mid-Range   |
 * | Arjun           | 799.00            | Premium Mid-Range   |
 * +-----------------+-------------------+---------------------+
 */

/**
 * SCENARIO 2: Outlier Analysis — Extreme spenders
 * 
 * Marketing team wants to target extreme spenders separately.
 * Find users who spent less than 300 OR more than 1200.
 */
SELECT 
    full_name, 
    last_purchase_inr,
    CASE 
        WHEN last_purchase_inr < 300 THEN 'Budget Shopper'
        WHEN last_purchase_inr > 1200 THEN 'Premium Shopper'
    END AS shopper_type
FROM users
WHERE last_purchase_inr NOT BETWEEN 300 AND 1200
  AND last_purchase_inr IS NOT NULL
ORDER BY last_purchase_inr;

/**
 * Output:
 * +-----------+-------------------+----------------+
 * | full_name | last_purchase_inr | shopper_type   |
 * +-----------+-------------------+----------------+
 * | Sameer    | 100.00            | Budget Shopper |
 * | Mohit     | 299.00            | Budget Shopper |
 * | Promo     | 1499.00           | Premium Shopper|
 * | Neha      | 1500.00           | Premium Shopper|
 * | Sara      | 2000.00           | Premium Shopper|
 * +-----------+-------------------+----------------+
 */

/**
 * SCENARIO 3: Time-Based Campaign — Q1 2026 Signups
 * 
 * Plan a welcome campaign for users who signed up in Q1 2026.
 */
SELECT 
    full_name,
    email,
    signup_at_utc
FROM users
WHERE signup_at_utc BETWEEN '2026-01-01 00:00:00'
                        AND '2026-03-31 23:59:59'
ORDER BY signup_at_utc;

/**
 * Output:
 * +-----------+--------------------------+---------------------+
 * | full_name | email                    | signup_at_utc       |
 * +-----------+--------------------------+---------------------+
 * | Mohit     | mohit@gmail.com          | 2026-01-01 00:00:00 |
 * +-----------+--------------------------+---------------------+
 * 
 * Only 1 user signed up in Q1 2026 so far.
 */

/**
 * SCENARIO 4: Age-Based Filtering — Users in their 20s
 * 
 * Calculate age from signup year (simplified) and filter.
 */
SELECT 
    full_name,
    EXTRACT(YEAR FROM signup_at_utc) AS signup_year,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, signup_at_utc)) AS account_age_years
FROM users
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, signup_at_utc)) BETWEEN 0 AND 1;

/**
 * Output:
 * +-----------------+-------------+-------------------+
 * | full_name       | signup_year | account_age_years |
 * +-----------------+-------------+-------------------+
 * | Raj             | 2025        | 0                 |
 * | Test User One   | 2025        | 0                 |
 * | Test User Two   | 2025        | 0                 |
 * | Aayush          | 2025        | 0                 |
 * | Neha            | 2025        | 0                 |
 * | Mohit           | 2026        | 0                 |
 * | Sara            | 2025        | 0                 |
 * | Arjun           | 2025        | 0                 |
 * | John Doe        | 2025        | 0                 |
 * | Jane Doe        | 2025        | 0                 |
 * | Support Trial   | 2025        | 0                 |
 * | Priya           | 2025        | 0                 |
 * | Sameer          | 2025        | 0                 |
 * | Empty City      | 2025        | 0                 |
 * | Khushi          | 2025        | 0                 |
 * | Promo           | 2025        | 0                 |
 * | Intern          | 2025        | 0                 |
 * | Hello           | 2025        | 0                 |
 * +-----------------+-------------+-------------------+
 */

/**
 * SCENARIO 5: Inventory Management — Reorder alert
 * 
 * Find products with low stock (between 0 and 10) that need reorder.
 * (Hypothetical product table example)
 */
-- WHERE stock_quantity BETWEEN 0 AND 10 → Critical low stock
-- WHERE stock_quantity BETWEEN 50 AND 100 → Healthy stock
-- WHERE stock_quantity NOT BETWEEN 20 AND 100 → Either low or excess stock

/**
 * ======================================================================
 * 8. COMMON MISTAKES — Pitfalls with BETWEEN
 * ======================================================================
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #1 — Wrong order of values (low > high)                   │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG:                                                        │
 * │   WHERE last_purchase_inr BETWEEN 1000 AND 500;                   │
 * │   → Returns NO rows because low > high                            │
 * │                                                                    │
 * │   ✅ CORRECT:                                                      │
 * │   WHERE last_purchase_inr BETWEEN 500 AND 1000;                   │
 * │   → Returns rows between 500 and 1000                             │
 * │                                                                    │
 * │   WHY? BETWEEN expects lower bound first, then upper bound.       │
 * │        If you reverse them, the range is invalid.                 │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2 — Forgetting that BETWEEN is inclusive                 │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   Example: BETWEEN 1 AND 10 includes 1 and 10                     │
 * │                                                                    │
 * │   If you want to EXCLUDE boundaries, use > and < instead:         │
 * │   WHERE last_purchase_inr > 400 AND last_purchase_inr < 800       │
 * │   → Excludes exactly 400 and 800                                  │
 * │                                                                    │
 * │   WHERE last_purchase_inr BETWEEN 400 AND 800                     │
 * │   → Includes 400 and 800 if they exist                            │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3 — NULL values in BETWEEN                               │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   NULL values are NEVER included in BETWEEN or NOT BETWEEN.       │
 * │                                                                    │
 * │   SELECT full_name, last_purchase_inr                             │
 * │   FROM users                                                      │
 * │   WHERE last_purchase_inr BETWEEN 400 AND 800;                    │
 * │   → NULL purchases are NOT included (they are unknown)            │
 * │                                                                    │
 * │   ✅ To include NULLs, handle them separately:                     │
 * │   WHERE last_purchase_inr BETWEEN 400 AND 800                     │
 * │      OR last_purchase_inr IS NULL;                                │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4 — Date boundary issues with time components            │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   ❌ WRONG — Misses events on Dec 31 after midnight:              │
 * │   WHERE signup_at_utc BETWEEN '2025-12-01' AND '2025-12-31';      │
 * │   → '2025-12-31' is interpreted as '2025-12-31 00:00:00'          │
 * │   → Misses events at 10:00 AM on Dec 31!                          │
 * │                                                                    │
 * │   ✅ CORRECT — Include the entire last day:                        │
 * │   WHERE signup_at_utc BETWEEN '2025-12-01 00:00:00'               │
 * │                         AND '2025-12-31 23:59:59';                │
 * │                                                                    │
 * │   ✅ Alternative — Use date casting:                               │
 * │   WHERE signup_at_utc::DATE BETWEEN '2025-12-01' AND '2025-12-31';│
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5 — Using BETWEEN with timestamps and forgetting time    │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   SELECT * FROM users                                             │
 * │   WHERE signup_at_utc BETWEEN '2025-12-31' AND '2025-12-31';      │
 * │   → Only includes rows with signup_at_utc = '2025-12-31 00:00:00' │
 * │   → Neha (id 5) signed up at 23:59:59 is MISSED!                  │
 * │                                                                    │
 * │   ✅ ALWAYS consider time components or cast to date!             │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #6 — Using BETWEEN with text and unexpected order         │
 * ├────────────────────────────────────────────────────────────────────┤
 * │                                                                    │
 * │   Text BETWEEN uses alphabetical order:                           │
 * │   WHERE full_name BETWEEN 'A' AND 'M'                             │
 * │   → Includes names starting with A, B, C, ..., M                  │
 * │                                                                    │
 * │   ⚠️ Case sensitivity matters!                                    │
 * │   'apple' > 'Apple'? Depends on collation.                        │
 * │   Use LOWER() for case-insensitive ranges:                        │
 * │   WHERE LOWER(full_name) BETWEEN 'a' AND 'm'                      │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ======================================================================
 * 9. QUICK REFERENCE — Cheat sheet
 * ======================================================================
 *
 * BASIC SYNTAX:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ BETWEEN low AND high      → Inclusive range (low ≤ col ≤ high)   │
 * │ NOT BETWEEN low AND high  → Outside range (col < low OR col > high)│
 * └────────────────────────────────────────────────────────────────────┘
 *
 * NUMERIC RANGES:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ WHERE price BETWEEN 100 AND 200     → Products between $100-$200  │
 * │ WHERE age BETWEEN 18 AND 25         → Age 18-25                   │
 * │ WHERE quantity NOT BETWEEN 10 AND 50→ Low or high stock           │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * DATE RANGES (with time components):
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Full day range (include entire day)                           │
 * │ WHERE date_col BETWEEN '2025-12-01 00:00:00'                     │
 * │                   AND '2025-12-31 23:59:59'                      │
 * │                                                                   │
 * │ -- Cleaner with date casting                                      │
 * │ WHERE date_col::DATE BETWEEN '2025-12-01' AND '2025-12-31'       │
 * │                                                                   │
 * │ -- Current month                                                 │
 * │ WHERE date_col BETWEEN DATE_TRUNC('month', CURRENT_DATE)         │
 * │                   AND DATE_TRUNC('month', CURRENT_DATE)           │
 * │                       + INTERVAL '1 month' - INTERVAL '1 second' │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * TEXT RANGES:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ WHERE name BETWEEN 'A' AND 'M'     → Names A-M                   │
 * │ WHERE LOWER(name) BETWEEN 'a' AND 'm' → Case-insensitive         │
 * │ WHERE email NOT BETWEEN 'a' AND 'z' → Non-alphabetical emails    │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * COMMON PATTERNS:
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ -- Find middle 80% (exclude extremes)                            │
 * │ WHERE value BETWEEN PERCENTILE_CONT(0.1)                         │
 * │                 AND PERCENTILE_CONT(0.9)                         │
 * │                                                                   │
 * │ -- Age groups                                                    │
 * │ CASE WHEN age BETWEEN 0 AND 17 THEN 'Minor'                      │
 * │      WHEN age BETWEEN 18 AND 64 THEN 'Adult'                     │
 * │      WHEN age >= 65 THEN 'Senior' END                            │
 * │                                                                   │
 * │ -- Time-based segmentation                                        │
 * │ WHERE signup_date BETWEEN '2025-01-01' AND '2025-06-30'          │
 * │   → H1 2025 signups                                               │
 * └────────────────────────────────────────────────────────────────────┘
 */

/**
 * ======================================================================
 * 10. GOLDEN RULES — Key principles to remember
 * ======================================================================
 *
 * 1. ✅ BETWEEN is INCLUSIVE — always includes both boundaries.
 *      If you need exclusive, use > and < instead.
 *
 * 2. ✅ Always put the LOWER value first, then the HIGHER value.
 *      BETWEEN 500 AND 1000 ✓    BETWEEN 1000 AND 500 ✗
 *
 * 3. ⚠️ When working with timestamps, be careful with date boundaries.
 *      '2025-12-31' = '2025-12-31 00:00:00' (midnight)
 *      Use '2025-12-31 23:59:59' to include the entire day.
 *
 * 4. ✅ NULL values are NEVER included in BETWEEN or NOT BETWEEN.
 *      They represent unknown and cannot be evaluated against ranges.
 *
 * 5. ✅ Use BETWEEN for clean, readable range queries.
 *      It's much cleaner than col >= low AND col <= high.
 *
 * 6. ✅ NOT BETWEEN is perfect for finding outliers and extremes.
 *      Use it to focus on the edges of your data distribution.
 *
 * 7. 💡 PRO TIP: For date ranges, cast to DATE to ignore time:
 *      WHERE date_col::DATE BETWEEN '2025-01-01' AND '2025-12-31'
 *
 * 8. 💡 PRO TIP: For performance, ensure the column you're using
 *      BETWEEN on has an index for faster range scans.
 *
 * 9. ✅ BETWEEN works with multiple data types:
 *      → Numbers (price, age, quantity)
 *      → Dates and timestamps (signup date, order date)
 *      → Text (names, categories) — alphabetically sorted
 *
 * 10. 💡 PRO TIP: When analyzing data, use BETWEEN to create segments:
 *       Low: < 500, Medium: BETWEEN 500 AND 1000, High: > 1000
 *
 * ======================================================================
 */