-- ============================================================================
-- PART 11: ON vs WHERE (Important difference!)
-- ============================================================================

/**
 * ON vs WHERE - INPUT/OUTPUT COMPARISON:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                      ON vs WHERE - KEY DIFFERENCES                      │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                    ON (Join Condition)                          │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied DURING the join (while matching rows)             │   │
 * │   │ PURPOSE: Defines HOW tables should match                        │   │
 * │   │ EFFECT: Affects WHICH rows are considered for joining           │   │
 * │   │ BEST FOR: Controlling what matches from right table             │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │                   WHERE (Filter Condition)                      │   │
 * │   ├─────────────────────────────────────────────────────────────────┤   │
 * │   │ WHEN: Applied AFTER the join (after result is produced)         │   │
 * │   │ PURPOSE: Filters the final result                               │   │
 * │   │ EFFECT: Removes rows from the final output                      │   │
 * │   │ BEST FOR: Filtering final results based on any column           │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

/**
 * DEMONSTRATION: Condition in ON vs WHERE
 * 
 * Goal: Show orders with customer city, but only if city is 'Delhi'
 */

-- OPTION 1: Condition in ON (during join)
SELECT 
    o.order_code,
    c.customer_id, 
    c.city
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id
    AND c.city = 'Delhi';

/**
 * OUTPUT:
 * ┌────────────┬─────────────┬──────────┐
 * │ order_code │ customer_id │ city     │
 * ├────────────┼─────────────┼──────────┤
 * │     A      │    101      │ Delhi    │
 * │     B      │    NULL     │ NULL     │
 * │     C      │    NULL     │ NULL     │
 * │     D      │    101      │ Delhi    │
 * │     E      │    NULL     │ NULL     │
 * │     F      │    NULL     │ NULL     │
 * │     G      │    NULL     │ NULL     │
 * │     H      │    NULL     │ NULL     │
 * └────────────┴─────────────┴──────────┘
 * 
 * EXPLANATION:
 * - Condition is applied DURING join
 * - A customer row matches ONLY IF city = 'Delhi'
 * - Orders without Delhi customers still appear (with NULLs)
 * - ALL orders are preserved (8 rows)
 */

-- OPTION 2: Condition in WHERE (after join)
SELECT 
    o.order_code,
    c.customer_id, 
    c.city
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.city = 'Delhi';

/**
 * OUTPUT:
 * ┌────────────┬─────────────┬──────────┐
 * │ order_code │ customer_id │ city     │
 * ├────────────┼─────────────┼──────────┤
 * │     A      │    101      │ Delhi    │
 * │     D      │    101      │ Delhi    │
 * └────────────┴─────────────┴──────────┘
 * 
 * EXPLANATION:
 * - JOIN happens first (all orders preserved)
 * - THEN WHERE filters to only rows where city = 'Delhi'
 * - Only orders with Delhi customers remain (2 rows)
 * - Orders without customers or non-Delhi customers are REMOVED
 */

