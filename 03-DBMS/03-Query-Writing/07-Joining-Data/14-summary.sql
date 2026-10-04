/**
 * ============================================================================
 * JOINS DEEP DIVE - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. TABLE ALIASES ------------------------- (Short names for tables)
 * 2. WHAT IS A JOIN? ----------------------- (Why we need joins)
 * 3. INNER JOIN ---------------------------- (Only matching rows)
 * 4. LEFT JOIN ----------------------------- (All left table rows)
 * 5. RIGHT JOIN ---------------------------- (All right table rows)
 * 6. FULL OUTER JOIN ----------------------- (All rows from both tables)
 * 7. CROSS JOIN ---------------------------- (Cartesian product)
 * 8. IMPLICIT JOIN ------------------------- (Old style comma join)
 * 9. SELF JOIN ----------------------------- (Table joins itself)
 * 10. NATURAL JOIN -------------------------- (Auto join by column names)
 * 11. ON vs WHERE -------------------------- (Important difference)
 * 12. PRACTICAL SCENARIOS ------------------ (Real business problems)
 * 13. GOLDEN RULES ------------------------- (Important points)
 * 
 * ============================================================================
 */









-- ============================================================================
-- SUMMARY TABLE: All JOIN Types
-- ============================================================================

/**
 * ┌─────────────────┬────────────────────────────────────────────────────────┐
 * │ JOIN TYPE       │ WHAT IT DOES                                           │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ INNER JOIN      │ Only rows that match in BOTH tables                    │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ LEFT JOIN       │ ALL rows from LEFT table + matches from RIGHT          │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ RIGHT JOIN      │ ALL rows from RIGHT table + matches from LEFT          │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ FULL OUTER JOIN │ ALL rows from BOTH tables (where available)            │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ CROSS JOIN      │ Every row from table1 with every row from table2       │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ SELF JOIN       │ Table joins with itself (for hierarchies)              │
 * ├─────────────────┼────────────────────────────────────────────────────────┤
 * │ NATURAL JOIN    │ Auto-join on columns with same name (risky!)           │
 * └─────────────────┴────────────────────────────────────────────────────────┘
 * 
 * ┌─────────────────┬────────────┬────────────┬────────────────────────────┐
 * │ JOIN TYPE       │ customers  │ orders     │ Total rows in result       │
 * │                 │ (8 rows)   │ (8 rows)   │                            │
 * ├─────────────────┼────────────┼────────────┼────────────────────────────┤
 * │ INNER JOIN      │ Only with  │ Only with  │ 5 rows (matching only)     │
 * │                 │ orders     │ customers  │                            │
 * ├─────────────────┼────────────┼────────────┼────────────────────────────┤
 * │ LEFT JOIN       │ ALL 8      │ Only       │ 10 rows (8 customers +     │
 * │                 │ customers  │ matching   │ their orders)              │
 * ├─────────────────┼────────────┼────────────┼────────────────────────────┤
 * │ RIGHT JOIN      │ Only       │ ALL 8      │ 8 rows (all orders)        │
 * │                 │ matching   │ orders     │                            │
 * ├─────────────────┼────────────┼────────────┼────────────────────────────┤
 * │ CROSS JOIN      │ ALL 8      │ ALL 8      │ 64 rows (8×8)              │
 * └─────────────────┴────────────┴────────────┴────────────────────────────┘
 */

-- ============================================================================
-- PRACTICAL SCENARIOS (Real business problems)
-- ============================================================================

/**
 * SCENARIO 1: Customers who have never ordered (for marketing campaigns)
 */

SELECT 
    c.customer_id,
    c.name,
    c.email,
    c.city
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬───────────────────┬────────────┐
 * │ customer_id │ name     │ email             │ city       │
 * ├─────────────┼──────────┼───────────────────┼────────────┤
 * │    103      │ Meera    │ meera@demo.com    │ NULL       │
 * │    104      │ Arjun    │ arjun@demo.com    │ Delhi      │
 * │    107      │ Ishaan   │ ishaan@demo.com   │ Bengaluru  │
 * │    108      │ Riya     │ NULL              │ Delhi      │
 * │    109      │ Aisha    │ aisha2@demo.com   │ Jaipur     │
 * └─────────────┴──────────┴───────────────────┴────────────┘
 * 
 * USE CASE: Send promotional emails to these customers
 */

/**
 * SCENARIO 2: Orders with missing customer information (data quality check)
 */

SELECT 
    o.order_id,
    o.order_code,
    o.customer_id,
    o.status,
    c.name AS customer_name
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬─────────────┬────────────┬────────────────┐
 * │ order_id │ order_code │ customer_id │ status     │ customer_name  │
 * ├──────────┼────────────┼─────────────┼────────────┼────────────────┤
 * │    3     │     C      │    105      │ PAID       │ NULL           │
 * │    7     │     G      │    NULL     │ PAID       │ NULL           │
 * │    8     │     H      │    999      │ PAID       │ NULL           │
 * └──────────┴────────────┴─────────────┴────────────┴────────────────┘
 * 
 * USE CASE: Data quality check - find orphaned orders
 */

/**
 * SCENARIO 3: Customer order summary (with zero for customers without orders)
 */

SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬──────────────┬──────────────┐
 * │ customer_id │ name     │ total_orders │ total_spent  │
 * ├─────────────┼──────────┼──────────────┼──────────────┤
 * │    101      │ Aisha    │      2       │   1498.00    │
 * │    106      │ Neha     │      2       │    948.00    │
 * │    102      │ Rohan    │      1       │    299.00    │
 * │    103      │ Meera    │      0       │      0.00    │
 * │    104      │ Arjun    │      0       │      0.00    │
 * │    107      │ Ishaan   │      0       │      0.00    │
 * │    108      │ Riya     │      0       │      0.00    │
 * │    109      │ Aisha    │      0       │      0.00    │
 * └─────────────┴──────────┴──────────────┴──────────────┘
 * 
 * USE CASE: Customer analytics - show all customers with their order stats
 */

-- ============================================================================
-- GOLDEN RULES (Important points to remember)
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Always use EXPLICIT JOIN syntax                                │
 * │         → Use INNER JOIN, LEFT JOIN, RIGHT JOIN                        │
 * │         → Avoid comma joins (IMPLICIT JOIN)                            │
 * │         → Much clearer and less error-prone                            │
 * │                                                                          │
 * │ RULE 2: Always use TABLE ALIASES                                       │
 * │         → customers c, orders o                                        │
 * │         → Makes queries shorter and clearer                            │
 * │         → Essential for SELF JOIN                                      │
 * │         → Use meaningful aliases (first letter of table name)          │
 * │                                                                          │
 * │ RULE 3: LEFT JOIN keeps ALL rows from LEFT table                       │
 * │         → Even if no match in right table                              │
 * │         → Right table columns become NULL                              │
 * │                                                                          │
 * │ RULE 4: RIGHT JOIN keeps ALL rows from RIGHT table                     │
 * │         → Even if no match in left table                               │
 * │         → Left table columns become NULL                               │
 * │         → (Can always rewrite as LEFT JOIN)                            │
 * │                                                                          │
 * │ RULE 5: INNER JOIN keeps ONLY matching rows                            │
 * │         → Rows that don't match are EXCLUDED                           │
 * │         → Most common join type                                        │
 * │                                                                          │
 * │ RULE 6: ON happens DURING join, WHERE happens AFTER join               │
 * │         → ON affects WHICH rows are joined                             │
 * │         → WHERE filters final result                                   │
 * │         → Put join conditions in ON, filters in WHERE                  │
 * │                                                                          │
 * │ RULE 7: Index your join columns                                        │
 * │         → CREATE INDEX idx_orders_customer_id ON orders(customer_id)   │
 * │         → Makes joins much faster                                      │
 * │                                                                          │
 * │ RULE 8: Be careful with CROSS JOIN                                     │
 * │         → Can create MASSIVE result sets                               │
 * │         → 10,000 × 10,000 = 100,000,000 rows!                         │
 * │                                                                          │
 * │ RULE 9: NATURAL JOIN is risky                                          │
 * │         → New same-named columns change results silently               │
 * │         → Always use explicit JOIN with ON                            │
 * │                                                                          │
 * │ RULE 10: Test with small data first                                    │
 * │         → Always test joins on a subset before running on full data    │
 * │         → Use LIMIT to verify results                                  │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Check if join columns are indexed
SELECT 
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename IN ('customers', 'orders')
ORDER BY tablename, indexname;

-- ============================================================================
-- PRACTICE EXERCISES (Try yourself)
-- ============================================================================

/**
 * EXERCISE 1: Find customers who have placed at least 2 orders
 * 
 * Answer:
 *   SELECT c.customer_id, c.name, COUNT(*) as order_count
 *   FROM customers c
 *   INNER JOIN orders o ON c.customer_id = o.customer_id
 *   GROUP BY c.customer_id, c.name
 *   HAVING COUNT(*) >= 2;
 */

/**
 * EXERCISE 2: List all orders with customer email (even if customer missing)
 * 
 * Answer:
 *   SELECT o.order_id, o.order_code, c.email
 *   FROM orders o
 *   LEFT JOIN customers c ON o.customer_id = c.customer_id;
 */

/**
 * EXERCISE 3: Find orders placed by customers from Delhi
 * 
 * Answer:
 *   SELECT o.order_id, o.order_code, c.name, c.city
 *   FROM customers c
 *   INNER JOIN orders o ON c.customer_id = o.customer_id
 *   WHERE c.city = 'Delhi';
 */

/**
 * EXERCISE 4: Show all customers and total orders (including zero)
 * 
 * Answer:
 *   SELECT c.customer_id, c.name, COUNT(o.order_id) as total_orders
 *   FROM customers c
 *   LEFT JOIN orders o ON c.customer_id = o.customer_id
 *   GROUP BY c.customer_id, c.name;
 */

/**
 * EXERCISE 5: Find customers who ordered in January 2026
 * 
 * Answer:
 *   SELECT DISTINCT c.customer_id, c.name
 *   FROM customers c
 *   INNER JOIN orders o ON c.customer_id = o.customer_id
 *   WHERE o.placed_at_utc >= '2026-01-01' 
 *     AND o.placed_at_utc < '2026-02-01';
 */

-- ============================================================================
-- QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         QUICK REFERENCE CARD                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ TABLE ALIASES:                                                          │
 * │   FROM table_name AS alias                                              │
 * │   FROM table_name alias     (AS is optional)                           │
 * │   Example: FROM customers c                                             │
 * │                                                                          │
 * │ INNER JOIN:                                                             │
 * │   SELECT * FROM table1 INNER JOIN table2 ON table1.key = table2.key    │
 * │                                                                          │
 * │ LEFT JOIN:                                                              │
 * │   SELECT * FROM table1 LEFT JOIN table2 ON table1.key = table2.key     │
 * │                                                                          │
 * │ RIGHT JOIN:                                                             │
 * │   SELECT * FROM table1 RIGHT JOIN table2 ON table1.key = table2.key    │
 * │                                                                          │
 * │ FULL OUTER JOIN:                                                        │
 * │   SELECT * FROM table1 FULL OUTER JOIN table2 ON table1.key = table2.key│
 * │                                                                          │
 * │ CROSS JOIN:                                                             │
 * │   SELECT * FROM table1 CROSS JOIN table2                               │
 * │                                                                          │
 * │ SELF JOIN:                                                              │
 * │   SELECT * FROM table t1 JOIN table t2 ON t1.key = t2.foreign_key      │
 * │                                                                          │
 * │ COMMON PATTERN - Customers without orders:                              │
 * │   SELECT c.* FROM customers c                                          │
 * │   LEFT JOIN orders o ON c.customer_id = o.customer_id                  │
 * │   WHERE o.order_id IS NULL                                             │
 * │                                                                          │
 * │ COMMON PATTERN - Orders without customers:                              │
 * │   SELECT o.* FROM orders o                                             │
 * │   LEFT JOIN customers c ON o.customer_id = c.customer_id               │
 * │   WHERE c.customer_id IS NULL                                          │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. TABLE ALIASES = Short names for tables (c for customers)            │
 * │    → Makes queries shorter and clearer                                 │
 * │    → Essential for SELF JOIN                                           │
 * │                                                                          │
 * │ 2. JOIN = Combining data from multiple tables using common keys        │
 * │                                                                          │
 * │ 3. INNER JOIN = Only matching rows from both tables                    │
 * │                                                                          │
 * │ 4. LEFT JOIN = All rows from left table + matches from right           │
 * │                                                                          │
 * │ 5. RIGHT JOIN = All rows from right table + matches from left          │
 * │                                                                          │
 * │ 6. FULL OUTER JOIN = All rows from both tables                         │
 * │                                                                          │
 * │ 7. CROSS JOIN = Every row with every row (Cartesian product)           │
 * │                                                                          │
 * │ 8. SELF JOIN = Table joined with itself (hierarchies)                  │
 * │                                                                          │
 * │ 9. NATURAL JOIN = Auto-join on same column names (risky)               │
 * │                                                                          │
 * │ 10. ON = Happens DURING join (controls matching)                       │
 * │                                                                          │
 * │ 11. WHERE = Happens AFTER join (filters results)                       │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Always use explicit JOIN syntax                                    │
 * │   - Always use table aliases for readability                           │
 * │   - Index join columns for performance                                 │
 * │   - LEFT JOIN is more common than RIGHT JOIN                           │
 * │   - Test with small data first                                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF JOINS DEEP DIVE GUIDE
-- ============================================================================