-- ============================================================================
-- PART 1: TABLE ALIASES (Short names for tables)
-- ============================================================================

/**
 * WHAT ARE TABLE ALIASES?
 * 
 * Table aliases are SHORT NAMES given to tables in a query.
 * They make your SQL code shorter, cleaner, and easier to read.
 * 
 * REAL LIFE EXAMPLE:
 * 
 * Instead of writing:
 *   "My Very Long Company Name With Many Words"
 * 
 * You write:
 *   "MVLCN"
 * 
 * Same meaning, but much shorter!
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                        TABLE ALIASES EXPLAINED                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   WHAT IS A TABLE ALIAS?                                                  │
 *   ┌─────────────────────────────────────────────────────────────────────┐ │
 *   │ A table alias is a temporary short name given to a table for the    │ │
 *   │ duration of a query. It makes queries more readable and is          │ │
 *   │ essential when joining multiple tables or using the same table      │ │
 *   │ multiple times (like in SELF JOIN).                                 │ │
 *   └─────────────────────────────────────────────────────────────────────┘ │
 *                                                                          │
 *   SYNTAX:                                                                │
 *   ┌─────────────────────────────────────────────────────────────────────┐ │
 *   │ FROM table_name AS alias_name                                       │ │
 *   │ -- OR (AS is optional)                                              │ │
 *   │ FROM table_name alias_name                                          │ │
 *   └─────────────────────────────────────────────────────────────────────┘ │
 *                                                                          │
 *   WITHOUT ALIAS (Hard to read):                                          │
 *   ┌─────────────────────────────────────────────────────────────────────┐ │
 *   │ SELECT customers.customer_id, customers.name, orders.order_id       │ │
 *   │ FROM customers                                                      │ │
 *   │ INNER JOIN orders ON customers.customer_id = orders.customer_id    │ │
 *   └─────────────────────────────────────────────────────────────────────┘ │
 *                                                                          │
 *   WITH ALIAS (Easy to read):                                             │
 *   ┌─────────────────────────────────────────────────────────────────────┐ │
 *   │ SELECT c.customer_id, c.name, o.order_id                           │ │
 *   │ FROM customers c                                                    │ │
 *   │ INNER JOIN orders o ON c.customer_id = o.customer_id               │ │
 *   └─────────────────────────────────────────────────────────────────────┘ │
 *                                                                          │
 *   WHY USE TABLE ALIASES?                                                 │
 *   ┌─────────────────────────────────────────────────────────────────────┐ │
 *   │ 1. Makes queries SHORTER and CLEANER                               │ │
 *   │ 2. Essential for SELF JOIN (same table used twice)                 │ │
 *   │ 3. Avoids ambiguity when columns have same name                    │ │
 *   │ 4. Improves readability in complex joins                           │ │
 *   │ 5. Common convention: Use first letter of table name as alias      │ │
 *   └─────────────────────────────────────────────────────────────────────┘ │
 *                                                                          │
 *   COMMON ALIAS CONVENTIONS:                                              │
 *   ┌─────────────────────────────────────────────────────────────────────┐ │
 *   │ customers  → c    (first letter)                                   │ │
 *   │ orders     → o    (first letter)                                   │ │
 *   │ products   → p    (first letter)                                   │ │
 *   │ employees  → e    (first letter)                                   │ │
 *   │ users      → u    (first letter)                                   │ │
 *   │ payments   → pay  (short form)                                     │ │
 *   │ order_items→ oi   (abbreviation)                                   │ │
 *   └─────────────────────────────────────────────────────────────────────┘ │
 *                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- EXAMPLE 1: Basic table alias (using AS keyword)
SELECT 
    c.customer_id,
    c.name,
    c.email,
    o.order_id,
    o.order_code
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id;

-- EXAMPLE 2: Table alias without AS keyword (shorter)
SELECT 
    c.customer_id,
    c.name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;

-- EXAMPLE 3: Column alias (different from table alias)
-- Table alias: 'c' for customers table
-- Column alias: 'customer_name' for c.name column
SELECT 
    c.customer_id,
    c.name AS customer_name,  -- This is COLUMN alias
    o.order_code
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

/**
 * IMPORTANT NOTE:
 * 
 * Table alias is temporary - only lasts for this query.
 * You CANNOT use table alias outside the query.
 * You MUST use alias once you define it.
 * 
 * ✅ CORRECT:
 *   SELECT c.customer_id FROM customers c
 * 
 * ❌ WRONG (using full name after alias):
 *   SELECT customers.customer_id FROM customers c
 * 
 * ❌ WRONG (alias not defined):
 *   SELECT c.customer_id FROM customers
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL JOIN EXAMPLES
-- ============================================================================

/**
 * CUSTOMERS TABLE - People who buy products
 */

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120),
    city VARCHAR(60),
    signup_at_utc TIMESTAMP
);

/**
 * ORDERS TABLE - Purchases made by customers
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_code VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    placed_at_utc TIMESTAMP NOT NULL
);

-- Create index for faster joins
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

/**
 * SAMPLE DATA - customers table
 * 
 * ┌─────────────┬──────────┬───────────────────┬────────────┬─────────────────────┐
 * │ customer_id │ name     │ email             │ city       │ signup_at_utc       │
 * ├─────────────┼──────────┼───────────────────┼────────────┼─────────────────────┤
 * │     101     │ Aisha    │ aisha@demo.com    │ Delhi      │ 2026-01-01 10:00:00 │
 * │     102     │ Rohan    │ rohan@demo.com    │ Mumbai     │ 2026-01-02 11:00:00 │
 * │     103     │ Meera    │ meera@demo.com    │ NULL       │ 2026-01-03 12:00:00 │
 * │     104     │ Arjun    │ arjun@demo.com    │ Delhi      │ 2026-01-04 13:00:00 │
 * │     106     │ Neha     │ neha@demo.com     │ Pune       │ 2026-01-05 09:30:00 │
 * │     107     │ Ishaan   │ ishaan@demo.com   │ Bengaluru  │ 2026-01-06 18:10:00 │
 * │     108     │ Riya     │ NULL              │ Delhi      │ 2026-01-07 07:45:00 │
 * │     109     │ Aisha    │ aisha2@demo.com   │ Jaipur     │ 2026-01-08 20:00:00 │
 * └─────────────┴──────────┴───────────────────┴────────────┴─────────────────────┘
 */

INSERT INTO customers (customer_id, name, email, city, signup_at_utc) VALUES
(101, 'Aisha',  'aisha@demo.com',  'Delhi',     '2026-01-01 10:00:00'),
(102, 'Rohan',  'rohan@demo.com',  'Mumbai',    '2026-01-02 11:00:00'),
(103, 'Meera',  'meera@demo.com',  NULL,        '2026-01-03 12:00:00'),
(104, 'Arjun',  'arjun@demo.com',  'Delhi',     '2026-01-04 13:00:00'),
(106, 'Neha',   'neha@demo.com',   'Pune',      '2026-01-05 09:30:00'),
(107, 'Ishaan', 'ishaan@demo.com', 'Bengaluru', '2026-01-06 18:10:00'),
(108, 'Riya',   NULL,              'Delhi',     '2026-01-07 07:45:00'),
(109, 'Aisha',  'aisha2@demo.com', 'Jaipur',    '2026-01-08 20:00:00');

/**
 * SAMPLE DATA - orders table
 * 
 * ┌──────────┬─────────────┬────────────┬────────────┬──────────────┬─────────────────────┐
 * │ order_id │ customer_id │ order_code │ status     │ total_amount │ placed_at_utc       │
 * ├──────────┼─────────────┼────────────┼────────────┼──────────────┼─────────────────────┤
 * │    1     │    101      │     A      │ PAID       │   499.00     │ 2026-01-10 10:00:00 │
 * │    2     │    102      │     B      │ PAID       │   299.00     │ 2026-01-10 11:00:00 │
 * │    3     │    105      │     C      │ PAID       │   199.00     │ 2026-01-10 12:00:00 │
 * │    4     │    101      │     D      │ CANCELLED  │   999.00     │ 2026-01-11 09:00:00 │
 * │    5     │    106      │     E      │ PAID       │   799.00     │ 2026-01-11 10:30:00 │
 * │    6     │    106      │     F      │ PENDING    │   149.00     │ 2026-01-12 08:20:00 │
 * │    7     │    NULL     │     G      │ PAID       │   249.00     │ 2026-01-12 09:10:00 │
 * │    8     │    999      │     H      │ PAID       │   129.00     │ 2026-01-12 15:40:00 │
 * └──────────┴─────────────┴────────────┴────────────┴──────────────┴─────────────────────┘
 * 
 * NOTE: 
 * - Customer 105 does NOT exist in customers table
 * - Customer 999 does NOT exist in customers table
 * - Order 7 has customer_id = NULL
 * - Customer 103, 104, 107, 108, 109 have NO orders
 */

INSERT INTO orders (order_id, customer_id, order_code, status, total_amount, placed_at_utc) VALUES
(1, 101, 'A', 'PAID',      499.00, '2026-01-10 10:00:00'),
(2, 102, 'B', 'PAID',      299.00, '2026-01-10 11:00:00'),
(3, 105, 'C', 'PAID',      199.00, '2026-01-10 12:00:00'),
(4, 101, 'D', 'CANCELLED', 999.00, '2026-01-11 09:00:00'),
(5, 106, 'E', 'PAID',      799.00, '2026-01-11 10:30:00'),
(6, 106, 'F', 'PENDING',   149.00, '2026-01-12 08:20:00'),
(7, NULL,'G', 'PAID',      249.00, '2026-01-12 09:10:00'),
(8, 999, 'H', 'PAID',      129.00, '2026-01-12 15:40:00');
