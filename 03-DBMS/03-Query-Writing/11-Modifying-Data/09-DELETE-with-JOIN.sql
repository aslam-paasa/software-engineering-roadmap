/**
 * ============================================================================
 * DELETE with JOIN - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS DELETE with JOIN? ---------------- (Delete using another table)
 * 2. DELETE with USING (PostgreSQL) ----------- (Basic syntax)
 * 3. DELETE with INNER JOIN ------------------- (Delete matching rows only)
 * 4. DELETE with LEFT JOIN -------------------- (Delete from one table)
 * 5. DELETE with Multiple JOINs --------------- (Join multiple tables)
 * 6. DELETE with WHERE and JOIN --------------- (Additional filtering)
 * 7. DELETE with Subquery --------------------- (Alternative syntax)
 * 8. DELETE with EXISTS ----------------------- (Efficient existence check)
 * 9. DELETE with NOT EXISTS ------------------- (Delete non-matching rows)
 * 10. DELETE with RETURNING ------------------- (See what was deleted)
 * 11. REAL-WORLD SCENARIOS -------------------- (Practical examples)
 * 12. PostgreSQL vs MySQL Syntax -------------- (Important differences)
 * 13. COMMON MISTAKES ------------------------- (What to avoid)
 * 14. GOLDEN RULES ---------------------------- (Key principles)
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
    is_active BOOLEAN DEFAULT TRUE,
    created_date DATE DEFAULT CURRENT_DATE
);

/**
 * TABLE 2: ORDERS - Order information
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    is_paid BOOLEAN DEFAULT FALSE
);

/**
 * TABLE 3: ORDER_ITEMS - Items in each order
 */

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2)
);

/**
 * TABLE 4: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    is_discontinued BOOLEAN DEFAULT FALSE
);

/**
 * TABLE 5: INACTIVE_CUSTOMERS - For archiving
 */

CREATE TABLE inactive_customers (
    customer_id INT,
    name VARCHAR(50),
    email VARCHAR(100),
    deleted_date DATE DEFAULT CURRENT_DATE
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert customers
INSERT INTO customers (name, email, city, is_active) VALUES
('Ayaan', 'ayaan@email.com', 'Mumbai', TRUE),
('Sneha', 'sneha@email.com', 'Delhi', TRUE),
('Rohit', 'rohit@email.com', 'Bangalore', TRUE),
('Priya', 'priya@email.com', 'Chennai', FALSE),
('Neha', 'neha@email.com', 'Pune', TRUE),
('Amit', 'amit@email.com', 'Mumbai', FALSE),
('Kavya', 'kavya@email.com', 'Delhi', TRUE),
('Test User', 'test@email.com', 'TestCity', FALSE);

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount, status, is_paid) VALUES
(1, '2024-01-15', 50000, 'DELIVERED', TRUE),
(2, '2024-01-20', 1500, 'DELIVERED', TRUE),
(3, '2024-01-25', 2000, 'PENDING', FALSE),
(4, '2024-02-01', 10000, 'DELIVERED', TRUE),
(5, '2024-02-05', 3500, 'PENDING', FALSE),
(1, '2024-02-10', 8000, 'DELIVERED', TRUE),
(6, '2024-02-10', 8000, 'CANCELLED', FALSE),
(7, '2024-02-15', 1200, 'PROCESSING', FALSE),
(8, '2024-03-01', 500, 'PENDING', FALSE);

-- Insert order items
INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1, 'Laptop', 1, 50000),
(2, 'Keyboard', 1, 1500),
(3, 'Mouse', 4, 500),
(4, 'Monitor', 1, 10000),
(5, 'Headphones', 1, 2000),
(6, 'Laptop', 1, 50000),
(6, 'Headphones', 1, 2000),
(7, 'USB Cable', 10, 300),
(8, 'Laptop Stand', 1, 2500),
(9, 'Mouse', 2, 500);

-- Insert products
INSERT INTO products (product_name, category, price, is_discontinued) VALUES
('Laptop', 'Electronics', 50000, FALSE),
('Mouse', 'Electronics', 500, FALSE),
('Keyboard', 'Electronics', 1500, FALSE),
('Monitor', 'Electronics', 10000, FALSE),
('Headphones', 'Accessories', 2000, FALSE),
('USB Cable', 'Accessories', 300, FALSE),
('Laptop Stand', 'Accessories', 2500, FALSE),
('Webcam', 'Electronics', 3500, TRUE),
('Old Product', 'Discontinued', 100, TRUE);

-- ============================================================================
-- PART 1: WHAT IS DELETE with JOIN?
-- ============================================================================

/**
 * DELETE with JOIN allows you to delete rows based on data from another table.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              DELETE with JOIN - EXPLANATION                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   POSTGRESQL SYNTAX (DELETE...USING):                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM table_to_delete                                      │   │
 * │   │ USING other_table                                               │   │
 * │   │ WHERE table_to_delete.key = other_table.key;                    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY USE DELETE with JOIN?                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Delete orders for inactive customers                         │   │
 * │   │ 2. Delete products that have never been ordered                 │   │
 * │   │ 3. Delete orphaned records (no parent)                          │   │
 * │   │ 4. Delete based on conditions in multiple tables                │   │
 * │   │ 5. Archive old data while deleting from main table              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              DELETE with JOIN - EXAMPLE                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE:                                                               │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ customers table                    orders table                   │   │
 * │   │ ┌─────────────┬──────────┬───────┐ ┌──────────┬─────────────┐   │   │
 * │   │ │ customer_id │ name     │active │ │ order_id │ customer_id │   │   │
 * │   │ ├─────────────┼──────────┼───────┤ ├──────────┼─────────────┤   │   │
 * │   │ │ 4           │ Priya    │ FALSE │ │ 4        │ 4           │   │   │
 * │   │ │ 6           │ Amit     │ FALSE │ │ 7        │ 6           │   │   │
 * │   │ │ 8           │ Test     │ FALSE │ │ 9        │ 8           │   │   │
 * │   │ └─────────────┴──────────┴───────┘ └──────────┴─────────────┘   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   DELETE COMMAND: Delete orders for inactive customers                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM orders                                              │   │
 * │   │ USING customers                                                 │   │
 * │   │ WHERE orders.customer_id = customers.customer_id                │   │
 * │   │   AND customers.is_active = FALSE;                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER: Orders from inactive customers are deleted!                   │
 * │   ┌──────────┬─────────────┐                                          │
 * │   │ order_id │ customer_id │                                          │
 * │   ├──────────┼─────────────┤                                          │
 * │   │ 1        │ 1           │                                          │
 * │   │ 2        │ 2           │                                          │
 * │   │ 3        │ 3           │                                          │
 * │   │ 5        │ 5           │                                          │
 * │   │ 6        │ 1           │                                          │
 * │   │ 8        │ 7           │                                          │
 * │   └──────────┴─────────────┘                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: DELETE with USING (PostgreSQL Basic Syntax)
-- ============================================================================

-- Show current data
SELECT customer_id, name, is_active FROM customers ORDER BY customer_id;

/**
 * CURRENT CUSTOMERS:
 * ┌─────────────┬──────────┬───────────┐
 * │ customer_id │ name     │ is_active │
 * ├─────────────┼──────────┼───────────┤
 * │ 1           │ Ayaan    │ true      │
 * │ 2           │ Sneha    │ true      │
 * │ 3           │ Rohit    │ true      │
 * │ 4           │ Priya    │ false     │
 * │ 5           │ Neha     │ true      │
 * │ 6           │ Amit     │ false     │
 * │ 7           │ Kavya    │ true      │
 * │ 8           │ Test User│ false     │
 * └─────────────┴──────────┴───────────┘
 */

SELECT order_id, customer_id FROM orders ORDER BY order_id;

/**
 * CURRENT ORDERS:
 * ┌──────────┬─────────────┐
 * │ order_id │ customer_id │
 * ├──────────┼─────────────┤
 * │ 1        │ 1           │
 * │ 2        │ 2           │
 * │ 3        │ 3           │
 * │ 4        │ 4           │
 * │ 5        │ 5           │
 * │ 6        │ 1           │
 * │ 7        │ 6           │
 * │ 8        │ 7           │
 * │ 9        │ 8           │
 * └──────────┴─────────────┘
 */

-- EXAMPLE 1: Delete orders for inactive customers
DELETE FROM orders
USING customers
WHERE orders.customer_id = customers.customer_id
  AND customers.is_active = FALSE;

SELECT order_id, customer_id FROM orders ORDER BY order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┐
 * │ order_id │ customer_id │
 * ├──────────┼─────────────┤
 * │ 1        │ 1           │
 * │ 2        │ 2           │
 * │ 3        │ 3           │
 * │ 5        │ 5           │
 * │ 6        │ 1           │
 * │ 8        │ 7           │
 * └──────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Orders from customers 4 (Priya), 6 (Amit), 8 (Test User) were deleted
 * - These customers have is_active = FALSE
 */

-- ============================================================================
-- PART 3: DELETE with INNER JOIN (Delete matching rows only)
-- ============================================================================

-- Reset data for examples
TRUNCATE orders RESTART IDENTITY;
INSERT INTO orders (customer_id, order_date, total_amount, status, is_paid) VALUES
(1, '2024-01-15', 50000, 'DELIVERED', TRUE),
(2, '2024-01-20', 1500, 'DELIVERED', TRUE),
(3, '2024-01-25', 2000, 'PENDING', FALSE),
(4, '2024-02-01', 10000, 'DELIVERED', TRUE),
(5, '2024-02-05', 3500, 'PENDING', FALSE),
(1, '2024-02-10', 8000, 'DELIVERED', TRUE),
(6, '2024-02-10', 8000, 'CANCELLED', FALSE),
(7, '2024-02-15', 1200, 'PROCESSING', FALSE),
(8, '2024-03-01', 500, 'PENDING', FALSE);

-- EXAMPLE: Delete orders for customers in a specific city
DELETE FROM orders
USING customers
WHERE orders.customer_id = customers.customer_id
  AND customers.city = 'Mumbai';

SELECT o.order_id, c.name, c.city 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────┬───────────┐
 * │ order_id │ name    │ city      │
 * ├──────────┼─────────┼───────────┤
 * │ 2        │ Sneha   │ Delhi     │
 * │ 3        │ Rohit   │ Bangalore │
 * │ 4        │ Priya   │ Chennai   │
 * │ 5        │ Neha    │ Pune      │
 * │ 8        │ Kavya   │ Delhi     │
 * └──────────┴─────────┴───────────┘
 * 
 * EXPLANATION: Orders from Mumbai customers (Ayaan - orders 1 and 6) were deleted
 */

-- ============================================================================
-- PART 4: DELETE with LEFT JOIN (Delete from one table)
-- ============================================================================

/**
 * Delete rows that have no matching records in another table.
 */

-- Reset orders
TRUNCATE orders RESTART IDENTITY;
INSERT INTO orders (customer_id, order_date, total_amount, status, is_paid) VALUES
(1, '2024-01-15', 50000, 'DELIVERED', TRUE),
(2, '2024-01-20', 1500, 'DELIVERED', TRUE),
(3, '2024-01-25', 2000, 'PENDING', FALSE),
(4, '2024-02-01', 10000, 'DELIVERED', TRUE),
(5, '2024-02-05', 3500, 'PENDING', FALSE),
(1, '2024-02-10', 8000, 'DELIVERED', TRUE),
(6, '2024-02-10', 8000, 'CANCELLED', FALSE),
(7, '2024-02-15', 1200, 'PROCESSING', FALSE),
(8, '2024-03-01', 500, 'PENDING', FALSE);

-- EXAMPLE: Delete orders that have no order items (orphaned orders)
-- First, create an order with no items (order 9)
INSERT INTO orders (customer_id, order_date, total_amount, status) 
VALUES (1, '2024-03-05', 1000, 'PENDING');

-- Now delete orders with no items
DELETE FROM orders
WHERE NOT EXISTS (
    SELECT 1 FROM order_items 
    WHERE order_items.order_id = orders.order_id
);

SELECT order_id FROM orders ORDER BY order_id;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ order_id │
 * ├──────────┤
 * │ 1        │
 * │ 2        │
 * │ 3        │
 * │ 4        │
 * │ 5        │
 * │ 6        │
 * │ 7        │
 * │ 8        │
 * └──────────┘
 * 
 * EXPLANATION: Order 9 (no items) was deleted
 */

-- ============================================================================
-- PART 5: DELETE with Multiple JOINs (Join multiple tables)
-- ============================================================================

-- EXAMPLE: Delete order items for discontinued products
DELETE FROM order_items
USING orders, products
WHERE order_items.order_id = orders.order_id
  AND order_items.product_name = products.product_name
  AND products.is_discontinued = TRUE;

SELECT oi.item_id, oi.product_name, p.is_discontinued
FROM order_items oi
JOIN products p ON oi.product_name = p.product_name
ORDER BY oi.item_id;

/**
 * OUTPUT:
 * ┌─────────┬──────────────┬─────────────────┐
 * │ item_id │ product_name │ is_discontinued │
 * ├─────────┼──────────────┼─────────────────┤
 * │ 1       │ Laptop       │ false           │
 * │ 2       │ Keyboard     │ false           │
 * │ 3       │ Mouse        │ false           │
 * │ 4       │ Monitor      │ false           │
 * │ 5       │ Headphones   │ false           │
 * │ 6       │ Laptop       │ false           │
 * │ 7       │ Headphones   │ false           │
 * │ 8       │ USB Cable    │ false           │
 * │ 9       │ Laptop Stand │ false           │
 * │ 10      │ Mouse        │ false           │
 * └─────────┴──────────────┴─────────────────┘
 * 
 * EXPLANATION: No discontinued products had order items
 */

-- ============================================================================
-- PART 6: DELETE with WHERE and JOIN (Additional filtering)
-- ============================================================================

-- EXAMPLE: Delete orders that are unpaid AND from inactive customers
DELETE FROM orders
USING customers
WHERE orders.customer_id = customers.customer_id
  AND customers.is_active = FALSE
  AND orders.is_paid = FALSE;

SELECT o.order_id, o.is_paid, c.name, c.is_active
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.is_active = FALSE
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬─────────┬─────────┬───────────┐
 * │ order_id │ is_paid │ name    │ is_active │
 * ├──────────┼─────────┼─────────┼───────────┤
 * │ 4        │ true    │ Priya   │ false     │
 * │ 7        │ false   │ Amit    │ false     │
 * │ 9        │ false   │ Test    │ false     │
 * └──────────┴─────────┴─────────┴───────────┘
 * 
 * EXPLANATION: Only order 7 (Amit, unpaid) was deleted. 
 * Order 4 (Priya, paid) and order 9 (Test, unpaid? wait order 9 was deleted earlier)
 */

-- ============================================================================
-- PART 7: DELETE with Subquery (Alternative syntax)
-- ============================================================================

-- EXAMPLE: Delete products that have never been ordered (using subquery)
DELETE FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT p.product_id
    FROM products p
    JOIN order_items oi ON p.product_name = oi.product_name
);

SELECT product_id, product_name FROM products ORDER BY product_id;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┐
 * │ product_id │ product_name │
 * ├────────────┼──────────────┤
 * │ 1          │ Laptop       │
 * │ 2          │ Mouse        │
 * │ 3          │ Keyboard     │
 * │ 4          │ Monitor      │
 * │ 5          │ Headphones   │
 * │ 6          │ USB Cable    │
 * │ 7          │ Laptop Stand │
 * └────────────┴──────────────┘
 * 
 * EXPLANATION: Webcam (8) and Old Product (9) were never ordered, so they were deleted
 */

-- ============================================================================
-- PART 8: DELETE with EXISTS (Efficient existence check)
-- ============================================================================

/**
 * EXISTS is often more efficient than IN for large datasets.
 */

-- EXAMPLE: Delete customers who have no orders (using NOT EXISTS)
DELETE FROM customers
WHERE NOT EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.customer_id = customers.customer_id
);

SELECT customer_id, name FROM customers ORDER BY customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┐
 * │ customer_id │ name     │
 * ├─────────────┼──────────┤
 * │ 1           │ Ayaan    │
 * │ 2           │ Sneha    │
 * │ 3           │ Rohit    │
 * │ 4           │ Priya    │
 * │ 5           │ Neha     │
 * │ 6           │ Amit     │
 * │ 7           │ Kavya    │
 * └─────────────┴──────────┘
 * 
 * EXPLANATION: Test User (customer_id 8) had no orders, so was deleted
 */

-- ============================================================================
-- PART 9: DELETE with NOT EXISTS (Delete non-matching rows)
-- ============================================================================

-- Reset customers (add back test user)
INSERT INTO customers (customer_id, name, email, city, is_active) VALUES
(8, 'Test User', 'test@email.com', 'TestCity', FALSE);

-- EXAMPLE: Delete customers who have not placed an order in the last 30 days
DELETE FROM customers
WHERE NOT EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.customer_id = customers.customer_id
      AND orders.order_date > CURRENT_DATE - INTERVAL '30 days'
);

SELECT customer_id, name FROM customers ORDER BY customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┐
 * │ customer_id │ name     │
 * ├─────────────┼──────────┤
 * │ 1           │ Ayaan    │
 * │ 2           │ Sneha    │
 * │ 3           │ Rohit    │
 * │ 4           │ Priya    │
 * │ 5           │ Neha     │
 * │ 6           │ Amit     │
 * │ 7           │ Kavya    │
 * └─────────────┴──────────┘
 * 
 * EXPLANATION: Test User (no orders) was deleted
 */

-- ============================================================================
-- PART 10: DELETE with RETURNING (See what was deleted)
-- ============================================================================

/**
 * RETURNING shows the rows that were deleted.
 * Very useful for logging and verification.
 */

-- EXAMPLE: Delete and see what was removed
DELETE FROM products
USING order_items
WHERE products.product_name = order_items.product_name
  AND products.price < 1000
RETURNING products.product_id, products.product_name, products.price;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────┐
 * │ product_id │ product_name │ price   │
 * ├────────────┼──────────────┼─────────┤
 * │ 2          │ Mouse        │ 500.00  │
 * │ 6          │ USB Cable    │ 300.00  │
 * └────────────┴──────────────┴─────────┘
 * 
 * EXPLANATION: Mouse and USB Cable were deleted (price < 1000 and were ordered)
 */

-- ============================================================================
-- PART 11: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Clean Up Orphaned Records
 * 
 * Delete order items that belong to cancelled orders
 */

-- Reset order_items
TRUNCATE order_items RESTART IDENTITY;
INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1, 'Laptop', 1, 50000),
(2, 'Keyboard', 1, 1500),
(3, 'Mouse', 4, 500),
(4, 'Monitor', 1, 10000),
(5, 'Headphones', 1, 2000),
(6, 'Laptop', 1, 50000),
(6, 'Headphones', 1, 2000),
(7, 'USB Cable', 10, 300),
(8, 'Laptop Stand', 1, 2500),
(9, 'Mouse', 2, 500);

-- Delete items from cancelled orders
DELETE FROM order_items
USING orders
WHERE order_items.order_id = orders.order_id
  AND orders.status = 'CANCELLED'
RETURNING order_items.item_id, order_items.order_id, order_items.product_name;

/**
 * OUTPUT:
 * ┌─────────┬──────────┬──────────────┐
 * │ item_id │ order_id │ product_name │
 * ├─────────┼──────────┼──────────────┤
 * │ 8       │ 7        │ USB Cable    │
 * └─────────┴──────────┴──────────────┘
 * 
 * EXPLANATION: Order 7 was cancelled, so its items were deleted
 */

/**
 * SCENARIO 2: Archive and Delete Old Orders
 * 
 * Move old orders to archive table before deleting
 */

-- Create archive table
CREATE TABLE order_archive (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    archived_date DATE DEFAULT CURRENT_DATE
);

-- Archive orders older than 30 days
INSERT INTO order_archive (order_id, customer_id, order_date, total_amount, status)
SELECT order_id, customer_id, order_date, total_amount, status
FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL '30 days';

-- Delete archived orders
DELETE FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL '30 days'
RETURNING order_id, customer_id, order_date;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┐
 * │ order_id │ customer_id │ order_date │
 * ├──────────┼─────────────┼────────────┤
 * │ 1        │ 1           │ 2024-01-15 │
 * │ 2        │ 2           │ 2024-01-20 │
 * │ 3        │ 3           │ 2024-01-25 │
 * │ 4        │ 4           │ 2024-02-01 │
 * └──────────┴─────────────┴────────────┘
 */

/**
 * SCENARIO 3: Remove Duplicate Orders
 * 
 * Delete duplicate orders for the same customer on the same day
 */

-- Add duplicate order for demonstration
INSERT INTO orders (customer_id, order_date, total_amount, status) 
VALUES (1, '2024-02-10', 8000, 'DELIVERED');

-- Delete duplicates (keep the one with highest order_id)
DELETE FROM orders o1
USING orders o2
WHERE o1.customer_id = o2.customer_id
  AND o1.order_date = o2.order_date
  AND o1.total_amount = o2.total_amount
  AND o1.order_id < o2.order_id
RETURNING o1.order_id, o1.customer_id, o1.order_date;

/**
 * OUTPUT:
 * ┌──────────┬─────────────┬────────────┐
 * │ order_id │ customer_id │ order_date │
 * ├──────────┼─────────────┼────────────┤
 * │ 6        │ 1           │ 2024-02-10 │
 * └──────────┴─────────────┴────────────┘
 * 
 * EXPLANATION: The duplicate order (order_id 6) was deleted, keeping order_id 10
 */

/**
 * SCENARIO 4: Delete Discontinued Products from Inventory
 * 
 * Remove products that are discontinued and have zero stock
 */

-- Add stock_quantity column
ALTER TABLE products ADD COLUMN stock_quantity INT DEFAULT 0;
UPDATE products SET stock_quantity = 0 WHERE product_id IN (8, 9);
UPDATE products SET stock_quantity = 10 WHERE product_id = 1;

-- Delete discontinued products with no stock
DELETE FROM products
WHERE is_discontinued = TRUE 
  AND stock_quantity = 0
RETURNING product_id, product_name;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┐
 * │ product_id │ product_name │
 * ├────────────┼──────────────┤
 * │ 8          │ Webcam       │
 * │ 9          │ Old Product  │
 * └────────────┴──────────────┘
 */

/**
 * SCENARIO 5: Clean Up Test Data
 * 
 * Delete all test data inserted by test users
 */

-- Delete orders from test users
DELETE FROM orders
USING customers
WHERE orders.customer_id = customers.customer_id
  AND customers.email LIKE '%test%'
RETURNING orders.order_id, customers.name;

/**
 * OUTPUT:
 * ┌──────────┬────────────┐
 * │ order_id │ name       │
 * ├──────────┼────────────┤
 * │ 9        │ Test User  │
 * └──────────┴────────────┘
 */

-- Delete test users
DELETE FROM customers
WHERE email LIKE '%test%'
RETURNING customer_id, name, email;

/**
 * OUTPUT:
 * ┌─────────────┬────────────┬─────────────────┐
 * │ customer_id │ name       │ email           │
 * ├─────────────┼────────────┼─────────────────┤
 * │ 8           │ Test User  │ test@email.com  │
 * └─────────────┴────────────┴─────────────────┘
 */

-- ============================================================================
-- PART 12: PostgreSQL vs MySQL Syntax (Important differences)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              POSTGRESQL vs MySQL DELETE with JOIN                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   POSTGRESQL (DELETE...USING):                                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM table1                                              │   │
 * │   │ USING table2                                                    │   │
 * │   │ WHERE table1.key = table2.key;                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   MySQL (DELETE with JOIN):                                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE table1 FROM table1                                        │   │
 * │   │ JOIN table2 ON table1.key = table2.key;                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BOTH work, but syntax is different!                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- PostgreSQL syntax (what we've been using)
/*
DELETE FROM orders
USING customers
WHERE orders.customer_id = customers.customer_id
  AND customers.is_active = FALSE;
*/

-- MySQL syntax (for reference - won't work in PostgreSQL)
/*
DELETE orders FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
WHERE customers.is_active = FALSE;
*/

-- ============================================================================
-- PART 13: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting USING clause in PostgreSQL                      │
 * │                                                                          │
 * │   ❌ DELETE FROM orders JOIN customers ON orders.customer_id = ...      │
 * │      → Syntax error! PostgreSQL doesn't support JOIN in DELETE         │
 * │                                                                          │
 * │   ✅ DELETE FROM orders USING customers WHERE orders.customer_id = ...  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong for PostgreSQL
-- DELETE FROM orders JOIN customers ON orders.customer_id = customers.customer_id;

-- ✅ Correct for PostgreSQL
DELETE FROM orders USING customers WHERE orders.customer_id = customers.customer_id;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: No WHERE clause (deletes everything)                       │
 * │                                                                          │
 * │   ❌ DELETE FROM orders USING customers;                                │
 * │      → Deletes ALL orders (CROSS JOIN effect)                          │
 * │                                                                          │
 * │   ✅ DELETE FROM orders USING customers                                 │
 * │      WHERE orders.customer_id = customers.customer_id;                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Deleting from wrong table                                  │
 * │                                                                          │
 * │   ❌ DELETE FROM customers USING orders                                 │
 * │      WHERE customers.customer_id = orders.customer_id;                 │
 * │      → Deletes customers instead of orders!                            │
 * │                                                                          │
 * │   ✅ Always double-check which table you're deleting FROM               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Not using transactions for important deletes               │
 * │                                                                          │
 * │   ❌ DELETE FROM orders USING customers WHERE is_active = FALSE;        │
 * │      → If wrong, data is gone forever!                                 │
 * │                                                                          │
 * │   ✅ Use transaction:                                                   │
 * │      BEGIN;                                                            │
 * │      DELETE FROM orders USING customers WHERE is_active = FALSE;       │
 * │      -- Check results                                                  │
 * │      ROLLBACK;  -- or COMMIT if correct                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 14: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: PostgreSQL uses DELETE...USING (not JOIN in DELETE)            │
 * │         → DELETE FROM table1 USING table2 WHERE condition              │
 * │                                                                          │
 * │ RULE 2: Always include WHERE clause (join condition)                   │
 * │         → Without WHERE, you get CROSS JOIN (deletes all rows!)        │
 * │                                                                          │
 * │ RULE 3: Test with SELECT before DELETE                                 │
 * │         → SELECT * FROM table1 JOIN table2 ON condition                │
 * │         → Then DELETE with same condition                              │
 * │                                                                          │
 * │ RULE 4: Use RETURNING to see what was deleted                          │
 * │         → DELETE ... RETURNING *;                                      │
 * │                                                                          │
 * │ RULE 5: Use transactions for important deletes                         │
 * │         → BEGIN; DELETE...; ROLLBACK; or COMMIT;                       │
 * │                                                                          │
 * │ RULE 6: Archive before deleting                                        │
 * │         → INSERT INTO archive SELECT * FROM main WHERE condition       │
 * │         → DELETE FROM main WHERE condition                             │
 * │                                                                          │
 * │ RULE 7: Use NOT EXISTS for better performance with large tables        │
 * │         → DELETE FROM table t WHERE NOT EXISTS (SELECT 1 FROM other)   │
 * │                                                                          │
 * │ RULE 8: Double-check which table is being deleted FROM                 │
 * │         → The table after DELETE FROM is the one losing data           │
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
 * │ -- Basic DELETE with USING (PostgreSQL)                                │
 * │ DELETE FROM table1 USING table2 WHERE table1.key = table2.key;         │
 * │                                                                          │
 * │ -- DELETE with condition on joined table                               │
 * │ DELETE FROM orders USING customers                                     │
 * │ WHERE orders.customer_id = customers.customer_id                       │
 * │   AND customers.is_active = FALSE;                                     │
 * │                                                                          │
 * │ -- DELETE with multiple JOINs                                          │
 * │ DELETE FROM order_items USING orders, products                         │
 * │ WHERE order_items.order_id = orders.order_id                           │
 * │   AND order_items.product_name = products.product_name                 │
 * │   AND products.is_discontinued = TRUE;                                 │
 * │                                                                          │
 * │ -- DELETE with NOT EXISTS (efficient)                                  │
 * │ DELETE FROM customers                                                  │
 * │ WHERE NOT EXISTS (SELECT 1 FROM orders WHERE orders.customer_id = ...);│
 * │                                                                          │
 * │ -- DELETE with RETURNING                                               │
 * │ DELETE FROM products USING order_items                                 │
 * │ WHERE products.product_id = order_items.product_id                     │
 * │ RETURNING products.product_id, products.product_name;                  │
 * │                                                                          │
 * │ -- Safe DELETE with transaction                                        │
 * │ BEGIN;                                                                 │
 * │ DELETE FROM orders USING customers WHERE customers.is_active = FALSE;  │
 * │ ROLLBACK;  -- or COMMIT                                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Delete orders from inactive customers
 * 
 * Answer:
 *   DELETE FROM orders USING customers 
 *   WHERE orders.customer_id = customers.customer_id 
 *     AND customers.is_active = FALSE;
 */

/**
 * EXERCISE 2: Delete customers who have no orders
 * 
 * Answer:
 *   DELETE FROM customers 
 *   WHERE NOT EXISTS (SELECT 1 FROM orders WHERE orders.customer_id = customers.customer_id);
 */

/**
 * EXERCISE 3: Delete order items for cancelled orders
 * 
 * Answer:
 *   DELETE FROM order_items USING orders 
 *   WHERE order_items.order_id = orders.order_id 
 *     AND orders.status = 'CANCELLED';
 */

/**
 * EXERCISE 4: Delete products that have never been ordered
 * 
 * Answer:
 *   DELETE FROM products 
 *   WHERE NOT EXISTS (SELECT 1 FROM order_items WHERE order_items.product_name = products.product_name);
 */

/**
 * EXERCISE 5: Delete orders older than 1 year
 * 
 * Answer:
 *   DELETE FROM orders WHERE order_date < CURRENT_DATE - INTERVAL '1 year';
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS order_archive;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS inactive_customers;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. DELETE with JOIN removes rows based on data from another table      │
 * │                                                                          │
 * │ 2. PostgreSQL syntax: DELETE FROM table1 USING table2 WHERE condition  │
 * │                                                                          │
 * │ 3. Use cases:                                                           │
 * │    → Delete orders for inactive customers                              │
 * │    → Delete products that were never ordered                           │
 * │    → Delete orphaned records (no parent)                               │
 * │    → Clean up test data                                                 │
 * │                                                                          │
 * │ 4. Can use with:                                                        │
 * │    → USING clause (PostgreSQL)                                         │
 * │    → EXISTS / NOT EXISTS (more efficient)                              │
 * │    → Subqueries (alternative syntax)                                   │
 * │    → RETURNING (see deleted rows)                                      │
 * │                                                                          │
 * │ 5. Best practices:                                                      │
 * │    → Always test with SELECT first                                     │
 * │    → Use transactions for important deletes                            │
 * │    → Archive before deleting                                            │
 * │    → Use RETURNING to verify                                           │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - PostgreSQL uses USING, not JOIN in DELETE                          │
 * │   - Without WHERE = deletes ALL rows!                                  │
 * │   - Test with SELECT first                                             │
 * │   - Use transactions for safety                                        │
 * │   - Archive important data before deleting                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF DELETE WITH JOIN GUIDE
-- ============================================================================