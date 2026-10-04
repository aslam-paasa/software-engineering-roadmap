
/**
 * ORDER BY & LIMIT — Sorting results and capping row count
 *
 * What do they do?
 * ─────────────────────────────────────────────────────────────────────
 * ORDER BY controls how the rows in your result are arranged.
 * It does not change the data stored in the database — it only
 * changes how you see it on your screen.
 *
 * LIMIT caps the number of rows returned, so you only see the top N
 * results. It prevents you from being overwhelmed by large datasets
 * and is essential for "Top 10" lists, leaderboards, and dashboards.
 *
 * ┌───────────────┬────────────────────────────────────────────────┐
 * │ Keyword       │ Behaviour                                      │
 * ├───────────────┼────────────────────────────────────────────────┤
 * │ ORDER BY col  │ Sorts by col in ASC order (default)            │
 * │ ORDER BY col  │                                                │
 * │   ASC         │ Small → large, A → Z (explicit ascending)      │
 * │ ORDER BY col  │                                                │
 * │   DESC        │ Large → small, Z → A (descending)              │
 * │ LIMIT n       │ Return only the first n rows of the result     │
 * └───────────────┴────────────────────────────────────────────────┘
 *
 * Quick example — top 2 countries by land area:
 *
 *   SELECT country, area
 *   FROM countries
 *   ORDER BY area DESC
 *   LIMIT 2;
 *
 * Output:
 * +---------+---------+
 * | country | area    |
 * +---------+---------+
 * | USA     | 9834000 |
 * | Brazil  | 8516000 |
 * +---------+---------+
 *
 * First sort by area (largest to smallest), then return only the top 2
 * rows using LIMIT.
 */


/**
 * THE SAMPLE TABLE — products
 *
 * The examples below use an electronics store inventory table.
 *
 * +------------+---------------------+-------------+-------+----------------+
 * | product_id | product_name        | category    | price | stock_quantity |
 * +------------+---------------------+-------------+-------+----------------+
 * | 101        | Gaming Mouse        | Accessories |    50 |            100 |
 * | 102        | Mechanical Keyboard | Accessories |   120 |             50 |
 * | 103        | Curved Monitor      | Electronics |   300 |             20 |
 * | 104        | Ergonomic Chair     | Furniture   |   250 |             10 |
 * | 105        | USB-C Cable         | Cables      |    15 |            200 |
 * +------------+---------------------+-------------+-------+----------------+
 */


/**
 * TOP N ANALYSIS: Combining ORDER BY with LIMIT
 *
 * The most powerful pattern with ORDER BY is pairing it with LIMIT.
 * Sort in descending order to put the best results at the top, then
 * use LIMIT to keep only the first N rows. This is how every "Top 10"
 * list, leaderboard, or bestseller chart is built in SQL.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ What are the 2 most expensive products in the store?            │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, price                                    │
 * │   FROM products                                                 │
 * │   ORDER BY price DESC                                           │
 * │   LIMIT 2;                                                      │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------------+-------+                                     │
 * │ | product_name    | price |                                     │
 * │ +-----------------+-------+                                     │
 * │ | Curved Monitor  |   300 |                                     │
 * │ | Ergonomic Chair |   250 |                                     │
 * │ +-----------------+-------+                                     │
 * │                                                                 │
 * │ The query sorted all 5 products by price (highest first), then  │
 * │ LIMIT cut the result to just the top 2 rows.                    │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * The Top N pattern — reusable formula:
 * ┌──────────────────────────────────────────────────────────────────┐
 * │   SELECT col                                                     │
 * │   FROM table                                                     │
 * │   ORDER BY col DESC   ← put the best at the top                  │
 * │   LIMIT n;            ← keep only the top n rows                 │
 * └──────────────────────────────────────────────────────────────────┘
 *
 * Common uses of this pattern:
 *   → Top 10 most expensive products
 *   → Top 5 highest-grossing customers
 *   → Top 3 countries by population
 *   → Most recent 20 orders
 */

