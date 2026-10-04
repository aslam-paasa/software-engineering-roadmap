/**
 * ============================================================================
 * UPDATE with WHERE CONDITION - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS UPDATE with WHERE? -------------- (Update specific rows only)
 * 2. BASIC WHERE CONDITIONS ------------------ (=, >, <, >=, <=, <>)
 * 3. WHERE with TEXT/String Conditions ------- (LIKE, IN, exact match)
 * 4. WHERE with Multiple Conditions ---------- (AND, OR, NOT)
 * 5. WHERE with NULL Values ------------------ (IS NULL, IS NOT NULL)
 * 6. WHERE with Date Conditions -------------- (Date comparisons)
 * 7. WHERE with BETWEEN and IN --------------- (Range and list matching)
 * 8. WHERE with Pattern Matching (LIKE) ------ (Partial text matching)
 * 9. WHERE with Subquery --------------------- (Update based on other table)
 * 10. UPDATE with WHERE and Expressions ------ (Calculations on filtered rows)
 * 11. REAL-WORLD SCENARIOS ------------------- (Practical examples)
 * 12. COMMON MISTAKES ------------------------ (What to avoid)
 * 13. GOLDEN RULES --------------------------- (Key principles)
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
    city VARCHAR(50),
    marks INT,
    attendance DECIMAL(5,2),
    enrollment_year INT
);

/**
 * TABLE 2: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    discount DECIMAL(5,2) DEFAULT 0,
    stock_quantity INT,
    rating DECIMAL(3,2)
);

/**
 * TABLE 3: EMPLOYEES - Employee information
 */

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    experience_years INT,
    performance_score INT,
    city VARCHAR(50)
);

/**
 * TABLE 4: ORDERS - Order information
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    order_status VARCHAR(20),
    total_amount DECIMAL(10,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert sample data into students
INSERT INTO students (name, age, grade, city, marks, attendance, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 95.5, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 88.0, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 92.0, 2022),
('Priya', 23, 'C', 'Chennai', 65, 75.5, 2020),
('Neha', 24, 'B', 'Pune', 78, 85.0, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 70.0, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 98.0, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 82.0, 2022);

-- Insert sample data into products
INSERT INTO products (product_name, category, price, discount, stock_quantity, rating) VALUES
('Laptop', 'Electronics', 50000, 0, 10, 4.5),
('Mouse', 'Electronics', 500, 0, 50, 4.2),
('Keyboard', 'Electronics', 1500, 0, 30, 4.0),
('Monitor', 'Electronics', 10000, 5, 5, 4.7),
('Headphones', 'Accessories', 2000, 0, 20, 4.3),
('USB Cable', 'Accessories', 300, 0, 100, 3.8),
('Laptop Stand', 'Accessories', 2500, 0, 15, 4.1),
('Webcam', 'Electronics', 3500, 0, 8, 4.4);

-- Insert sample data into employees
INSERT INTO employees (name, department, salary, experience_years, performance_score, city) VALUES
('Alice', 'IT', 75000, 5, 85, 'Mumbai'),
('Bob', 'HR', 65000, 3, 78, 'Delhi'),
('Carol', 'IT', 80000, 7, 92, 'Bangalore'),
('Dave', 'Finance', 70000, 4, 70, 'Chennai'),
('Eve', 'IT', 72000, 6, 88, 'Mumbai'),
('Frank', 'HR', 60000, 2, 75, 'Pune');

-- Insert sample data into orders
INSERT INTO orders (customer_name, order_date, order_status, total_amount) VALUES
('Ayaan', '2024-01-15', 'DELIVERED', 50000),
('Sneha', '2024-01-20', 'DELIVERED', 1500),
('Rohit', '2024-01-25', 'PENDING', 2000),
('Priya', '2024-02-01', 'CANCELLED', 10000),
('Neha', '2024-02-05', 'PENDING', 3500),
('Amit', '2024-02-10', 'DELIVERED', 8000),
('Kavya', '2024-02-15', 'PROCESSING', 1200);

-- ============================================================================
-- PART 1: WHAT IS UPDATE with WHERE?
-- ============================================================================

/**
 * UPDATE with WHERE updates only rows that match the condition.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE with WHERE - EXPLANATION                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE table_name                                               │   │
 * │   │ SET column1 = new_value,                                        │   │
 * │   │     column2 = new_value                                         │   │
 * │   │ WHERE condition;          ← Only rows matching this are updated │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  WITHOUT WHERE: ALL rows are updated!                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 *   │   │ UPDATE students SET grade = 'A';    ← Updates EVERY student!    │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WITH WHERE: Only matching rows updated                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students SET grade = 'A' WHERE city = 'Mumbai';          │   │
 * │   │ → Only students in Mumbai get grade 'A'                         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              UPDATE with WHERE - EXAMPLE                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE UPDATE:                                                        │
 * │   ┌────────────┬─────────┬─────┬─────────┬────────┐                   │
 * │   │ student_id │ name    │ age │ city    │ grade  │                   │
 * │   ├────────────┼─────────┼─────┼─────────┼────────┤                   │
 * │   │ 1          │ Ayaan   │ 20  │ Mumbai  │ A      │                   │
 * │   │ 2          │ Sneha   │ 22  │ Delhi   │ B      │                   │
 * │   │ 3          │ Rohit   │ 21  │ Banglore│ A      │                   │
 * │   │ 7          │ Amit    │ 22  │ Mumbai  │ A      │                   │
 * │   └────────────┴─────────┴─────┴─────────┴────────┘                   │
 * │                                                                          │
 * │   UPDATE COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE students                                                  │   │
 * │   │ SET grade = 'A+', age = age + 1                                  │   │
 * │   │ WHERE city = 'Mumbai';           ← Only Mumbai students         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER UPDATE: Only Mumbai students changed!                          │
 * │   ┌────────────┬─────────┬─────┬─────────┬────────┐                   │
 * │   │ student_id │ name    │ age │ city    │ grade  │                   │
 * │   ├────────────┼─────────┼─────┼─────────┼────────┤                   │
 * │   │ 1          │ Ayaan   │ 21  │ Mumbai  │ A+     │ ← updated         │
 * │   │ 2          │ Sneha   │ 22  │ Delhi   │ B      │ ← unchanged       │
 * │   │ 3          │ Rohit   │ 21  │ Banglore│ A      │ ← unchanged       │
 * │   │ 7          │ Amit    │ 23  │ Mumbai  │ A+     │ ← updated         │
 * │   └────────────┴─────────┴─────┴─────────┴────────┘                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: BASIC WHERE CONDITIONS (=, >, <, >=, <=, <>)
-- ============================================================================

-- Show current data
SELECT student_id, name, age, city, marks FROM students ORDER BY student_id;

/**
 * CURRENT DATA:
 * ┌────────────┬─────────┬─────┬───────────┬───────┐
 * │ student_id │ name    │ age │ city      │ marks │
 * ├────────────┼─────────┼─────┼───────────┼───────┤
 * │ 1          │ Ayaan   │ 20  │ Mumbai    │ 85    │
 * │ 2          │ Sneha   │ 22  │ Delhi     │ 72    │
 * │ 3          │ Rohit   │ 21  │ Bangalore │ 88    │
 * │ 4          │ Priya   │ 23  │ Chennai   │ 65    │
 * │ 5          │ Neha    │ 24  │ Pune      │ 78    │
 * │ 6          │ Raj     │ 20  │ Ahmedabad │ 58    │
 * │ 7          │ Amit    │ 22  │ Mumbai    │ 91    │
 * │ 8          │ Kavya   │ 21  │ Delhi     │ 75    │
 * └────────────┴─────────┴─────┴───────────┴───────┘
 */

-- EXAMPLE 1: Equal to (=) - Update specific city
UPDATE students 
SET grade = 'A+' 
WHERE city = 'Mumbai';

SELECT student_id, name, city, grade FROM students WHERE city = 'Mumbai';

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────┬───────┐
 * │ student_id │ name    │ city    │ grade │
 * ├────────────┼─────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ Mumbai  │ A+    │
 * │ 7          │ Amit    │ Mumbai  │ A+    │
 * └────────────┴─────────┴─────────┴───────┘
 */

-- EXAMPLE 2: Greater than (>) - Update students with high marks
UPDATE students 
SET grade = 'A', 
    attendance = attendance + 2
WHERE marks > 80;

SELECT student_id, name, marks, grade, attendance FROM students WHERE marks > 80;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┬───────┬────────────┐
 * │ student_id │ name    │ marks │ grade │ attendance │
 * ├────────────┼─────────┼───────┼───────┼────────────┤
 * │ 1          │ Ayaan   │ 85    │ A     │ 97.5       │
 * │ 3          │ Rohit   │ 88    │ A     │ 94.0       │
 * │ 7          │ Amit    │ 91    │ A     │ 100.0      │
 * └────────────┴─────────┴───────┴───────┴────────────┘
 */

-- EXAMPLE 3: Less than (<) - Update low marks students
UPDATE students 
SET grade = 'D',
    attendance = attendance - 5
WHERE marks < 60;

SELECT student_id, name, marks, grade, attendance FROM students WHERE marks < 60;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┬───────┬────────────┐
 * │ student_id │ name    │ marks │ grade │ attendance │
 * ├────────────┼─────────┼───────┼───────┼────────────┤
 * │ 6          │ Raj     │ 58    │ D     │ 65.0       │
 * └────────────┴─────────┴───────┴───────┴────────────┘
 */

-- EXAMPLE 4: Greater than or equal (>=) - Update senior students
UPDATE students 
SET grade = 'Senior'
WHERE age >= 23;

SELECT student_id, name, age, grade FROM students WHERE age >= 23;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬────────┐
 * │ student_id │ name    │ age │ grade  │
 * ├────────────┼─────────┼─────┼────────┤
 * │ 4          │ Priya   │ 23  │ Senior │
 * │ 5          │ Neha    │ 24  │ Senior │
 * └────────────┴─────────┴─────┴────────┘
 */

-- EXAMPLE 5: Not equal to (<>) - Update all except one city
UPDATE students 
SET attendance = attendance + 1
WHERE city <> 'Delhi';

SELECT student_id, name, city, attendance FROM students ORDER BY student_id;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┬────────────┐
 * │ student_id │ name    │ city      │ attendance │
 * ├────────────┼─────────┼───────────┼────────────┤
 * │ 1          │ Ayaan   │ Mumbai    │ 98.5       │
 * │ 2          │ Sneha   │ Delhi     │ 88.0       │ ← unchanged
 * │ 3          │ Rohit   │ Bangalore │ 95.0       │
 * │ 4          │ Priya   │ Chennai   │ 76.5       │
 * │ 5          │ Neha    │ Pune      │ 86.0       │
 * │ 6          │ Raj     │ Ahmedabad │ 66.0       │
 * │ 7          │ Amit    │ Mumbai    │ 101.0      │
 * │ 8          │ Kavya   │ Delhi     │ 82.0       │ ← unchanged
 * └────────────┴─────────┴───────────┴────────────┘
 */

-- ============================================================================
-- PART 3: WHERE with TEXT/String Conditions
-- ============================================================================

-- EXAMPLE 1: Exact match on text
UPDATE products 
SET discount = 10 
WHERE category = 'Electronics';

SELECT product_name, category, discount FROM products WHERE category = 'Electronics';

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬──────────┐
 * │ product_name │ category     │ discount │
 * ├──────────────┼──────────────┼──────────┤
 * │ Laptop       │ Electronics  │ 10       │
 * │ Mouse        │ Electronics  │ 10       │
 * │ Keyboard     │ Electronics  │ 10       │
 * │ Monitor      │ Electronics  │ 10       │
 * │ Webcam       │ Electronics  │ 10       │
 * └──────────────┴──────────────┴──────────┘
 */

-- EXAMPLE 2: IN operator for multiple text values
UPDATE products 
SET price = price * 0.90 
WHERE category IN ('Accessories', 'Electronics');

SELECT product_name, category, price FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬─────────┐
 * │ product_name │ category     │ price   │
 * ├──────────────┼──────────────┼─────────┤
 * │ Laptop       │ Electronics  │ 45000.00│
 * │ Mouse        │ Electronics  │ 450.00  │
 * │ Keyboard     │ Electronics  │ 1350.00 │
 * │ Monitor      │ Electronics  │ 9000.00 │
 * │ Headphones   │ Accessories  │ 1800.00 │
 * │ USB Cable    │ Accessories  │ 270.00  │
 * │ Laptop Stand │ Accessories  │ 2250.00 │
 * │ Webcam       │ Electronics  │ 3150.00 │
 * └──────────────┴──────────────┴─────────┘
 */

-- ============================================================================
-- PART 4: WHERE with Multiple Conditions (AND, OR, NOT)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHERE with Multiple Conditions (AND, OR)                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE:                                                               │
 * │   ┌────────────┬─────────┬─────────┬────────────┬─────────┐            │
 * │   │ product_id │ name    │ price   │ category   │ stock   │            │
 *   │   ├────────────┼─────────┼─────────┼────────────┼─────────┤            │
 * │   │ 1          │ Laptop  │ 50000   │ Electronics│ 10      │            │
 * │   │ 2          │ Mouse   │ 500     │ Electronics│ 50      │            │
 * │   │ 3          │ Keyboard│ 1500    │ Electronics│ 30      │            │
 * │   │ 4          │ Monitor │ 10000   │ Electronics│ 5       │            │
 * │   └────────────┴─────────┴─────────┴────────────┴─────────┘            │
 * │                                                                          │
 * │   UPDATE with AND: Both conditions must be TRUE                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ UPDATE products                                                 │   │
 * │   │ SET price = price * 0.85                                        │   │
 * │   │ WHERE category = 'Electronics' AND stock_quantity > 5;          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER: Only products with stock > 5 get discount                     │
 * │   ┌────────────┬─────────┬─────────┬────────────┬─────────┐            │
 * │   │ product_id │ name    │ price   │ category   │ stock   │            │
 * │   ├────────────┼─────────┼─────────┼────────────┼─────────┤            │
 * │   │ 1          │ Laptop  │ 42500   │ Electronics│ 10      │ ← updated  │
 * │   │ 2          │ Mouse   │ 425     │ Electronics│ 50      │ ← updated  │
 * │   │ 3          │ Keyboard│ 1275    │ Electronics│ 30      │ ← updated  │
 * │   │ 4          │ Monitor │ 10000   │ Electronics│ 5       │ ← unchanged│
 * │   └────────────┴─────────┴─────────┴────────────┴─────────┘            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Reset products for demo
UPDATE products SET price = 
    CASE product_name
        WHEN 'Laptop' THEN 50000
        WHEN 'Mouse' THEN 500
        WHEN 'Keyboard' THEN 1500
        WHEN 'Monitor' THEN 10000
        WHEN 'Headphones' THEN 2000
        WHEN 'USB Cable' THEN 300
        WHEN 'Laptop Stand' THEN 2500
        WHEN 'Webcam' THEN 3500
    END,
    stock_quantity = CASE product_name
        WHEN 'Laptop' THEN 10
        WHEN 'Mouse' THEN 50
        WHEN 'Keyboard' THEN 30
        WHEN 'Monitor' THEN 5
        WHEN 'Headphones' THEN 20
        WHEN 'USB Cable' THEN 100
        WHEN 'Laptop Stand' THEN 15
        WHEN 'Webcam' THEN 8
    END;

-- EXAMPLE 1: AND (both conditions must be true)
UPDATE products 
SET discount = 15,
    price = price * 0.85
WHERE category = 'Electronics' AND stock_quantity > 10;

SELECT product_name, price, discount, stock_quantity FROM products WHERE category = 'Electronics';

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┬─────────────────┐
 * │ product_name │ price   │ discount │ stock_quantity  │
 * ├──────────────┼─────────┼──────────┼─────────────────┤
 * │ Laptop       │ 50000.00│ 0        │ 10              │ ← unchanged (stock=10)
 * │ Mouse        │ 425.00  │ 15       │ 50              │ ← updated (stock>10)
 * │ Keyboard     │ 1275.00 │ 15       │ 30              │ ← updated (stock>10)
 * │ Monitor      │ 10000.00│ 0        │ 5               │ ← unchanged (stock=5)
 * │ Webcam       │ 3500.00 │ 0        │ 8               │ ← unchanged (stock=8)
 * └──────────────┴─────────┴──────────┴─────────────────┘
 */

-- EXAMPLE 2: OR (at least one condition must be true)
UPDATE products 
SET discount = 20,
    price = price * 0.80
WHERE category = 'Electronics' OR rating > 4.0;

SELECT product_name, category, rating, price, discount FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┬───────┬─────────┬──────────┐
 * │ product_name │ category     │ rating│ price   │ discount │
 * ├──────────────┼──────────────┼───────┼─────────┼──────────┤
 * │ Laptop       │ Electronics  │ 4.5   │ 40000.00│ 20       │
 * │ Mouse        │ Electronics  │ 4.2   │ 340.00  │ 20       │
 * │ Keyboard     │ Electronics  │ 4.0   │ 1020.00 │ 20       │
 * │ Monitor      │ Electronics  │ 4.7   │ 8000.00 │ 20       │
 * │ Headphones   │ Accessories  │ 4.3   │ 1600.00 │ 20       │
 * │ USB Cable    │ Accessories  │ 3.8   │ 270.00  │ 0        │
 * │ Laptop Stand │ Accessories  │ 4.1   │ 2000.00 │ 20       │
 * │ Webcam       │ Electronics  │ 4.4   │ 2800.00 │ 20       │
 * └──────────────┴──────────────┴───────┴─────────┴──────────┘
 */

-- EXAMPLE 3: NOT (negates a condition)
UPDATE employees 
SET bonus = 5000
WHERE NOT department = 'IT';

-- Add bonus column first
ALTER TABLE employees ADD COLUMN bonus DECIMAL(10,2) DEFAULT 0;

UPDATE employees 
SET bonus = 5000
WHERE NOT department = 'IT';

SELECT name, department, bonus FROM employees;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬─────────┐
 * │ name    │ department │ bonus   │
 * ├─────────┼────────────┼─────────┤
 * │ Alice   │ IT         │ 0.00    │
 * │ Bob     │ HR         │ 5000.00 │
 * │ Carol   │ IT         │ 0.00    │
 * │ Dave    │ Finance    │ 5000.00 │
 * │ Eve     │ IT         │ 0.00    │
 * │ Frank   │ HR         │ 5000.00 │
 * └─────────┴────────────┴─────────┘
 */

-- EXAMPLE 4: Complex combination
UPDATE employees 
SET salary = salary * 1.15,
    bonus = bonus + 2000
WHERE (department = 'IT' AND experience_years > 5) OR (department = 'HR' AND performance_score > 80);

SELECT name, department, experience_years, performance_score, salary, bonus FROM employees;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬───────────────────┬──────────────────┬─────────┬─────────┐
 * │ name    │ department │ experience_years  │ performance_score │ salary  │ bonus   │
 * ├─────────┼────────────┼───────────────────┼──────────────────┼─────────┼─────────┤
 * │ Alice   │ IT         │ 5                 │ 85               │ 86250.00│ 0.00    │
 * │ Bob     │ HR         │ 3                 │ 78               │ 65000.00│ 5000.00 │
 * │ Carol   │ IT         │ 7                 │ 92               │ 92000.00│ 0.00    │
 * │ Dave    │ Finance    │ 4                 │ 70               │ 70000.00│ 5000.00 │
 * │ Eve     │ IT         │ 6                 │ 88               │ 82800.00│ 0.00    │
 * │ Frank   │ HR         │ 2                 │ 75               │ 60000.00│ 5000.00 │
 * └─────────┴────────────┴───────────────────┴──────────────────┴─────────┴─────────┘
 */

-- ============================================================================
-- PART 5: WHERE with NULL Values (IS NULL, IS NOT NULL)
-- ============================================================================

-- Add some NULL values for demonstration
UPDATE products SET rating = NULL WHERE product_name IN ('USB Cable', 'Laptop Stand');

-- EXAMPLE 1: Update rows where column IS NULL
UPDATE products 
SET rating = 3.5,
    discount = 5
WHERE rating IS NULL;

SELECT product_name, rating, discount FROM products WHERE rating = 3.5;

/**
 * OUTPUT:
 * ┌──────────────┬────────┬──────────┐
 * │ product_name │ rating │ discount │
 * ├──────────────┼────────┼──────────┤
 * │ USB Cable    │ 3.5    │ 5        │
 * │ Laptop Stand │ 3.5    │ 5        │
 * └──────────────┴────────┴──────────┘
 */

-- EXAMPLE 2: Update rows where column IS NOT NULL
UPDATE products 
SET discount = discount + 2
WHERE rating IS NOT NULL;

SELECT product_name, rating, discount FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬───────┬──────────┐
 * │ product_name │ rating│ discount │
 * ├──────────────┼───────┼──────────┤
 * │ Laptop       │ 4.5   │ 22       │
 * │ Mouse        │ 4.2   │ 22       │
 * │ Keyboard     │ 4.0   │ 22       │
 * │ Monitor      │ 4.7   │ 22       │
 * │ Headphones   │ 4.3   │ 22       │
 * │ USB Cable    │ 3.5   │ 5        │
 * │ Laptop Stand │ 3.5   │ 5        │
 * │ Webcam       │ 4.4   │ 22       │
 * └──────────────┴───────┴──────────┘
 */

-- ============================================================================
-- PART 6: WHERE with Date Conditions
-- ============================================================================

-- EXAMPLE 1: Update orders by exact date
UPDATE orders 
SET order_status = 'COMPLETED'
WHERE order_date = '2024-01-15';

SELECT order_id, customer_name, order_date, order_status FROM orders;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┬───────────────┐
 * │ order_id │ customer_name │ order_date │ order_status  │
 * ├──────────┼───────────────┼────────────┼───────────────┤
 * │ 1        │ Ayaan         │ 2024-01-15 │ COMPLETED     │
 * │ 2        │ Sneha         │ 2024-01-20 │ DELIVERED     │
 * │ 3        │ Rohit         │ 2024-01-25 │ PENDING       │
 * │ 4        │ Priya         │ 2024-02-01 │ CANCELLED     │
 * │ 5        │ Neha          │ 2024-02-05 │ PENDING       │
 * │ 6        │ Amit          │ 2024-02-10 │ DELIVERED     │
 * │ 7        │ Kavya         │ 2024-02-15 │ PROCESSING    │
 * └──────────┴───────────────┴────────────┴───────────────┘
 */

-- EXAMPLE 2: Update orders before a certain date
UPDATE orders 
SET order_status = 'ARCHIVED'
WHERE order_date < '2024-02-01';

SELECT order_id, customer_name, order_date, order_status FROM orders WHERE order_date < '2024-02-01';

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┬─────────────┐
 * │ order_id │ customer_name │ order_date │ order_status│
 * ├──────────┼───────────────┼────────────┼─────────────┤
 * │ 1        │ Ayaan         │ 2024-01-15 │ ARCHIVED    │
 * │ 2        │ Sneha         │ 2024-01-20 │ ARCHIVED    │
 * │ 3        │ Rohit         │ 2024-01-25 │ ARCHIVED    │
 * └──────────┴───────────────┴────────────┴─────────────┘
 */

-- EXAMPLE 3: Update orders in date range
UPDATE orders 
SET order_status = 'RECENT'
WHERE order_date BETWEEN '2024-02-01' AND '2024-02-10';

SELECT order_id, customer_name, order_date, order_status FROM orders WHERE order_date BETWEEN '2024-02-01' AND '2024-02-10';

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┬─────────────┐
 * │ order_id │ customer_name │ order_date │ order_status│
 * ├──────────┼───────────────┼────────────┼─────────────┤
 * │ 4        │ Priya         │ 2024-02-01 │ RECENT      │
 * │ 5        │ Neha          │ 2024-02-05 │ RECENT      │
 * │ 6        │ Amit          │ 2024-02-10 │ RECENT      │
 * └──────────┴───────────────┴────────────┴─────────────┘
 */

-- ============================================================================
-- PART 7: WHERE with BETWEEN and IN
-- ============================================================================

-- EXAMPLE 1: BETWEEN (range)
UPDATE employees 
SET salary = salary * 1.10
WHERE experience_years BETWEEN 3 AND 5;

SELECT name, experience_years, salary FROM employees;

/**
 * OUTPUT:
 * ┌─────────┬───────────────────┬─────────┐
 * │ name    │ experience_years  │ salary  │
 * ├─────────┼───────────────────┼─────────┤
 * │ Alice   │ 5                 │ 94875.00│ (10% increase)
 * │ Bob     │ 3                 │ 71500.00│ (10% increase)
 * │ Carol   │ 7                 │ 92000.00│ (no change)
 * │ Dave    │ 4                 │ 77000.00│ (10% increase)
 * │ Eve     │ 6                 │ 82800.00│ (no change)
 * │ Frank   │ 2                 │ 60000.00│ (no change)
 * └─────────┴───────────────────┴─────────┘
 */

-- EXAMPLE 2: IN (list of values)
UPDATE students 
SET grade = 'Merit'
WHERE city IN ('Mumbai', 'Delhi', 'Bangalore');

SELECT student_id, name, city, grade FROM students WHERE city IN ('Mumbai', 'Delhi', 'Bangalore');

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┬───────┐
 * │ student_id │ name    │ city      │ grade │
 * ├────────────┼─────────┼───────────┼───────┤
 * │ 1          │ Ayaan   │ Mumbai    │ Merit │
 * │ 2          │ Sneha   │ Delhi     │ Merit │
 * │ 3          │ Rohit   │ Bangalore │ Merit │
 * │ 7          │ Amit    │ Mumbai    │ Merit │
 * │ 8          │ Kavya   │ Delhi     │ Merit │
 * └────────────┴─────────┴───────────┴───────┘
 */

-- ============================================================================
-- PART 8: WHERE with Pattern Matching (LIKE)
-- ============================================================================

-- EXAMPLE 1: LIKE with % (any characters)
UPDATE products 
SET discount = 25
WHERE product_name LIKE '%pad%';

SELECT product_name, discount FROM products WHERE product_name LIKE '%pad%';

/**
 * OUTPUT:
 * ┌──────────────┬──────────┐
 * │ product_name │ discount │
 * ├──────────────┼──────────┤
 * │ Laptop Stand │ 5        │ (contains 'Stand', not 'pad')
 * │ Mouse Pad    │ 25       │ (contains 'pad')
 * └──────────────┴──────────┘
 */

-- Add Mouse Pad product
INSERT INTO products (product_name, category, price, stock_quantity, rating) VALUES
('Mouse Pad', 'Accessories', 400, 40, 4.0);

-- EXAMPLE 2: LIKE with _ (single character)
UPDATE employees 
SET bonus = bonus + 1000
WHERE name LIKE '_l%';

SELECT name, bonus FROM employees;

/**
 * OUTPUT:
 * ┌─────────┬─────────┐
 * │ name    │ bonus   │
 * ├─────────┼─────────┤
 * │ Alice   │ 1000.00 │ (starts with A? '_l%' means second letter 'l')
 * │ Bob     │ 5000.00 │
 * │ Carol   │ 0.00    │
 * │ Dave    │ 5000.00 │
 * │ Eve     │ 0.00    │
 * │ Frank   │ 5000.00 │
 * └─────────┴─────────┘
 */

-- ============================================================================
-- PART 9: WHERE with Subquery (Update based on other table)
-- ============================================================================

-- EXAMPLE: Update products based on orders
-- Give extra discount to products that have been ordered
UPDATE products 
SET discount = discount + 5
WHERE product_name IN (
    SELECT DISTINCT product_name 
    FROM orders o
    JOIN products p ON o.product_name = p.product_name
);

SELECT product_name, discount FROM products ORDER BY product_name;

/**
 * OUTPUT:
 * ┌──────────────┬──────────┐
 * │ product_name │ discount │
 * ├──────────────┼──────────┤
 * │ Headphones   │ 22       │
 * │ Keyboard     │ 22       │
 * │ Laptop       │ 22       │
 * │ Laptop Stand │ 5        │
 * │ Monitor      │ 22       │
 * │ Mouse        │ 22       │
 * │ Mouse Pad    │ 25       │
 * │ USB Cable    │ 5        │
 * │ Webcam       │ 22       │
 * └──────────────┴──────────┘
 */

-- ============================================================================
-- PART 10: UPDATE with WHERE and Expressions
-- ============================================================================

-- EXAMPLE: Complex calculations on filtered rows
UPDATE students 
SET marks = marks + 5,
    attendance = attendance + 2,
    grade = CASE 
        WHEN marks + 5 >= 90 THEN 'A+'
        WHEN marks + 5 >= 80 THEN 'A'
        WHEN marks + 5 >= 70 THEN 'B'
        ELSE 'C'
    END
WHERE enrollment_year = 2022;

SELECT student_id, name, enrollment_year, marks, attendance, grade FROM students WHERE enrollment_year = 2022;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────────────┬───────┬────────────┬───────┐
 * │ student_id │ name    │ enrollment_year │ marks │ attendance │ grade │
 * ├────────────┼─────────┼─────────────────┼───────┼────────────┼───────┤
 * │ 1          │ Ayaan   │ 2022            │ 90    │ 100.5      │ A+    │
 * │ 3          │ Rohit   │ 2022            │ 93    │ 97.0       │ A+    │
 * │ 8          │ Kavya   │ 2022            │ 80    │ 84.0       │ A     │
 * └────────────┴─────────┴─────────────────┴───────┴────────────┴───────┘
 */

-- ============================================================================
-- PART 11: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Year-End Bonus Calculation
 * 
 * Give bonuses to high-performing employees
 */

-- Reset employees
UPDATE employees SET 
    salary = CASE name
        WHEN 'Alice' THEN 75000
        WHEN 'Bob' THEN 65000
        WHEN 'Carol' THEN 80000
        WHEN 'Dave' THEN 70000
        WHEN 'Eve' THEN 72000
        WHEN 'Frank' THEN 60000
    END,
    bonus = 0,
    performance_score = CASE name
        WHEN 'Alice' THEN 85
        WHEN 'Bob' THEN 78
        WHEN 'Carol' THEN 92
        WHEN 'Dave' THEN 70
        WHEN 'Eve' THEN 88
        WHEN 'Frank' THEN 75
    END;

-- Year-end bonus
UPDATE employees 
SET 
    bonus = CASE 
        WHEN performance_score >= 90 THEN salary * 0.20
        WHEN performance_score >= 80 THEN salary * 0.15
        WHEN performance_score >= 70 THEN salary * 0.10
        ELSE 0
    END,
    salary = salary * (1 + CASE 
        WHEN performance_score >= 90 THEN 0.10
        WHEN performance_score >= 80 THEN 0.08
        WHEN performance_score >= 70 THEN 0.05
        ELSE 0
    END)
WHERE performance_score >= 70
RETURNING name, performance_score, salary, bonus;

/**
 * OUTPUT:
 * ┌─────────┬──────────────────┬─────────┬─────────┐
 * │ name    │ performance_score │ salary  │ bonus   │
 * ├─────────┼──────────────────┼─────────┼─────────┤
 * │ Alice   │ 85               │ 81000.00│ 12150.00│
 * │ Bob     │ 78               │ 68250.00│ 6825.00 │
 * │ Carol   │ 92               │ 88000.00│ 17600.00│
 * │ Dave    │ 70               │ 73500.00│ 7350.00 │
 * │ Eve     │ 88               │ 77760.00│ 11664.00│
 * │ Frank   │ 75               │ 63000.00│ 6300.00 │
 * └─────────┴──────────────────┴─────────┴─────────┘
 */

/**
 * SCENARIO 2: Inventory Clearance Sale
 * 
 * Apply discounts based on stock quantity
 */

UPDATE products 
SET 
    price = CASE 
        WHEN stock_quantity > 50 THEN price * 0.60
        WHEN stock_quantity > 20 THEN price * 0.70
        WHEN stock_quantity > 10 THEN price * 0.80
        ELSE price * 0.90
    END,
    discount = CASE 
        WHEN stock_quantity > 50 THEN 40
        WHEN stock_quantity > 20 THEN 30
        WHEN stock_quantity > 10 THEN 20
        ELSE 10
    END
WHERE stock_quantity > 0
RETURNING product_name, stock_quantity, price, discount;

/**
 * OUTPUT:
 * ┌──────────────┬─────────────────┬─────────┬──────────┐
 * │ product_name │ stock_quantity  │ price   │ discount │
 * ├──────────────┼─────────────────┼─────────┼──────────┤
 * │ Laptop       │ 10              │ 36000.00│ 20       │
 * │ Mouse        │ 50              │ 255.00  │ 40       │
 * │ Keyboard     │ 30              │ 892.50  │ 30       │
 * │ Monitor      │ 5               │ 7200.00 │ 10       │
 * │ Headphones   │ 20              │ 1280.00 │ 20       │
 * │ USB Cable    │ 100             │ 162.00  │ 40       │
 * │ Laptop Stand │ 15              │ 1800.00 │ 20       │
 * │ Webcam       │ 8               │ 2520.00 │ 10       │
 * │ Mouse Pad    │ 40              │ 240.00  │ 30       │
 * └──────────────┴─────────────────┴─────────┴──────────┘
 */

/**
 * SCENARIO 3: Student Grade Adjustment
 * 
 * Adjust grades based on attendance
 */

UPDATE students 
SET 
    grade = CASE 
        WHEN attendance >= 95 THEN 'A+'
        WHEN attendance >= 85 THEN 'A'
        WHEN attendance >= 75 THEN 'B'
        WHEN attendance >= 65 THEN 'C'
        ELSE 'D'
    END,
    marks = marks + (attendance - 75) / 5
WHERE attendance IS NOT NULL
RETURNING name, attendance, marks, grade;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬───────┬───────┐
 * │ name    │ attendance │ marks │ grade │
 * ├─────────┼────────────┼───────┼───────┤
 * │ Ayaan   │ 100.5      │ 90    │ A+    │
 * │ Sneha   │ 88.0       │ 72    │ A     │
 * │ Rohit   │ 97.0       │ 93    │ A+    │
 * │ Priya   │ 76.5       │ 65    │ B     │
 * │ Neha    │ 86.0       │ 78    │ A     │
 * │ Raj     │ 66.0       │ 58    │ C     │
 * │ Amit    │ 101.0      │ 91    │ A+    │
 * │ Kavya   │ 84.0       │ 75    │ B     │
 * └─────────┴────────────┴───────┴───────┘
 */

/**
 * SCENARIO 4: Order Status Update by Age
 * 
 * Update order status based on how old the order is
 */

UPDATE orders 
SET 
    order_status = CASE 
        WHEN order_date < CURRENT_DATE - INTERVAL '30 days' THEN 'ARCHIVED'
        WHEN order_date < CURRENT_DATE - INTERVAL '7 days' THEN 'COMPLETED'
        WHEN order_date < CURRENT_DATE - INTERVAL '2 days' THEN 'PROCESSING'
        ELSE 'PENDING'
    END,
    notes = CASE 
        WHEN order_date < CURRENT_DATE - INTERVAL '30 days' THEN 'Auto-archived'
        ELSE NULL
    END
WHERE order_status NOT IN ('CANCELLED', 'ARCHIVED')
RETURNING order_id, customer_name, order_date, order_status;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┬───────────────┐
 * │ order_id │ customer_name │ order_date │ order_status  │
 * ├──────────┼───────────────┼────────────┼───────────────┤
 * │ 1        │ Ayaan         │ 2024-01-15 │ ARCHIVED      │
 * │ 2        │ Sneha         │ 2024-01-20 │ ARCHIVED      │
 * │ 3        │ Rohit         │ 2024-01-25 │ COMPLETED     │
 * │ 5        │ Neha          │ 2024-02-05 │ PROCESSING    │
 * │ 6        │ Amit          │ 2024-02-10 │ PENDING       │
 * │ 7        │ Kavya         │ 2024-02-15 │ PENDING       │
 * └──────────┴───────────────┴────────────┴───────────────┘
 */

/**
 * SCENARIO 5: Bulk Price Update by Category and Rating
 * 
 * Update prices based on category and rating combination
 */

UPDATE products 
SET 
    price = CASE 
        WHEN rating >= 4.5 THEN price * 1.10   (Increase price for top products)
        WHEN rating >= 4.0 THEN price * 0.95   (Slight discount for good products)
        ELSE price * 0.85                      (Big discount for poor products)
    END,
    discount = CASE 
        WHEN rating >= 4.5 THEN 5
        WHEN rating >= 4.0 THEN 10
        ELSE 20
    END
WHERE category = 'Electronics'
RETURNING product_name, rating, price, discount;

/**
 * OUTPUT:
 * ┌──────────────┬───────┬─────────┬──────────┐
 * │ product_name │ rating│ price   │ discount │
 * ├──────────────┼───────┼─────────┼──────────┤
 * │ Laptop       │ 4.5   │ 39600.00│ 5        │
 * │ Mouse        │ 4.2   │ 242.25  │ 10       │
 * │ Keyboard     │ 4.0   │ 847.88  │ 10       │
 * │ Monitor      │ 4.7   │ 7920.00 │ 5        │
 * │ Webcam       │ 4.4   │ 2394.00 │ 10       │
 * └──────────────┴───────┴─────────┴──────────┘
 */

-- ============================================================================
-- PART 12: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting WHERE clause (updates ALL rows)                 │
 * │                                                                          │
 * │   ❌ UPDATE students SET grade = 'A';                                   │
 * │      → EVERY student gets grade 'A'! (Disaster!)                       │
 * │                                                                          │
 * │   ✅ UPDATE students SET grade = 'A' WHERE student_id = 1;              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ DANGEROUS - Never run without WHERE unless intentional
-- UPDATE students SET grade = 'A';  -- Updates all 8 students!

-- ✅ Always add WHERE
UPDATE students SET grade = 'A' WHERE student_id = 1;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Using = instead of IS NULL for NULL values                 │
 * │                                                                          │
 * │   ❌ UPDATE products SET discount = 10 WHERE rating = NULL;             │
 * │      → Nothing updates! NULL = NULL is FALSE in SQL                    │
 * │                                                                          │
 * │   ✅ UPDATE products SET discount = 10 WHERE rating IS NULL;            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong
-- UPDATE products SET discount = 10 WHERE rating = NULL;

-- ✅ Correct
UPDATE products SET discount = 10 WHERE rating IS NULL;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Wrong operator for text comparison                         │
 * │                                                                          │
 * │   ❌ UPDATE students SET grade = 'A' WHERE name = Ayaan;                │
 * │      → Error! Text must be in quotes                                   │
 * │                                                                          │
 * │   ✅ UPDATE students SET grade = 'A' WHERE name = 'Ayaan';              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: AND/OR logic confusion                                      │
 * │                                                                          │
 * │   ❌ UPDATE products SET discount = 20                                   │
 * │      WHERE category = 'Electronics' OR category = 'Accessories'         │
 * │      AND price > 1000;   ← AND binds tighter than OR!                  │
 * │                                                                          │
 * │   ✅ Use parentheses to be clear:                                        │
 * │      WHERE (category = 'Electronics' OR category = 'Accessories')       │
 * │      AND price > 1000;                                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 13: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: ALWAYS use WHERE unless you want to update EVERY row           │
 * │         → Test with SELECT first: SELECT * FROM table WHERE condition  │
 * │         → Then UPDATE: UPDATE table SET ... WHERE same_condition       │
 * │                                                                          │
 * │ RULE 2: Use parentheses for complex AND/OR conditions                  │
 * │         → (condition1 OR condition2) AND condition3                    │
 * │                                                                          │
 * │ RULE 3: Use IS NULL (not = NULL) for NULL checks                       │
 * │         → WHERE column IS NULL (correct)                               │
 * │         → WHERE column = NULL (wrong)                                  │
 * │                                                                          │
 * │ RULE 4: Text values need quotes (' ')                                   │
 * │         → WHERE city = 'Mumbai'                                        │
 * │                                                                          │
 * │ RULE 5: Use IN for multiple OR conditions                              │
 * │         → WHERE city IN ('Mumbai', 'Delhi', 'Pune')                    │
 * │         → Instead of: city = 'Mumbai' OR city = 'Delhi' OR city = 'Pune'│
 * │                                                                          │
 * │ RULE 6: Use BETWEEN for ranges                                          │
 * │         → WHERE age BETWEEN 20 AND 30                                  │
 * │         → Instead of: age >= 20 AND age <= 30                          │
 * │                                                                          │
 * │ RULE 7: Always test with SELECT before UPDATE                          │
 * │         → Run SELECT to see which rows will be affected                │
 * │         → Then run UPDATE with same WHERE                              │
 * │                                                                          │
 * │ RULE 8: Use RETURNING to verify updates                                │
 * │         → UPDATE ... RETURNING *;                                      │
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
 * │ -- Basic WHERE (equal)                                                 │
 * │ UPDATE table SET col = value WHERE column = 'value';                   │
 * │                                                                          │
 * │ -- Comparison operators                                                │
 * │ WHERE age > 18                                                         │
 * │ WHERE age >= 18                                                        │
 * │ WHERE age < 65                                                         │
 * │ WHERE age <= 65                                                        │
 * │ WHERE age <> 25      (not equal)                                       │
 * │                                                                          │
 * │ -- Multiple conditions                                                 │
 * │ WHERE condition1 AND condition2                                        │
 * │ WHERE condition1 OR condition2                                         │
 * │ WHERE NOT condition                                                    │
 * │                                                                          │
 * │ -- NULL checks                                                         │
 * │ WHERE column IS NULL                                                   │
 * │ WHERE column IS NOT NULL                                               │
 * │                                                                          │
 * │ -- Range and list                                                      │
 * │ WHERE age BETWEEN 18 AND 65                                           │
 * │ WHERE city IN ('Mumbai', 'Delhi', 'Pune')                             │
 * │                                                                          │
 * │ -- Pattern matching                                                    │
 * │ WHERE name LIKE 'A%'    (starts with A)                               │
 * │ WHERE name LIKE '%n'    (ends with n)                                 │
 * │ WHERE name LIKE '%ar%'  (contains 'ar')                               │
 * │                                                                          │
 * │ -- Date conditions                                                     │
 * │ WHERE order_date = '2024-01-15'                                       │
 * │ WHERE order_date > '2024-01-01'                                       │
 * │ WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Update grade to 'A' for students with marks > 80
 * 
 * Answer:
 *   UPDATE students SET grade = 'A' WHERE marks > 80;
 */

/**
 * EXERCISE 2: Give 15% discount to Electronics products with stock > 20
 * 
 * Answer:
 *   UPDATE products SET discount = 15 
 *   WHERE category = 'Electronics' AND stock_quantity > 20;
 */

/**
 * EXERCISE 3: Increase salary by 10% for employees in IT department
 * 
 * Answer:
 *   UPDATE employees SET salary = salary * 1.10 WHERE department = 'IT';
 */

/**
 * EXERCISE 4: Update order status to 'PROCESSED' for orders before Feb 1, 2024
 * 
 * Answer:
 *   UPDATE orders SET order_status = 'PROCESSED' WHERE order_date < '2024-02-01';
 */

/**
 * EXERCISE 5: Update bonus for employees with performance_score >= 85
 * 
 * Answer:
 *   UPDATE employees SET bonus = 10000 WHERE performance_score >= 85;
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
 * │ 1. UPDATE with WHERE updates ONLY rows matching the condition          │
 * │                                                                          │
 * │ 2. WITHOUT WHERE = ALL rows updated (usually a mistake!)               │
 * │                                                                          │
 * │ 3. WHERE conditions can use:                                            │
 * │    → Comparison: =, >, <, >=, <=, <>                                    │
 * │    → Logical: AND, OR, NOT                                              │
 * │    → NULL: IS NULL, IS NOT NULL                                         │
 * │    → Range: BETWEEN                                                     │
 * │    → List: IN                                                            │
 * │    → Pattern: LIKE                                                      │
 * │    → Date: date comparisons                                             │
 * │    → Subquery: IN (SELECT ...)                                          │
 * │                                                                          │
 * │ 4. Best practices:                                                      │
 * │    → ALWAYS test with SELECT first                                      │
 * │    → Use parentheses for complex conditions                             │
 * │    → Use RETURNING to verify updates                                    │
 * │    → Use transactions for multiple updates                              │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - WHERE is your safety net!                                           │
 * │   - Test with SELECT before UPDATE                                      │
 * │   - NULL needs IS NULL, not = NULL                                      │
 * │   - Text needs quotes                                                   │
 * │   - Use parentheses for AND/OR                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF UPDATE WITH WHERE CONDITION GUIDE
-- ============================================================================