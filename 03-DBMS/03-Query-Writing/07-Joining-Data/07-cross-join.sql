-- ============================================================================
-- PART 7: CROSS JOIN (Cartesian product)
-- ============================================================================

/**
 * CROSS JOIN produces the Cartesian product.
 * Every row from first table pairs with every row from second table.
 * Total rows = rows_in_table1 × rows_in_table2
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           CROSS JOIN                                    │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                         │
 * │   INPUT - Colors Table:           INPUT - Sizes Table:                  │
 * │   ┌────────┐                     ┌────────┐                             │
 * │   │ color  │                     │ size   │                             │
 * │   ├────────┤                     ├────────┤                             │
 * │   │ Red    │                     │ S      │                             │
 * │   │ Blue   │                     │ M      │                             │
 * │   │ Green  │                     │ L      │                             │
 * │   └────────┘                     └────────┘                             │
 * │                                                                         │
 * │   CROSS JOIN (No ON condition)                                          │
 * │                                                                         │
 * │   OUTPUT - Every color with every size (3 × 3 = 9 rows):                │
 * │   ┌────────┬────────┐                                                   │
 * │   │ color  │ size   │                                                   │
 * │   ├────────┼────────┤                                                   │
 * │   │ Red    │ S      │                                                   │
 * │   │ Red    │ M      │                                                   │
 * │   │ Red    │ L      │                                                   │
 * │   │ Blue   │ S      │                                                   │
 * │   │ Blue   │ M      │                                                   │
 * │   │ Blue   │ L      │                                                   │
 * │   │ Green  │ S      │                                                   │
 * │   │ Green  │ M      │                                                   │
 * │   │ Green  │ L      │                                                   │
 * │   └────────┴────────┘                                                   │
 * │                                                                         │
 * │   WARNING: If tables are large, this creates MASSIVE results!           │
 * │   1000 customers × 1000 orders = 1,000,000 rows!                        │
 * │                                                                         │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- CROSS JOIN example
SELECT COUNT(*) FROM customers CROSS JOIN orders;

/**
 * OUTPUT:
 * ┌──────────┐
 * │ count    │
 * ├──────────┤
 * │   64     │
 * └──────────┘
 * 
 * EXPLANATION:
 * - customers table: 8 rows
 * - orders table: 8 rows
 * - CROSS JOIN: 8 × 8 = 64 rows
 * 
 * USE CASE: Generating all combinations
 * Example: All customers with all coupon codes
 */

-- Practical example: Generate all customer-coupon combinations
CREATE TEMP TABLE coupons (coupon_code VARCHAR(10));
INSERT INTO coupons VALUES ('SAVE10'), ('SAVE20'), ('SAVE50');

SELECT c.name, coupon_code
FROM customers c
CROSS JOIN coupons
ORDER BY c.name, coupon_code;

-- Clean up
DROP TABLE coupons;
