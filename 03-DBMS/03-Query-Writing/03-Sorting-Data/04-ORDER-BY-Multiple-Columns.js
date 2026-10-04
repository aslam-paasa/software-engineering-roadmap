/**
 * ORDER BY Multiple Columns:
 * > Sort by multiple columns to create a hierarchical order. 
 * > First by one column, then by another for ties.
 * 
 * > Multiple column sorting applies the second sort within groups of 
 *   the first. 
 * > Users from the same country will be ordered by age.
 * > Use ORDER BY column1 ASC, column2 ASC
*/

/**
 * MULTI-LEVEL SORTING: Tie-breakers with multiple columns
 *
 * You can sort by more than one column at a time. The database sorts
 * by the first column you specify. If two rows have the same value
 * in the first column, it uses the second column as a tie-breaker.
 * You can mix ASC and DESC independently for each column.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Sort products by category (A → Z), then price (highest first)   │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category, price                          │
 * │   FROM products                                                 │
 * │   ORDER BY category ASC, price DESC;                            │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-------------+-------+                   │
 * │ | product_name        | category    | price |                   │
 * │ +---------------------+-------------+-------+                   │
 * │ | Mechanical Keyboard | Accessories |   120 |                   │
 * │ | Gaming Mouse        | Accessories |    50 |                   │
 * │ | USB-C Cable         | Cables      |    15 |                   │
 * │ | Curved Monitor      | Electronics |   300 |                   │
 * │ | Ergonomic Chair     | Furniture   |   250 |                   │
 * │ +---------------------+-------------+-------+                   │
 * │                                                                 │
 * │ Categories are sorted A → Z (Accessories, Cables, Electronics,  │
 * │ Furniture). Within Accessories, Mechanical Keyboard ($120)      │
 * │ appears before Gaming Mouse ($50) because price is sorted DESC. │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Multi-column sort syntax:
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ ORDER BY col1 ASC, col2 DESC                                     │
 * │   → Sort by col1 first (A→Z), then use col2 as tie-breaker       │
 * │     (largest first within the same col1 group)                   │
 * │                                                                  │
 * │ ORDER BY col1 DESC, col2 ASC                                     │
 * │   → Sort by col1 first (largest first), then col2 (A→Z)          │
 * │     within ties                                                  │
 * └──────────────────────────────────────────────────────────────────┘
 */
