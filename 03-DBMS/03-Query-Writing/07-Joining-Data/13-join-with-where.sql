/**
 * ============================================================================
 * JOIN WITH WHERE - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. TABLE ALIASES ------------------------- (Short names for tables)
 * 2. WHAT IS A JOIN? ----------------------- (Quick review)
 * 3. WHAT IS WHERE? ------------------------ (Filtering explained)
 * 4. JOIN WITH WHERE - BASIC --------------- (Filter after join)
 * 5. WHERE vs ON - IMPORTANT DIFFERENCE ---- (Where to put conditions)
 * 6. MULTIPLE CONDITIONS ------------------- (AND, OR, IN, BETWEEN)
 * 7. JOIN WITH WHERE ON MULTIPLE TABLES ---- (Complex filters)
 * 8. PRACTICAL BUSINESS SCENARIOS ---------- (Real world examples)
 * 9. COMMON MISTAKES ----------------------- (What to avoid)
 * 10. GOLDEN RULES ------------------------- (Important points)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: CUSTOMERS - People who buy products
 */

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(120),
    country VARCHAR(50),
    city VARCHAR(60),
    signup_date DATE
);

/**
 * TABLE 2: ORDERS - Purchases made by customers
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_code VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    order_date DATE,
    total_amount DECIMAL(10,2) NOT NULL
);

/**
 * TABLE 3: PRODUCTS - Items available for sale
 */

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price DECIMAL(10,2) NOT NULL
);

/**
 * TABLE 4: ORDER_ITEMS - Products inside each order
 */

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- Create indexes for faster joins
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * CUSTOMERS TABLE
 * ┌─────────────┬──────────┬───────────────────┬─────────────┬────────────┬─────────────┐
 * │ customer_id │ name     │ email             │ country     │ city       │ signup_date │
 * ├─────────────┼──────────┼───────────────────┼─────────────┼────────────┼─────────────┤
 * │     101     │ Aisha    │ aisha@demo.com    │ India       │ Delhi      │ 2024-01-01  │
 * │     102     │ Rohan    │ rohan@demo.com    │ India       │ Mumbai     │ 2024-01-02  │
 * │     103     │ Meera    │ meera@demo.com    │ India       │ Pune       │ 2024-01-03  │
 * │     104     │ John     │ john@demo.com     │ USA         │ New York   │ 2024-01-04  │
 * │     105     │ Sarah    │ sarah@demo.com    │ USA         │ Los Angeles│ 2024-01-05  │
 * │     106     │ David    │ david@demo.com    │ UK          │ London     │ 2024-01-06  │
 * │     107     │ Priya    │ priya@demo.com    │ India       │ Bengaluru  │ 2024-01-07  │
 * └─────────────┴──────────┴───────────────────┴─────────────┴────────────┴─────────────┘
 */

INSERT INTO customers (customer_id, name, email, country, city, signup_date) VALUES
(101, 'Aisha', 'aisha@demo.com', 'India', 'Delhi', '2024-01-01'),
(102, 'Rohan', 'rohan@demo.com', 'India', 'Mumbai', '2024-01-02'),
(103, 'Meera', 'meera@demo.com', 'India', 'Pune', '2024-01-03'),
(104, 'John', 'john@demo.com', 'USA', 'New York', '2024-01-04'),
(105, 'Sarah', 'sarah@demo.com', 'USA', 'Los Angeles', '2024-01-05'),
(106, 'David', 'david@demo.com', 'UK', 'London', '2024-01-06'),
(107, 'Priya', 'priya@demo.com', 'India', 'Bengaluru', '2024-01-07');

/**
 * PRODUCTS TABLE
 * ┌────────────┬──────────────────┬──────────────┬────────────┐
 * │ product_id │ product_name     │ category     │ unit_price │
 * ├────────────┼──────────────────┼──────────────┼────────────┤
 * │     1      │ Laptop           │ Electronics  │ 50000.00   │
 * │     2      │ Mouse            │ Electronics  │ 500.00     │
 * │     3      │ Keyboard         │ Electronics  │ 1500.00    │
 * │     4      │ Monitor          │ Electronics  │ 10000.00   │
 * │     5      │ Headphones       │ Accessories  │ 2000.00    │
 * │     6      │ USB Cable        │ Accessories  │ 300.00     │
 * │     7      │ Mouse Pad        │ Accessories  │ 400.00     │
 * └────────────┴──────────────────┴──────────────┴────────────┘
 */

INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(1, 'Laptop', 'Electronics', 50000.00),
(2, 'Mouse', 'Electronics', 500.00),
(3, 'Keyboard', 'Electronics', 1500.00),
(4, 'Monitor', 'Electronics', 10000.00),
(5, 'Headphones', 'Accessories', 2000.00),
(6, 'USB Cable', 'Accessories', 300.00),
(7, 'Mouse Pad', 'Accessories', 400.00);

/**
 * ORDERS TABLE
 * ┌──────────┬─────────────┬────────────┬────────────┬─────────────┬──────────────┐
 * │ order_id │ customer_id │ order_code │ status     │ order_date  │ total_amount │
 * ├──────────┼─────────────┼────────────┼────────────┼─────────────┼──────────────┤
 * │    1     │    101      │    ORD1    │ DELIVERED  │ 2024-01-10  │   51500.00   │
 * │    2     │    102      │    ORD2    │ DELIVERED  │ 2024-01-11  │    500.00    │
 * │    3     │    101      │    ORD3    │ DELIVERED  │ 2024-01-12  │   11500.00   │
 * │    4     │    104      │    ORD4    │ DELIVERED  │ 2024-01-13  │   10000.00   │
 * │    5     │    105      │    ORD5    │ DELIVERED  │ 2024-01-14  │   2000.00    │
 * │    6     │    106      │    ORD6    │ DELIVERED  │ 2024-01-15  │   1500.00    │
 * │    7     │    107      │    ORD7    │ PENDING    │ 2024-01-16  │   2000.00    │
 * │    8     │    101      │    ORD8    │ DELIVERED  │ 2024-01-17  │    300.00    │
 * │    9     │    104      │    ORD9    │ CANCELLED  │ 2024-01-18  │   4000.00    │
 * │   10     │    105      │    ORD10   │ DELIVERED  │ 2024-01-19  │   400.00     │
 * └──────────┴─────────────┴────────────┴────────────┴─────────────┴──────────────┘
 */

INSERT INTO orders (order_id, customer_id, order_code, status, order_date, total_amount) VALUES
(1, 101, 'ORD1', 'DELIVERED', '2024-01-10', 51500.00),
(2, 102, 'ORD2', 'DELIVERED', '2024-01-11', 500.00),
(3, 101, 'ORD3', 'DELIVERED', '2024-01-12', 11500.00),
(4, 104, 'ORD4', 'DELIVERED', '2024-01-13', 10000.00),
(5, 105, 'ORD5', 'DELIVERED', '2024-01-14', 2000.00),
(6, 106, 'ORD6', 'DELIVERED', '2024-01-15', 1500.00),
(7, 107, 'ORD7', 'PENDING', '2024-01-16', 2000.00),
(8, 101, 'ORD8', 'DELIVERED', '2024-01-17', 300.00),
(9, 104, 'ORD9', 'CANCELLED', '2024-01-18', 4000.00),
(10, 105, 'ORD10', 'DELIVERED', '2024-01-19', 400.00);

/**
 * ORDER_ITEMS TABLE
 * ┌───────────────┬──────────┬────────────┬──────────┬─────────┐
 * │ order_item_id │ order_id │ product_id │ quantity │ price   │
 * ├───────────────┼──────────┼────────────┼──────────┼─────────┤
 * │      1        │    1     │     1      │    1     │ 50000   │
 * │      2        │    1     │     2      │    3     │ 1500    │
 * │      3        │    2     │     2      │    1     │ 500     │
 * │      4        │    3     │     4      │    1     │ 10000   │
 * │      5        │    3     │     3      │    1     │ 1500    │
 * │      6        │    4     │     4      │    1     │ 10000   │
 * │      7        │    5     │     5      │    1     │ 2000    │
 * │      8        │    6     │     3      │    1     │ 1500    │
 * │      9        │    7     │     5      │    1     │ 2000    │
 * │     10        │    8     │     6      │    1     │ 300     │
 * │     11        │    9     │     4      │    1     │ 10000   │
 * │     12        │   10     │     7      │    1     │ 400     │
 * └───────────────┴──────────┴────────────┴──────────┴─────────┘
 */

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1, 50000),
(2, 1, 2, 3, 1500),
(3, 2, 2, 1, 500),
(4, 3, 4, 1, 10000),
(5, 3, 3, 1, 1500),
(6, 4, 4, 1, 10000),
(7, 5, 5, 1, 2000),
(8, 6, 3, 1, 1500),
(9, 7, 5, 1, 2000),
(10, 8, 6, 1, 300),
(11, 9, 4, 1, 10000),
(12, 10, 7, 1, 400);

-- ============================================================================
-- PART 1: TABLE ALIASES (Quick Review)
-- ============================================================================

/**
 * TABLE ALIASES = Short names for tables
 * 
 * WITHOUT ALIAS (Hard to read):
 *   SELECT customers.name, orders.order_code 
 *   FROM customers 
 *   JOIN orders ON customers.customer_id = orders.customer_id
 * 
 * WITH ALIAS (Easy to read):
 *   SELECT c.name, o.order_code 
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 * 
 * COMMON ALIASES:
 *   customers   → c
 *   orders      → o
 *   products    → p
 *   order_items → oi
 */

-- ============================================================================
-- PART 2: WHAT IS A JOIN? (Quick Review)
-- ============================================================================

/**
 * A JOIN combines rows from two or more tables based on a related column.
 * 
 * VISUAL REPRESENTATION:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                        VISUAL JOIN REFERENCE                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INNER JOIN                      LEFT JOIN                            │
 * │   ┌─────────────┐                 ┌─────────────┐                      │
 * │   │   ╔═════╗   │                 │   ╔═════════╗│                      │
 * │   │   ║ A∩B ║   │                 │   ║ A       ║│                      │
 * │   │   ╚═════╝   │                 │   ╚═════════╝│                      │
 * │   └─────────────┘                 └─────────────┘                      │
 * │   Only matching rows               All left + matching right           │
 * │                                                                          │
 * │   RIGHT JOIN                      FULL OUTER JOIN                      │
 * │   ┌─────────────┐                 ┌─────────────┐                      │
 * │   │┌═════════╗  │                 │┌═══════════┐│                      │
 * │   ││       B ║  │                 ││ A ∪ B     ││                      │
 * │   │└═════════╝  │                 │└═══════════┘│                      │
 * │   └─────────────┘                 └─────────────┘                      │
 * │   All right + matching left       All rows from both tables            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 3: WHAT IS WHERE? (Filtering Explained)
-- ============================================================================

/**
 * WHERE clause filters rows based on conditions.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          WHAT IS WHERE?                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SIMPLE WHERE EXAMPLE:                                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT * FROM customers WHERE country = 'India';               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INPUT (All customers):           OUTPUT (Only India customers):      │
 * │   ┌─────────────┬──────────┬──────┐ ┌─────────────┬──────────┬──────┐  │
 * │   │ customer_id │ name     │country│ │ customer_id │ name     │country│  │
 * │   ├─────────────┼──────────┼──────┤ ├─────────────┼──────────┼──────┤  │
 * │   │    101      │ Aisha    │ India │ │    101      │ Aisha    │ India │  │
 * │   │    102      │ Rohan    │ India │ │    102      │ Rohan    │ India │  │
 * │   │    103      │ Meera    │ India │ │    103      │ Meera    │ India │  │
 * │   │    104      │ John     │ USA   │ │    107      │ Priya    │ India │  │
 * │   │    105      │ Sarah    │ USA   │ └─────────────┴──────────┴──────┘  │
 * │   │    106      │ David    │ UK    │                                    │
 * │   │    107      │ Priya    │ India │                                    │
 * │   └─────────────┴──────────┴──────┘                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Simple WHERE example
SELECT * FROM customers WHERE country = 'India';

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬───────────────────┬─────────────┬────────────┬─────────────┐
 * │ customer_id │ name     │ email             │ country     │ city       │ signup_date │
 * ├─────────────┼──────────┼───────────────────┼─────────────┼────────────┼─────────────┤
 * │    101      │ Aisha    │ aisha@demo.com    │ India       │ Delhi      │ 2024-01-01  │
 * │    102      │ Rohan    │ rohan@demo.com    │ India       │ Mumbai     │ 2024-01-02  │
 * │    103      │ Meera    │ meera@demo.com    │ India       │ Pune       │ 2024-01-03  │
 * │    107      │ Priya    │ priya@demo.com    │ India       │ Bengaluru  │ 2024-01-07  │
 * └─────────────┴──────────┴───────────────────┴─────────────┴────────────┴─────────────┘
 */

-- ============================================================================
-- PART 4: JOIN WITH WHERE - BASIC (Filter after join)
-- ============================================================================

/**
 * JOIN WITH WHERE - The most common pattern:
 * 1. First, JOIN tables to combine data
 * 2. Then, use WHERE to filter the combined results
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    JOIN WITH WHERE - BASIC                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   STEP 1: JOIN customers and orders                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.name, o.order_code, o.total_amount                    │   │
 * │   │ FROM customers c                                                │   │
 * │   │ JOIN orders o ON c.customer_id = o.customer_id                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Add WHERE to filter (only USA customers)                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.name, o.order_code, o.total_amount                    │   │
 * │   │ FROM customers c                                                │   │
 *   │   │ JOIN orders o ON c.customer_id = o.customer_id                 │   │
 * │   │ WHERE c.country = 'USA'                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   RESULT: Only orders from USA customers                               │
 * │   ┌──────────┬────────────┬──────────────┐                           │
 * │   │ name     │ order_code │ total_amount │                           │
 * │   ├──────────┼────────────┼──────────────┤                           │
 * │   │ John     │ ORD4       │ 10000.00     │                           │
 * │   │ Sarah    │ ORD5       │ 2000.00      │                           │
 * │   │ John     │ ORD9       │ 4000.00      │                           │
 * │   │ Sarah    │ ORD10      │ 400.00       │                           │
 * │   └──────────┴────────────┴──────────────┘                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Basic JOIN with WHERE - Find orders from USA customers only
SELECT 
    c.name,
    c.country,
    o.order_code,
    o.total_amount,
    o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┬──────────────┬────────────┐
 * │ name     │ country     │ order_code │ total_amount │ status     │
 * ├──────────┼─────────────┼────────────┼──────────────┼────────────┤
 * │ John     │ USA         │ ORD4       │ 10000.00     │ DELIVERED  │
 * │ Sarah    │ USA         │ ORD5       │ 2000.00      │ DELIVERED  │
 * │ John     │ USA         │ ORD9       │ 4000.00      │ CANCELLED  │
 * │ Sarah    │ USA         │ ORD10      │ 400.00       │ DELIVERED  │
 * └──────────┴─────────────┴────────────┴──────────────┴────────────┘
 * 
 * EXPLANATION:
 * - JOIN first combines customers with their orders
 * - WHERE then filters to only customers from USA
 * - John has 2 orders (ORD4 and ORD9)
 * - Sarah has 2 orders (ORD5 and ORD10)
 */

-- Example 2: Find orders from India customers only
SELECT 
    c.name,
    c.country,
    c.city,
    o.order_code,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.country = 'India'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┬────────────┬──────────────┐
 * │ name     │ country     │ city       │ order_code │ total_amount │
 * ├──────────┼─────────────┼────────────┼────────────┼──────────────┤
 * │ Aisha    │ India       │ Delhi      │ ORD1       │ 51500.00     │
 * │ Rohan    │ India       │ Mumbai     │ ORD2       │ 500.00       │
 * │ Aisha    │ India       │ Delhi      │ ORD3       │ 11500.00     │
 * │ Priya    │ India       │ Bengaluru  │ ORD7       │ 2000.00      │
 * │ Aisha    │ India       │ Delhi      │ ORD8       │ 300.00       │
 * └──────────┴─────────────┴────────────┴────────────┴──────────────┘
 */

-- Example 3: Find DELIVERED orders only
SELECT 
    c.name,
    c.country,
    o.order_code,
    o.status,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'DELIVERED'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┬────────────┬──────────────┐
 * │ name     │ country     │ order_code │ status     │ total_amount │
 * ├──────────┼─────────────┼────────────┼────────────┼──────────────┤
 * │ Aisha    │ India       │ ORD1       │ DELIVERED  │ 51500.00     │
 * │ Rohan    │ India       │ ORD2       │ DELIVERED  │ 500.00       │
 * │ Aisha    │ India       │ ORD3       │ DELIVERED  │ 11500.00     │
 * │ John     │ USA         │ ORD4       │ DELIVERED  │ 10000.00     │
 * │ Sarah    │ USA         │ ORD5       │ DELIVERED  │ 2000.00      │
 * │ David    │ UK          │ ORD6       │ DELIVERED  │ 1500.00      │
 * │ Aisha    │ India       │ ORD8       │ DELIVERED  │ 300.00       │
 * │ Sarah    │ USA         │ ORD10      │ DELIVERED  │ 400.00       │
 * └──────────┴─────────────┴────────────┴────────────┴──────────────┘
 * 
 * NOTE: ORD7 (PENDING) and ORD9 (CANCELLED) are excluded
 */

-- ============================================================================
-- PART 5: WHERE vs ON - IMPORTANT DIFFERENCE
-- ============================================================================

/**
 * WHERE vs ON - INPUT/OUTPUT COMPARISON:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                      WHERE vs ON - KEY DIFFERENCES                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    ON (Join Condition)                          │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied DURING the join (while matching rows)            │   │
 * │   │ PURPOSE: Defines HOW tables should match                        │   │
 * │   │ EFFECT: Affects WHICH rows are considered for joining           │   │
 * │   │ BEST FOR: Controlling what matches from right table             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                   WHERE (Filter Condition)                      │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied AFTER the join (after result is produced)        │   │
 * │   │ PURPOSE: Filters the final result                               │   │
 *   │   │ EFFECT: Removes rows from the final output                      │   │
 * │   │ BEST FOR: Filtering final results based on any column           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * DEMONSTRATION: Condition in ON vs WHERE with LEFT JOIN
 * 
 * Goal: Show all customers with their orders, but only show order if it's DELIVERED
 */

-- OPTION 1: Condition in WHERE (after join)
-- This filters the FINAL result - removes customers without DELIVERED orders
SELECT 
    c.name,
    c.country,
    o.order_code,
    o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'DELIVERED' OR o.status IS NULL;  -- Need to keep customers without orders

-- OPTION 2: Condition in ON (during join)
-- This filters DURING join - keeps all customers, only matches DELIVERED orders
SELECT 
    c.name,
    c.country,
    o.order_code,
    o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'DELIVERED';

/**
 * OUTPUT of OPTION 2 (Condition in ON):
 * ┌──────────┬─────────────┬────────────┬────────────┐
 * │ name     │ country     │ order_code │ status     │
 * ├──────────┼─────────────┼────────────┼────────────┤
 * │ Aisha    │ India       │ ORD1       │ DELIVERED  │
 * │ Aisha    │ India       │ ORD3       │ DELIVERED  │
 * │ Aisha    │ India       │ ORD8       │ DELIVERED  │
 * │ Rohan    │ India       │ ORD2       │ DELIVERED  │
 * │ Meera    │ India       │ NULL       │ NULL       │
 * │ John     │ USA         │ ORD4       │ DELIVERED  │
 * │ John     │ USA         │ NULL       │ NULL       │  ← ORD9 was CANCELLED
 * │ Sarah    │ USA         │ ORD5       │ DELIVERED  │
 * │ Sarah    │ USA         │ ORD10      │ DELIVERED  │
 * │ David    │ UK          │ ORD6       │ DELIVERED  │
 * │ Priya    │ India       │ NULL       │ NULL       │  ← ORD7 was PENDING
 * └──────────┴─────────────┴────────────┴────────────┘
 * 
 * EXPLANATION:
 * - All customers appear (because LEFT JOIN)
 * - Only DELIVERED orders are matched
 * - CANCELLED (ORD9) and PENDING (ORD7) orders show NULL
 * - Customers without any DELIVERED orders show NULL for order columns
 */

-- ============================================================================
-- PART 6: MULTIPLE CONDITIONS (AND, OR, IN, BETWEEN)
-- ============================================================================

/**
 * EXAMPLE 1: Multiple conditions with AND
 * Find orders from USA customers that are DELIVERED
 */

SELECT 
    c.name,
    c.country,
    o.order_code,
    o.status,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA' 
  AND o.status = 'DELIVERED'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┬────────────┬──────────────┐
 * │ name     │ country     │ order_code │ status     │ total_amount │
 * ├──────────┼─────────────┼────────────┼────────────┼──────────────┤
 * │ John     │ USA         │ ORD4       │ DELIVERED  │ 10000.00     │
 * │ Sarah    │ USA         │ ORD5       │ DELIVERED  │ 2000.00      │
 * │ Sarah    │ USA         │ ORD10      │ DELIVERED  │ 400.00       │
 * └──────────┴─────────────┴────────────┴────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - John's ORD9 is CANCELLED → excluded
 * - Only DELIVERED orders from USA customers appear
 */

/**
 * EXAMPLE 2: Multiple conditions with OR
 * Find orders from USA OR UK customers
 */

SELECT 
    c.name,
    c.country,
    o.order_code,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.country = 'USA' OR c.country = 'UK'
ORDER BY c.country, o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┬──────────────┐
 * │ name     │ country     │ order_code │ total_amount │
 * ├──────────┼─────────────┼────────────┼──────────────┤
 * │ David    │ UK          │ ORD6       │ 1500.00      │
 * │ John     │ USA         │ ORD4       │ 10000.00     │
 * │ John     │ USA         │ ORD9       │ 4000.00      │
 * │ Sarah    │ USA         │ ORD5       │ 2000.00      │
 * │ Sarah    │ USA         │ ORD10      │ 400.00       │
 * └──────────┴─────────────┴────────────┴──────────────┘
 */

/**
 * EXAMPLE 3: Using IN operator (easier than multiple OR)
 * Same as above but cleaner
 */

SELECT 
    c.name,
    c.country,
    o.order_code,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.country IN ('USA', 'UK')
ORDER BY c.country, o.order_id;

/**
 * OUTPUT (same as above):
 * ┌──────────┬─────────────┬────────────┬──────────────┐
 * │ name     │ country     │ order_code │ total_amount │
 * ├──────────┼─────────────┼────────────┼──────────────┤
 * │ David    │ UK          │ ORD6       │ 1500.00      │
 * │ John     │ USA         │ ORD4       │ 10000.00     │
 * │ John     │ USA         │ ORD9       │ 4000.00      │
 * │ Sarah    │ USA         │ ORD5       │ 2000.00      │
 * │ Sarah    │ USA         │ ORD10      │ 400.00       │
 * └──────────┴─────────────┴────────────┴──────────────┘
 */

/**
 * EXAMPLE 4: Using BETWEEN for date ranges
 * Find orders placed in first half of January 2024
 */

SELECT 
    c.name,
    o.order_code,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-01-15'
ORDER BY o.order_date;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬─────────────┬──────────────┐
 * │ name     │ order_code │ order_date  │ total_amount │
 * ├──────────┼────────────┼─────────────┼──────────────┤
 * │ Aisha    │ ORD1       │ 2024-01-10  │ 51500.00     │
 * │ Rohan    │ ORD2       │ 2024-01-11  │ 500.00       │
 * │ Aisha    │ ORD3       │ 2024-01-12  │ 11500.00     │
 * │ John     │ ORD4       │ 2024-01-13  │ 10000.00     │
 * │ Sarah    │ ORD5       │ 2024-01-14  │ 2000.00      │
 * │ David    │ ORD6       │ 2024-01-15  │ 1500.00      │
 * └──────────┴────────────┴─────────────┴──────────────┘
 */

/**
 * EXAMPLE 5: Using NOT operator
 * Find orders that are NOT DELIVERED
 */

SELECT 
    c.name,
    o.order_code,
    o.status,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status != 'DELIVERED'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬────────────┬──────────────┐
 * │ name     │ order_code │ status     │ total_amount │
 * ├──────────┼────────────┼────────────┼──────────────┤
 * │ Priya    │ ORD7       │ PENDING    │ 2000.00      │
 * │ John     │ ORD9       │ CANCELLED  │ 4000.00      │
 * └──────────┴────────────┴────────────┴──────────────┘
 */

-- ============================================================================
-- PART 7: JOIN WITH WHERE ON MULTIPLE TABLES
-- ============================================================================

/**
 * EXAMPLE 1: Filtering on three tables
 * Show delivered orders from USA customers that include Electronics products
 */

SELECT 
    c.name AS customer_name,
    c.country,
    o.order_code,
    o.status,
    p.product_name,
    p.category
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE c.country = 'USA' 
  AND o.status = 'DELIVERED'
  AND p.category = 'Electronics'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────┬────────────┬────────────┬──────────────┬──────────────┐
 * │ customer_name │ country     │ order_code │ status     │ product_name │ category     │
 * ├───────────────┼─────────────┼────────────┼────────────┼──────────────┼──────────────┤
 * │ John          │ USA         │ ORD4       │ DELIVERED  │ Monitor      │ Electronics  │
 * └───────────────┴─────────────┴────────────┴────────────┴──────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - John (USA) ordered Monitor (Electronics) in order ORD4
 * - Sarah's orders (ORD5 and ORD10) are Accessories, not Electronics
 * - So only 1 row appears
 */

/**
 * EXAMPLE 2: Filter with date and status
 * Show orders placed after Jan 15, 2024 that are DELIVERED
 */

SELECT 
    c.name,
    o.order_code,
    o.order_date,
    o.status,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date > '2024-01-15'
  AND o.status = 'DELIVERED'
ORDER BY o.order_date;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬─────────────┬────────────┬──────────────┐
 * │ name     │ order_code │ order_date  │ status     │ total_amount │
 * ├──────────┼────────────┼─────────────┼────────────┼──────────────┤
 * │ Priya    │ ORD7       │ 2024-01-16  │ PENDING    │ 2000.00      │
 * │ Aisha    │ ORD8       │ 2024-01-17  │ DELIVERED  │ 300.00       │
 * │ John     │ ORD9       │ 2024-01-18  │ CANCELLED  │ 4000.00      │
 * │ Sarah    │ ORD10      │ 2024-01-19  │ DELIVERED  │ 400.00       │
 * └──────────┴────────────┴─────────────┴────────────┴──────────────┘
 * 
 * NOTE: Only ORD8 and ORD10 are DELIVERED after Jan 15
 */

/**
 * EXAMPLE 3: Filter with amount threshold
 * Find orders over ₹5000 from India customers
 */

SELECT 
    c.name,
    c.city,
    o.order_code,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.country = 'India' 
  AND o.total_amount > 5000
ORDER BY o.total_amount DESC;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬────────────┬──────────────┐
 * │ name     │ city       │ order_code │ total_amount │
 * ├──────────┼────────────┼────────────┼──────────────┤
 * │ Aisha    │ Delhi      │ ORD1       │ 51500.00     │
 * │ Aisha    │ Delhi      │ ORD3       │ 11500.00     │
 * └──────────┴────────────┴────────────┴──────────────┘
 */

-- ============================================================================
-- PART 8: PRACTICAL BUSINESS SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: High Value Customer Report
 * Find customers who have spent more than ₹10000 total
 */

SELECT 
    c.customer_id,
    c.name,
    c.country,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.country
HAVING SUM(o.total_amount) > 10000
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬─────────────┬─────────────┬─────────────┐
 * │ customer_id │ name     │ country     │ order_count │ total_spent │
 * ├─────────────┼──────────┼─────────────┼─────────────┼─────────────┤
 * │    101      │ Aisha    │ India       │      3      │ 63300.00    │
 * │    104      │ John     │ USA         │      2      │ 14000.00    │
 * └─────────────┴──────────┴─────────────┴─────────────┴─────────────┘
 */

/**
 * SCENARIO 2: Recent Orders Report
 * Find orders placed in the last 7 days from current date
 */

-- Assuming today is 2024-01-20 for this example
SELECT 
    c.name,
    c.country,
    o.order_code,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-13'  -- Last 7 days from 2024-01-20
ORDER BY o.order_date DESC;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┬─────────────┬──────────────┐
 * │ name     │ country     │ order_code │ order_date  │ total_amount │
 * ├──────────┼─────────────┼────────────┼─────────────┼──────────────┤
 * │ Sarah    │ USA         │ ORD10      │ 2024-01-19  │ 400.00       │
 * │ John     │ USA         │ ORD9       │ 2024-01-18  │ 4000.00      │
 * │ Aisha    │ India       │ ORD8       │ 2024-01-17  │ 300.00       │
 * │ Priya    │ India       │ ORD7       │ 2024-01-16  │ 2000.00      │
 * │ David    │ UK          │ ORD6       │ 2024-01-15  │ 1500.00      │
 * │ Sarah    │ USA         │ ORD5       │ 2024-01-14  │ 2000.00      │
 * │ John     │ USA         │ ORD4       │ 2024-01-13  │ 10000.00     │
 * └──────────┴─────────────┴────────────┴─────────────┴──────────────┘
 */

/**
 * SCENARIO 3: Product Category Performance by Country
 * Show total sales by product category for each country
 */

SELECT 
    c.country,
    p.category,
    COUNT(oi.order_item_id) AS items_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'DELIVERED'
GROUP BY c.country, p.category
ORDER BY c.country, total_revenue DESC;

/**
 * OUTPUT:
 * ┌─────────────┬──────────────┬─────────────┬───────────────┐
 * │ country     │ category     │ items_sold  │ total_revenue │
 * ├─────────────┼──────────────┼─────────────┼───────────────┤
 * │ India       │ Electronics  │      6      │ 63500.00      │
 * │ India       │ Accessories  │      1      │ 300.00        │
 * │ UK          │ Electronics  │      1      │ 1500.00       │
 * │ USA         │ Electronics  │      1      │ 10000.00      │
 * │ USA         │ Accessories  │      2      │ 2400.00       │
 * └─────────────┴──────────────┴─────────────┴───────────────┘
 */

/**
 * SCENARIO 4: Customer Acquisition by Month
 * Show how many customers signed up each month
 */

SELECT 
    DATE_TRUNC('month', signup_date) AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY DATE_TRUNC('month', signup_date)
ORDER BY signup_month;

/**
 * OUTPUT:
 * ┌─────────────┬────────────────┐
 * │ signup_month│ new_customers  │
 * ├─────────────┼────────────────┤
 * │ 2024-01-01  │       7        │
 * └─────────────┴────────────────┘
 */

/**
 * SCENARIO 5: Orders that need attention
 * Find PENDING or CANCELLED orders with customer details
 */

SELECT 
    c.name,
    c.email,
    o.order_code,
    o.status,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('PENDING', 'CANCELLED')
ORDER BY o.status, o.order_date;

/**
 * OUTPUT:
 * ┌──────────┬───────────────────┬────────────┬────────────┬─────────────┬──────────────┐
 * │ name     │ email             │ order_code │ status     │ order_date  │ total_amount │
 * ├──────────┼───────────────────┼────────────┼────────────┼─────────────┼──────────────┤
 * │ John     │ john@demo.com     │ ORD9       │ CANCELLED  │ 2024-01-18  │ 4000.00      │
 * │ Priya    │ priya@demo.com    │ ORD7       │ PENDING    │ 2024-01-16  │ 2000.00      │
 * └──────────┴───────────────────┴────────────┴────────────┴─────────────┴──────────────┘
 */

-- ============================================================================
-- PART 9: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE 1: WHERE clause converts LEFT JOIN to INNER JOIN               │
 * │                                                                          │
 * │   ❌ WRONG:                                                             │
 * │   SELECT c.name, o.order_code                                          │
 * │   FROM customers c                                                     │
 * │   LEFT JOIN orders o ON c.customer_id = o.customer_id                  │
 * │   WHERE o.status = 'DELIVERED'   ← This removes customers without orders│
 * │                                                                          │
 * │   ✅ CORRECT:                                                           │
 * │   SELECT c.name, o.order_code                                          │
 * │   FROM customers c                                                     │
 * │   LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'DELIVERED'│
 * │                                                                          │
 * │ MISTAKE 2: Column ambiguity (same column name in multiple tables)     │
 * │                                                                          │
 * │   ❌ WRONG: SELECT customer_id FROM customers JOIN orders ...          │
 * │   ✅ CORRECT: SELECT c.customer_id FROM customers c JOIN orders o ...  │
 * │                                                                          │
 * │ MISTAKE 3: Using WHERE on aggregated column without GROUP BY          │
 * │                                                                          │
 * │   ❌ WRONG: SELECT c.name, SUM(o.total_amount) > 10000 ...             │
 * │   ✅ CORRECT: Use HAVING clause for aggregated filters                 │
 * │                                                                          │
 * │ MISTAKE 4: Forgetting table aliases in WHERE clause                    │
 * │                                                                          │
 * │   ❌ WRONG: SELECT * FROM customers c JOIN orders o WHERE customer_id = 1│
 * │   ✅ CORRECT: WHERE c.customer_id = 1                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example of MISTAKE 1 (LEFT JOIN becomes INNER JOIN)
-- This is WRONG - customers without DELIVERED orders will be removed!
SELECT 
    c.name,
    o.order_code,
    o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'DELIVERED';  -- This removes customers without orders!

-- Correct way to show all customers with only DELIVERED orders matched
SELECT 
    c.name,
    o.order_code,
    o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'DELIVERED';

-- ============================================================================
-- PART 10: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: WHERE filters AFTER JOIN                                       │
 * │         → JOIN first, then filter                                      │
 * │         → More efficient (less data to filter)                         │
 * │                                                                          │
 * │ RULE 2: Use table aliases in WHERE clause                              │
 * │         → Always use c.column_name, not just column_name               │
 * │         → Prevents ambiguity errors                                    │
 * │                                                                          │
 * │ RULE 3: Put JOIN conditions in ON, filters in WHERE                    │
 * │         → ON: How tables match                                         │
 * │         → WHERE: Which rows to keep                                    │
 * │         → This is the standard pattern                                 │
 * │                                                                          │
 * │ RULE 4: Be careful with LEFT JOIN and WHERE                            │
 * │         → Filtering on right table column converts to INNER JOIN       │
 * │         → Put right table filters in ON clause for LEFT JOIN           │
 * │                                                                          │
 * │ RULE 5: Use parentheses for complex conditions                         │
 * │         → WHERE (country = 'USA' OR country = 'UK') AND status = 'PAID'│
 * │         → Makes logic clear                                            │
 * │                                                                          │
 * │ RULE 6: Index columns used in WHERE                                    │
 * │         → WHERE country = 'India' → index on country                   │
 * │         → WHERE order_date > '2024-01-01' → index on order_date        │
 * │         → Makes queries much faster                                    │
 * │                                                                          │
 * │ RULE 7: Test with EXPLAIN                                              │
 * │         → EXPLAIN SELECT ...                                           │
 * │         → See if indexes are being used                                │
 * │                                                                          │
 * │ RULE 8: Use appropriate operators                                      │
 * │         → = for exact match                                            │
 * │         → LIKE for pattern matching                                    │
 * │         → IN for list of values                                        │
 * │         → BETWEEN for ranges                                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ BASIC JOIN WITH WHERE:                                                  │
 * │   SELECT columns                                                        │
 * │   FROM table1 t1                                                        │
 * │   JOIN table2 t2 ON t1.key = t2.foreign_key                            │
 * │   WHERE condition                                                       │
 * │                                                                          │
 * │ MULTIPLE CONDITIONS:                                                    │
 * │   WHERE col1 = 'value1' AND col2 = 'value2'    (both true)             │
 * │   WHERE col1 = 'value1' OR col2 = 'value2'     (either true)           │
 * │   WHERE col IN ('value1', 'value2')            (list match)            │
 * │   WHERE col BETWEEN 100 AND 200                (range)                 │
 * │   WHERE col LIKE 'pattern%'                    (starts with)           │
 * │   WHERE col IS NULL                            (null check)            │
 * │                                                                          │
 * │ LEFT JOIN WITH CONDITION IN ON:                                         │
 * │   SELECT columns                                                        │
 * │   FROM table1 t1                                                        │
 * │   LEFT JOIN table2 t2 ON t1.key = t2.foreign_key AND t2.status = 'X'  │
 * │                                                                          │
 * │ COMMON PATTERNS:                                                        │
 * │   -- Customers from specific country                                   │
 * │   WHERE c.country = 'India'                                            │
 * │                                                                          │
 * │   -- Orders in date range                                              │
 * │   WHERE o.order_date BETWEEN '2024-01-01' AND '2024-01-31'             │
 * │                                                                          │
 * │   -- High value orders                                                 │
 * │   WHERE o.total_amount > 10000                                         │
 * │                                                                          │
 * │   -- Specific statuses                                                 │
 * │   WHERE o.status IN ('DELIVERED', 'PAID')                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find all orders from UK customers
 * 
 * Answer:
 *   SELECT c.name, o.order_code, o.total_amount
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   WHERE c.country = 'UK';
 */

/**
 * EXERCISE 2: Find delivered orders over ₹5000
 * 
 * Answer:
 *   SELECT c.name, o.order_code, o.total_amount
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   WHERE o.status = 'DELIVERED' AND o.total_amount > 5000;
 */

/**
 * EXERCISE 3: Find customers who signed up in January 2024
 * 
 * Answer:
 *   SELECT name, email, signup_date
 *   FROM customers
 *   WHERE signup_date BETWEEN '2024-01-01' AND '2024-01-31';
 */

/**
 * EXERCISE 4: Find orders from India or USA that are not delivered
 * 
 * Answer:
 *   SELECT c.name, c.country, o.order_code, o.status
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   WHERE c.country IN ('India', 'USA') AND o.status != 'DELIVERED';
 */

/**
 * EXERCISE 5: Find orders placed in January 2024 from Delhi customers
 * 
 * Answer:
 *   SELECT c.name, c.city, o.order_code, o.order_date
 *   FROM customers c
 *   JOIN orders o ON c.customer_id = o.customer_id
 *   WHERE c.city = 'Delhi' AND o.order_date BETWEEN '2024-01-01' AND '2024-01-31';
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

-- Drop indexes first
DROP INDEX IF EXISTS idx_orders_customer_id;
DROP INDEX IF EXISTS idx_order_items_order_id;
DROP INDEX IF EXISTS idx_order_items_product_id;

-- Drop tables in reverse order (child tables first)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. JOIN = Combine data from multiple tables                            │
 * │ 2. WHERE = Filter the results                                           │
 * │ 3. JOIN with WHERE = Combine THEN filter                               │
 * │                                                                          │
 * │ 4. Order of execution:                                                  │
 * │    FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY         │
 * │                                                                          │
 * │ 5. WHERE conditions can use:                                            │
 * │    - =, !=, >, <, >=, <= (comparisons)                                 │
 * │    - AND, OR, NOT (logical operators)                                  │
 * │    - IN, BETWEEN, LIKE, IS NULL (special operators)                    │
 * │                                                                          │
 * │ 6. LEFT JOIN with WHERE on right table = INNER JOIN (be careful!)      │
 * │                                                                          │
 * │ 7. Always use table aliases in WHERE clause                            │
 * │                                                                          │
 * │ 8. Index columns used in WHERE for better performance                  │
 * │                                                                          │
 * │ MOST COMMON PATTERN:                                                    │
 * │   SELECT c.name, o.order_code, o.total_amount                          │
 * │   FROM customers c                                                      │
 * │   JOIN orders o ON c.customer_id = o.customer_id                       │
 * │   WHERE c.country = 'India' AND o.status = 'DELIVERED'                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF JOIN WITH WHERE GUIDE
-- ============================================================================