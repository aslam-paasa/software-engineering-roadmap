/**
 * ============================================================================
 * SUBQUERY IN FROM - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS SUBQUERY IN FROM? -------------- (Subquery as a temporary table)
 * 2. BASIC SUBQUERY IN FROM ----------------- (Simple derived table)
 * 3. SUBQUERY WITH AGGREGATES --------------- (Pre-calculated values)
 * 4. SUBQUERY WITH JOINS -------------------- (Combining with other tables)
 * 5. NESTED SUBQUERIES IN FROM -------------- (Multiple levels)
 * 6. SUBQUERY IN FROM WITH WHERE ------------ (Filtering derived tables)
 * 7. SUBQUERY IN FROM WITH GROUP BY --------- (Grouping derived data)
 * 8. COMMON TABLE EXPRESSIONS (CTE) --------- (WITH clause alternative)
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
 * TABLE 1: USERS - Customer information
 */

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    age INT
);

/**
 * TABLE 2: ORDERS - Purchase records
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_name VARCHAR(50),
    amount DECIMAL(10,2),
    order_date DATE
);

/**
 * TABLE 3: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * USERS TABLE
 * ┌─────────┬───────────┬─────────┬──────────────┬─────┐
 * │ user_id │ name      │ country │ city         │ age │
 * ├─────────┼───────────┼─────────┼──────────────┼─────┤
 * │ 1       │ Ayaan     │ India   │ Mumbai       │ 25  │
 * │ 2       │ Sneha     │ India   │ Delhi        │ 30  │
 * │ 3       │ Rohit     │ India   │ Bangalore    │ 22  │
 * │ 4       │ John      │ USA     │ New York     │ 35  │
 * │ 5       │ Sarah     │ USA     │ Los Angeles  │ 28  │
 * │ 6       │ David     │ UK      │ London       │ 40  │
 * │ 7       │ Priya     │ India   │ Chennai      │ 26  │
 * │ 8       │ Michael   │ USA     │ Chicago      │ 32  │
 * └─────────┴───────────┴─────────┴──────────────┴─────┘
 */

INSERT INTO users VALUES
(1, 'Ayaan', 'India', 'Mumbai', 25),
(2, 'Sneha', 'India', 'Delhi', 30),
(3, 'Rohit', 'India', 'Bangalore', 22),
(4, 'John', 'USA', 'New York', 35),
(5, 'Sarah', 'USA', 'Los Angeles', 28),
(6, 'David', 'UK', 'London', 40),
(7, 'Priya', 'India', 'Chennai', 26),
(8, 'Michael', 'USA', 'Chicago', 32);

/**
 * ORDERS TABLE
 * ┌──────────┬─────────┬──────────────┬─────────┬────────────┐
 * │ order_id │ user_id │ product_name │ amount  │ order_date │
 * ├──────────┼─────────┼──────────────┼─────────┼────────────┤
 * │ 101      │ 1       │ Laptop       │ 50000   │ 2024-01-10 │
 * │ 102      │ 1       │ Mouse        │ 500     │ 2024-01-11 │
 * │ 103      │ 2       │ Keyboard     │ 1500    │ 2024-01-12 │
 * │ 104      │ 4       │ Monitor      │ 10000   │ 2024-01-13 │
 * │ 105      │ 5       │ Headphones   │ 2000    │ 2024-01-14 │
 * │ 106      │ 4       │ USB Cable    │ 300     │ 2024-01-15 │
 * │ 107      │ 7       │ Mouse Pad    │ 400     │ 2024-01-16 │
 * │ 108      │ 8       │ Laptop Stand │ 2500    │ 2024-01-17 │
 * │ 109      │ 3       │ Webcam       │ 3500    │ 2024-01-18 │
 * │ 110      │ 5       │ Speaker      │ 4000    │ 2024-01-19 │
 * └──────────┴─────────┴──────────────┴─────────┴────────────┘
 */

INSERT INTO orders VALUES
(101, 1, 'Laptop', 50000, '2024-01-10'),
(102, 1, 'Mouse', 500, '2024-01-11'),
(103, 2, 'Keyboard', 1500, '2024-01-12'),
(104, 4, 'Monitor', 10000, '2024-01-13'),
(105, 5, 'Headphones', 2000, '2024-01-14'),
(106, 4, 'USB Cable', 300, '2024-01-15'),
(107, 7, 'Mouse Pad', 400, '2024-01-16'),
(108, 8, 'Laptop Stand', 2500, '2024-01-17'),
(109, 3, 'Webcam', 3500, '2024-01-18'),
(110, 5, 'Speaker', 4000, '2024-01-19');

/**
 * PRODUCTS TABLE
 * ┌────────────┬──────────────┬──────────────┬─────────┐
 * │ product_id │ product_name │ category     │ price   │
 * ├────────────┼──────────────┼──────────────┼─────────┤
 * │ 1          │ Laptop       │ Electronics  │ 50000   │
 * │ 2          │ Mouse        │ Electronics  │ 500     │
 * │ 3          │ Keyboard     │ Electronics  │ 1500    │
 * │ 4          │ Monitor      │ Electronics  │ 10000   │
 * │ 5          │ Headphones   │ Accessories  │ 2000    │
 * │ 6          │ USB Cable    │ Accessories  │ 300     │
 * │ 7          │ Mouse Pad    │ Accessories  │ 400     │
 * └────────────┴──────────────┴──────────────┴─────────┘
 */

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 50000),
(2, 'Mouse', 'Electronics', 500),
(3, 'Keyboard', 'Electronics', 1500),
(4, 'Monitor', 'Electronics', 10000),
(5, 'Headphones', 'Accessories', 2000),
(6, 'USB Cable', 'Accessories', 300),
(7, 'Mouse Pad', 'Accessories', 400);

-- ============================================================================
-- PART 1: WHAT IS SUBQUERY IN FROM?
-- ============================================================================

/**
 * Subquery in FROM treats the result of a SELECT as a "temporary table".
 * This is also called a "derived table".
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY IN FROM - SIMPLE EXAMPLE                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   THE PROBLEM: "Count how many users are from USA"                     │
 * │                                                                          │
 * │   STEP 1: Create a subquery that selects USA users                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT * FROM users WHERE country = 'USA'                       │   │
 * │   │                                                                  │   │
 * │   │ Result (temporary table):                                       │   │
 * │   │ ┌─────────┬─────────┬─────────┬──────────────┬─────┐            │   │
 * │   │ │ user_id │ name    │ country │ city         │ age │            │   │
 * │   │ ├─────────┼─────────┼─────────┼──────────────┼─────┤            │   │
 * │   │ │ 4       │ John    │ USA     │ New York     │ 35  │            │   │
 * │   │ │ 5       │ Sarah   │ USA     │ Los Angeles  │ 28  │            │   │
 * │   │ │ 8       │ Michael │ USA     │ Chicago      │ 32  │            │   │
 * │   │ └─────────┴─────────┴─────────┴──────────────┴─────┘            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Outer query counts rows in this temporary table               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT COUNT(*) FROM (SELECT * FROM users WHERE country='USA')  │   │
 * │   │                         AS usa_users                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┐                                                         │
 * │   │ count   │                                                         │
 * │   ├─────────┤                                                         │
 * │   │ 3       │                                                         │
 * │   └─────────┘                                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Basic example: Count USA users using subquery in FROM
SELECT COUNT(*) AS usa_user_count
FROM (
    SELECT * 
    FROM users 
    WHERE country = 'USA'
) AS usa_users;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ usa_user_count  │
 * ├─────────────────┤
 * │ 3               │
 * └─────────────────┘
 * 
 * EXPLANATION:
 * - Subquery creates a temporary table with only USA users
 * - Outer query counts rows in that temporary table
 * - Must give the subquery an alias (usa_users)
 */

-- ============================================================================
-- PART 2: BASIC SUBQUERY IN FROM (Simple derived table)
-- ============================================================================

/**
 * EXAMPLE 1: Get user details and rename columns
 */

SELECT 
    user_id,
    full_name,
    user_country,
    user_age
FROM (
    SELECT 
        user_id,
        name AS full_name,
        country AS user_country,
        age AS user_age
    FROM users
    WHERE age >= 25
) AS adult_users
ORDER BY user_age DESC;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬─────────────┬──────────┐
 * │ user_id │ full_name │ user_country │ user_age │
 * ├─────────┼───────────┼─────────────┼──────────┤
 * │ 6       │ David     │ UK          │ 40       │
 * │ 4       │ John      │ USA         │ 35       │
 * │ 8       │ Michael   │ USA         │ 32       │
 * │ 2       │ Sneha     │ India       │ 30       │
 * │ 5       │ Sarah     │ USA         │ 28       │
 * │ 7       │ Priya     │ India       │ 26       │
 * │ 1       │ Ayaan     │ India       │ 25       │
 * └─────────┴───────────┴─────────────┴──────────┘
 * 
 * EXPLANATION:
 * - Subquery filters to users age >= 25 and renames columns
 * - Outer query selects from this derived table
 */

/**
 * EXAMPLE 2: Get users from India only
 */

SELECT *
FROM (
    SELECT user_id, name, city, age
    FROM users
    WHERE country = 'India'
) AS indian_users
ORDER BY age;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬────────────┬─────┐
 * │ user_id │ name      │ city       │ age │
 * ├─────────┼───────────┼────────────┼─────┤
 * │ 3       │ Rohit     │ Bangalore  │ 22  │
 * │ 1       │ Ayaan     │ Mumbai     │ 25  │
 * │ 7       │ Priya     │ Chennai    │ 26  │
 * │ 2       │ Sneha     │ Delhi      │ 30  │
 * └─────────┴───────────┴────────────┴─────┘
 */

-- ============================================================================
-- PART 3: SUBQUERY WITH AGGREGATES (Pre-calculated values)
-- ============================================================================

/**
 * Use subquery in FROM to pre-calculate aggregates for each group.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY WITH AGGREGATES                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: "Find users who spent more than average"                     │
 * │                                                                          │
 * │   STEP 1: Subquery calculates total spent per user                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT user_id, SUM(amount) AS total_spent                      │   │
 * │   │ FROM orders                                                     │   │
 * │   │ GROUP BY user_id                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Outer query calculates overall average and filters           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT user_id, total_spent                                     │   │
 * │   │ FROM (user_totals)                                              │   │
 * │   │ WHERE total_spent > (SELECT AVG(total_spent) FROM user_totals)  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Find users who spent more than average
SELECT 
    user_id,
    total_spent
FROM (
    SELECT 
        user_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY user_id
) AS user_totals
WHERE total_spent > (
    SELECT AVG(total_spent) 
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM orders
        GROUP BY user_id
    ) AS avg_calc
)
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ user_id │ total_spent │
 * ├─────────┼─────────────┤
 * │ 1       │ 50500.00    │
 * │ 4       │ 10300.00    │
 * │ 5       │ 6000.00     │
 * └─────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Subquery calculates total_spent per user
 * - Outer query calculates average of totals
 * - Filters to users above average
 */

-- Simplified version using CTE (Common Table Expression)
WITH user_totals AS (
    SELECT user_id, SUM(amount) AS total_spent
    FROM orders
    GROUP BY user_id
)
SELECT user_id, total_spent
FROM user_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM user_totals)
ORDER BY total_spent DESC;

-- ============================================================================
-- PART 4: SUBQUERY WITH JOINS (Combining with other tables)
-- ============================================================================

/**
 * You can join a derived table with other tables.
 */

-- Find users who have spent more than ₹5000, with their details
SELECT 
    u.name,
    u.country,
    u.city,
    spending.total_spent
FROM users u
INNER JOIN (
    SELECT 
        user_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY user_id
) AS spending ON u.user_id = spending.user_id
WHERE spending.total_spent > 5000
ORDER BY spending.total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬──────────────┬─────────────┐
 * │ name    │ country │ city         │ total_spent │
 * ├─────────┼─────────┼──────────────┼─────────────┤
 * │ Ayaan   │ India   │ Mumbai       │ 50500.00    │
 * │ John    │ USA     │ New York     │ 10300.00    │
 * │ Sarah   │ USA     │ Los Angeles  │ 6000.00     │
 * └─────────┴─────────┴──────────────┴─────────────┘
 */

-- ============================================================================
-- PART 5: NESTED SUBQUERIES IN FROM (Multiple levels)
-- ============================================================================

/**
 * You can nest subqueries multiple levels deep.
 */

-- Find average spending of top spending users
SELECT 
    ROUND(AVG(total_spent), 2) AS avg_top_spenders
FROM (
    SELECT 
        user_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY user_id
    ORDER BY total_spent DESC
    LIMIT 3
) AS top_spenders;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ avg_top_spenders │
 * ├──────────────────┤
 * │ 22266.67         │
 * └──────────────────┘
 * 
 * EXPLANATION:
 * - Innermost subquery: calculates total per user
 * - Middle subquery: takes top 3 spenders
 * - Outer query: calculates average of those top 3
 */

-- ============================================================================
-- PART 6: SUBQUERY IN FROM WITH WHERE (Filtering derived tables)
-- ============================================================================

/**
 * You can filter the derived table using WHERE clause.
 */

-- Find Indian users who are above average age of Indians
SELECT 
    name,
    age,
    city
FROM (
    SELECT 
        name,
        age,
        city,
        (SELECT AVG(age) FROM users WHERE country = 'India') AS india_avg_age
    FROM users
    WHERE country = 'India'
) AS indian_users
WHERE age > india_avg_age
ORDER BY age DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────┬─────────┐
 * │ name    │ age │ city    │
 * ├─────────┼─────┼─────────┤
 * │ Sneha   │ 30  │ Delhi   │
 * │ Priya   │ 26  │ Chennai │
 * └─────────┴─────┴─────────┘
 * 
 * EXPLANATION:
 * - Average age of Indians = (25+30+22+26)/4 = 25.75
 * - Users above this average: Sneha(30), Priya(26)
 */

-- ============================================================================
-- PART 7: SUBQUERY IN FROM WITH GROUP BY (Grouping derived data)
-- ============================================================================

/**
 * You can group data in the derived table, then group again in outer query.
 */

-- Find average order value by country (using two levels of grouping)
SELECT 
    country,
    ROUND(AVG(avg_order_value), 2) AS country_avg_order_value
FROM (
    SELECT 
        u.country,
        o.user_id,
        AVG(o.amount) AS avg_order_value
    FROM orders o
    JOIN users u ON o.user_id = u.user_id
    GROUP BY u.country, o.user_id
) AS user_averages
GROUP BY country
ORDER BY country_avg_order_value DESC;

/**
 * OUTPUT:
 * ┌─────────┬────────────────────────┐
 * │ country │ country_avg_order_value │
 * ├─────────┼────────────────────────┤
 * │ India   │ 13833.33               │
 * │ USA     │ 6166.67                │
 * │ UK      │ NULL                   │
 * └─────────┴────────────────────────┘
 * 
 * EXPLANATION:
 * - Inner subquery: average order value per user
 * - Outer query: average of those averages per country
 */

-- ============================================================================
-- PART 8: COMMON TABLE EXPRESSIONS (CTE) - WITH clause
-- ============================================================================

/**
 * CTE is a cleaner way to write subqueries in FROM.
 * More readable, especially for complex queries.
 */

-- Using CTE instead of subquery in FROM
WITH usa_users AS (
    SELECT * 
    FROM users 
    WHERE country = 'USA'
)
SELECT COUNT(*) AS usa_count
FROM usa_users;

/**
 * OUTPUT:
 * ┌───────────┐
 * │ usa_count │
 * ├───────────┤
 * │ 3         │
 * └───────────┘
 */

-- Multiple CTEs in one query
WITH 
indian_users AS (
    SELECT user_id, name, age
    FROM users
    WHERE country = 'India'
),
user_orders AS (
    SELECT user_id, COUNT(*) AS order_count, SUM(amount) AS total_spent
    FROM orders
    GROUP BY user_id
)
SELECT 
    i.name,
    i.age,
    COALESCE(uo.order_count, 0) AS order_count,
    COALESCE(uo.total_spent, 0) AS total_spent
FROM indian_users i
LEFT JOIN user_orders uo ON i.user_id = uo.user_id
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────┬─────────────┬─────────────┐
 * │ name    │ age │ order_count │ total_spent │
 * ├─────────┼─────┼─────────────┼─────────────┤
 * │ Ayaan   │ 25  │ 2           │ 50500.00    │
 * │ Sneha   │ 30  │ 1           │ 1500.00     │
 * │ Priya   │ 26  │ 1           │ 400.00      │
 * │ Rohit   │ 22  │ 1           │ 3500.00     │
 * └─────────┴─────┴─────────────┴─────────────┘
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Customer Segmentation
 * 
 * Segment customers based on their total spending
 */

SELECT 
    name,
    total_spent,
    CASE 
        WHEN total_spent > 10000 THEN 'Premium'
        WHEN total_spent > 2000 THEN 'Regular'
        ELSE 'Basic'
    END AS customer_segment
FROM (
    SELECT 
        u.name,
        COALESCE(SUM(o.amount), 0) AS total_spent
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.name
) AS customer_spending
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬──────────────────┐
 * │ name    │ total_spent │ customer_segment │
 * ├─────────┼─────────────┼──────────────────┤
 * │ Ayaan   │ 50500.00    │ Premium          │
 * │ John    │ 10300.00    │ Premium          │
 * │ Sarah   │ 6000.00     │ Regular          │
 * │ Rohit   │ 3500.00     │ Regular          │
 * │ Sneha   │ 1500.00     │ Basic            │
 * │ Priya   │ 400.00      │ Basic            │
 * │ David   │ 0.00        │ Basic            │
 * │ Michael │ 0.00        │ Basic            │
 * └─────────┴─────────────┴──────────────────┘
 */

/**
 * SCENARIO 2: Department Performance Report
 * 
 * Calculate average salary by department, then find departments above average
 */

-- First, add department and salary to users for this example
ALTER TABLE users ADD COLUMN department VARCHAR(30);
ALTER TABLE users ADD COLUMN salary DECIMAL(10,2);

UPDATE users SET 
    department = CASE user_id
        WHEN 1 THEN 'IT'
        WHEN 2 THEN 'HR'
        WHEN 3 THEN 'IT'
        WHEN 4 THEN 'Finance'
        WHEN 5 THEN 'Marketing'
        WHEN 6 THEN 'IT'
        WHEN 7 THEN 'HR'
        WHEN 8 THEN 'Finance'
    END,
    salary = CASE user_id
        WHEN 1 THEN 80000
        WHEN 2 THEN 60000
        WHEN 3 THEN 75000
        WHEN 4 THEN 90000
        WHEN 5 THEN 65000
        WHEN 6 THEN 85000
        WHEN 7 THEN 55000
        WHEN 8 THEN 70000
    END;

-- Find departments with above-average salary
SELECT 
    department,
    avg_salary,
    employee_count
FROM (
    SELECT 
        department,
        AVG(salary) AS avg_salary,
        COUNT(*) AS employee_count
    FROM users
    WHERE department IS NOT NULL
    GROUP BY department
) AS dept_stats
WHERE avg_salary > (
    SELECT AVG(salary) 
    FROM users 
    WHERE department IS NOT NULL
)
ORDER BY avg_salary DESC;

/**
 * OUTPUT:
 * ┌────────────┬────────────┬─────────────────┐
 * │ department │ avg_salary │ employee_count  │
 * ├────────────┼────────────┼─────────────────┤
 * │ Finance    │ 80000.00   │ 2               │
 * │ IT         │ 80000.00   │ 3               │
 * └────────────┴────────────┴─────────────────┘
 */

-- Clean up added columns
ALTER TABLE users DROP COLUMN department;
ALTER TABLE users DROP COLUMN salary;

/**
 * SCENARIO 3: Top Products by Category
 * 
 * Find the most expensive product in each category
 */

SELECT 
    category,
    product_name,
    price
FROM (
    SELECT 
        category,
        product_name,
        price,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS rn
    FROM products
) AS ranked_products
WHERE rn = 1
ORDER BY price DESC;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ category     │ product_name │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Electronics  │ Laptop       │ 50000   │
 * │ Accessories  │ Headphones   │ 2000    │
 * └──────────────┴──────────────┴─────────┘
 */

/**
 * SCENARIO 4: Monthly Sales Summary
 * 
 * Get monthly sales with running total
 */

SELECT 
    order_month,
    monthly_sales,
    SUM(monthly_sales) OVER (ORDER BY order_month) AS running_total
FROM (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS order_month,
        SUM(amount) AS monthly_sales
    FROM orders
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
) AS monthly_summary
ORDER BY order_month;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┬───────────────┐
 * │ order_month │ monthly_sales │ running_total │
 * ├─────────────┼───────────────┼───────────────┤
 * │ 2024-01     │ 74600.00      │ 74600.00      │
 * └─────────────┴───────────────┴───────────────┘
 */

/**
 * SCENARIO 5: User Activity Summary
 * 
 * Get user order summary with percentage of total
 */

SELECT 
    name,
    total_spent,
    ROUND(100.0 * total_spent / SUM(total_spent) OVER (), 2) AS percentage_of_total
FROM (
    SELECT 
        u.name,
        COALESCE(SUM(o.amount), 0) AS total_spent
    FROM users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.user_id, u.name
) AS user_spending
WHERE total_spent > 0
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬─────────────────────┐
 * │ name    │ total_spent │ percentage_of_total │
 * ├─────────┼─────────────┼─────────────────────┤
 * │ Ayaan   │ 50500.00    │ 67.69               │
 * │ John    │ 10300.00    │ 13.81               │
 * │ Sarah   │ 6000.00     │ 8.04                │
 * │ Rohit   │ 3500.00     │ 4.69                │
 * │ Sneha   │ 1500.00     │ 2.01                │
 * │ Priya   │ 400.00      │ 0.54                │
 * └─────────┴─────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting alias for derived table                         │
 * │                                                                          │
 * │   ❌ SELECT * FROM (SELECT * FROM users)                               │
 * │      → Error! Every derived table must have an alias                   │
 * │                                                                          │
 * │   ✅ SELECT * FROM (SELECT * FROM users) AS temp                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ This will cause an error
-- SELECT * FROM (SELECT * FROM users);

-- ✅ Correct
SELECT * FROM (SELECT * FROM users) AS temp_users;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Column name ambiguity                                      │
 * │                                                                          │
 * │   ❌ SELECT user_id FROM (SELECT user_id, name FROM users)             │
 * │      → Might be ambiguous if multiple columns have same name           │
 * │                                                                          │
 * │   ✅ Use aliases to clarify:                                            │
 * │      SELECT t.user_id FROM (SELECT user_id, name FROM users) AS t      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Ambiguous if derived table has same column names
-- ✅ Use alias
SELECT t.user_id, t.name 
FROM (SELECT user_id, name FROM users) AS t;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Unnecessary subquery (can be simplified)                   │
 * │                                                                          │
 * │   ❌ SELECT * FROM (SELECT * FROM users WHERE country = 'USA') AS u    │
 * │                                                                          │
 * │   ✅ SELECT * FROM users WHERE country = 'USA'                         │
 * │                                                                          │
 * │   Only use subquery in FROM when you need to:                          │
 * │   - Aggregate first, then filter                                       │
 * │   - Join a query result with another table                             │
 * │   - Use window functions                                               │
 * │   - Rename columns                                                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Unnecessary (can be simplified)
SELECT * FROM (SELECT * FROM users WHERE country = 'USA') AS u;

-- Simplified
SELECT * FROM users WHERE country = 'USA';

-- ============================================================================
-- PART 11: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: ALWAYS give derived table an alias                             │
 * │         → SELECT * FROM (SELECT ...) AS alias                          │
 * │         → Without alias, query will fail                               │
 * │                                                                          │
 * │ RULE 2: Use subquery in FROM when you need to:                         │
 * │         → Pre-calculate aggregates before filtering                    │
 * │         → Join a summarized result with another table                  │
 * │         → Use window functions results in WHERE clause                 │
 * │         → Rename columns or transform data                             │
 * │                                                                          │
 * │ RULE 3: For simple filtering, use WHERE instead                        │
 * │         → SELECT * FROM users WHERE country='USA' is better            │
 * │         → Than SELECT * FROM (SELECT * FROM users) AS t WHERE...       │
 * │                                                                          │
 * │ RULE 4: Use CTE (WITH clause) for better readability                   │
 * │         → Especially for multiple or complex subqueries                │
 * │                                                                          │
 * │ RULE 5: Subquery in FROM executes FIRST                                │
 * │         → Then outer query uses the result                             │
 * │         → Can be nested multiple levels                                │
 * │                                                                          │
 * │ RULE 6: Column names from subquery are available in outer query        │
 * │         → Use AS to rename columns if needed                           │
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
 * │ -- Basic subquery in FROM                                               │
 * │ SELECT * FROM (SELECT * FROM table WHERE condition) AS alias;          │
 * │                                                                          │
 * │ -- Subquery with aggregation                                            │
 * │ SELECT AVG(calculated) FROM (                                           │
 * │     SELECT SUM(amount) AS calculated FROM orders GROUP BY user_id      │
 * │ ) AS totals;                                                            │
 * │                                                                          │
 * │ -- Subquery with JOIN                                                   │
 * │ SELECT * FROM table1 t1                                                 │
 * │ JOIN (SELECT * FROM table2 WHERE condition) AS t2 ON t1.id = t2.id;    │
 * │                                                                          │
 * │ -- Using CTE instead (cleaner)                                          │
 * │ WITH temp AS (SELECT * FROM table WHERE condition)                      │
 * │ SELECT * FROM temp;                                                     │
 * │                                                                          │
 * │ -- Multiple CTEs                                                        │
 * │ WITH                                                                    │
 * │   cte1 AS (SELECT ...),                                                 │
 * │   cte2 AS (SELECT ...)                                                  │
 * │ SELECT * FROM cte1 JOIN cte2 ON ...;                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Count number of users from India using subquery in FROM
 * 
 * Answer:
 *   SELECT COUNT(*) FROM (SELECT * FROM users WHERE country = 'India') AS indian_users;
 */

/**
 * EXERCISE 2: Get average age of users from USA using subquery in FROM
 * 
 * Answer:
 *   SELECT AVG(age) FROM (SELECT age FROM users WHERE country = 'USA') AS usa_ages;
 */

/**
 * EXERCISE 3: Find users who have placed more than 1 order
 * 
 * Answer:
 *   SELECT u.name, o.order_count
 *   FROM users u
 *   JOIN (SELECT user_id, COUNT(*) AS order_count FROM orders GROUP BY user_id) AS o
 *   ON u.user_id = o.user_id
 *   WHERE o.order_count > 1;
 */

/**
 * EXERCISE 4: Calculate average order value per user, then overall average
 * 
 * Answer:
 *   SELECT AVG(avg_order_value) FROM (
 *       SELECT AVG(amount) AS avg_order_value FROM orders GROUP BY user_id
 *   ) AS user_averages;
 */

/**
 * EXERCISE 5: Find the second highest order amount
 * 
 * Answer:
 *   SELECT MIN(amount) FROM (
 *       SELECT DISTINCT amount FROM orders ORDER BY amount DESC LIMIT 2
 *   ) AS top_two;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. SUBQUERY IN FROM = Treats SELECT result as a temporary table        │
 * │    → Also called "derived table"                                       │
 * │                                                                          │
 * │ 2. MUST give alias to derived table                                    │
 * │    → SELECT * FROM (SELECT ...) AS alias                               │
 * │                                                                          │
 * │ 3. Best used when:                                                      │
 * │    → You need to pre-calculate aggregates before filtering             │
 * │    → You want to join a summarized result                              │
 * │    → You need to use window function results in WHERE                  │
 * │    → You want to rename or transform columns                           │
 * │                                                                          │
 * │ 4. CTE (WITH clause) is often cleaner                                  │
 * │    → More readable for complex queries                                 │
 * │    → Can be reused multiple times                                      │
 * │                                                                          │
 * │ 5. Execution order:                                                     │
 * │    → Subquery executes FIRST                                           │
 * │    → Creates temporary result set                                      │
 * │    → Outer query uses that result                                      │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always use alias                                                   │
 * │   - Use CTE for readability                                            │
 * │   - Don't overuse (simple WHERE is better)                             │
 * │   - Can nest multiple levels                                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF SUBQUERY IN FROM GUIDE
-- ============================================================================