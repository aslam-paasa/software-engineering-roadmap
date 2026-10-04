/**
 * ORDER BY Ascending:
 * > Sort results in ascending order. 
 * > The products table has 20 items with prices ranging from 
 *   $9.99 to $999.99.
 * 
 * > ORDER BY sorts results. 
 * > ASC is the default (low to high). 
 * > This helps find the cheapest products.
 * > Use ORDER BY column_name ASC 
 *   (or just ORDER BY column_name since ASC is default)
*/

/**
 * SORTING ASC: From lowest to highest
 *
 * ASC (ascending) is the default sort direction. You do not need to
 * write it explicitly, but doing so makes your intention clear.
 * Numbers go from smallest to largest. Text goes from A to Z.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ List all products starting from the cheapest price              │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, price                                    │
 * │   FROM products                                                 │
 * │   ORDER BY price;                                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-------+                                 │
 * │ | product_name        | price |                                 │
 * │ +---------------------+-------+                                 │
 * │ | USB-C Cable         |    15 |                                 │
 * │ | Gaming Mouse        |    50 |                                 │
 * │ | Mechanical Keyboard |   120 |                                 │
 * │ | Ergonomic Chair     |   250 |                                 │
 * │ | Curved Monitor      |   300 |                                 │
 * │ +---------------------+-------+                                 │
 * │                                                                 │
 * │ Rows are sorted from the cheapest ($15) to the most expensive   │
 * │ ($300). No ASC keyword was needed — it is the default.          │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ASC vs DESC at a glance:
 * ┌──────────────────────────────────────────────────────────────┐
 * │ ORDER BY price ASC    → $15, $50, $120, $250, $300           │
 * │ ORDER BY price DESC   → $300, $250, $120, $50, $15           │
 * │ ORDER BY name ASC     → Apple, Banana, Cherry  (A → Z)       │
 * │ ORDER BY name DESC    → Cherry, Banana, Apple  (Z → A)       │
 * └──────────────────────────────────────────────────────────────┘
 */



/**
 * Deep Dive — ORDER BY & LIMIT:
 * 1. Operator Overview        : What ORDER BY and LIMIT do
 * 2. Sorting ASC              : Cheapest first, A to Z
 * 3. Sorting DESC             : Highest stock, largest first
 * 4. Top N Analysis           : Sort + LIMIT for leaderboards
 * 5. Multi-Level Sorting      : Tie-breakers with multiple columns
 * 6. Common Mistakes          : Pitfalls every beginner hits
 */

/**
 * QUICK REFERENCE
 *
 * SORTING PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * ORDER BY col                   → Ascending (default, same as ASC)
 * ORDER BY col ASC               → Small → large, A → Z (explicit)
 * ORDER BY col DESC              → Large → small, Z → A
 * ORDER BY col1 ASC, col2 DESC   → Multi-column sort with mixed dirs
 * ORDER BY alias DESC            → Sort by a computed column alias
 *
 * TOP N PATTERN:
 * ─────────────────────────────────────────────────────────────────────
 * ORDER BY col DESC LIMIT n      → Top N by largest value
 * ORDER BY col ASC LIMIT n       → Bottom N by smallest value
 * ORDER BY col DESC LIMIT 1      → Single highest value
 *
 * CORRECT CLAUSE ORDER:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT → FROM → WHERE → ORDER BY → LIMIT
 *
 * EXECUTION ORDER (how the db actually processes):
 * ─────────────────────────────────────────────────────────────────────
 * 1. FROM      → Find the table
 * 2. WHERE     → Filter rows
 * 3. SELECT    → Pick and compute columns
 * 4. ORDER BY  → Sort the result (aliases from SELECT available here)
 * 5. LIMIT     → Cap the final row count
 */
