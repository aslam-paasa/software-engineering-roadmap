/**
 * UNION & UNION ALL
 * 1. WHAT IS UNION? -------------------------- (Combine results, remove duplicates)
 * 2. WHAT IS UNION ALL? ---------------------- (Combine results, keep duplicates)
 * 3. UNION vs UNION ALL ---------------------- (Key differences)
 * 4. UNION RULES ----------------------------- (Important requirements)
 * 5. UNION WITH ORDER BY --------------------- (Sorting combined results)
 * 6. UNION WITH WHERE ------------------------ (Filter before combining)
 * 7. UNION WITH MULTIPLE TABLES -------------- (Combine 3+ result sets)
 * 8. UNION ALL WITH COUNT -------------------- (Counting with duplicates)
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
 * TABLE 1: CUSTOMERS - Customer information
 */

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

/**
 * TABLE 2: SUPPLIERS - Supplier information
 */

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

/**
 * TABLE 3: EMPLOYEES - Employee information
 */

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    department VARCHAR(50)
);

/**
 * TABLE 4: ORDERS_2023 - Orders from 2023
 */

CREATE TABLE orders_2023 (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    amount DECIMAL(10,2)
);

/**
 * TABLE 5: ORDERS_2024 - Orders from 2024
 */

CREATE TABLE orders_2024 (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    amount DECIMAL(10,2)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * CUSTOMERS TABLE
 * ┌─────────────┬───────────┬──────────────┬─────────────┐
 * │ customer_id │ name      │ city         │ country     │
 * ├─────────────┼───────────┼──────────────┼─────────────┤
 * │ 1           │ Ayaan     │ Mumbai       │ India       │
 * │ 2           │ Sneha     │ Delhi        │ India       │
 * │ 3           │ Rohit     │ Bangalore    │ India       │
 * │ 4           │ John      │ New York     │ USA         │
 * │ 5           │ Sarah     │ Los Angeles  │ USA         │
 * └─────────────┴───────────┴──────────────┴─────────────┘
 */

INSERT INTO customers VALUES
(1, 'Ayaan', 'Mumbai', 'India'),
(2, 'Sneha', 'Delhi', 'India'),
(3, 'Rohit', 'Bangalore', 'India'),
(4, 'John', 'New York', 'USA'),
(5, 'Sarah', 'Los Angeles', 'USA');

/**
 * SUPPLIERS TABLE
 * ┌─────────────┬───────────────┬──────────────┬─────────────┐
 * │ supplier_id │ company_name  │ city         │ country     │
 * ├─────────────┼───────────────┼──────────────┼─────────────┤
 * │ 101         │ Tech Supplies │ Mumbai       │ India       │
 * │ 102         │ Global Parts  │ London       │ UK          │
 * │ 103         │ Digital Goods │ New York     │ USA         │
 * │ 104         │ Office Mart   │ Chicago      │ USA         │
 * │ 105         │ ElectronicsCo │ Bangalore    │ India       │
 * └─────────────┴───────────────┴──────────────┴─────────────┘
 */

INSERT INTO suppliers VALUES
(101, 'Tech Supplies', 'Mumbai', 'India'),
(102, 'Global Parts', 'London', 'UK'),
(103, 'Digital Goods', 'New York', 'USA'),
(104, 'Office Mart', 'Chicago', 'USA'),
(105, 'ElectronicsCo', 'Bangalore', 'India');

/**
 * EMPLOYEES TABLE
 * ┌─────────────┬───────────┬──────────────┬──────────────┐
 * │ employee_id │ name      │ city         │ department   │
 * ├─────────────┼───────────┼──────────────┼──────────────┤
 * │ 1           │ Alice     │ New York     │ Sales        │
 * │ 2           │ Bob       │ London       │ IT           │
 * │ 3           │ Carol     │ Mumbai       │ Marketing    │
 * │ 4           │ Dave      │ Sydney       │ Sales        │
 * └─────────────┴───────────┴──────────────┴──────────────┘
 */

INSERT INTO employees VALUES
(1, 'Alice', 'New York', 'Sales'),
(2, 'Bob', 'London', 'IT'),
(3, 'Carol', 'Mumbai', 'Marketing'),
(4, 'Dave', 'Sydney', 'Sales');

/**
 * ORDERS_2023 TABLE
 * ┌──────────┬───────────────┬─────────┐
 * │ order_id │ customer_name │ amount  │
 * ├──────────┼───────────────┼─────────┤
 * │ 1        │ Ayaan         │ 50000   │
 * │ 2        │ Sneha         │ 15000   │
 * │ 3        │ John          │ 30000   │
 * └──────────┴───────────────┴─────────┘
 */

INSERT INTO orders_2023 VALUES
(1, 'Ayaan', 50000),
(2, 'Sneha', 15000),
(3, 'John', 30000);

/**
 * ORDERS_2024 TABLE
 * ┌──────────┬───────────────┬─────────┐
 * │ order_id │ customer_name │ amount  │
 * ├──────────┼───────────────┼─────────┤
 * │ 101      │ Ayaan         │ 25000   │
 * │ 102      │ Rohit         │ 20000   │
 * │ 103      │ John          │ 45000   │
 * │ 104      │ Sarah         │ 12000   │
 * └──────────┴───────────────┴─────────┘
 */

INSERT INTO orders_2024 VALUES
(101, 'Ayaan', 25000),
(102, 'Rohit', 20000),
(103, 'John', 45000),
(104, 'Sarah', 12000);

-- ============================================================================
-- PART 1: WHAT IS UNION?
-- ============================================================================

/**
 * UNION combines results from multiple SELECT statements and REMOVES duplicates.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS UNION?                                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT column1, column2 FROM table1                             │   │
 * │   │ UNION                                                           │   │
 * │   │ SELECT column1, column2 FROM table2;                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. Run first SELECT query                                       │   │
 * │   │ 2. Run second SELECT query                                      │   │
 *   │   │ 3. Combine all results into one list                           │   │
 * │   │ 4. Remove duplicate rows                                        │   │
 * │   │ 5. Return unique results                                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ "Show me all unique cities where we have customers OR suppliers"│   │
 * │   │                                                                  │   │
 * │   │ Mumbai appears in BOTH tables → appears only ONCE in result     │   │
 * │   │ Bangalore appears only in customers → appears once              │   │
 * │   │ London appears only in suppliers → appears once                 │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    UNION - EXAMPLE                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find all unique cities from customers and suppliers           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT city FROM customers                                      │   │
 * │   │ UNION                                                           │   │
 *   │   │ SELECT city FROM suppliers;                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Result from customers query                                 │
 * │   ┌─────────────────┐                                                │
 * │   │ city            │                                                │
 * │   ├─────────────────┤                                                │
 * │   │ Mumbai          │                                                │
 * │   │ Delhi           │                                                │
 * │   │ Bangalore       │                                                │
 * │   │ New York        │                                                │
 * │   │ Los Angeles     │                                                │
 *   │   └─────────────────┘                                                │
 * │                                                                          │
 * │   STEP 2: Result from suppliers query                                 │
 * │   ┌─────────────────┐                                                │
 * │   │ city            │                                                │
 * │   ├─────────────────┤                                                │
 * │   │ Mumbai          │                                                │
 * │   │ London          │                                                │
 * │   │ New York        │                                                │
 * │   │ Chicago         │                                                │
 * │   │ Bangalore       │                                                │
 * │   └─────────────────┘                                                │
 * │                                                                          │
 * │   STEP 3: Combined and duplicates removed (UNION)                     │
 * │   ┌─────────────────┐                                                │
 *   │   │ city            │                                                │
 * │   ├─────────────────┤                                                │
 * │   │ Mumbai          │  ← appears in both, but shown once             │
 * │   │ Delhi           │                                                │
 *   │   │ Bangalore       │                                                │
 * │   │ New York        │                                                │
 * │   │ Los Angeles     │                                                │
 * │   │ London          │                                                │
 * │   │ Chicago         │                                                │
 * │   └─────────────────┘                                                │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example 1: Unique cities from customers and suppliers
SELECT city FROM customers
UNION
SELECT city FROM suppliers
ORDER BY city;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ city        │
 * ├─────────────┤
 * │ Bangalore   │
 * │ Chicago     │
 * │ Delhi       │
 * │ London      │
 * │ Los Angeles │
 * │ Mumbai      │
 * │ New York    │
 * └─────────────┘
 * 
 * EXPLANATION:
 * - Mumbai appears in both tables → shown once
 * - Bangalore appears in both tables → shown once
 * - New York appears in both tables → shown once
 * - Total 7 unique cities (customers had 5, suppliers had 5, but 3 duplicates)
 */

-- Example 2: Unique countries from customers and suppliers
SELECT country FROM customers
UNION
SELECT country FROM suppliers
ORDER BY country;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ country │
 * ├─────────┤
 * │ India   │
 * │ UK      │
 * │ USA     │
 * └─────────┘
 * 
 * EXPLANATION:
 * - India appears in both tables → shown once
 * - USA appears in both tables → shown once
 * - UK appears only in suppliers
 */

-- ============================================================================
-- PART 2: WHAT IS UNION ALL?
-- ============================================================================

/**
 * UNION ALL combines results from multiple SELECT statements and KEEPS duplicates.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    UNION ALL - EXAMPLE                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find all cities from customers and suppliers (keep duplicates) │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT city FROM customers                                      │   │
 * │   │ UNION ALL                                                       │   │
 * │   │ SELECT city FROM suppliers;                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Result from customers (5 rows)                               │
 * │   ┌─────────────────┐                                                │
 * │   │ Mumbai          │                                                │
 * │   │ Delhi           │                                                │
 * │   │ Bangalore       │                                                │
 * │   │ New York        │                                                │
 * │   │ Los Angeles     │                                                │
 * │   └─────────────────┘                                                │
 * │                                                                          │
 * │   STEP 2: Result from suppliers (5 rows)                              │
 * │   ┌─────────────────┐                                                │
 * │   │ Mumbai          │                                                │
 * │   │ London          │                                                │
 * │   │ New York        │                                                │
 * │   │ Chicago         │                                                │
 * │   │ Bangalore       │                                                │
 * │   └─────────────────┘                                                │
 * │                                                                          │
 * │   STEP 3: Combined with duplicates KEPT (UNION ALL)                   │
 * │   ┌─────────────────┐                                                │
 * │   │ Mumbai          │  ← appears twice (kept both)                   │
 * │   │ Delhi           │                                                │
 * │   │ Bangalore       │  ← appears twice (kept both)                   │
 * │   │ New York        │  ← appears twice (kept both)                   │
 * │   │ Los Angeles     │                                                │
 * │   │ Mumbai          │  ← second copy                                 │
 * │   │ London          │                                                │
 * │   │ New York        │  ← second copy                                 │
 * │   │ Chicago         │                                                │
 * │   │ Bangalore       │  ← second copy                                 │
 * │   └─────────────────┘                                                │
 * │                                                                          │
 * │   Total rows: 10 (5 + 5)                                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Example: All cities (keep duplicates) from customers and suppliers
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers
ORDER BY city;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ city        │
 * ├─────────────┤
 * │ Bangalore   │
 * │ Bangalore   │
 * │ Chicago     │
 * │ Delhi       │
 * │ London      │
 * │ Los Angeles │
 * │ Mumbai      │
 * │ Mumbai      │
 * │ New York    │
 * │ New York    │
 * └─────────────┘
 * 
 * EXPLANATION:
 * - Total 10 rows (5 from customers + 5 from suppliers)
 * - Bangalore appears twice (once in each table)
 * - Mumbai appears twice (once in each table)
 * - New York appears twice (once in each table)
 */

-- ============================================================================
-- PART 3: UNION vs UNION ALL (Key differences)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    UNION vs UNION ALL - COMPARISON                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │                    UNION                                            ││
 * │ ├─────────────────────────────────────────────────────────────────────┤│
 * │ │ • Removes duplicate rows                                           ││
 * │ │ • Slower (must check for duplicates)                               ││
 * │ │ • Uses more memory                                                  ││
 * │ │ • Results are unique                                               ││
 * │ │ • Use when you need DISTINCT results                               ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │                    UNION ALL                                        ││
 * │ ├─────────────────────────────────────────────────────────────────────┤│
 * │ │ • Keeps all duplicate rows                                         ││
 * │ │ • Faster (no duplicate checking)                                   ││
 * │ │ • Uses less memory                                                  ││
 * │ │ • Results may have duplicates                                      ││
 * │ │ • Use when you know there are no duplicates OR want all rows       ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * PERFORMANCE COMPARISON:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         SPEED TEST                                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   UNION:      Must compare every row to remove duplicates              │
 * │   UNION ALL:  Simply concatenates results (no comparison)              │
 * │                                                                          │
 * │   For large datasets, UNION ALL can be 2-3 times FASTER!               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Compare outputs
-- UNION (no duplicates)
SELECT country FROM customers
UNION
SELECT country FROM suppliers;

/**
 * OUTPUT: 3 rows (India, UK, USA)
 */

-- UNION ALL (with duplicates)
SELECT country FROM customers
UNION ALL
SELECT country FROM suppliers;

/**
 * OUTPUT: 10 rows (India 3 times, USA 3 times, UK 1 time, etc.)
 * Actually: India appears 3 times in customers + 2 times in suppliers = 5 times
 * USA appears 2 times in customers + 1 time in suppliers = 3 times
 * UK appears 0 + 1 = 1 time
 */

-- ============================================================================
-- PART 4: UNION RULES (Important requirements)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    IMPORTANT UNION RULES                                │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Same number of columns                                         │
 * │         → Both SELECT statements must have the SAME number of columns  │
 * │                                                                          │
 * │ RULE 2: Compatible data types                                          │
 * │         → Corresponding columns must have compatible data types        │
 * │         → Example: INT can be UNION with DECIMAL                       │
 * │         → But INT cannot be UNION with TEXT (in most databases)        │
 * │                                                                          │
 * │ RULE 3: Column names come from FIRST query                             │
 * │         → The column names in result are taken from the first SELECT   │
 * │                                                                          │
 * │ RULE 4: ORDER BY applies to entire result                              │
 * │         → Put ORDER BY only at the very end                            │
 * │         → Cannot ORDER BY individual SELECT statements                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ✅ CORRECT: Same number of columns
SELECT customer_id, name FROM customers
UNION
SELECT supplier_id, company_name FROM suppliers;

-- ❌ WRONG: Different number of columns
-- SELECT customer_id, name, city FROM customers
-- UNION
-- SELECT supplier_id, company_name FROM suppliers;  -- ERROR!

-- ✅ CORRECT: ORDER BY at the end
SELECT city FROM customers
UNION
SELECT city FROM suppliers
ORDER BY city;  -- ORDER BY applies to combined result

-- ❌ WRONG: ORDER BY in individual SELECT (not allowed in most databases)
-- SELECT city FROM customers ORDER BY city
-- UNION
-- SELECT city FROM suppliers;  -- ERROR!

-- ============================================================================
-- PART 5: UNION WITH ORDER BY (Sorting combined results)
-- ============================================================================

/**
 * You can sort the combined result using ORDER BY at the end.
 * Column names from the FIRST query are used for sorting.
 */

-- Example: Sort cities alphabetically
SELECT city AS location FROM customers
UNION
SELECT city FROM suppliers
ORDER BY location;  -- Can use alias from first query

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ location    │
 * ├─────────────┤
 * │ Bangalore   │
 * │ Chicago     │
 * │ Delhi       │
 * │ London      │
 * │ Los Angeles │
 * │ Mumbai      │
 * │ New York    │
 * └─────────────┘
 */

-- Sort by multiple columns
SELECT city, country FROM customers
UNION
SELECT city, country FROM suppliers
ORDER BY country, city;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┐
 * │ city        │ country │
 * ├─────────────┼─────────┤
 * │ Bangalore   │ India   │
 * │ Delhi       │ India   │
 * │ Mumbai      │ India   │
 * │ London      │ UK      │
 * │ Chicago     │ USA     │
 * │ Los Angeles │ USA     │
 * │ New York    │ USA     │
 * └─────────────┴─────────┘
 */

-- ============================================================================
-- PART 6: UNION WITH WHERE (Filter before combining)
-- ============================================================================

/**
 * You can filter each SELECT individually before combining.
 */

-- Example: Cities from India (customers) + Cities from USA (suppliers)
SELECT city, country FROM customers WHERE country = 'India'
UNION
SELECT city, country FROM suppliers WHERE country = 'USA'
ORDER BY city;

/**
 * OUTPUT:
 * ┌─────────────┬─────────┐
 * │ city        │ country │
 * ├─────────────┼─────────┤
 * │ Bangalore   │ India   │
 * │ Chicago     │ USA     │
 * │ Delhi       │ India   │
 * │ Los Angeles │ USA     │
 * │ Mumbai      │ India   │
 * │ New York    │ USA     │
 * └─────────────┴─────────┘
 */

-- Example: Customers from India + Suppliers from UK
SELECT name AS contact, city, 'Customer' AS type FROM customers WHERE country = 'India'
UNION
SELECT company_name, city, 'Supplier' AS type FROM suppliers WHERE country = 'UK'
ORDER BY city;

/**
 * OUTPUT:
 * ┌───────────────┬────────────┬──────────┐
 * │ contact       │ city       │ type     │
 * ├───────────────┼────────────┼──────────┤
 * │ Rohit         │ Bangalore  │ Customer │
 * │ Sneha         │ Delhi      │ Customer │
 * │ Global Parts  │ London     │ Supplier │
 * │ Ayaan         │ Mumbai     │ Customer │
 * └───────────────┴────────────┴──────────┘
 */

-- ============================================================================
-- PART 7: UNION WITH MULTIPLE TABLES (Combine 3+ result sets)
-- ============================================================================

/**
 * You can combine results from 3 or more tables using multiple UNIONs.
 */

-- Example: Unique cities from customers, suppliers, and employees
SELECT city FROM customers
UNION
SELECT city FROM suppliers
UNION
SELECT city FROM employees
ORDER BY city;

/**
 * OUTPUT:
 * ┌─────────────┐
 * │ city        │
 * ├─────────────┤
 * │ Bangalore   │
 * │ Chicago     │
 * │ Delhi       │
 * │ London      │
 * │ Los Angeles │
 * │ Mumbai      │
 * │ New York    │
 * │ Sydney      │
 * └─────────────┘
 * 
 * EXPLANATION:
 * - Sydney only appears in employees
 * - New York appears in customers, suppliers, AND employees → shown once
 */

-- Example: All names (keep duplicates) from multiple tables
SELECT name FROM customers
UNION ALL
SELECT company_name FROM suppliers
UNION ALL
SELECT name FROM employees
ORDER BY name;

/**
 * OUTPUT:
 * ┌───────────────┐
 * │ name          │
 * ├───────────────┤
 * │ Alice         │
 * │ Ayaan         │
 * │ Bob           │
 * │ Carol         │
 * │ Dave          │
 * │ Digital Goods │
 * │ ElectronicsCo │
 * │ Global Parts  │
 * │ John          │
 * │ Office Mart   │
 * │ Rohit         │
 * │ Sarah         │
 * │ Sneha         │
 * │ Tech Supplies │
 * └───────────────┘
 * 
 * Total: 5 customers + 5 suppliers + 4 employees = 14 rows
 */

-- ============================================================================
-- PART 8: UNION ALL WITH COUNT (Counting with duplicates)
-- ============================================================================

/**
 * You can use UNION ALL to combine data before counting.
 */

-- Example: Count total number of cities (including duplicates)
SELECT COUNT(*) AS total_cities_with_duplicates
FROM (
    SELECT city FROM customers
    UNION ALL
    SELECT city FROM suppliers
    UNION ALL
    SELECT city FROM employees
) AS all_cities;

/**
 * OUTPUT:
 * ┌─────────────────────────────┐
 * │ total_cities_with_duplicates │
 * ├─────────────────────────────┤
 * │ 14                          │
 * └─────────────────────────────┘
 * 
 * EXPLANATION:
 * - customers: 5 rows
 * - suppliers: 5 rows
 * - employees: 4 rows
 * - Total = 14
 */

-- Count unique cities (using UNION instead of UNION ALL)
SELECT COUNT(*) AS unique_cities
FROM (
    SELECT city FROM customers
    UNION
    SELECT city FROM suppliers
    UNION
    SELECT city FROM employees
) AS unique_cities_list;

/**
 * OUTPUT:
 * ┌──────────────┐
 * │ unique_cities│
 * ├──────────────┤
 * │ 8            │
 * └──────────────┘
 */

-- ============================================================================
-- PART 9: REAL-WORLD SCENARIOS
-- ============================================================================

/**
 * SCENARIO 1: Combine orders from multiple years
 * 
 * Get all orders from 2023 and 2024 for customer report
 */

SELECT customer_name, amount, '2023' AS order_year FROM orders_2023
UNION ALL
SELECT customer_name, amount, '2024' AS order_year FROM orders_2024
ORDER BY customer_name, order_year;

/**
 * OUTPUT:
 * ┌───────────────┬─────────┬────────────┐
 * │ customer_name │ amount  │ order_year │
 * ├───────────────┼─────────┼────────────┤
 * │ Ayaan         │ 50000   │ 2023       │
 * │ Ayaan         │ 25000   │ 2024       │
 * │ John          │ 30000   │ 2023       │
 * │ John          │ 45000   │ 2024       │
 * │ Rohit         │ 20000   │ 2024       │
 * │ Sarah         │ 12000   │ 2024       │
 * │ Sneha         │ 15000   │ 2023       │
 * └───────────────┴─────────┴────────────┘
 */

/**
 * SCENARIO 2: Customer and Supplier Contact List
 * 
 * Create a master contact list for mailing
 */

SELECT 
    name AS contact_name,
    city,
    'Customer' AS type
FROM customers
UNION
SELECT 
    company_name,
    city,
    'Supplier' AS type
FROM suppliers
ORDER BY city, contact_name;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────┬──────────┐
 * │ contact_name  │ city        │ type     │
 * ├───────────────┼─────────────┼──────────┤
 * │ ElectronicsCo │ Bangalore   │ Supplier │
 * │ Rohit         │ Bangalore   │ Customer │
 * │ Office Mart   │ Chicago     │ Supplier │
 * │ Sneha         │ Delhi       │ Customer │
 * │ Global Parts  │ London      │ Supplier │
 * │ Sarah         │ Los Angeles │ Customer │
 * │ Ayaan         │ Mumbai      │ Customer │
 * │ Tech Supplies │ Mumbai      │ Supplier │
 * │ Digital Goods │ New York    │ Supplier │
 * │ John          │ New York    │ Customer │
 * └───────────────┴─────────────┴──────────┘
 */

/**
 * SCENARIO 3: Find all cities where we have presence
 * 
 * Get unique cities from customers, suppliers, and employees
 */

SELECT city, 'Has Customers' AS presence FROM customers
UNION
SELECT city, 'Has Suppliers' FROM suppliers
UNION
SELECT city, 'Has Employees' FROM employees
ORDER BY city, presence;

/**
 * OUTPUT:
 * ┌─────────────┬─────────────────┐
 * │ city        │ presence        │
 * ├─────────────┼─────────────────┤
 * │ Bangalore   │ Has Customers   │
 * │ Bangalore   │ Has Suppliers   │
 * │ Chicago     │ Has Suppliers   │
 * │ Delhi       │ Has Customers   │
 * │ London      │ Has Employees   │
 * │ London      │ Has Suppliers   │
 * │ Los Angeles │ Has Customers   │
 * │ Mumbai      │ Has Customers   │
 * │ Mumbai      │ Has Employees   │
 * │ Mumbai      │ Has Suppliers   │
 * │ New York    │ Has Customers   │
 * │ New York    │ Has Employees   │
 * │ New York    │ Has Suppliers   │
 * │ Sydney      │ Has Employees   │
 * └─────────────┴─────────────────┘
 */

/**
 * SCENARIO 4: Sales Report Combining Years
 * 
 * Get total sales per customer across both years
 */

SELECT 
    customer_name,
    SUM(amount) AS total_sales
FROM (
    SELECT customer_name, amount FROM orders_2023
    UNION ALL
    SELECT customer_name, amount FROM orders_2024
) AS all_orders
GROUP BY customer_name
ORDER BY total_sales DESC;

/**
 * OUTPUT:
 * ┌───────────────┬─────────────┐
 * │ customer_name │ total_sales │
 * ├───────────────┼─────────────┤
 * │ Ayaan         │ 75000.00    │
 * │ John          │ 75000.00    │
 * │ Rohit         │ 20000.00    │
 * │ Sneha         │ 15000.00    │
 * │ Sarah         │ 12000.00    │
 * └───────────────┴─────────────┘
 */

/**
 * SCENARIO 5: Department Employee List with External Contacts
 * 
 * Combine internal employees with external contacts for an event
 */

SELECT 
    name,
    department,
    'Internal' AS source
FROM employees
UNION
SELECT 
    name,
    'Customer' AS department,
    'External' AS source
FROM customers
UNION
SELECT 
    company_name,
    'Supplier' AS department,
    'External' AS source
FROM suppliers
ORDER BY source, name;

/**
 * OUTPUT:
 * ┌───────────────┬────────────┬──────────┐
 * │ name          │ department │ source   │
 * ├───────────────┼────────────┼──────────┤
 * │ Ayaan         │ Customer   │ External │
 * │ Digital Goods │ Supplier   │ External │
 * │ ElectronicsCo │ Supplier   │ External │
 * │ Global Parts  │ Supplier   │ External │
 * │ John          │ Customer   │ External │
 * │ Office Mart   │ Supplier   │ External │
 * │ Rohit         │ Customer   │ External │
 * │ Sarah         │ Customer   │ External │
 * │ Sneha         │ Customer   │ External │
 * │ Tech Supplies │ Supplier   │ External │
 * │ Alice         │ Sales      │ Internal │
 * │ Bob           │ IT         │ Internal │
 * │ Carol         │ Marketing  │ Internal │
 * │ Dave          │ Sales      │ Internal │
 * └───────────────┴────────────┴──────────┘
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Different number of columns                                │
 * │                                                                          │
 * │   ❌ SELECT customer_id, name FROM customers                           │
 * │      UNION                                                             │
 * │      SELECT supplier_id FROM suppliers;  ← Different column count!     │
 * │                                                                          │
 * │   ✅ SELECT customer_id, name FROM customers                           │
 * │      UNION                                                             │
 * │      SELECT supplier_id, company_name FROM suppliers;                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- MISTAKE #2: Incompatible data types
-- ❌ SELECT order_id FROM orders_2023
--    UNION
--    SELECT customer_name FROM customers;  -- INT vs VARCHAR

-- ✅ Convert to same type
SELECT CAST(order_id AS VARCHAR) AS id FROM orders_2023
UNION
SELECT customer_name FROM customers;

/**
 * MISTAKE #3: ORDER BY in wrong place
 * 
 *   ❌ SELECT city FROM customers ORDER BY city
 *      UNION
 *      SELECT city FROM suppliers;
 * 
 *   ✅ SELECT city FROM customers
 *      UNION
 *      SELECT city FROM suppliers
 *      ORDER BY city;
 */

/**
 * MISTAKE #4: Using UNION when UNION ALL is sufficient
 * 
 *   ❌ SELECT city FROM customers WHERE country = 'India'
 *      UNION                                    ← Unnecessary duplicate check
 *      SELECT city FROM suppliers WHERE country = 'India';
 *      (These results are already unique per table? Not necessarily)
 * 
 *   ✅ Use UNION ALL if you know no duplicates exist between tables
 *      SELECT city FROM customers WHERE country = 'India'
 *      UNION ALL
 *      SELECT city FROM suppliers WHERE country = 'India';
 */

-- ============================================================================
-- PART 11: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Both SELECT statements must have SAME number of columns        │
 * │                                                                          │
 * │ RULE 2: Corresponding columns must have COMPATIBLE data types          │
 * │                                                                          │
 * │ RULE 3: Column names come from FIRST query                             │
 * │         → Use aliases in first query to rename columns                 │
 * │                                                                          │
 * │ RULE 4: Use UNION ALL when you want ALL rows (faster)                  │
 * │         → Use UNION only when you need to remove duplicates            │
 * │                                                                          │
 * │ RULE 5: ORDER BY only at the END of the entire query                   │
 * │         → Cannot ORDER BY individual SELECT statements                  │
 * │                                                                          │
 * │ RULE 6: UNION removes duplicates across ALL columns                    │
 * │         → Two rows are considered duplicates if ALL columns match      │
 * │                                                                          │
 * │ RULE 7: UNION ALL is faster than UNION                                 │
 * │         → No duplicate checking overhead                               │
 * │         → Use when duplicates are acceptable or impossible             │
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
 * │ -- Basic UNION (removes duplicates)                                    │
 * │ SELECT column1, column2 FROM table1                                    │
 * │ UNION                                                                  │
 * │ SELECT column1, column2 FROM table2;                                   │
 * │                                                                          │
 * │ -- UNION ALL (keeps duplicates)                                        │
 * │ SELECT column1, column2 FROM table1                                    │
 * │ UNION ALL                                                              │
 * │ SELECT column1, column2 FROM table2;                                   │
 * │                                                                          │
 * │ -- UNION with WHERE                                                    │
 * │ SELECT column1 FROM table1 WHERE condition                             │
 * │ UNION                                                                  │
 * │ SELECT column1 FROM table2 WHERE condition;                            │
 * │                                                                          │
 * │ -- UNION with ORDER BY (at the end)                                    │
 * │ SELECT column1 FROM table1                                             │
 * │ UNION                                                                  │
 * │ SELECT column1 FROM table2                                             │
 * │ ORDER BY column1;                                                      │
 * │                                                                          │
 * │ -- UNION with alias (name from first query)                            │
 * │ SELECT column1 AS first_col FROM table1                                │
 * │ UNION                                                                  │
 * │ SELECT column2 FROM table2                                             │
 * │ ORDER BY first_col;                                                    │
 * │                                                                          │
 * │ -- UNION with multiple tables (3 or more)                              │
 * │ SELECT column1 FROM table1                                             │
 * │ UNION                                                                  │
 * │ SELECT column1 FROM table2                                             │
 * │ UNION                                                                  │
 * │ SELECT column1 FROM table3;                                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Get all unique cities from customers and employees
 * 
 * Answer:
 *   SELECT city FROM customers
 *   UNION
 *   SELECT city FROM employees;
 */

/**
 * EXERCISE 2: Get all names (including duplicates) from customers and employees
 * 
 * Answer:
 *   SELECT name FROM customers
 *   UNION ALL
 *   SELECT name FROM employees;
 */

/**
 * EXERCISE 3: Get all countries from customers and suppliers, sorted alphabetically
 * 
 * Answer:
 *   SELECT country FROM customers
 *   UNION
 *   SELECT country FROM suppliers
 *   ORDER BY country;
 */

/**
 * EXERCISE 4: Get Indian customers and UK suppliers
 * 
 * Answer:
 *   SELECT name, city, 'Customer' AS type FROM customers WHERE country = 'India'
 *   UNION
 *   SELECT company_name, city, 'Supplier' FROM suppliers WHERE country = 'UK';
 */

/**
 * EXERCISE 5: Count total number of cities (including duplicates) from all three tables
 * 
 * Answer:
 *   SELECT COUNT(*) FROM (
 *       SELECT city FROM customers
 *       UNION ALL
 *       SELECT city FROM suppliers
 *       UNION ALL
 *       SELECT city FROM employees
 *   ) AS all_cities;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS orders_2024;
DROP TABLE IF EXISTS orders_2023;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. UNION = Combines results, REMOVES duplicates                        │
 * │    → Slower, uses more memory, returns unique rows                     │
 * │                                                                          │
 * │ 2. UNION ALL = Combines results, KEEPS all duplicates                  │
 * │    → Faster, uses less memory, returns all rows                        │
 * │                                                                          │
 * │ 3. Key differences:                                                     │
 * │    ┌─────────────┬──────────────────────┬──────────────────────┐       │
 * │    │ Feature     │ UNION                │ UNION ALL            │       │
 * │    ├─────────────┼──────────────────────┼──────────────────────┤       │
 * │    │ Duplicates  │ Removed              │ Kept                 │       │
 * │    │ Speed       │ Slower               │ Faster               │       │
 * │    │ Memory      │ More                 │ Less                 │       │
 * │    │ Use when    │ Need unique results  │ Want all rows        │       │
 * │    └─────────────┴──────────────────────┴──────────────────────┘       │
 * │                                                                          │
 * │ 4. Rules to remember:                                                   │
 * │    → Same number of columns                                            │
 * │    → Compatible data types                                              │
 * │    → ORDER BY only at the end                                           │
 * │    → Column names come from first query                                 │
 * │                                                                          │
 * │ 5. Use UNION ALL by default (faster)                                   │
 * │    → Only use UNION when you specifically need to remove duplicates    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF UNION & UNION ALL GUIDE
-- ============================================================================