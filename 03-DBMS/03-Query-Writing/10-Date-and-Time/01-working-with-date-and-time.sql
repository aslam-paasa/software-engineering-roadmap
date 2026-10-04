/**
 * Deep Dive — DATE AND TIME FUNCTIONS:
 * SECTION 1  : Date & Time Data Types (DATE vs TIMESTAMP)
 * SECTION 2  : Sample Tables & Data Setup
 * SECTION 3  : Extracting Date Parts (YEAR, MONTH, DAY)
 * SECTION 4  : Extracting Time Parts (HOUR, MINUTE, SECOND)
 * SECTION 5  : Filtering by Date (WHERE with dates)
 * SECTION 6  : The BETWEEN Trap — Most Common Mistake
 * SECTION 7  : Correct Date Range Filtering (Half-open interval)
 * SECTION 8  : MIN and MAX with Dates
 * SECTION 9  : Date Differences (Days, Hours, Minutes)
 * SECTION 10 : Current Date and Time
 * SECTION 11 : GROUP BY with Dates
 * SECTION 12 : Real-World Scenarios (5 complete examples)
 * SECTION 13 : Common Mistakes
 * SECTION 14 : Practice Exercises
 * SECTION 15 : Quick Reference
 * SECTION 16 : Golden Rules
 */


/**
 * ======================================================================
 * SECTION 1 — DATE & TIME DATA TYPES
 * ======================================================================
 *
 * SQL has two main types for storing date and time information.
 * Choosing the right one depends on whether you need the TIME or not.
 *
 * ┌─────────────────┬─────────────────────────┬──────────────────────┐
 * │ Type            │ What it stores          │ Example              │
 * ├─────────────────┼─────────────────────────┼──────────────────────┤
 * │ DATE            │ Only the date           │ 2029-08-19           │
 * │                 │ (year, month, day)      │ No time information  │
 * │ TIMESTAMP       │ Date AND time together  │ 2029-05-18 12:50:45  │
 * │                 │ (year, month, day,      │ Shows the exact      │
 * │                 │  hour, minute, second)  │ moment something     │
 * │                 │                         │ happened             │
 * └─────────────────┴─────────────────────────┴──────────────────────┘
 *
 * When to use which:
 *   DATE      → When time does not matter. Example: employee joining date,
 *               birthday, public holiday
 *   TIMESTAMP → When the exact moment matters. Example: login time,
 *               order placed time, payment processed time
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Example — see how both look:                                    │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       DATE '2029-08-19' AS date_only,                           │
 * │       TIMESTAMP '2029-05-18 12:50:45' AS datetime_with_time;    │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +────────────+─────────────────────+                            │
 * │ | date_only  | datetime_with_time  |                            │
 * │ +────────────+─────────────────────+                            │
 * │ | 2029-08-19 | 2029-05-18 12:50:45 |                            │
 * │ +────────────+─────────────────────+                            │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Format rule: SQL always writes dates as YYYY-MM-DD
 *   YYYY = 4-digit year  (2029)
 *   MM   = 2-digit month (08 for August)
 *   DD   = 2-digit day   (19)
 */


/**
 * ======================================================================
 * SECTION 2 — SAMPLE TABLES & DATA SETUP
 * ======================================================================
 *
 * All examples in this guide use these four tables.
 * Read this section once so you understand the data before the queries.
 */

-- ── TABLE 1: employees ────────────────────────────────────────────────
-- Stores employee joining information.
-- Note: Arjun has NULL joining_date (he was added but never assigned a date)

CREATE TABLE employees (
    emp_id       SERIAL PRIMARY KEY,
    name         VARCHAR(50),
    joining_date DATE,           -- DATE only, no time needed
    department   VARCHAR(50)
);

INSERT INTO employees (name, joining_date, department) VALUES
('Aditi', '2028-03-15', 'Engineering'),
('Rohan', '2028-11-04', 'Support'),
('Kiran', '2029-03-22', 'Engineering'),
('Neha',  '2028-02-29', 'HR'),
('Arjun',  NULL,        'Engineering'),  -- ← no joining date
('Farah', '2028-01-01', 'Product'),
('Ishan', '2028-12-31', 'Support'),
('Zoya',  '2028-02-29', 'Engineering'),
('Kabir', '2028-12-01', 'Finance'),
('Tara',  '2029-02-10', 'Support');

-- ── TABLE 2: orders ──────────────────────────────────────────────────
-- Stores customer order records.
-- Has both a DATE column and a TIMESTAMP column — shows the difference.

CREATE TABLE orders (
    order_id       SERIAL PRIMARY KEY,
    customer       VARCHAR(50),
    order_date     DATE,           -- date only
    order_datetime TIMESTAMP,      -- date + exact time
    amount         DECIMAL(10,2),
    status         VARCHAR(20)
);

INSERT INTO orders (customer, order_date, order_datetime, amount, status) VALUES
('Asha',   '2029-01-05', '2029-01-05 09:30:00', 349.00,  'PLACED'),
('Ravi',   '2029-01-18', '2029-01-18 14:45:00', 1200.00, 'DELIVERED'),
('Meera',  '2029-02-02', '2029-02-02 10:00:00', 799.00,  'DELIVERED'),
('Asha',   '2028-12-30', '2028-12-30 18:20:00', 499.00,  'DELIVERED'),
('Dev',    '2029-02-10', '2029-02-10 15:30:00', 50.00,   'CANCELLED'),
('Isha',   '2028-02-29', '2028-02-29 09:00:00', 999.00,  'DELIVERED'),
('Kabir',  '2029-03-01', '2029-03-01 08:15:00', 199.00,  'PLACED'),
('Simran', '2029-03-15', '2029-03-15 12:00:00', 299.00,  'DELIVERED'),
('Nikhil', '2028-11-11', '2028-11-11 16:30:00', 899.00,  'DELIVERED'),
('Rohan',  '2029-04-23', '2029-04-23 11:45:00', 149.00,  'PLACED'),
('Meera',  '2029-05-01', '2029-05-01 20:00:00', 399.00,  'CANCELLED'),
('Asha',   '2029-02-28', '2029-02-28 12:30:00', 129.00,  'DELIVERED');

-- ── TABLE 3: logins ──────────────────────────────────────────────────
-- Stores user login records with exact time.
-- This table is used to demonstrate the BETWEEN trap (Section 6).
-- Notice some logins happen at midnight (00:00:00) and some at 23:59:59.

CREATE TABLE logins (
    login_id   SERIAL PRIMARY KEY,
    username   VARCHAR(50),
    login_time TIMESTAMP,          -- exact moment of login
    device     VARCHAR(20),
    ip_address VARCHAR(20)
);

INSERT INTO logins (username, login_time, device, ip_address) VALUES
('Ashwin', '2029-01-15 09:00:00', 'android', '10.0.0.1'),
('Ashwin', '2029-02-10 09:00:00', 'web',     '10.0.0.2'),
('Simran', '2029-01-20 20:15:00', 'ios',     '10.0.0.3'),
('Nikhil', '2029-02-10 00:00:00', 'web',     '10.0.0.4'), -- ← midnight
('Nikhil', '2029-02-10 00:00:00', 'web',     '10.0.0.5'), -- ← midnight again
('Priya',  '2029-02-09 23:59:59', 'android', '10.0.0.6'), -- ← one second before midnight
('Priya',  '2029-02-10 23:59:59', 'android', '10.0.0.7'), -- ← last second of Feb 10
('Asha',   '2029-02-11 00:00:00', 'web',     '10.0.0.8'),
('Isha',   '2029-01-31 10:30:00', 'web',     '10.0.0.9'),
('Isha',   '2029-02-01 10:30:00', 'web',     '10.0.0.10'),
('Dev',    '2029-02-10 15:45:00', 'ios',     '10.0.0.11'),
('Kabir',  '2029-02-05 08:00:00', 'web',     '10.0.0.12'),
('Meera',  '2029-02-10 09:00:00', 'android', '10.0.0.13');

-- ── TABLE 4: deliveries ──────────────────────────────────────────────
-- Stores food delivery records.
-- Note: Rohit's delivery has NULL delivered_at (not delivered yet)
-- Note: Priya's delivered_at is BEFORE order_placed_at (bad data)

CREATE TABLE deliveries (
    delivery_id    SERIAL PRIMARY KEY,
    order_placed_at TIMESTAMP,
    delivered_at   TIMESTAMP,      -- NULL if not delivered yet
    customer       VARCHAR(50),
    restaurant     VARCHAR(50)
);

INSERT INTO deliveries (order_placed_at, delivered_at, customer, restaurant) VALUES
('2029-02-10 12:00:00', '2029-02-10 12:18:00', 'Ayaan', 'Pizza Hut'),
('2029-02-10 12:05:00', '2029-02-10 12:42:00', 'Sneha', 'Burger King'),
('2029-02-10 12:10:00', NULL,                   'Rohit', 'KFC'),          -- pending
('2029-02-10 12:20:00', '2029-02-10 12:10:00', 'Priya', 'Dominoz'),      -- bad data
('2029-02-10 13:00:00', '2029-02-10 13:31:00', 'Neha',  'Pizza Hut'),
('2029-02-10 14:00:00', '2029-02-10 14:30:00', 'Amit',  'McDonalds'),
('2029-02-09 23:55:00', '2029-02-10 00:25:00', 'Kavya', 'KFC'),          -- crosses midnight
('2029-02-10 23:59:00', '2029-02-11 00:10:00', 'Raj',   'Burger King'),  -- crosses midnight
('2029-02-11 12:00:00', '2029-02-11 12:20:00', 'Ayaan', 'Pizza Hut'),
('2029-02-08 12:00:00', '2029-02-08 12:05:00', 'Sneha', 'Dominoz');


/**
 * ======================================================================
 * SECTION 3 — EXTRACTING DATE PARTS (YEAR, MONTH, DAY)
 * ======================================================================
 *
 * EXTRACT() is a function that reads one specific part from a date
 * or timestamp and gives you just that number.
 *
 * Syntax: EXTRACT(part FROM column)
 *   part = YEAR, MONTH, or DAY
 *
 * Think of it like asking: "From this full date, give me only the year."
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Basic example — extract year, month, day from a fixed date      │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       EXTRACT(YEAR  FROM DATE '2029-08-19') AS year,            │
 * │       EXTRACT(MONTH FROM DATE '2029-08-19') AS month,           │
 * │       EXTRACT(DAY   FROM DATE '2029-08-19') AS day;             │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────+───────+─────+                                          │
 * │ | year | month | day |                                          │
 * │ +──────+───────+─────+                                          │
 * │ | 2029 | 8     | 19  |                                          │
 * │ +──────+───────+─────+                                          │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Real table example — extract from employees joining_date        │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       emp_id, name,                                             │
 * │       EXTRACT(YEAR  FROM joining_date) AS join_year,            │
 * │       EXTRACT(MONTH FROM joining_date) AS join_month            │
 * │   FROM employees                                                │
 * │   ORDER BY emp_id;                                              │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +────────+───────────+───────────+────────────+                 │
 * │ | emp_id | name      | join_year | join_month |                 │
 * │ +────────+───────────+───────────+────────────+                 │
 * │ | 1      | Aditi     | 2028      | 3          |                 │
 * │ | 2      | Rohan     | 2028      | 11         |                 │
 * │ | 3      | Kiran     | 2029      | 3          |                 │
 * │ | 4      | Neha      | 2028      | 2          |                 │
 * │ | 5      | Arjun     | NULL      | NULL       | ← no date!      │
 * │ | 6      | Farah     | 2028      | 1          |                 │
 * │ | 7      | Ishan     | 2028      | 12         |                 │
 * │ | 8      | Zoya      | 2028      | 2          |                 │
 * │ | 9      | Kabir     | 2028      | 12         |                 │
 * │ | 10     | Tara      | 2029      | 2          |                 │
 * │ +────────+───────────+───────────+────────────+                 │
 * │                                                                 │
 * │ Important: Arjun's joining_date is NULL.                        │
 * │ EXTRACT(YEAR FROM NULL) → returns NULL, NOT zero.               │
 * └─────────────────────────────────────────────────────────────────┘
 */

-- Query 1: Basic date part extraction
SELECT
    EXTRACT(YEAR  FROM DATE '2029-08-19') AS year,
    EXTRACT(MONTH FROM DATE '2029-08-19') AS month,
    EXTRACT(DAY   FROM DATE '2029-08-19') AS day;

-- Query 2: Extract from table column
SELECT
    emp_id,
    name,
    EXTRACT(YEAR  FROM joining_date) AS join_year,
    EXTRACT(MONTH FROM joining_date) AS join_month
FROM employees
ORDER BY emp_id;


/**
 * ======================================================================
 * SECTION 4 — EXTRACTING TIME PARTS (HOUR, MINUTE, SECOND)
 * ======================================================================
 *
 * EXTRACT() also works on TIMESTAMP columns to get the time parts.
 * You cannot extract HOUR, MINUTE, or SECOND from a DATE column
 * because DATE does not store time.
 *
 * ┌──────────────────────────────────────────────────────────────────────┐
 * │ Basic example — extract hour, minute, second                         │
 * ├──────────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                             │
 * │       EXTRACT(HOUR   FROM TIMESTAMP '2029-05-18 12:50:45') AS hour,  │
 * │       EXTRACT(MINUTE FROM TIMESTAMP '2029-05-18 12:50:45') AS minute,│
 * │       EXTRACT(SECOND FROM TIMESTAMP '2029-05-18 12:50:45') AS second;│
 * │                                                                      │
 * │ Output:                                                              │
 * │ +──────+────────+────────+                                           │
 * │ | hour | minute | second |                                           │
 * │ +──────+────────+────────+                                           │
 * │ | 12   | 50     | 45     |                                           │
 * │ +──────+────────+────────+                                           │
 * └──────────────────────────────────────────────────────────────────────┘
 *
 * ┌───────────────────────────────────────────────────────────────────────────┐
 * │ Real table example — extract from orders.order_datetime                   │
 * ├───────────────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                                  │
 * │       order_id, customer, order_datetime,                                 │
 * │       EXTRACT(HOUR   FROM order_datetime) AS order_hour,                  │
 * │       EXTRACT(MINUTE FROM order_datetime) AS order_minute                 │
 * │   FROM orders                                                             │
 * │   LIMIT 5;                                                                │
 * │                                                                           │
 * │ Output:                                                                   │
 * │ +──────────+──────────+─────────────────────+────────────+──────────────+ │
 * │ | order_id | customer | order_datetime      | order_hour | order_minute | │
 * │ +──────────+──────────+─────────────────────+────────────+──────────────+ │
 * │ | 1        | Asha     | 2029-01-05 09:30:00 | 9          | 30           | │
 * │ | 2        | Ravi     | 2029-01-18 14:45:00 | 14         | 45           | │
 * │ | 3        | Meera    | 2029-02-02 10:00:00 | 10         | 0            | │
 * │ | 4        | Asha     | 2028-12-30 18:20:00 | 18         | 20           | │
 * │ | 5        | Dev      | 2029-02-10 15:30:00 | 15         | 30           | │
 * │ +──────────+──────────+─────────────────────+────────────+──────────────+ │
 * └───────────────────────────────────────────────────────────────────────────┘
 */

-- Query 1: Basic time part extraction
SELECT
    EXTRACT(HOUR   FROM TIMESTAMP '2029-05-18 12:50:45') AS hour,
    EXTRACT(MINUTE FROM TIMESTAMP '2029-05-18 12:50:45') AS minute,
    EXTRACT(SECOND FROM TIMESTAMP '2029-05-18 12:50:45') AS second;

-- Query 2: Extract from table column
SELECT
    order_id,
    customer,
    order_datetime,
    EXTRACT(HOUR   FROM order_datetime) AS order_hour,
    EXTRACT(MINUTE FROM order_datetime) AS order_minute
FROM orders
LIMIT 5;


/**
 * ======================================================================
 * SECTION 5 — FILTERING BY DATE (WHERE with dates)
 * ======================================================================
 *
 * You can use DATE and TIMESTAMP values inside a WHERE clause
 * just like you use numbers or text. The same comparison operators
 * work: =, >, <, >=, <=
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Example 1 — Filter by exact date                                │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT order_id, customer, order_date, amount                 │
 * │   FROM orders                                                   │
 * │   WHERE order_date = DATE '2029-01-05';                         │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────+──────────+────────────+────────+                   │
 * │ | order_id | customer | order_date | amount |                   │
 * │ +──────────+──────────+────────────+────────+                   │
 * │ | 1        | Asha     | 2029-01-05 | 349.00 |                   │
 * │ +──────────+──────────+────────────+────────+                   │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Example 2 — Filter by year and month using EXTRACT              │
 * │ (Note: This works but is slower on large tables — see Section 7)│
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT order_id, customer, order_date                         │
 * │   FROM orders                                                   │
 * │   WHERE EXTRACT(YEAR  FROM order_date) = 2029                   │
 * │     AND EXTRACT(MONTH FROM order_date) = 1;                     │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────+──────────+────────────+                            │
 * │ | order_id | customer | order_date |                            │
 * │ +──────────+──────────+────────────+                            │
 * │ | 1        | Asha     | 2029-01-05 |                            │
 * │ | 2        | Ravi     | 2029-01-18 |                            │
 * │ +──────────+──────────+────────────+                            │
 * └─────────────────────────────────────────────────────────────────┘
 */

-- Query 1: Exact date filter
SELECT order_id, customer, order_date, amount
FROM orders
WHERE order_date = DATE '2029-01-05';

-- Query 2: Filter by year and month with EXTRACT
SELECT order_id, customer, order_date
FROM orders
WHERE EXTRACT(YEAR  FROM order_date) = 2029
  AND EXTRACT(MONTH FROM order_date) = 1;


/**
 * ======================================================================
 * SECTION 6 — THE BETWEEN TRAP: Most Important Mistake to Avoid
 * ======================================================================
 *
 * This is one of the most common and dangerous mistakes in SQL.
 * Please read this section carefully.
 *
 * The problem:
 * ─────────────────────────────────────────────────────────────────────
 * When you use BETWEEN with a DATE value on a TIMESTAMP column,
 * SQL converts the DATE to a TIMESTAMP at midnight (00:00:00).
 *
 * So this query:
 *   WHERE login_time BETWEEN DATE '2029-02-10' AND DATE '2029-02-10'
 *
 * Actually becomes:
 *   WHERE login_time >= '2029-02-10 00:00:00'
 *     AND login_time <= '2029-02-10 00:00:00'
 *
 * This only finds logins at EXACTLY midnight — nothing else!
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ ❌ WRONG query — using BETWEEN on a TIMESTAMP column ❌           │
 * ├────────────────────────────────────────────────────────────────────┤
 * │   SELECT login_id, username, login_time                            │
 * │   FROM logins                                                      │
 * │   WHERE login_time BETWEEN DATE '2029-02-10' AND DATE '2029-02-10';│
 * │                                                                    │
 * │ Output (almost empty — only midnight logins!):                     │
 * │ +──────────+──────────+─────────────────────+                      │
 * │ | login_id | username | login_time          |                      │
 * │ +──────────+──────────+─────────────────────+                      │
 * │ | 4        | Nikhil   | 2029-02-10 00:00:00 |                      │
 * │ | 5        | Nikhil   | 2029-02-10 00:00:00 |                      │
 * │ +──────────+──────────+─────────────────────+                      │
 * │                                                                    │
 * │ ❌ MISSING: logins at 09:00, 15:45, 23:59:59 on the same day ❌   │
 * └────────────────────────────────────────────────────────────────────┘
 *
 * Why those logins are missing:
 *   09:00:00 > 00:00:00  AND  09:00:00 <= 00:00:00  → FALSE (excluded)
 *   15:45:00 > 00:00:00  AND  15:45:00 <= 00:00:00  → FALSE (excluded)
 *   23:59:59 > 00:00:00  AND  23:59:59 <= 00:00:00  → FALSE (excluded)
 *
 * The correct solution is in Section 7 below.
 */

-- ❌ WRONG — do NOT do this on a TIMESTAMP column
SELECT login_id, username, login_time
FROM logins
WHERE login_time BETWEEN DATE '2029-02-10' AND DATE '2029-02-10';


/**
 * ======================================================================
 * SECTION 7 — CORRECT DATE RANGE FILTERING (Half-open interval)
 * ======================================================================
 *
 * The solution to the BETWEEN trap is called the "half-open interval".
 * It means: include the start, exclude the end.
 *
 * The pattern:
 *   WHERE col >= start_timestamp
 *     AND col <  next_day_timestamp
 *
 * The key is using < (strictly less than) on the end, NOT <=.
 * This way, everything from 00:00:00 to 23:59:59.999 is included,
 * and nothing from the next day creeps in.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ ✅ CORRECT query — all logins on February 10, 2029 ✅          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT login_id, username, login_time                         │
 * │   FROM logins                                                   │
 * │   WHERE login_time >= TIMESTAMP '2029-02-10 00:00:00'           │
 * │     AND login_time <  TIMESTAMP '2029-02-11 00:00:00'           │
 * │   ORDER BY login_time;                                          │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────+──────────+─────────────────────+                   │
 * │ | login_id | username | login_time          |                   │
 * │ +──────────+──────────+─────────────────────+                   │
 * │ | 4        | Nikhil   | 2029-02-10 00:00:00 |                   │
 * │ | 5        | Nikhil   | 2029-02-10 00:00:00 |                   │
 * │ | 13       | Meera    | 2029-02-10 09:00:00 |                   │
 * │ | 2        | Ashwin   | 2029-02-10 09:00:00 |                   │
 * │ | 11       | Dev      | 2029-02-10 15:45:00 |                   │
 * │ | 7        | Priya    | 2029-02-10 23:59:59 |                   │
 * │ +──────────+──────────+─────────────────────+                   │
 * │                                                                 │
 * │ ✅ All 6 logins on Feb 10 are now found — nothing missed! ✅   │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Pattern for a full month — all orders in January 2029           │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT order_id, customer, order_datetime                     │
 * │   FROM orders                                                   │
 * │   WHERE order_datetime >= TIMESTAMP '2029-01-01 00:00:00'       │
 * │     AND order_datetime <  TIMESTAMP '2029-02-01 00:00:00';      │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────+──────────+─────────────────────+                   │
 * │ | order_id | customer | order_datetime      |                   │
 * │ +──────────+──────────+─────────────────────+                   │
 * │ | 1        | Asha     | 2029-01-05 09:30:00 |                   │
 * │ | 2        | Ravi     | 2029-01-18 14:45:00 |                   │
 * │ +──────────+──────────+─────────────────────+                   │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Why "half-open" works and "23:59:59" does not:
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ ❌ WHERE col <= '2029-02-10 23:59:59' ❌                        │
 * │    → Fails for 2029-02-10 23:59:59.500 (milliseconds missed!)    │
 * │                                                                  │
 * │ ✅ WHERE col <  '2029-02-11 00:00:00' ✅                        │
 * │    → Safe for ALL timestamps including milliseconds              │
 * └──────────────────────────────────────────────────────────────────┘
 */

-- ✅ CORRECT — single day
SELECT login_id, username, login_time
FROM logins
WHERE login_time >= TIMESTAMP '2029-02-10 00:00:00'
  AND login_time <  TIMESTAMP '2029-02-11 00:00:00'
ORDER BY login_time;

-- ✅ CORRECT — full month
SELECT order_id, customer, order_datetime
FROM orders
WHERE order_datetime >= TIMESTAMP '2029-01-01 00:00:00'
  AND order_datetime <  TIMESTAMP '2029-02-01 00:00:00';


/**
 * ======================================================================
 * SECTION 8 — MIN AND MAX WITH DATES
 * ======================================================================
 *
 * MIN() and MAX() work with dates and timestamps exactly the same way
 * they work with numbers. "Smallest" date = earliest. "Largest" = latest.
 *
 * MIN(date) → finds the earliest / first occurrence
 * MAX(date) → finds the latest / most recent occurrence
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Find each user's first and latest login time                    │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       username,                                                 │
 * │       MIN(login_time) AS first_login,                           │
 * │       MAX(login_time) AS latest_login,                          │
 * │       COUNT(*)        AS number_of_logins                       │
 * │   FROM logins                                                   │
 * │   GROUP BY username                                             │
 * │   ORDER BY username;                                            │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────+─────────────────────+─────────────────────+──────+ │
 * │ | username | first_login         | latest_login        |count|  │
 * │ +──────────+─────────────────────+─────────────────────+──────+ │
 * │ | Asha     | 2029-02-11 00:00:00 | 2029-02-11 00:00:00 | 1   |  │
 * │ | Ashwin   | 2029-01-15 09:00:00 | 2029-02-10 09:00:00 | 2   |  │
 * │ | Dev      | 2029-02-10 15:45:00 | 2029-02-10 15:45:00 | 1   |  │
 * │ | Isha     | 2029-01-31 10:30:00 | 2029-02-01 10:30:00 | 2   |  │
 * │ | Kabir    | 2029-02-05 08:00:00 | 2029-02-05 08:00:00 | 1   |  │
 * │ | Meera    | 2029-02-10 09:00:00 | 2029-02-10 09:00:00 | 1   |  │
 * │ | Nikhil   | 2029-02-10 00:00:00 | 2029-02-10 00:00:00 | 2   |  │
 * │ | Priya    | 2029-02-09 23:59:59 | 2029-02-10 23:59:59 | 2   |  │
 * │ | Simran   | 2029-01-20 20:15:00 | 2029-01-20 20:15:00 | 1   |  │
 * │ +──────────+─────────────────────+─────────────────────+──────+ │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌──────────────────────────────────────────────────────────────────────────────────────┐
 * │ Find the overall first and last order date in the system                             │
 * ├──────────────────────────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                                             │
 * │       MIN(order_date)     AS first_order_date,                                       │
 * │       MAX(order_date)     AS last_order_date,                                        │
 * │       MIN(order_datetime) AS first_order_datetime,                                   │
 * │       MAX(order_datetime) AS last_order_datetime                                     │
 * │   FROM orders;                                                                       │
 * │                                                                                      │
 * │ Output:                                                                              │
 * │ +───────────────────+──────────────────+─────────────────────+─────────────────────+ │
 * │ | first_order_date  | last_order_date  | first_order_datetime| last_order_datetime | │
 * │ +───────────────────+──────────────────+─────────────────────+─────────────────────+ │
 * │ | 2028-02-29        | 2029-05-01       | 2028-02-29 09:00:00 | 2029-05-01 20:00:00 | │
 * │ +───────────────────+──────────────────+─────────────────────+─────────────────────+ │
 * └──────────────────────────────────────────────────────────────────────────────────────┘
 */

-- Query 1: First and latest login per user
SELECT
    username,
    MIN(login_time) AS first_login,
    MAX(login_time) AS latest_login,
    COUNT(*)        AS number_of_logins
FROM logins
GROUP BY username
ORDER BY username;

-- Query 2: Overall date range in orders
SELECT
    MIN(order_date)     AS first_order_date,
    MAX(order_date)     AS last_order_date,
    MIN(order_datetime) AS first_order_datetime,
    MAX(order_datetime) AS last_order_datetime
FROM orders;


/**
 * ======================================================================
 * SECTION 9 — DATE DIFFERENCES
 * ======================================================================
 *
 * You can subtract dates and timestamps from each other to find
 * how much time has passed between two moments.
 *
 * Two different methods depending on what you need:
 *
 * ┌──────────────────────┬──────────────────────────────────────────┐
 * │ What you need        │ How to calculate it                      │
 * ├──────────────────────┼──────────────────────────────────────────┤
 * │ Days between 2 dates │ date1 - date2                            │
 * │ Hours between 2 times│ EXTRACT(EPOCH FROM (ts1 - ts2)) / 3600   │
 * │ Minutes between times│ EXTRACT(EPOCH FROM (ts1 - ts2)) / 60     │
 * └──────────────────────┴──────────────────────────────────────────┘
 *
 * What is EPOCH?
 *   EPOCH converts a time difference into total seconds.
 *   Then you divide by 60 to get minutes, or 3600 to get hours.
 *   Think of it as: "How many seconds is this gap?"
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Days difference between two dates                               │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT DATE '2029-07-19' - DATE '2029-01-10' AS days_diff;    │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────+                                                    │
 * │ | days_diff|                                                    │
 * │ +──────────+                                                    │
 * │ | 190      |                                                    │
 * │ +──────────+                                                    │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Hours difference between two timestamps                         │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       EXTRACT(EPOCH FROM (                                      │
 * │           TIMESTAMP '2029-09-10 12:07:10'                       │
 * │           - TIMESTAMP '2029-01-10 19:07:10'                     │
 * │       )) / 3600 AS hours_diff;                                  │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +────────────+                                                  │
 * │ | hours_diff |                                                  │
 * │ +────────────+                                                  │
 * │ | 5825       |                                                  │
 * │ +────────────+                                                  │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Minutes difference between two timestamps                       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       EXTRACT(EPOCH FROM (                                      │
 * │           TIMESTAMP '2029-09-10 12:07:10'                       │
 * │           - TIMESTAMP '2029-01-10 19:07:10'                     │
 * │       )) / 60 AS minutes_diff;                                  │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +──────────────+                                                │
 * │ | minutes_diff |                                                │
 * │ +──────────────+                                                │
 * │ | 349500       |                                                │
 * │ +──────────────+                                                │
 * └─────────────────────────────────────────────────────────────────┘
 */

-- Days difference
SELECT DATE '2029-07-19' - DATE '2029-01-10' AS days_diff;

-- Hours difference
SELECT
    EXTRACT(EPOCH FROM (
        TIMESTAMP '2029-09-10 12:07:10'
        - TIMESTAMP '2029-01-10 19:07:10'
    )) / 3600 AS hours_diff;

-- Minutes difference
SELECT
    EXTRACT(EPOCH FROM (
        TIMESTAMP '2029-09-10 12:07:10'
        - TIMESTAMP '2029-01-10 19:07:10'
    )) / 60 AS minutes_diff;


/**
 * ======================================================================
 * SECTION 10 — CURRENT DATE AND TIME
 * ======================================================================
 *
 * SQL has built-in functions that return today's date and time.
 * You do not need to type the date yourself — the database fills it
 * in automatically at the moment the query runs.
 *
 * ┌────────────────────────┬─────────────────────────────────────────┐
 * │ Function               │ Returns                                 │
 * ├────────────────────────┼─────────────────────────────────────────┤
 * │ CURRENT_DATE           │ Today's date only (no time)             │
 * │                        │ Example: 2029-02-10                     │
 * │ CURRENT_TIMESTAMP      │ Today's date and current time           │
 * │                        │ Example: 2029-02-10 15:30:00            │
 * └────────────────────────┴─────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ See today's date and time                                       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       CURRENT_DATE      AS today,                               │
 * │       CURRENT_TIMESTAMP AS now;                                 │
 * │                                                                 │
 * │ Output (example — changes every day):                           │
 * │ +────────────+─────────────────────+                            │
 * │ | today      | now                 |                            │
 * │ +────────────+─────────────────────+                            │
 * │ | 2029-02-10 | 2029-02-10 15:30:00 |                            │
 * │ +────────────+─────────────────────+                            │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌────────────────────────────────────────────────────────────────────┐
 * │ Practical use — find all logins that happened today                │
 * │ (Assuming CURRENT_DATE = '2029-02-10' for this example)            │
 * ├────────────────────────────────────────────────────────────────────┤
 * │   SELECT login_id, username, login_time                            │
 * │   FROM logins                                                      │
 * │   WHERE login_time >= CURRENT_DATE::timestamp                      │
 * │     AND login_time <  (CURRENT_DATE + INTERVAL '1 day')::timestamp │
 * │   ORDER BY login_time;                                             │
 * │                                                                    │
 * │ Output:                                                            │
 * │ +──────────+──────────+─────────────────────+                      │
 * │ | login_id | username | login_time          |                      │
 * │ +──────────+──────────+─────────────────────+                      │
 * │ | 4        | Nikhil   | 2029-02-10 00:00:00 |                      │
 * │ | 5        | Nikhil   | 2029-02-10 00:00:00 |                      │
 * │ | 13       | Meera    | 2029-02-10 09:00:00 |                      │
 * │ | 2        | Ashwin   | 2029-02-10 09:00:00 |                      │
 * │ | 11       | Dev      | 2029-02-10 15:45:00 |                      │
 * │ | 7        | Priya    | 2029-02-10 23:59:59 |                      │
 * │ +──────────+──────────+─────────────────────+                      │
 * │                                                                    │
 * │ CURRENT_DATE::timestamp  → converts today's date to 00:00:00       │
 * │ INTERVAL '1 day'         → adds exactly one day to the date        │
 * └────────────────────────────────────────────────────────────────────┘
 */

-- See current date and time
SELECT
    CURRENT_DATE      AS today,
    CURRENT_TIMESTAMP AS now;

-- Find logins that happened today (dynamic — works any day)
SELECT login_id, username, login_time
FROM logins
WHERE login_time >= CURRENT_DATE::timestamp
  AND login_time <  (CURRENT_DATE + INTERVAL '1 day')::timestamp
ORDER BY login_time;


/**
 * ======================================================================
 * SECTION 11 — GROUP BY WITH DATES
 * ======================================================================
 *
 * You can group data by date parts to create reports like:
 *   → "How many orders per month?"
 *   → "How many employees joined per year?"
 *   → "What is the revenue per quarter?"
 *
 * The pattern is: use EXTRACT() in both SELECT and GROUP BY.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Count how many employees were hired per year and month          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       EXTRACT(YEAR  FROM joining_date) AS join_year,            │
 * │       EXTRACT(MONTH FROM joining_date) AS join_month,           │
 * │       COUNT(*) AS hires                                         │
 * │   FROM employees                                                │
 * │   GROUP BY                                                      │
 * │       EXTRACT(YEAR  FROM joining_date),                         │
 * │       EXTRACT(MONTH FROM joining_date)                          │
 * │   ORDER BY join_year NULLS LAST, join_month NULLS LAST;         │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +───────────+────────────+───────+                              │
 * │ | join_year | join_month | hires |                              │
 * │ +───────────+────────────+───────+                              │
 * │ | 2028      | 1          | 1     |                              │
 * │ | 2028      | 2          | 2     |                              │
 * │ | 2028      | 3          | 1     |                              │
 * │ | 2028      | 11         | 1     |                              │
 * │ | 2028      | 12         | 2     |                              │
 * │ | 2029      | 2          | 1     |                              │
 * │ | 2029      | 3          | 1     |                              │
 * │ | NULL      | NULL       | 1     | ← Arjun (no joining date)    │
 * │ +───────────+────────────+───────+                              │
 * │                                                                 │
 * │ Important: Arjun with NULL joining_date forms its own           │
 * │ NULL group — he is still counted, just in a separate row.       │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Count orders and total revenue per month                        │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT                                                        │
 * │       EXTRACT(YEAR  FROM order_datetime) AS order_year,         │
 * │       EXTRACT(MONTH FROM order_datetime) AS order_month,        │
 * │       COUNT(*)      AS total_orders,                            │
 * │       SUM(amount)   AS total_amount                             │
 * │   FROM orders                                                   │
 * │   GROUP BY                                                      │
 * │       EXTRACT(YEAR  FROM order_datetime),                       │
 * │       EXTRACT(MONTH FROM order_datetime)                        │
 * │   ORDER BY order_year, order_month;                             │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +────────────+─────────────+──────────────+──────────────+      │
 * │ | order_year | order_month | total_orders | total_amount |      │
 * │ +────────────+─────────────+──────────────+──────────────+      │
 * │ | 2028       | 2           | 1            | 999.00       |      │
 * │ | 2028       | 11          | 1            | 899.00       |      │
 * │ | 2028       | 12          | 1            | 499.00       |      │
 * │ | 2029       | 1           | 2            | 1549.00      |      │
 * │ | 2029       | 2           | 3            | 978.00       |      │
 * │ | 2029       | 3           | 2            | 498.00       |      │
 * │ | 2029       | 4           | 1            | 149.00       |      │
 * │ | 2029       | 5           | 1            | 399.00       |      │
 * │ +────────────+─────────────+──────────────+──────────────+      │
 * └─────────────────────────────────────────────────────────────────┘
 */

-- Hires per year and month
SELECT
    EXTRACT(YEAR  FROM joining_date) AS join_year,
    EXTRACT(MONTH FROM joining_date) AS join_month,
    COUNT(*) AS hires
FROM employees
GROUP BY
    EXTRACT(YEAR  FROM joining_date),
    EXTRACT(MONTH FROM joining_date)
ORDER BY join_year NULLS LAST, join_month NULLS LAST;

-- Orders and revenue per month
SELECT
    EXTRACT(YEAR  FROM order_datetime) AS order_year,
    EXTRACT(MONTH FROM order_datetime) AS order_month,
    COUNT(*)    AS total_orders,
    SUM(amount) AS total_amount
FROM orders
GROUP BY
    EXTRACT(YEAR  FROM order_datetime),
    EXTRACT(MONTH FROM order_datetime)
ORDER BY order_year, order_month;


/**
 * ======================================================================
 * SECTION 12 — REAL-WORLD SCENARIOS
 * ======================================================================
 *
 * Five complete real-world queries that combine everything learned above.
 */

-- ── SCENARIO 1: Delivery Performance Analysis ─────────────────────────
-- Goal: Find how many minutes each delivery took, and label it:
--       "On Time" (30 min or less), "Slow" (over 30 min),
--       "Pending" (not delivered yet), "Bad Data" (delivered before order)

SELECT
    delivery_id,
    customer,
    order_placed_at,
    delivered_at,
    CASE
        WHEN delivered_at IS NULL              THEN NULL
        ELSE EXTRACT(EPOCH FROM (delivered_at - order_placed_at)) / 60
    END AS delivery_minutes,
    CASE
        WHEN delivered_at IS NULL                                                     THEN 'Pending'
        WHEN delivered_at < order_placed_at                                           THEN 'Bad Data'
        WHEN EXTRACT(EPOCH FROM (delivered_at - order_placed_at)) <= 30 * 60          THEN 'On Time'
        ELSE 'Slow'
    END AS delivery_status
FROM deliveries
ORDER BY delivery_id;

/**
 * Output:
 * +─────────────+──────────+─────────────────────+─────────────────────+───────────────────+─────────────────+
 * | delivery_id | customer | order_placed_at     | delivered_at        | delivery_minutes  | delivery_status |
 * +─────────────+──────────+─────────────────────+─────────────────────+───────────────────+─────────────────+
 * | 1           | Ayaan    | 2029-02-10 12:00:00 | 2029-02-10 12:18:00 | 18                | On Time         |
 * | 2           | Sneha    | 2029-02-10 12:05:00 | 2029-02-10 12:42:00 | 37                | Slow            |
 * | 3           | Rohit    | 2029-02-10 12:10:00 | NULL                | NULL              | Pending         |
 * | 4           | Priya    | 2029-02-10 12:20:00 | 2029-02-10 12:10:00 | -10               | Bad Data        |
 * | 5           | Neha     | 2029-02-10 13:00:00 | 2029-02-10 13:31:00 | 31                | Slow            |
 * | 6           | Amit     | 2029-02-10 14:00:00 | 2029-02-10 14:30:00 | 30                | On Time         |
 * | 7           | Kavya    | 2029-02-09 23:55:00 | 2029-02-10 00:25:00 | 30                | On Time         |
 * | 8           | Raj      | 2029-02-10 23:59:00 | 2029-02-11 00:10:00 | 11                | On Time         |
 * | 9           | Ayaan    | 2029-02-11 12:00:00 | 2029-02-11 12:20:00 | 20                | On Time         |
 * | 10          | Sneha    | 2029-02-08 12:00:00 | 2029-02-08 12:05:00 | 5                 | On Time         |
 * +─────────────+──────────+─────────────────────+─────────────────────+───────────────────+─────────────────+
 */

-- ── SCENARIO 2: User Login Summary ────────────────────────────────────
-- Goal: For each user, find first login, last login, total count,
--       and how many days they have been active

SELECT
    username,
    MIN(login_time)   AS first_login,
    MAX(login_time)   AS latest_login,
    COUNT(*)          AS total_logins,
    EXTRACT(DAY FROM (MAX(login_time) - MIN(login_time))) AS days_active
FROM logins
GROUP BY username
ORDER BY total_logins DESC;

/**
 * Output:
 * +──────────+─────────────────────+─────────────────────+──────────────+─────────────+
 * | username | first_login         | latest_login        | total_logins | days_active |
 * +──────────+─────────────────────+─────────────────────+──────────────+─────────────+
 * | Nikhil   | 2029-02-10 00:00:00 | 2029-02-10 00:00:00 | 2            | 0           |
 * | Ashwin   | 2029-01-15 09:00:00 | 2029-02-10 09:00:00 | 2            | 26          |
 * | Isha     | 2029-01-31 10:30:00 | 2029-02-01 10:30:00 | 2            | 1           |
 * | Priya    | 2029-02-09 23:59:59 | 2029-02-10 23:59:59 | 2            | 1           |
 * | Asha     | 2029-02-11 00:00:00 | 2029-02-11 00:00:00 | 1            | 0           |
 * | Dev      | 2029-02-10 15:45:00 | 2029-02-10 15:45:00 | 1            | 0           |
 * | Kabir    | 2029-02-05 08:00:00 | 2029-02-05 08:00:00 | 1            | 0           |
 * | Meera    | 2029-02-10 09:00:00 | 2029-02-10 09:00:00 | 1            | 0           |
 * | Simran   | 2029-01-20 20:15:00 | 2029-01-20 20:15:00 | 1            | 0           |
 * +──────────+─────────────────────+─────────────────────+──────────────+─────────────+
 */

-- ── SCENARIO 3: Restaurant Performance ────────────────────────────────
-- Goal: Average delivery time by restaurant.
--       Exclude: NULL delivered_at (pending) and bad data (delivered < ordered)

SELECT
    restaurant,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(EXTRACT(EPOCH FROM (delivered_at - order_placed_at)) / 60), 1) AS avg_delivery_minutes,
    COUNT(CASE WHEN EXTRACT(EPOCH FROM (delivered_at - order_placed_at)) > 30 * 60 THEN 1 END) AS slow_deliveries
FROM deliveries
WHERE delivered_at IS NOT NULL
  AND delivered_at > order_placed_at
GROUP BY restaurant
ORDER BY avg_delivery_minutes;

/**
 * Output:
 * +─────────────+───────────────────+───────────────────────+──────────────────+
 * | restaurant  | total_deliveries  | avg_delivery_minutes  | slow_deliveries  |
 * +─────────────+───────────────────+───────────────────────+──────────────────+
 * | Dominoz     | 2                 | 7.5                   | 0                |
 * | Pizza Hut   | 2                 | 19.0                  | 0                |
 * | McDonalds   | 1                 | 30.0                  | 0                |
 * | KFC         | 1                 | 30.0                  | 0                |
 * | Burger King | 2                 | 34.0                  | 1                |
 * +─────────────+───────────────────+───────────────────────+──────────────────+
 */

-- ── SCENARIO 4: Monthly Revenue Report with Running Total ─────────────
-- Goal: Calculate monthly revenue for DELIVERED orders only,
--       and show a running total that accumulates month by month

SELECT
    EXTRACT(YEAR  FROM order_datetime)  AS year,
    EXTRACT(MONTH FROM order_datetime)  AS month,
    TO_CHAR(order_datetime, 'Month')    AS month_name,
    COUNT(*)                            AS order_count,
    SUM(amount)                         AS monthly_revenue,
    SUM(SUM(amount)) OVER (ORDER BY MIN(order_datetime)) AS running_total
FROM orders
WHERE status = 'DELIVERED'
GROUP BY
    EXTRACT(YEAR  FROM order_datetime),
    EXTRACT(MONTH FROM order_datetime),
    TO_CHAR(order_datetime, 'Month')
ORDER BY year, month;

/**
 * Output:
 * +──────+───────+────────────+─────────────+─────────────────+───────────────+
 * | year | month | month_name | order_count | monthly_revenue | running_total |
 * +──────+───────+────────────+─────────────+─────────────────+───────────────+
 * | 2028 | 2     | February   | 1           | 999.00          | 999.00        |
 * | 2028 | 11    | November   | 1           | 899.00          | 1898.00       |
 * | 2028 | 12    | December   | 1           | 499.00          | 2397.00       |
 * | 2029 | 1     | January    | 1           | 1200.00         | 3597.00       |
 * | 2029 | 2     | February   | 3           | 978.00          | 4575.00       |
 * | 2029 | 3     | March      | 1           | 299.00          | 4874.00       |
 * +──────+───────+────────────+─────────────+─────────────────+───────────────+
 */

-- ── SCENARIO 5: New Employee Onboarding Report ────────────────────────
-- Goal: Count new hires per department per month.
--       Exclude employees with NULL joining_date.

SELECT
    department,
    EXTRACT(YEAR  FROM joining_date) AS hire_year,
    EXTRACT(MONTH FROM joining_date) AS hire_month,
    COUNT(*) AS new_hires
FROM employees
WHERE joining_date IS NOT NULL
GROUP BY department, EXTRACT(YEAR FROM joining_date), EXTRACT(MONTH FROM joining_date)
ORDER BY hire_year, hire_month, department;

/**
 * Output:
 * +─────────────+───────────+────────────+──────────+
 * | department  | hire_year | hire_month | new_hires|
 * +─────────────+───────────+────────────+──────────+
 * | Product     | 2028      | 1          | 1        |
 * | HR          | 2028      | 2          | 1        |
 * | Engineering | 2028      | 2          | 1        |
 * | Engineering | 2028      | 3          | 1        |
 * | Support     | 2028      | 11         | 1        |
 * | Finance     | 2028      | 12         | 1        |
 * | Support     | 2028      | 12         | 1        |
 * | Support     | 2029      | 2          | 1        |
 * | Engineering | 2029      | 3          | 1        |
 * +─────────────+───────────+────────────+──────────+
 */


/**
 * ======================================================================
 * SECTION 13 — COMMON MISTAKES
 * ======================================================================
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 1 — BETWEEN with DATETIME (the classic trap)            │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ This is the most dangerous date mistake in SQL.                 │
 * │ BETWEEN with a DATE value converts it to midnight only.         │
 * │                                                                 │
 * │   ❌ WHERE login_time BETWEEN DATE '2029-02-10' ❌             │
 * │                           AND DATE '2029-02-10'                 │
 * │      → Only logins at exactly midnight are returned!            │
 * │                                                                 │
 * │   ✅ WHERE login_time >= '2029-02-10 00:00:00'  ✅             │
 * │        AND login_time <  '2029-02-11 00:00:00'                  │
 * │      → All logins on Feb 10 are returned correctly              │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 2 — Using 23:59:59 as the end of day                    │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Some databases support milliseconds. 23:59:59 misses them.      │
 * │                                                                 │
 * │   ❌ WHERE login_time <= '2029-02-10 23:59:59'  ❌             │
 * │      → Misses: 2029-02-10 23:59:59.500 (milliseconds)           │
 * │                                                                 │
 * │   ✅ WHERE login_time <  '2029-02-11 00:00:00'  ✅             │
 * │      → Safe for all timestamp precisions including ms           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 3 — Using EXTRACT in WHERE on an indexed column         │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ When you wrap a column inside a function like EXTRACT(), the    │
 * │ database cannot use any index on that column. It reads EVERY    │
 * │ row — which is slow on large tables.                            │
 * │                                                                 │
 * │   ❌ WHERE EXTRACT(YEAR FROM order_date) = 2029   ❌           │
 * │      → No index used → full table scan                          │
 * │                                                                 │
 * │   ✅ WHERE order_date >= '2029-01-01'             ✅           │
 * │        AND order_date <  '2030-01-01'                           │
 * │      → Index can be used → much faster                          │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 4 — Assuming EXTRACT(YEAR FROM NULL) returns 0          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Like all SQL functions, EXTRACT returns NULL when given NULL.   │
 * │ It does NOT return zero.                                        │
 * │                                                                 │
 * │   ❌ Assuming: EXTRACT(YEAR FROM NULL) → 0     ❌              │
 * │   ✅ Actual:   EXTRACT(YEAR FROM NULL) → NULL  ✅              │
 * │                                                                 │
 * │   If you need zero instead of NULL:                             │
 * │   COALESCE(EXTRACT(YEAR FROM joining_date), 0) AS join_year     │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * ======================================================================
 * SECTION 14 — PRACTICE EXERCISES
 * ======================================================================
 *
 * Try writing these queries yourself before reading the answers.
 *
 * Exercise 1:
 *   Extract year and month from joining_date for all employees.
 *
 *   Answer:
 *   SELECT name,
 *          EXTRACT(YEAR  FROM joining_date) AS year,
 *          EXTRACT(MONTH FROM joining_date) AS month
 *   FROM employees;
 *
 * ─────────────────────────────────────────────────────────────────────
 * Exercise 2:
 *   Find all orders placed in February 2029.
 *
 *   Answer:
 *   SELECT *
 *   FROM orders
 *   WHERE order_date >= '2029-02-01'
 *     AND order_date <  '2029-03-01';
 *
 * ─────────────────────────────────────────────────────────────────────
 * Exercise 3:
 *   Calculate how many days ago each employee joined.
 *
 *   Answer:
 *   SELECT name,
 *          (CURRENT_DATE - joining_date) AS days_since_joined
 *   FROM employees;
 *
 * ─────────────────────────────────────────────────────────────────────
 * Exercise 4:
 *   Count orders by month for the year 2029.
 *
 *   Answer:
 *   SELECT EXTRACT(MONTH FROM order_date) AS month,
 *          COUNT(*) AS order_count
 *   FROM orders
 *   WHERE EXTRACT(YEAR FROM order_date) = 2029
 *   GROUP BY EXTRACT(MONTH FROM order_date)
 *   ORDER BY month;
 *
 * ─────────────────────────────────────────────────────────────────────
 * Exercise 5:
 *   Find all users who logged in on February 10, 2029.
 *   (Use the correct half-open interval, NOT BETWEEN)
 *
 *   Answer:
 *   SELECT *
 *   FROM logins
 *   WHERE login_time >= '2029-02-10 00:00:00'
 *     AND login_time <  '2029-02-11 00:00:00';
 */


/**
 * ======================================================================
 * SECTION 15 — QUICK REFERENCE
 * ======================================================================
 *
 * DATA TYPES:
 * ─────────────────────────────────────────────────────────────────────
 * DATE           → YYYY-MM-DD                (no time)
 * TIMESTAMP      → YYYY-MM-DD HH:MM:SS       (date + time)
 *
 * EXTRACT — DATE PARTS:
 * ─────────────────────────────────────────────────────────────────────
 * EXTRACT(YEAR   FROM col)  → Year number    (2029)
 * EXTRACT(MONTH  FROM col)  → Month number   (1–12)
 * EXTRACT(DAY    FROM col)  → Day number     (1–31)
 *
 * EXTRACT — TIME PARTS (TIMESTAMP only):
 * ─────────────────────────────────────────────────────────────────────
 * EXTRACT(HOUR   FROM col)  → Hour           (0–23)
 * EXTRACT(MINUTE FROM col)  → Minute         (0–59)
 * EXTRACT(SECOND FROM col)  → Second         (0–59)
 *
 * CURRENT DATE AND TIME:
 * ─────────────────────────────────────────────────────────────────────
 * CURRENT_DATE       → Today's date
 * CURRENT_TIMESTAMP  → Current date and time
 *
 * CORRECT DATE RANGE PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * Single day:
 *   WHERE col >= '2029-02-10 00:00:00' AND col < '2029-02-11 00:00:00'
 *
 * Full month:
 *   WHERE col >= '2029-01-01 00:00:00' AND col < '2029-02-01 00:00:00'
 *
 * Full year:
 *   WHERE col >= '2029-01-01 00:00:00' AND col < '2030-01-01 00:00:00'
 *
 * Today (dynamic):
 *   WHERE col >= CURRENT_DATE::timestamp
 *     AND col < (CURRENT_DATE + INTERVAL '1 day')::timestamp
 *
 * DATE DIFFERENCES:
 * ─────────────────────────────────────────────────────────────────────
 * Days    → date1 - date2
 * Hours   → EXTRACT(EPOCH FROM (ts1 - ts2)) / 3600
 * Minutes → EXTRACT(EPOCH FROM (ts1 - ts2)) / 60
 *
 * FIRST AND LAST EVENTS:
 * ─────────────────────────────────────────────────────────────────────
 * MIN(date) → earliest date
 * MAX(date) → latest date
 */


/**
 * ======================================================================
 * SECTION 16 — GOLDEN RULES
 * ======================================================================
 *
 * 1. ✅ Use DATE when you only need the date (no time).
 *       Use TIMESTAMP when the exact moment matters.
 *
 * 2. ❌ NEVER use BETWEEN with a DATE value on a TIMESTAMP column.
 *       It converts the date to midnight 00:00:00 and misses all
 *       records after midnight. This is silent — no error is shown.
 *
 * 3. ✅ Always use the half-open interval pattern for date ranges:
 *       WHERE col >= start AND col < next_period_start
 *       This is safe for all timestamps including milliseconds.
 *
 * 4. ❌ Never use 23:59:59 as the end of a day.
 *       Use < next_day_00:00:00 instead. 23:59:59 breaks for
 *       timestamps that include milliseconds.
 *
 * 5. ✅ For best performance on large tables, use direct date range
 *       filters instead of wrapping the column in EXTRACT.
 *       → Fast:  WHERE order_date >= '2029-01-01' AND order_date < '2029-02-01'
 *       → Slow:  WHERE EXTRACT(MONTH FROM order_date) = 1
 *
 * 6. ✅ NULL dates return NULL in EXTRACT — not zero.
 *       Use COALESCE if you need a default value.
 *       COALESCE(EXTRACT(YEAR FROM joining_date), 0)
 *
 * 7. ✅ Use MIN(date) to find the first/earliest event.
 *       Use MAX(date) to find the latest/most recent event.
 *
 * 8. ✅ For time differences, always use EXTRACT(EPOCH FROM diff)
 *       and then divide: / 60 for minutes, / 3600 for hours.
 *
 * ======================================================================
 */


-- ── Cleanup ─────────────────────────────────────────────────────────
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS logins;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;