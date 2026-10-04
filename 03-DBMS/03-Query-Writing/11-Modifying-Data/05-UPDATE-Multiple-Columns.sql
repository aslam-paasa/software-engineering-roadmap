/**
 * ============================================================================
 * UPDATE MULTIPLE COLUMNS - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS UPDATE MULTIPLE COLUMNS? ------- (Update several columns at once)
 * 2. UPDATE MULTIPLE COLUMNS - BASIC -------- (Simple multi-column updates)
 * 3. UPDATE with WHERE on Multiple Columns --- (Filter by multiple conditions)
 * 4. UPDATE with Expressions ---------------- (Calculations on multiple columns)
 * 5. UPDATE with RETURNING ------------------ (See all updated columns)
 * 6. UPDATE with NULL and DEFAULT ----------- (Set multiple to NULL/DEFAULT)
 * 7. UPDATE with CASE (Multiple Columns) ---- (Conditional updates on many columns)
 * 8. UPDATE with Subquery ------------------- (Use values from another table)
 * 9. UPDATE Multiple Rows Differently ------- (Different values for different rows)
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
 * TABLE 1: STUDENTS - Student information
 */

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    grade VARCHAR(2),
    email VARCHAR(100),
    city VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE
);

/**
 * TABLE 2: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    discount DECIMAL(5,2) DEFAULT 0,
    stock_quantity INT,
    category VARCHAR(50)
);

/**
 * TABLE 3: EMPLOYEES - Employee information
 */

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    department VARCHAR(50),
    performance_rating INT,
    bonus DECIMAL(10,2) DEFAULT 0
);

/**
 * TABLE 4: ORDERS - Order information
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    product_name VARCHAR(50),
    quantity INT,
    order_status VARCHAR(20),
    total_amount DECIMAL(10,2)
);

/**
 * TABLE 5: PRICE_UPDATES - For subquery example
 */

CREATE TABLE price_updates (
    product_name VARCHAR(100),
    new_price DECIMAL(10,2),
    new_discount DECIMAL(5,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert sample data into students
INSERT INTO students (name, age, grade, email, city) VALUES
('Ayaan', 20, 'A', 'ayaan@email.com', 'Mumbai'),
('Sneha', 22, 'B', 'sneha@email.com', 'Delhi'),
('Rohit', 21, 'A', 'rohit@email.com', 'Bangalore'),
('Priya', 23, 'C', 'priya@email.com', 'Chennai'),
('Neha', 24, 'B', 'neha@email.com', 'Pune'),
('Raj', 20, 'C', 'raj@email.com', 'Ahmedabad');

-- Insert sample data into products
INSERT INTO products (product_name, price, discount, stock_quantity, category) VALUES
('Laptop', 50000, 0, 10, 'Electronics'),
('Mouse', 500, 0, 50, 'Electronics'),
('Keyboard', 1500, 0, 30, 'Electronics'),
('Monitor', 10000, 5, 5, 'Electronics'),
('Headphones', 2000, 0, 20, 'Accessories');

-- Insert sample data into employees
INSERT INTO employees (name, salary, department, performance_rating) VALUES
('Alice', 75000, 'IT', 3),
('Bob', 65000, 'HR', 4),
('Carol', 80000, 'IT', 5),
('Dave', 70000, 'Finance', 3);

-- Insert sample data into orders
INSERT INTO orders (customer_name, product_name, quantity, order_status, total_amount) VALUES
('Ayaan', 'Laptop', 1, 'PENDING', 50000),
('Sneha', 'Keyboard', 2, 'DELIVERED', 3000),
('Rohit', 'Mouse', 3, 'PENDING', 1500),
('Priya', 'Monitor', 1, 'CANCELLED', 10000);

-- Insert sample data into price_updates
INSERT INTO price_updates (product_name, new_price, new_discount) VALUES
('Laptop', 45000, 10),
('Monitor', 9000, 15);

-- ============================================================================
-- PART 1: WHAT IS UPDATE MULTIPLE COLUMNS?
-- ============================================================================

/**
 * UPDATE multiple columns changes several columns in the same row(s) at once.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE MULTIPLE COLUMNS - EXPLANATION                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE table_name                                               │   │
 * │   │ SET column1 = value1,                                           │   │
 * │   │     column2 = value2,                                           │   │
 * │   │     column3 = value3                                            │   │
 * │   │ WHERE condition;                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SINGLE COLUMN UPDATE (Two separate statements):                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students SET grade = 'A' WHERE student_id = 1;           │   │
 * │   │ UPDATE students SET city = 'Mumbai' WHERE student_id = 1;       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   MULTIPLE COLUMN UPDATE (One statement - BETTER!):                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students                                                 │   │
 * │   │ SET grade = 'A',                                                │   │
 * │   │     city = 'Mumbai'                                             │   │
 * │   │ WHERE student_id = 1;                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ADVANTAGES OF MULTIPLE COLUMN UPDATE:                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. FASTER - One database round trip instead of many            │   │
 * │   │ 2. ATOMIC - All updates happen together (or not at all)        │   │
 * │   │ 3. CLEANER - Less code, easier to read                         │   │
 * │   │ 4. CONSISTENT - No partial updates if one column fails         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE MULTIPLE COLUMNS - EXAMPLE                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE UPDATE:                                                        │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────┐   │
 * │   │ student_id │ name    │ age │ grade │ email           │ city    │   │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────┤   │
 * │   │ 1          │ Ayaan   │ 20  │ A     │ ayaan@email.com │ Mumbai  │   │
 * │   │ 2          │ Sneha   │ 22  │ B     │ sneha@email.com │ Delhi   │   │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴─────────┘   │
 * │                                                                          │
 * │   UPDATE COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students                                                 │   │
 * │   │ SET grade = 'A+',                                               │   │
 * │   │     city = 'New Mumbai',                                        │   │
 * │   │     age = 21                                                    │   │
 * │   │ WHERE student_id = 1;                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER UPDATE:                                                         │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬────────────┐│
 * │   │ student_id │ name    │ age │ grade │ email           │ city       ││
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼────────────┤│
 * │   │ 1          │ Ayaan   │ 21  │ A+    │ ayaan@email.com │ New Mumbai ││
 * │   │ 2          │ Sneha   │ 22  │ B     │ sneha@email.com │ Delhi      ││
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴────────────┘│
 * │                                                                          │
 * │   EXPLANATION: Three columns (grade, city, age) updated in one command. │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: UPDATE MULTIPLE COLUMNS - BASIC
-- ============================================================================

-- Show current data
SELECT student_id, name, grade, city, age FROM students WHERE student_id = 1;

/**
 * CURRENT DATA:
 * ┌────────────┬─────────┬───────┬─────────┬─────┐
 * │ student_id │ name    │ grade │ city    │ age │
 * ├────────────┼─────────┼───────┼─────────┼─────┤
 * │ 1          │ Ayaan   │ A     │ Mumbai  │ 20  │
 * └────────────┴─────────┴───────┴─────────┴─────┘
 */

-- EXAMPLE 1: Update multiple columns for a single student
UPDATE students 
SET grade = 'A+', 
    city = 'South Mumbai', 
    age = 21
WHERE student_id = 1;

-- Verify the update
SELECT student_id, name, grade, city, age FROM students WHERE student_id = 1;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┬──────────────┬─────┐
 * │ student_id │ name    │ grade │ city         │ age │
 * ├────────────┼─────────┼───────┼──────────────┼─────┤
 * │ 1          │ Ayaan   │ A+    │ South Mumbai │ 21  │
 * └────────────┴─────────┴───────┴──────────────┴─────┘
 */

-- EXAMPLE 2: Update multiple columns for another student
UPDATE students 
SET grade = 'B+', 
    email = 'sneha.new@email.com'
WHERE student_id = 2;

SELECT student_id, name, grade, email FROM students WHERE student_id = 2;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┬─────────────────────┐
 * │ student_id │ name    │ grade │ email               │
 * ├────────────┼─────────┼───────┼─────────────────────┤
 * │ 2          │ Sneha   │ B+    │ sneha.new@email.com │
 * └────────────┴─────────┴───────┴─────────────────────┘
 */

-- ============================================================================
-- PART 3: UPDATE with WHERE on Multiple Columns
-- ============================================================================

/**
 * Use WHERE with multiple conditions to filter which rows to update.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE with WHERE on Multiple Columns                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE UPDATE:                                                        │
 * │   ┌────────────┬─────────┬─────────┬───────────┬─────────┐             │
 * │   │ product_id │ name    │ price   │ discount  │ category│             │
 * │   ├────────────┼─────────┼─────────┼───────────┼─────────┤             │
 * │   │ 1          │ Laptop  │ 50000   │ 0         │ Elec    │             │
 * │   │ 2          │ Mouse   │ 500     │ 0         │ Elec    │             │
 * │   │ 3          │ Keyboard│ 1500    │ 0         │ Elec    │             │
 * │   │ 4          │ Monitor │ 10000   │ 5         │ Elec    │             │
 * │   └────────────┴─────────┴─────────┴───────────┴─────────┘             │
 * │                                                                          │
 * │   UPDATE COMMAND: Update Electronics products with price > 5000         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE products                                                 │   │
 * │   │ SET discount = 10,                                              │   │
 * │   │     price = price * 0.95                                        │   │
 * │   │ WHERE category = 'Electronics' AND price > 5000;                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER UPDATE:                                                         │
 * │   ┌────────────┬─────────┬─────────┬───────────┬─────────┐             │
 * │   │ product_id │ name    │ price   │ discount  │ category│             │
 * │   ├────────────┼─────────┼─────────┼───────────┼─────────┤             │
 * │   │ 1          │ Laptop  │ 47500   │ 10        │ Elec    │ ← updated   │
 * │   │ 2          │ Mouse   │ 500     │ 0         │ Elec    │ ← unchanged │
 * │   │ 3          │ Keyboard│ 1500    │ 0         │ Elec    │ ← unchanged │
 * │   │ 4          │ Monitor │ 9500    │ 10        │ Elec    │ ← updated   │
 * │   └────────────┴─────────┴─────────┴───────────┴─────────┘             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Reset products to original values
UPDATE products SET price = 
    CASE product_name
        WHEN 'Laptop' THEN 50000
        WHEN 'Mouse' THEN 500
        WHEN 'Keyboard' THEN 1500
        WHEN 'Monitor' THEN 10000
        WHEN 'Headphones' THEN 2000
    END,
    discount = 0;

-- Update multiple columns for products matching multiple conditions
UPDATE products 
SET discount = 10,
    price = price * 0.90,
    stock_quantity = stock_quantity + 5
WHERE category = 'Electronics' AND price > 5000;

SELECT product_name, price, discount, stock_quantity FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┬─────────────────┐
 * │ product_name │ price   │ discount │ stock_quantity  │
 * ├──────────────┼─────────┼──────────┼─────────────────┤
 * │ Laptop       │ 45000.00│ 10       │ 15              │ ← updated
 * │ Mouse        │ 500.00  │ 0        │ 50              │ ← unchanged
 * │ Keyboard     │ 1500.00 │ 0        │ 30              │ ← unchanged
 * │ Monitor      │ 9000.00 │ 10       │ 10              │ ← updated
 * │ Headphones   │ 2000.00 │ 0        │ 20              │ ← unchanged
 * └──────────────┴─────────┴──────────┴─────────────────┘
 */

-- Update students based on multiple conditions
UPDATE students 
SET is_active = FALSE,
    email = NULL
WHERE city = 'Delhi' OR grade = 'C';

SELECT student_id, name, city, grade, is_active, email FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────┬───────┬───────────┬─────────────────────┐
 * │ student_id │ name    │ city    │ grade │ is_active │ email               │
 * ├────────────┼─────────┼─────────┼───────┼───────────┼─────────────────────┤
 * │ 1          │ Ayaan   │ S Mumbai│ A+    │ true      │ ayaan@email.com     │
 * │ 2          │ Sneha   │ Delhi   │ B+    │ false     │ NULL                │ ← updated
 * │ 3          │ Rohit   │ Banglore│ A     │ true      │ rohit@email.com     │
 * │ 4          │ Priya   │ Chennai │ C     │ false     │ NULL                │ ← updated
 * │ 5          │ Neha    │ Pune    │ B     │ true      │ neha@email.com      │
 * │ 6          │ Raj     │ Ahmedabad│ C    │ false     │ NULL                │ ← updated
 * └────────────┴─────────┴─────────┴───────┴───────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 4: UPDATE with Expressions (Calculations on multiple columns)
-- ============================================================================

/**
 * Use mathematical expressions and functions when updating multiple columns.
 */

-- Reset data
UPDATE employees SET 
    salary = CASE name
        WHEN 'Alice' THEN 75000
        WHEN 'Bob' THEN 65000
        WHEN 'Carol' THEN 80000
        WHEN 'Dave' THEN 70000
    END,
    bonus = 0,
    performance_rating = CASE name
        WHEN 'Alice' THEN 3
        WHEN 'Bob' THEN 4
        WHEN 'Carol' THEN 5
        WHEN 'Dave' THEN 3
    END;

-- Give salary increase and bonus based on performance
UPDATE employees 
SET salary = salary * (1 + performance_rating * 0.02),
    bonus = salary * (performance_rating * 0.05),
    department = CASE 
        WHEN performance_rating >= 4 THEN 'Senior ' || department
        ELSE department
    END
WHERE performance_rating >= 3;

SELECT name, department, salary, bonus FROM employees;

/**
 * OUTPUT:
 * ┌─────────┬─────────────────┬─────────┬─────────┐
 * │ name    │ department      │ salary  │ bonus   │
 * ├─────────┼─────────────────┼─────────┼─────────┤
 * │ Alice   │ Senior IT       │ 79500.00│ 11250.00│
 * │ Bob     │ Senior HR       │ 70200.00│ 16250.00│
 * │ Carol   │ Senior IT       │ 88000.00│ 20000.00│
 * │ Dave    │ Finance         │ 74200.00│ 10500.00│
 * └─────────┴─────────────────┴─────────┴─────────┘
 */

-- Update product prices with complex calculations
UPDATE products 
SET price = price * 0.90,
    discount = discount + 5,
    stock_quantity = stock_quantity - 2
WHERE category = 'Electronics' AND stock_quantity > 5;

SELECT product_name, price, discount, stock_quantity FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┬─────────────────┐
 * │ product_name │ price   │ discount │ stock_quantity  │
 * ├──────────────┼─────────┼──────────┼─────────────────┤
 * │ Laptop       │ 40500.00│ 15       │ 13              │
 * │ Mouse        │ 450.00  │ 5        │ 48              │
 * │ Keyboard     │ 1350.00 │ 5        │ 28              │
 * │ Monitor      │ 8100.00 │ 15       │ 8               │
 * │ Headphones   │ 2000.00 │ 0        │ 20              │
 * └──────────────┴─────────┴──────────┴─────────────────┘
 */

-- ============================================================================
-- PART 5: UPDATE with RETURNING (See all updated columns)
-- ============================================================================

/**
 * RETURNING shows all updated values (old vs new can be compared).
 */

-- Update multiple columns and see what changed
UPDATE students 
SET age = age + 1,
    grade = 'A',
    city = UPPER(city)
WHERE student_id = 1
RETURNING student_id, name, age, grade, city;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬───────┬──────────────┐
 * │ student_id │ name    │ age │ grade │ city         │
 * ├────────────┼─────────┼─────┼───────┼──────────────┤
 * │ 1          │ Ayaan   │ 22  │ A     │ SOUTH MUMBAI │
 * └────────────┴─────────┴─────┴───────┴──────────────┘
 */

-- Update multiple rows and see all updated rows
UPDATE products 
SET price = price * 0.95,
    discount = discount + 2
WHERE category = 'Electronics' AND price > 1000
RETURNING product_name, price, discount;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┐
 * │ product_name │ price   │ discount │
 * ├──────────────┼─────────┼──────────┤
 * │ Laptop       │ 38475.00│ 17       │
 * │ Keyboard     │ 1282.50 │ 7        │
 * │ Monitor      │ 7695.00 │ 17       │
 * └──────────────┴─────────┴──────────┘
 */

-- Update with RETURNING * (all columns)
UPDATE employees 
SET salary = salary * 1.05,
    bonus = bonus + 5000
WHERE department LIKE 'Senior%'
RETURNING *;

/**
 * OUTPUT:
 * ┌────────┬─────────┬─────────┬───────────────┬────────────────────┬─────────┐
 * │ emp_id │ name    │ salary  │ department    │ performance_rating │ bonus   │
 * ├────────┼─────────┼─────────┼───────────────┼────────────────────┼─────────┤
 * │ 1      │ Alice   │ 83475.00│ Senior IT     │ 3                  │ 16812.50│
 * │ 2      │ Bob     │ 73710.00│ Senior HR     │ 4                  │ 22062.50│
 * │ 3      │ Carol   │ 92400.00│ Senior IT     │ 5                  │ 26000.00│
 * └────────┴─────────┴─────────┴───────────────┴────────────────────┴─────────┘
 */

-- ============================================================================
-- PART 6: UPDATE with NULL and DEFAULT (Multiple columns)
-- ============================================================================

/**
 * Set multiple columns to NULL or DEFAULT values.
 */

-- Set multiple columns to NULL
UPDATE students 
SET email = NULL,
    city = NULL
WHERE student_id = 3;

SELECT student_id, name, email, city FROM students WHERE student_id = 3;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┬──────┐
 * │ student_id │ name    │ email │ city │
 * ├────────────┼─────────┼───────┼──────┤
 * │ 3          │ Rohit   │ NULL  │ NULL │
 * └────────────┴─────────┴───────┴──────┘
 */

-- Set multiple columns to DEFAULT values
UPDATE products 
SET discount = DEFAULT,
    stock_quantity = DEFAULT
WHERE product_name = 'Mouse';

SELECT product_name, discount, stock_quantity FROM products WHERE product_name = 'Mouse';

/**
 * OUTPUT:
 * ┌──────────────┬──────────┬─────────────────┐
 * │ product_name │ discount │ stock_quantity  │
 * ├──────────────┼──────────┼─────────────────┤
 * │ Mouse        │ 0        │ 0               │
 * └──────────────┴──────────┴─────────────────┘
 */

-- Mix of explicit values, NULL, and DEFAULT
UPDATE orders 
SET order_status = 'PROCESSING',
    notes = NULL,
    priority = DEFAULT
WHERE order_id = 1
RETURNING order_id, order_status, notes, priority;

-- Note: priority column not in original table, adding for demo
ALTER TABLE orders ADD COLUMN priority INT DEFAULT 1;
ALTER TABLE orders ADD COLUMN notes TEXT;

-- Now run the update
UPDATE orders 
SET order_status = 'PROCESSING',
    notes = NULL,
    priority = DEFAULT
WHERE order_id = 1
RETURNING order_id, order_status, notes, priority;

/**
 * OUTPUT:
 * ┌──────────┬──────────────┬───────┬──────────┐
 * │ order_id │ order_status │ notes │ priority │
 * ├──────────┼──────────────┼───────┼──────────┤
 * │ 1        │ PROCESSING   │ NULL  │ 1        │
 * └──────────┴──────────────┴───────┴──────────┘
 */

-- ============================================================================
-- PART 7: UPDATE with CASE (Multiple Columns, Conditional)
-- ============================================================================

/**
 * Use CASE to set different values for different rows.
 * You can have CASE for each column independently.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE with CASE on Multiple Columns                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: Give different salary increases AND different bonuses       │
 * │            based on performance rating                                 │
 * │                                                                          │
 * │   BEFORE:                                                               │
 * │   ┌─────────┬─────────────────┬─────────┬─────────┐                    │
 * │   │ name    │ department      │ salary  │ bonus   │                    │
 * │   ├─────────┼─────────────────┼─────────┼─────────┤                    │
 * │   │ Alice   │ Senior IT       │ 83475   │ 16812   │                    │
 * │   │ Bob     │ Senior HR       │ 73710   │ 22062   │                    │
 * │   │ Carol   │ Senior IT       │ 92400   │ 26000   │                    │
 * │   │ Dave    │ Finance         │ 74200   │ 10500   │                    │
 * │   └─────────┴─────────────────┴─────────┴─────────┘                    │
 * │                                                                          │
 * │   UPDATE COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE employees                                                │   │
 * │   │ SET salary = CASE                                               │   │
 * │   │         WHEN performance_rating >= 4 THEN salary * 1.10         │   │
 * │   │         ELSE salary * 1.05                                      │   │
 * │   │     END,                                                        │   │
 * │   │     bonus = CASE                                                │   │
 * │   │         WHEN performance_rating >= 4 THEN bonus * 1.5           │   │
 * │   │         ELSE bonus * 1.2                                       │   │
 * │   │     END                                                         │   │
 * │   │ WHERE department LIKE 'Senior%';                                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Reset employees data
UPDATE employees SET 
    salary = CASE name
        WHEN 'Alice' THEN 75000
        WHEN 'Bob' THEN 65000
        WHEN 'Carol' THEN 80000
        WHEN 'Dave' THEN 70000
    END,
    bonus = 0,
    performance_rating = CASE name
        WHEN 'Alice' THEN 3
        WHEN 'Bob' THEN 4
        WHEN 'Carol' THEN 5
        WHEN 'Dave' THEN 3
    END,
    department = CASE name
        WHEN 'Alice' THEN 'IT'
        WHEN 'Bob' THEN 'HR'
        WHEN 'Carol' THEN 'IT'
        WHEN 'Dave' THEN 'Finance'
    END;

-- Conditional update on multiple columns
UPDATE employees 
SET 
    salary = CASE 
        WHEN performance_rating >= 4 THEN salary * 1.15
        WHEN performance_rating >= 3 THEN salary * 1.10
        ELSE salary * 1.05
    END,
    bonus = CASE 
        WHEN performance_rating >= 4 THEN salary * 0.20
        WHEN performance_rating >= 3 THEN salary * 0.10
        ELSE salary * 0.05
    END,
    department = CASE 
        WHEN performance_rating >= 4 THEN 'Senior ' || department
        ELSE department
    END
WHERE performance_rating >= 3
RETURNING name, department, salary, bonus, performance_rating;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬─────────┬─────────┬────────────────────┐
 * │ name    │ department  │ salary  │ bonus   │ performance_rating │
 * ├─────────┼─────────────┼─────────┼─────────┼────────────────────┤
 * │ Alice   │ Senior IT   │ 82500.00│ 7500.00 │ 3                  │
 * │ Bob     │ Senior HR   │ 74750.00│ 13000.00│ 4                  │
 * │ Carol   │ Senior IT   │ 92000.00│ 16000.00│ 5                  │
 * │ Dave    │ Finance     │ 73500.00│ 3500.00 │ 3                  │
 * └─────────┴─────────────┴─────────┴─────────┴────────────────────┘
 */

-- Update products with different discounts based on price
UPDATE products 
SET 
    discount = CASE 
        WHEN price > 10000 THEN 20
        WHEN price > 5000 THEN 15
        WHEN price > 1000 THEN 10
        ELSE 5
    END,
    price = CASE 
        WHEN price > 10000 THEN price * 0.80
        WHEN price > 5000 THEN price * 0.85
        WHEN price > 1000 THEN price * 0.90
        ELSE price * 0.95
    END
WHERE category = 'Electronics';

SELECT product_name, price, discount FROM products WHERE category = 'Electronics';

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┐
 * │ product_name │ price   │ discount │
 * ├──────────────┼─────────┼──────────┤
 * │ Laptop       │ 30780.00│ 20       │
 * │ Mouse        │ 427.50  │ 5        │
 * │ Keyboard     │ 1154.25 │ 10       │
 * │ Monitor      │ 6156.00 │ 20       │
 * └──────────────┴─────────┴──────────┘
 */

-- ============================================================================
-- PART 8: UPDATE with Subquery (Use values from another table)
-- ============================================================================

/**
 * Use values from another table to update multiple columns.
 */

-- Show current price_updates table
SELECT * FROM price_updates;

/**
 * OUTPUT:
 * ┌──────────────┬───────────┬──────────────┐
 * │ product_name │ new_price │ new_discount │
 * ├──────────────┼───────────┼──────────────┤
 * │ Laptop       │ 45000.00  │ 10           │
 * │ Monitor      │ 9000.00   │ 15           │
 * └──────────────┴───────────┴──────────────┘
 */

-- Reset products to original values
UPDATE products SET 
    price = CASE product_name
        WHEN 'Laptop' THEN 50000
        WHEN 'Mouse' THEN 500
        WHEN 'Keyboard' THEN 1500
        WHEN 'Monitor' THEN 10000
        WHEN 'Headphones' THEN 2000
    END,
    discount = 0;

-- Update products using values from price_updates table
UPDATE products 
SET 
    price = (SELECT new_price FROM price_updates WHERE product_name = products.product_name),
    discount = (SELECT new_discount FROM price_updates WHERE product_name = products.product_name)
WHERE EXISTS (SELECT 1 FROM price_updates WHERE product_name = products.product_name);

SELECT product_name, price, discount FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┐
 * │ product_name │ price   │ discount │
 * ├──────────────┼─────────┼──────────┤
 * │ Laptop       │ 45000.00│ 10       │ ← updated
 * │ Mouse        │ 500.00  │ 0        │ ← unchanged
 * │ Keyboard     │ 1500.00 │ 0        │ ← unchanged
 * │ Monitor      │ 9000.00 │ 15       │ ← updated
 * │ Headphones   │ 2000.00 │ 0        │ ← unchanged
 * └──────────────┴─────────┴──────────┘
 */

-- Update using JOIN (more efficient for multiple columns)
UPDATE products p
SET 
    price = pu.new_price,
    discount = pu.new_discount
FROM price_updates pu
WHERE p.product_name = pu.product_name;

SELECT product_name, price, discount FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┐
 * │ product_name │ price   │ discount │
 * ├──────────────┼─────────┼──────────┤
 * │ Laptop       │ 45000.00│ 10       │
 * │ Mouse        │ 500.00  │ 0        │
 * │ Keyboard     │ 1500.00 │ 0        │
 * │ Monitor      │ 9000.00 │ 15       │
 * │ Headphones   │ 2000.00 │ 0        │
 * └──────────────┴─────────┴──────────┘
 */

-- ============================================================================
-- PART 9: UPDATE Multiple Rows Differently
-- ============================================================================

/**
 * Update different rows with different values using CASE or multiple WHERE conditions.
 */

-- Method 1: Using CASE (single UPDATE statement)
UPDATE students 
SET 
    grade = CASE student_id
        WHEN 1 THEN 'A+'
        WHEN 2 THEN 'B+'
        WHEN 3 THEN 'A'
        WHEN 4 THEN 'B'
        ELSE 'C'
    END,
    is_active = CASE 
        WHEN student_id IN (1, 2, 3) THEN TRUE
        ELSE FALSE
    END
WHERE student_id IN (1, 2, 3, 4, 5, 6);

SELECT student_id, name, grade, is_active FROM students ORDER BY student_id;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┬───────────┐
 * │ student_id │ name    │ grade │ is_active │
 * ├────────────┼─────────┼───────┼───────────┤
 * │ 1          │ Ayaan   │ A+    │ true      │
 * │ 2          │ Sneha   │ B+    │ true      │
 * │ 3          │ Rohit   │ A     │ true      │
 * │ 4          │ Priya   │ B     │ false     │
 * │ 5          │ Neha    │ C     │ false     │
 * │ 6          │ Raj     │ C     │ false     │
 * └────────────┴─────────┴───────┴───────────┘
 */

-- Method 2: Multiple UPDATE statements (in transaction)
BEGIN;

UPDATE employees SET salary = 90000, bonus = 10000 WHERE name = 'Alice';
UPDATE employees SET salary = 75000, bonus = 8000 WHERE name = 'Bob';
UPDATE employees SET salary = 100000, bonus = 15000 WHERE name = 'Carol';
UPDATE employees SET salary = 80000, bonus = 5000 WHERE name = 'Dave';

COMMIT;

SELECT name, salary, bonus FROM employees ORDER BY name;

/**
 * OUTPUT:
 * ┌─────────┬─────────┬─────────┐
 * │ name    │ salary  │ bonus   │
 * ├─────────┼─────────┼─────────┤
 * │ Alice   │ 90000.00│ 10000.00│
 * │ Bob     │ 75000.00│ 8000.00 │
 * │ Carol   │ 100000.00│ 15000.00│
 * │ Dave    │ 80000.00│ 5000.00 │
 * └─────────┴─────────┴─────────┘
 */

-- ============================================================================
-- PART 10: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Employee Annual Review
 * 
 * Update salary, bonus, and department based on performance rating
 */

-- Reset employees
UPDATE employees SET 
    salary = CASE name
        WHEN 'Alice' THEN 75000
        WHEN 'Bob' THEN 65000
        WHEN 'Carol' THEN 80000
        WHEN 'Dave' THEN 70000
    END,
    bonus = 0,
    performance_rating = CASE name
        WHEN 'Alice' THEN 3
        WHEN 'Bob' THEN 4
        WHEN 'Carol' THEN 5
        WHEN 'Dave' THEN 3
    END,
    department = CASE name
        WHEN 'Alice' THEN 'IT'
        WHEN 'Bob' THEN 'HR'
        WHEN 'Carol' THEN 'IT'
        WHEN 'Dave' THEN 'Finance'
    END;

-- Annual review updates
UPDATE employees 
SET 
    salary = CASE 
        WHEN performance_rating >= 4 THEN salary * 1.15
        WHEN performance_rating >= 3 THEN salary * 1.10
        ELSE salary * 1.05
    END,
    bonus = CASE 
        WHEN performance_rating >= 4 THEN salary * 0.25
        WHEN performance_rating >= 3 THEN salary * 0.15
        ELSE salary * 0.10
    END,
    department = CASE 
        WHEN performance_rating >= 4 THEN 'Senior ' || department
        ELSE department
    END
WHERE performance_rating IS NOT NULL
RETURNING name, department, salary, bonus;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬─────────┬─────────┐
 * │ name    │ department  │ salary  │ bonus   │
 * ├─────────┼─────────────┼─────────┼─────────┤
 * │ Alice   │ Senior IT   │ 82500.00│ 12375.00│
 * │ Bob     │ Senior HR   │ 74750.00│ 18687.50│
 * │ Carol   │ Senior IT   │ 92000.00│ 23000.00│
 * │ Dave    │ Finance     │ 73500.00│ 11025.00│
 * └─────────┴─────────────┴─────────┴─────────┘
 */

/**
 * SCENARIO 2: E-commerce Flash Sale
 * 
 * Apply different discounts and price changes based on category and price
 */

-- Reset products
UPDATE products SET 
    price = CASE product_name
        WHEN 'Laptop' THEN 50000
        WHEN 'Mouse' THEN 500
        WHEN 'Keyboard' THEN 1500
        WHEN 'Monitor' THEN 10000
        WHEN 'Headphones' THEN 2000
    END,
    discount = 0,
    stock_quantity = CASE product_name
        WHEN 'Laptop' THEN 10
        WHEN 'Mouse' THEN 50
        WHEN 'Keyboard' THEN 30
        WHEN 'Monitor' THEN 5
        WHEN 'Headphones' THEN 20
    END;

-- Flash sale updates
UPDATE products 
SET 
    price = CASE 
        WHEN category = 'Electronics' AND price > 10000 THEN price * 0.75
        WHEN category = 'Electronics' AND price > 1000 THEN price * 0.80
        WHEN category = 'Accessories' THEN price * 0.85
        ELSE price * 0.90
    END,
    discount = CASE 
        WHEN category = 'Electronics' AND price > 10000 THEN 25
        WHEN category = 'Electronics' AND price > 1000 THEN 20
        WHEN category = 'Accessories' THEN 15
        ELSE 10
    END,
    stock_quantity = stock_quantity - 1
WHERE stock_quantity > 0
RETURNING product_name, category, price, discount, stock_quantity;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┬──────────┬─────────────────┐
 * │ product_name │ category     │ price   │ discount │ stock_quantity  │
 * ├──────────────┼──────────────┼─────────┼──────────┼─────────────────┤
 * │ Laptop       │ Electronics  │ 37500.00│ 25       │ 9               │
 * │ Mouse        │ Electronics  │ 400.00  │ 20       │ 49              │
 * │ Keyboard     │ Electronics  │ 1200.00 │ 20       │ 29              │
 * │ Monitor      │ Electronics  │ 7500.00 │ 25       │ 4               │
 * │ Headphones   │ Accessories  │ 1700.00 │ 15       │ 19              │
 * └──────────────┴──────────────┴─────────┴──────────┴─────────────────┘
 */

/**
 * SCENARIO 3: Student Grade Update at End of Semester
 * 
 * Update grades, GPA, and status based on final exam scores
 */

-- Add gpa column
ALTER TABLE students ADD COLUMN gpa DECIMAL(3,2);
ALTER TABLE students ADD COLUMN status VARCHAR(20) DEFAULT 'Active';

-- Update multiple columns based on grade
UPDATE students 
SET 
    gpa = CASE grade
        WHEN 'A+' THEN 4.0
        WHEN 'A' THEN 3.7
        WHEN 'A-' THEN 3.5
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        WHEN 'C+' THEN 2.3
        WHEN 'C' THEN 2.0
        ELSE 1.0
    END,
    status = CASE 
        WHEN grade IN ('A+', 'A', 'A-', 'B+') THEN 'Honors'
        WHEN grade IN ('B', 'B-') THEN 'Good Standing'
        ELSE 'Probation'
    END,
    is_active = CASE 
        WHEN grade IN ('F', 'D') THEN FALSE
        ELSE TRUE
    END
WHERE student_id IS NOT NULL;

SELECT name, grade, gpa, status, is_active FROM students ORDER BY student_id;

/**
 * OUTPUT:
 * ┌─────────┬───────┬──────┬─────────────────┬───────────┐
 * │ name    │ grade │ gpa  │ status          │ is_active │
 * ├─────────┼───────┼──────┼─────────────────┼───────────┤
 * │ Ayaan   │ A+    │ 4.00 │ Honors          │ true      │
 * │ Sneha   │ B+    │ 3.30 │ Honors          │ true      │
 * │ Rohit   │ A     │ 3.70 │ Honors          │ true      │
 * │ Priya   │ B     │ 3.00 │ Good Standing   │ true      │
 * │ Neha    │ C     │ 2.00 │ Probation       │ true      │
 * │ Raj     │ C     │ 2.00 │ Probation       │ true      │
 * └─────────┴───────┴──────┴─────────────────┴───────────┘
 */

/**
 * SCENARIO 4: Order Processing
 * 
 * Update order status, priority, and notes based on order age
 */

-- Add order_date and priority to orders
ALTER TABLE orders ADD COLUMN order_date DATE DEFAULT CURRENT_DATE;
ALTER TABLE orders ADD COLUMN priority INT DEFAULT 1;

UPDATE orders SET order_date = 
    CASE order_id
        WHEN 1 THEN CURRENT_DATE - INTERVAL '10 days'
        WHEN 2 THEN CURRENT_DATE - INTERVAL '5 days'
        WHEN 3 THEN CURRENT_DATE - INTERVAL '2 days'
        WHEN 4 THEN CURRENT_DATE - INTERVAL '1 day'
    END;

-- Process pending orders
UPDATE orders 
SET 
    order_status = CASE 
        WHEN order_date < CURRENT_DATE - INTERVAL '7 days' THEN 'URGENT'
        WHEN order_date < CURRENT_DATE - INTERVAL '3 days' THEN 'PROCESSING'
        ELSE 'PENDING'
    END,
    priority = CASE 
        WHEN order_date < CURRENT_DATE - INTERVAL '7 days' THEN 5
        WHEN order_date < CURRENT_DATE - INTERVAL '3 days' THEN 3
        ELSE 1
    END,
    notes = CASE 
        WHEN order_date < CURRENT_DATE - INTERVAL '7 days' THEN 'Customer notified - urgent'
        ELSE NULL
    END
WHERE order_status = 'PENDING'
RETURNING order_id, customer_name, order_status, priority, notes;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬──────────┬─────────────────────────┐
 * │ order_id │ customer_name │ order_status │ priority │ notes                   │
 * ├──────────┼───────────────┼──────────────┼──────────┼─────────────────────────┤
 * │ 1        │ Ayaan         │ URGENT       │ 5        │ Customer notified - urgent│
 * │ 3        │ Rohit         │ PROCESSING   │ 3        │ NULL                    │
 * └──────────┴───────────────┴──────────────┴──────────┴─────────────────────────┘
 */

/**
 * SCENARIO 5: Bulk Product Re-categorization
 * 
 * Update category and pricing strategy for multiple products
 */

-- Update multiple products with new category and pricing
UPDATE products 
SET 
    category = CASE 
        WHEN price > 10000 THEN 'Premium Electronics'
        WHEN price > 1000 THEN 'Standard Electronics'
        ELSE 'Budget Electronics'
    END,
    discount = CASE 
        WHEN price > 10000 THEN 10
        WHEN price > 1000 THEN 5
        ELSE 2
    END,
    price = price * 0.95
WHERE category LIKE '%Electronics%'
RETURNING product_name, category, price, discount;

/**
 * OUTPUT:
 * ┌──────────────┬───────────────────────┬─────────┬──────────┐
 * │ product_name │ category              │ price   │ discount │
 * ├──────────────┼───────────────────────┼─────────┼──────────┤
 * │ Laptop       │ Premium Electronics   │ 35625.00│ 10       │
 * │ Mouse        │ Budget Electronics    │ 380.00  │ 2        │
 * │ Keyboard     │ Standard Electronics  │ 1140.00 │ 5        │
 * │ Monitor      │ Premium Electronics   │ 7125.00 │ 10       │
 * └──────────────┴───────────────────────┴─────────┴──────────┘
 */

-- ============================================================================
-- PART 11: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Missing comma between column assignments                   │
 * │                                                                          │
 * │   ❌ UPDATE students SET grade = 'A' city = 'Mumbai' WHERE id = 1;      │
 * │      → Error! Missing comma after 'A'                                  │
 * │                                                                          │
 * │   ✅ UPDATE students SET grade = 'A', city = 'Mumbai' WHERE id = 1;     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong
-- UPDATE students SET grade = 'A' city = 'Mumbai' WHERE student_id = 1;

-- ✅ Correct
UPDATE students SET grade = 'A', city = 'Mumbai' WHERE student_id = 1;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Forgetting WHERE clause (updates ALL rows)                 │
 * │                                                                          │
 * │   ❌ UPDATE students SET grade = 'A', city = 'Mumbai';                  │
 * │      → EVERY student gets grade 'A' and city 'Mumbai'!                 │
 * │                                                                          │
 * │   ✅ UPDATE students SET grade = 'A', city = 'Mumbai' WHERE id = 1;     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Using SET multiple times                                    │
 * │                                                                          │
 * │   ❌ UPDATE students SET grade = 'A' SET city = 'Mumbai' WHERE id = 1;  │
 * │      → Error! SET can only be used once                                │
 * │                                                                          │
 * │   ✅ UPDATE students SET grade = 'A', city = 'Mumbai' WHERE id = 1;     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Data type mismatch in one of the columns                   │
 * │                                                                          │
 * │   ❌ UPDATE students SET age = 'twenty', grade = 'A' WHERE id = 1;      │
 * │      → Error! age expects INTEGER, not TEXT                            │
 * │                                                                          │
 * │   ✅ UPDATE students SET age = 20, grade = 'A' WHERE id = 1;            │
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
 * │ RULE 1: Separate multiple column assignments with COMMA                │
 * │         → SET col1 = val1, col2 = val2, col3 = val3                    │
 * │                                                                          │
 * │ RULE 2: ALWAYS use WHERE clause unless updating ALL rows               │
 * │         → Test with SELECT first                                       │
 * │                                                                          │
 * │ RULE 3: Use RETURNING to verify what was updated                       │
 * │         → UPDATE ... RETURNING *;                                      │
 * │                                                                          │
 * │ RULE 4: Use CASE for conditional updates on multiple rows              │
 * │         → SET col = CASE WHEN condition THEN value ELSE other END      │
 * │                                                                          │
 * │ RULE 5: Use subquery or JOIN to update from another table              │
 * │         → UPDATE t1 SET col = t2.col FROM t2 WHERE t1.id = t2.id       │
 * │                                                                          │
 * │ RULE 6: For different values for different rows, use:                  │
 * │         → CASE statement (single UPDATE)                               │
 * │         → Multiple UPDATE in transaction (BEGIN...COMMIT)              │
 * │                                                                          │
 * │ RULE 7: Always test with SELECT before UPDATE                          │
 * │         → SELECT * FROM table WHERE condition;                         │
 * │         → UPDATE table SET ... WHERE condition;                        │
 * │                                                                          │
 * │ RULE 8: Use transactions for multiple UPDATE statements                │
 * │         → BEGIN; UPDATE...; UPDATE...; COMMIT;                         │
 * │         → Or ROLLBACK if something goes wrong                          │
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
 * │ -- Update multiple columns for specific rows                           │
 * │ UPDATE table                                                           │
 * │ SET col1 = val1, col2 = val2, col3 = val3                              │
 * │ WHERE condition;                                                       │
 * │                                                                          │
 * │ -- Update with expressions                                             │
 * │ UPDATE table                                                           │
 * │ SET col1 = col1 * 1.1, col2 = col2 + 10                                │
 * │ WHERE condition;                                                       │
 * │                                                                          │
 * │ -- Update with RETURNING                                               │
 * │ UPDATE table                                                           │
 * │ SET col1 = val1, col2 = val2                                           │
 * │ WHERE condition                                                        │
 * │ RETURNING *;                                                           │
 * │                                                                          │
 * │ -- Update with CASE (different values per row)                         │
 * │ UPDATE table                                                           │
 * │ SET col1 = CASE                                                        │
 * │     WHEN condition1 THEN val1                                          │
 * │     WHEN condition2 THEN val2                                          │
 * │     ELSE val3                                                          │
 * │ END                                                                    │
 * │ WHERE condition;                                                       │
 * │                                                                          │
 * │ -- Update from another table (JOIN syntax)                            │
 * │ UPDATE t1                                                              │
 * │ SET t1.col1 = t2.col1, t1.col2 = t2.col2                              │
 * │ FROM t2                                                                │
 * │ WHERE t1.id = t2.id;                                                   │
 * │                                                                          │
 * │ -- Update multiple rows with different values (transaction)            │
 * │ BEGIN;                                                                 │
 * │ UPDATE table SET col = val1 WHERE id = 1;                              │
 * │ UPDATE table SET col = val2 WHERE id = 2;                              │
 * │ COMMIT;                                                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Update student's grade and city for student_id = 3
 * 
 * Answer:
 *   UPDATE students SET grade = 'A', city = 'New York' WHERE student_id = 3;
 */

/**
 * EXERCISE 2: Give 10% discount and reduce stock by 1 for all Electronics products
 * 
 * Answer:
 *   UPDATE products 
 *   SET discount = 10, stock_quantity = stock_quantity - 1 
 *   WHERE category = 'Electronics';
 */

/**
 * EXERCISE 3: Update salary and bonus for employees in IT department
 * 
 * Answer:
 *   UPDATE employees 
 *   SET salary = salary * 1.1, bonus = salary * 0.15 
 *   WHERE department = 'IT';
 */

/**
 * EXERCISE 4: Update order status and priority for order_id = 1
 * 
 * Answer:
 *   UPDATE orders SET order_status = 'DELIVERED', priority = 1 WHERE order_id = 1;
 */

/**
 * EXERCISE 5: Update multiple columns using CASE (give different raises)
 * 
 * Answer:
 *   UPDATE employees 
 *   SET salary = CASE 
 *       WHEN performance_rating = 5 THEN salary * 1.2
 *       WHEN performance_rating = 4 THEN salary * 1.15
 *       ELSE salary * 1.1
 *   END,
 *   bonus = salary * 0.1;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS price_updates;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
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
 * │ 1. UPDATE multiple columns changes several columns in one statement    │
 * │                                                                          │
 * │ 2. Syntax:                                                              │
 * │    UPDATE table                                                        │
 * │    SET col1 = val1, col2 = val2, col3 = val3                           │
 * │    WHERE condition;                                                     │
 * │                                                                          │
 * │ 3. Benefits over single column updates:                                │
 * │    → Faster (one round trip)                                           │
 * │    → Atomic (all or nothing)                                           │
 * │    → Cleaner code                                                      │
 * │                                                                          │
 * │ 4. You can use:                                                         │
 * │    → Expressions: SET col1 = col1 * 1.1, col2 = col2 + 5               │
 * │    → NULL: SET col1 = NULL, col2 = NULL                                │
 * │    → DEFAULT: SET col1 = DEFAULT, col2 = DEFAULT                       │
 * │    → CASE: Conditional updates for different rows                      │
 * │    → Subquery/JOIN: Update from another table                          │
 * │                                                                          │
 * │ 5. Use RETURNING to see updated rows                                   │
 * │                                                                          │
 * │ 6. Always test with SELECT before UPDATE                               │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Separate columns with COMMA (not AND)                              │
 * │   - Always use WHERE (unless updating all rows)                        │
 * │   - Use CASE for different values per row                              │
 * │   - Use transactions for multiple UPDATE statements                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF UPDATE MULTIPLE COLUMNS GUIDE
-- ============================================================================