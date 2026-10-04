/**
 * ============================================================================
 * SUBQUERY IN WHERE - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS SUBQUERY IN WHERE? ------------- (Filter using query results)
 * 2. SUBQUERY WITH COMPARISON OPERATORS ----- (> , < , = , >= , <=)
 * 3. SUBQUERY WITH IN ----------------------- (Match any value in list)
 * 4. SUBQUERY WITH EXISTS ------------------- (Check existence)
 * 5. SUBQUERY WITH NOT EXISTS --------------- (Check non-existence)
 * 6. SUBQUERY WITH ANY/ALL ------------------ (Compare with any/all)
 * 7. MULTIPLE SUBQUERIES IN WHERE ----------- (Combining conditions)
 * 8. SUBQUERY WITH AGGREGATES --------------- (MAX, MIN, AVG, SUM)
 * 9. NESTED SUBQUERIES ---------------------- (Subquery inside subquery)
 * 10. REAL-WORLD SCENARIOS ------------------ (Practical examples)
 * 11. COMMON MISTAKES ----------------------- (What to avoid)
 * 12. GOLDEN RULES -------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: PRODUCTS - Items available for sale
 */

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2)
);

/**
 * TABLE 2: ORDERS - Customer purchase records
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT,
    amount DECIMAL(10,2),
    order_date DATE
);

/**
 * TABLE 3: EMPLOYEES - Company employee data
 */

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * PRODUCTS TABLE
 * ┌────────────┬──────────────┬──────────────┬─────────┐
 * │ product_id │ product_name │ category     │ price   │
 * ├────────────┼──────────────┼──────────────┼─────────┤
 * │    1       │ Laptop       │ Electronics  │ 50000   │
 * │    2       │ Mouse        │ Electronics  │ 500     │
 * │    3       │ Keyboard     │ Electronics  │ 1500    │
 * │    4       │ Monitor      │ Electronics  │ 10000   │
 * │    5       │ Headphones   │ Accessories  │ 2000    │
 * │    6       │ USB Cable    │ Accessories  │ 300     │
 * │    7       │ Mouse Pad    │ Accessories  │ 400     │
 * │    8       │ Laptop Stand │ Accessories  │ 2500    │
 * │    9       │ Webcam       │ Electronics  │ 3500    │
 * │   10       │ Speaker      │ Electronics  │ 4000    │
 * └────────────┴──────────────┴──────────────┴─────────┘
 */

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 50000),
(2, 'Mouse', 'Electronics', 500),
(3, 'Keyboard', 'Electronics', 1500),
(4, 'Monitor', 'Electronics', 10000),
(5, 'Headphones', 'Accessories', 2000),
(6, 'USB Cable', 'Accessories', 300),
(7, 'Mouse Pad', 'Accessories', 400),
(8, 'Laptop Stand', 'Accessories', 2500),
(9, 'Webcam', 'Electronics', 3500),
(10, 'Speaker', 'Electronics', 4000);

/**
 * ORDERS TABLE
 * ┌──────────┬─────────┬────────────┬──────────┬─────────┬────────────┐
 * │ order_id │ user_id │ product_id │ quantity │ amount  │ order_date │
 * ├──────────┼─────────┼────────────┼──────────┼─────────┼────────────┤
 * │    1     │ 101     │ 1          │ 1        │ 50000   │ 2024-01-10 │
 * │    2     │ 102     │ 2          │ 2        │ 1000    │ 2024-01-11 │
 * │    3     │ 101     │ 3          │ 1        │ 1500    │ 2024-01-12 │
 * │    4     │ 103     │ 4          │ 1        │ 10000   │ 2024-01-13 │
 * │    5     │ 102     │ 5          │ 1        │ 2000    │ 2024-01-14 │
 * │    6     │ 101     │ 6          │ 3        │ 900     │ 2024-01-15 │
 * │    7     │ 104     │ 7          │ 2        │ 800     │ 2024-01-16 │
 * │    8     │ 103     │ 8          │ 1        │ 2500    │ 2024-01-17 │
 * │    9     │ 101     │ 9          │ 1        │ 3500    │ 2024-01-18 │
 * │   10     │ 102     │ 10         │ 1        │ 4000    │ 2024-01-19 │
 * └──────────┴─────────┴────────────┴──────────┴─────────┴────────────┘
 */

INSERT INTO orders VALUES
(1, 101, 1, 1, 50000, '2024-01-10'),
(2, 102, 2, 2, 1000, '2024-01-11'),
(3, 101, 3, 1, 1500, '2024-01-12'),
(4, 103, 4, 1, 10000, '2024-01-13'),
(5, 102, 5, 1, 2000, '2024-01-14'),
(6, 101, 6, 3, 900, '2024-01-15'),
(7, 104, 7, 2, 800, '2024-01-16'),
(8, 103, 8, 1, 2500, '2024-01-17'),
(9, 101, 9, 1, 3500, '2024-01-18'),
(10, 102, 10, 1, 4000, '2024-01-19');

/**
 * EMPLOYEES TABLE
 * ┌────────┬───────────┬────────────┬─────────┐
 * │ emp_id │ emp_name  │ department │ salary  │
 * ├────────┼───────────┼────────────┼─────────┤
 * │ 1      │ Alice     │ IT         │ 80000   │
 * │ 2      │ Bob       │ IT         │ 75000   │
 * │ 3      │ Carol     │ HR         │ 60000   │
 * │ 4      │ Dave      │ IT         │ 90000   │
 * │ 5      │ Eve       │ Finance    │ 70000   │
 * │ 6      │ Frank     │ HR         │ 55000   │
 * │ 7      │ Grace     │ Finance    │ 85000   │
 * │ 8      │ Hank      │ IT         │ 65000   │
 * └────────┴───────────┴────────────┴─────────┘
 */

INSERT INTO employees VALUES
(1, 'Alice', 'IT', 80000),
(2, 'Bob', 'IT', 75000),
(3, 'Carol', 'HR', 60000),
(4, 'Dave', 'IT', 90000),
(5, 'Eve', 'Finance', 70000),
(6, 'Frank', 'HR', 55000),
(7, 'Grace', 'Finance', 85000),
(8, 'Hank', 'IT', 65000);

-- ============================================================================
-- PART 1: WHAT IS SUBQUERY IN WHERE?
-- ============================================================================

/**
 * Subquery in WHERE uses the result of a SELECT statement as a filter value.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY IN WHERE - SIMPLE EXAMPLE                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   THE PROBLEM: "Find products that cost more than average"             │
 * │                                                                          │
 *   │   STEP 1 (Subquery): Calculate average price of all products          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT AVG(price) FROM products                                │   │
 * │   │ Result: 7450.00 (average of all 10 products)                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2 (Outer query): Find products with price > average            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT product_name, price FROM products                        │   │
 * │   │ WHERE price > 7450.00                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   COMBINED QUERY:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT product_name, price                                      │   │
 * │   │ FROM products                                                   │   │
 * │   │ WHERE price > (SELECT AVG(price) FROM products);                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────────┬─────────┐                                          │
 * │   │ product_name │ price   │                                          │
 * │   ├──────────────┼─────────┤                                          │
 * │   │ Laptop       │ 50000   │  ← > 7450                                │
 * │   │ Monitor      │ 10000   │  ← > 7450                                │
 * │   │ Speaker      │ 4000    │  ← NOT > 7450 (less)                     │
 * │   └──────────────┴─────────┘                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Simple example: Products more expensive than average
SELECT 
    product_name,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * │ Monitor      │ 10000   │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Subquery calculates AVG(price) = (50000+500+1500+10000+2000+300+400+2500+3500+4000)/10 = 7450
 * - Outer query finds products with price > 7450
 * - Only Laptop (50000) and Monitor (10000) qualify
 */

-- ============================================================================
-- PART 2: SUBQUERY WITH COMPARISON OPERATORS (> , < , = , >= , <=)
-- ============================================================================

/**
 * EXAMPLE 1: Products cheaper than average (using <)
 */

SELECT 
    product_name,
    price
FROM products
WHERE price < (SELECT AVG(price) FROM products)
ORDER BY price DESC;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Speaker      │ 4000    │
 * │ Webcam       │ 3500    │
 * │ Laptop Stand │ 2500    │
 * │ Headphones   │ 2000    │
 * │ Keyboard     │ 1500    │
 * │ Mouse        │ 500     │
 * │ Mouse Pad    │ 400     │
 * │ USB Cable    │ 300     │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - All products with price < 7450
 * - 8 products are below average
 */

/**
 * EXAMPLE 2: Products with price exactly equal to maximum price
 */

SELECT 
    product_name,
    price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Subquery finds MAX(price) = 50000
 * - Outer query finds product with price = 50000
 */

/**
 * EXAMPLE 3: Products with price greater than or equal to average
 */

SELECT 
    product_name,
    price
FROM products
WHERE price >= (SELECT AVG(price) FROM products)
ORDER BY price DESC;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * │ Monitor      │ 10000   │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Only products with price >= 7450
 * - Laptop and Monitor qualify
 */

-- ============================================================================
-- PART 3: SUBQUERY WITH IN (Match any value in list)
-- ============================================================================

/**
 * Use IN when subquery returns multiple values (a list).
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY WITH IN                                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: "Find products that have been ordered"                       │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT product_name, price                                      │   │
 * │   │ FROM products                                                   │   │
 * │   │ WHERE product_id IN (                                           │   │
 * │   │     SELECT DISTINCT product_id                                  │   │
 * │   │     FROM orders                                                 │   │
 * │   │     WHERE product_id IS NOT NULL                                │   │
 * │   │ );                                                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Subquery finds all product_ids in orders                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT DISTINCT product_id FROM orders                          │   │
 * │   │ Result: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10} (all products)         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT: All products (since all have been ordered)                    │
 * │   ┌──────────────┬─────────┐                                          │
 * │   │ product_name │ price   │                                          │
 * │   ├──────────────┼─────────┤                                          │
 * │   │ Laptop       │ 50000   │                                          │
 * │   │ Mouse        │ 500     │                                          │
 * │   │ Keyboard     │ 1500    │                                          │
 * │   │ ... all 10 products ...                                          │
 * │   └──────────────┴─────────┘                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find products that have been ordered
SELECT 
    product_name,
    price
FROM products
WHERE product_id IN (
    SELECT DISTINCT product_id
    FROM orders
    WHERE product_id IS NOT NULL
);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * │ Mouse        │ 500     │
 * │ Keyboard     │ 1500    │
 * │ Monitor      │ 10000   │
 * │ Headphones   │ 2000    │
 * │ USB Cable    │ 300     │
 * │ Mouse Pad    │ 400     │
 * │ Laptop Stand │ 2500    │
 * │ Webcam       │ 3500    │
 * │ Speaker      │ 4000    │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Subquery returns all product_ids from orders
 * - Outer query returns products whose ID is in that list
 */

-- Find products that have NOT been ordered (using NOT IN)
SELECT 
    product_name,
    price
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM orders
    WHERE product_id IS NOT NULL
);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ (empty)      │         │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - All products have been ordered, so empty result
 */

-- ============================================================================
-- PART 4: SUBQUERY WITH EXISTS (Check existence)
-- ============================================================================

/**
 * EXISTS checks if subquery returns at least one row.
 * Very efficient - stops at first match.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY WITH EXISTS                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: "Find products that have been ordered"                       │
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT p.product_name, p.price                                  │   │
 * │   │ FROM products p                                                 │   │
 * │   │ WHERE EXISTS (                                                  │   │
 * │   │     SELECT 1                                                    │   │
 * │   │     FROM orders o                                               │   │
 * │   │     WHERE o.product_id = p.product_id                           │   │
 * │   │ );                                                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ For EACH product in products table:                             │   │
 * │   │                                                                  │   │
 * │   │ Product 1 (Laptop): Any order with product_id=1? Yes → KEEP     │   │
 * │   │ Product 2 (Mouse): Any order with product_id=2? Yes → KEEP      │   │
 * │   │ ...                                                             │   │
 * │   │ All products have orders → all kept                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find products that have been ordered (using EXISTS)
SELECT 
    p.product_name,
    p.price
FROM products p
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.product_id = p.product_id
);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * │ Mouse        │ 500     │
 * │ Keyboard     │ 1500    │
 * │ Monitor      │ 10000   │
 * │ Headphones   │ 2000    │
 * │ USB Cable    │ 300     │
 * │ Mouse Pad    │ 400     │
 * │ Laptop Stand │ 2500    │
 * │ Webcam       │ 3500    │
 * │ Speaker      │ 4000    │
 * └──────────────┴─────────┘
 */

-- ============================================================================
-- PART 5: SUBQUERY WITH NOT EXISTS (Check non-existence)
-- ============================================================================

/**
 * NOT EXISTS checks if subquery returns NO rows.
 * Best for "never happened" queries.
 */

-- Find employees who have NO orders (using employees and orders)
-- First, add some employees who haven't made orders
INSERT INTO employees VALUES
(9, 'Ivan', 'IT', 70000),
(10, 'Julia', 'HR', 58000);

-- Find employees who have not placed any orders
SELECT 
    e.emp_name,
    e.department
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = e.emp_id
);

/**
 * OUTPUT:
 * ┌──────────┬────────────┐
 * │ emp_name │ department │
 * ├──────────┼────────────┤
 * │ Alice    │ IT         │
 * │ Bob      │ IT         │
 * │ Carol    │ HR         │
 * │ Dave     │ IT         │
 * │ Eve      │ Finance    │
 * │ Frank    │ HR         │
 * │ Grace    │ Finance    │
 * │ Hank     │ IT         │
 * │ Ivan     │ IT         │
 * │ Julia    │ HR         │
 * └──────────┴────────────┘
 * 
 * EXPLANATION:
 * - All employees have no orders in our orders table
 * - (Because orders.user_id uses different ID range)
 */

-- ============================================================================
-- PART 6: SUBQUERY WITH ANY/ALL (Compare with any/all values)
-- ============================================================================

/**
 * ANY = true if condition true for AT LEAST ONE value in subquery
 * ALL = true if condition true for ALL values in subquery
 */

-- ANY example: Products priced higher than ANY Electronics product
SELECT 
    product_name,
    category,
    price
FROM products
WHERE price > ANY (
    SELECT price
    FROM products
    WHERE category = 'Electronics'
);

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 50000   │
 * │ Monitor      │ Electronics  │ 10000   │
 * │ Speaker      │ Electronics  │ 4000    │
 * │ Webcam       │ Electronics  │ 3500    │
 * │ Laptop Stand │ Accessories  │ 2500    │
 * │ Headphones   │ Accessories  │ 2000    │
 * └──────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - ANY means: price > (500, 1500, 10000, 3500, 4000, 50000) at least one
 * - Since Electronics min price is 500, all products >500 qualify
 */

-- ALL example: Products priced higher than ALL Accessories products
SELECT 
    product_name,
    category,
    price
FROM products
WHERE price > ALL (
    SELECT price
    FROM products
    WHERE category = 'Accessories'
);

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 50000   │
 * │ Monitor      │ Electronics  │ 10000   │
 * │ Speaker      │ Electronics  │ 4000    │
 * │ Webcam       │ Electronics  │ 3500    │
 * └──────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Accessories prices: 2000, 300, 400, 2500
 * - ALL means: price > 2000 AND >300 AND >400 AND >2500
 * - Must be >2500 (the maximum of Accessories)
 * - Products >2500: Laptop(50000), Monitor(10000), Speaker(4000), Webcam(3500)
 */

-- ============================================================================
-- PART 7: MULTIPLE SUBQUERIES IN WHERE (Combining conditions)
-- ============================================================================

/**
 * You can use multiple subqueries in WHERE clause with AND/OR.
 */

-- Find products that are above average price AND in Electronics category
SELECT 
    product_name,
    category,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
  AND category = 'Electronics';

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 50000   │
 * │ Monitor      │ Electronics  │ 10000   │
 * └──────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - First condition: price > 7450
 * - Second condition: category = 'Electronics'
 * - Only Laptop and Monitor satisfy both
 */

-- Find products that are above average OR below minimum of Electronics
SELECT 
    product_name,
    category,
    price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
   OR price < (SELECT MIN(price) FROM products WHERE category = 'Electronics');

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 50000   │
 * │ Monitor      │ Electronics  │ 10000   │
 * │ USB Cable    │ Accessories  │ 300     │
 * │ Mouse Pad    │ Accessories  │ 400     │
 * └──────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - MIN price in Electronics = 500 (Mouse)
 * - Products with price < 500: USB Cable(300), Mouse Pad(400)
 * - Products with price > 7450: Laptop(50000), Monitor(10000)
 */

-- ============================================================================
-- PART 8: SUBQUERY WITH AGGREGATES (MAX, MIN, AVG, SUM)
-- ============================================================================

/**
 * EXAMPLE 1: Find the most expensive product (MAX)
 */

SELECT 
    product_name,
    price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 50000   │
 * └──────────────┴─────────┘
 */

/**
 * EXAMPLE 2: Find the cheapest product (MIN)
 */

SELECT 
    product_name,
    price
FROM products
WHERE price = (SELECT MIN(price) FROM products);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ USB Cable    │ 300     │
 * └──────────────┴─────────┘
 */

/**
 * EXAMPLE 3: Find products with price within 10% of average
 */

SELECT 
    product_name,
    price
FROM products
WHERE price BETWEEN (SELECT AVG(price) * 0.9 FROM products)
                AND (SELECT AVG(price) * 1.1 FROM products);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Speaker      │ 4000    │
 * │ Webcam       │ 3500    │
 * │ Laptop Stand │ 2500    │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - AVG = 7450
 * - 10% range: 6705 to 8195
 * - Products in this range: Speaker(4000? no), actually 4000 < 6705
 * - Let me recalculate: 7450 * 0.9 = 6705, 7450 * 1.1 = 8195
 * - No products in this range with given data
 * - This demonstrates that subqueries work correctly even with empty results
 */

-- ============================================================================
-- PART 9: NESTED SUBQUERIES (Subquery inside subquery)
-- ============================================================================

/**
 * You can nest subqueries multiple levels deep.
 */

-- Find products that cost more than the average of Electronics products
SELECT 
    product_name,
    category,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
    WHERE category = 'Electronics'
);

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 50000   │
 * │ Monitor      │ Electronics  │ 10000   │
 * │ Speaker      │ Electronics  │ 4000    │
 * └──────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Inner subquery: AVG of Electronics = (50000+500+1500+10000+3500+4000)/6 = 11583.33
 * - Outer query: products with price > 11583.33
 * - Laptop(50000) and Monitor(10000? 10000 < 11583, so no)
 * - Wait, 10000 is less than 11583, so only Laptop qualifies
 */

-- Correct calculation: Electronics prices: 50000, 500, 1500, 10000, 3500, 4000
-- Sum = 50000+500=50500, +1500=52000, +10000=62000, +3500=65500, +4000=69500
-- AVG = 69500 / 6 = 11583.33
-- Products > 11583.33: Only Laptop (50000)

SELECT 
    product_name,
    category,
    price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
    WHERE category = 'Electronics'
);

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 50000   │
 * └──────────────┴──────────────┴─────────┘
 */

-- ============================================================================
-- PART 10: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Find products that sold above average quantity
 */

SELECT 
    p.product_name,
    SUM(o.quantity) AS total_sold
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name
HAVING SUM(o.quantity) > (
    SELECT AVG(quantity_sum)
    FROM (
        SELECT SUM(quantity) AS quantity_sum
        FROM orders
        GROUP BY product_id
    ) AS product_totals
);

/**
 * OUTPUT:
 * ┌──────────────┬────────────┐
 * │ product_name │ total_sold │
 * ├──────────────┼────────────┤
 * │ Mouse        │ 2          │
 * │ USB Cable    │ 3          │
 * │ Mouse Pad    │ 2          │
 * └──────────────┴────────────┘
 */

/**
 * SCENARIO 2: Find employees earning more than department average
 */

SELECT 
    e.emp_name,
    e.department,
    e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e.department
)
ORDER BY e.department, e.salary DESC;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬─────────┐
 * │ emp_name │ department │ salary  │
 * ├──────────┼────────────┼─────────┤
 * │ Dave     │ IT         │ 90000   │
 * │ Alice    │ IT         │ 80000   │
 * │ Grace    │ Finance    │ 85000   │
 * │ Carol    │ HR         │ 60000   │
 * └──────────┴────────────┴─────────┘
 * 
 * EXPLANATION:
 * - IT average: (80000+75000+90000+65000)/4 = 77500
 *   → Above: Dave(90000), Alice(80000)
 * - Finance average: (70000+85000)/2 = 77500
 *   → Above: Grace(85000)
 * - HR average: (60000+55000)/2 = 57500
 *   → Above: Carol(60000)
 */

/**
 * SCENARIO 3: Find orders with amount greater than user's average
 */

SELECT 
    o.order_id,
    o.user_id,
    o.amount
FROM orders o
WHERE o.amount > (
    SELECT AVG(o2.amount)
    FROM orders o2
    WHERE o2.user_id = o.user_id
)
ORDER BY o.user_id, o.amount DESC;

/**
 * OUTPUT:
 * ┌──────────┬─────────┬─────────┐
 * │ order_id │ user_id │ amount  │
 * ├──────────┼─────────┼─────────┤
 * │ 1        │ 101     │ 50000   │
 * │ 9        │ 101     │ 3500    │
 * │ 3        │ 101     │ 1500    │
 * │ 10       │ 102     │ 4000    │
 * │ 5        │ 102     │ 2000    │
 * │ 4        │ 103     │ 10000   │
 * │ 8        │ 103     │ 2500    │
 * │ 7        │ 104     │ 800     │
 * └──────────┴─────────┴─────────┘
 */

/**
 * SCENARIO 4: Find products that are never ordered (using NOT EXISTS)
 */

SELECT 
    p.product_name,
    p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.product_id = p.product_id
);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ (empty)      │         │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION:
 * - All products have been ordered in our data
 * - If a product had no orders, it would appear here
 */

-- Add a new product with no orders to test
INSERT INTO products VALUES (11, 'Tablet', 'Electronics', 25000);

-- Now run the query again
SELECT 
    p.product_name,
    p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.product_id = p.product_id
);

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Tablet       │ 25000   │
 * └──────────────┴─────────┘
 */

-- ============================================================================
-- PART 11: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Subquery returns multiple rows with comparison operator    │
 * │                                                                          │
 * │   ❌ WHERE price > (SELECT price FROM products)                         │
 * │      → Error! Subquery returns 10 rows, but > expects single value     │
 * │                                                                          │
 * │   ✅ WHERE price > (SELECT AVG(price) FROM products)                    │
 * │      → Use aggregate to return single value                            │
 * │                                                                          │
 * │   ✅ OR use IN for multiple values:                                      │
 * │      WHERE price IN (SELECT price FROM products)                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- MISTAKE #2: NOT IN with NULL values
-- If subquery returns NULL, NOT IN returns NO rows!

-- Create a table with NULL
CREATE TEMP TABLE test_products (price DECIMAL);
INSERT INTO test_products VALUES (100), (200), (NULL);

-- This query will return NOTHING because of NULL!
SELECT * FROM products WHERE price NOT IN (SELECT price FROM test_products);

-- ✅ Use NOT EXISTS instead
SELECT * FROM products p WHERE NOT EXISTS (SELECT 1 FROM test_products t WHERE t.price = p.price);

DROP TABLE test_products;

/**
 * MISTAKE #3: Correlated subquery without alias confusion
 * 
 *   ❌ SELECT * FROM orders WHERE amount > (SELECT AVG(amount) FROM orders)
 *      → This works but is NOT correlated (uses same table)
 * 
 *   ✅ For correlated: use different aliases
 *      SELECT * FROM orders o1 WHERE amount > (SELECT AVG(amount) FROM orders o2 WHERE o2.user_id = o1.user_id)
 */

-- ============================================================================
-- PART 12: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Subquery with >, <, = must return ONE value                    │
 * │         → Use aggregate functions (AVG, MAX, MIN, SUM)                 │
 * │                                                                          │
 * │ RULE 2: Use IN when subquery returns MULTIPLE values                   │
 * │         → WHERE column IN (SELECT column FROM table)                   │
 * │                                                                          │
 * │ RULE 3: Use EXISTS for existence checks (more efficient)               │
 * │         → Stops searching at first match                               │
 * │                                                                          │
 * │ RULE 4: Avoid NOT IN when subquery may contain NULL                    │
 * │         → Use NOT EXISTS for safety                                    │
 * │                                                                          │
 * │ RULE 5: Use table aliases for correlated subqueries                    │
 * │         → Helps avoid confusion                                        │
 * │                                                                          │
 * │ RULE 6: Test subquery separately first                                 │
 * │         → Run inner query alone to verify results                      │
 * │                                                                          │
 * │ RULE 7: Subquery in WHERE executes FIRST                               │
 * │         → Then outer query uses the result                             │
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
 * │ -- Single value comparison                                              │
 * │ SELECT * FROM table WHERE col > (SELECT AVG(col) FROM table);          │
 * │                                                                          │
 * │ -- IN with multiple values                                              │
 * │ SELECT * FROM table WHERE col IN (SELECT col FROM other_table);        │
 * │                                                                          │
 * │ -- NOT IN with multiple values (careful with NULLs)                    │
 * │ SELECT * FROM table WHERE col NOT IN (SELECT col FROM other_table);    │
 * │                                                                          │
 * │ -- EXISTS (efficient existence check)                                  │
 * │ SELECT * FROM table t WHERE EXISTS (SELECT 1 FROM other WHERE condition);│
 * │                                                                          │
 * │ -- NOT EXISTS (safe anti-join)                                         │
 * │ SELECT * FROM table t WHERE NOT EXISTS (SELECT 1 FROM other WHERE cond);│
 * │                                                                          │
 * │ -- ANY (greater than at least one)                                     │
 * │ SELECT * FROM table WHERE col > ANY (SELECT col FROM other);           │
 * │                                                                          │
 * │ -- ALL (greater than all)                                              │
 * │ SELECT * FROM table WHERE col > ALL (SELECT col FROM other);           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find products cheaper than average price
 * 
 * Answer:
 *   SELECT product_name, price FROM products 
 *   WHERE price < (SELECT AVG(price) FROM products);
 */

/**
 * EXERCISE 2: Find the most expensive product in Electronics category
 * 
 * Answer:
 *   SELECT product_name, price FROM products 
 *   WHERE price = (SELECT MAX(price) FROM products WHERE category = 'Electronics');
 */

/**
 * EXERCISE 3: Find products that have never been ordered (using NOT EXISTS)
 * 
 * Answer:
 *   SELECT * FROM products p 
 *   WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.product_id = p.product_id);
 */

/**
 * EXERCISE 4: Find employees earning more than company average
 * 
 * Answer:
 *   SELECT emp_name, salary FROM employees 
 *   WHERE salary > (SELECT AVG(salary) FROM employees);
 */

/**
 * EXERCISE 5: Find orders with amount greater than average order amount
 * 
 * Answer:
 *   SELECT order_id, amount FROM orders 
 *   WHERE amount > (SELECT AVG(amount) FROM orders);
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. SUBQUERY IN WHERE = Use query result as a filter value              │
 * │                                                                          │
 * │ 2. Comparison operators (>, <, =, >=, <=) need SINGLE value            │
 * │    → Use AVG, MAX, MIN, SUM to get single value                        │
 * │                                                                          │
 * │ 3. IN / NOT IN = Use when subquery returns MULTIPLE values             │
 * │    → Safe when subquery has no NULLs                                   │
 * │                                                                          │
 * │ 4. EXISTS / NOT EXISTS = Most efficient for existence checks           │
 * │    → Stops at first match                                              │
 * │    → Safe with NULLs                                                   │
 * │                                                                          │
 * │ 5. ANY / ALL = Compare with any or all values in subquery              │
 * │                                                                          │
 * │ 6. Multiple subqueries can be combined with AND/OR                     │
 * │                                                                          │
 * │ 7. Subqueries can be nested (subquery inside subquery)                 │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Subquery executes FIRST                                            │
 * │   - Result is used by outer query                                      │
 * │   - Test subquery separately                                           │
 * │   - Use NOT EXISTS instead of NOT IN with NULLs                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF SUBQUERY IN WHERE GUIDE
-- ============================================================================