-- ============================================================================
-- PART 8: IMPLICIT JOIN (Old style comma join)
-- ============================================================================

/**
 * IMPLICIT JOIN is the old way of writing joins using comma in FROM clause.
 * The join condition goes in WHERE clause.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          IMPLICIT JOIN                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   IMPLICIT JOIN (Old style):                                            │
 * │   ┌────────────────────────────────────────────────────────────────┐    │
 * │   │ SELECT *                                                       │    │
 * │   │ FROM customers c, orders o                                     │    │
 * │   │ WHERE c.customer_id = o.customer_id;                           │    │
 * │   └────────────────────────────────────────────────────────────────┘    │
 * │                                                                         │
 * │   EXPLICIT JOIN (New style - RECOMMENDED):                              │
 * │   ┌────────────────────────────────────────────────────────────────┐    │
 * │   │ SELECT *                                                       │    │
 * │   │ FROM customers c                                               │    │
 * │   │ INNER JOIN orders o ON c.customer_id = o.customer_id;          │    │
 * │   └────────────────────────────────────────────────────────────────┘    │
 * │                                                                         │
 * │   ⚠️⚠️ WARNING: If you forget WHERE clause, it becomes CROSS JOIN!     │
 * │   ⚠️⚠️ Always use EXPLICIT JOIN (INNER JOIN, LEFT JOIN, etc.)          │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- IMPLICIT JOIN (Old style - NOT recommended)
SELECT
    c.customer_id,
    c.name,
    o.order_code,
    o.status
FROM customers c, orders o
WHERE c.customer_id = o.customer_id;

/**
 * OUTPUT (Same as INNER JOIN):
 * ┌─────────────┬──────────┬────────────┬────────────┐
 * │ customer_id │ name     │ order_code │ status     │
 * ├─────────────┼──────────┼────────────┼────────────┤
 * │    101      │ Aisha    │     A      │ PAID       │
 * │    102      │ Rohan    │     B      │ PAID       │
 * │    101      │ Aisha    │     D      │ CANCELLED  │
 * │    106      │ Neha     │     E      │ PAID       │
 * │    106      │ Neha     │     F      │ PENDING    │
 * └─────────────┴──────────┴────────────┴────────────┘
 * 
 * DANGER: Forgetting WHERE clause
 * 
 * SELECT * FROM customers c, orders o;  -- No WHERE clause
 * This becomes CROSS JOIN! 8 × 8 = 64 rows!
 */
