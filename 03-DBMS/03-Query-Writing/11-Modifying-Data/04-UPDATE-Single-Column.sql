/**
 * ============================================================================
 * UPDATE SINGLE COLUMN - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS UPDATE? -------------------------- (Modifying existing data)
 * 2. UPDATE SINGLE COLUMN - BASIC ------------- (Simple column updates)
 * 3. UPDATE with WHERE ------------------------ (Update specific rows)
 * 4. UPDATE All Rows (Without WHERE) ---------- (Be careful!)
 * 5. UPDATE with Expressions ------------------ (Calculations in UPDATE)
 * 6. UPDATE with RETURNING -------------------- (See what was updated)
 * 7. UPDATE with NULL -------------------------- (Set column to NULL)
 * 8. UPDATE with DEFAULT ---------------------- (Reset to default value)
 * 9. UPDATE with CASE -------------------------- (Conditional updates)
 * 10. REAL-WORLD SCENARIOS -------------------- (Practical examples)
 * 11. COMMON MISTAKES ------------------------- (What to avoid)
 * 12. GOLDEN RULES ---------------------------- (Key principles)
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
    city VARCHAR(50) DEFAULT 'Unknown',
    is_active BOOLEAN DEFAULT TRUE
);

/**
 * TABLE 2: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    stock_quantity INT DEFAULT 0,
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
    performance_rating INT DEFAULT 3
);

/**
 * TABLE 4: ORDERS - Order information
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    order_status VARCHAR(20) DEFAULT 'PENDING',
    total_amount DECIMAL(10,2)
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
INSERT INTO employees (name, salary, department) VALUES
('Alice', 75000, 'IT'),
('Bob', 65000, 'HR'),
('Carol', 80000, 'IT'),
('Dave', 70000, 'Finance');

-- Insert sample data into orders
INSERT INTO orders (customer_name, order_status, total_amount) VALUES
('Ayaan', 'PENDING', 50000),
('Sneha', 'DELIVERED', 1500),
('Rohit', 'PENDING', 2000),
('Priya', 'CANCELLED', 10000);

-- ============================================================================
-- PART 1: WHAT IS UPDATE?
-- ============================================================================

/**
 * UPDATE modifies existing data in a table.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS UPDATE?                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE table_name                                               │   │
 * │   │ SET column_name = new_value                                     │   │
 * │   │ WHERE condition;                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Find rows that match the WHERE condition                    │   │
 * │   │ 2. Change the specified column to the new value                │   │
 * │   │ 3. Other columns remain unchanged                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ "Update student's grade from 'C' to 'B'"                        │   │
 * │   │                                                                  │   │
 * │   │ BEFORE: student_id=1, name='Ayaan', grade='C'                   │   │
 * │   │ UPDATE students SET grade = 'B' WHERE student_id = 1;           │   │
 * │   │ AFTER:  student_id=1, name='Ayaan', grade='B'                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  IMPORTANT WARNING:                                                │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Without WHERE clause, ALL rows will be updated!                 │   │
 * │   │ Always use WHERE unless you really want to update everything     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE SINGLE COLUMN - EXAMPLE                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE UPDATE:                                                        │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────┐   │
 * │   │ student_id │ name    │ age │ grade │ email           │ city    │   │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────┤   │
 * │   │ 1          │ Ayaan   │ 20  │ A     │ ayaan@email.com │ Mumbai  │   │
 * │   │ 2          │ Sneha   │ 22  │ B     │ sneha@email.com │ Delhi   │   │
 * │   │ 3          │ Rohit   │ 21  │ A     │ rohit@email.com │ Banglore│   │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴─────────┘   │
 * │                                                                          │
 * │   UPDATE COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students SET grade = 'A+' WHERE student_id = 1;          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER UPDATE:                                                         │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────┐   │
 * │   │ student_id │ name    │ age │ grade │ email           │ city    │   │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────┤   │
 * │   │ 1          │ Ayaan   │ 20  │ A+    │ ayaan@email.com │ Mumbai  │   │
 * │   │ 2          │ Sneha   │ 22  │ B     │ sneha@email.com │ Delhi   │   │
 * │   │ 3          │ Rohit   │ 21  │ A     │ rohit@email.com │ Banglore│   │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴─────────┘   │
 * │                                                                          │
 * │   EXPLANATION: Only row with student_id=1 was updated.                  │
 * │   Other rows (2 and 3) remained unchanged.                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: UPDATE SINGLE COLUMN - BASIC
-- ============================================================================

-- Show current data
SELECT student_id, name, grade FROM students ORDER BY student_id;

/**
 * CURRENT DATA:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ grade │
 * ├────────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ A     │
 * │ 2          │ Sneha   │ B     │
 * │ 3          │ Rohit   │ A     │
 * │ 4          │ Priya   │ C     │
 * │ 5          │ Neha    │ B     │
 * │ 6          │ Raj     │ C     │
 * └────────────┴─────────┴───────┘
 */

-- EXAMPLE 1: Update a single student's grade
UPDATE students 
SET grade = 'A+' 
WHERE student_id = 1;

-- Verify the update
SELECT student_id, name, grade FROM students WHERE student_id = 1;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ grade │
 * ├────────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ A+    │
 * └────────────┴─────────┴───────┘
 */

-- EXAMPLE 2: Update another student's grade
UPDATE students 
SET grade = 'B+' 
WHERE student_id = 2;

SELECT student_id, name, grade FROM students WHERE student_id = 2;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ grade │
 * ├────────────┼─────────┼───────┤
 * │ 2          │ Sneha   │ B+    │
 * └────────────┴─────────┴───────┘
 */

-- EXAMPLE 3: Update age of a specific student
UPDATE students 
SET age = 21 
WHERE student_id = 6;

SELECT student_id, name, age FROM students WHERE student_id = 6;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┐
 * │ student_id │ name    │ age │
 * ├────────────┼─────────┼─────┤
 * │ 6          │ Raj     │ 21  │
 * └────────────┴─────────┴─────┘
 */

-- ============================================================================
-- PART 3: UPDATE with WHERE (Update specific rows)
-- ============================================================================

/**
 * WHERE clause determines WHICH rows get updated.
 * Always use WHERE to update specific rows.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    UPDATE with WHERE                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE UPDATE:                                                        │
 * │   ┌────────────┬─────────┬─────┬─────────┐                             │
 * │   │ student_id │ name    │ age │ city    │                             │
 * │   ├────────────┼─────────┼─────┼─────────┤                             │
 * │   │ 1          │ Ayaan   │ 20  │ Mumbai  │                             │
 * │   │ 2          │ Sneha   │ 22  │ Delhi   │                             │
 * │   │ 3          │ Rohit   │ 21  │ Banglore│                             │
 * │   │ 4          │ Priya   │ 23  │ Chennai │                             │
 * │   └────────────┴─────────┴─────┴─────────┘                             │
 * │                                                                          │
 * │   UPDATE COMMAND: Update all students in Mumbai                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students SET age = age + 1 WHERE city = 'Mumbai';        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER UPDATE:                                                         │
 * │   ┌────────────┬─────────┬─────┬─────────┐                             │
 * │   │ student_id │ name    │ age │ city    │                             │
 * │   ├────────────┼─────────┼─────┼─────────┤                             │
 * │   │ 1          │ Ayaan   │ 21  │ Mumbai  │ ← age increased by 1        │
 * │   │ 2          │ Sneha   │ 22  │ Delhi   │ ← unchanged                 │
 * │   │ 3          │ Rohit   │ 21  │ Banglore│ ← unchanged                 │
 * │   │ 4          │ Priya   │ 23  │ Chennai │ ← unchanged                 │
 * │   └────────────┴─────────┴─────┴─────────┘                             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Update multiple rows that match a condition
UPDATE students 
SET city = 'Mumbai' 
WHERE city = 'Unknown' OR city IS NULL;

-- Update all students from a specific city
UPDATE students 
SET grade = 'A' 
WHERE city = 'Mumbai';

SELECT student_id, name, city, grade FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────┬───────┐
 * │ student_id │ name    │ city    │ grade │
 * ├────────────┼─────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ Mumbai  │ A+    │
 * │ 2          │ Sneha   │ Delhi   │ B+    │
 * │ 3          │ Rohit   │ Banglore│ A     │
 * │ 4          │ Priya   │ Chennai │ C     │
 * │ 5          │ Neha    │ Pune    │ B     │
 * │ 6          │ Raj     │ Ahmedabad│ C    │
 * └────────────┴─────────┴─────────┴───────┘
 */

-- Update using comparison operators
UPDATE products 
SET discount = 10 
WHERE price > 5000;

SELECT product_name, price, discount FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┐
 * │ product_name │ price   │ discount │
 * ├──────────────┼─────────┼──────────┤
 * │ Laptop       │ 50000   │ 10       │ ← price > 5000
 * │ Mouse        │ 500     │ 0        │ ← price ≤ 5000
 * │ Keyboard     │ 1500    │ 0        │ ← price ≤ 5000
 * │ Monitor      │ 10000   │ 10       │ ← price > 5000
 * │ Headphones   │ 2000    │ 0        │ ← price ≤ 5000
 * └──────────────┴─────────┴──────────┘
 */

-- Update using IN operator
UPDATE students 
SET is_active = FALSE 
WHERE student_id IN (4, 5, 6);

SELECT student_id, name, is_active FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┐
 * │ student_id │ name    │ is_active │
 * ├────────────┼─────────┼───────────┤
 * │ 1          │ Ayaan   │ true      │
 * │ 2          │ Sneha   │ true      │
 * │ 3          │ Rohit   │ true      │
 * │ 4          │ Priya   │ false     │
 * │ 5          │ Neha    │ false     │
 * │ 6          │ Raj     │ false     │
 * └────────────┴─────────┴───────────┘
 */

-- ============================================================================
-- PART 4: UPDATE All Rows (Without WHERE) - BE CAREFUL!
-- ============================================================================

/**
 * ⚠️  WARNING: UPDATE without WHERE updates EVERY row in the table!
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    UPDATE All Rows - BE CAREFUL!                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE UPDATE:                                                        │
 * │   ┌────────────┬─────────┬─────────┐                                   │
 * │   │ student_id │ name    │ city    │                                   │
 * │   ├────────────┼─────────┼─────────┤                                   │
 * │   │ 1          │ Ayaan   │ Mumbai  │                                   │
 * │   │ 2          │ Sneha   │ Delhi   │                                   │
 *   │   │ 3          │ Rohit   │ Banglore│                                   │
 * │   └────────────┴─────────┴─────────┘                                   │
 * │                                                                          │
 * │   UPDATE COMMAND (NO WHERE!):                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students SET city = 'India';        ← No WHERE clause!   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER UPDATE: ALL rows changed!                                       │
 * │   ┌────────────┬─────────┬─────────┐                                   │
 * │   │ student_id │ name    │ city    │                                   │
 *   │   ├────────────┼─────────┼─────────┤                                   │
 * │   │ 1          │ Ayaan   │ India   │ ← changed                         │
 * │   │ 2          │ Sneha   │ India   │ ← changed                         │
 * │   │ 3          │ Rohit   │ India   │ ← changed                         │
 * │   └────────────┴─────────┴─────────┘                                   │
 * │                                                                          │
 * │   ⚠️  This is often a mistake! Only use without WHERE when you        │
 * │       really want to update EVERY row in the table.                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Reset data first (for demo)
UPDATE students SET is_active = TRUE;

-- ⚠️  CAREFUL: This updates ALL rows (no WHERE clause)
UPDATE students SET is_active = FALSE;

SELECT student_id, name, is_active FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┐
 * │ student_id │ name    │ is_active │
 * ├────────────┼─────────┼───────────┤
 * │ 1          │ Ayaan   │ false     │
 * │ 2          │ Sneha   │ false     │
 * │ 3          │ Rohit   │ false     │
 * │ 4          │ Priya   │ false     │
 * │ 5          │ Neha    │ false     │
 * │ 6          │ Raj     │ false     │
 * └────────────┴─────────┴───────────┘
 * 
 * EXPLANATION: All 6 students were set to inactive!
 * This is why WHERE is so important.
 */

-- Fix: Reactivate students (another UPDATE without WHERE)
UPDATE students SET is_active = TRUE;

-- ============================================================================
-- PART 5: UPDATE with Expressions (Calculations in UPDATE)
-- ============================================================================

/**
 * You can use mathematical expressions and functions in UPDATE.
 */

-- Increase age by 1 for all students
UPDATE students SET age = age + 1;

SELECT student_id, name, age FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┐
 * │ student_id │ name    │ age │
 * ├────────────┼─────────┼─────┤
 * │ 1          │ Ayaan   │ 21  │
 * │ 2          │ Sneha   │ 23  │
 * │ 3          │ Rohit   │ 22  │
 * │ 4          │ Priya   │ 24  │
 * │ 5          │ Neha    │ 25  │
 * │ 6          │ Raj     │ 22  │
 * └────────────┴─────────┴─────┘
 */

-- Apply discount to products
UPDATE products 
SET price = price * 0.9 
WHERE category = 'Electronics';

SELECT product_name, category, price FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 45000.00│ (was 50000)
 * │ Mouse        │ Electronics  │ 450.00  │ (was 500)
 * │ Keyboard     │ Electronics  │ 1350.00 │ (was 1500)
 * │ Monitor      │ Electronics  │ 9000.00 │ (was 10000)
 * │ Headphones   │ Accessories  │ 2000.00 │ (unchanged)
 * └──────────────┴──────────────┴─────────┘
 */

-- Give 10% salary increase to IT department
UPDATE employees 
SET salary = salary * 1.10 
WHERE department = 'IT';

SELECT name, department, salary FROM employees;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬─────────┐
 * │ name    │ department │ salary  │
 * ├─────────┼────────────┼─────────┤
 * │ Alice   │ IT         │ 82500.00│ (was 75000)
 * │ Bob     │ HR         │ 65000.00│ (unchanged)
 * │ Carol   │ IT         │ 88000.00│ (was 80000)
 * │ Dave    │ Finance    │ 70000.00│ (unchanged)
 * └─────────┴────────────┴─────────┘
 */

-- ============================================================================
-- PART 6: UPDATE with RETURNING (See what was updated)
-- ============================================================================

/**
 * RETURNING shows the updated values after the UPDATE.
 */

-- Update and see what changed
UPDATE students 
SET grade = 'A' 
WHERE student_id = 1
RETURNING student_id, name, grade;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ grade │
 * ├────────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ A     │
 * └────────────┴─────────┴───────┘
 */

-- Update multiple rows and see all updated rows
UPDATE students 
SET is_active = TRUE 
WHERE city IN ('Mumbai', 'Delhi')
RETURNING student_id, name, city, is_active;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────┬───────────┐
 * │ student_id │ name    │ city    │ is_active │
 * ├────────────┼─────────┼─────────┼───────────┤
 * │ 1          │ Ayaan   │ Mumbai  │ true      │
 * │ 2          │ Sneha   │ Delhi   │ true      │
 * └────────────┴─────────┴─────────┴───────────┘
 */

-- Update with RETURNING * (all columns)
UPDATE products 
SET discount = 15 
WHERE price > 5000
RETURNING *;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬─────────┬──────────┬─────────────────┬──────────────┐
 * │ product_id │ product_name │ price   │ discount │ stock_quantity  │ category     │
 * ├────────────┼──────────────┼─────────┼──────────┼─────────────────┼──────────────┤
 * │ 1          │ Laptop       │ 45000.00│ 15       │ 10              │ Electronics  │
 * │ 4          │ Monitor      │ 9000.00 │ 15       │ 5               │ Electronics  │
 * └────────────┴──────────────┴─────────┴──────────┴─────────────────┴──────────────┘
 */

-- ============================================================================
-- PART 7: UPDATE with NULL (Set column to NULL)
-- ============================================================================

/**
 * Set a column to NULL when it allows NULL values.
 */

-- Remove email for a student
UPDATE students 
SET email = NULL 
WHERE student_id = 1;

SELECT student_id, name, email FROM students WHERE student_id = 1;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ email │
 * ├────────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ NULL  │
 * └────────────┴─────────┴───────┘
 */

-- Remove category for products (set to NULL)
UPDATE products 
SET category = NULL 
WHERE product_name = 'Headphones';

SELECT product_name, category FROM products WHERE product_name = 'Headphones';

/**
 * OUTPUT:
 * ┌──────────────┬──────────┐
 * │ product_name │ category │
 * ├──────────────┼──────────┤
 * │ Headphones   │ NULL     │
 * └──────────────┴──────────┘
 */

-- ============================================================================
-- PART 8: UPDATE with DEFAULT (Reset to default value)
-- ============================================================================

/**
 * Set a column to its DEFAULT value using the DEFAULT keyword.
 */

-- Reset discount to default (0)
UPDATE products 
SET discount = DEFAULT 
WHERE discount > 0;

SELECT product_name, price, discount FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┐
 * │ product_name │ price   │ discount │
 * ├──────────────┼─────────┼──────────┤
 * │ Laptop       │ 45000.00│ 0        │
 * │ Mouse        │ 450.00  │ 0        │
 * │ Keyboard     │ 1350.00 │ 0        │
 * │ Monitor      │ 9000.00 │ 0        │
 * │ Headphones   │ 2000.00 │ 0        │
 * └──────────────┴─────────┴──────────┘
 */

-- Reset is_active to default (TRUE)
UPDATE students 
SET is_active = DEFAULT 
WHERE is_active = FALSE;

SELECT student_id, name, is_active FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┐
 * │ student_id │ name    │ is_active │
 * ├────────────┼─────────┼───────────┤
 * │ 1          │ Ayaan   │ true      │
 * │ 2          │ Sneha   │ true      │
 * │ 3          │ Rohit   │ true      │
 * │ 4          │ Priya   │ true      │
 * │ 5          │ Neha    │ true      │
 * │ 6          │ Raj     │ true      │
 * └────────────┴─────────┴───────────┘
 */

-- ============================================================================
-- PART 9: UPDATE with CASE (Conditional updates)
-- ============================================================================

/**
 * Use CASE to set different values based on conditions.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    UPDATE with CASE                                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   PROBLEM: Give different salary increases based on department          │
 * │                                                                          │
 * │   BEFORE:                                                               │
 * │   ┌─────────┬────────────┬─────────┐                                   │
 * │   │ name    │ department │ salary  │                                   │
 * │   ├─────────┼────────────┼─────────┤                                   │
 * │   │ Alice   │ IT         │ 75000   │                                   │
 * │   │ Bob     │ HR         │ 65000   │                                   │
 * │   │ Carol   │ IT         │ 80000   │                                   │
 * │   │ Dave    │ Finance    │ 70000   │                                   │
 * │   └─────────┴────────────┴─────────┘                                   │
 * │                                                                          │
 * │   UPDATE COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE employees                                                │   │
 * │   │ SET salary = CASE                                               │   │
 * │   │     WHEN department = 'IT' THEN salary * 1.15                   │   │
 * │   │     WHEN department = 'HR' THEN salary * 1.10                   │   │
 * │   │     ELSE salary * 1.05                                          │   │
 * │   │ END;                                                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER:                                                               │
 * │   ┌─────────┬────────────┬─────────┐                                   │
 * │   │ name    │ department │ salary  │                                   │
 * │   ├─────────┼────────────┼─────────┤                                   │
 * │   │ Alice   │ IT         │ 86250   │ (15% increase)                    │
 * │   │ Bob     │ HR         │ 71500   │ (10% increase)                    │
 * │   │ Carol   │ IT         │ 92000   │ (15% increase)                    │
 * │   │ Dave    │ Finance    │ 73500   │ (5% increase)                     │
 * │   └─────────┴────────────┴─────────┘                                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Reset salaries to original values
UPDATE employees SET salary = 
    CASE name
        WHEN 'Alice' THEN 75000
        WHEN 'Bob' THEN 65000
        WHEN 'Carol' THEN 80000
        WHEN 'Dave' THEN 70000
    END;

-- Now apply conditional increases
UPDATE employees 
SET salary = CASE 
    WHEN department = 'IT' THEN salary * 1.15
    WHEN department = 'HR' THEN salary * 1.10
    ELSE salary * 1.05
END
RETURNING name, department, salary;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬─────────┐
 * │ name    │ department │ salary  │
 * ├─────────┼────────────┼─────────┤
 * │ Alice   │ IT         │ 86250.00│
 * │ Bob     │ HR         │ 71500.00│
 * │ Carol   │ IT         │ 92000.00│
 * │ Dave    │ Finance    │ 73500.00│
 * └─────────┴────────────┴─────────┘
 */

-- Update grades based on age
UPDATE students 
SET grade = CASE 
    WHEN age >= 24 THEN 'A'
    WHEN age >= 22 THEN 'B'
    WHEN age >= 20 THEN 'C'
    ELSE 'D'
END
RETURNING name, age, grade;

/**
 * OUTPUT:
 * ┌─────────┬─────┬───────┐
 * │ name    │ age │ grade │
 * ├─────────┼─────┼───────┤
 * │ Ayaan   │ 21  │ C     │
 * │ Sneha   │ 23  │ B     │
 * │ Rohit   │ 22  │ B     │
 * │ Priya   │ 24  │ A     │
 * │ Neha    │ 25  │ A     │
 * │ Raj     │ 22  │ B     │
 * └─────────┴─────┴───────┘
 */

-- ============================================================================
-- PART 10: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Student Graduation - Update all students' status
 * 
 * All students who joined in 2020 are graduating, mark them as inactive
 */

-- Add enrollment_year column for this scenario
ALTER TABLE students ADD COLUMN enrollment_year INT DEFAULT 2024;
UPDATE students SET enrollment_year = 2020 WHERE student_id IN (1, 2);
UPDATE students SET enrollment_year = 2021 WHERE student_id IN (3, 4);
UPDATE students SET enrollment_year = 2022 WHERE student_id IN (5, 6);

-- Update students who enrolled in 2020
UPDATE students 
SET is_active = FALSE 
WHERE enrollment_year = 2020
RETURNING student_id, name, enrollment_year, is_active;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────────────┬───────────┐
 * │ student_id │ name    │ enrollment_year │ is_active │
 * ├────────────┼─────────┼─────────────────┼───────────┤
 * │ 1          │ Ayaan   │ 2020            │ false     │
 * │ 2          │ Sneha   │ 2020            │ false     │
 * └────────────┴─────────┴─────────────────┴───────────┘
 */

/**
 * SCENARIO 2: E-commerce Sale - Apply discount to all products
 * 
 * Site-wide sale: 20% off on all Electronics, 10% off on Accessories
 */

-- Reset prices first (for demo)
UPDATE products SET price = 
    CASE product_name
        WHEN 'Laptop' THEN 50000
        WHEN 'Mouse' THEN 500
        WHEN 'Keyboard' THEN 1500
        WHEN 'Monitor' THEN 10000
        WHEN 'Headphones' THEN 2000
    END;

-- Apply sale discounts
UPDATE products 
SET price = CASE 
    WHEN category = 'Electronics' THEN price * 0.80
    WHEN category = 'Accessories' THEN price * 0.90
    ELSE price
END
RETURNING product_name, category, price;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 40000.00│
 * │ Mouse        │ Electronics  │ 400.00  │
 * │ Keyboard     │ Electronics  │ 1200.00 │
 * │ Monitor      │ Electronics  │ 8000.00 │
 * │ Headphones   │ Accessories  │ 1800.00 │
 * └──────────────┴──────────────┴─────────┘
 */

/**
 * SCENARIO 3: Employee Promotion
 * 
 * Give promotion (salary increase + department change) to top performers
 */

-- Add performance_rating if not exists
ALTER TABLE employees ADD COLUMN IF NOT EXISTS performance_rating INT DEFAULT 3;

UPDATE employees SET performance_rating = 
    CASE name
        WHEN 'Alice' THEN 5
        WHEN 'Carol' THEN 4
        ELSE 3
    END;

-- Promote top performers
UPDATE employees 
SET 
    salary = salary * 1.20,
    department = 'Senior ' || department
WHERE performance_rating >= 4
RETURNING name, department, salary;

/**
 * OUTPUT:
 * ┌─────────┬───────────────────┬─────────┐
 * │ name    │ department        │ salary  │
 * ├─────────┼───────────────────┼─────────┤
 * │ Alice   │ Senior IT         │ 103500.00│
 * │ Carol   │ Senior IT         │ 110400.00│
 * └─────────┴───────────────────┴─────────┘
 */

/**
 * SCENARIO 4: Order Status Update
 * 
 * Update order status from PENDING to PROCESSING after 3 days
 */

-- Add order_date for this scenario
ALTER TABLE orders ADD COLUMN order_date DATE DEFAULT CURRENT_DATE;
UPDATE orders SET order_date = CURRENT_DATE - INTERVAL '5 days' 
WHERE order_id IN (1, 3);
UPDATE orders SET order_date = CURRENT_DATE - INTERVAL '1 day' 
WHERE order_id IN (2, 4);

-- Update orders older than 3 days
UPDATE orders 
SET order_status = 'PROCESSING' 
WHERE order_status = 'PENDING' 
  AND order_date < CURRENT_DATE - INTERVAL '3 days'
RETURNING order_id, customer_name, order_status, order_date;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬────────────┐
 * │ order_id │ customer_name │ order_status │ order_date │
 * ├──────────┼───────────────┼──────────────┼────────────┤
 * │ 1        │ Ayaan         │ PROCESSING   │ 2024-01-10 │
 * │ 3        │ Rohit         │ PROCESSING   │ 2024-01-10 │
 * └──────────┴───────────────┴──────────────┴────────────┘
 */

/**
 * SCENARIO 5: Bulk Price Update
 * 
 * Update prices based on percentage of original price
 */

-- Add original_price column
ALTER TABLE products ADD COLUMN original_price DECIMAL(10,2);
UPDATE products SET original_price = price;

-- Apply different strategies for different price ranges
UPDATE products 
SET price = CASE 
    WHEN original_price > 10000 THEN original_price * 0.85
    WHEN original_price > 1000 THEN original_price * 0.90
    WHEN original_price > 100 THEN original_price * 0.95
    ELSE original_price
END
RETURNING product_name, original_price, price;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬─────────┐
 * │ product_name │ original_price  │ price   │
 * ├──────────────┼─────────────────┼─────────┤
 * │ Laptop       │ 50000.00        │ 42500.00│
 * │ Mouse        │ 500.00          │ 450.00  │
 * │ Keyboard     │ 1500.00         │ 1350.00 │
 * │ Monitor      │ 10000.00        │ 8500.00 │
 * │ Headphones   │ 2000.00         │ 1800.00 │
 * └──────────────┴─────────────────┴─────────┘
 */

-- ============================================================================
-- PART 11: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting WHERE clause (updates ALL rows)                 │
 * │                                                                          │
 * │   ❌ UPDATE students SET grade = 'A';                                   │
 * │      → ALL students get grade 'A'!                                     │
 * │                                                                          │
 * │   ✅ UPDATE students SET grade = 'A' WHERE student_id = 1;              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ DANGEROUS - This updates EVERY row!
-- UPDATE students SET grade = 'A';  -- All students become 'A'!

-- ✅ Safe - Only updates specific student
UPDATE students SET grade = 'A' WHERE student_id = 1;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Wrong data type                                            │
 * │                                                                          │
 * │   ❌ UPDATE students SET age = 'twenty' WHERE student_id = 1;           │
 * │      → Error! age expects INTEGER                                      │
 * │                                                                          │
 * │   ✅ UPDATE students SET age = 20 WHERE student_id = 1;                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting string quotes                                   │
 * │                                                                          │
 * │   ❌ UPDATE students SET city = Mumbai WHERE student_id = 1;            │
 * │      → Error! Text must be in quotes                                   │
 * │                                                                          │
 * │   ✅ UPDATE students SET city = 'Mumbai' WHERE student_id = 1;          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Using = NULL instead of IS NULL                            │
 * │                                                                          │
 * │   ❌ UPDATE students SET email = NULL WHERE email = NULL;               │
 * │      → Nothing updates! NULL = NULL is FALSE in SQL                    │
 * │                                                                          │
 * │   ✅ UPDATE students SET email = 'new@email.com' WHERE email IS NULL;   │
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
 * │ RULE 1: ALWAYS use WHERE clause unless you want to update ALL rows     │
 * │         → Without WHERE, EVERY row is updated!                         │
 * │                                                                          │
 * │ RULE 2: Test with SELECT first                                         │
 * │         → Run SELECT with same WHERE to see which rows will update     │
 * │         → SELECT * FROM students WHERE student_id = 1;                 │
 * │         → UPDATE students SET grade = 'A' WHERE student_id = 1;        │
 * │                                                                          │
 * │ RULE 3: Use RETURNING to see what changed                              │
 * │         → UPDATE ... RETURNING *;                                      │
 * │                                                                          │
 * │ RULE 4: Use transactions for multiple updates                          │
 * │         → BEGIN; UPDATE ...; UPDATE ...; COMMIT;                       │
 * │         → Or ROLLBACK if something goes wrong                          │
 * │                                                                          │
 * │ RULE 5: Back up before mass updates                                    │
 * │         → CREATE TABLE backup AS SELECT * FROM table;                  │
 * │                                                                          │
 * │ RULE 6: Use CASE for conditional updates                               │
 * │         → SET column = CASE WHEN condition THEN value ELSE other END   │
 * │                                                                          │
 * │ RULE 7: NULL comparison needs IS NULL, not = NULL                      │
 * │         → WHERE column IS NULL (correct)                               │
 * │         → WHERE column = NULL (wrong)                                  │
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
 * │ -- Update single column for specific row                               │
 * │ UPDATE table SET column = value WHERE condition;                       │
 * │                                                                          │
 * │ -- Update with expression                                              │
 * │ UPDATE table SET column = column * 1.1 WHERE condition;                │
 * │                                                                          │
 * │ -- Update with RETURNING (see changes)                                 │
 * │ UPDATE table SET column = value WHERE condition RETURNING *;           │
 * │                                                                          │
 * │ -- Update to NULL                                                      │
 * │ UPDATE table SET column = NULL WHERE condition;                        │
 * │                                                                          │
 * │ -- Update to DEFAULT                                                   │
 * │ UPDATE table SET column = DEFAULT WHERE condition;                     │
 * │                                                                          │
 * │ -- Update with CASE (conditional)                                      │
 * │ UPDATE table                                                           │
 * │ SET column = CASE                                                      │
 * │     WHEN condition1 THEN value1                                        │
 * │     WHEN condition2 THEN value2                                        │
 * │     ELSE value3                                                        │
 * │ END                                                                    │
 * │ WHERE condition;                                                       │
 * │                                                                          │
 * │ -- ⚠️  DANGEROUS - updates ALL rows!                                   │
 * │ UPDATE table SET column = value;   -- No WHERE!                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Update student's grade to 'A' for student_id = 3
 * 
 * Answer:
 *   UPDATE students SET grade = 'A' WHERE student_id = 3;
 */

/**
 * EXERCISE 2: Give 10% discount to all products (single column update)
 * 
 * Answer:
 *   UPDATE products SET discount = 10;
 *   (No WHERE - applies to all products)
 */

/**
 * EXERCISE 3: Update all students' age by adding 1 year
 * 
 * Answer:
 *   UPDATE students SET age = age + 1;
 */

/**
 * EXERCISE 4: Update order status to 'DELIVERED' for order_id = 1
 * 
 * Answer:
 *   UPDATE orders SET order_status = 'DELIVERED' WHERE order_id = 1;
 */

/**
 * EXERCISE 5: Give 5% salary increase to all employees in IT department
 * 
 * Answer:
 *   UPDATE employees SET salary = salary * 1.05 WHERE department = 'IT';
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

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
 * │ 1. UPDATE modifies existing data in a table                            │
 * │                                                                          │
 * │ 2. Basic syntax:                                                        │
 * │    UPDATE table SET column = new_value WHERE condition;                 │
 * │                                                                          │
 * │ 3. ⚠️  CRITICAL: Without WHERE, ALL rows are updated!                  │
 * │                                                                          │
 * │ 4. You can use:                                                         │
 * │    → Expressions: UPDATE table SET age = age + 1                        │
 * │    → NULL: UPDATE table SET email = NULL                                │
 * │    → DEFAULT: UPDATE table SET status = DEFAULT                         │
 * │    → CASE: Conditional updates                                          │
 * │                                                                          │
 * │ 5. Use RETURNING to see updated rows                                    │
 * │                                                                          │
 * │ 6. Best practices:                                                      │
 * │    → Always test with SELECT first                                      │
 * │    → Always use WHERE (unless updating all rows)                        │
 * │    → Use transactions for multiple updates                              │
 * │    → Back up before mass updates                                        │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - UPDATE changes existing data (unlike INSERT which adds new)        │
 * │   - WHERE is your safety net!                                          │
 * │   - Test with SELECT before UPDATE                                     │
 * │   - Use RETURNING to verify changes                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF UPDATE SINGLE COLUMN GUIDE
-- ============================================================================