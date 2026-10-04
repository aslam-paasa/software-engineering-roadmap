/**
 * ============================================================================
 * CASE EXPRESSIONS - COMPLETE REVISION GUIDE
 * (Conditional Logic, Branching, Boolean Evaluation)
 * Simple English - Quick revision with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS CASE? --------------------------------- (SQL's IF/ELSE logic)
 *    - 1.1 Basic syntax and example
 *    - 1.2 Searched CASE vs Simple CASE
 * 
 * 2. PRICE-BASED PRODUCT CLASSIFICATION ----------- (Categorizing data)
 * 
 * 3. BOOLEAN EVALUATION WITH CASE ----------------- (PASS/FAIL logic)
 * 
 * 4. HANDLING NULL AND EMPTY STRINGS -------------- (Data cleaning)
 * 
 * 5. BONUS CALCULATION USING CASE and COALESCE ---- (Safe fallback values)
 * 
 * 6. NODE CLASSIFICATION -------------------------- (Hierarchical data)
 * 
 * 7. CONDITIONAL AGGREGATION ---------------------- (CASE inside SUM/COUNT)
 * 
 * 8. NULL COMPARISONS ----------------------------- (Important! NULL = NULL is FALSE)
 * 
 * 9. COMMON MISTAKES ------------------------------ (What to avoid)
 * 
 * 10. GOLDEN RULES -------------------------------- (Key principles)
 * 
 * 11. QUICK REFERENCE CARD ------------------------ (Cheat sheet)
 * 
 * 12. PRACTICE EXERCISES -------------------------- (Test yourself)
 * 
 * ============================================================================
 */

-- ============================================================================
-- PART 1: WHAT IS CASE? (SQL's IF/ELSE logic)
-- ============================================================================

/**
 * CASE is SQL's way of writing IF/ELSE logic inside a query.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS CASE?                                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   SYNTAX:                                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ CASE                                                            │   │
 * │   │     WHEN condition1 THEN value1                                 │   │
 * │   │     WHEN condition2 THEN value2                                 │   │
 * │   │     ...                                                         │   │
 * │   │     ELSE fallback_value                                         │   │
 * │   │ END                                                             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. SQL checks conditions from TOP to BOTTOM                    │   │
 * │   │ 2. Returns the value for the FIRST matching condition          │   │
 * │   │ 3. If no conditions match, returns ELSE value (or NULL)        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   IMPORTANT:                                                           │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ • CASE is an EXPRESSION (returns a value)                      │   │
 * │   │ • Not a statement (can't execute actions)                      │   │
 * │   │ • Must end with END                                             │   │
 * │   │ • ELSE is optional (returns NULL if omitted)                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 1.1 Basic syntax example
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CASE - Basic Example                                       │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Check if age 19 is adult or not                               │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT                                                          │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN 19 >= 18 THEN 'Adult'                              │   │
 * │   │         ELSE 'Not an Adult'                                     │   │
 * │   │     END AS result;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌───────┐                                                           │
 * │   │ result│                                                           │
 * │   ├───────┤                                                           │
 * │   │ Adult │                                                           │
 * │   └───────┘                                                           │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    CASE 
        WHEN 19 >= 18 THEN 'Adult'
        ELSE 'Not an Adult'
    END AS result;

/**
 * OUTPUT:
 * ┌───────┐
 * │ result│
 * ├───────┤
 * │ Adult │
 * └───────┘
 */

-- Example with variable (using CTE in PostgreSQL)
WITH temp AS (SELECT 19 AS temp_age)
SELECT 
    CASE 
        WHEN temp_age >= 18 THEN 'Adult'
        ELSE 'Not an Adult'
    END AS result
FROM temp;

/**
 * OUTPUT:
 * ┌───────┐
 * │ result│
 * ├───────┤
 * │ Adult │
 * └───────┘
 */

-- ============================================================================
-- 1.2 Searched CASE vs Simple CASE
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              SEARCHED CASE vs SIMPLE CASE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ SEARCHED CASE (Most common - for ranges/thresholds):                    │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE                                                               ││
 * │ │     WHEN score >= 90 THEN 'A'                                      ││
 * │ │     WHEN score >= 80 THEN 'B'                                      ││
 * │ │     WHEN score >= 70 THEN 'C'                                      ││
 * │ │     ELSE 'F'                                                       ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │ • Can use ANY condition (>, <, BETWEEN, IS NULL, AND, OR)             │
 * │ • Best for thresholds, ranges, complex logic                          │
 * │                                                                          │
 * │ SIMPLE CASE (For equality mapping):                                     │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE status                                                        ││
 * │ │     WHEN 'P' THEN 'Pending'                                        ││
 * │ │     WHEN 'D' THEN 'Delivered'                                      ││
 * │ │     WHEN 'C' THEN 'Cancelled'                                      ││
 * │ │     ELSE 'Unknown'                                                 ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │ • Only checks equality (=)                                            │
 * │ • Best for mapping fixed values                                       │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Searched CASE example (with ranges)
SELECT 
    CASE 
        WHEN 75 >= 90 THEN 'A'
        WHEN 75 >= 80 THEN 'B'
        WHEN 75 >= 70 THEN 'C'
        WHEN 75 >= 60 THEN 'D'
        ELSE 'F'
    END AS grade;

/**
 * OUTPUT:
 * ┌───────┐
 * │ grade │
 * ├───────┤
 * │ C     │
 * └───────┘
 */

-- Simple CASE example (equality only)
SELECT 
    CASE 'P'
        WHEN 'P' THEN 'Pending'
        WHEN 'D' THEN 'Delivered'
        WHEN 'C' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS status;

/**
 * OUTPUT:
 * ┌─────────┐
 * │ status  │
 * ├─────────┤
 * │ Pending │
 * └─────────┘
 */

-- ============================================================================
-- SOURCE TABLE: PRODUCTS
-- ============================================================================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price INT NULL
);

INSERT INTO products (product_id, name, price) VALUES
(1, 'Laptop Sleeve', 18),
(2, 'Wireless Mouse', 32),
(3, 'Keyboard', 55),
(4, 'Monitor', 150),
(5, 'USB Cable', 8),
(6, 'Webcam', 60),
(7, 'HDMI Cable', 20),
(8, 'Mechanical Keyboard', 120),
(9, 'Sticker Pack', 0),
(10, 'Gift Card', 19),
(11, 'Mystery Box', NULL),
(12, 'Refurb Monitor', 61);

-- Display products
SELECT product_id, name, price FROM products ORDER BY product_id;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬───────┐
 * │ product_id │ name                │ price │
 * ├────────────┼─────────────────────┼───────┤
 * │ 1          │ Laptop Sleeve       │ 18    │
 * │ 2          │ Wireless Mouse      │ 32    │
 * │ 3          │ Keyboard            │ 55    │
 * │ 4          │ Monitor             │ 150   │
 * │ 5          │ USB Cable           │ 8     │
 * │ 6          │ Webcam              │ 60    │
 * │ 7          │ HDMI Cable          │ 20    │
 * │ 8          │ Mechanical Keyboard │ 120   │
 * │ 9          │ Sticker Pack        │ 0     │
 * │ 10         │ Gift Card           │ 19    │
 * │ 11         │ Mystery Box         │ NULL  │
 * │ 12         │ Refurb Monitor      │ 61    │
 * └────────────┴─────────────────────┴───────┘
 */

-- ============================================================================
-- PART 2: PRICE-BASED PRODUCT CLASSIFICATION
-- ============================================================================

/**
 * BUSINESS RULES:
 * - If price is NULL → 'Missing Price'
 * - If price <= 20 → 'Budget'
 * - If price > 20 AND price <= 100 → 'Mid Range'
 * - If price > 100 → 'Premium'
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              PRICE-BASED PRODUCT CLASSIFICATION                         │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT product_id, name, price,                                 │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN price IS NULL THEN 'Missing Price'                 │   │
 * │   │         WHEN price <= 20 THEN 'Budget'                          │   │
 * │   │         WHEN price <= 100 THEN 'Mid Range'                      │   │
 * │   │         WHEN price > 100 THEN 'Premium'                         │   │
 * │   │     END AS price_category                                       │   │
 * │   │ FROM products                                                   │   │
 * │   │ ORDER BY product_id;                                            │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    product_id,
    name,
    price,
    CASE
        WHEN price IS NULL THEN 'Missing Price'
        WHEN price <= 20 THEN 'Budget'
        WHEN price <= 100 THEN 'Mid Range'
        WHEN price > 100 THEN 'Premium'
    END AS price_category
FROM products
ORDER BY product_id;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬───────┬────────────────┐
 * │ product_id │ name                │ price │ price_category │
 * ├────────────┼─────────────────────┼───────┼────────────────┤
 * │ 1          │ Laptop Sleeve       │ 18    │ Budget         │
 * │ 2          │ Wireless Mouse      │ 32    │ Mid Range      │
 * │ 3          │ Keyboard            │ 55    │ Mid Range      │
 * │ 4          │ Monitor             │ 150   │ Premium        │
 * │ 5          │ USB Cable           │ 8     │ Budget         │
 * │ 6          │ Webcam              │ 60    │ Mid Range      │
 * │ 7          │ HDMI Cable          │ 20    │ Budget         │
 * │ 8          │ Mechanical Keyboard │ 120   │ Premium        │
 * │ 9          │ Sticker Pack        │ 0     │ Budget         │
 * │ 10         │ Gift Card           │ 19    │ Budget         │
 * │ 11         │ Mystery Box         │ NULL  │ Missing Price  │
 * │ 12         │ Refurb Monitor      │ 61    │ Mid Range      │
 * └────────────┴─────────────────────┴───────┴────────────────┘
 * 
 * NOTE: ELSE is optional. If no ELSE and no conditions match, result is NULL.
 */

-- ============================================================================
-- SOURCE TABLE: RULES
-- ============================================================================

CREATE TABLE rules (
    rule_id INT PRIMARY KEY,
    value INT
);

INSERT INTO rules (rule_id, value) VALUES
(1, 75),
(2, 40),
(3, 60),
(4, NULL),
(5, 95),
(6, 59),
(7, 0),
(8, 61);

-- Display rules
SELECT rule_id, value FROM rules ORDER BY rule_id;

/**
 * OUTPUT:
 * ┌─────────┬───────┐
 * │ rule_id │ value │
 * ├─────────┼───────┤
 * │ 1       │ 75    │
 * │ 2       │ 40    │
 * │ 3       │ 60    │
 * │ 4       │ NULL  │
 * │ 5       │ 95    │
 * │ 6       │ 59    │
 * │ 7       │ 0     │
 * │ 8       │ 61    │
 * └─────────┴───────┘
 */

-- ============================================================================
-- PART 3: BOOLEAN EVALUATION WITH CASE (PASS/FAIL logic)
-- ============================================================================

/**
 * BUSINESS RULES:
 * - If value is NULL → 'Missing'
 * - Else if value >= 40 → 'PASS'
 * - Else → 'FAIL'
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              BOOLEAN EVALUATION WITH CASE                               │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT rule_id, value,                                          │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN value IS NULL THEN 'Missing'                       │   │
 * │   │         WHEN value >= 40 THEN 'PASS'                            │   │
 * │   │         ELSE 'FAIL'                                             │   │
 * │   │     END AS verdict                                              │   │
 * │   │ FROM rules                                                      │   │
 * │   │ ORDER BY rule_id;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    rule_id,
    value,
    CASE
        WHEN value IS NULL THEN 'Missing'
        WHEN value >= 40 THEN 'PASS'
        ELSE 'FAIL'
    END AS verdict
FROM rules
ORDER BY rule_id;

/**
 * OUTPUT:
 * ┌─────────┬───────┬─────────┐
 * │ rule_id │ value │ verdict │
 * ├─────────┼───────┼─────────┤
 * │ 1       │ 75    │ PASS    │
 * │ 2       │ 40    │ PASS    │
 * │ 3       │ 60    │ PASS    │
 * │ 4       │ NULL  │ Missing │
 * │ 5       │ 95    │ PASS    │
 * │ 6       │ 59    │ PASS    │
 * │ 7       │ 0     │ FAIL    │
 * │ 8       │ 61    │ PASS    │
 * └─────────┴───────┴─────────┘
 */

-- ============================================================================
-- SOURCE TABLE: USERS
-- ============================================================================

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(60)
);

INSERT INTO users (user_id, username) VALUES
(1, 'Pro_User'),
(2, 'guest123'),
(3, 'PRO_member'),
(4, 'ProXUser'),
(5, 'pro_user99'),
(6, ' Pro_User '),
(7, ''),
(8, NULL);

-- Display users
SELECT user_id, username FROM users ORDER BY user_id;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ user_id │ username    │
 * ├─────────┼─────────────┤
 * │ 1       │ Pro_User    │
 * │ 2       │ guest123    │
 * │ 3       │ PRO_member  │
 * │ 4       │ ProXUser    │
 * │ 5       │ pro_user99  │
 * │ 6       │  Pro_User   │
 * │ 7       │             │
 * │ 8       │ NULL        │
 * └─────────┴─────────────┘
 */

-- ============================================================================
-- PART 4: HANDLING NULL AND EMPTY STRINGS (Data cleaning)
-- ============================================================================

/**
 * BUSINESS RULES:
 * - If username IS NULL → 'Not Filled'
 * - If username = '' (empty string) → 'Empty'
 * - Otherwise → actual username
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              HANDLING NULL AND EMPTY STRINGS                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT user_id, username,                                       │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN username IS NULL THEN 'Not Filled'                  │   │
 * │   │         WHEN username = '' THEN 'Empty'                          │   │
 * │   │         ELSE username                                            │   │
 * │   │     END AS username_display                                      │   │
 * │   │ FROM users                                                       │   │
 * │   │ ORDER BY user_id;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    user_id,
    username,
    CASE
        WHEN username IS NULL THEN 'Not Filled'
        WHEN username = '' THEN 'Empty'
        ELSE username
    END AS username_display
FROM users
ORDER BY user_id;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┬─────────────────┐
 * │ user_id │ username    │ username_display│
 * ├─────────┼─────────────┼─────────────────┤
 * │ 1       │ Pro_User    │ Pro_User        │
 * │ 2       │ guest123    │ guest123        │
 * │ 3       │ PRO_member  │ PRO_member      │
 * │ 4       │ ProXUser    │ ProXUser        │
 * │ 5       │ pro_user99  │ pro_user99      │
 * │ 6       │  Pro_User   │  Pro_User       │
 * │ 7       │             │ Empty           │
 * │ 8       │ NULL        │ Not Filled      │
 * └─────────┴─────────────┴─────────────────┘
 */

-- ============================================================================
-- SOURCE TABLE: EMPLOYEES
-- ============================================================================

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    salary INT NOT NULL,
    performance_score INT
);

INSERT INTO employees (emp_id, salary, performance_score) VALUES
(101, 50000, 90),
(102, 45000, NULL),
(103, 60000, 74),
(104, 70000, 75),
(105, 80000, 89),
(106, 0, 92),
(107, 52000, 100),
(108, 50000, 0),
(109, 45000, 85),
(110, 40000, NULL);

-- Display employees
SELECT emp_id, salary, performance_score FROM employees ORDER BY emp_id;

/**
 * OUTPUT:
 * ┌────────┬────────┬───────────────────┐
 * │ emp_id │ salary │ performance_score │
 * ├────────┼────────┼───────────────────┤
 * │ 101    │ 50000  │ 90                │
 * │ 102    │ 45000  │ NULL              │
 * │ 103    │ 60000  │ 74                │
 * │ 104    │ 70000  │ 75                │
 * │ 105    │ 80000  │ 89                │
 * │ 106    │ 0      │ 92                │
 * │ 107    │ 52000  │ 100               │
 * │ 108    │ 50000  │ 0                 │
 * │ 109    │ 45000  │ 85                │
 * │ 110    │ 40000  │ NULL              │
 * └────────┴────────┴───────────────────┘
 */

-- ============================================================================
-- PART 5: BONUS CALCULATION USING CASE and COALESCE
-- ============================================================================

/**
 * BUSINESS RULES:
 * - If performance_score is NULL → bonus = 0
 * - If score >= 90 → bonus = 20% of salary
 * - If score >= 75 → bonus = 10% of salary
 * - Else → bonus = 5% of salary
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              BONUS CALCULATION USING CASE and COALESCE                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT emp_id, salary, performance_score,                       │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN COALESCE(performance_score, -1) = -1 THEN 0        │   │
 * │   │         WHEN performance_score >= 90 THEN salary * 0.20         │   │
 * │   │         WHEN performance_score >= 75 THEN salary * 0.10         │   │
 * │   │         ELSE salary * 0.05                                      │   │
 * │   │     END AS bonus_amount                                         │   │
 * │   │ FROM employees                                                  │   │
 * │   │ ORDER BY emp_id;                                                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    emp_id,
    salary,
    performance_score,
    CASE
        WHEN COALESCE(performance_score, -1) = -1 THEN 0
        WHEN performance_score >= 90 THEN salary * 0.20
        WHEN performance_score >= 75 THEN salary * 0.10
        ELSE salary * 0.05
    END AS bonus_amount
FROM employees
ORDER BY emp_id;

/**
 * OUTPUT:
 * ┌────────┬────────┬───────────────────┬──────────────┐
 * │ emp_id │ salary │ performance_score │ bonus_amount │
 * ├────────┼────────┼───────────────────┼──────────────┤
 * │ 101    │ 50000  │ 90                │ 10000.00     │
 * │ 102    │ 45000  │ NULL              │ 0.00         │
 * │ 103    │ 60000  │ 74                │ 3000.00      │
 * │ 104    │ 70000  │ 75                │ 7000.00      │
 * │ 105    │ 80000  │ 89                │ 8000.00      │
 * │ 106    │ 0      │ 92                │ 0.00         │
 * │ 107    │ 52000  │ 100               │ 10400.00     │
 * │ 108    │ 50000  │ 0                 │ 2500.00      │
 * │ 109    │ 45000  │ 85                │ 4500.00      │
 * │ 110    │ 40000  │ NULL              │ 0.00         │
 * └────────┴────────┴───────────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - COALESCE(performance_score, -1) = -1 detects NULLs
 * - NULL scores get 0 bonus
 * - Score 0 gets 5% bonus (ELSE clause)
 */

-- ============================================================================
-- SOURCE TABLE: NODES (Hierarchical data)
-- ============================================================================

CREATE TABLE nodes (
    node_id INT PRIMARY KEY,
    parent_id INT
);

INSERT INTO nodes (node_id, parent_id) VALUES
(1, NULL),
(2, 1),
(3, 2),
(4, 1),
(5, 4),
(6, 4),
(7, 6),
(8, NULL),
(9, 8),
(10, 8),
(11, 10),
(12, 10);

-- Create index for better performance
CREATE INDEX idx_nodes_parent_id ON nodes(parent_id);

-- Display nodes
SELECT node_id, parent_id FROM nodes ORDER BY node_id;

/**
 * OUTPUT:
 * ┌─────────┬───────────┐
 * │ node_id │ parent_id │
 * ├─────────┼───────────┤
 * │ 1       │ NULL      │
 * │ 2       │ 1         │
 * │ 3       │ 2         │
 * │ 4       │ 1         │
 * │ 5       │ 4         │
 * │ 6       │ 4         │
 * │ 7       │ 6         │
 * │ 8       │ NULL      │
 * │ 9       │ 8         │
 * │ 10      │ 8         │
 * │ 11      │ 10        │
 * │ 12      │ 10        │
 * └─────────┴───────────┘
 */

-- ============================================================================
-- PART 6: NODE CLASSIFICATION (Hierarchical data)
-- ============================================================================

/**
 * TREE STRUCTURE RULES:
 * - ROOT: node with no parent (parent_id IS NULL)
 * - INTERNAL: node that has at least one child
 * - LEAF: node that has no children
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              NODE CLASSIFICATION                                        │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT node_id, parent_id,                                      │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN parent_id IS NULL THEN 'ROOT'                      │   │
 * │   │         WHEN NOT EXISTS (                                       │   │
 * │   │             SELECT 1 FROM nodes n2                              │   │
 * │   │             WHERE n2.parent_id = n1.node_id                     │   │
 * │   │         ) THEN 'LEAF'                                           │   │
 * │   │         ELSE 'INTERNAL'                                         │   │
 * │   │     END AS node_type                                            │   │
 * │   │ FROM nodes n1                                                   │   │
 * │   │ ORDER BY node_id;                                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    node_id,
    parent_id,
    CASE
        WHEN parent_id IS NULL THEN 'ROOT'
        WHEN NOT EXISTS (
            SELECT 1
            FROM nodes n2
            WHERE n2.parent_id = n1.node_id
        ) THEN 'LEAF'
        ELSE 'INTERNAL'
    END AS node_type
FROM nodes n1
ORDER BY node_id;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬──────────┐
 * │ node_id │ parent_id │ node_type│
 * ├─────────┼───────────┼──────────┤
 * │ 1       │ NULL      │ ROOT     │
 * │ 2       │ 1         │ INTERNAL │
 * │ 3       │ 2         │ LEAF     │
 * │ 4       │ 1         │ INTERNAL │
 * │ 5       │ 4         │ LEAF     │
 * │ 6       │ 4         │ INTERNAL │
 * │ 7       │ 6         │ LEAF     │
 * │ 8       │ NULL      │ ROOT     │
 * │ 9       │ 8         │ LEAF     │
 * │ 10      │ 8         │ INTERNAL │
 * │ 11      │ 10        │ LEAF     │
 * │ 12      │ 10        │ LEAF     │
 * └─────────┴───────────┴──────────┘
 * 
 * EXPLANATION:
 * - Nodes 1 and 8: no parent → ROOT
 * - Nodes 2,4,6,10: have children → INTERNAL
 * - Other nodes: no children → LEAF
 */

-- ============================================================================
-- SOURCE TABLE: SALES (For conditional aggregation)
-- ============================================================================

CREATE TABLE sales (
    item VARCHAR(30) NOT NULL,
    quantity INT
);

INSERT INTO sales (item, quantity) VALUES
('apple', 10),
('orange', 7),
('apple', 5),
('banana', 3),
('mango', 2),
('apple', NULL),
('orange', NULL);

-- Display sales
SELECT item, quantity FROM sales ORDER BY item;

/**
 * OUTPUT:
 * ┌────────┬──────────┐
 * │ item   │ quantity │
 * ├────────┼──────────┤
 * │ apple  │ 10       │
 * │ apple  │ 5        │
 * │ apple  │ NULL     │
 * │ banana │ 3        │
 * │ mango  │ 2        │
 * │ orange │ 7        │
 * │ orange │ NULL     │
 * └────────┴──────────┘
 */

-- ============================================================================
-- PART 7: CONDITIONAL AGGREGATION (CASE inside SUM/COUNT)
-- ============================================================================

/**
 * Use CASE inside aggregate functions to count/sum conditionally.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CONDITIONAL AGGREGATION                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Total apples sold vs oranges sold                             │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT                                                          │   │
 * │   │     SUM(CASE WHEN item = 'apple'                                │   │
 * │   │         THEN COALESCE(quantity, 0) ELSE 0 END) AS apples_sold,  │   │
 * │   │     SUM(CASE WHEN item = 'orange'                               │   │
 * │   │         THEN COALESCE(quantity, 0) ELSE 0 END) AS oranges_sold  │   │
 * │   │ FROM sales;                                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    SUM(CASE WHEN item = 'apple' THEN COALESCE(quantity, 0) ELSE 0 END) AS apples_sold,
    SUM(CASE WHEN item = 'orange' THEN COALESCE(quantity, 0) ELSE 0 END) AS oranges_sold
FROM sales;

/**
 * OUTPUT:
 * ┌─────────────┬───────────────┐
 * │ apples_sold │ oranges_sold  │
 * ├─────────────┼───────────────┤
 * │ 15          │ 7             │
 * └─────────────┴───────────────┘
 * 
 * EXPLANATION:
 * - apples: 10 + 5 + 0 = 15 (NULL treated as 0)
 * - oranges: 7 + 0 = 7 (NULL treated as 0)
 */

-- ============================================================================
-- PART 8: NULL COMPARISONS (Important! NULL = NULL is FALSE)
-- ============================================================================

/**
 * ⚠️  CRITICAL: In SQL, NULL = NULL is NOT TRUE!
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              NULL COMPARISONS                                           │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   Comparison                    Result      Explanation                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ NULL = NULL                   → NULL    (UNKNOWN, not TRUE)     │   │
 * │   │ NULL = 5                      → NULL    (UNKNOWN)               │   │
 * │   │ NULL >= 60                    → NULL    (UNKNOWN)               │   │
 * │   │ NULL IS NULL                  → TRUE    (Correct way!)          │   │
 * │   │ NULL IS NOT NULL              → FALSE   (Correct way!)          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT
    (NULL = NULL) AS eq_null_null,
    (NULL = 5) AS eq_null_5,
    (NULL >= 60) AS ge_null_60,
    (NULL IS NULL) AS is_null,
    (NULL IS NOT NULL) AS is_not_null;

/**
 * OUTPUT:
 * ┌───────────────┬───────────┬────────────┬─────────┬──────────────┐
 * │ eq_null_null  │ eq_null_5 │ ge_null_60 │ is_null │ is_not_null  │
 * ├───────────────┼───────────┼────────────┼─────────┼──────────────┤
 * │ NULL          │ NULL      │ NULL       │ true    │ false        │
 * └───────────────┴───────────┴────────────┴─────────┴──────────────┘
 * 
 * EXPLANATION:
 * - NULL = NULL returns NULL (not TRUE!)
 * - Always use IS NULL to check for NULL values
 */

-- ============================================================================
-- PART 9: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Forgetting END                                             │
 * │                                                                          │
 * │   ❌ CASE WHEN condition THEN value                                     │
 * │   ✅ CASE WHEN condition THEN value END                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Missing END (syntax error)
-- SELECT CASE WHEN 1=1 THEN 'Yes';

-- ✅ Correct
SELECT CASE WHEN 1=1 THEN 'Yes' END AS result;

/**
 * ┌────────┐
 * │ result │
 * ├────────┤
 * │ Yes    │
 * └────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #2: No ELSE when needed (returns NULL)                         │
 * │                                                                          │
 * │   ❌ CASE WHEN price <= 20 THEN 'Budget'                                │
 * │        WHEN price <= 100 THEN 'Mid Range'                               │
 * │      → price > 100 returns NULL                                        │
 * │                                                                          │
 * │   ✅ Add ELSE clause                                                    │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Without ELSE (price 150 returns NULL)
SELECT 
    price,
    CASE 
        WHEN price <= 20 THEN 'Budget'
        WHEN price <= 100 THEN 'Mid Range'
    END AS category
FROM (VALUES (150)) AS t(price);

/**
 * OUTPUT:
 * ┌───────┬──────────┐
 * │ price │ category │
 * ├───────┼──────────┤
 * │ 150   │ NULL     │
 * └───────┴──────────┘
 */

-- With ELSE
SELECT 
    price,
    CASE 
        WHEN price <= 20 THEN 'Budget'
        WHEN price <= 100 THEN 'Mid Range'
        ELSE 'Premium'
    END AS category
FROM (VALUES (150)) AS t(price);

/**
 * OUTPUT:
 * ┌───────┬──────────┐
 * │ price │ category │
 * ├───────┼──────────┤
 * │ 150   │ Premium  │
 * └───────┴──────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Order of conditions matters!                               │
 * │                                                                          │
 * │   ❌ CASE                                                               │
 * │        WHEN price <= 100 THEN 'Mid Range'                              │
 * │        WHEN price <= 20 THEN 'Budget'    ← Never reaches!              │
 * │      END                                                               │
 * │                                                                          │
 * │   ✅ Put more specific conditions FIRST                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong order (Budget never happens)
SELECT 
    price,
    CASE 
        WHEN price <= 100 THEN 'Mid Range'
        WHEN price <= 20 THEN 'Budget'
        ELSE 'Premium'
    END AS category
FROM (VALUES (18)) AS t(price);

/**
 * OUTPUT:
 * ┌───────┬───────────┐
 * │ price │ category  │
 * ├───────┼───────────┤
 * │ 18    │ Mid Range │  ← Should be Budget!
 * └───────┴───────────┘
 */

-- ✅ Correct order (Budget first, then Mid Range)
SELECT 
    price,
    CASE 
        WHEN price <= 20 THEN 'Budget'
        WHEN price <= 100 THEN 'Mid Range'
        ELSE 'Premium'
    END AS category
FROM (VALUES (18)) AS t(price);

/**
 * OUTPUT:
 * ┌───────┬──────────┐
 * │ price │ category │
 * ├───────┼──────────┤
 * │ 18    │ Budget   │  ✓ Correct
 * └───────┴──────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Comparing with NULL using =                                │
 * │                                                                          │
 * │   ❌ WHERE price = NULL    ← Never TRUE!                               │
 * │   ✅ WHERE price IS NULL    ← Correct                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 10: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: CASE checks conditions TOP to BOTTOM                           │
 * │         → First match wins                                             │
 * │         → Put most SPECIFIC conditions FIRST                           │
 * │                                                                          │
 * │ RULE 2: Always include ELSE unless you WANT NULL                       │
 * │         → Without ELSE, unmatched conditions return NULL               │
 * │                                                                          │
 * │ RULE 3: CASE must end with END                                         │
 * │         → Every CASE needs END                                         │
 * │                                                                          │
 * │ RULE 4: Use searched CASE (WHEN condition) for ranges                  │
 * │         → WHEN price > 100 THEN 'Premium'                              │
 * │                                                                          │
 * │ RULE 5: Use simple CASE (CASE column) for equality only                │
 * │         → CASE status WHEN 'P' THEN 'Pending'                          │
 * │                                                                          │
 * │ RULE 6: Use COALESCE inside CASE to handle NULLs                       │
 * │         → WHEN COALESCE(score, -1) = -1 THEN 'Missing'                 │
 * │                                                                          │
 * │ RULE 7: CASE can be nested inside aggregates                           │
 * │         → SUM(CASE WHEN condition THEN value ELSE 0 END)               │
 * │                                                                          │
 * │ RULE 8: NULL = NULL is FALSE (use IS NULL)                             │
 * │         → Always use IS NULL to check for NULL                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 11: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ SEARCHED CASE (for ranges/thresholds):                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE                                                               ││
 * │ │     WHEN score >= 90 THEN 'A'                                      ││
 * │ │     WHEN score >= 80 THEN 'B'                                      ││
 * │ │     WHEN score >= 70 THEN 'C'                                      ││
 * │ │     ELSE 'F'                                                       ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ SIMPLE CASE (for equality mapping):                                     │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE status                                                        ││
 * │ │     WHEN 'P' THEN 'Pending'                                        ││
 * │ │     WHEN 'D' THEN 'Delivered'                                      ││
 * │ │     WHEN 'C' THEN 'Cancelled'                                      ││
 * │ │     ELSE 'Unknown'                                                 ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ HANDLING NULL in CASE:                                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE                                                               ││
 * │ │     WHEN price IS NULL THEN 'Missing'                              ││
 * │ │     WHEN price <= 20 THEN 'Budget'                                 ││
 * │ │     ELSE 'Other'                                                   ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ CONDITIONAL AGGREGATION:                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ SUM(CASE WHEN item = 'apple' THEN quantity ELSE 0 END)             ││
 * │ │ COUNT(CASE WHEN status = 'ACTIVE' THEN 1 END)                      ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ COMPLETE PATTERN with COALESCE:                                         │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE                                                               ││
 * │ │     WHEN COALESCE(score, -1) = -1 THEN 'Missing'                   ││
 * │ │     WHEN score >= 90 THEN 'Excellent'                              ││
 * │ │     WHEN score >= 75 THEN 'Good'                                   ││
 * │ │     ELSE 'Needs Improvement'                                       ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 12: PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Classify products with price > 100 as 'Expensive', 
 *            price between 50-100 as 'Moderate', else 'Cheap'
 * 
 * Answer:
 *   SELECT name, price,
 *       CASE 
 *           WHEN price > 100 THEN 'Expensive'
 *           WHEN price >= 50 THEN 'Moderate'
 *           ELSE 'Cheap'
 *       END AS price_tier
 *   FROM products;
 */

/**
 * EXERCISE 2: Create grade from score (A: >=90, B: >=80, C: >=70, D: >=60, F: <60)
 * 
 * Answer:
 *   SELECT score,
 *       CASE 
 *           WHEN score >= 90 THEN 'A'
 *           WHEN score >= 80 THEN 'B'
 *           WHEN score >= 70 THEN 'C'
 *           WHEN score >= 60 THEN 'D'
 *           ELSE 'F'
 *       END AS grade
 *   FROM scores;
 */

/**
 * EXERCISE 3: Count number of active and inactive users
 * 
 * Answer:
 *   SELECT 
 *       COUNT(CASE WHEN status = 'ACTIVE' THEN 1 END) AS active_count,
 *       COUNT(CASE WHEN status = 'INACTIVE' THEN 1 END) AS inactive_count
 *   FROM users;
 */

/**
 * EXERCISE 4: Map status codes to full text
 * 
 * Answer:
 *   SELECT 
 *       CASE status_code
 *           WHEN 'P' THEN 'Pending'
 *           WHEN 'A' THEN 'Approved'
 *           WHEN 'R' THEN 'Rejected'
 *           ELSE 'Unknown'
 *       END AS status_text
 *   FROM orders;
 */

/**
 * EXERCISE 5: Calculate total sales for Electronics vs Accessories
 * 
 * Answer:
 *   SELECT 
 *       SUM(CASE WHEN category = 'Electronics' THEN amount ELSE 0 END) AS electronics_sales,
 *       SUM(CASE WHEN category = 'Accessories' THEN amount ELSE 0 END) AS accessories_sales
 *   FROM sales;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS nodes;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS rules;
DROP TABLE IF EXISTS products;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. CASE is SQL's IF/ELSE logic                                         │
 * │    → Checks conditions top to bottom                                    │
 * │    → Returns first matching result                                      │
 * │                                                                          │
 * │ 2. Searched CASE (WHEN condition) for ranges/thresholds                │
 * │    → Most common and flexible                                          │
 * │                                                                          │
 * │ 3. Simple CASE (CASE column) for equality mapping                      │
 * │    → Cleaner when just checking equality                                │
 * │                                                                          │
 * │ 4. Always handle NULLs explicitly                                      │
 * │    → Use IS NULL in CASE                                               │
 * │    → Use COALESCE for safe calculations                                 │
 * │                                                                          │
 * │ 5. Put most SPECIFIC conditions FIRST                                  │
 * │    → Order matters!                                                    │
 * │                                                                          │
 * │ 6. Always include ELSE unless you want NULL                            │
 * │                                                                          │
 * │ 7. CASE can be used in:                                                │
 * │    → SELECT (categorization)                                           │
 * │    → WHERE (filtering)                                                 │
 * │    → ORDER BY (custom sorting)                                         │
 * │    → Aggregates (conditional counting/summing)                         │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - NULL = NULL is FALSE                                               │
 * │   - Order of conditions matters                                        │
 * │   - Always END the CASE                                                │
 * │   - ELSE prevents NULL results                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF CASE EXPRESSIONS REVISION GUIDE
-- ============================================================================