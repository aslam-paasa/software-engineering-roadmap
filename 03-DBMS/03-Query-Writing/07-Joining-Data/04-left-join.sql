-- ============================================================================
-- PART 4: LEFT JOIN (All left table rows)
-- ============================================================================

/**
 * LEFT JOIN returns ALL rows from the LEFT table, and matching rows from the RIGHT table.
 * If no match exists, right table columns become NULL.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           LEFT JOIN                                     │
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
 * │   LEFT JOIN ON customers.customer_id = orders.customer_id               │
 * │                                                                         │
 * │   OUTPUT - ALL customers (even without orders):                         │
 * │   ┌─────────────┬──────────┬──────────┬─────────────┐                   │
 * │   │ customer_id │ name     │ order_id │ customer_id │                   │
 * │   ├─────────────┼──────────┼──────────┼─────────────┤                   │
 * │   │    101      │ Aisha    │    1     │    101      │  ← HAS order      │
 * │   │    101      │ Aisha    │    4     │    101      │  ← HAS order      │
 * │   │    102      │ Rohan    │    2     │    102      │  ← HAS order      │
 * │   │    103      │ Meera    │   NULL   │    NULL     │  ← NO order!      │
 * │   │    104      │ Arjun    │   NULL   │    NULL     │  ← NO order!      │
 * │   │    106      │ Neha     │    5     │    106      │  ← HAS order      │
 * │   │    106      │ Neha     │    6     │    106      │  ← HAS order      │
 * │   │    107      │ Ishaan   │   NULL   │    NULL     │  ← NO order!      │
 * │   │    108      │ Riya     │   NULL   │    NULL     │  ← NO order!      │
 * │   │    109      │ Aisha    │   NULL   │    NULL     │  ← NO order!      │
 * │   └─────────────┴──────────┴──────────┴─────────────┘                   │
 * │                                                                         │
 * │   ✅✅ ALL customers appear (8 customers)                              │
 * │   ✅✅ Customers with orders show order details                        │
 * │   ✅✅ Customers without orders show NULL for order columns            │
 * │   ❌❌ Orders without matching customers (3,7,8) are NOT included      │
 * │      (because they are on RIGHT side)                                   │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * SCENARIO 1: Show every customer and their orders
 */

-- Using table aliases: c for customers, o for orders
SELECT
    c.customer_id,
    c.name,
    o.order_id,
    o.order_code
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬──────────┬────────────┐
 * │ customer_id │ name     │ order_id │ order_code │
 * ├─────────────┼──────────┼──────────┼────────────┤
 * │    101      │ Aisha    │    1     │     A      │
 * │    101      │ Aisha    │    4     │     D      │
 * │    102      │ Rohan    │    2     │     B      │
 * │    103      │ Meera    │   NULL   │    NULL    │
 * │    104      │ Arjun    │   NULL   │    NULL    │
 * │    106      │ Neha     │    5     │     E      │
 * │    106      │ Neha     │    6     │     F      │
 * │    107      │ Ishaan   │   NULL   │    NULL    │
 * │    108      │ Riya     │   NULL   │    NULL    │
 * │    109      │ Aisha    │   NULL   │    NULL    │
 * └─────────────┴──────────┴──────────┴────────────┘
 * 
 * EXPLANATION:
 * - LEFT JOIN keeps ALL 8 customers
 * - Customers with orders (Aisha, Rohan, Neha) show their orders
 * - Customers without orders (Meera, Arjun, Ishaan, Riya, Aisha2) show NULL
 */

/**
 * SCENARIO 2: Find customers who never placed any order
 */

SELECT
    c.customer_id,
    c.name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

/**
 * OUTPUT:
 * ┌─────────────┬──────────┬──────────┐
 * │ customer_id │ name     │ order_id │
 * ├─────────────┼──────────┼──────────┤
 * │    103      │ Meera    │   NULL   │
 * │    104      │ Arjun    │   NULL   │
 * │    107      │ Ishaan   │   NULL   │
 * │    108      │ Riya     │   NULL   │
 * │    109      │ Aisha    │   NULL   │
 * └─────────────┴──────────┴──────────┘
 * 
 * EXPLANATION:
 * - LEFT JOIN first (keeps all customers)
 * - WHERE o.order_id IS NULL (filters to customers with no orders)
 * - These 5 customers have never placed any order
 */
