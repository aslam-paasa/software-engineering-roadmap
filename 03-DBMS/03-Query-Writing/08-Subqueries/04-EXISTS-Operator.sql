/**
 * ============================================================================
 * EXISTS OPERATOR - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS EXISTS? ------------------------ (Check if subquery returns rows)
 * 2. EXISTS vs IN --------------------------- (Key differences)
 * 3. EXISTS WITH SELECT 1 ------------------- (Standard pattern)
 * 4. EXISTS WITH DIFFERENT JOINS ------------ (Correlated subquery)
 * 5. NOT EXISTS ----------------------------- (Check if NO rows exist)
 * 6. EXISTS with Multiple Conditions -------- (AND, OR in subquery)
 * 7. EXISTS with UPDATE/DELETE -------------- (Modify based on existence)
 * 8. EXISTS vs IN Performance --------------- (Which is faster)
 * 9. REAL-WORLD SCENARIOS ------------------- (Practical examples)
 * 10. COMMON MISTAKES ----------------------- (What to avoid)
 * 11. GOLDEN RULES -------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: CUSTOMERS - Customer information
 */

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    join_date DATE
);

/**
 * TABLE 2: ORDERS - Purchase records
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(50),
    amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

/**
 * TABLE 3: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2),
    stock_quantity INT
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * CUSTOMERS TABLE
 * ┌─────────────┬───────────┬─────────────────────┬──────────────┬────────────┐
 * │ customer_id │ name      │ email               │ city         │ join_date  │
 * ├─────────────┼───────────┼─────────────────────┼──────────────┼────────────┤
 * │ 1           │ Ayaan     │ ayaan@email.com     │ Mumbai       │ 2024-01-01 │
 * │ 2           │ Sneha     │ sneha@email.com     │ Delhi        │ 2024-01-02 │
 * │ 3           │ Rohit     │ rohit@email.com     │ Bangalore    │ 2024-01-03 │
 * │ 4           │ John      │ john@email.com      │ New York     │ 2024-01-04 │
 * │ 5           │ Sarah     │ sarah@email.com     │ Los Angeles  │ 2024-01-05 │
 * │ 6           │ David     │ david@email.com     │ London       │ 2024-01-06 │
 * │ 7           │ Priya     │ priya@email.com     │ Chennai      │ 2024-01-07 │
 * │ 8           │ Michael   │ michael@email.com   │ Chicago      │ 2024-01-08 │
 * │ 9           │ Neha      │ neha@email.com      │ Pune         │ 2024-01-09 │
 * │ 10          │ Raj       │ raj@email.com       │ Ahmedabad    │ 2024-01-10 │
 * └─────────────┴───────────┴─────────────────────┴──────────────┴────────────┘
 */

INSERT INTO customers VALUES
(1, 'Ayaan', 'ayaan@email.com', 'Mumbai', '2024-01-01'),
(2, 'Sneha', 'sneha@email.com', 'Delhi', '2024-01-02'),
(3, 'Rohit', 'rohit@email.com', 'Bangalore', '2024-01-03'),
(4, 'John', 'john@email.com', 'New York', '2024-01-04'),
(5, 'Sarah', 'sarah@email.com', 'Los Angeles', '2024-01-05'),
(6, 'David', 'david@email.com', 'London', '2024-01-06'),
(7, 'Priya', 'priya@email.com', 'Chennai', '2024-01-07'),
(8, 'Michael', 'michael@email.com', 'Chicago', '2024-01-08'),
(9, 'Neha', 'neha@email.com', 'Pune', '2024-01-09'),
(10, 'Raj', 'raj@email.com', 'Ahmedabad', '2024-01-10');

/**
 * ORDERS TABLE
 * ┌──────────┬─────────────┬──────────────┬─────────┬────────────┬────────────┐
 * │ order_id │ customer_id │ product_name │ amount  │ order_date │ status     │
 * ├──────────┼─────────────┼──────────────┼─────────┼────────────┼────────────┤
 * │ 101      │ 1           │ Laptop       │ 50000   │ 2024-01-15 │ DELIVERED  │
 * │ 102      │ 1           │ Mouse        │ 500     │ 2024-01-16 │ DELIVERED  │
 * │ 103      │ 2           │ Keyboard     │ 1500    │ 2024-01-17 │ DELIVERED  │
 * │ 104      │ 4           │ Monitor      │ 10000   │ 2024-01-18 │ DELIVERED  │
 * │ 105      │ 5           │ Headphones   │ 2000    │ 2024-01-19 │ DELIVERED  │
 * │ 106      │ 4           │ USB Cable    │ 300     │ 2024-01-20 │ CANCELLED  │
 * │ 107      │ 7           │ Mouse Pad    │ 400     │ 2024-01-21 │ DELIVERED  │
 * │ 108      │ 8           │ Laptop Stand │ 2500    │ 2024-01-22 │ PENDING    │
 * │ 109      │ 3           │ Webcam       │ 3500    │ 2024-01-23 │ DELIVERED  │
 * │ 110      │ 5           │ Speaker      │ 4000    │ 2024-01-24 │ DELIVERED  │
 * └──────────┴─────────────┴──────────────┴─────────┴────────────┴────────────┘
 */

INSERT INTO orders VALUES
(101, 1, 'Laptop', 50000, '2024-01-15', 'DELIVERED'),
(102, 1, 'Mouse', 500, '2024-01-16', 'DELIVERED'),
(103, 2, 'Keyboard', 1500, '2024-01-17', 'DELIVERED'),
(104, 4, 'Monitor', 10000, '2024-01-18', 'DELIVERED'),
(105, 5, 'Headphones', 2000, '2024-01-19', 'DELIVERED'),
(106, 4, 'USB Cable', 300, '2024-01-20', 'CANCELLED'),
(107, 7, 'Mouse Pad', 400, '2024-01-21', 'DELIVERED'),
(108, 8, 'Laptop Stand', 2500, '2024-01-22', 'PENDING'),
(109, 3, 'Webcam', 3500, '2024-01-23', 'DELIVERED'),
(110, 5, 'Speaker', 4000, '2024-01-24', 'DELIVERED');

/**
 * PRODUCTS TABLE
 * ┌────────────┬──────────────┬──────────────┬─────────┬────────────────┐
 * │ product_id │ product_name │ category     │ price   │ stock_quantity │
 * ├────────────┼──────────────┼──────────────┼─────────┼────────────────┤
 * │ 1          │ Laptop       │ Electronics  │ 50000   │ 10             │
 * │ 2          │ Mouse        │ Electronics  │ 500     │ 50             │
 * │ 3          │ Keyboard     │ Electronics  │ 1500    │ 30             │
 * │ 4          │ Monitor      │ Electronics  │ 10000   │ 5              │
 * │ 5          │ Headphones   │ Accessories  │ 2000    │ 20             │
 * │ 6          │ USB Cable    │ Accessories  │ 300     │ 100            │
 * │ 7          │ Mouse Pad    │ Accessories  │ 400     │ 40             │
 * │ 8          │ Webcam       │ Electronics  │ 3500    │ 15             │
 * │ 9          │ Speaker      │ Electronics  │ 4000    │ 8              │
 * └────────────┴──────────────┴──────────────┴─────────┴────────────────┘
 */

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 50000, 10),
(2, 'Mouse', 'Electronics', 500, 50),
(3, 'Keyboard', 'Electronics', 1500, 30),
(4, 'Monitor', 'Electronics', 10000, 5),
(5, 'Headphones', 'Accessories', 2000, 20),
(6, 'USB Cable', 'Accessories', 300, 100),
(7, 'Mouse Pad', 'Accessories', 400, 40),
(8, 'Webcam', 'Electronics', 3500, 15),
(9, 'Speaker', 'Electronics', 4000, 8);

-- ============================================================================
-- PART 1: WHAT IS EXISTS?
-- ============================================================================

/**
 * EXISTS checks whether a subquery returns ANY rows.
 * Returns TRUE if subquery has at least one row.
 * Returns FALSE if subquery has no rows.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS EXISTS?                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT column1, column2                                         │   │
 * │   │ FROM table1                                                     │   │
 * │   │ WHERE EXISTS (                                                  │   │
 * │   │     SELECT 1                                                    │   │
 * │   │     FROM table2                                                 │   │
 * │   │     WHERE table2.foreign_key = table1.primary_key               │   │
 * │   │ );                                                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. For each row in the outer query...                          │   │
 * │   │ 2. ...run the subquery to check if ANY row exists              │   │
 * │   │ 3. If subquery returns at least one row → TRUE → KEEP row      │   │
 * │   │ 4. If subquery returns no rows → FALSE → REMOVE row            │   │
 * │   │ 5. Stops searching as soon as first match is found (efficient) │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ "Show me all customers who have placed at least one order"     │   │
 * │   │                                                                  │   │
 *   │   │ For each customer, check orders table:                         │   │
 * │   │   - Customer 1 (Ayaan): Has orders? YES → Include               │   │
 * │   │   - Customer 2 (Sneha): Has orders? YES → Include               │   │
 * │   │   - Customer 3 (Rohit): Has orders? YES → Include               │   │
 * │   │   - Customer 6 (David): Has orders? NO → Exclude                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    EXISTS - SIMPLE EXAMPLE                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find customers who have placed at least one order             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.customer_id, c.name                                   │   │
 * │   │ FROM customers c                                               │   │
 * │   │ WHERE EXISTS (                                                  │   │
 * │   │     SELECT 1                                                   │   │
 * │   │     FROM orders o                                              │   │
 * │   │     WHERE o.customer_id = c.customer_id                        │   │
 * │   │ );                                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS (for each customer):                                     │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Customer 1 (Ayaan): Subquery finds orders? YES → KEEP           │   │
 * │   │ Customer 2 (Sneha): Subquery finds orders? YES → KEEP           │   │
 * │   │ Customer 3 (Rohit): Subquery finds orders? YES → KEEP           │   │
 * │   │ Customer 4 (John): Subquery finds orders? YES → KEEP            │   │
 * │   │ Customer 5 (Sarah): Subquery finds orders? YES → KEEP           │   │
 * │   │ Customer 6 (David): Subquery finds orders? NO → REMOVE          │   │
 * │   │ Customer 7 (Priya): Subquery finds orders? YES → KEEP           │   │
 * │   │ Customer 8 (Michael): Subquery finds orders? YES → KEEP         │   │
 * │   │ Customer 9 (Neha): Subquery finds orders? NO → REMOVE           │   │
 * │   │ Customer 10 (Raj): Subquery finds orders? NO → REMOVE           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────┬───────────┐                                         │
 * │   │ customer_id │ name      │                                         │
 * │   ├─────────────┼───────────┤                                         │
 * │   │ 1           │ Ayaan     │                                         │
 * │   │ 2           │ Sneha     │                                         │
 * │   │ 3           │ Rohit     │                                         │
 * │   │ 4           │ John      │                                         │
 * │   │ 5           │ Sarah     │                                         │
 * │   │ 7           │ Priya     │                                         │
 * │   │ 8           │ Michael   │                                         │
 * │   └─────────────┴───────────┘                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find customers who have placed at least one order
SELECT 
    c.customer_id,
    c.name,
    c.city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬───────────┬──────────────┐
 * │ customer_id │ name      │ city         │
 * ├─────────────┼───────────┼──────────────┤
 * │ 1           │ Ayaan     │ Mumbai       │
 * │ 2           │ Sneha     │ Delhi        │
 * │ 3           │ Rohit     │ Bangalore    │
 * │ 4           │ John      │ New York     │
 * │ 5           │ Sarah     │ Los Angeles  │
 * │ 7           │ Priya     │ Chennai      │
 * │ 8           │ Michael   │ Chicago      │
 * └─────────────┴───────────┴──────────────┘
 * 
 * EXPLANATION:
 * - EXISTS checks if subquery returns any rows for each customer
 * - Customers 6 (David), 9 (Neha), 10 (Raj) have no orders → excluded
 * - SELECT 1 is used (value doesn't matter, only existence matters)
 */

-- ============================================================================
-- PART 2: EXISTS vs IN (Key differences)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    EXISTS vs IN - COMPARISON                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    EXISTS                                        │   │
 *   │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ • Returns TRUE/FALSE (existence check)                          │   │
 * │   │ • Can use any columns in subquery                               │   │
 * │   │ • Stops at first match (efficient)                              │   │
 * │   │ • Best for: "Does any row exist?"                               │   │
 * │   │ • Works correctly with NULLs                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    IN                                           │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ • Returns TRUE if value matches any in list                     │   │
 * │   │ • Subquery must return ONE column                               │   │
 * │   │ • Evaluates all rows in subquery (can be slower)                │   │
 * │   │ • Best for: "Is value in this list?"                            │   │
 * │   │ • Can have issues with NULLs                                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Using EXISTS
SELECT c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
);

-- Using IN (same result)
SELECT c.name
FROM customers c
WHERE c.customer_id IN (
    SELECT DISTINCT o.customer_id 
    FROM orders o
);

/**
 * Both return same results:
 * Ayaan, Sneha, Rohit, John, Sarah, Priya, Michael
 * 
 * BUT EXISTS is often faster because:
 * - Stops searching as soon as first match found
 * - Doesn't need to process all rows like IN does
 */

-- ============================================================================
-- PART 3: EXISTS WITH SELECT 1 (Standard pattern)
-- ============================================================================

/**
 * In EXISTS subquery, the SELECT columns don't matter.
 * Convention is to use SELECT 1 (or SELECT NULL, SELECT *).
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SELECT 1 IN EXISTS                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   All these work the same:                                             │
 * │                                                                          │
 * │   SELECT 1 FROM orders WHERE customer_id = 1                           │
 * │   SELECT * FROM orders WHERE customer_id = 1                           │
 * │   SELECT NULL FROM orders WHERE customer_id = 1                        │
 * │   SELECT 'anything' FROM orders WHERE customer_id = 1                  │
 * │                                                                          │
 * │   Because EXISTS only cares about: "Does this query return ANY rows?"  │
 * │   The actual values don't matter.                                      │
 * │                                                                          │
 * │   Convention: Use SELECT 1 for clarity                                 │
 * │   - Shows that you don't care about the actual data                    │
 * │   - Only checking existence                                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- All these are equivalent
SELECT c.name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

SELECT c.name
FROM customers c
WHERE EXISTS (SELECT * FROM orders o WHERE o.customer_id = c.customer_id);

SELECT c.name
FROM customers c
WHERE EXISTS (SELECT NULL FROM orders o WHERE o.customer_id = c.customer_id);

-- ============================================================================
-- PART 4: EXISTS WITH DIFFERENT JOINS (Correlated subquery)
-- ============================================================================

/**
 * EXISTS is a correlated subquery - it references the outer query.
 */

-- EXAMPLE 1: Find customers who ordered Laptop
SELECT 
    c.customer_id,
    c.name,
    c.city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.product_name = 'Laptop'
);

/**
 * OUTPUT:
 * ┌─────────────┬───────────┬──────────┐
 * │ customer_id │ name      │ city     │
 * ├─────────────┼───────────┼──────────┤
 * │ 1           │ Ayaan     │ Mumbai   │
 * └─────────────┴───────────┴──────────┘
 * 
 * EXPLANATION:
 * - Only customers who have an order with product_name = 'Laptop'
 * - Ayaan (customer_id=1) has Laptop order
 */

-- EXAMPLE 2: Find customers who ordered products over ₹5000
SELECT 
    c.customer_id,
    c.name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.amount > 5000
);

/**
 * OUTPUT:
 * ┌─────────────┬───────────┐
 * │ customer_id │ name      │
 * ├─────────────┼───────────┤
 * │ 1           │ Ayaan     │
 * │ 4           │ John      │
 * └─────────────┴───────────┘
 * 
 * EXPLANATION:
 * - Ayaan: Laptop (50000) > 5000
 * - John: Monitor (10000) > 5000
 */

-- ============================================================================
-- PART 5: NOT EXISTS (Check if NO rows exist)
-- ============================================================================

/**
 * NOT EXISTS returns TRUE if subquery returns NO rows.
 * Perfect for "never happened" queries.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    NOT EXISTS                                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find customers who have NEVER placed an order                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT c.customer_id, c.name                                   │   │
 * │   │ FROM customers c                                               │   │
 * │   │ WHERE NOT EXISTS (                                             │   │
 * │   │     SELECT 1                                                   │   │
 * │   │     FROM orders o                                              │   │
 * │   │     WHERE o.customer_id = c.customer_id                        │   │
 * │   │ );                                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────┬───────────┐                                         │
 * │   │ customer_id │ name      │                                         │
 * │   ├─────────────┼───────────┤                                         │
 * │   │ 6           │ David     │                                         │
 * │   │ 9           │ Neha      │                                         │
 * │   │ 10          │ Raj       │                                         │
 * │   └─────────────┴───────────┘                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find customers who have NEVER placed an order
SELECT 
    c.customer_id,
    c.name,
    c.city
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
ORDER BY c.customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬───────────┬────────────┐
 * │ customer_id │ name      │ city       │
 * ├─────────────┼───────────┼────────────┤
 * │ 6           │ David     │ London     │
 * │ 9           │ Neha      │ Pune       │
 * │ 10          │ Raj       │ Ahmedabad  │
 * └─────────────┴───────────┴────────────┘
 * 
 * EXPLANATION:
 * - NOT EXISTS returns TRUE when subquery finds NO orders
 * - Customers 6, 9, 10 have no orders → included
 */

-- Find products that have never been ordered
SELECT 
    p.product_id,
    p.product_name,
    p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.product_name = p.product_name
);

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────┐
 * │ product_id │ product_name │ price   │
 * ├────────────┼──────────────┼─────────┤
 * │ 8          │ Webcam       │ 3500    │
 * │ 9          │ Speaker      │ 4000    │
 * └────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Webcam and Speaker have never been ordered
 */

-- ============================================================================
-- PART 6: EXISTS with Multiple Conditions (AND, OR in subquery)
-- ============================================================================

/**
 * You can use AND/OR inside the EXISTS subquery.
 */

-- EXAMPLE 1: Customers with high-value orders (amount > 5000) AND delivered
SELECT 
    c.name,
    c.city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.amount > 5000
      AND o.status = 'DELIVERED'
);

/**
 * OUTPUT:
 * ┌───────────┬──────────┐
 * │ name      │ city     │
 * ├───────────┼──────────┤
 * │ Ayaan     │ Mumbai   │
 * │ John      │ New York │
 * └───────────┴──────────┘
 */

-- EXAMPLE 2: Customers with orders from specific date range
SELECT 
    c.name,
    c.join_date
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date BETWEEN '2024-01-15' AND '2024-01-20'
);

/**
 * OUTPUT:
 * ┌───────────┬────────────┐
 * │ name      │ join_date  │
 * ├───────────┼────────────┤
 * │ Ayaan     │ 2024-01-01 │
 * │ Sneha     │ 2024-01-02 │
 * │ John      │ 2024-01-04 │
 * │ Sarah     │ 2024-01-05 │
 * │ Priya     │ 2024-01-07 │
 * └───────────┴────────────┘
 */

-- EXAMPLE 3: Customers with orders OR from specific city (using OR in outer)
SELECT 
    c.name,
    c.city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
OR c.city = 'London';

/**
 * OUTPUT:
 * ┌───────────┬──────────────┐
 * │ name      │ city         │
 * ├───────────┼──────────────┤
 * │ Ayaan     │ Mumbai       │
 * │ Sneha     │ Delhi        │
 * │ Rohit     │ Bangalore    │
 * │ John      │ New York     │
 * │ Sarah     │ Los Angeles  │
 * │ David     │ London       │
 * │ Priya     │ Chennai      │
 * │ Michael   │ Chicago      │
 * └───────────┴──────────────┘
 * 
 * EXPLANATION:
 * - Customers with orders (Ayaan, Sneha, Rohit, John, Sarah, Priya, Michael)
 * - OR customers from London (David)
 */

-- ============================================================================
-- PART 7: EXISTS with UPDATE/DELETE (Modify based on existence)
-- ============================================================================

/**
 * You can use EXISTS in UPDATE and DELETE statements.
 */

-- EXAMPLE 1: Update product stock for products that have been ordered
-- First, check current stock
SELECT product_name, stock_quantity FROM products WHERE product_name IN ('Laptop', 'Mouse');

-- Update stock (reduce by 1 for ordered products)
UPDATE products p
SET stock_quantity = stock_quantity - 1
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.product_name = p.product_name
);

-- Check updated stock
SELECT product_name, stock_quantity FROM products ORDER BY product_name;

/**
 * OUTPUT (before and after):
 * ┌──────────────┬─────────────────┐
 * │ product_name │ stock_quantity  │
 * ├──────────────┼─────────────────┤
 * │ Headphones   │ 19 (was 20)     │
 * │ Keyboard     │ 29 (was 30)     │
 * │ Laptop       │ 9 (was 10)      │
 * │ Monitor      │ 4 (was 5)       │
 * │ Mouse        │ 49 (was 50)     │
 * │ Mouse Pad    │ 39 (was 40)     │
 * │ USB Cable    │ 99 (was 100)    │
 * │ Webcam       │ 15 (unchanged)  │
 * │ Speaker      │ 8 (unchanged)   │
 * └──────────────┴─────────────────┘
 */

-- Reset stock for demo
UPDATE products SET stock_quantity = 
    CASE product_name
        WHEN 'Laptop' THEN 10
        WHEN 'Mouse' THEN 50
        WHEN 'Keyboard' THEN 30
        WHEN 'Monitor' THEN 5
        WHEN 'Headphones' THEN 20
        WHEN 'USB Cable' THEN 100
        WHEN 'Mouse Pad' THEN 40
        WHEN 'Webcam' THEN 15
        WHEN 'Speaker' THEN 8
    END;

-- EXAMPLE 2: Delete customers who have no orders
-- First, check customers with no orders
SELECT c.name FROM customers c 
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Delete them (commented for safety)
-- DELETE FROM customers c
-- WHERE NOT EXISTS (
--     SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
-- );

-- ============================================================================
-- PART 8: EXISTS vs IN Performance
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    EXISTS vs IN - PERFORMANCE                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   EXISTS is usually FASTER for existence checks because:                │
 * │                                                                          │
 *   │   1. Stops searching as soon as FIRST match is found                  │
 * │   2. Doesn't need to process all rows in subquery                       │
 * │   3. More efficient with correlated subqueries                         │
 * │                                                                          │
 * │   IN can be slower because:                                             │
 * │                                                                          │
 * │   1. Must process ALL rows in subquery                                  │
 * │   2. Builds complete result set before comparing                        │
 * │   3. Can have issues with NULLs                                        │
 * │                                                                          │
 * │   RULE OF THUMB:                                                        │
 * │   - Use EXISTS when checking existence ("Does any row exist?")         │
 * │   - Use IN when you need actual values from subquery                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Find customers who have ordered in the last 7 days
 */

SELECT 
    c.name,
    c.email,
    MAX(o.order_date) AS last_order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE EXISTS (
    SELECT 1
    FROM orders o2
    WHERE o2.customer_id = c.customer_id
      AND o2.order_date >= CURRENT_DATE - INTERVAL '7 days'
)
GROUP BY c.customer_id, c.name, c.email
ORDER BY last_order_date DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┬─────────────────┐
 * │ name    │ email           │ last_order_date │
 * ├─────────┼─────────────────┼─────────────────┤
 * │ Sarah   │ sarah@email.com │ 2024-01-24      │
 * │ Michael │ michael@email.com│ 2024-01-22    │
 * │ Priya   │ priya@email.com │ 2024-01-21      │
 * │ John    │ john@email.com  │ 2024-01-20      │
 * │ Sarah   │ sarah@email.com │ 2024-01-19      │
 * │ Ayaan   │ ayaan@email.com │ 2024-01-16      │
 * │ Sneha   │ sneha@email.com │ 2024-01-17      │
 * └─────────┴─────────────────┴─────────────────┘
 */

/**
 * SCENARIO 2: Find products that are low in stock AND have been ordered
 * (Need to restock popular items)
 */

SELECT 
    p.product_name,
    p.stock_quantity,
    COUNT(o.order_id) AS times_ordered
FROM products p
INNER JOIN orders o ON p.product_name = o.product_name
WHERE p.stock_quantity < 20
  AND EXISTS (
    SELECT 1
    FROM orders o2
    WHERE o2.product_name = p.product_name
)
GROUP BY p.product_name, p.stock_quantity
ORDER BY times_ordered DESC;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬───────────────┐
 * │ product_name │ stock_quantity  │ times_ordered │
 * ├──────────────┼─────────────────┼───────────────┤
 * │ Monitor      │ 5               │ 1             │
 * │ Laptop       │ 10              │ 1             │
 * └──────────────┴─────────────────┴───────────────┘
 */

/**
 * SCENARIO 3: Find customers who have ordered more than ₹10000 total
 */

SELECT 
    c.name,
    c.city,
    total_spent
FROM customers c
INNER JOIN (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) AS spending ON c.customer_id = spending.customer_id
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
    GROUP BY o.customer_id
    HAVING SUM(o.amount) > 10000
)
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┐
 * │ name    │ city      │ total_spent │
 * ├─────────┼───────────┼─────────────┤
 * │ Ayaan   │ Mumbai    │ 50500.00    │
 * │ John    │ New York  │ 10300.00    │
 * └─────────┴───────────┴─────────────┘
 */

/**
 * SCENARIO 4: Find customers who ordered every product in a category
 * (Double NOT EXISTS = Relational Division)
 */

-- Find customers who ordered ALL Electronics products
SELECT 
    c.name,
    c.city
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM products p
    WHERE p.category = 'Electronics'
    AND NOT EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = c.customer_id
          AND o.product_name = p.product_name
    )
);

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ name    │ city     │
 * ├─────────┼──────────┤
 * │ Ayaan   │ Mumbai   │
 * └─────────┴──────────┘
 * 
 * EXPLANATION:
 * - Ayaan ordered Laptop, Mouse, Keyboard (all Electronics products)
 * - Other customers missing at least one Electronics product
 */

/**
 * SCENARIO 5: Customer churn analysis (inactive customers)
 * Find customers who joined more than 30 days ago but never ordered
 */

SELECT 
    c.name,
    c.email,
    c.join_date,
    CURRENT_DATE - c.join_date AS days_since_join
FROM customers c
WHERE c.join_date < CURRENT_DATE - INTERVAL '30 days'
  AND NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
ORDER BY days_since_join DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┬────────────┬─────────────────┐
 * │ name    │ email           │ join_date  │ days_since_join │
 * ├─────────┼─────────────────┼────────────┼─────────────────┤
 * │ David   │ david@email.com │ 2024-01-06 │ 94              │
 * │ Raj     │ raj@email.com   │ 2024-01-10 │ 90              │
 * │ Neha    │ neha@email.com  │ 2024-01-09 │ 91              │
 * └─────────┴─────────────────┴────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Using EXISTS without correlation                           │
 * │                                                                          │
 * │   ❌ WHERE EXISTS (SELECT 1 FROM orders)                                │
 * │      → This is always TRUE (orders has rows)                           │
 * │      → Returns ALL customers!                                          │
 * │                                                                          │
 * │   ✅ WHERE EXISTS (SELECT 1 FROM orders WHERE customer_id = c.customer_id)│
 * │      → Correlated subquery - checks per customer                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ WRONG - This returns ALL customers (because orders table has rows)
SELECT c.name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders);

-- ✅ CORRECT - Correlated subquery
SELECT c.name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Using NOT IN instead of NOT EXISTS                         │
 * │                                                                          │
 * │   NOT IN with NULL can return NO rows!                                 │
 * │                                                                          │
 * │   ❌ SELECT * FROM customers WHERE customer_id NOT IN                  │
 * │        (SELECT customer_id FROM orders)                                │
 * │      → If orders.customer_id has NULL, returns NO rows!                │
 * │                                                                          │
 * │   ✅ SELECT * FROM customers c WHERE NOT EXISTS                         │
 * │        (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id)    │
 * │      → Safe with NULLs                                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 11: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: EXISTS checks for ANY row, not specific values                 │
 * │         → Use SELECT 1 (convention for "I don't care about values")    │
 * │                                                                          │
 * │ RULE 2: EXISTS is a CORRELATED subquery                                │
 * │         → Must reference outer query column                            │
 * │         → WHERE o.customer_id = c.customer_id                          │
 * │                                                                          │
 * │ RULE 3: EXISTS stops at first match (efficient)                        │
 * │         → Better than IN for large datasets                            │
 * │                                                                          │
 * │ RULE 4: NOT EXISTS is safe with NULLs                                  │
 * │         → Always use NOT EXISTS instead of NOT IN                      │
 * │                                                                          │
 * │ RULE 5: Use EXISTS when you only need to know "if any row exists"      │
 * │         → Don't use when you need actual values from subquery          │
 * │                                                                          │
 * │ RULE 6: Double NOT EXISTS = "For all" or "Every"                       │
 * │         → NOT EXISTS (SELECT 1 WHERE NOT EXISTS (...))                 │
 * │         → Finds customers who bought ALL products                      │
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
 * │ -- Basic EXISTS (customers with orders)                                │
 * │ SELECT * FROM customers c                                              │
 * │ WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);│
 * │                                                                          │
 * │ -- NOT EXISTS (customers without orders)                               │
 * │ SELECT * FROM customers c                                              │
 * │ WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);│
 * │                                                                          │
 * │ -- EXISTS with multiple conditions                                     │
 * │ WHERE EXISTS (                                                        │
 * │     SELECT 1 FROM orders                                              │
 * │     WHERE customer_id = c.customer_id                                 │
 * │       AND amount > 1000                                               │
 * │       AND status = 'DELIVERED'                                        │
 * │ );                                                                    │
 * │                                                                          │
 * │ -- Double NOT EXISTS (customers who bought ALL products)              │
 * │ WHERE NOT EXISTS (                                                    │
 * │     SELECT 1 FROM products p                                          │
 * │     WHERE NOT EXISTS (                                                │
 * │         SELECT 1 FROM orders o                                        │
 * │         WHERE o.customer_id = c.customer_id                           │
 * │           AND o.product_id = p.product_id                             │
 * │     )                                                                 │
 * │ );                                                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find customers who have placed an order with amount > 5000
 * 
 * Answer:
 *   SELECT c.name FROM customers c
 *   WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id AND o.amount > 5000);
 */

/**
 * EXERCISE 2: Find customers who have NEVER ordered (using NOT EXISTS)
 * 
 * Answer:
 *   SELECT c.name FROM customers c
 *   WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);
 */

/**
 * EXERCISE 3: Find customers who ordered 'Laptop'
 * 
 * Answer:
 *   SELECT c.name FROM customers c
 *   WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id AND o.product_name = 'Laptop');
 */

/**
 * EXERCISE 4: Find products that have been ordered at least once
 * 
 * Answer:
 *   SELECT p.product_name FROM products p
 *   WHERE EXISTS (SELECT 1 FROM orders o WHERE o.product_name = p.product_name);
 */

/**
 * EXERCISE 5: Find customers who ordered in January 2024
 * 
 * Answer:
 *   SELECT c.name FROM customers c
 *   WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id 
 *                 AND o.order_date BETWEEN '2024-01-01' AND '2024-01-31');
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

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
 * │ 1. EXISTS = Checks if subquery returns ANY rows                        │
 * │    → Returns TRUE/FALSE, not actual data                               │
 * │                                                                          │
 * │ 2. EXISTS is a CORRELATED subquery                                     │
 * │    → References outer query column                                     │
 * │    → WHERE o.customer_id = c.customer_id                               │
 * │                                                                          │
 * │ 3. SELECT 1 is convention (value doesn't matter)                       │
 * │    → Only existence matters                                            │
 * │                                                                          │
 * │ 4. NOT EXISTS = Checks if subquery returns NO rows                     │
 * │    → Safe with NULLs (unlike NOT IN)                                   │
 * │                                                                          │
 * │ 5. EXISTS is more efficient than IN for large datasets                 │
 * │    → Stops at first match                                              │
 * │                                                                          │
 * │ 6. Double NOT EXISTS = "For all" or "Every"                            │
 * │    → Customers who bought ALL products                                 │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - EXISTS checks EXISTENCE, not values                                │
 * │   - Always correlate with outer query                                  │
 * │   - Use SELECT 1 for clarity                                           │
 * │   - NOT EXISTS > NOT IN (safer with NULLs)                             │
 * │   - EXISTS stops early → faster                                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF EXISTS OPERATOR GUIDE
-- ============================================================================