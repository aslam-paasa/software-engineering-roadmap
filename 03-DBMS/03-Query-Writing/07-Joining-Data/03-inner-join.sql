-- ============================================================================
-- PART 3: INNER JOIN (Only matching rows)
-- ============================================================================

/**
 * INNER JOIN returns ONLY rows that have matching values in BOTH tables.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          INNER JOIN                                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   INPUT - Customers Table:            INPUT - Orders Table:             │
 * │   ┌─────────────┬──────────┐        ┌──────────┬─────────────┐          │
 * │   │ customer_id │ name     │        │ order_id │ customer_id │          │
 * │   ├─────────────┼──────────┤        ├──────────┼─────────────┤          │
 * │   │    101      │ Aisha    │        │    1     │    101      │          │
 * │   │    102      │ Rohan    │        │    2     │    102      │          │
 * │   │    103      │ Meera    │        │    3     │    105      │          │
 * │   │    104      │ Arjun    │        │    4     │    101      │          │
 * │   │    106      │ Neha     │        │    5     │    106      │          │
 * │   │    107      │ Ishaan   │        │    6     │    106      │          │
 * │   │    108      │ Riya     │        │    7     │    NULL     │          │
 * │   │    109      │ Aisha    │        │    8     │    999      │          │
 * │   └─────────────┴──────────┘        └──────────┴─────────────┘          │
 * │                                                                         │
 * │   INNER JOIN ON customers.customer_id = orders.customer_id              │
 * │                                                                         │
 * │   OUTPUT - Only customers who HAVE orders:                              │
 * │   ┌─────────────┬──────────┬──────────┬─────────────┐                   │
 * │   │ customer_id │ name     │ order_id │ customer_id │                   │
 * │   ├─────────────┼──────────┼──────────┼─────────────┤                   │
 * │   │    101      │ Aisha    │    1     │    101      │  ← MATCH!         │
 * │   │    102      │ Rohan    │    2     │    102      │  ← MATCH!         │
 * │   │    101      │ Aisha    │    4     │    101      │  ← MATCH!         │
 * │   │    106      │ Neha     │    5     │    106      │  ← MATCH!         │
 * │   │    106      │ Neha     │    6     │    106      │  ← MATCH!         │
 * │   └─────────────┴──────────┴──────────┴─────────────┘                   │
 * │                                                                         │
 * │   ❌❌ Customer 103 (Meera) - No orders → NOT included                 │
 * │   ❌❌ Customer 104 (Arjun) - No orders → NOT included                 │
 * │   ❌❌ Customer 107 (Ishaan) - No orders → NOT included                │
 * │   ❌❌ Customer 108 (Riya) - No orders → NOT included                  │
 * │   ❌❌ Customer 109 (Aisha) - No orders → NOT included                 │
 * │   ❌❌ Order 3 (customer 105) - No customer → NOT included             │
 * │   ❌❌ Order 7 (customer NULL) - No customer → NOT included            │
 * │   ❌❌ Order 8 (customer 999) - No customer → NOT included             │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * SCENARIO 1: Count orders per customer
 * Which customers have placed orders? How many orders each?
 */

-- Using table aliases: c for customers, o for orders
SELECT
    c.customer_id,
    c.name,
    COUNT(*) AS orders_count
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬──────────────┐
 * │ customer_id │ name     │ orders_count │
 * ├─────────────┼──────────┼──────────────┤
 * │    101      │ Aisha    │      2       │
 * │    102      │ Rohan    │      1       │
 * │    106      │ Neha     │      2       │
 * └─────────────┴──────────┴──────────────┘
 * 
 * EXPLANATION:
 * - Only customers with at least 1 order appear
 * - Aisha has 2 orders (order_id 1 and 4)
 * - Rohan has 1 order (order_id 2)
 * - Neha has 2 orders (order_id 5 and 6)
 * - Customers without orders (Meera, Arjun, Ishaan, Riya, Aisha2) are NOT shown
 */

/**
 * SCENARIO 2: Revenue per customer
 * How much money has each customer spent?
 */

SELECT
    c.customer_id,
    c.name,
    SUM(o.total_amount) AS revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬─────────┐
 * │ customer_id │ name     │ revenue │
 * ├─────────────┼──────────┼─────────┤
 * │    101      │ Aisha    │ 1498.00 │
 * │    102      │ Rohan    │  299.00 │
 * │    106      │ Neha     │  948.00 │
 * └─────────────┴──────────┴─────────┘
 * 
 * EXPLANATION:
 * - Aisha: 499 + 999 = 1498
 * - Rohan: 299 = 299
 * - Neha: 799 + 149 = 948
 * - Only customers with orders are included
 */
