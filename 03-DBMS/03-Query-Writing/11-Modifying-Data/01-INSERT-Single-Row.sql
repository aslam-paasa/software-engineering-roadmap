/**
 * ============================================================================
 * INSERT SINGLE ROW - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS INSERT? ------------------------- (Adding new data to tables)
 * 2. INSERT INTO TABLE (All Columns) --------- (Simple insert)
 * 3. INSERT INTO TABLE (Specific Columns) ---- (Insert only some columns)
 * 4. INSERT with DEFAULT Values -------------- (Using default column values)
 * 5. INSERT with RETURNING ------------------- (Get back inserted data)
 * 6. INSERT with NULL Values ----------------- (Inserting empty values)
 * 7. INSERT with Expressions ----------------- (Calculations in INSERT)
 * 8. INSERT with SUBQUERY -------------------- (Insert from another table)
 * 9. REAL-WORLD SCENARIOS -------------------- (Practical examples)
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
 * TABLE 4: CUSTOMERS_BACKUP - Backup table for examples
 */

CREATE TABLE customers_backup (
    customer_id INT,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

-- ============================================================================
-- PART 1: WHAT IS INSERT?
-- ============================================================================

/**
 * INSERT adds new rows (records) to a database table.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS INSERT?                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX (Basic):                                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO table_name (column1, column2, column3)              │   │
 * │   │ VALUES (value1, value2, value3);                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Specify which table to insert into                          │   │
 * │   │ 2. List the columns you want to fill                           │   │
 * │   │ 3. Provide values in the SAME ORDER as columns                 │   │
 * │   │ 4. Database creates a new row with your data                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ "Adding a new student to the school database"                   │   │
 * │   │                                                                  │   │
 *   │   │ Before INSERT: Students table has 0 rows                       │   │
 * │   │ After INSERT:  New row added with student details               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    INSERT - SIMPLE EXAMPLE                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE INSERT (Empty students table):                                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ student_id │ name │ age │ grade │ enrollment_date │ email       │   │
 * │   ├────────────┼──────┼─────┼───────┼─────────────────┼─────────────┤   │
 * │   │ (no rows)  │      │     │       │                 │             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   INSERT COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO students (name, age, grade, email)                 │   │
 * │   │ VALUES ('Ayaan', 20, 'A', 'ayaan@email.com');                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER INSERT (1 row added):                                           │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │   │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │   │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ ayaan@email.com     │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: INSERT INTO TABLE (All Columns - Simple Insert)
-- ============================================================================

/**
 * You can insert values for ALL columns in the table.
 * Column order must match the table definition.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    INSERT - All Columns                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO table_name VALUES (value1, value2, value3);        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BEFORE INSERT:                                                        │
 * │   ┌────────────┬──────────┬─────┬───────┬─────────────────┬─────────┐  │
 * │   │ student_id │ name     │ age │ grade │ enrollment_date │ email   │  │
 * │   ├────────────┼──────────┼─────┼───────┼─────────────────┼─────────┤  │
 * │   │ (empty)    │          │     │       │                 │         │  │
 * │   └────────────┴──────────┴─────┴───────┴─────────────────┴─────────┘  │
 * │                                                                          │
 * │   INSERT COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO students VALUES (1, 'Ayaan', 20, 'A', '2024-01-15',│   │
 * │   │                              'ayaan@email.com');               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER INSERT:                                                         │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │   │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │   │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ ayaan@email.com     │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Insert values for ALL columns (must match table structure exactly)
INSERT INTO students VALUES (1, 'Ayaan', 20, 'A', '2024-01-15', 'ayaan@email.com');

-- Insert another student
INSERT INTO students VALUES (2, 'Sneha', 22, 'B', '2024-01-16', 'sneha@email.com');

-- Insert third student
INSERT INTO students VALUES (3, 'Rohit', 21, 'A', '2024-01-17', 'rohit@email.com');

-- View all students
SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ ayaan@email.com     │
 * │ 2          │ Sneha   │ 22  │ B     │ 2024-01-16      │ sneha@email.com     │
 * │ 3          │ Rohit   │ 21  │ A     │ 2024-01-17      │ rohit@email.com     │
 * └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 * 
 * IMPORTANT NOTES:
 * - Values must be in the SAME ORDER as columns in the table
 * - SERIAL columns (like student_id) auto-increment, but we manually provided values
 * - For SERIAL columns, you can omit them (see next section)
 */

-- ============================================================================
-- PART 3: INSERT INTO TABLE (Specific Columns - Best Practice)
-- ============================================================================

/**
 * Best practice: Specify which columns you want to insert.
 * This is safer and more readable.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    INSERT - Specific Columns                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO table_name (col1, col2, col3)                       │   │
 * │   │ VALUES (val1, val2, val3);                                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   ADVANTAGES:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. No need to know exact column order                         │   │
 * │   │ 2. Can skip columns with DEFAULT values                        │   │
 * │   │ 3. More readable and maintainable                              │   │
 * │   │ 4. Won't break if table structure changes                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Clear existing data
TRUNCATE students RESTART IDENTITY;

-- Insert with specific columns (best practice)
INSERT INTO students (name, age, grade, email) 
VALUES ('Ayaan', 20, 'A', 'ayaan@email.com');

INSERT INTO students (name, age, grade, email) 
VALUES ('Sneha', 22, 'B', 'sneha@email.com');

INSERT INTO students (name, age, grade, email) 
VALUES ('Rohit', 21, 'A', 'rohit@email.com');

-- student_id auto-increments automatically
-- enrollment_date gets DEFAULT value (today's date)
SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ ayaan@email.com     │
 * │ 2          │ Sneha   │ 22  │ B     │ 2024-01-15      │ sneha@email.com     │
 * │ 3          │ Rohit   │ 21  │ A     │ 2024-01-15      │ rohit@email.com     │
 * └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 * 
 * EXPLANATION:
 * - student_id auto-incremented (1, 2, 3)
 * - enrollment_date got DEFAULT value (CURRENT_DATE)
 */

-- ============================================================================
-- PART 4: INSERT with DEFAULT Values
-- ============================================================================

/**
 * Use DEFAULT keyword to use the column's default value.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    INSERT with DEFAULT                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BEFORE INSERT:                                                        │
 * │   ┌────────────┬──────────┬─────┬───────┬─────────────────┬─────────┐  │
 * │   │ student_id │ name     │ age │ grade │ enrollment_date │ email   │  │
 * │   ├────────────┼──────────┼─────┼───────┼─────────────────┼─────────┤  │
 * │   │ 1          │ Ayaan    │ 20  │ A     │ 2024-01-15      │ ayaan@  │  │
 * │   │ 2          │ Sneha    │ 22  │ B     │ 2024-01-15      │ sneha@  │  │
 * │   │ 3          │ Rohit    │ 21  │ A     │ 2024-01-15      │ rohit@  │  │
 * │   └────────────┴──────────┴─────┴───────┴─────────────────┴─────────┘  │
 * │                                                                          │
 * │   INSERT COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO students (name, age, grade, enrollment_date, email)│   │
 * │   │ VALUES ('Priya', 23, 'B', DEFAULT, 'priya@email.com');         │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   AFTER INSERT:                                                         │
 * │   ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │   │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * │   ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │   │ 1          │ Ayaan   │ 20  │ A     │ 2024-01-15      │ ayaan@email.com     │
 * │   │ 2          │ Sneha   │ 22  │ B     │ 2024-01-15      │ sneha@email.com     │
 * │   │ 3          │ Rohit   │ 21  │ A     │ 2024-01-15      │ rohit@email.com     │
 * │   │ 4          │ Priya   │ 23  │ B     │ 2024-01-15      │ priya@email.com     │
 * │   └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Insert using DEFAULT keyword
INSERT INTO students (name, age, grade, enrollment_date, email) 
VALUES ('Priya', 23, 'B', DEFAULT, 'priya@email.com');

-- DEFAULT works for columns that have default values
INSERT INTO products (product_name, category, price) 
VALUES ('Laptop', 'Electronics', DEFAULT);  -- price will be 0.00

INSERT INTO products (product_name, category, stock_quantity) 
VALUES ('Mouse', 'Electronics', DEFAULT);  -- stock_quantity will be 0

SELECT * FROM products;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬──────────────┬─────────┬─────────────────┬──────────┐
 * │ product_id │ product_name │ category     │ price   │ stock_quantity  │ in_stock │
 * ├────────────┼──────────────┼──────────────┼─────────┼─────────────────┼──────────┤
 * │ 1          │ Laptop       │ Electronics  │ 0.00    │ 0               │ true     │
 * │ 2          │ Mouse        │ Electronics  │ 0.00    │ 0               │ true     │
 * └────────────┴──────────────┴──────────────┴─────────┴─────────────────┴──────────┘
 */

-- ============================================================================
-- PART 5: INSERT with RETURNING (Get back inserted data)
-- ============================================================================

/**
 * RETURNING clause returns the inserted values, especially useful for
 * auto-generated columns like SERIAL.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    INSERT with RETURNING                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO table_name (columns) VALUES (values)                │   │
 * │   │ RETURNING *;                           ← Returns all columns    │   │
 * │   │ -- OR --                                                         │   │
 * │   │ RETURNING column1, column2;            ← Returns specific columns│   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Insert and get back all inserted data
INSERT INTO students (name, age, grade, email) 
VALUES ('Neha', 24, 'A', 'neha@email.com')
RETURNING *;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name    │ age │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────┼─────┼───────┼─────────────────┼─────────────────────┤
 * │ 5          │ Neha    │ 24  │ A     │ 2024-01-15      │ neha@email.com      │
 * └────────────┴─────────┴─────┴───────┴─────────────────┴─────────────────────┘
 */

-- Insert and get back only specific columns
INSERT INTO students (name, age, grade, email) 
VALUES ('Raj', 25, 'B', 'raj@email.com')
RETURNING student_id, name, email;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬─────────────────┐
 * │ student_id │ name    │ email           │
 * ├────────────┼─────────┼─────────────────┤
 * │ 6          │ Raj     │ raj@email.com   │
 * └────────────┴─────────┴─────────────────┘
 */

-- Practical use: Get auto-generated ID for further operations
INSERT INTO orders (customer_name, product_name, quantity) 
VALUES ('Ayaan', 'Laptop', 1)
RETURNING order_id;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ order_id │
 * ├──────────┤
 * │ 1        │
 * └──────────┘
 * 
 * Now you can use this order_id to add order items in another table
 */

-- ============================================================================
-- PART 6: INSERT with NULL Values
-- ============================================================================

/**
 * Insert NULL for optional columns (columns that allow NULL).
 */

-- Clear existing data
TRUNCATE students RESTART IDENTITY;

-- Insert with NULL values for optional columns
INSERT INTO students (name, age, email) 
VALUES ('Ayaan', 20, 'ayaan@email.com');
-- grade is NULL because not provided

INSERT INTO students (name, email) 
VALUES ('Sneha', 'sneha@email.com');
-- age and grade are NULL

INSERT INTO students (name, age, grade, email) 
VALUES ('Rohit', NULL, NULL, 'rohit@email.com');
-- Explicitly setting NULL

SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬─────────┬──────┬───────┬─────────────────┬─────────────────────┐
 * │ student_id │ name    │ age  │ grade │ enrollment_date │ email               │
 * ├────────────┼─────────┼──────┼───────┼─────────────────┼─────────────────────┤
 * │ 1          │ Ayaan   │ 20   │ NULL  │ 2024-01-15      │ ayaan@email.com     │
 * │ 2          │ Sneha   │ NULL │ NULL  │ 2024-01-15      │ sneha@email.com     │
 * │ 3          │ Rohit   │ NULL │ NULL  │ 2024-01-15      │ rohit@email.com     │
 * └────────────┴─────────┴──────┴───────┴─────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 7: INSERT with Expressions (Calculations in INSERT)
-- ============================================================================

/**
 * You can use expressions and calculations in INSERT statements.
 */

-- Clear existing data
TRUNCATE products RESTART IDENTITY;

-- Insert with calculated values
INSERT INTO products (product_name, category, price, stock_quantity) 
VALUES ('Laptop', 'Electronics', 50000 * 1.18, 10 + 5);

-- Insert with functions
INSERT INTO products (product_name, category, price, stock_quantity, in_stock) 
VALUES ('Mouse', 'Electronics', 500, 50, 10 > 0);

-- Insert with string concatenation
INSERT INTO products (product_name, category, price) 
VALUES (UPPER('keyboard'), 'Electronics', 1500);

SELECT * FROM products;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬──────────────┬─────────┬─────────────────┬──────────┐
 * │ product_id │ product_name │ category     │ price   │ stock_quantity  │ in_stock │
 * ├────────────┼──────────────┼──────────────┼─────────┼─────────────────┼──────────┤
 * │ 1          │ Laptop       │ Electronics  │ 59000.00│ 15              │ true     │
 * │ 2          │ Mouse        │ Electronics  │ 500.00  │ 50              │ true     │
 * │ 3          │ KEYBOARD     │ Electronics  │ 1500.00 │ 0               │ true     │
 * └────────────┴──────────────┴──────────────┴─────────┴─────────────────┴──────────┘
 */

-- ============================================================================
-- PART 8: INSERT with SUBQUERY (Insert from another table)
-- ============================================================================

/**
 * You can insert data from another table using a subquery.
 */

-- First, insert some data into customers_backup table
INSERT INTO customers_backup (customer_id, customer_name, city) VALUES
(1, 'Ayaan', 'Mumbai'),
(2, 'Sneha', 'Delhi'),
(3, 'Rohit', 'Bangalore');

-- Now create a new table for premium customers
CREATE TABLE premium_customers (
    premium_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    added_date DATE DEFAULT CURRENT_DATE
);

-- Insert from another table using subquery
INSERT INTO premium_customers (customer_name, city)
SELECT customer_name, city
FROM customers_backup
WHERE city IN ('Mumbai', 'Delhi');

SELECT * FROM premium_customers;

/**
 * OUTPUT:
 * ┌────────────┬───────────────┬─────────┬────────────┐
 * │ premium_id │ customer_name │ city    │ added_date │
 * ├────────────┼───────────────┼─────────┼────────────┤
 * │ 1          │ Ayaan         │ Mumbai  │ 2024-01-15 │
 * │ 2          │ Sneha         │ Delhi   │ 2024-01-15 │
 * └────────────┴───────────────┴─────────┴────────────┘
 * 
 * EXPLANATION:
 * - Only customers from Mumbai and Delhi were inserted
 * - Bangalore customer (Rohit) was NOT inserted
 */

-- Insert with more complex subquery
INSERT INTO orders (customer_name, product_name, quantity)
SELECT 
    c.customer_name,
    'Special Product',
    FLOOR(RANDOM() * 10 + 1)::INT
FROM customers_backup c
WHERE c.city = 'Mumbai';

SELECT * FROM orders;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬─────────────────┬──────────┬────────────┬─────────┐
 * │ order_id │ customer_name │ product_name    │ quantity │ order_date │ status  │
 * ├──────────┼───────────────┼─────────────────┼──────────┼────────────┼─────────┤
 * │ 1        │ Ayaan         │ Special Product │ 7        │ 2024-01-15 │ PENDING │
 * └──────────┴───────────────┴─────────────────┴──────────┴────────────┴─────────┘
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: New Student Registration
 * 
 * School registration system - add a new student
 */

-- Clear existing data
TRUNCATE students RESTART IDENTITY;

-- Add a new student with all information
INSERT INTO students (name, age, grade, email) 
VALUES ('Ayaan Khan', 20, 'A', 'ayaan.khan@school.edu')
RETURNING student_id, name, enrollment_date;

/**
 * OUTPUT:
 * ┌────────────┬─────────────┬─────────────────┐
 * │ student_id │ name        │ enrollment_date │
 * ├────────────┼─────────────┼─────────────────┤
 * │ 1          │ Ayaan Khan  │ 2024-01-15      │
 * └────────────┴─────────────┴─────────────────┘
 */

-- Add multiple students at once (covered in next lesson)
INSERT INTO students (name, age, grade, email) VALUES 
('Sneha Patel', 22, 'B', 'sneha.patel@school.edu'),
('Rohit Sharma', 21, 'A', 'rohit.sharma@school.edu'),
('Priya Singh', 23, 'B', 'priya.singh@school.edu');

SELECT * FROM students;

/**
 * OUTPUT:
 * ┌────────────┬───────────────┬─────┬───────┬─────────────────┬─────────────────────────────┐
 * │ student_id │ name          │ age │ grade │ enrollment_date │ email                       │
 * ├────────────┼───────────────┼─────┼───────┼─────────────────┼─────────────────────────────┤
 * │ 1          │ Ayaan Khan    │ 20  │ A     │ 2024-01-15      │ ayaan.khan@school.edu       │
 * │ 2          │ Sneha Patel   │ 22  │ B     │ 2024-01-15      │ sneha.patel@school.edu      │
 * │ 3          │ Rohit Sharma  │ 21  │ A     │ 2024-01-15      │ rohit.sharma@school.edu     │
 * │ 4          │ Priya Singh   │ 23  │ B     │ 2024-01-15      │ priya.singh@school.edu      │
 * └────────────┴───────────────┴─────┴───────┴─────────────────┴─────────────────────────────┘
 */

/**
 * SCENARIO 2: Add New Product to Inventory
 * 
 * E-commerce inventory management
 */

TRUNCATE products RESTART IDENTITY;

-- Add a new product with all details
INSERT INTO products (product_name, category, price, stock_quantity, in_stock)
VALUES ('Wireless Headphones', 'Electronics', 2999.99, 100, TRUE)
RETURNING product_id, product_name, price;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬─────────┐
 * │ product_id │ product_name        │ price   │
 * ├────────────┼─────────────────────┼─────────┤
 * │ 1          │ Wireless Headphones │ 2999.99 │
 * └────────────┴─────────────────────┴─────────┘
 */

-- Add product with default stock (0)
INSERT INTO products (product_name, category, price)
VALUES ('USB Cable', 'Accessories', 299.99);

-- Add product out of stock
INSERT INTO products (product_name, category, price, stock_quantity, in_stock)
VALUES ('Gaming Mouse', 'Electronics', 1499.99, 0, FALSE);

SELECT * FROM products;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬──────────────┬─────────┬─────────────────┬──────────┐
 * │ product_id │ product_name        │ category     │ price   │ stock_quantity  │ in_stock │
 * ├────────────┼─────────────────────┼──────────────┼─────────┼─────────────────┼──────────┤
 * │ 1          │ Wireless Headphones │ Electronics  │ 2999.99 │ 100             │ true     │
 * │ 2          │ USB Cable           │ Accessories  │ 299.99  │ 0               │ true     │
 * │ 3          │ Gaming Mouse        │ Electronics  │ 1499.99 │ 0               │ false    │
 * └────────────┴─────────────────────┴──────────────┴─────────┴─────────────────┴──────────┘
 */

/**
 * SCENARIO 3: Place New Order
 * 
 * Online shopping - customer places an order
 */

TRUNCATE orders RESTART IDENTITY;

-- Customer places an order
INSERT INTO orders (customer_name, product_name, quantity, status)
VALUES ('Ayaan', 'Laptop', 1, 'CONFIRMED')
RETURNING order_id, customer_name, product_name, order_date;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬────────────┐
 * │ order_id │ customer_name │ product_name │ order_date │
 * ├──────────┼───────────────┼──────────────┼────────────┤
 * │ 1        │ Ayaan         │ Laptop       │ 2024-01-15 │
 * └──────────┴───────────────┴──────────────┴────────────┘
 */

-- Another customer places order
INSERT INTO orders (customer_name, product_name, quantity)
VALUES ('Sneha', 'Mouse', 2);

-- Order with specific date
INSERT INTO orders (customer_name, product_name, quantity, order_date)
VALUES ('Rohit', 'Keyboard', 1, '2024-01-20');

SELECT * FROM orders ORDER BY order_id;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬──────────┬────────────┬───────────┐
 * │ order_id │ customer_name │ product_name │ quantity │ order_date │ status    │
 * ├──────────┼───────────────┼──────────────┼──────────┼────────────┼───────────┤
 * │ 1        │ Ayaan         │ Laptop       │ 1        │ 2024-01-15 │ CONFIRMED │
 * │ 2        │ Sneha         │ Mouse        │ 2        │ 2024-01-15 │ PENDING   │
 * │ 3        │ Rohit         │ Keyboard     │ 1        │ 2024-01-20 │ PENDING   │
 * └──────────┴───────────────┴──────────────┴──────────┴────────────┴───────────┘
 */

/**
 * SCENARIO 4: Create Customer Account
 * 
 * New user registration on website
 */

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- New user registration
INSERT INTO users (username, email, full_name)
VALUES ('ayaan_khan', 'ayaan@example.com', 'Ayaan Khan')
RETURNING user_id, username, created_at;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬─────────────────────────┐
 * │ user_id │ username   │ created_at              │
 * ├─────────┼────────────┼─────────────────────────┤
 * │ 1       │ ayaan_khan │ 2024-01-15 10:30:00     │
 * └─────────┴────────────┴─────────────────────────┘
 */

-- Register multiple users
INSERT INTO users (username, email, full_name) VALUES
('sneha_p', 'sneha@example.com', 'Sneha Patel'),
('rohit_s', 'rohit@example.com', 'Rohit Sharma');

SELECT user_id, username, full_name, is_active FROM users;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬───────────────┬───────────┐
 * │ user_id │ username   │ full_name     │ is_active │
 * ├─────────┼────────────┼───────────────┼───────────┤
 * │ 1       │ ayaan_khan │ Ayaan Khan    │ true      │
 * │ 2       │ sneha_p    │ Sneha Patel   │ true      │
 * │ 3       │ rohit_s    │ Rohit Sharma  │ true      │
 * └─────────┴────────────┴───────────────┴───────────┘
 */

/**
 * SCENARIO 5: Add Product Review
 * 
 * Customer submits a product review
 */

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT,
    customer_name VARCHAR(50),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);

-- Customer submits a 5-star review
INSERT INTO reviews (product_id, customer_name, rating, review_text)
VALUES (1, 'Ayaan', 5, 'Excellent product! Highly recommended.')
RETURNING review_id, customer_name, rating, review_date;

/**
 * OUTPUT:
 * ┌───────────┬───────────────┬────────┬─────────────────────────┐
 * │ review_id │ customer_name │ rating │ review_date             │
 * ├───────────┼───────────────┼────────┼─────────────────────────┤
 * │ 1         │ Ayaan         │ 5      │ 2024-01-15              │
 * └───────────┴───────────────┴────────┴─────────────────────────┘
 */

-- Another review with lower rating
INSERT INTO reviews (product_id, customer_name, rating, review_text)
VALUES (2, 'Sneha', 3, 'Average product, works as expected.');

SELECT * FROM reviews;

/**
 * OUTPUT:
 * ┌───────────┬────────────┬───────────────┬────────┬─────────────────────────────────┬────────────┐
 * │ review_id │ product_id │ customer_name │ rating │ review_text                     │ review_date│
 * ├───────────┼────────────┼───────────────┼────────┼─────────────────────────────────┼────────────┤
 * │ 1         │ 1          │ Ayaan         │ 5      │ Excellent product! Highly...    │ 2024-01-15 │
 * │ 2         │ 2          │ Sneha         │ 3      │ Average product, works as...    │ 2024-01-15 │
 * └───────────┴────────────┴───────────────┴────────┴─────────────────────────────────┴────────────┘
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Wrong number of values                                     │
 * │                                                                          │
 * │   ❌ INSERT INTO students (name, age) VALUES ('Ayaan');                 │
 * │      → Error! 2 columns specified but only 1 value provided            │
 * │                                                                          │
 * │   ✅ INSERT INTO students (name, age) VALUES ('Ayaan', 20);             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong
-- INSERT INTO students (name, age) VALUES ('Ayaan');  -- ERROR!

-- ✅ Correct
INSERT INTO students (name, age) VALUES ('Ayaan', 20);

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Data type mismatch                                         │
 * │                                                                          │
 * │   ❌ INSERT INTO students (name, age) VALUES ('Ayaan', 'twenty');       │
 * │      → age expects INTEGER, but got TEXT                               │
 * │                                                                          │
 * │   ✅ INSERT INTO students (name, age) VALUES ('Ayaan', 20);             │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting single quotes for text                           │
 * │                                                                          │
 * │   ❌ INSERT INTO students (name) VALUES (Ayaan);                        │
 * │      → Error! Text must be in quotes                                   │
 * │                                                                          │
 * │   ✅ INSERT INTO students (name) VALUES ('Ayaan');                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Inserting duplicate values in UNIQUE column                │
 * │                                                                          │
 * │   ❌ INSERT INTO students (email) VALUES ('ayaan@email.com');           │
 * │      INSERT INTO students (email) VALUES ('ayaan@email.com');           │
 * │      → Second insert fails (email must be unique)                      │
 * │                                                                          │
 * │   ✅ Use different email for each record                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5: Forgetting column list when skipping columns               │
 * │                                                                          │
 * │   ❌ INSERT INTO students VALUES ('Ayaan', 20);  -- Missing columns!    │
 * │                                                                          │
 * │   ✅ INSERT INTO students (name, age) VALUES ('Ayaan', 20);             │
 * │      → Always specify column names for clarity and safety              │
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
 * │ RULE 1: Always specify column names                                     │
 * │         → INSERT INTO table (col1, col2) VALUES (val1, val2)           │
 * │         → Safer, more readable, won't break if table changes           │
 * │                                                                          │
 * │ RULE 2: Values must match column order                                 │
 * │         → First value goes to first column listed                      │
 * │         → Second value goes to second column listed, etc.              │
 * │                                                                          │
 * │ RULE 3: Use DEFAULT keyword for default values                         │
 * │         → INSERT INTO table (col1, col2) VALUES ('text', DEFAULT)      │
 * │                                                                          │
 * │ RULE 4: Use RETURNING to get auto-generated values                     │
 * │         → INSERT INTO table (col1) VALUES (val1) RETURNING *           │
 * │         → Gets SERIAL/auto-increment IDs back                          │
 * │                                                                          │
 * │ RULE 5: Text and date values need quotes (' ')                         │
 * │         → Numbers don't need quotes                                    │
 * │                                                                          │
 * │ RULE 6: Check constraints before inserting                             │
 * │         → NOT NULL, UNIQUE, CHECK constraints can cause failures       │
 * │                                                                          │
 * │ RULE 7: Test INSERT with SELECT first                                  │
 * │         → Run SELECT with same WHERE conditions to see what will insert│
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
 * │ -- Insert with all columns (NOT recommended)                           │
 * │ INSERT INTO table_name VALUES (val1, val2, val3);                      │
 * │                                                                          │
 * │ -- Insert with specific columns (RECOMMENDED)                          │
 * │ INSERT INTO table_name (col1, col2, col3) VALUES (val1, val2, val3);   │
 * │                                                                          │
 * │ -- Insert with DEFAULT                                                 │
 * │ INSERT INTO table_name (col1, col2) VALUES ('text', DEFAULT);          │
 * │                                                                          │
 * │ -- Insert with RETURNING                                               │
 * │ INSERT INTO table_name (col1, col2) VALUES (val1, val2)                │
 * │ RETURNING *;                                                           │
 * │                                                                          │
 * │ -- Insert with RETURNING specific columns                              │
 * │ INSERT INTO table_name (col1, col2) VALUES (val1, val2)                │
 * │ RETURNING id, col1;                                                    │
 * │                                                                          │
 * │ -- Insert from another table                                           │
 * │ INSERT INTO table1 (col1, col2)                                        │
 * │ SELECT col1, col2 FROM table2 WHERE condition;                         │
 * │                                                                          │
 * │ -- Insert with expressions                                             │
 * │ INSERT INTO table_name (col1, col2) VALUES (100 * 1.18, UPPER('text'));│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Insert a new student with name 'John', age 19, grade 'A'
 * 
 * Answer:
 *   INSERT INTO students (name, age, grade) VALUES ('John', 19, 'A');
 */

/**
 * EXERCISE 2: Insert a new product with name 'Tablet', category 'Electronics', price 15000
 * 
 * Answer:
 *   INSERT INTO products (product_name, category, price) VALUES ('Tablet', 'Electronics', 15000);
 */

/**
 * EXERCISE 3: Insert a new order for customer 'Ayaan', product 'Laptop', quantity 1
 *            and return the order_id
 * 
 * Answer:
 *   INSERT INTO orders (customer_name, product_name, quantity) 
 *   VALUES ('Ayaan', 'Laptop', 1) 
 *   RETURNING order_id;
 */

/**
 * EXERCISE 4: Insert a new user with username 'john_doe', email 'john@example.com'
 * 
 * Answer:
 *   INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com');
 */

/**
 * EXERCISE 5: Insert a product review for product_id 1, customer 'Ayaan', rating 4
 * 
 * Answer:
 *   INSERT INTO reviews (product_id, customer_name, rating) VALUES (1, 'Ayaan', 4);
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers_backup;
DROP TABLE IF EXISTS premium_customers;
DROP TABLE IF EXISTS students;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. INSERT adds new rows to a table                                     │
 * │                                                                          │
 * │ 2. Basic syntax:                                                        │
 * │    INSERT INTO table (col1, col2) VALUES (val1, val2);                 │
 * │                                                                          │
 * │ 3. Always specify column names (safer and more readable)               │
 * │                                                                          │
 * │ 4. Use DEFAULT keyword for default values                              │
 * │                                                                          │
 * │ 5. Use RETURNING to get back inserted data (especially IDs)            │
 * │                                                                          │
 * │ 6. You can insert data from another table using SELECT                 │
 * │                                                                          │
 * │ 7. Text and dates need quotes (' '), numbers don't                     │
 * │                                                                          │
 * │ 8. Column order in VALUES must match column list order                 │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always specify column names                                        │
 * │   - Check data types match                                             │
 * │   - Use RETURNING to get generated IDs                                 │
 * │   - Test with SELECT first when inserting from other tables            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF INSERT SINGLE ROW GUIDE
-- ============================================================================