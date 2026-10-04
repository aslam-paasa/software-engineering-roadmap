/**
 * ============================================================================
 * INSERT WITH SPECIFIC COLUMNS - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS INSERT WITH SPECIFIC COLUMNS? --- (Insert only needed columns)
 * 2. WHY USE SPECIFIC COLUMNS? -------------- (Benefits and advantages)
 * 3. INSERT WITH SPECIFIC COLUMNS - BASIC ---- (Simple examples)
 * 4. OMITTING COLUMNS with DEFAULT ----------- (Using default values)
 * 5. OMITTING COLUMNS with NULL -------------- (Columns that allow NULL)
 * 6. INSERT with MIX of Values --------------- (Some values, some DEFAULT)
 * 7. INSERT with SPECIFIC COLUMNS & RETURNING - (Get back inserted data)
 * 8. INSERT with SPECIFIC COLUMNS & CONFLICT -- (Handle duplicates)
 * 9. REAL-WORLD SCENARIOS -------------------- (Practical examples)
 * 10. COLUMN TYPES REFERENCE ----------------- (Which columns can be omitted)
 * 11. COMMON MISTAKES ------------------------ (What to avoid)
 * 12. GOLDEN RULES --------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: CUSTOMERS - Customer information with optional fields
 */

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,           -- Required (cannot be omitted)
    email VARCHAR(100) NOT NULL UNIQUE,  -- Required (cannot be omitted)
    phone VARCHAR(20),                   -- Optional (can be NULL)
    age INT,                             -- Optional (can be NULL)
    city VARCHAR(50) DEFAULT 'Unknown',  -- Has default value
    country VARCHAR(50) DEFAULT 'India', -- Has default value
    signup_date DATE DEFAULT CURRENT_DATE -- Has default value
);

/**
 * TABLE 2: PRODUCTS - Product catalog with optional fields
 */

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,   -- Required
    category VARCHAR(50) DEFAULT 'General', -- Has default
    price DECIMAL(10,2) NOT NULL,         -- Required
    discount DECIMAL(5,2) DEFAULT 0.00,   -- Has default
    stock_quantity INT DEFAULT 0,         -- Has default
    description TEXT,                     -- Optional (can be NULL)
    is_active BOOLEAN DEFAULT TRUE        -- Has default
);

/**
 * TABLE 3: ORDERS - Order information with optional fields
 */

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,   -- Required
    product_name VARCHAR(50) NOT NULL,    -- Required
    quantity INT NOT NULL,                -- Required
    order_date DATE DEFAULT CURRENT_DATE, -- Has default
    status VARCHAR(20) DEFAULT 'PENDING', -- Has default
    notes TEXT,                           -- Optional (can be NULL)
    priority INT DEFAULT 1                -- Has default
);

/**
 * TABLE 4: EMPLOYEES - Employee information
 */

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,            -- Required
    department VARCHAR(50),               -- Optional (can be NULL)
    salary DECIMAL(10,2),                 -- Optional (can be NULL)
    hire_date DATE DEFAULT CURRENT_DATE,  -- Has default
    manager_id INT,                       -- Optional (can be NULL)
    is_permanent BOOLEAN DEFAULT TRUE     -- Has default
);

-- ============================================================================
-- PART 1: WHAT IS INSERT WITH SPECIFIC COLUMNS?
-- ============================================================================

/**
 * INSERT with specific columns means you only provide values for columns you want.
 * Other columns get NULL or DEFAULT values automatically.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              INSERT WITH SPECIFIC COLUMNS - EXPLANATION                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 *   │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO table_name (column1, column2)                       │   │
 * │   │ VALUES (value1, value2);                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   COMPLETE INSERT (All columns):                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO customers (customer_id, name, email, phone, age,   │   │
 * │   │                       city, country, signup_date)              │   │
 * │   │ VALUES (1, 'Ayaan', 'ayaan@email.com', '1234567890', 25,       │   │
 * │   │         'Mumbai', 'India', '2024-01-15');                      │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   SPECIFIC COLUMNS INSERT (Only required columns):                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO customers (name, email)                             │   │
 * │   │ VALUES ('Ayaan', 'ayaan@email.com');                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   WHAT HAPPENS TO OMITTED COLUMNS:                                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Column Type        │ What happens when omitted                 │   │
 *   │   ├─────────────────────┼───────────────────────────────────────────┤   │
 * │   │ NOT NULL (no default)│ ERROR! Cannot omit                        │   │
 * │   │ Has DEFAULT value    │ Gets the DEFAULT value                    │   │
 * │   │ Allows NULL          │ Gets NULL                                 │   │
 * │   │ SERIAL/AUTO_INCREMENT│ Auto-increments automatically             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │           INSERT WITH SPECIFIC COLUMNS - EXAMPLE                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   INSERT COMMAND:                                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ INSERT INTO customers (name, email)                             │   │
 * │   │ VALUES ('Ayaan', 'ayaan@email.com');                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   RESULT (What actually gets inserted):                                 │
 * │   ┌─────────────┬─────────┬─────────────────┬───────┬─────┬──────────┬─────────┬────────────┐
 * │   │ customer_id │ name    │ email           │ phone │ age │ city     │ country │ signup_date│
 *   │   ├─────────────┼─────────┼─────────────────┼───────┼─────┼──────────┼─────────┼────────────┤
 * │   │ 1           │ Ayaan   │ ayaan@email.com │ NULL  │ NULL│ Unknown  │ India   │ 2024-01-15 │
 * │   └─────────────┴─────────┴─────────────────┴───────┴─────┴──────────┴─────────┴────────────┘
 * │                                                                          │
 * │   EXPLANATION:                                                          │
 * │   - customer_id: Auto-generated (SERIAL)                               │
 * │   - phone: NULL (column allows NULL)                                   │
 * │   - age: NULL (column allows NULL)                                     │
 * │   - city: 'Unknown' (DEFAULT value)                                    │
 * │   - country: 'India' (DEFAULT value)                                   │
 * │   - signup_date: Today's date (DEFAULT CURRENT_DATE)                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 2: WHY USE SPECIFIC COLUMNS?
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHY USE SPECIFIC COLUMNS? - BENEFITS                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   BENEFIT 1: Only provide data you HAVE                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ You don't need to know or provide values for all columns       │   │
 * │   │ Example: New customer signs up - you only have name and email  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BENEFIT 2: Let database handle defaults                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ Columns with DEFAULT values automatically get their defaults    │   │
 * │   │ Example: signup_date gets today's date automatically            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BENEFIT 3: More readable and maintainable                            │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ You can see exactly which columns you're inserting              │   │
 * │   │ INSERT INTO customers (name, email) VALUES ('Ayaan', ...)       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BENEFIT 4: Safe against table changes                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ If someone adds a new column, your INSERT still works           │   │
 * │   │ (as long as new column has DEFAULT or allows NULL)              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   BENEFIT 5: Avoid errors with NOT NULL columns                        │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ You must include all NOT NULL columns without DEFAULT           │   │
 * │   │ Specifying columns makes this clear                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 3: INSERT WITH SPECIFIC COLUMNS - BASIC
-- ============================================================================

-- Clear existing data
TRUNCATE customers RESTART IDENTITY;

-- Insert only name and email (minimum required data)
INSERT INTO customers (name, email) 
VALUES ('Ayaan', 'ayaan@email.com');

INSERT INTO customers (name, email) 
VALUES ('Sneha', 'sneha@email.com');

INSERT INTO customers (name, email) 
VALUES ('Rohit', 'rohit@email.com');

SELECT customer_id, name, email, city, country, signup_date FROM customers;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┬─────────┬─────────┬────────────┐
 * │ customer_id │ name    │ email           │ city    │ country │ signup_date│
 * ├─────────────┼─────────┼─────────────────┼─────────┼─────────┼────────────┤
 * │ 1           │ Ayaan   │ ayaan@email.com │ Unknown │ India   │ 2024-01-15 │
 * │ 2           │ Sneha   │ sneha@email.com │ Unknown │ India   │ 2024-01-15 │
 * │ 3           │ Rohit   │ rohit@email.com │ Unknown │ India   │ 2024-01-15 │
 * └─────────────┴─────────┴─────────────────┴─────────┴─────────┴────────────┘
 * 
 * EXPLANATION:
 * - customer_id auto-generated (1,2,3)
 * - phone and age are NULL (allow NULL)
 * - city got DEFAULT 'Unknown'
 * - country got DEFAULT 'India'
 * - signup_date got DEFAULT CURRENT_DATE
 */

-- Insert with additional columns
INSERT INTO customers (name, email, phone, age) 
VALUES ('Priya', 'priya@email.com', '9876543210', 25);

SELECT customer_id, name, email, phone, age, city FROM customers 
WHERE name = 'Priya';

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┬────────────┬─────┬─────────┐
 * │ customer_id │ name    │ email           │ phone      │ age │ city    │
 * ├─────────────┼─────────┼─────────────────┼────────────┼─────┼─────────┤
 * │ 4           │ Priya   │ priya@email.com │ 9876543210 │ 25  │ Unknown │
 * └─────────────┴─────────┴─────────────────┴────────────┴─────┴─────────┘
 * 
 * EXPLANATION:
 * - Provided phone and age values
 * - city still got DEFAULT 'Unknown'
 */

-- ============================================================================
-- PART 4: OMITTING COLUMNS with DEFAULT
-- ============================================================================

/**
 * Columns with DEFAULT values automatically get their default when omitted.
 */

-- Clear existing data
TRUNCATE products RESTART IDENTITY;

-- Insert only product_name and price (others get defaults)
INSERT INTO products (product_name, price) VALUES
    ('Laptop', 50000),
    ('Mouse', 500),
    ('Keyboard', 1500);

SELECT product_id, product_name, category, price, discount, stock_quantity, is_active 
FROM products;

/**
 * OUTPUT:
 * ┌────────────┬──────────────┬───────────┬─────────┬──────────┬─────────────────┬───────────┐
 * │ product_id │ product_name │ category  │ price   │ discount │ stock_quantity  │ is_active │
 * ├────────────┼──────────────┼───────────┼─────────┼──────────┼─────────────────┼───────────┤
 * │ 1          │ Laptop       │ General   │ 50000.00│ 0.00     │ 0               │ true      │
 * │ 2          │ Mouse        │ General   │ 500.00  │ 0.00     │ 0               │ true      │
 * │ 3          │ Keyboard     │ General   │ 1500.00 │ 0.00     │ 0               │ true      │
 * └────────────┴──────────────┴───────────┴─────────┴──────────┴─────────────────┴───────────┘
 * 
 * EXPLANATION:
 * - category got DEFAULT 'General'
 * - discount got DEFAULT 0.00
 * - stock_quantity got DEFAULT 0
 * - is_active got DEFAULT TRUE
 * - description is NULL (allows NULL)
 */

-- Insert with some DEFAULT values explicitly specified
INSERT INTO products (product_name, price, discount, stock_quantity) VALUES
    ('Monitor', 10000, 5.00, 10),
    ('Headphones', 2000, DEFAULT, 50);  -- discount will be 0.00

SELECT product_name, price, discount, stock_quantity FROM products
WHERE product_name IN ('Monitor', 'Headphones');

/**
 * OUTPUT:
 * ┌──────────────┬─────────┬──────────┬─────────────────┐
 * │ product_name │ price   │ discount │ stock_quantity  │
 * ├──────────────┼─────────┼──────────┼─────────────────┤
 * │ Monitor      │ 10000.00│ 5.00     │ 10              │
 * │ Headphones   │ 2000.00 │ 0.00     │ 50              │
 * └──────────────┴─────────┴──────────┴─────────────────┘
 */

-- ============================================================================
-- PART 5: OMITTING COLUMNS that allow NULL
-- ============================================================================

/**
 * Columns that allow NULL get NULL when omitted.
 */

-- Clear existing data
TRUNCATE employees RESTART IDENTITY;

-- Insert only name (others get NULL or DEFAULT)
INSERT INTO employees (name) VALUES
    ('Alice'),
    ('Bob'),
    ('Carol');

SELECT emp_id, name, department, salary, hire_date, manager_id, is_permanent 
FROM employees;

/**
 * OUTPUT:
 * ┌────────┬─────────┬────────────┬─────────┬────────────┬────────────┬─────────────┐
 * │ emp_id │ name    │ department │ salary  │ hire_date  │ manager_id │ is_permanent│
 * ├────────┼─────────┼────────────┼─────────┼────────────┼────────────┼─────────────┤
 * │ 1      │ Alice   │ NULL       │ NULL    │ 2024-01-15 │ NULL       │ true        │
 * │ 2      │ Bob     │ NULL       │ NULL    │ 2024-01-15 │ NULL       │ true        │
 * │ 3      │ Carol   │ NULL       │ NULL    │ 2024-01-15 │ NULL       │ true        │
 * └────────┴─────────┴────────────┴─────────┴────────────┴────────────┴─────────────┘
 * 
 * EXPLANATION:
 * - department: NULL (allows NULL)
 * - salary: NULL (allows NULL)
 * - manager_id: NULL (allows NULL)
 * - hire_date: DEFAULT CURRENT_DATE
 * - is_permanent: DEFAULT TRUE
 */

-- Insert with some NULL-capable columns provided
INSERT INTO employees (name, department, salary) VALUES
    ('Dave', 'IT', 75000),
    ('Eve', 'HR', 65000);

SELECT emp_id, name, department, salary, manager_id FROM employees
WHERE emp_id > 3;

/**
 * OUTPUT:
 * ┌────────┬─────────┬────────────┬─────────┬────────────┐
 * │ emp_id │ name    │ department │ salary  │ manager_id │
 * ├────────┼─────────┼────────────┼─────────┼────────────┤
 * │ 4      │ Dave    │ IT         │ 75000.00│ NULL       │
 * │ 5      │ Eve     │ HR         │ 65000.00│ NULL       │
 * └────────┴─────────┴────────────┴─────────┴────────────┘
 */

-- ============================================================================
-- PART 6: INSERT with MIX of Values (Some values, some DEFAULT/NULL)
-- ============================================================================

/**
 * You can mix provided values, DEFAULT keyword, and omitted columns.
 */

-- Clear existing data
TRUNCATE orders RESTART IDENTITY;

-- Insert with mix of explicit values, DEFAULT, and omitted columns
INSERT INTO orders (customer_name, product_name, quantity, status, priority) VALUES
    ('Ayaan', 'Laptop', 1, DEFAULT, DEFAULT),     -- status = 'PENDING', priority = 1
    ('Sneha', 'Mouse', 2, 'CONFIRMED', 2),        -- all explicit
    ('Rohit', 'Keyboard', 1, DEFAULT, 3);         -- status DEFAULT, priority explicit

SELECT order_id, customer_name, product_name, quantity, status, priority, order_date, notes 
FROM orders;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬──────────┬───────────┬──────────┬────────────┬───────┐
 * │ order_id │ customer_name │ product_name │ quantity │ status    │ priority │ order_date │ notes │
 * ├──────────┼───────────────┼──────────────┼──────────┼───────────┼──────────┼────────────┼───────┤
 * │ 1        │ Ayaan         │ Laptop       │ 1        │ PENDING   │ 1        │ 2024-01-15 │ NULL  │
 * │ 2        │ Sneha         │ Mouse        │ 2        │ CONFIRMED │ 2        │ 2024-01-15 │ NULL  │
 * │ 3        │ Rohit         │ Keyboard     │ 1        │ PENDING   │ 3        │ 2024-01-15 │ NULL  │
 * └──────────┴───────────────┴──────────────┴──────────┴───────────┴──────────┴────────────┴───────┘
 */

-- Insert with notes (optional TEXT column)
INSERT INTO orders (customer_name, product_name, quantity, notes) VALUES
    ('Priya', 'Monitor', 1, 'Urgent delivery'),
    ('Neha', 'Headphones', 2, 'Gift wrapping required');

SELECT order_id, customer_name, product_name, quantity, notes, status, priority 
FROM orders WHERE order_id > 3;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬──────────┬─────────────────────────┬─────────┬──────────┐
 * │ order_id │ customer_name │ product_name │ quantity │ notes                   │ status  │ priority │
 * ├──────────┼───────────────┼──────────────┼──────────┼─────────────────────────┼─────────┼──────────┤
 * │ 4        │ Priya         │ Monitor      │ 1        │ Urgent delivery         │ PENDING │ 1        │
 * │ 5        │ Neha          │ Headphones   │ 2        │ Gift wrapping required  │ PENDING │ 1        │
 * └──────────┴───────────────┴──────────────┴──────────┴─────────────────────────┴─────────┴──────────┘
 */

-- ============================================================================
-- PART 7: INSERT with SPECIFIC COLUMNS & RETURNING
-- ============================================================================

/**
 * RETURNING shows you what was actually inserted (including defaults).
 */

-- Clear existing data
TRUNCATE customers RESTART IDENTITY;

-- Insert and see all values (including defaults)
INSERT INTO customers (name, email)
VALUES ('Ayaan', 'ayaan@email.com')
RETURNING *;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┬───────┬─────┬─────────┬─────────┬────────────┐
 * │ customer_id │ name    │ email           │ phone │ age │ city    │ country │ signup_date│
 * ├─────────────┼─────────┼─────────────────┼───────┼─────┼─────────┼─────────┼────────────┤
 * │ 1           │ Ayaan   │ ayaan@email.com │ NULL  │ NULL│ Unknown │ India   │ 2024-01-15 │
 * └─────────────┴─────────┴─────────────────┴───────┴─────┴─────────┴─────────┴────────────┘
 */

-- Insert with specific columns and return only specific columns
INSERT INTO customers (name, email, city)
VALUES ('Sneha', 'sneha@email.com', 'Delhi')
RETURNING customer_id, name, email, city, country, signup_date;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┬─────────────────┬─────────┬─────────┬────────────┐
 * │ customer_id │ name    │ email           │ city    │ country │ signup_date│
 * ├─────────────┼─────────┼─────────────────┼─────────┼─────────┼────────────┤
 * │ 2           │ Sneha   │ sneha@email.com │ Delhi   │ India   │ 2024-01-15 │
 * └─────────────┴─────────┴─────────────────┴─────────┴─────────┴────────────┘
 * 
 * EXPLANATION:
 * - city provided as 'Delhi' (overrides DEFAULT 'Unknown')
 * - country still got DEFAULT 'India'
 */

-- ============================================================================
-- PART 8: INSERT with SPECIFIC COLUMNS & CONFLICT (Handle duplicates)
-- ============================================================================

/**
 * Handle duplicate entries when inserting only specific columns.
 */

-- Clear existing data
TRUNCATE customers RESTART IDENTITY;

-- Insert initial customer
INSERT INTO customers (name, email) VALUES ('Ayaan', 'ayaan@email.com');

-- Try to insert duplicate email with ON CONFLICT
INSERT INTO customers (name, email, phone)
VALUES ('Ayaan Khan', 'ayaan@email.com', '9876543210')
ON CONFLICT (email) 
DO UPDATE SET 
    name = EXCLUDED.name,
    phone = EXCLUDED.phone
RETURNING *;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┬─────────────────┬────────────┬─────┬─────────┬─────────┬────────────┐
 * │ customer_id │ name        │ email           │ phone      │ age │ city    │ country │ signup_date│
 * ├─────────────┼─────────────┼─────────────────┼────────────┼─────┼─────────┼─────────┼────────────┤
 * │ 1           │ Ayaan Khan  │ ayaan@email.com │ 9876543210 │ NULL│ Unknown │ India   │ 2024-01-15 │
 * └─────────────┴─────────────┴─────────────────┴────────────┴─────┴─────────┴─────────┴────────────┘
 * 
 * EXPLANATION:
 * - Instead of inserting new row, existing row was updated
 * - name changed from 'Ayaan' to 'Ayaan Khan'
 * - phone added (was NULL, now '9876543210')
 * - Other columns (city, country, signup_date) unchanged
 */

-- Insert with ON CONFLICT DO NOTHING (skip duplicates)
INSERT INTO customers (name, email)
VALUES ('New Customer', 'ayaan@email.com')  -- email already exists
ON CONFLICT (email) DO NOTHING
RETURNING *;

/**
 * OUTPUT:
 * (no rows returned - duplicate was skipped)
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: New Customer Registration (Web Form)
 * 
 * User fills only name and email during signup
 */

TRUNCATE customers RESTART IDENTITY;

-- Customer signs up with only name and email
INSERT INTO customers (name, email)
VALUES ('Ayaan Khan', 'ayaan@example.com')
RETURNING customer_id, name, email, signup_date;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┬─────────────────────┬────────────┐
 * │ customer_id │ name        │ email               │ signup_date│
 * ├─────────────┼─────────────┼─────────────────────┼────────────┤
 * │ 1           │ Ayaan Khan  │ ayaan@example.com   │ 2024-01-15 │
 * └─────────────┴─────────────┴─────────────────────┴────────────┘
 * 
 * EXPLANATION:
 * - customer_id auto-generated
 * - signup_date automatically set to today
 * - city defaulted to 'Unknown'
 * - country defaulted to 'India'
 * - phone and age are NULL (not provided)
 */

-- Customer updates profile later with more info
INSERT INTO customers (name, email, phone, age, city)
VALUES ('Ayaan Khan', 'ayaan@example.com', '9876543210', 25, 'Mumbai')
ON CONFLICT (email) DO UPDATE SET
    phone = EXCLUDED.phone,
    age = EXCLUDED.age,
    city = EXCLUDED.city;

SELECT customer_id, name, email, phone, age, city FROM customers;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────┬─────────────────────┬────────────┬─────┬─────────┐
 * │ customer_id │ name        │ email               │ phone      │ age │ city    │
 * ├─────────────┼─────────────┼─────────────────────┼────────────┼─────┼─────────┤
 * │ 1           │ Ayaan Khan  │ ayaan@example.com   │ 9876543210 │ 25  │ Mumbai  │
 * └─────────────┴─────────────┴─────────────────────┴────────────┴─────┴─────────┘
 */

/**
 * SCENARIO 2: Quick Product Addition
 * 
 * Warehouse receiving new products, only know name and price
 */

TRUNCATE products RESTART IDENTITY;

-- Add new products with minimal information
INSERT INTO products (product_name, price) VALUES
    ('iPhone 15', 79999),
    ('Samsung S24', 74999),
    ('Sony Headphones', 2999),
    ('Logitech Mouse', 1499)
RETURNING product_id, product_name, price, category, stock_quantity;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────┬─────────┬───────────┬─────────────────┐
 * │ product_id │ product_name    │ price   │ category  │ stock_quantity  │
 * ├────────────┼─────────────────┼─────────┼───────────┼─────────────────┤
 * │ 1          │ iPhone 15       │ 79999.00│ General   │ 0               │
 * │ 2          │ Samsung S24     │ 74999.00│ General   │ 0               │
 * │ 3          │ Sony Headphones │ 2999.00 │ General   │ 0               │
 * │ 4          │ Logitech Mouse  │ 1499.00 │ General   │ 0               │
 * └────────────┴─────────────────┴─────────┴───────────┴─────────────────┘
 */

-- Later, add category and stock information
UPDATE products SET 
    category = 'Electronics',
    stock_quantity = 50
WHERE category = 'General';

SELECT product_name, category, price, stock_quantity FROM products;

/**
 * OUTPUT:
 * ┌─────────────────┬──────────────┬─────────┬─────────────────┐
 * │ product_name    │ category     │ price   │ stock_quantity  │
 * ├─────────────────┼──────────────┼─────────┼─────────────────┤
 * │ iPhone 15       │ Electronics  │ 79999.00│ 50              │
 * │ Samsung S24     │ Electronics  │ 74999.00│ 50              │
 * │ Sony Headphones │ Electronics  │ 2999.00 │ 50              │
 * │ Logitech Mouse  │ Electronics  │ 1499.00 │ 50              │
 * └─────────────────┴──────────────┴─────────┴─────────────────┘
 */

/**
 * SCENARIO 3: Express Order (Customer in hurry)
 * 
 * Customer places order with minimum information
 */

TRUNCATE orders RESTART IDENTITY;

-- Customer places quick order with only essentials
INSERT INTO orders (customer_name, product_name, quantity)
VALUES ('Ayaan', 'iPhone 15', 1)
RETURNING order_id, customer_name, product_name, quantity, order_date, status;

/**
 * OUTPUT:
 * ┌──────────┬───────────────┬──────────────┬──────────┬────────────┬─────────┐
 * │ order_id │ customer_name │ product_name │ quantity │ order_date │ status  │
 * ├──────────┼───────────────┼──────────────┼──────────┼────────────┼─────────┤
 * │ 1        │ Ayaan         │ iPhone 15    │ 1        │ 2024-01-15 │ PENDING │
 * └──────────┴───────────────┴──────────────┴──────────┴────────────┴─────────┘
 * 
 * EXPLANATION:
 * - order_date automatically set to today
 * - status defaulted to 'PENDING'
 * - priority defaulted to 1
 * - notes is NULL
 */

/**
 * SCENARIO 4: Employee Onboarding
 * 
 * HR adds new employee with minimal information first
 */

TRUNCATE employees RESTART IDENTITY;

-- New employee joins, basic info added first
INSERT INTO employees (name, department)
VALUES ('Alice Johnson', 'Engineering')
RETURNING emp_id, name, department, hire_date, is_permanent;

/**
 * OUTPUT:
 * ┌────────┬─────────────────┬─────────────┬────────────┬─────────────┐
 * │ emp_id │ name            │ department  │ hire_date  │ is_permanent│
 * ├────────┼─────────────────┼─────────────┼────────────┼─────────────┤
 * │ 1      │ Alice Johnson   │ Engineering │ 2024-01-15 │ true        │
 * └────────┴─────────────────┴─────────────┴────────────┴─────────────┘
 */

-- Later, salary and manager information added
INSERT INTO employees (name, department, salary, manager_id)
VALUES ('Alice Johnson', 'Engineering', 95000, NULL)
ON CONFLICT (emp_id) DO UPDATE SET
    salary = EXCLUDED.salary;

SELECT emp_id, name, department, salary, manager_id, is_permanent FROM employees;

/**
 * OUTPUT:
 * ┌────────┬─────────────────┬─────────────┬─────────┬────────────┬─────────────┐
 * │ emp_id │ name            │ department  │ salary  │ manager_id │ is_permanent│
 * ├────────┼─────────────────┼─────────────┼─────────┼────────────┼─────────────┤
 * │ 1      │ Alice Johnson   │ Engineering │ 95000.00│ NULL       │ true        │
 * └────────┴─────────────────┴─────────────┴─────────┴────────────┴─────────────┘
 */

/**
 * SCENARIO 5: Bulk Product Import (Only name and price known)
 * 
 * Importing product catalog from spreadsheet with minimal data
 */

TRUNCATE products RESTART IDENTITY;

-- Import products with only name and price
INSERT INTO products (product_name, price) VALUES
    ('Wireless Mouse', 1299),
    ('Mechanical Keyboard', 3499),
    ('USB Hub', 899),
    ('HDMI Cable', 499),
    ('Laptop Stand', 1999),
    ('Webcam', 2999),
    ('Microphone', 4499),
    ('Ring Light', 2499);

SELECT product_id, product_name, price, category, discount, stock_quantity, is_active 
FROM products
ORDER BY price DESC;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬─────────┬───────────┬──────────┬─────────────────┬───────────┐
 * │ product_id │ product_name        │ price   │ category  │ discount │ stock_quantity  │ is_active │
 * ├────────────┼─────────────────────┼─────────┼───────────┼──────────┼─────────────────┼───────────┤
 * │ 2          │ Mechanical Keyboard │ 3499.00 │ General   │ 0.00     │ 0               │ true      │
 * │ 7          │ Microphone          │ 4499.00 │ General   │ 0.00     │ 0               │ true      │
 * │ 6          │ Webcam              │ 2999.00 │ General   │ 0.00     │ 0               │ true      │
 * │ 8          │ Ring Light          │ 2499.00 │ General   │ 0.00     │ 0               │ true      │
 * │ 5          │ Laptop Stand        │ 1999.00 │ General   │ 0.00     │ 0               │ true      │
 * │ 1          │ Wireless Mouse      │ 1299.00 │ General   │ 0.00     │ 0               │ true      │
 * │ 3          │ USB Hub             │ 899.00  │ General   │ 0.00     │ 0               │ true      │
 * │ 4          │ HDMI Cable          │ 499.00  │ General   │ 0.00     │ 0               │ true      │
 * └────────────┴─────────────────────┴─────────┴───────────┴──────────┴─────────────────┴───────────┘
 */

-- ============================================================================
-- PART 10: COLUMN TYPES REFERENCE
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              WHICH COLUMNS CAN BE OMITTED?                              │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────────────────────┬──────────────────────────────────────┐   │
 * │ │ Column Definition          │ Can you omit?                        │   │
 * ├────────────────────────────┼──────────────────────────────────────┤   │
 * │ │ SERIAL / AUTO_INCREMENT   │ YES - Auto-generates value           │   │
 * │ │ NOT NULL (no default)     │ NO - Must provide value              │   │
 * │ │ NOT NULL DEFAULT value    │ YES - Uses DEFAULT value             │   │
 * │ │ DEFAULT value (allows NULL)│ YES - Uses DEFAULT value            │   │
 * │ │ NULL (no default)         │ YES - Becomes NULL                   │   │
 * │ └────────────────────────────┴──────────────────────────────────────┘   │
 * │                                                                          │
 * │ EXAMPLES:                                                               │
 * │ ┌─────────────────────────────────────────────────────────────────┐   │
 * │ │ Column Definition        │ Omitted? │ Result                     │   │
 * │ ├──────────────────────────┼──────────┼────────────────────────────┤   │
 * │ │ id SERIAL PRIMARY KEY    │ YES      │ Auto-increments (1,2,3...) │   │
 * │ │ name VARCHAR NOT NULL    │ NO       │ ERROR! Must provide        │   │
 * │ │ age INT                  │ YES      │ Becomes NULL               │   │
 * │ │ city VARCHAR DEFAULT 'NA'│ YES      │ Becomes 'NA'               │   │
 * │ │ created_at TIMESTAMP     │ YES      │ Becomes NULL               │   │
 * │ │   DEFAULT CURRENT_DATE   │          │                            │   │
 * │ └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 11: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Omitting a NOT NULL column without DEFAULT                 │
 * │                                                                          │
 * │   ❌ INSERT INTO customers (name) VALUES ('Ayaan');                     │
 * │      → ERROR! Column 'email' has no default and cannot be NULL         │
 * │                                                                          │
 * │   ✅ INSERT INTO customers (name, email) VALUES ('Ayaan', 'a@b.com');   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ This will cause an error
-- INSERT INTO customers (name) VALUES ('Ayaan');  -- ERROR! email is required

-- ✅ Correct
INSERT INTO customers (name, email) VALUES ('Ayaan', 'ayaan@email.com');

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: Assuming NULL is same as DEFAULT                           │
 * │                                                                          │
 * │   DEFAULT 'Unknown' vs NULL are different!                             │
 * │                                                                          │
 * │   INSERT INTO customers (name, email, city) VALUES ('A', 'a@b.com', NULL);│
 * │   → city becomes NULL (not 'Unknown')                                  │
 * │                                                                          │
 * │   INSERT INTO customers (name, email) VALUES ('A', 'a@b.com');          │
 * │   → city becomes 'Unknown' (DEFAULT)                                   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- City becomes NULL (not the default 'Unknown')
INSERT INTO customers (name, email, city) VALUES ('Test', 'test@email.com', NULL);

-- City becomes 'Unknown' (default)
INSERT INTO customers (name, email) VALUES ('Test2', 'test2@email.com');

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting to specify column names                         │
 * │                                                                          │
 * │   ❌ INSERT INTO customers VALUES ('Ayaan', 'a@b.com');                 │
 * │      → Assumes values for ALL columns in order!                        │
 * │                                                                          │
 * │   ✅ INSERT INTO customers (name, email) VALUES ('Ayaan', 'a@b.com');   │
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
 * │ RULE 1: Always specify column names                                     │
 * │         → INSERT INTO table (col1, col2) VALUES (val1, val2)           │
 * │         → Never rely on column order                                   │
 * │                                                                          │
 * │ RULE 2: Know your columns                                              │
 * │         → Which columns are NOT NULL (must provide)                    │
 * │         → Which columns have DEFAULT values                            │
 * │         → Which columns allow NULL                                     │
 * │                                                                          │
 * │ RULE 3: You CANNOT omit NOT NULL columns without DEFAULT               │
 * │         → These must always be provided                                │
 * │                                                                          │
 * │ RULE 4: You CAN omit columns with DEFAULT                              │
 * │         → They get their default values automatically                  │
 * │                                                                          │
 * │ RULE 5: You CAN omit columns that allow NULL                           │
 * │         → They become NULL automatically                               │
 * │                                                                          │
 * │ RULE 6: Use RETURNING to see what was inserted                         │
 * │         → Especially useful to see auto-generated IDs and defaults     │
 * │                                                                          │
 * │ RULE 7: Use ON CONFLICT for UPSERT operations                          │
 * │         → Insert or update based on unique constraint                  │
 * │                                                                          │
 * │ RULE 8: DEFAULT and NULL are different                                 │
 * │         → DEFAULT uses column's default value                          │
 * │         → NULL explicitly sets to NULL                                 │
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
 * │ -- Insert only required columns                                         │
 * │ INSERT INTO table (required_col1, required_col2)                        │
 * │ VALUES (val1, val2);                                                    │
 * │                                                                          │
 * │ -- Insert with some optional columns                                    │
 * │ INSERT INTO table (col1, col2, optional_col)                            │
 * │ VALUES (val1, val2, val3);                                              │
 * │                                                                          │
 * │ -- Insert with DEFAULT keyword                                          │
 * │ INSERT INTO table (col1, col2, col3)                                    │
 * │ VALUES (val1, DEFAULT, val3);                                           │
 * │                                                                          │
 * │ -- Insert with RETURNING (see all values)                               │
 * │ INSERT INTO table (col1, col2) VALUES (val1, val2)                      │
 * │ RETURNING *;                                                            │
 * │                                                                          │
 * │ -- Insert with ON CONFLICT (update if exists)                           │
 * │ INSERT INTO table (unique_col, col1, col2) VALUES (val1, val2, val3)    │
 * │ ON CONFLICT (unique_col) DO UPDATE SET col1 = EXCLUDED.col1;            │
 * │                                                                          │
 * │ -- Insert with ON CONFLICT DO NOTHING                                   │
 * │ INSERT INTO table (unique_col, col1) VALUES (val1, val2)                │
 * │ ON CONFLICT (unique_col) DO NOTHING;                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Insert a new customer with only name and email
 * 
 * Answer:
 *   INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
 */

/**
 * EXERCISE 2: Insert a new product with name and price (others default)
 * 
 * Answer:
 *   INSERT INTO products (product_name, price) VALUES ('Tablet', 15000);
 */

/**
 * EXERCISE 3: Insert an order with customer, product, quantity (others default)
 * 
 * Answer:
 *   INSERT INTO orders (customer_name, product_name, quantity) 
 *   VALUES ('Ayaan', 'Laptop', 1);
 */

/**
 * EXERCISE 4: Insert an employee with name and department (salary NULL)
 * 
 * Answer:
 *   INSERT INTO employees (name, department) VALUES ('John', 'IT');
 */

/**
 * EXERCISE 5: Insert a customer and return all inserted data
 * 
 * Answer:
 *   INSERT INTO customers (name, email) VALUES ('Jane', 'jane@email.com')
 *   RETURNING *;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. INSERT with specific columns = Insert only the columns you need     │
 * │                                                                          │
 * │ 2. Benefits:                                                            │
 * │    → Only provide data you have                                        │
 * │    → Let database handle defaults                                      │
 * │    → More readable and maintainable                                    │
 * │    → Safe against table changes                                        │
 * │                                                                          │
 * │ 3. What happens to omitted columns:                                    │
 * │    → SERIAL columns → Auto-increment                                   │
 * │    → DEFAULT columns → Get default value                               │
 * │    → NULL columns → Become NULL                                        │
 * │    → NOT NULL (no default) → ERROR! Cannot omit                        │
 * │                                                                          │
 * │ 4. Always specify column names (never rely on order)                   │
 * │                                                                          │
 * │ 5. Use RETURNING to see inserted data (including defaults)             │
 * │                                                                          │
 * │ 6. Use ON CONFLICT to handle duplicate keys                            │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Know your table structure                                          │
 * │   - NOT NULL columns without DEFAULT must be provided                  │
 * │   - DEFAULT and NULL are different                                     │
 * │   - Specify column names for clarity and safety                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF INSERT WITH SPECIFIC COLUMNS GUIDE
-- ============================================================================