-- ============================================================================
-- PART 5: RIGHT JOIN (All right table rows)
-- ============================================================================

/**
 * RIGHT JOIN returns ALL rows from the RIGHT table, and matching rows from the LEFT table.
 * If no match exists, left table columns become NULL.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          RIGHT JOIN                                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   INPUT - Customers Table (LEFT):    INPUT - Orders Table (RIGHT):      │
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
 * │   RIGHT JOIN ON customers.customer_id = orders.customer_id              │
 * │                                                                         │
 * │   OUTPUT - ALL orders (even without customers):                         │
 * │   ┌──────────┬─────────────┬──────────┬────────────┐                    │
 * │   │ order_id │ customer_id │ name     │ order_code │                    │
 * │   ├──────────┼─────────────┼──────────┼────────────┤                    │
 * │   │    1     │    101      │ Aisha    │     A      │  ← HAS customer    │
 * │   │    2     │    102      │ Rohan    │     B      │  ← HAS customer    │
 * │   │    3     │    105      │ NULL     │     C      │  ← NO customer!    │
 * │   │    4     │    101      │ Aisha    │     D      │  ← HAS customer    │
 * │   │    5     │    106      │ Neha     │     E      │  ← HAS customer    │
 * │   │    6     │    106      │ Neha     │     F      │  ← HAS customer    │
 * │   │    7     │    NULL     │ NULL     │     G      │  ← NO customer!    │
 * │   │    8     │    999      │ NULL     │     H      │  ← NO customer!    │
 * │   └──────────┴─────────────┴──────────┴────────────┘                    │
 * │                                                                         │
 * │   ✅✅ ALL orders appear (8 orders)                                    │
 * │   ✅✅ Orders with customers show customer details                     │
 * │   ✅✅ Orders without customers show NULL for customer columns         │
 * │   ❌❌ Customers without orders (103,104,107,108,109) are NOT included │
 * │      (because they are on LEFT side)                                    │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * SCENARIO 1: Show every order with customer name (if known)
 */

-- Using table aliases: c for customers, o for orders
SELECT
    o.order_id,
    o.order_code,
    o.status,
    o.total_amount,
    o.customer_id,
    c.name AS customer_name
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬────────────┬──────────────┬─────────────┬────────────────┐
 * │ order_id │ order_code │ status     │ total_amount │ customer_id │ customer_name  │
 * ├──────────┼────────────┼────────────┼──────────────┼─────────────┼────────────────┤
 * │    1     │     A      │ PAID       │   499.00     │    101      │ Aisha          │
 * │    2     │     B      │ PAID       │   299.00     │    102      │ Rohan          │
 * │    3     │     C      │ PAID       │   199.00     │    105      │ NULL           │
 * │    4     │     D      │ CANCELLED  │   999.00     │    101      │ Aisha          │
 * │    5     │     E      │ PAID       │   799.00     │    106      │ Neha           │
 * │    6     │     F      │ PENDING    │   149.00     │    106      │ Neha           │
 * │    7     │     G      │ PAID       │   249.00     │    NULL     │ NULL           │
 * │    8     │     H      │ PAID       │   129.00     │    999      │ NULL           │
 * └──────────┴────────────┴────────────┴──────────────┴─────────────┴────────────────┘
 * 
 * EXPLANATION:
 * - RIGHT JOIN keeps ALL 8 orders
 * - Orders 1,2,4,5,6 have matching customers → show customer name
 * - Orders 3,7,8 have NO matching customer → customer_name is NULL
 * - Order 3: customer_id 105 (does not exist in customers)
 * - Order 7: customer_id NULL
 * - Order 8: customer_id 999 (does not exist in customers)
 */

/**
 * SCENARIO 2: Show only PAID orders with customer city
 */

SELECT
    o.order_id,
    o.order_code,
    o.status,
    o.total_amount,
    c.name AS customer_name,
    c.city
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.status = 'PAID'
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬────────────┬────────┬──────────────┬────────────────┬──────────┐
 * │ order_id │ order_code │ status │ total_amount │ customer_name  │ city     │
 * ├──────────┼────────────┼────────┼──────────────┼────────────────┼──────────┤
 * │    1     │     A      │ PAID   │   499.00     │ Aisha          │ Delhi    │
 * │    2     │     B      │ PAID   │   299.00     │ Rohan          │ Mumbai   │
 * │    3     │     C      │ PAID   │   199.00     │ NULL           │ NULL     │
 * │    5     │     E      │ PAID   │   799.00     │ Neha           │ Pune     │
 * │    7     │     G      │ PAID   │   249.00     │ NULL           │ NULL     │
 * │    8     │     H      │ PAID   │   129.00     │ NULL           │ NULL     │
 * └──────────┴────────────┴────────┴──────────────┴────────────────┴──────────┘
 * 
 * EXPLANATION:
 * - RIGHT JOIN keeps all orders
 * - WHERE o.status = 'PAID' filters to only PAID orders
 * - Order 4 (CANCELLED) is excluded
 * - Order 6 (PENDING) is excluded
 * - Orders without customers still appear (3,7,8) but customer columns are NULL
 */
