/**
 * ============================================================================
 * CASE EXPRESSIONS - COMPLETE REVISION GUIDE
 * (Boolean Evaluation, Conditional Logic, Branching, Aggregation)
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
 * 4. BONUS CALCULATION USING CASE and COALESCE ---- (Safe fallback values)
 * 
 * 5. NODE CLASSIFICATION -------------------------- (Hierarchical data)
 * 
 * 6. CONDITIONAL AGGREGATION ---------------------- (CASE inside SUM/COUNT)
 *    - 6.1 Comparing Apple vs Orange sales
 *    - 6.2 Counting PASS/FAIL scores
 *    - 6.3 Percentage of NULLs in a column
 *    - 6.4 Multi-condition totaling
 *    - 6.5 Pivoting experience levels
 * 
 * 7. GROUPING BY PERFORMANCE TIERS ---------------- (Categorizing employees)
 * 
 * 8. CUSTOM ACTIVITY FLAGS ------------------------ (Marketing flags)
 * 
 * 9. NULL COMPARISONS ----------------------------- (Important! NULL = NULL is FALSE)
 * 
 * 10. COMMON MISTAKES ----------------------------- (What to avoid)
 * 
 * 11. GOLDEN RULES -------------------------------- (Key principles)
 * 
 * 12. QUICK REFERENCE CARD ------------------------ (Cheat sheet)
 * 
 * 13. PRACTICE EXERCISES -------------------------- (Test yourself)
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
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- 1.1 Basic syntax example (Age Verification)
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CASE - Age Verification                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT                                                          │   │
 * │   │     CASE                                                         │   │
 * │   │         WHEN 19 >= 18 THEN 'Adult'                              │   │
 * │   │         ELSE 'Not an Adult'                                     │   │
 * │   │     END AS age_status;                                           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌────────────┐                                                      │
 * │   │ age_status │                                                      │
 * │   ├────────────┤                                                      │
 * │   │ Adult      │                                                      │
 * │   └────────────┘                                                      │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

SELECT 
    CASE 
        WHEN 19 >= 18 THEN 'Adult'
        ELSE 'Not an Adult'
    END AS age_status;

/**
 * OUTPUT:
 * ┌────────────┐
 * │ age_status │
 * ├────────────┤
 * │ Adult      │
 * └────────────┘
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
    price NUMERIC(10,2)
);

INSERT INTO products (product_id, name, price) VALUES
(1, 'Laptop Sleeve', 18.00),
(2, 'Wireless Mouse', 32.00),
(3, 'Keyboard', 55.00),
(4, 'Monitor', 150.00),
(5, 'USB Cable', 8.00),
(8, 'Mechanical Keyboard', 120.00),
(11, 'Mystery Box', NULL);

-- Display products
SELECT product_id, name, price FROM products ORDER BY product_id;

/**
 * OUTPUT:
 * ┌────────────┬─────────────────────┬───────┐
 * │ product_id │ name                │ price │
 * ├────────────┼─────────────────────┼───────┤
 * │ 1          │ Laptop Sleeve       │ 18.00 │
 * │ 2          │ Wireless Mouse      │ 32.00 │
 * │ 3          │ Keyboard            │ 55.00 │
 * │ 4          │ Monitor             │ 150.00│
 * │ 5          │ USB Cable           │ 8.00  │
 * │ 8          │ Mechanical Keyboard │ 120.00│
 * │ 11         │ Mystery Box         │ NULL  │
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
 * │ 1          │ Laptop Sleeve       │ 18.00 │ Budget         │
 * │ 2          │ Wireless Mouse      │ 32.00 │ Mid Range      │
 * │ 3          │ Keyboard            │ 55.00 │ Mid Range      │
 * │ 4          │ Monitor             │ 150.00│ Premium        │
 * │ 5          │ USB Cable           │ 8.00  │ Budget         │
 * │ 8          │ Mechanical Keyboard │ 120.00│ Premium        │
 * │ 11         │ Mystery Box         │ NULL  │ Missing Price  │
 * └────────────┴─────────────────────┴───────┴────────────────┘
 * 
 * KEY INSIGHTS:
 * 1. SQL checks conditions TOP to BOTTOM
 * 2. First matching condition wins
 * 3. Always use IS NULL to check for NULL (not = NULL)
 * 4. END keyword is mandatory
 * 5. Use AS to give the column a readable name
 */

-- ============================================================================
-- SOURCE TABLE: RULES (For Boolean evaluation)
-- ============================================================================

CREATE TABLE rules (
    rule_id INT PRIMARY KEY,
    value INT
);

INSERT INTO rules (rule_id, value) VALUES
(1, 75),
(2, 40),
(4, NULL),
(7, 0);

-- Display rules
SELECT rule_id, value FROM rules ORDER BY rule_id;

/**
 * OUTPUT:
 * ┌─────────┬───────┐
 * │ rule_id │ value │
 * ├─────────┼───────┤
 * │ 1       │ 75    │
 * │ 2       │ 40    │
 * │ 4       │ NULL  │
 * │ 7       │ 0     │
 * └─────────┴───────┘
 */

-- ============================================================================
-- PART 3: BOOLEAN EVALUATION WITH CASE (PASS/FAIL logic)
-- ============================================================================

/**
 * BUSINESS RULES:
 * - If value is NULL → 'Missing'
 * - If value >= 40 → 'PASS'
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
 * │ 4       │ NULL  │ Missing │
 * │ 7       │ 0     │ FAIL    │
 * └─────────┴───────┴─────────┘
 */

-- ============================================================================
-- SOURCE TABLE: EMPLOYEES (For bonus calculation)
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
(108, 50000, 0);

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
 * │ 108    │ 50000  │ 0                 │
 * └────────┴────────┴───────────────────┘
 */

-- ============================================================================
-- PART 4: BONUS CALCULATION USING CASE and COALESCE
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
 * │ 108    │ 50000  │ 0                 │ 2500.00      │
 * └────────┴────────┴───────────────────┴──────────────┘
 * 
 * EXPLANATION:
 * - COALESCE(performance_score, -1) = -1 detects NULLs
 * - NULL scores → 0 bonus
 * - Score 90 → 20% of 50000 = 10000
 * - Score 74 → 5% of 60000 = 3000 (ELSE clause)
 * - Score 0 → 5% of 50000 = 2500 (ELSE clause)
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
(4, 1);

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
 * └─────────┴───────────┘
 */

-- ============================================================================
-- PART 5: NODE CLASSIFICATION (Hierarchical data)
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
 * │   │         WHEN EXISTS (                                           │   │
 * │   │             SELECT 1 FROM nodes c                               │   │
 * │   │             WHERE c.parent_id = n.node_id                       │   │
 * │   │         ) THEN 'INTERNAL'                                       │   │
 * │   │         ELSE 'LEAF'                                             │   │
 * │   │     END AS node_type                                            │   │
 * │   │ FROM nodes n                                                    │   │
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
        WHEN EXISTS (
            SELECT 1
            FROM nodes c
            WHERE c.parent_id = n.node_id
        ) THEN 'INTERNAL'
        ELSE 'LEAF'
    END AS node_type
FROM nodes n
ORDER BY node_id;

/**
 * OUTPUT:
 * ┌─────────┬───────────┬──────────┐
 * │ node_id │ parent_id │ node_type│
 * ├─────────┼───────────┼──────────┤
 * │ 1       │ NULL      │ ROOT     │
 * │ 2       │ 1         │ INTERNAL │
 * │ 3       │ 2         │ LEAF     │
 * │ 4       │ 1         │ LEAF     │
 * └─────────┴───────────┴──────────┘
 * 
 * EXPLANATION:
 * - Node 1: no parent → ROOT
 * - Node 2: has child (node 3) → INTERNAL
 * - Node 3: no children → LEAF
 * - Node 4: no children → LEAF
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
('apple', NULL);

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
 * │ orange │ 7        │
 * └────────┴──────────┘
 */

-- ============================================================================
-- PART 6: CONDITIONAL AGGREGATION (CASE inside SUM/COUNT)
-- ============================================================================

/**
 * Conditional Aggregation = Putting CASE inside SUM or COUNT
 * Allows pivoting data into a single row report
 */

-- ============================================================================
-- 6.1 Comparing Apple vs Orange sales totals
-- ============================================================================

/**
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │              CONDITIONAL AGGREGATION - Apple vs Orange                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT                                                          │   │
 * │   │     SUM(CASE WHEN item = 'apple'                                │   │
 * │   │         THEN COALESCE(quantity, 0) ELSE 0 END) AS apples_sold,  │   │
 * │   │     SUM(CASE WHEN item = 'orange'                               │   │
 * │   │         THEN COALESCE(quantity, 0) ELSE 0 END) AS oranges_sold  │   │
 * │   │ FROM sales;                                                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────────┬───────────────┐                                     │
 * │   │ apples_sold │ oranges_sold  │                                     │
 * │   ├─────────────┼───────────────┤                                     │
 * │   │ 15          │ 7             │                                     │
 * │   └─────────────┴───────────────┘                                     │
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
 * - oranges: 7 = 7
 * - ELSE 0 prevents NULL results
 */

-- ============================================================================
-- 6.2 Counting PASS/FAIL scores (using rules table)
-- ============================================================================

/**
 * Count how many scores were PASS (>=40) and FAIL (<40)
 */

SELECT 
    COUNT(CASE WHEN value >= 40 THEN 1 END) AS pass_count,
    COUNT(CASE WHEN value < 40 THEN 1 END) AS fail_count
FROM rules;

/**
 * OUTPUT:
 * ┌────────────┬────────────┐
 * │ pass_count │ fail_count │
 * ├────────────┼────────────┤
 * │ 2          │ 1          │
 * └────────────┴────────────┘
 * 
 * EXPLANATION:
 * - PASS: 75 and 40 = 2
 * - FAIL: 0 = 1
 * - NULL values are ignored (not counted as PASS or FAIL)
 */

-- ============================================================================
-- 6.3 Percentage of NULLs in a column
-- ============================================================================

SELECT 
    (SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS null_percentage
FROM sales;

/**
 * OUTPUT:
 * ┌─────────────────┐
 * │ null_percentage │
 * ├─────────────────┤
 * │ 20.0            │
 * └─────────────────┘
 * 
 * EXPLANATION:
 * - 1 NULL out of 5 rows = 20%
 */

-- ============================================================================
-- 6.4 Multi-condition totaling (Paid registrations from Instagram)
-- ============================================================================

-- First, create registrations table for this example
CREATE TABLE registrations (
    reg_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(100),
    ticket_type VARCHAR(20),
    referrer VARCHAR(30)
);

INSERT INTO registrations VALUES
(1, 'Aisha', 'aisha@example.com', 'Paid', 'Instagram'),
(2, 'Mohit', NULL, 'Free', 'LinkedIn'),
(3, 'Rohan', 'rohan@example.com', 'Paid', 'Instagram'),
(4, 'Neha', 'neha@example.com', 'Free', 'Twitter'),
(5, 'Priya', 'priya@example.com', 'Paid', 'Google');

SELECT 
    SUM(CASE WHEN ticket_type = 'Paid' AND referrer = 'Instagram' THEN 1 ELSE 0 END) AS insta_paid_total
FROM registrations;

/**
 * OUTPUT:
 * ┌──────────────────┐
 * │ insta_paid_total │
 * ├──────────────────┤
 * │ 2                │
 * └──────────────────┘
 * 
 * EXPLANATION: Aisha and Rohan = 2 paid Instagram registrations
 */

-- ============================================================================
-- 6.5 Pivoting experience levels (Junior vs Senior)
-- ============================================================================

-- First, create employees_with_exp table
CREATE TABLE employees_with_exp (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    years_experience INT
);

INSERT INTO employees_with_exp VALUES
(1, 'Alice', 2),
(2, 'Bob', 1),
(3, 'Carol', 5),
(4, 'Dave', 3),
(5, 'Eve', 8),
(6, 'Frank', 0),
(7, 'Grace', 4),
(8, 'Henry', 6),
(9, 'Ivy', 1);

SELECT 
    COUNT(CASE WHEN years_experience <= 3 THEN 1 END) AS juniors,
    COUNT(CASE WHEN years_experience > 3 THEN 1 END) AS seniors
FROM employees_with_exp;

/**
 * OUTPUT:
 * ┌─────────┬─────────┐
 * │ juniors │ seniors │
 * ├─────────┼─────────┤
 * │ 5       │ 4       │
 * └─────────┴─────────┘
 * 
 * EXPLANATION:
 * - Juniors (≤3 years): Alice(2), Bob(1), Dave(3), Frank(0), Ivy(1) = 5
 * - Seniors (>3 years): Carol(5), Eve(8), Grace(4), Henry(6) = 4
 */

-- ============================================================================
-- PART 7: GROUPING BY PERFORMANCE TIERS (Categorizing employees)
-- ============================================================================

/**
 * Group employees into "High Performers", "Average", "Needs Improvement"
 */

-- Create employees_with_names table
CREATE TABLE employees_with_names (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    performance_score INT
);

INSERT INTO employees_with_names VALUES
(1, 'Alice', 90),
(2, 'Bob', 85),
(3, 'Carol', 74),
(4, 'Dave', 60),
(5, 'Eve', 45),
(6, 'Frank', 30);

SELECT 
    name, 
    performance_score,
    CASE 
        WHEN performance_score >= 90 THEN 'High Performer'
        WHEN performance_score >= 70 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance_tier
FROM employees_with_names
WHERE performance_score IS NOT NULL;

/**
 * OUTPUT:
 * ┌─────────┬───────────────────┬─────────────────────┐
 * │ name    │ performance_score │ performance_tier    │
 * ├─────────┼───────────────────┼─────────────────────┤
 * │ Alice   │ 90                │ High Performer      │
 * │ Bob     │ 85                │ Average             │
 * │ Carol   │ 74                │ Average             │
 * │ Dave    │ 60                │ Needs Improvement   │
 * │ Eve     │ 45                │ Needs Improvement   │
 * │ Frank   │ 30                │ Needs Improvement   │
 * └─────────┴───────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 8: CUSTOM ACTIVITY FLAGS (Marketing flags)
-- ============================================================================

/**
 * Create "Contact Status" for users based on email presence
 */

-- Create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO users VALUES
(1, 'Aisha', 'aisha@example.com'),
(2, 'Mohit', NULL),
(3, 'Rohan', 'rohan@example.com'),
(4, 'Neha', NULL);

SELECT 
    full_name, 
    email,
    CASE 
        WHEN email IS NOT NULL THEN 'Verified'
        ELSE 'Unverified'
    END AS registration_status
FROM users;

/**
 * OUTPUT:
 * ┌───────────┬─────────────────────┬─────────────────────┐
 * │ full_name │ email               │ registration_status │
 * ├───────────┼─────────────────────┼─────────────────────┤
 * │ Aisha     │ aisha@example.com   │ Verified            │
 * │ Mohit     │ NULL                │ Unverified          │
 * │ Rohan     │ rohan@example.com   │ Verified            │
 * │ Neha      │ NULL                │ Unverified          │
 * └───────────┴─────────────────────┴─────────────────────┘
 */

-- ============================================================================
-- PART 9: NULL COMPARISONS (Important! NULL = NULL is FALSE)
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
 * - This is why CASE uses WHEN value IS NULL, not WHEN value = NULL
 */

-- ============================================================================
-- PART 10: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Wrong condition order (specific rules at bottom)           │
 * │                                                                          │
 * │   ❌ CASE                                                               │
 * │        WHEN price <= 100 THEN 'Mid Range'                              │
 * │        WHEN price <= 20 THEN 'Budget'    ← Never reaches!              │
 * │      END                                                               │
 * │                                                                          │
 * │   ✅ Put more SPECIFIC conditions FIRST                                │
 * │      CASE                                                              │
 * │        WHEN price <= 20 THEN 'Budget'                                  │
 * │        WHEN price <= 100 THEN 'Mid Range'                              │
 * │      END                                                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ❌ Wrong order (Budget never happens)
SELECT 
    18 AS price,
    CASE 
        WHEN price <= 100 THEN 'Mid Range'
        WHEN price <= 20 THEN 'Budget'
    END AS category;

/**
 * OUTPUT:
 * ┌───────┬───────────┐
 * │ price │ category  │
 * ├───────┼───────────┤
 * │ 18    │ Mid Range │  ← Should be Budget!
 * └───────┴───────────┘
 */

-- ✅ Correct order
SELECT 
    18 AS price,
    CASE 
        WHEN price <= 20 THEN 'Budget'
        WHEN price <= 100 THEN 'Mid Range'
    END AS category;

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
 * │ MISTAKE #2: Missing ELSE (returns NULL when no match)                  │
 * │                                                                          │
 * │   ❌ CASE WHEN price <= 20 THEN 'Budget' END                            │
 * │      → price 150 returns NULL                                          │
 * │                                                                          │
 * │   ✅ CASE WHEN price <= 20 THEN 'Budget' ELSE 'Other' END               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #3: Forgetting END                                             │
 * │                                                                          │
 * │   ❌ CASE WHEN condition THEN value                                     │
 * │   ✅ CASE WHEN condition THEN value END                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #4: Using = NULL instead of IS NULL                            │
 * │                                                                          │
 * │   ❌ WHEN price = NULL THEN 'Missing'   ← Never triggers!               │
 * │   ✅ WHEN price IS NULL THEN 'Missing'                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ MISTAKE #5: Forgetting ELSE 0 in conditional SUM                       │
 * │                                                                          │
 * │   ❌ SUM(CASE WHEN item = 'apple' THEN quantity END)                    │
 * │      → Returns NULL if no apples (not 0)                               │
 * │                                                                          │
 * │   ✅ SUM(CASE WHEN item = 'apple' THEN quantity ELSE 0 END)             │
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
 * │ RULE 9: In conditional SUM, always include ELSE 0                      │
 * │         → Prevents NULL results                                        │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PART 12: QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ SEARCHED CASE (for ranges/thresholds):                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE                                                               ││
 * │ │     WHEN price IS NULL THEN 'Missing'                              ││
 * │ │     WHEN price <= 20 THEN 'Budget'                                 ││
 * │ │     WHEN price <= 100 THEN 'Mid Range'                             ││
 * │ │     ELSE 'Premium'                                                 ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ SIMPLE CASE (for equality mapping):                                     │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE status_code                                                   ││
 * │ │     WHEN 'P' THEN 'Pending'                                        ││
 * │ │     WHEN 'D' THEN 'Delivered'                                      ││
 * │ │     WHEN 'C' THEN 'Cancelled'                                      ││
 * │ │     ELSE 'Unknown'                                                 ││
 * │ │ END                                                                ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ CONDITIONAL AGGREGATION:                                                │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ SUM(CASE WHEN item = 'apple' THEN quantity ELSE 0 END)             ││
 * │ │ COUNT(CASE WHEN score >= 40 THEN 1 END) AS pass_count              ││
 * │ │ AVG(CASE WHEN status = 'ACTIVE' THEN salary END)                   ││
 * │ └─────────────────────────────────────────────────────────────────────┘│
 * │                                                                          │
 * │ HANDLING NULL in CASE:                                                  │
 * │ ┌─────────────────────────────────────────────────────────────────────┐│
 * │ │ CASE                                                               ││
 * │ │     WHEN score IS NULL THEN 'Missing'                              ││
 * │ │     WHEN score >= 90 THEN 'A'                                      ││
 * │ │     WHEN score >= 80 THEN 'B'                                      ││
 * │ │     ELSE 'C'                                                       ││
 * │ │ END                                                                ││
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
-- PART 13: PRACTICE EXERCISES
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
 * EXERCISE 4: Calculate total sales for Electronics vs Accessories
 * 
 * Answer:
 *   SELECT 
 *       SUM(CASE WHEN category = 'Electronics' THEN amount ELSE 0 END) AS electronics_sales,
 *       SUM(CASE WHEN category = 'Accessories' THEN amount ELSE 0 END) AS accessories_sales
 *   FROM sales;
 */

/**
 * EXERCISE 5: Create performance tier (High: >=90, Medium: >=70, Low: <70)
 * 
 * Answer:
 *   SELECT name, performance_score,
 *       CASE 
 *           WHEN performance_score >= 90 THEN 'High'
 *           WHEN performance_score >= 70 THEN 'Medium'
 *           ELSE 'Low'
 *       END AS performance_tier
 *   FROM employees;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS employees_with_exp;
DROP TABLE IF EXISTS employees_with_names;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS nodes;
DROP TABLE IF EXISTS employees;
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
 * │ 4. Boolean Evaluation: CASE can return PASS/FAIL based on thresholds   │
 * │                                                                          │
 * │ 5. Always handle NULLs explicitly                                      │
 * │    → Use IS NULL in CASE                                               │
 * │    → Use COALESCE for safe calculations                                 │
 * │                                                                          │
 * │ 6. Put most SPECIFIC conditions FIRST                                  │
 * │    → Order matters! Budget before Mid Range                            │
 * │                                                                          │
 * │ 7. Always include ELSE unless you want NULL                            │
 * │                                                                          │
 * │ 8. Conditional Aggregation: CASE inside SUM/COUNT                      │
 * │    → Pivot data into single row reports                                │
 * │    → Always include ELSE 0 in SUM                                      │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - NULL = NULL is FALSE (use IS NULL)                                 │
 * │   - Order of conditions matters                                        │
 * │   - Always END the CASE                                                │
 * │   - ELSE prevents NULL results                                         │
 * │   - For math in CASE, keep result simple                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF CASE EXPRESSIONS REVISION GUIDE
-- ============================================================================