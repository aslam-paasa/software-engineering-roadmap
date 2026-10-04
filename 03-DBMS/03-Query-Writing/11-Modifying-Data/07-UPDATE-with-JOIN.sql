/**
 * ============================================================================
 * UPDATE with JOIN - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS UPDATE with JOIN? ---------------- (Update using another table)
 * 2. UPDATE with INNER JOIN ------------------- (Update matching rows only)
 * 3. UPDATE with LEFT JOIN -------------------- (Update all from one table)
 * 4. UPDATE with Multiple JOINs --------------- (Join multiple tables)
 * 5. UPDATE with JOIN and WHERE --------------- (Additional filtering)
 * 6. UPDATE with JOIN and Aggregate ----------- (Use SUM, COUNT, AVG)
 * 7. UPDATE with JOIN and CASE ---------------- (Conditional updates)
 * 8. UPDATE with JOIN and Subquery ------------ (Alternative syntax)
 * 9. REAL-WORLD SCENARIOS --------------------- (Practical examples)
 * 10. PostgreSQL vs MySQL Syntax -------------- (Important differences)
 * 11. COMMON MISTAKES ------------------------- (What to avoid)
 * 12. GOLDEN RULES ---------------------------- (Key principles)
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
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    total_spent DECIMAL(10,2) DEFAULT 0,
    loyalty_points INT DEFAULT 0,
    last_order_date DATE
);

/**
 * TABLE 2: ORDERS - Order information
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

/**
 * TABLE 3: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT,
    category VARCHAR(50)
);

/**
 * TABLE 4: ORDER_ITEMS - Items in each order
 */

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2)
);

/**
 * TABLE 5: PRICE_UPDATES - Bulk price update data
 */

CREATE TABLE price_updates (
    product_id INT,
    new_price DECIMAL(10,2),
    discount_percent INT
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert customers
INSERT INTO customers (name, email, city, total_spent, loyalty_points, last_order_date) VALUES
('Ayaan', 'ayaan@email.com', 'Mumbai', 50000, 500, '2024-01-15'),
('Sneha', 'sneha@email.com', 'Delhi', 3000, 30, '2024-01-20'),
('Rohit', 'rohit@email.com', 'Bangalore', 2000, 20, '2024-01-25'),
('Priya', 'priya@email.com', 'Chennai', 10000, 100, '2024-02-01'),
('Neha', 'neha@email.com', 'Pune', 3500, 35, '2024-02-05'),
('Amit', 'amit@email.com', 'Mumbai', 8000, 80, '2024-02-10'),
('Kavya', 'kavya@email.com', 'Delhi', 1200, 12, '2024-02-15');

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-01-15', 50000, 'DELIVERED'),
(2, '2024-01-20', 1500, 'DELIVERED'),
(3, '2024-01-25', 2000, 'PENDING'),
(4, '2024-02-01', 10000, 'DELIVERED'),
(5, '2024-02-05', 3500, 'PENDING'),
(1, '2024-02-10', 8000, 'DELIVERED'),
(6, '2024-02-10', 8000, 'DELIVERED'),
(7, '2024-02-15', 1200, 'PROCESSING');

-- Insert products
INSERT INTO products (product_name, price, stock_quantity, category) VALUES
('Laptop', 50000, 10, 'Electronics'),
('Mouse', 500, 50, 'Electronics'),
('Keyboard', 1500, 30, 'Electronics'),
('Monitor', 10000, 5, 'Electronics'),
('Headphones', 2000, 20, 'Accessories'),
('USB Cable', 300, 100, 'Accessories'),
('Laptop Stand', 2500, 15, 'Accessories'),
('Webcam', 3500, 8, 'Electronics');

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 50000),
(2, 3, 1, 1500),
(3, 2, 4, 500),
(4, 4, 1, 10000),
(5, 5, 1, 2000),
(6, 1, 1, 50000),
(6, 5, 1, 2000),
(7, 6, 10, 300),
(8, 7, 1, 2500);

-- Insert price updates
INSERT INTO price_updates (product_id, new_price, discount_percent) VALUES
(1, 45000, 10),
(4, 9000, 10),
(5, 1800, 10);

-- ============================================================================
-- PART 1: WHAT IS UPDATE with JOIN?
-- ============================================================================

/**
 * UPDATE with JOIN allows you to update a table using values from another table.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE with JOIN - EXPLANATION                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   POSTGRESQL SYNTAX (UPDATE...FROM):                                  │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE table_to_update                                          │   │
 * │   │ SET column = other_table.column                                 │   │
 * │   │ FROM other_table                                                │   │
 * │   │ WHERE table_to_update.key = other_table.key;                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY USE UPDATE with JOIN?                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Update multiple rows based on data in another table         │   │
 * │   │ 2. Calculate values from related records (SUM, COUNT, AVG)     │   │
 * │   │ 3. Bulk update prices using a price list table                  │   │
 * │   │ 4. Update customer totals based on their orders                 │   │
 * │   │ 5. Synchronize data between related tables                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE with JOIN - EXAMPLE                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE:                                                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ customers table                 price_updates table             │   │
 * │   │ ┌─────────────┬─────────────┐   ┌────────────┬─────────────┐   │   │
 * │   │ │ customer_id │ total_spent │   │ product_id │ new_price    │   │   │
 * │   │ ├─────────────┼─────────────┤   ├────────────┼─────────────┤   │   │
 * │   │ │ 1           │ 50000       │   │ 1          │ 45000       │   │   │
 * │   │ │ 2           │ 3000        │   │ 4          │ 9000        │   │   │
 * │   │ │ 3           │ 2000        │   └────────────┴─────────────┘   │   │
 * │   │ └─────────────┴─────────────┘                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   UPDATE COMMAND: Update customer totals based on orders               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE customers                                                │   │
 * │   │ SET total_spent = orders.total_amount                          │   │
 * │   │ FROM orders                                                     │   │
 * │   │ WHERE customers.customer_id = orders.customer_id;              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER: Customer totals updated from latest order                     │
 * │   ┌─────────────┬─────────────┐                                       │
 * │   │ customer_id │ total_spent │                                       │
 * │   ├─────────────┼─────────────┤                                       │
 * │   │ 1           │ 8000        │ ← updated from order 6                │
 * │   │ 2           │ 1500        │ ← updated from order 2                │
 * │   │ 3           │ 2000        │ ← updated from order 3                │
 * │   └─────────────┴─────────────┘                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: UPDATE with INNER JOIN (Update matching rows only)
-- ============================================================================

/**
 * Update only rows that have matching records in the other table.
 */

-- Show current data
SELECT customer_id, name, total_spent FROM customers ORDER BY customer_id;

/**
 * CURRENT DATA:
 * ┌─────────────┬─────────┬─────────────┐
 * │ customer_id │ name    │ total_spent │
 * ├─────────────┼─────────┼─────────────┤
 * │ 1           │ Ayaan   │ 50000.00    │
 * │ 2           │ Sneha   │ 3000.00     │
 * │ 3           │ Rohit   │ 2000.00     │
 * │ 4           │ Priya   │ 10000.00    │
 * │ 5           │ Neha    │ 3500.00     │
 * │ 6           │ Amit    │ 8000.00     │
 * │ 7           │ Kavya   │ 1200.00     │
 * └─────────────┴─────────┴─────────────┘
 */

-- EXAMPLE 1: Update customer total_spent from their latest order
UPDATE customers 
SET total_spent = orders.total_amount
FROM orders 
WHERE customers.customer_id = orders.customer_id;

SELECT customer_id, name, total_spent FROM customers ORDER BY customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────┐
 * │ customer_id │ name    │ total_spent │
 * ├─────────────┼─────────┼─────────────┤
 * │ 1           │ Ayaan   │ 8000.00     │ ← updated from order 6
 * │ 2           │ Sneha   │ 1500.00     │ ← updated from order 2
 * │ 3           │ Rohit   │ 2000.00     │ ← updated from order 3
 * │ 4           │ Priya   │ 10000.00    │ ← updated from order 4
 * │ 5           │ Neha    │ 3500.00     │ ← updated from order 5
 * │ 6           │ Amit    │ 8000.00     │ ← updated from order 7
 * │ 7           │ Kavya   │ 1200.00     │ ← updated from order 8
 * └─────────────┴─────────┴─────────────┘
 */

-- EXAMPLE 2: Update product prices from price_updates table
SELECT product_id, product_name, price FROM products WHERE product_id IN (1, 4, 5);

/**
 * BEFORE:
 * ┌────────────┬──────────────┬─────────┐
 * │ product_id │ product_name │ price   │
 * ├────────────┼──────────────┼─────────┤
 * │ 1          │ Laptop       │ 50000.00│
 * │ 4          │ Monitor      │ 10000.00│
 * │ 5          │ Headphones   │ 2000.00 │
 * └────────────┴──────────────┴─────────┘
 */

UPDATE products 
SET price = price_updates.new_price
FROM price_updates 
WHERE products.product_id = price_updates.product_id;

SELECT product_id, product_name, price FROM products WHERE product_id IN (1, 4, 5);

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────┐
 * │ product_id │ product_name │ price   │
 * ├────────────┼──────────────┼─────────┤
 * │ 1          │ Laptop       │ 45000.00│ ← updated
 * │ 4          │ Monitor      │ 9000.00 │ ← updated
 * │ 5          │ Headphones   │ 1800.00 │ ← updated
 * └────────────┴──────────────┴─────────┘
 */

-- ============================================================================
-- PART 3: UPDATE with LEFT JOIN (Update all from one table)
-- ============================================================================

/**
 * LEFT JOIN updates all rows from the left table.
 * Rows without matches get NULL or default values.
 */

-- EXAMPLE: Update customer loyalty points based on orders (keep customers without orders)
UPDATE customers 
SET loyalty_points = COALESCE(orders.total_amount / 100, 0)
FROM orders 
WHERE customers.customer_id = orders.customer_id;

SELECT customer_id, name, loyalty_points FROM customers ORDER BY customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┐
 * │ customer_id │ name    │ loyalty_points  │
 * ├─────────────┼─────────┼─────────────────┤
 * │ 1           │ Ayaan   │ 80              │ (8000/100)
 * │ 2           │ Sneha   │ 15              │ (1500/100)
 * │ 3           │ Rohit   │ 20              │ (2000/100)
 * │ 4           │ Priya   │ 100             │ (10000/100)
 * │ 5           │ Neha    │ 35              │ (3500/100)
 * │ 6           │ Amit    │ 80              │ (8000/100)
 * │ 7           │ Kavya   │ 12              │ (1200/100)
 * └─────────────┴─────────┴─────────────────┘
 */

-- ============================================================================
-- PART 4: UPDATE with Multiple JOINs (Join multiple tables)
-- ============================================================================

/**
 * Update a table using data from two or more other tables.
 */

-- EXAMPLE: Update product stock based on order items (reduce stock)
UPDATE products 
SET stock_quantity = products.stock_quantity - order_items.quantity
FROM order_items 
WHERE products.product_id = order_items.product_id;

SELECT product_id, product_name, stock_quantity FROM products ORDER BY product_id;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────────────┐
 * │ product_id │ product_name │ stock_quantity  │
 * ├────────────┼──────────────┼─────────────────┤
 * │ 1          │ Laptop       │ 8               │ (10 - 2 orders)
 * │ 2          │ Mouse        │ 46              │ (50 - 4)
 * │ 3          │ Keyboard     │ 29              │ (30 - 1)
 * │ 4          │ Monitor      │ 4               │ (5 - 1)
 * │ 5          │ Headphones   │ 18              │ (20 - 2)
 * │ 6          │ USB Cable    │ 90              │ (100 - 10)
 * │ 7          │ Laptop Stand │ 14              │ (15 - 1)
 * │ 8          │ Webcam       │ 8               │ (no orders)
 * └────────────┴──────────────┴─────────────────┘
 */

-- EXAMPLE: Update product prices using category discount from another table
-- First, create category_discounts table
CREATE TABLE category_discounts (
    category VARCHAR(50),
    discount_percent INT
);

INSERT INTO category_discounts VALUES
('Electronics', 15),
('Accessories', 10);

-- Update prices with category discount (using JOIN on category)
UPDATE products 
SET price = products.price * (1 - category_discounts.discount_percent / 100.0)
FROM category_discounts 
WHERE products.category = category_discounts.category;

SELECT product_name, category, price FROM products ORDER BY category, product_name;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Headphones   │ Accessories  │ 1620.00 │ (1800 * 0.90)
 * │ Laptop Stand │ Accessories  │ 2250.00 │ (2500 * 0.90)
 * │ USB Cable    │ Accessories  │ 270.00  │ (300 * 0.90)
 * │ Keyboard     │ Electronics  │ 1147.50 │ (1350 * 0.85)
 * │ Laptop       │ Electronics  │ 38250.00│ (45000 * 0.85)
 * │ Monitor      │ Electronics  │ 7650.00 │ (9000 * 0.85)
 * │ Mouse        │ Electronics  │ 382.50  │ (450 * 0.85)
 * │ Webcam       │ Electronics  │ 2975.00 │ (3500 * 0.85)
 * └──────────────┴──────────────┴─────────┘
 */

-- ============================================================================
-- PART 5: UPDATE with JOIN and WHERE (Additional filtering)
-- ============================================================================

/**
 * Add WHERE clause to filter which rows get updated.
 */

-- EXAMPLE: Update only DELIVERED orders to customer totals
-- Reset customer totals first
UPDATE customers SET total_spent = 0;

UPDATE customers 
SET total_spent = orders.total_amount
FROM orders 
WHERE customers.customer_id = orders.customer_id 
  AND orders.status = 'DELIVERED';

SELECT c.customer_id, c.name, c.total_spent 
FROM customers c 
ORDER BY c.customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────┐
 * │ customer_id │ name    │ total_spent │
 * ├─────────────┼─────────┼─────────────┤
 * │ 1           │ Ayaan   │ 8000.00     │ (order 6 delivered)
 * │ 2           │ Sneha   │ 1500.00     │ (order 2 delivered)
 * │ 3           │ Rohit   │ 0.00        │ (order 3 pending)
 * │ 4           │ Priya   │ 10000.00    │ (order 4 delivered)
 * │ 5           │ Neha    │ 0.00        │ (order 5 pending)
 * │ 6           │ Amit    │ 8000.00     │ (order 7 delivered)
 * │ 7           │ Kavya   │ 0.00        │ (order 8 processing)
 * └─────────────┴─────────┴─────────────┘
 */

-- EXAMPLE: Update only products with low stock
UPDATE products 
SET price = price * 0.90,
    stock_quantity = stock_quantity + 5
FROM category_discounts 
WHERE products.category = category_discounts.category 
  AND products.stock_quantity < 10;

SELECT product_name, stock_quantity, price FROM products WHERE stock_quantity < 10;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬─────────┐
 * │ product_name │ stock_quantity  │ price   │
 * ├──────────────┼─────────────────┼─────────┤
 * │ Monitor      │ 9               │ 6885.00 │ (stock was 4, +5, price reduced)
 * │ Webcam       │ 13              │ 2677.50 │ (stock was 8, +5, price reduced)
 * └──────────────┴─────────────────┴─────────┘
 */

-- ============================================================================
-- PART 6: UPDATE with JOIN and Aggregate (Use SUM, COUNT, AVG)
-- ============================================================================

/**
 * Use aggregate functions to calculate values from related records.
 */

-- EXAMPLE 1: Update customer total_spent with SUM of all their orders
UPDATE customers 
SET total_spent = order_totals.total_amount
FROM (
    SELECT customer_id, SUM(total_amount) AS total_amount
    FROM orders
    GROUP BY customer_id
) AS order_totals
WHERE customers.customer_id = order_totals.customer_id;

SELECT c.customer_id, c.name, c.total_spent FROM customers ORDER BY c.customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────┐
 * │ customer_id │ name    │ total_spent │
 * ├─────────────┼─────────┼─────────────┤
 * │ 1           │ Ayaan   │ 58000.00    │ (50000 + 8000)
 * │ 2           │ Sneha   │ 1500.00     │ (1500)
 * │ 3           │ Rohit   │ 2000.00     │ (2000)
 * │ 4           │ Priya   │ 10000.00    │ (10000)
 * │ 5           │ Neha    │ 3500.00     │ (3500)
 * │ 6           │ Amit    │ 8000.00     │ (8000)
 * │ 7           │ Kavya   │ 1200.00     │ (1200)
 * └─────────────┴─────────┴─────────────┘
 */

-- EXAMPLE 2: Update last_order_date with most recent order date
UPDATE customers 
SET last_order_date = order_dates.max_order_date
FROM (
    SELECT customer_id, MAX(order_date) AS max_order_date
    FROM orders
    GROUP BY customer_id
) AS order_dates
WHERE customers.customer_id = order_dates.customer_id;

SELECT customer_id, name, last_order_date FROM customers ORDER BY customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┐
 * │ customer_id │ name    │ last_order_date │
 * ├─────────────┼─────────┼─────────────────┤
 * │ 1           │ Ayaan   │ 2024-02-10      │
 * │ 2           │ Sneha   │ 2024-01-20      │
 * │ 3           │ Rohit   │ 2024-01-25      │
 * │ 4           │ Priya   │ 2024-02-01      │
 * │ 5           │ Neha    │ 2024-02-05      │
 * │ 6           │ Amit    │ 2024-02-10      │
 * │ 7           │ Kavya   │ 2024-02-15      │
 * └─────────────┴─────────┴─────────────────┘
 */

-- EXAMPLE 3: Update product average rating from reviews (if we had reviews table)
-- This is a template pattern
/*
UPDATE products 
SET avg_rating = review_stats.avg_rating
FROM (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM reviews
    GROUP BY product_id
) AS review_stats
WHERE products.product_id = review_stats.product_id;
*/

-- ============================================================================
-- PART 7: UPDATE with JOIN and CASE (Conditional updates)
-- ============================================================================

/**
 * Combine CASE with JOIN for complex conditional updates.
 */

-- EXAMPLE: Update customer tier based on total spending
ALTER TABLE customers ADD COLUMN tier VARCHAR(20) DEFAULT 'Bronze';

UPDATE customers 
SET tier = CASE 
    WHEN total_spent >= 50000 THEN 'Platinum'
    WHEN total_spent >= 10000 THEN 'Gold'
    WHEN total_spent >= 5000 THEN 'Silver'
    ELSE 'Bronze'
END;

SELECT customer_id, name, total_spent, tier FROM customers ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────┬──────────┐
 * │ customer_id │ name    │ total_spent │ tier     │
 * ├─────────────┼─────────┼─────────────┼──────────┤
 * │ 1           │ Ayaan   │ 58000.00    │ Platinum │
 * │ 4           │ Priya   │ 10000.00    │ Gold     │
 * │ 6           │ Amit    │ 8000.00     │ Silver   │
 * │ 5           │ Neha    │ 3500.00     │ Bronze   │
 * │ 3           │ Rohit   │ 2000.00     │ Bronze   │
 * │ 2           │ Sneha   │ 1500.00     │ Bronze   │
 * │ 7           │ Kavya   │ 1200.00     │ Bronze   │
 * └─────────────┴─────────┴─────────────┴──────────┘
 */

-- EXAMPLE: Update product status based on stock and orders
ALTER TABLE products ADD COLUMN status VARCHAR(20) DEFAULT 'Active';

UPDATE products 
SET status = CASE 
    WHEN stock_quantity = 0 THEN 'Out of Stock'
    WHEN stock_quantity < 10 THEN 'Low Stock'
    WHEN stock_quantity > 100 THEN 'Overstocked'
    ELSE 'Active'
END;

SELECT product_name, stock_quantity, status FROM products ORDER BY stock_quantity DESC;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬─────────────┐
 * │ product_name │ stock_quantity  │ status      │
 * ├──────────────┼─────────────────┼─────────────┤
 * │ USB Cable    │ 90              │ Active      │
 * │ Mouse        │ 46              │ Active      │
 * │ Keyboard     │ 29              │ Active      │
 * │ Headphones   │ 18              │ Active      │
 * │ Laptop Stand │ 14              │ Active      │
 * │ Webcam       │ 13              │ Active      │
 * │ Monitor      │ 9               │ Low Stock   │
 * │ Laptop       │ 8               │ Low Stock   │
 * └──────────────┴─────────────────┴─────────────┘
 */

-- ============================================================================
-- PART 8: UPDATE with JOIN and Subquery (Alternative syntax)
-- ============================================================================

/**
 * You can also use subqueries instead of JOIN for updates.
 */

-- EXAMPLE: Update using subquery (same as JOIN)
UPDATE customers 
SET loyalty_points = (
    SELECT COALESCE(SUM(total_amount) / 100, 0)
    FROM orders
    WHERE orders.customer_id = customers.customer_id
);

SELECT customer_id, name, loyalty_points FROM customers ORDER BY customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┐
 * │ customer_id │ name    │ loyalty_points  │
 * ├─────────────┼─────────┼─────────────────┤
 * │ 1           │ Ayaan   │ 580             │
 * │ 2           │ Sneha   │ 15              │
 * │ 3           │ Rohit   │ 20              │
 * │ 4           │ Priya   │ 100             │
 * │ 5           │ Neha    │ 35              │
 * │ 6           │ Amit    │ 80              │
 * │ 7           │ Kavya   │ 12              │
 * └─────────────┴─────────┴─────────────────┘
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Monthly Customer Summary Update
 * 
 * Update customer summary based on their orders for the current month
 */

-- Reset customers
UPDATE customers SET total_spent = 0, loyalty_points = 0;

-- Update with current month's orders only
UPDATE customers 
SET total_spent = monthly_orders.monthly_total,
    loyalty_points = monthly_orders.monthly_total / 100
FROM (
    SELECT customer_id, SUM(total_amount) AS monthly_total
    FROM orders
    WHERE EXTRACT(MONTH FROM order_date) = EXTRACT(MONTH FROM CURRENT_DATE)
    GROUP BY customer_id
) AS monthly_orders
WHERE customers.customer_id = monthly_orders.customer_id;

SELECT customer_id, name, total_spent, loyalty_points FROM customers 
WHERE total_spent > 0 ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────┬─────────────────┐
 * │ customer_id │ name    │ total_spent │ loyalty_points  │
 * ├─────────────┼─────────┼─────────────┼─────────────────┤
 * │ 1           │ Ayaan   │ 8000.00     │ 80              │
 * │ 6           │ Amit    │ 8000.00     │ 80              │
 * │ 4           │ Priya   │ 10000.00    │ 100             │
 * │ 5           │ Neha    │ 3500.00     │ 35              │
 * │ 7           │ Kavya   │ 1200.00     │ 12              │
 * └─────────────┴─────────┴─────────────┴─────────────────┘
 */

/**
 * SCENARIO 2: Inventory Reorder Alert
 * 
 * Update product status based on stock and sales velocity
 */

ALTER TABLE products ADD COLUMN reorder_needed BOOLEAN DEFAULT FALSE;

UPDATE products 
SET reorder_needed = TRUE
FROM (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM order_items
    GROUP BY product_id
) AS sales_data
WHERE products.product_id = sales_data.product_id
  AND products.stock_quantity < sales_data.total_sold;

SELECT product_name, stock_quantity, total_sold, reorder_needed
FROM products p
JOIN (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM order_items
    GROUP BY product_id
) AS sales ON p.product_id = sales.product_id
WHERE reorder_needed = TRUE;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬────────────┬─────────────────┐
 * │ product_name │ stock_quantity  │ total_sold │ reorder_needed  │
 * ├──────────────┼─────────────────┼────────────┼─────────────────┤
 * │ Laptop       │ 8               │ 2          │ FALSE           │
 * │ Mouse        │ 46              │ 4          │ FALSE           │
 * │ Keyboard     │ 29              │ 1          │ FALSE           │
 * │ Monitor      │ 9               │ 1          │ FALSE           │
 * │ Headphones   │ 18              │ 2          │ FALSE           │
 * │ USB Cable    │ 90              │ 10         │ FALSE           │
 * │ Laptop Stand │ 14              │ 1          │ FALSE           │
 * └──────────────┴─────────────────┴────────────┴─────────────────┘
 */

/**
 * SCENARIO 3: Bulk Price Update from Excel Import
 * 
 * Update product prices using data imported from spreadsheet
 */

-- Create temp table for price import (simulating Excel import)
CREATE TEMP TABLE price_import (
    product_name VARCHAR(100),
    new_price DECIMAL(10,2)
);

INSERT INTO price_import VALUES
('Laptop', 48000),
('Monitor', 9500),
('Keyboard', 1400);

-- Update products using the import table
UPDATE products 
SET price = price_import.new_price
FROM price_import 
WHERE products.product_name = price_import.product_name;

SELECT product_name, price FROM products 
WHERE product_name IN ('Laptop', 'Monitor', 'Keyboard');

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Laptop       │ 48000.00│
 * │ Keyboard     │ 1400.00 │
 * │ Monitor      │ 9500.00 │
 * └──────────────┴─────────┘
 */

DROP TABLE price_import;

/**
 * SCENARIO 4: Customer Reward Points Expiry
 * 
 * Reduce loyalty points for inactive customers
 */

-- Add last_activity_date to customers
ALTER TABLE customers ADD COLUMN last_activity_date DATE;
UPDATE customers SET last_activity_date = last_order_date;

-- Reduce points for customers inactive > 30 days
UPDATE customers 
SET loyalty_points = loyalty_points * 0.5
FROM (
    SELECT customer_id
    FROM customers
    WHERE last_activity_date < CURRENT_DATE - INTERVAL '30 days'
) AS inactive
WHERE customers.customer_id = inactive.customer_id;

SELECT customer_id, name, last_activity_date, loyalty_points FROM customers 
WHERE last_activity_date < CURRENT_DATE - INTERVAL '30 days';

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────────┬─────────────────┐
 * │ customer_id │ name    │ last_activity_date  │ loyalty_points  │
 * ├─────────────┼─────────┼─────────────────────┼─────────────────┤
 * │ 2           │ Sneha   │ 2024-01-20          │ 7               │ (15 * 0.5)
 * │ 3           │ Rohit   │ 2024-01-25          │ 10              │ (20 * 0.5)
 * │ 4           │ Priya   │ 2024-02-01          │ 50              │ (100 * 0.5)
 * └─────────────┴─────────┴─────────────────────┴─────────────────┘
 */

/**
 * SCENARIO 5: Order Status Batch Update
 * 
 * Update order status based on payment confirmation from payment table
 */

-- Create payments table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT,
    payment_status VARCHAR(20),
    payment_date DATE
);

INSERT INTO payments (order_id, payment_status, payment_date) VALUES
(1, 'CONFIRMED', '2024-01-15'),
(2, 'CONFIRMED', '2024-01-20'),
(3, 'PENDING', NULL),
(4, 'CONFIRMED', '2024-02-01'),
(5, 'FAILED', NULL),
(6, 'CONFIRMED', '2024-02-10'),
(7, 'CONFIRMED', '2024-02-10'),
(8, 'PENDING', NULL);

-- Update order status based on payment status
UPDATE orders 
SET status = 
    CASE payments.payment_status
        WHEN 'CONFIRMED' THEN 'PAID'
        WHEN 'FAILED' THEN 'PAYMENT_FAILED'
        ELSE status
    END
FROM payments 
WHERE orders.order_id = payments.order_id;

SELECT o.order_id, o.status, p.payment_status 
FROM orders o
JOIN payments p ON o.order_id = p.order_id
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────────┬────────────────┐
 * │ order_id │ status          │ payment_status │
 * ├──────────┼─────────────────┼────────────────┤
 * │ 1        │ PAID            │ CONFIRMED      │
 * │ 2        │ PAID            │ CONFIRMED      │
 * │ 3        │ PENDING         │ PENDING        │
 * │ 4        │ PAID            │ CONFIRMED      │
 * │ 5        │ PAYMENT_FAILED  │ FAILED         │
 * │ 6        │ PAID            │ CONFIRMED      │
 * │ 7        │ PAID            │ CONFIRMED      │
 * │ 8        │ PROCESSING      │ PENDING        │
 * └──────────┴─────────────────┴────────────────┘
 */

-- ============================================================================
-- PART 10: PostgreSQL vs MySQL Syntax (Important differences)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              POSTGRESQL vs MySQL UPDATE with JOIN                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   POSTGRESQL (UPDATE...FROM):                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE table1                                                    │   │
 * │   │ SET table1.column = table2.column                               │   │
 * │   │ FROM table2                                                     │   │
 * │   │ WHERE table1.key = table2.key;                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   MySQL (UPDATE with JOIN):                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE table1                                                   │   │
 * │   │ JOIN table2 ON table1.key = table2.key                          │   │
 * │   │ SET table1.column = table2.column;                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BOTH work, but syntax is different!                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- PostgreSQL syntax (what we've been using)
/*
UPDATE customers 
SET total_spent = orders.total_amount
FROM orders 
WHERE customers.customer_id = orders.customer_id;
*/

-- MySQL syntax (for reference - won't work in PostgreSQL)
/*
UPDATE customers 
JOIN orders ON customers.customer_id = orders.customer_id
SET customers.total_spent = orders.total_amount;
*/

-- ============================================================================
-- PART 11: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting WHERE clause in UPDATE with JOIN                │
 * │                                                                          │
 * │   ❌ UPDATE customers SET total_spent = orders.total_amount             │
 * │      FROM orders;                                                       │
 * │      → No WHERE! This creates CROSS JOIN!                              │
 * │                                                                          │
 * │   ✅ UPDATE customers SET total_spent = orders.total_amount             │
 * │      FROM orders                                                        │
 * │      WHERE customers.customer_id = orders.customer_id;                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ DANGEROUS - No WHERE clause
-- UPDATE customers SET total_spent = orders.total_amount FROM orders;

-- ✅ Correct
UPDATE customers SET total_spent = orders.total_amount 
FROM orders 
WHERE customers.customer_id = orders.customer_id;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Ambiguous column names                                     │
 * │                                                                          │
 * │   ❌ UPDATE customers SET total_spent = total_amount                    │
 * │      FROM orders                                                        │
 * │      WHERE customer_id = customer_id;                                  │
 * │      → Which customer_id? Ambiguous!                                   │
 * │                                                                          │
 * │   ✅ Always use table aliases:                                          │
 * │      UPDATE customers c SET total_spent = o.total_amount               │
 * │      FROM orders o                                                      │
 * │      WHERE c.customer_id = o.customer_id;                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ✅ Correct with aliases
UPDATE customers c 
SET total_spent = o.total_amount
FROM orders o 
WHERE c.customer_id = o.customer_id;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using JOIN syntax incorrectly for PostgreSQL              │
 * │                                                                          │
 * │   ❌ UPDATE customers                                                   │
 * │      JOIN orders ON customers.customer_id = orders.customer_id         │
 * │      SET customers.total_spent = orders.total_amount;                  │
 * │      → This is MySQL syntax! Won't work in PostgreSQL                  │
 * │                                                                          │
 * │   ✅ Use UPDATE...FROM for PostgreSQL:                                  │
 * │      UPDATE customers                                                  │
 * │      SET total_spent = orders.total_amount                             │
 * │      FROM orders                                                       │
 * │      WHERE customers.customer_id = orders.customer_id;                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 12: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: PostgreSQL uses UPDATE...FROM (not JOIN in UPDATE)             │
 * │         → UPDATE table1 SET col = table2.col FROM table2 WHERE ...     │
 * │                                                                          │
 * │ RULE 2: Always use table aliases to avoid ambiguity                    │
 * │         → UPDATE customers c SET ... FROM orders o WHERE c.id = o.id   │
 * │                                                                          │
 * │ RULE 3: Always include WHERE clause (join condition)                   │
 * │         → Without WHERE, you get CROSS JOIN (updates all rows!)        │
 * │                                                                          │
 * │ RULE 4: Test with SELECT before UPDATE                                 │
 * │         → SELECT * FROM customers c JOIN orders o ON c.id = o.id       │
 * │         → Then run UPDATE with same condition                          │
 * │                                                                          │
 * │ RULE 5: Use subquery for simple single-table updates                   │
 * │         → Sometimes cleaner than JOIN                                  │
 * │                                                                          │
 * │ RULE 6: Use aggregate subqueries for SUM/COUNT/AVG                     │
 * │         → Pre-aggregate in subquery before JOIN                        │
 * │                                                                          │
 * │ RULE 7: Use RETURNING to verify updates                                │
 * │         → UPDATE ... RETURNING *;                                      │
 * │                                                                          │
 * │ RULE 8: Be careful with multiple matching rows                         │
 * │         → If one customer has multiple orders, which one updates?      │
 * │         → Use aggregation or LIMIT to control                          │
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
 * │ -- Basic UPDATE with JOIN (PostgreSQL)                                 │
 * │ UPDATE table1                                                          │
 * │ SET table1.column = table2.column                                      │
 * │ FROM table2                                                            │
 * │ WHERE table1.key = table2.key;                                         │
 * │                                                                          │
 * │ -- UPDATE with JOIN and aliases                                        │
 * │ UPDATE t1                                                              │
 * │ SET t1.column = t2.column                                              │
 * │ FROM table2 t2                                                         │
 * │ WHERE t1.key = t2.key;                                                 │
 * │                                                                          │
 * │ -- UPDATE with JOIN and aggregate                                      │
 * │ UPDATE t1                                                              │
 * │ SET t1.column = agg.total                                              │
 * │ FROM (SELECT key, SUM(value) AS total FROM t2 GROUP BY key) agg       │
 * │ WHERE t1.key = agg.key;                                                │
 * │                                                                          │
 * │ -- UPDATE with JOIN and additional WHERE                               │
 * │ UPDATE t1                                                              │
 * │ SET t1.column = t2.column                                              │
 * │ FROM t2                                                                │
 * │ WHERE t1.key = t2.key AND t1.status = 'ACTIVE';                       │
 * │                                                                          │
 * │ -- UPDATE with JOIN and CASE                                           │
 * │ UPDATE t1                                                              │
 * │ SET t1.column = CASE                                                   │
 * │     WHEN t2.value > 100 THEN 'High'                                    │
 * │     ELSE 'Low'                                                         │
 * │ END                                                                    │
 * │ FROM t2                                                                │
 * │ WHERE t1.key = t2.key;                                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Update customer email domain from @email.com to @newemail.com
 * 
 * Answer:
 *   UPDATE customers SET email = REPLACE(email, '@email.com', '@newemail.com');
 */

/**
 * EXERCISE 2: Update product prices using price_updates table
 * 
 * Answer:
 *   UPDATE products p 
 *   SET price = pu.new_price 
 *   FROM price_updates pu 
 *   WHERE p.product_id = pu.product_id;
 */

/**
 * EXERCISE 3: Update customer total_spent with sum of all their orders
 * 
 * Answer:
 *   UPDATE customers c 
 *   SET total_spent = o.total 
 *   FROM (SELECT customer_id, SUM(total_amount) AS total FROM orders GROUP BY customer_id) o 
 *   WHERE c.customer_id = o.customer_id;
 */

/**
 * EXERCISE 4: Update product stock based on order quantities
 * 
 * Answer:
 *   UPDATE products p 
 *   SET stock_quantity = p.stock_quantity - oi.quantity 
 *   FROM order_items oi 
 *   WHERE p.product_id = oi.product_id;
 */

/**
 * EXERCISE 5: Update customer tier based on total_spent
 * 
 * Answer:
 *   UPDATE customers 
 *   SET tier = CASE 
 *       WHEN total_spent >= 50000 THEN 'Platinum'
 *       WHEN total_spent >= 10000 THEN 'Gold'
 *       WHEN total_spent >= 5000 THEN 'Silver'
 *       ELSE 'Bronze'
 *   END;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS category_discounts;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS price_updates;
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
 * │ 1. UPDATE with JOIN updates a table using data from another table      │
 * │                                                                          │
 * │ 2. PostgreSQL syntax: UPDATE ... SET ... FROM ... WHERE ...            │
 * │                                                                          │
 * │ 3. Use cases:                                                           │
 * │    → Update customer totals from orders                                 │
 * │    → Bulk price updates from price list                                 │
 * │    → Update stock based on sales                                        │
 * │    → Synchronize related tables                                         │
 * │                                                                          │
 * │ 4. Can use with:                                                        │
 * │    → INNER JOIN (update matching rows only)                            │
 * │    → Aggregate functions (SUM, COUNT, AVG)                             │
 * │    → CASE for conditional updates                                       │
 * │    → Additional WHERE for filtering                                     │
 * │                                                                          │
 * │ 5. Best practices:                                                      │
 * │    → Always use table aliases                                           │
 * │    → Always include WHERE (join condition)                              │
 * │    → Test with SELECT first                                             │
 * │    → Use RETURNING to verify                                            │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - PostgreSQL uses UPDATE...FROM (not JOIN in UPDATE)                 │
 * │   - Without WHERE = CROSS JOIN (updates all rows!)                     │
 * │   - Use subqueries for aggregates before JOIN                          │
 * │   - Multiple matching rows can cause unexpected updates                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF UPDATE WITH JOIN GUIDE
-- ============================================================================