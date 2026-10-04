/**
 * ============================================================================
 * DELETE with WHERE - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS DELETE? --------------------------- (Removing data from tables)
 * 2. DELETE with WHERE - BASIC ---------------- (Delete specific rows)
 * 3. DELETE with Comparison Operators --------- (=, >, <, >=, <=, <>)
 * 4. DELETE with Multiple Conditions ---------- (AND, OR, NOT)
 * 5. DELETE with NULL Values ------------------ (IS NULL, IS NOT NULL)
 * 6. DELETE with IN and BETWEEN --------------- (Range and list deletion)
 * 7. DELETE with LIKE (Pattern Matching) ------ (Delete matching patterns)
 * 8. DELETE with Subquery --------------------- (Delete based on other table)
 * 9. DELETE with JOIN (PostgreSQL) ------------ (Delete using another table)
 * 10. DELETE All Rows (Without WHERE) --------- (BE CAREFUL!)
 * 11. DELETE with RETURNING ------------------- (See what was deleted)
 * 12. REAL-WORLD SCENARIOS -------------------- (Practical examples)
 * 13. COMMON MISTAKES ------------------------- (What to avoid)
 * 14. GOLDEN RULES ---------------------------- (Key principles)
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
    enrollment_year INT,
    is_active BOOLEAN DEFAULT TRUE
);

/**
 * TABLE 2: PRODUCTS - Product catalog
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT,
    is_discontinued BOOLEAN DEFAULT FALSE
);

/**
 * TABLE 3: ORDERS - Order information
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    order_status VARCHAR(20),
    total_amount DECIMAL(10,2)
);

/**
 * TABLE 4: EMPLOYEES - Employee information
 */

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    experience_years INT,
    is_active BOOLEAN DEFAULT TRUE
);

/**
 * TABLE 5: OLD_ORDERS - Archive table for deletion examples
 */

CREATE TABLE old_orders (
    order_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

-- Insert sample data into students
INSERT INTO students (name, age, grade, city, marks, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 2022),
('Priya', 23, 'C', 'Chennai', 65, 2020),
('Neha', 24, 'B', 'Pune', 78, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 2022),
('Test1', 25, 'D', 'TestCity', 45, 2020),
('Test2', 26, 'F', 'TestCity', 35, 2019);

-- Insert sample data into products
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 50000, 10),
('Mouse', 'Electronics', 500, 50),
('Keyboard', 'Electronics', 1500, 30),
('Monitor', 'Electronics', 10000, 5),
('Headphones', 'Accessories', 2000, 20),
('USB Cable', 'Accessories', 300, 100),
('Laptop Stand', 'Accessories', 2500, 15),
('Webcam', 'Electronics', 3500, 8),
('Old Product 1', 'Discontinued', 100, 0),
('Old Product 2', 'Discontinued', 200, 0);

-- Insert sample data into orders
INSERT INTO orders (customer_name, order_date, order_status, total_amount) VALUES
('Ayaan', '2024-01-15', 'DELIVERED', 50000),
('Sneha', '2024-01-20', 'DELIVERED', 1500),
('Rohit', '2024-01-25', 'PENDING', 2000),
('Priya', '2024-02-01', 'CANCELLED', 10000),
('Neha', '2024-02-05', 'PENDING', 3500),
('Amit', '2024-02-10', 'DELIVERED', 8000),
('Kavya', '2024-02-15', 'PROCESSING', 1200),
('TestUser', '2024-03-01', 'PENDING', 500),
('OldOrder1', '2023-01-01', 'DELIVERED', 1000),
('OldOrder2', '2023-02-01', 'DELIVERED', 2000);

-- Insert sample data into employees
INSERT INTO employees (name, department, salary, experience_years) VALUES
('Alice', 'IT', 75000, 5),
('Bob', 'HR', 65000, 3),
('Carol', 'IT', 80000, 7),
('Dave', 'Finance', 70000, 4),
('Eve', 'IT', 72000, 6),
('Frank', 'HR', 60000, 2),
('Grace', 'Finance', 68000, 3),
('Henry', 'IT', 55000, 1),
('Ivy', 'HR', 58000, 1),
('Jack', 'Finance', 62000, 2);

-- ============================================================================
-- PART 1: WHAT IS DELETE?
-- ============================================================================

/**
 * DELETE removes rows permanently from a table.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS DELETE?                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM table_name                                          │   │
 * │   │ WHERE condition;          ← Only rows matching this are deleted │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  WITHOUT WHERE: ALL rows are deleted!                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM students;     ← Deletes EVERY student!              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ⚠️  DELETE is PERMANENT! Cannot be undone (unless in transaction)    │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ "Remove a student who has graduated"                            │   │
 * │   │                                                                  │   │
 *   │   │ BEFORE: Student exists in database                             │   │
 * │   │ DELETE FROM students WHERE student_id = 5;                      │   │
 * │   │ AFTER: Student record is GONE forever!                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    DELETE with WHERE - EXAMPLE                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE DELETE:                                                        │
 * │   ┌────────────┬─────────┬─────┬─────────┬────────┐                   │
 * │   │ student_id │ name    │ age │ city    │ grade  │                   │
 * │   ├────────────┼─────────┼─────┼─────────┼────────┤                   │
 * │   │ 1          │ Ayaan   │ 20  │ Mumbai  │ A      │                   │
 * │   │ 2          │ Sneha   │ 22  │ Delhi   │ B      │                   │
 * │   │ 3          │ Rohit   │ 21  │ Banglore│ A      │                   │
 * │   │ 9          │ Test1   │ 25  │ TestCity│ D      │                   │
 * │   │ 10         │ Test2   │ 26  │ TestCity│ F      │                   │
 * │   └────────────┴─────────┴─────┴─────────┴────────┘                   │
 * │                                                                          │
 * │   DELETE COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM students WHERE city = 'TestCity';                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER DELETE: Test students are removed!                             │
 * │   ┌────────────┬─────────┬─────┬─────────┬────────┐                   │
 * │   │ student_id │ name    │ age │ city    │ grade  │                   │
 * │   ├────────────┼─────────┼─────┼─────────┼────────┤                   │
 * │   │ 1          │ Ayaan   │ 20  │ Mumbai  │ A      │                   │
 * │   │ 2          │ Sneha   │ 22  │ Delhi   │ B      │                   │
 * │   │ 3          │ Rohit   │ 21  │ Banglore│ A      │                   │
 * │   └────────────┴─────────┴─────┴─────────┴────────┘                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: DELETE with WHERE - BASIC (Delete specific rows)
-- ============================================================================

-- Show current data
SELECT student_id, name, city, grade FROM students ORDER BY student_id;

/**
 * CURRENT DATA:
 * ┌────────────┬─────────┬───────────┬───────┐
 * │ student_id │ name    │ city      │ grade │
 * ├────────────┼─────────┼───────────┼───────┤
 * │ 1          │ Ayaan   │ Mumbai    │ A     │
 * │ 2          │ Sneha   │ Delhi     │ B     │
 * │ 3          │ Rohit   │ Bangalore │ A     │
 * │ 4          │ Priya   │ Chennai   │ C     │
 * │ 5          │ Neha    │ Pune      │ B     │
 * │ 6          │ Raj     │ Ahmedabad │ C     │
 * │ 7          │ Amit    │ Mumbai    │ A     │
 * │ 8          │ Kavya   │ Delhi     │ B     │
 * │ 9          │ Test1   │ TestCity  │ D     │
 * │ 10         │ Test2   │ TestCity  │ F     │
 * └────────────┴─────────┴───────────┴───────┘
 */

-- EXAMPLE 1: Delete a specific student by ID
DELETE FROM students WHERE student_id = 9;

SELECT student_id, name FROM students WHERE student_id = 9;

/**
 * OUTPUT:
 * (no rows - student 9 is deleted)
 */

-- EXAMPLE 2: Delete by name
DELETE FROM students WHERE name = 'Test2';

SELECT student_id, name FROM students WHERE name = 'Test2';

/**
 * OUTPUT:
 * (no rows - Test2 is deleted)
 */

-- View remaining students
SELECT student_id, name, city FROM students ORDER BY student_id;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┐
 * │ student_id │ name    │ city      │
 * ├────────────┼─────────┼───────────┤
 * │ 1          │ Ayaan   │ Mumbai    │
 * │ 2          │ Sneha   │ Delhi     │
 * │ 3          │ Rohit   │ Bangalore │
 * │ 4          │ Priya   │ Chennai   │
 * │ 5          │ Neha    │ Pune      │
 * │ 6          │ Raj     │ Ahmedabad │
 * │ 7          │ Amit    │ Mumbai    │
 * │ 8          │ Kavya   │ Delhi     │
 * └────────────┴─────────┴───────────┘
 */

-- ============================================================================
-- PART 3: DELETE with Comparison Operators (=, >, <, >=, <=, <>)
-- ============================================================================

-- EXAMPLE 1: Delete students with age less than 21
DELETE FROM students WHERE age < 21;

SELECT student_id, name, age FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┐
 * │ student_id │ name    │ age │
 * ├────────────┼─────────┼─────┤
 * │ 2          │ Sneha   │ 22  │
 * │ 4          │ Priya   │ 23  │
 * │ 5          │ Neha    │ 24  │
 * │ 7          │ Amit    │ 22  │
 * └────────────┴─────────┴─────┘
 * 
 * EXPLANATION: Students age 20 and 21 were deleted (Ayaan, Rohit, Raj, Kavya)
 */

-- Reset students for next example
TRUNCATE students RESTART IDENTITY;

-- Re-insert original data
INSERT INTO students (name, age, grade, city, marks, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 2022),
('Priya', 23, 'C', 'Chennai', 65, 2020),
('Neha', 24, 'B', 'Pune', 78, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 2022),
('Test1', 25, 'D', 'TestCity', 45, 2020),
('Test2', 26, 'F', 'TestCity', 35, 2019);

-- EXAMPLE 2: Delete students with marks greater than 80
DELETE FROM students WHERE marks > 80;

SELECT student_id, name, marks FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ marks │
 * ├────────────┼─────────┼───────┤
 * │ 2          │ Sneha   │ 72    │
 * │ 4          │ Priya   │ 65    │
 * │ 5          │ Neha    │ 78    │
 * │ 6          │ Raj     │ 58    │
 * │ 8          │ Kavya   │ 75    │
 * │ 9          │ Test1   │ 45    │
 * │ 10         │ Test2   │ 35    │
 * └────────────┴─────────┴───────┘
 * 
 * EXPLANATION: Students with marks > 80 (Ayaan, Rohit, Amit) were deleted
 */

-- Reset for next examples
TRUNCATE students RESTART IDENTITY;
INSERT INTO students (name, age, grade, city, marks, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 2022),
('Priya', 23, 'C', 'Chennai', 65, 2020),
('Neha', 24, 'B', 'Pune', 78, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 2022),
('Test1', 25, 'D', 'TestCity', 45, 2020),
('Test2', 26, 'F', 'TestCity', 35, 2019);

-- EXAMPLE 3: Delete students with marks less than or equal to 60
DELETE FROM students WHERE marks <= 60;

SELECT student_id, name, marks FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────┐
 * │ student_id │ name    │ marks │
 * ├────────────┼─────────┼───────┤
 * │ 1          │ Ayaan   │ 85    │
 * │ 2          │ Sneha   │ 72    │
 * │ 3          │ Rohit   │ 88    │
 * │ 4          │ Priya   │ 65    │
 * │ 5          │ Neha    │ 78    │
 * │ 7          │ Amit    │ 91    │
 * │ 8          │ Kavya   │ 75    │
 * └────────────┴─────────┴───────┘
 * 
 * EXPLANATION: Students with marks <= 60 (Raj, Test1, Test2) were deleted
 */

-- Reset
TRUNCATE students RESTART IDENTITY;
INSERT INTO students (name, age, grade, city, marks, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 2022),
('Priya', 23, 'C', 'Chennai', 65, 2020),
('Neha', 24, 'B', 'Pune', 78, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 2022),
('Test1', 25, 'D', 'TestCity', 45, 2020),
('Test2', 26, 'F', 'TestCity', 35, 2019);

-- EXAMPLE 4: Delete students not from Mumbai (not equal to)
DELETE FROM students WHERE city <> 'Mumbai';

SELECT student_id, name, city FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────┐
 * │ student_id │ name    │ city    │
 * ├────────────┼─────────┼─────────┤
 * │ 1          │ Ayaan   │ Mumbai  │
 * │ 7          │ Amit    │ Mumbai  │
 * └────────────┴─────────┴─────────┘
 * 
 * EXPLANATION: Only students from Mumbai remain
 */

-- ============================================================================
-- PART 4: DELETE with Multiple Conditions (AND, OR, NOT)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              DELETE with Multiple Conditions (AND, OR)                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE:                                                               │
 * │   ┌────────────┬─────────┬───────────┬─────────┬───────┐               │
 * │   │ student_id │ name    │ city      │ marks   │ grade │               │
 * │   ├────────────┼─────────┼───────────┼─────────┼───────┤               │
 * │   │ 1          │ Ayaan   │ Mumbai    │ 85      │ A     │               │
 * │   │ 2          │ Sneha   │ Delhi     │ 72      │ B     │               │
 * │   │ 3          │ Rohit   │ Bangalore │ 88      │ A     │               │
 * │   │ 4          │ Priya   │ Chennai   │ 65      │ C     │               │
 * │   └────────────┴─────────┴───────────┴─────────┴───────┘               │
 * │                                                                          │
 * │   DELETE with AND (both conditions must be true)                        │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM students WHERE city = 'Mumbai' AND marks < 90;      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER: Only students from Mumbai with marks < 90 are deleted         │
 * │   ┌────────────┬─────────┬───────────┬─────────┬───────┐               │
 * │   │ student_id │ name    │ city      │ marks   │ grade │               │
 * │   ├────────────┼─────────┼───────────┼─────────┼───────┤               │
 * │   │ 2          │ Sneha   │ Delhi     │ 72      │ B     │               │
 * │   │ 3          │ Rohit   │ Bangalore │ 88      │ A     │               │
 * │   │ 4          │ Priya   │ Chennai   │ 65      │ C     │               │
 * │   └────────────┴─────────┴───────────┴─────────┴───────┘               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Reset students
TRUNCATE students RESTART IDENTITY;
INSERT INTO students (name, age, grade, city, marks, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 2022),
('Priya', 23, 'C', 'Chennai', 65, 2020),
('Neha', 24, 'B', 'Pune', 78, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 2022);

-- EXAMPLE 1: AND (both conditions must be true)
DELETE FROM students WHERE city = 'Mumbai' AND marks < 90;

SELECT student_id, name, city, marks FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┬───────┐
 * │ student_id │ name    │ city      │ marks │
 * ├────────────┼─────────┼───────────┼───────┤
 * │ 2          │ Sneha   │ Delhi     │ 72    │
 * │ 3          │ Rohit   │ Bangalore │ 88    │
 * │ 4          │ Priya   │ Chennai   │ 65    │
 * │ 5          │ Neha    │ Pune      │ 78    │
 * │ 6          │ Raj     │ Ahmedabad │ 58    │
 * │ 7          │ Amit    │ Mumbai    │ 91    │
 * │ 8          │ Kavya   │ Delhi     │ 75    │
 * └────────────┴─────────┴───────────┴───────┘
 * 
 * EXPLANATION: Ayaan (Mumbai, marks 85) was deleted. Amit (Mumbai, marks 91) remains.
 */

-- Reset
TRUNCATE students RESTART IDENTITY;
INSERT INTO students (name, age, grade, city, marks, enrollment_year) VALUES
('Ayaan', 20, 'A', 'Mumbai', 85, 2022),
('Sneha', 22, 'B', 'Delhi', 72, 2021),
('Rohit', 21, 'A', 'Bangalore', 88, 2022),
('Priya', 23, 'C', 'Chennai', 65, 2020),
('Neha', 24, 'B', 'Pune', 78, 2019),
('Raj', 20, 'C', 'Ahmedabad', 58, 2023),
('Amit', 22, 'A', 'Mumbai', 91, 2021),
('Kavya', 21, 'B', 'Delhi', 75, 2022);

-- EXAMPLE 2: OR (at least one condition must be true)
DELETE FROM students WHERE city = 'Mumbai' OR marks < 70;

SELECT student_id, name, city, marks FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬───────────┬───────┐
 * │ student_id │ name    │ city      │ marks │
 * ├────────────┼─────────┼───────────┼───────┤
 * │ 2          │ Sneha   │ Delhi     │ 72    │
 * │ 3          │ Rohit   │ Bangalore │ 88    │
 * │ 5          │ Neha    │ Pune      │ 78    │
 * │ 8          │ Kavya   │ Delhi     │ 75    │
 * └────────────┴─────────┴───────────┴───────┘
 * 
 * EXPLANATION: 
 * - Ayaan (Mumbai) deleted
 * - Amit (Mumbai) deleted
 * - Priya (marks 65 < 70) deleted
 * - Raj (marks 58 < 70) deleted
 * - Sneha, Rohit, Neha, Kavya remain
 */

-- ============================================================================
-- PART 5: DELETE with NULL Values (IS NULL, IS NOT NULL)
-- ============================================================================

-- Add some NULL values for demonstration
UPDATE products SET category = NULL WHERE product_id IN (9, 10);

-- EXAMPLE 1: Delete rows where column IS NULL
DELETE FROM products WHERE category IS NULL;

SELECT product_id, product_name, category FROM products;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬──────────────┐
 * │ product_id │ product_name │ category     │
 * ├────────────┼──────────────┼──────────────┤
 * │ 1          │ Laptop       │ Electronics  │
 * │ 2          │ Mouse        │ Electronics  │
 * │ 3          │ Keyboard     │ Electronics  │
 * │ 4          │ Monitor      │ Electronics  │
 * │ 5          │ Headphones   │ Accessories  │
 * │ 6          │ USB Cable    │ Accessories  │
 * │ 7          │ Laptop Stand │ Accessories  │
 * │ 8          │ Webcam       │ Electronics  │
 * └────────────┴──────────────┴──────────────┘
 * 
 * EXPLANATION: Products 9 and 10 (NULL category) were deleted
 */

-- EXAMPLE 2: Delete rows where column IS NOT NULL (opposite)
-- This would delete all products with categories (not shown)
-- DELETE FROM products WHERE category IS NOT NULL;

-- ============================================================================
-- PART 6: DELETE with IN and BETWEEN (Range and list deletion)
-- ============================================================================

-- Reset products
TRUNCATE products RESTART IDENTITY;
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 50000, 10),
('Mouse', 'Electronics', 500, 50),
('Keyboard', 'Electronics', 1500, 30),
('Monitor', 'Electronics', 10000, 5),
('Headphones', 'Accessories', 2000, 20),
('USB Cable', 'Accessories', 300, 100),
('Laptop Stand', 'Accessories', 2500, 15),
('Webcam', 'Electronics', 3500, 8);

-- EXAMPLE 1: Delete with IN (multiple values)
DELETE FROM products WHERE category IN ('Accessories', 'Discontinued');

SELECT product_name, category FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬──────────────┐
 * │ product_name │ category     │
 * ├──────────────┼──────────────┤
 * │ Laptop       │ Electronics  │
 * │ Mouse        │ Electronics  │
 * │ Keyboard     │ Electronics  │
 * │ Monitor      │ Electronics  │
 * │ Webcam       │ Electronics  │
 * └──────────────┴──────────────┘
 * 
 * EXPLANATION: All Accessories products were deleted
 */

-- Reset products
TRUNCATE products RESTART IDENTITY;
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Laptop', 'Electronics', 50000, 10),
('Mouse', 'Electronics', 500, 50),
('Keyboard', 'Electronics', 1500, 30),
('Monitor', 'Electronics', 10000, 5),
('Headphones', 'Accessories', 2000, 20),
('USB Cable', 'Accessories', 300, 100),
('Laptop Stand', 'Accessories', 2500, 15),
('Webcam', 'Electronics', 3500, 8);

-- EXAMPLE 2: Delete with BETWEEN (price range)
DELETE FROM products WHERE price BETWEEN 1000 AND 10000;

SELECT product_name, price FROM products;

/**
 * OUTPUT:
 * ┌──────────────┬─────────┐
 * │ product_name │ price   │
 * ├──────────────┼─────────┤
 * │ Mouse        │ 500.00  │
 * │ USB Cable    │ 300.00  │
 * └──────────────┴─────────┘
 * 
 * EXPLANATION: Products priced between 1000 and 10000 were deleted
 */

-- ============================================================================
-- PART 7: DELETE with LIKE (Pattern Matching)
-- ============================================================================

-- Add some test products
INSERT INTO products (product_name, category, price) VALUES
('Test Product 1', 'Test', 100),
('Test Product 2', 'Test', 200),
('Sample Product', 'Test', 150),
('Demo Item', 'Test', 300);

-- EXAMPLE 1: Delete products with names starting with 'Test'
DELETE FROM products WHERE product_name LIKE 'Test%';

SELECT product_name FROM products WHERE category = 'Test';

/**
 * OUTPUT:
 * ┌────────────────┐
 * │ product_name   │
 * ├────────────────┤
 * │ Sample Product │
 * │ Demo Item      │
 * └────────────────┘
 * 
 * EXPLANATION: Products starting with 'Test' were deleted
 */

-- EXAMPLE 2: Delete products with names containing 'Sample'
DELETE FROM products WHERE product_name LIKE '%Sample%';

SELECT product_name FROM products WHERE category = 'Test';

/**
 * OUTPUT:
 * ┌────────────┐
 * │ product_name│
 * ├────────────┤
 * │ Demo Item  │
 * └────────────┘
 */

-- ============================================================================
-- PART 8: DELETE with Subquery (Delete based on other table)
-- ============================================================================

-- EXAMPLE 1: Delete orders from customers who have no recent activity
DELETE FROM orders 
WHERE customer_name IN (
    SELECT name 
    FROM students 
    WHERE enrollment_year < 2020
);

SELECT order_id, customer_name, order_date FROM orders ORDER BY order_id;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┐
 * │ order_id │ customer_name │ order_date │
 * ├──────────┼───────────────┼────────────┤
 * │ 1        │ Ayaan         │ 2024-01-15 │
 * │ 2        │ Sneha         │ 2024-01-20 │
 * │ 3        │ Rohit         │ 2024-01-25 │
 * │ 4        │ Priya         │ 2024-02-01 │
 * │ 5        │ Neha          │ 2024-02-05 │
 * │ 6        │ Amit          │ 2024-02-10 │
 * │ 7        │ Kavya         │ 2024-02-15 │
 * │ 8        │ TestUser      │ 2024-03-01 │
 * └──────────┴───────────────┴────────────┘
 * 
 * EXPLANATION: OldOrder1 and OldOrder2 were deleted (students with enrollment_year < 2020)
 */

-- EXAMPLE 2: Delete products that have never been ordered
DELETE FROM products 
WHERE product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM order_items
);

SELECT product_id, product_name FROM products;

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
 * EXPLANATION: Webcam (not ordered) was deleted
 */

-- ============================================================================
-- PART 9: DELETE with JOIN (PostgreSQL USING syntax)
-- ============================================================================

/**
 * PostgreSQL allows DELETE with USING clause to join another table.
 */

-- EXAMPLE: Delete orders that are older than 30 days and copy to archive
-- First, copy old orders to archive table
INSERT INTO old_orders (order_id, customer_name, order_date, total_amount)
SELECT order_id, customer_name, order_date, total_amount
FROM orders
WHERE order_date < '2024-02-01';

-- Now delete using USING clause
DELETE FROM orders o
USING old_orders oo
WHERE o.order_id = oo.order_id;

SELECT order_id, customer_name, order_date FROM orders ORDER BY order_id;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┐
 * │ order_id │ customer_name │ order_date │
 * ├──────────┼───────────────┼────────────┤
 * │ 5        │ Neha          │ 2024-02-05 │
 * │ 6        │ Amit          │ 2024-02-10 │
 * │ 7        │ Kavya         │ 2024-02-15 │
 * │ 8        │ TestUser      │ 2024-03-01 │
 * └──────────┴───────────────┴────────────┘
 * 
 * EXPLANATION: Orders before 2024-02-01 were deleted (moved to archive)
 */

-- ============================================================================
-- PART 10: DELETE All Rows (Without WHERE) - BE CAREFUL!
-- ============================================================================

/**
 * ⚠️  WARNING: DELETE without WHERE removes EVERY row from the table!
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    DELETE All Rows - BE CAREFUL!                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE:                                                               │
 * │   ┌────────────┬─────────┬───────────┐                                 │
 * │   │ student_id │ name    │ city      │                                 │
 * │   ├────────────┼─────────┼───────────┤                                 │
 * │   │ 1          │ Ayaan   │ Mumbai    │                                 │
 * │   │ 2          │ Sneha   │ Delhi     │                                 │
 * │   │ 3          │ Rohit   │ Bangalore │                                 │
 * │   └────────────┴─────────┴───────────┘                                 │
 * │                                                                          │
 * │   DELETE COMMAND (NO WHERE!):                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ DELETE FROM students;        ← No WHERE clause!                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER: ALL rows are gone!                                            │
 * │   ┌────────────┬─────────┬───────────┐                                 │
 * │   │ student_id │ name    │ city      │                                 │
 * │   ├────────────┼─────────┼───────────┤                                 │
 * │   │ (no rows)  │         │           │                                 │
 * │   └────────────┴─────────┴───────────┘                                 │
 * │                                                                          │
 * │   ⚠️  This is often a disaster! Only use when you really want to      │
 * │       delete ALL data from a table.                                     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ DANGEROUS - This deletes EVERY row!
-- DELETE FROM students;  -- All 8 students would be gone!

-- ✅ To delete all rows safely, use TRUNCATE (faster, but still permanent)
-- TRUNCATE students;  -- Also deletes all rows

-- ============================================================================
-- PART 11: DELETE with RETURNING (See what was deleted)
-- ============================================================================

/**
 * RETURNING shows the rows that were deleted.
 * Very useful for logging or verification.
 */

-- EXAMPLE 1: Delete and see what was removed
DELETE FROM employees 
WHERE experience_years < 2
RETURNING emp_id, name, department, experience_years;

/**
 * OUTPUT:
 * ┌────────┬─────────┬────────────┬───────────────────┐
 * │ emp_id │ name    │ department │ experience_years  │
 * ├────────┼─────────┼────────────┼───────────────────┤
 * │ 8      │ Henry   │ IT         │ 1                 │
 * │ 9      │ Ivy     │ HR         │ 1                 │
 * │ 10     │ Jack    │ Finance    │ 2                 │
 * └────────┴─────────┴────────────┴───────────────────┘
 * 
 * EXPLANATION: The RETURNING clause shows which employees were deleted
 */

-- EXAMPLE 2: Delete with RETURNING * (all columns)
DELETE FROM employees 
WHERE department = 'Finance' AND salary < 65000
RETURNING *;

/**
 * OUTPUT:
 * ┌────────┬─────────┬────────────┬─────────┬───────────────────┬───────────┐
 * │ emp_id │ name    │ department │ salary  │ experience_years  │ is_active │
 * ├────────┼─────────┼────────────┼─────────┼───────────────────┼───────────┤
 * │ 10     │ Jack    │ Finance    │ 62000.00│ 2                 │ true      │
 * └────────┴─────────┴────────────┴─────────┴───────────────────┴───────────┘
 */

-- ============================================================================
-- PART 12: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Remove Inactive Students
 * 
 * Delete students who have been inactive (is_active = FALSE) for more than a year
 */

-- Add is_active and last_active_date to students
ALTER TABLE students ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE students ADD COLUMN last_active_date DATE DEFAULT CURRENT_DATE;

UPDATE students SET is_active = FALSE, last_active_date = '2022-01-01' 
WHERE student_id IN (4, 5, 6);

-- Delete inactive students
DELETE FROM students 
WHERE is_active = FALSE 
  AND last_active_date < CURRENT_DATE - INTERVAL '365 days'
RETURNING student_id, name, last_active_date;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────────────┐
 * │ student_id │ name    │ last_active_date│
 * ├────────────┼─────────┼─────────────────┤
 * │ 4          │ Priya   │ 2022-01-01      │
 * │ 5          │ Neha    │ 2022-01-01      │
 * │ 6          │ Raj     │ 2022-01-01      │
 * └────────────┴─────────┴─────────────────┘
 */

/**
 * SCENARIO 2: Remove Discontinued Products
 * 
 * Delete products that are marked as discontinued and have zero stock
 */

-- Add is_discontinued column
ALTER TABLE products ADD COLUMN is_discontinued BOOLEAN DEFAULT FALSE;
UPDATE products SET is_discontinued = TRUE, stock_quantity = 0 
WHERE product_id IN (9, 10);

-- Delete discontinued products with no stock
DELETE FROM products 
WHERE is_discontinued = TRUE AND stock_quantity = 0
RETURNING product_id, product_name;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┐
 * │ product_id │ product_name │
 * ├────────────┼──────────────┤
 * │ 9          │ Old Product 1│
 * │ 10         │ Old Product 2│
 * └────────────┴──────────────┘
 */

/**
 * SCENARIO 3: Clean Up Old Orders
 * 
 * Delete orders older than 6 months and archive them first
 */

-- Create archive table if not exists
CREATE TABLE IF NOT EXISTS order_archive (
    order_id INT,
    customer_name VARCHAR(50),
    order_date DATE,
    total_amount DECIMAL(10,2),
    archived_date DATE DEFAULT CURRENT_DATE
);

-- First, archive old orders
INSERT INTO order_archive (order_id, customer_name, order_date, total_amount)
SELECT order_id, customer_name, order_date, total_amount
FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL '30 days';

-- Then delete them
DELETE FROM orders 
WHERE order_date < CURRENT_DATE - INTERVAL '30 days'
RETURNING order_id, customer_name, order_date;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬────────────┐
 * │ order_id │ customer_name │ order_date │
 * ├──────────┼───────────────┼────────────┤
 * │ 1        │ Ayaan         │ 2024-01-15 │
 * │ 2        │ Sneha         │ 2024-01-20 │
 * │ 3        │ Rohit         │ 2024-01-25 │
 * │ 4        │ Priya         │ 2024-02-01 │
 * └──────────┴───────────────┴────────────┘
 */

/**
 * SCENARIO 4: Remove Duplicate Employees
 * 
 * Delete duplicate employee records (same name and department)
 */

-- Add duplicate for demonstration
INSERT INTO employees (name, department, salary, experience_years) VALUES
('Alice', 'IT', 75000, 5);

-- Delete duplicates (keep the one with highest emp_id)
DELETE FROM employees 
WHERE emp_id IN (
    SELECT e1.emp_id
    FROM employees e1
    JOIN employees e2 ON e1.name = e2.name AND e1.department = e2.department
    WHERE e1.emp_id < e2.emp_id
);

SELECT name, department, COUNT(*) FROM employees GROUP BY name, department;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬───────┐
 * │ name    │ department │ count │
 * ├─────────┼────────────┼───────┤
 * │ Alice   │ IT         │ 1     │
 * │ Bob     │ HR         │ 1     │
 * │ Carol   │ IT         │ 1     │
 * │ Dave    │ Finance    │ 1     │
 * │ Eve     │ IT         │ 1     │
 * │ Frank   │ HR         │ 1     │
 * │ Grace   │ Finance    │ 1     │
 * └─────────┴────────────┴───────┘
 */

/**
 * SCENARIO 5: Remove Orphaned Records
 * 
 * Delete orders that don't have matching customers
 */

-- Add a customer_id column to orders
ALTER TABLE orders ADD COLUMN customer_id INT;

-- Delete orders without matching customers
DELETE FROM orders 
WHERE customer_id IS NOT NULL 
  AND customer_id NOT IN (SELECT customer_id FROM customers);

-- Or using NOT EXISTS (more efficient for large tables)
DELETE FROM orders o
WHERE NOT EXISTS (
    SELECT 1 FROM customers c WHERE c.customer_id = o.customer_id
);

-- ============================================================================
-- PART 13: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting WHERE clause (deletes ALL rows)                 │
 * │                                                                          │
 * │   ❌ DELETE FROM students;        ← Deletes every student!              │
 * │                                                                          │
 * │   ✅ DELETE FROM students WHERE student_id = 1;                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ DANGEROUS - Never run without WHERE unless intentional
-- DELETE FROM students;  -- All students would be gone!

-- ✅ Always add WHERE
DELETE FROM students WHERE student_id = 1;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Using = NULL instead of IS NULL                            │
 * │                                                                          │
 * │   ❌ DELETE FROM products WHERE category = NULL;                        │
 * │      → Nothing deletes! NULL = NULL is FALSE in SQL                    │
 * │                                                                          │
 * │   ✅ DELETE FROM products WHERE category IS NULL;                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong
-- DELETE FROM products WHERE category = NULL;

-- ✅ Correct
DELETE FROM products WHERE category IS NULL;

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting string quotes                                   │
 * │                                                                          │
 * │   ❌ DELETE FROM students WHERE name = Ayaan;                           │
 * │      → Error! Text must be in quotes                                   │
 * │                                                                          │
 * │   ✅ DELETE FROM students WHERE name = 'Ayaan';                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Deleting from wrong table                                  │
 * │                                                                          │
 * │   ❌ DELETE FROM students WHERE city = 'Mumbai';                        │
 * │      → What if you meant to delete from employees?                     │
 * │                                                                          │
 * │   ✅ Always double-check table name before running DELETE               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5: Not using transactions for important deletes               │
 * │                                                                          │
 * │   ❌ DELETE FROM employees WHERE department = 'HR';                     │
 * │      → If this is wrong, data is gone forever!                         │
 * │                                                                          │
 * │   ✅ Use transaction to be safe:                                        │
 * │      BEGIN;                                                            │
 * │      DELETE FROM employees WHERE department = 'HR';                    │
 * │      -- Check results                                                  │
 * │      ROLLBACK;  -- or COMMIT if correct                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Safe way to delete with transaction
BEGIN;
DELETE FROM employees WHERE department = 'IT' AND salary < 60000;
-- Check how many rows were deleted
SELECT COUNT(*) FROM employees WHERE department = 'IT' AND salary < 60000;
-- If correct, COMMIT; if wrong, ROLLBACK;
ROLLBACK;  -- Undo the delete

-- ============================================================================
-- PART 14: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: ALWAYS use WHERE unless you want to delete EVERY row           │
 * │         → Test with SELECT first: SELECT * FROM table WHERE condition  │
 * │         → Then DELETE: DELETE FROM table WHERE same_condition          │
 * │                                                                          │
 * │ RULE 2: DELETE is PERMANENT!                                           │
 * │         → Cannot be undone (unless in transaction)                     │
 * │         → Always double-check conditions                               │
 * │                                                                          │
 * │ RULE 3: Use transactions for important deletes                         │
 * │         → BEGIN; DELETE...; ROLLBACK; or COMMIT;                       │
 * │         → Gives you a chance to undo mistakes                          │
 * │                                                                          │
 * │ RULE 4: Use RETURNING to see what was deleted                          │
 * │         → DELETE FROM table WHERE condition RETURNING *;               │
 * │         → Helpful for logging and verification                         │
 * │                                                                          │
 * │ RULE 5: Archive before deleting                                        │
 * │         → INSERT INTO archive_table SELECT * FROM main_table WHERE...  │
 * │         → DELETE FROM main_table WHERE...                              │
 * │                                                                          │
 * │ RULE 6: Use TRUNCATE for deleting all rows                             │
 * │         → TRUNCATE table; is faster than DELETE FROM table             │
 * │         → But cannot use WHERE with TRUNCATE                           │
 * │                                                                          │
 * │ RULE 7: Test with SELECT first                                         │
 * │         → Run SELECT to see which rows will be deleted                 │
 * │         → Then run DELETE with same WHERE                              │
 * │                                                                          │
 * │ RULE 8: Use NOT EXISTS for subquery deletes (more efficient)           │
 * │         → DELETE FROM table t WHERE NOT EXISTS (SELECT 1 FROM other)   │
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
 * │ -- Basic DELETE with WHERE                                             │
 * │ DELETE FROM table WHERE condition;                                      │
 * │                                                                          │
 * │ -- DELETE with comparison                                               │
 * │ DELETE FROM table WHERE age > 18;                                       │
 * │ DELETE FROM table WHERE status = 'INACTIVE';                            │
 * │                                                                          │
 * │ -- DELETE with multiple conditions                                      │
 * │ DELETE FROM table WHERE city = 'Mumbai' AND age < 21;                   │
 * │ DELETE FROM table WHERE status = 'PENDING' OR status = 'CANCELLED';     │
 * │                                                                          │
 * │ -- DELETE with NULL                                                     │
 * │ DELETE FROM table WHERE email IS NULL;                                  │
 * │                                                                          │
 * │ -- DELETE with IN                                                       │
 * │ DELETE FROM table WHERE city IN ('Mumbai', 'Delhi', 'Pune');            │
 * │                                                                          │
 * │ -- DELETE with BETWEEN                                                  │
 * │ DELETE FROM table WHERE price BETWEEN 100 AND 500;                      │
 * │                                                                          │
 * │ -- DELETE with LIKE                                                     │
 * │ DELETE FROM table WHERE name LIKE 'Test%';                              │
 * │                                                                          │
 * │ -- DELETE with subquery                                                 │
 * │ DELETE FROM table WHERE id IN (SELECT id FROM other_table WHERE cond);  │
 * │                                                                          │
 * │ -- DELETE with RETURNING (see deleted rows)                             │
 * │ DELETE FROM table WHERE condition RETURNING *;                          │
 * │                                                                          │
 * │ -- ⚠️  DANGEROUS - deletes ALL rows!                                    │
 * │ DELETE FROM table;   -- No WHERE clause!                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Delete student with student_id = 3
 * 
 * Answer:
 *   DELETE FROM students WHERE student_id = 3;
 */

/**
 * EXERCISE 2: Delete all students from Mumbai
 * 
 * Answer:
 *   DELETE FROM students WHERE city = 'Mumbai';
 */

/**
 * EXERCISE 3: Delete products with price less than 500
 * 
 * Answer:
 *   DELETE FROM products WHERE price < 500;
 */

/**
 * EXERCISE 4: Delete orders older than '2024-01-01'
 * 
 * Answer:
 *   DELETE FROM orders WHERE order_date < '2024-01-01';
 */

/**
 * EXERCISE 5: Delete employees with experience less than 2 years
 * 
 * Answer:
 *   DELETE FROM employees WHERE experience_years < 2;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS order_archive;
DROP TABLE IF EXISTS old_orders;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS students;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. DELETE removes rows PERMANENTLY from a table                        │
 * │                                                                          │
 * │ 2. Basic syntax: DELETE FROM table WHERE condition;                     │
 * │                                                                          │
 * │ 3. ⚠️  WITHOUT WHERE = ALL rows deleted (usually a disaster!)          │
 * │                                                                          │
 * │ 4. DELETE can use:                                                      │
 * │    → Comparison operators (=, >, <, >=, <=, <>)                         │
 * │    → Logical operators (AND, OR, NOT)                                   │
 * │    → NULL checks (IS NULL, IS NOT NULL)                                 │
 * │    → Range (BETWEEN) and list (IN)                                      │
 * │    → Pattern matching (LIKE)                                            │
 * │    → Subqueries and JOINs (USING)                                       │
 * │                                                                          │
 * │ 5. Use RETURNING to see what was deleted                               │
 * │                                                                          │
 * │ 6. Best practices:                                                      │
 * │    → ALWAYS test with SELECT first                                      │
 * │    → Use transactions for important deletes                             │
 * │    → Archive before deleting                                            │
 * │    → Use TRUNCATE for deleting all rows (faster)                        │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - DELETE is PERMANENT!                                                │
 * │   - WHERE is your safety net                                            │
 * │   - Test with SELECT first                                              │
 * │   - Use transactions for safety                                         │
 * │   - RETURNING helps verify                                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF DELETE WITH WHERE GUIDE
-- ============================================================================