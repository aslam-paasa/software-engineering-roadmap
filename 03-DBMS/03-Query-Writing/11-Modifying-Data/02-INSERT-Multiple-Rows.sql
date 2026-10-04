/**
 * ============================================================================
 * INSERT MULTIPLE ROWS - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS MULTIPLE ROW INSERT? ----------- (Insert many rows at once)
 * 2. INSERT MULTIPLE ROWS - BASIC ----------- (Simple multiple insert)
 * 3. INSERT MULTIPLE ROWS - SPECIFIC COLUMNS - (Insert only needed columns)
 * 4. INSERT MULTIPLE ROWS with RETURNING ---- (Get back inserted data)
 * 5. INSERT MULTIPLE ROWS with DEFAULT ------ (Using default values)
 * 6. INSERT MULTIPLE ROWS from SELECT ------- (Insert query results)
 * 7. INSERT MULTIPLE ROWS with CONFLICT ----- (Handle duplicates - UPSERT)
 * 8. REAL-WORLD SCENARIOS -------------------- (Practical examples)
 * 9. PERFORMANCE COMPARISON ------------------ (Single vs Multiple inserts)
 * 10. COMMON MISTAKES ------------------------ (What to avoid)
 * 11. GOLDEN RULES --------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: STUDENTS - Student information
 */

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    grade VARCHAR(2),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    email VARCHAR(100) UNIQUE
);

/**
 * TABLE 2: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) DEFAULT 0.00,
    stock_quantity INT DEFAULT 0,
    in_stock BOOLEAN DEFAULT TRUE
);

/**
 * TABLE 3: ORDERS - Customer orders
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    product_name VARCHAR(50),
    quantity INT,
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'PENDING'
);

/**
 * TABLE 4: EMPLOYEES - Employee data for bulk insert
 */

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

/**
 * TABLE 5: TEMP_DATA - Temporary data for transfer
 */

CREATE TABLE temp_data (
    id INT,
    name VARCHAR(50),
    value DECIMAL(10,2)
);

-- ============================================================================
-- PART 1: WHAT IS MULTIPLE ROW INSERT?
-- ============================================================================

/**
 * Multiple row INSERT adds several rows to a table in ONE command.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS MULTIPLE ROW INSERT?                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX (Basic):                                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO table_name (col1, col2, col3)                       │   │
 * │   │ VALUES                                                          │   │
 * │   │     (val1, val2, val3),    ← Row 1                              │   │
 * │   │     (val4, val5, val6),    ← Row 2                              │   │
 * │   │     (val7, val8, val9);    ← Row 3                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SINGLE INSERT (Slow - multiple round trips):                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO students (name) VALUES ('Ayaan');                   │   │
 * │   │ INSERT INTO students (name) VALUES ('Sneha');                   │   │
 * │   │ INSERT INTO students (name) VALUES ('Rohit');                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   MULTIPLE ROW INSERT (Fast - one round trip):                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO students (name) VALUES                              │   │
 * │   │     ('Ayaan'),                                                  │   │
 * │   │     ('Sneha'),                                                  │   │
 * │   │     ('Rohit');                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHY USE MULTIPLE ROW INSERT?                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. FASTER - One database round trip instead of many            │   │
 * │   │ 2. LESS NETWORK TRAFFIC - Send all data at once                │   │
 * │   │ 3. ATOMIC - Either all rows insert or none (in a transaction)  │   │
 * │   │ 4. CLEANER CODE - Less repetition                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              INSERT MULTIPLE ROWS - EXAMPLE                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE INSERT (Empty students table):                                 │
 * │   ┌────────────┬──────┬─────┬───────┬─────────────────┬───────┐        │
 * │   │ student_id │ name │ age │ grade │ enrollment_date │ email │        │
 * │   ├────────────┼──────┼─────┼───────┼─────────────────┼───────┤        │
 * │   │ (no rows)  │      │     │       │                 │       │        │
 * │   └────────────┴──────┴─────┴───────┴─────────────────┴───────┘        │
 * │                                                                          │
 * │   INSERT COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO students (name, age, grade) VALUES                  │   │
 * │   │     ('Ayaan', 20, 'A'),                                         │   │
 * │   │     ('Sneha', 22, 'B'),                                         │   │
 * │   │     ('Rohit', 21, 'A');                                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER INSERT (3 rows added at once):                                  │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬───────┐     │
 * │   │ student_id │ name    │ age │ grade │ enrollment_date │ email │     │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼───────┤     │
 * │   │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ NULL  │     │
 * │   │ 2          │ Sneha   │ 22  │ B     │ 2024-01-15      │ NULL  │     │
 * │   │ 3          │ Rohit   │ 21  │ A     │ 2024-01-15      │ NULL  │     │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴───────┘     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: INSERT MULTIPLE ROWS - BASIC
-- ============================================================================

/**
 * Insert multiple rows with all columns or specific columns.
 */

-- Clear existing data
TRUNCATE students RESTART IDENTITY;

-- Insert 3 students at once
INSERT INTO students (name, age, grade) VALUES
    ('Ayaan', 20, 'A'),
    ('Sneha', 22, 'B'),
    ('Rohit', 21, 'A');

SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬───────┬─────────────────┬───────┐
 * │ student_id │ name    │ age │ grade │ enrollment_date │ email │
 * ├────────────┼─────────┼─────┼───────┼─────────────────┼───────┤
 * │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ NULL  │
 * │ 2          │ Sneha   │ 22  │ B     │ 2024-01-15      │ NULL  │
 * │ 3          │ Rohit   │ 21  │ A     │ 2024-01-15      │ NULL  │
 * └────────────┴─────────┴─────┴───────┴─────────────────┴───────┘
 */

-- Insert 2 more students
INSERT INTO students (name, age, grade, email) VALUES
    ('Priya', 23, 'B', 'priya@email.com'),
    ('Neha', 24, 'A', 'neha@email.com');

SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ NULL                │
 * │ 2          │ Sneha   │ 22  │ B     │ 2024-01-15      │ NULL                │
 * │ 3          │ Rohit   │ 21  │ A     │ 2024-01-15      │ NULL                │
 * │ 4          │ Priya   │ 23  │ B     │ 2024-01-15      │ priya@email.com     │
 * │ 5          │ Neha    │ 24  │ A     │ 2024-01-15      │ neha@email.com      │
 * └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 3: INSERT MULTIPLE ROWS - SPECIFIC COLUMNS
-- ============================================================================

/**
 * You can insert multiple rows with only the columns you need.
 * Omitted columns get NULL or DEFAULT values.
 */

-- Clear existing data
TRUNCATE products RESTART IDENTITY;

-- Insert multiple products with only product_name and category
INSERT INTO products (product_name, category) VALUES
    ('Laptop', 'Electronics'),
    ('Mouse', 'Electronics'),
    ('Keyboard', 'Electronics'),
    ('Monitor', 'Electronics'),
    ('Headphones', 'Accessories');

SELECT * FROM products;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬──────────────┬─────────┬─────────────────┬──────────┐
 * │ product_id │ product_name │ category     │ price   │ stock_quantity  │ in_stock │
 * ├────────────┼──────────────┼──────────────┼─────────┼─────────────────┼──────────┤
 * │ 1          │ Laptop       │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 2          │ Mouse        │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 3          │ Keyboard     │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 4          │ Monitor      │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 5          │ Headphones   │ Accessories  │ 0.00    │ 0               │ true     │
 * └────────────┴──────────────┴──────────────┴─────────┴─────────────────┴──────────┘
 * 
 * EXPLANATION:
 * - price got DEFAULT value 0.00
 * - stock_quantity got DEFAULT value 0
 * - in_stock got DEFAULT value TRUE
 */

-- Insert with some columns having values, others using DEFAULT
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
    ('USB Cable', 'Accessories', 299, 100),
    ('Mouse Pad', 'Accessories', 399, 50),
    ('Laptop Stand', 'Accessories', 2499, 25);

SELECT product_name, price, stock_quantity, in_stock FROM products
WHERE category = 'Accessories';

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬─────────────────┬──────────┐
 * │ product_name │ price   │ stock_quantity  │ in_stock │
 * ├──────────────┼─────────┼─────────────────┼──────────┤
 * │ Headphones   │ 0.00    │ 0               │ true     │
 * │ USB Cable    │ 299.00  │ 100             │ true     │
 * │ Mouse Pad    │ 399.00  │ 50              │ true     │
 * │ Laptop Stand │ 2499.00 │ 25              │ true     │
 * └──────────────┴─────────┴─────────────────┴──────────┘
 */

-- ============================================================================
-- PART 4: INSERT MULTIPLE ROWS with RETURNING
-- ============================================================================

/**
 * RETURNING clause returns the inserted values for all rows.
 * Useful for getting auto-generated IDs.
 */

-- Clear existing data
TRUNCATE orders RESTART IDENTITY;

-- Insert multiple orders and return all inserted data
INSERT INTO orders (customer_name, product_name, quantity) VALUES
    ('Ayaan', 'Laptop', 1),
    ('Sneha', 'Mouse', 2),
    ('Rohit', 'Keyboard', 1),
    ('Priya', 'Monitor', 1),
    ('Neha', 'Headphones', 2)
RETURNING *;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬──────────┬────────────┬─────────┐
 * │ order_id │ customer_name │ product_name │ quantity │ order_date │ status  │
 * ├──────────┼───────────────┼──────────────┼──────────┼────────────┼─────────┤
 * │ 1        │ Ayaan         │ Laptop       │ 1        │ 2024-01-15 │ PENDING │
 * │ 2        │ Sneha         │ Mouse        │ 2        │ 2024-01-15 │ PENDING │
 * │ 3        │ Rohit         │ Keyboard     │ 1        │ 2024-01-15 │ PENDING │
 * │ 4        │ Priya         │ Monitor      │ 1        │ 2024-01-15 │ PENDING │
 * │ 5        │ Neha          │ Headphones   │ 2        │ 2024-01-15 │ PENDING │
 * └──────────┴───────────────┴──────────────┴──────────┴────────────┴─────────┘
 */

-- Insert multiple and return only specific columns
INSERT INTO orders (customer_name, product_name, quantity, status) VALUES
    ('Ayaan', 'USB Cable', 3, 'CONFIRMED'),
    ('Sneha', 'Mouse Pad', 1, 'CONFIRMED')
RETURNING order_id, customer_name, status;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬───────────┐
 * │ order_id │ customer_name │ status    │
 * ├──────────┼───────────────┼───────────┤
 * │ 6        │ Ayaan         │ CONFIRMED │
 * │ 7        │ Sneha         │ CONFIRMED │
 * └──────────┴───────────────┴───────────┘
 */

-- ============================================================================
-- PART 5: INSERT MULTIPLE ROWS with DEFAULT
-- ============================================================================

/**
 * Use DEFAULT keyword for columns with default values.
 */

-- Clear existing data
TRUNCATE employees RESTART IDENTITY;

-- Insert multiple employees using DEFAULT for some columns
INSERT INTO employees (name, department, salary, hire_date) VALUES
    ('Alice', 'IT', 75000, DEFAULT),        -- hire_date will be NULL
    ('Bob', 'HR', 65000, '2024-01-10'),
    ('Carol', 'IT', DEFAULT, '2024-01-12'), -- salary will be NULL
    ('Dave', 'Finance', 80000, DEFAULT);

SELECT * FROM employees;

/**
 * OUTPUT:
 * ┌────────┬─────────┬────────────┬─────────┬────────────┐
 * │ emp_id │ name    │ department │ salary  │ hire_date  │
 * ├────────┼─────────┼────────────┼─────────┼────────────┤
 * │ 1      │ Alice   │ IT         │ 75000.00│ NULL       │
 * │ 2      │ Bob     │ HR         │ 65000.00│ 2024-01-10 │
 * │ 3      │ Carol   │ IT         │ NULL    │ 2024-01-12 │
 * │ 4      │ Dave    │ Finance    │ 80000.00│ NULL       │
 * └────────┴─────────┴────────────┴─────────┴────────────┘
 */

-- ============================================================================
-- PART 6: INSERT MULTIPLE ROWS from SELECT
-- ============================================================================

/**
 * Insert multiple rows from the result of a SELECT query.
 * Great for copying or transforming data.
 */

-- First, populate temp_data
TRUNCATE temp_data;

INSERT INTO temp_data (id, name, value) VALUES
    (1, 'Product A', 100.50),
    (2, 'Product B', 200.75),
    (3, 'Product C', 150.25),
    (4, 'Product D', 300.00),
    (5, 'Product E', 250.50);

-- Insert into products from temp_data (with transformation)
INSERT INTO products (product_name, price, stock_quantity)
SELECT 
    name AS product_name,
    value AS price,
    10 AS stock_quantity
FROM temp_data
WHERE value > 150;

SELECT product_name, price, stock_quantity FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬─────────────────┐
 * │ product_name │ price   │ stock_quantity  │
 * ├──────────────┼─────────┼─────────────────┤
 * │ Product B    │ 200.75  │ 10              │
 * │ Product D    │ 300.00  │ 10              │
 * │ Product E    │ 250.50  │ 10              │
 * └──────────────┴─────────┴─────────────────┘
 * 
 * EXPLANATION:
 * - Only products with value > 150 were inserted
 * - Product A (100.50) and Product C (150.25) were NOT inserted
 * - stock_quantity was set to 10 for all
 */

-- Copy all data from one table to another
CREATE TABLE products_backup AS SELECT * FROM products WHERE 1=0;  -- Create empty copy

INSERT INTO products_backup 
SELECT * FROM products
WHERE category = 'Electronics';

SELECT * FROM products_backup;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬──────────────┬─────────┬─────────────────┬──────────┐
 * │ product_id │ product_name │ category     │ price   │ stock_quantity  │ in_stock │
 * ├────────────┼──────────────┼──────────────┼─────────┼─────────────────┼──────────┤
 * │ 1          │ Laptop       │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 2          │ Mouse        │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 3          │ Keyboard     │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 4          │ Monitor      │ Electronics  │ 0.00    │ 0               │ true     │
 * └────────────┴──────────────┴──────────────┴─────────┴─────────────────┴──────────┘
 */

-- ============================================================================
-- PART 7: INSERT MULTIPLE ROWS with CONFLICT (UPSERT - PostgreSQL)
-- ============================================================================

/**
 * ON CONFLICT handles duplicate key violations.
 * Useful for "Insert or Update" operations.
 */

-- Clear existing data
TRUNCATE students RESTART IDENTITY;

-- Insert initial data with unique emails
INSERT INTO students (name, age, email) VALUES
    ('Ayaan', 20, 'ayaan@email.com'),
    ('Sneha', 22, 'sneha@email.com');

-- Insert new students, but if email exists, update the name
INSERT INTO students (name, age, email) VALUES
    ('Ayaan Khan', 20, 'ayaan@email.com'),     -- email exists
    ('Rohit', 21, 'rohit@email.com'),          -- new email
    ('Priya', 23, 'priya@email.com')           -- new email
ON CONFLICT (email) 
DO UPDATE SET name = EXCLUDED.name;

SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name        │ age │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │ 1          │ Ayaan Khan  │ 20  │ NULL  │ 2024-01-15      │ ayaan@email.com     │
 * │ 2          │ Sneha       │ 22  │ NULL  │ 2024-01-15      │ sneha@email.com     │
 * │ 4          │ Rohit       │ 21  │ NULL  │ 2024-01-15      │ rohit@email.com     │
 * │ 5          │ Priya       │ 23  │ NULL  │ 2024-01-15      │ priya@email.com     │
 * └────────────┴─────────────┴─────┴───────┴─────────────────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Ayaan's name was updated from 'Ayaan' to 'Ayaan Khan' (email conflict)
 * - Sneha remained unchanged (no conflict)
 * - Rohit and Priya were inserted as new rows
 * - student_id 3 was skipped (conflict, didn't create new ID)
 */

-- INSERT with ON CONFLICT DO NOTHING (skip duplicates)
INSERT INTO students (name, email) VALUES
    ('Neha', 'neha@email.com'),
    ('Raj', 'ayaan@email.com'),    -- email exists - will be skipped
    ('Rajesh', 'rajesh@email.com')
ON CONFLICT (email) DO NOTHING
RETURNING *;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬──────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name    │ age  │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────┼──────┼───────┼─────────────────┼─────────────────────┤
 * │ 6          │ Neha    │ NULL │ NULL  │ 2024-01-15      │ neha@email.com      │
 * │ 8          │ Rajesh  │ NULL │ NULL  │ 2024-01-15      │ rajesh@email.com    │
 * └────────────┴─────────┴──────┴───────┴─────────────────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - Neha inserted (student_id 6)
 * - Raj skipped (email ayaan@email.com already exists)
 * - Rajesh inserted (student_id 8, note 7 was skipped due to conflict)
 */

-- ============================================================================
-- PART 8: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Bulk Student Enrollment
 * 
 * School enrolls multiple new students at once
 */

TRUNCATE students RESTART IDENTITY;

-- Enroll a batch of new students
INSERT INTO students (name, age, grade, email) VALUES
    ('Ayaan Khan', 20, 'A', 'ayaan.khan@school.edu'),
    ('Sneha Patel', 22, 'B', 'sneha.patel@school.edu'),
    ('Rohit Sharma', 21, 'A', 'rohit.sharma@school.edu'),
    ('Priya Singh', 23, 'B', 'priya.singh@school.edu'),
    ('Neha Verma', 24, 'A', 'neha.verma@school.edu'),
    ('Raj Malhotra', 20, 'C', 'raj.malhotra@school.edu')
RETURNING student_id, name, grade;

/**
 * OUTPUT:
 * ┌────────────┬───────────────┬───────┐
 * │ student_id │ name          │ grade │
 * ├────────────┼───────────────┼───────┤
 * │ 1          │ Ayaan Khan    │ A     │
 * │ 2          │ Sneha Patel   │ B     │
 * │ 3          │ Rohit Sharma  │ A     │
 * │ 4          │ Priya Singh   │ B     │
 * │ 5          │ Neha Verma    │ A     │
 * │ 6          │ Raj Malhotra  │ C     │
 * └────────────┴───────────────┴───────┘
 */

/**
 * SCENARIO 2: Bulk Product Inventory Update
 * 
 * Warehouse receives new stock of multiple products
 */

TRUNCATE products RESTART IDENTITY;

-- Add new products with initial stock
INSERT INTO products (product_name, category, price, stock_quantity, in_stock) VALUES
    ('iPhone 15', 'Electronics', 79999.99, 50, TRUE),
    ('Samsung Galaxy S24', 'Electronics', 74999.99, 35, TRUE),
    ('Sony Headphones', 'Accessories', 2999.99, 100, TRUE),
    ('Logitech Mouse', 'Electronics', 1499.99, 200, TRUE),
    ('Dell Monitor', 'Electronics', 24999.99, 25, TRUE),
    ('USB-C Cable', 'Accessories', 499.99, 500, TRUE),
    ('Laptop Bag', 'Accessories', 1999.99, 75, TRUE),
    ('Wireless Charger', 'Accessories', 2499.99, 150, TRUE);

SELECT product_name, price, stock_quantity FROM products
ORDER BY price DESC;

/**
 * OUTPUT:
 * ┌─────────────────────┬─────────┬─────────────────┐
 * │ product_name        │ price   │ stock_quantity  │
 * ├─────────────────────┼─────────┼─────────────────┤
 * │ iPhone 15           │ 79999.99│ 50              │
 * │ Samsung Galaxy S24  │ 74999.99│ 35              │
 * │ Dell Monitor        │ 24999.99│ 25              │
 * │ Sony Headphones     │ 2999.99 │ 100             │
 * │ Wireless Charger    │ 2499.99 │ 150             │
 * │ Laptop Bag          │ 1999.99 │ 75              │
 * │ Logitech Mouse      │ 1499.99 │ 200             │
 * │ USB-C Cable         │ 499.99  │ 500             │
 * └─────────────────────┴─────────┴─────────────────┘
 */

/**
 * SCENARIO 3: Bulk Order Import
 * 
 * Import multiple orders from a file or another system
 */

TRUNCATE orders RESTART IDENTITY;

-- Import bulk orders
INSERT INTO orders (customer_name, product_name, quantity, status, order_date) VALUES
    ('Ayaan', 'iPhone 15', 1, 'DELIVERED', '2024-01-10'),
    ('Sneha', 'Samsung Galaxy S24', 1, 'DELIVERED', '2024-01-11'),
    ('Rohit', 'Sony Headphones', 2, 'SHIPPED', '2024-01-12'),
    ('Priya', 'Logitech Mouse', 3, 'PENDING', '2024-01-13'),
    ('Neha', 'Dell Monitor', 1, 'DELIVERED', '2024-01-14'),
    ('Raj', 'USB-C Cable', 5, 'PENDING', '2024-01-15'),
    ('Ayaan', 'Wireless Charger', 2, 'SHIPPED', '2024-01-16'),
    ('Sneha', 'Laptop Bag', 1, 'DELIVERED', '2024-01-17')
RETURNING order_id, customer_name, product_name, status;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬─────────────────────┬───────────┐
 * │ order_id │ customer_name │ product_name        │ status    │
 * ├──────────┼───────────────┼─────────────────────┼───────────┤
 * │ 1        │ Ayaan         │ iPhone 15           │ DELIVERED │
 * │ 2        │ Sneha         │ Samsung Galaxy S24  │ DELIVERED │
 * │ 3        │ Rohit         │ Sony Headphones     │ SHIPPED   │
 * │ 4        │ Priya         │ Logitech Mouse      │ PENDING   │
 * │ 5        │ Neha          │ Dell Monitor        │ DELIVERED │
 * │ 6        │ Raj           │ USB-C Cable         │ PENDING   │
 * │ 7        │ Ayaan         │ Wireless Charger    │ SHIPPED   │
 * │ 8        │ Sneha         │ Laptop Bag          │ DELIVERED │
 * └──────────┴───────────────┴─────────────────────┴───────────┘
 */

/**
 * SCENARIO 4: Employee Data Migration
 * 
 * Migrate employee data from legacy system
 */

TRUNCATE employees RESTART IDENTITY;

-- Insert multiple employees from legacy data
INSERT INTO employees (name, department, salary, hire_date) VALUES
    ('Alice Johnson', 'Engineering', 95000, '2022-01-15'),
    ('Bob Smith', 'Sales', 75000, '2022-02-20'),
    ('Carol Davis', 'Marketing', 82000, '2022-03-10'),
    ('David Wilson', 'Engineering', 88000, '2022-04-05'),
    ('Emma Brown', 'HR', 68000, '2022-05-12'),
    ('Frank Miller', 'Sales', 78000, '2022-06-18'),
    ('Grace Lee', 'Engineering', 92000, '2022-07-22'),
    ('Henry Taylor', 'Finance', 85000, '2022-08-30');

SELECT department, COUNT(*) as emp_count, AVG(salary) as avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

/**
 * OUTPUT:
 * ┌─────────────┬───────────┬─────────────┐
 * │ department  │ emp_count │ avg_salary  │
 * ├─────────────┼───────────┼─────────────┤
 * │ Engineering │ 3         │ 91666.67    │
 * │ Finance     │ 1         │ 85000.00    │
 * │ Marketing   │ 1         │ 82000.00    │
 * │ Sales       │ 2         │ 76500.00    │
 * │ HR          │ 1         │ 68000.00    │
 * └─────────────┴───────────┴─────────────┘
 */

/**
 * SCENARIO 5: Seasonal Product Launch
 * 
 * Launch multiple new products for holiday season
 */

TRUNCATE products RESTART IDENTITY;

-- Holiday season product launch
INSERT INTO products (product_name, category, price, stock_quantity, in_stock) VALUES
    ('Christmas Tree', 'Holiday', 4999.99, 200, TRUE),
    ('String Lights', 'Holiday', 999.99, 1000, TRUE),
    ('Ornaments Set', 'Holiday', 1499.99, 500, TRUE),
    ('Gift Wrapping Kit', 'Holiday', 299.99, 2000, TRUE),
    ('Stockings', 'Holiday', 399.99, 800, TRUE),
    ('Santa Hat', 'Holiday', 199.99, 1500, TRUE),
    ('Advent Calendar', 'Holiday', 2499.99, 300, TRUE),
    ('Snow Globe', 'Holiday', 799.99, 400, TRUE)
RETURNING product_id, product_name, price;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬─────────┐
 * │ product_id │ product_name        │ price   │
 * ├────────────┼─────────────────────┼─────────┤
 * │ 1          │ Christmas Tree      │ 4999.99 │
 * │ 2          │ String Lights       │ 999.99  │
 * │ 3          │ Ornaments Set       │ 1499.99 │
 * │ 4          │ Gift Wrapping Kit   │ 299.99  │
 * │ 5          │ Stockings           │ 399.99  │
 * │ 6          │ Santa Hat           │ 199.99  │
 * │ 7          │ Advent Calendar     │ 2499.99 │
 * │ 8          │ Snow Globe          │ 799.99  │
 * └────────────┴─────────────────────┴─────────┘
 */

-- ============================================================================
-- PART 9: PERFORMANCE COMPARISON
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              SINGLE INSERT vs MULTIPLE ROW INSERT                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SINGLE INSERTS (100 rows):                                            │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 100 separate INSERT statements                                   │   │
 * │   │ 100 network round trips                                          │   │
 * │   │ 100 transaction logs                                             │   │
 * │   │ Time: ~500-1000ms                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   MULTIPLE ROW INSERT (100 rows):                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1 INSERT statement with 100 value sets                          │   │
 * │   │ 1 network round trip                                            │   │
 * │   │ 1 transaction log                                               │   │
 * │   │ Time: ~50-100ms                                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   RESULT: Multiple row insert is 5-10 times FASTER!                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Missing comma between value sets                           │
 * │                                                                          │
 * │   ❌ INSERT INTO students (name) VALUES                                 │
 * │        ('Ayaan')                                                       │
 * │        ('Sneha')        ← Missing comma!                               │
 * │        ('Rohit');                                                      │
 * │                                                                          │
 * │   ✅ INSERT INTO students (name) VALUES                                 │
 * │        ('Ayaan'),                                                      │
 * │        ('Sneha'),                                                      │
 * │        ('Rohit');                                                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Different number of values per row                         │
 * │                                                                          │
 * │   ❌ INSERT INTO students (name, age) VALUES                            │
 * │        ('Ayaan', 20),                                                  │
 * │        ('Sneha'),           ← Missing age!                             │
 * │        ('Rohit', 21);                                                  │
 * │                                                                          │
 * │   ✅ Each row must have same number of values                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ──────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Exceeding maximum values per INSERT                        │
 * │                                                                          │
 * │   Different databases have limits on how many rows you can insert      │
 * │   at once. PostgreSQL default is 1000 rows recommended.                │
 * │                                                                          │
 * │   ✅ For very large inserts, use COPY or batch in chunks of 1000       │
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
 * │ RULE 1: Use multiple row INSERT for better performance                 │
 * │         → One round trip instead of many                               │
 * │         → 5-10x faster for bulk inserts                                │
 * │                                                                          │
 * │ RULE 2: Always specify column names                                     │
 * │         → INSERT INTO table (col1, col2) VALUES (val1, val2), ...      │
 * │         → Safer and more readable                                      │
 * │                                                                          │
 * │ RULE 3: Separate value sets with commas                                │
 * │         → (val1, val2), (val3, val4), (val5, val6)                     │
 * │                                                                          │
 * │ RULE 4: Each row must have same number of values                       │
 * │         → All rows in the same INSERT must have identical structure    │
 * │                                                                          │
 * │ RULE 5: Use RETURNING to get back inserted data                        │
 * │         → Especially useful for auto-generated IDs                     │
 * │                                                                          │
 * │ RULE 6: For very large inserts (1000+ rows), use COPY                  │
 * │         → COPY is even faster than multiple row INSERT                 │
 * │                                                                          │
 * │ RULE 7: Use ON CONFLICT to handle duplicates                           │
 * │         → INSERT ... ON CONFLICT (unique_col) DO UPDATE/NOTHING        │
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
 * │ -- Insert multiple rows (basic)                                        │
 * │ INSERT INTO table (col1, col2) VALUES                                  │
 * │     (val1, val2),                                                      │
 * │     (val3, val4),                                                      │
 *     │     (val5, val6);                                                    │
 * │                                                                          │
 * │ -- Insert multiple with RETURNING                                      │
 * │ INSERT INTO table (col1, col2) VALUES                                  │
 * │     (val1, val2),                                                      │
 * │     (val3, val4)                                                       │
 * │ RETURNING *;                                                           │
 * │                                                                          │
 * │ -- Insert multiple from SELECT                                         │
 * │ INSERT INTO table1 (col1, col2)                                        │
 * │ SELECT col1, col2 FROM table2 WHERE condition;                         │
 * │                                                                          │
 * │ -- Insert multiple with ON CONFLICT (UPSERT)                           │
 * │ INSERT INTO table (id, name) VALUES                                    │
 * │     (1, 'A'),                                                          │
 * │     (2, 'B'),                                                          │
 * │     (3, 'C')                                                           │
 * │ ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;                   │
 * │                                                                          │
 * │ -- Insert multiple with ON CONFLICT DO NOTHING                         │
 * │ INSERT INTO table (id, name) VALUES                                    │
 * │     (1, 'A'),                                                          │
 * │     (2, 'B'),                                                          │
 *     │     (3, 'C')                                                           │
 * │ ON CONFLICT (id) DO NOTHING;                                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Insert 3 new students at once
 * 
 * Answer:
 *   INSERT INTO students (name, age, grade) VALUES
 *       ('John', 19, 'A'),
 *       ('Jane', 20, 'B'),
 *       ('Jim', 21, 'A');
 */

/**
 * EXERCISE 2: Insert multiple products with prices
 * 
 * Answer:
 *   INSERT INTO products (product_name, price) VALUES
 *       ('Tablet', 15000),
 *       ('Smartwatch', 5000),
 *       ('Power Bank', 1500);
 */

/**
 * EXERCISE 3: Insert multiple orders and return order_ids
 * 
 * Answer:
 *   INSERT INTO orders (customer_name, product_name, quantity) VALUES
 *       ('Ayaan', 'Laptop', 1),
 *       ('Sneha', 'Mouse', 2)
 *   RETURNING order_id;
 */

/**
 * EXERCISE 4: Insert from temp_data into products (price > 200)
 * 
 * Answer:
 *   INSERT INTO products (product_name, price)
 *   SELECT name, value FROM temp_data WHERE value > 200;
 */

/**
 * EXERCISE 5: Insert with ON CONFLICT (update if exists)
 * 
 * Answer:
 *   INSERT INTO students (email, name) VALUES
 *       ('ayaan@email.com', 'Ayaan Khan'),
 *       ('new@email.com', 'New Student')
 *   ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS products_backup;
DROP TABLE IF EXISTS temp_data;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS students;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. Multiple row INSERT adds several rows in ONE command                │
 * │                                                                          │
 * │ 2. Syntax:                                                              │
 * │    INSERT INTO table (col1, col2) VALUES                               │
 * │        (val1, val2),                                                   │
 * │        (val3, val4),                                                   │
 * │        (val5, val6);                                                   │
 * │                                                                          │
 * │ 3. Benefits:                                                            │
 * │    → 5-10x faster than single inserts                                  │
 * │    → Less network traffic                                              │
 * │    → Atomic (all or nothing)                                           │
 * │    → Cleaner code                                                      │
 * │                                                                          │
 * │ 4. Use RETURNING to get back inserted data                             │
 * │                                                                          │
 * │ 5. Use INSERT FROM SELECT to copy/transform data                       │
 * │                                                                          │
 * │ 6. Use ON CONFLICT for "UPSERT" (update if exists, insert if not)      │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always specify column names                                        │
 * │   - Separate value sets with commas                                    │
 * │   - Each row must have same number of values                           │
 * │   - For 1000+ rows, consider using COPY                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF INSERT MULTIPLE ROWS GUIDE
-- ============================================================================