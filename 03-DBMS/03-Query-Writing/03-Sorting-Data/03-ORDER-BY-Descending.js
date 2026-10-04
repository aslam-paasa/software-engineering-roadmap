/**
 * ORDER BY Descending:
 * > Sort results in descending order. 
 * > Find the most expensive products first.
 * 
 * > DESC reverses the sort order to show highest values first. 
 * > Perfect for finding top items.
 * > Use ORDER BY column_name DESC
*/

/**
 * CASE 2 — SORTING DESC: From highest to lowest
 *
 * When you want the largest numbers or the end of the alphabet first,
 * add the DESC keyword. This is the standard approach for identifying
 * top performers, highest quantities, or most recent records.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Which items do we have the most of? Sort by stock, highest first │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, stock_quantity                           │
 * │   FROM products                                                 │
 * │   ORDER BY stock_quantity DESC;                                 │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+----------------+                        │
 * │ | product_name        | stock_quantity |                        │
 * │ +---------------------+----------------+                        │
 * │ | USB-C Cable         |            200 |                        │
 * │ | Gaming Mouse        |            100 |                        │
 * │ | Mechanical Keyboard |             50 |                        │
 * │ | Curved Monitor      |             20 |                        │
 * │ | Ergonomic Chair     |             10 |                        │
 * │ +---------------------+----------------+                        │
 * │                                                                 │
 * │ USB-C Cable has the most stock (200 units) and appears first.   │
 * │ Ergonomic Chair (10 units) has the lowest stock and appears     │
 * │ last — a clear signal it needs to be reordered soon.           │
 * └─────────────────────────────────────────────────────────────────┘
 */
