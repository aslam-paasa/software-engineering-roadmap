/**
 * SELECT & FROM:
 * 1. Order of Execution     : How SQL actually processes a query
 * 2. Wildcard (*)           : Selecting all columns at once
 * 3. Column Order Control   : Writing columns in any order you want
 * 4. Math in SELECT         : Performing calculations on the fly
 * 5. Static Labels          : Adding fixed text to every row
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * HOW SELECT AND FROM ACTUALLY WORK
 * ─────────────────────────────────────────────────────────────────────
 * At first glance, it feels like SELECT runs first — because it appears
 * first in the query. But that is not how SQL works under the hood.
 *
 * SQL processes a query in this order:
 *
 *   Step 1 → FROM   : The database first finds the table you named.
 *                     Think of it as going to a filing cabinet and
 *                     pulling out the right folder.
 *
 *   Step 2 → SELECT : Once it has access to the full table, it then
 *                     looks at which columns were requested and
 *                     extracts only those.
 *
 * In English, we read left to right — so SELECT seems to come first.
 * In SQL, the engine works table-first, columns-second.
 *
 * ┌──────────────────────────────────────────────────────────────┐
 * │ Execution Order (simplified)                                 │
 * ├──────────────────────────────────────────────────────────────┤
 * │  1. FROM   → Open the table                                  │
 * │  2. WHERE  → Filter rows (if present)                        │
 * │  3. SELECT → Choose and compute the columns                  │
 * │  4. ORDER BY / LIMIT → Sort and cap results (if present)     │
 * └──────────────────────────────────────────────────────────────┘
 *
 * Understanding this order helps you write and debug queries correctly.
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * THE SAMPLE TABLE — products
 * ─────────────────────────────────────────────────────────────────────
 * The examples in this section use an electronics store inventory table.
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
 * ─────────────────────────────────────────────────────────────────────
 * CASE 1 — THE WILDCARD (*): Selecting all columns at once
 * ─────────────────────────────────────────────────────────────────────
 * The asterisk (*) is called a wildcard. It means "all columns."
 * It is the fastest way to see everything inside a table — great for
 * exploration and understanding a table's structure.
 *
 * ┌───────────────────────────────────────────────────────────────────┐
 * │ Select every column from the products table                       │
 * ├───────────────────────────────────────────────────────────────────┤
 * │   SELECT *                                                        │
 * │   FROM products;                                                  │
 * │                                                                   │
 * │ Output:                                                           │
 * │ +------------+---------------------+-------------+-------+------+ │
 * │ | product_id | product_name        | category    | price | stock│ │
 * │ +------------+---------------------+-------------+-------+------+ │
 * │ | 101        | Gaming Mouse        | Accessories |    50 |  100 │ │
 * │ | 102        | Mechanical Keyboard | Accessories |   120 |   50 │ │
 * │ | 103        | Curved Monitor      | Electronics |   300 |   20 │ │
 * │ | 104        | Ergonomic Chair     | Furniture   |   250 |   10 │ │
 * │ | 105        | USB-C Cable         | Cables      |    15 |  200 │ │
 * │ +------------+---------------------+-------------+-------+------+ │
 * └───────────────────────────────────────────────────────────────────┘
 *
 * ⚠️  Why strict usage matters:
 *   SELECT * is great for quick checks, but avoid it in real
 *   applications. If your table has 50 columns but your app only needs
 *   2 of them, fetching all 50 wastes memory and slows the system.
 *
 *   ✅ Use SELECT * for exploration and debugging.
 *   ❌ Avoid SELECT * in production code — name only what you need.
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * CASE 2 — COLUMN ORDER CONTROL: You decide what appears and in what order
 * ─────────────────────────────────────────────────────────────────────
 * When you list specific columns in SELECT, the order you write them
 * is the order they appear in the result.
 * The original order of columns in the table does not matter.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Show price first, then product name (reversed from table order) │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT price, product_name                                    │
 * │   FROM products;                                                │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-------+---------------------+                                 │
 * │ | price | product_name        |                                 │
 * │ +-------+---------------------+                                 │
 * │ |    50 | Gaming Mouse        |                                 │
 * │ |   120 | Mechanical Keyboard |                                 │
 * │ |   300 | Curved Monitor      |                                 │
 * │ |   250 | Ergonomic Chair     |                                 │
 * │ |    15 | USB-C Cable         |                                 │
 * │ +-------+---------------------+                                 │
 * │                                                                 │
 * │ Even though product_name comes before price in the table,       │
 * │ writing price first in SELECT puts it first in the output.      │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * CASE 3 — MATH IN SELECT: Performing calculations on the fly
 * ─────────────────────────────────────────────────────────────────────
 * The SELECT clause is not limited to fetching stored data.
 * It can also perform arithmetic on column values for every row —
 * the database computes the result instantly without storing it.
 *
 * When you perform a calculation, the database creates a temporary
 * column for the result. Without a name, the header shows the raw
 * formula. Use AS to give it a clean, readable label.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Show each product's name and total stock value                  │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Total value = price × stock_quantity                            │
 * │                                                                 │
 * │   SELECT product_name, price * stock_quantity AS total_value    │
 * │   FROM products;                                                │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-------------+                           │
 * │ | product_name        | total_value |                           │
 * │ +---------------------+-------------+                           │
 * │ | Gaming Mouse        |        5000 |                           │
 * │ | Mechanical Keyboard |        6000 |                           │
 * │ | Curved Monitor      |        6000 |                           │
 * │ | Ergonomic Chair     |        2500 |                           │
 * │ | USB-C Cable         |        3000 |                           │
 * │ +---------------------+-------------+                           │
 * │                                                                 │
 * │ The database multiplied price × stock_quantity for every single │
 * │ row instantly. The result column exists only in the output —    │
 * │ nothing is permanently stored or altered in the table.          │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Common arithmetic you can use directly in SELECT:
 *
 * ┌────────────────────────────────────────────────────────────────┐
 * │ SELECT price + 10 AS price_with_tax FROM products;             │
 * │ SELECT price * 0.9 AS discounted_price FROM products;          │
 * │ SELECT stock_quantity - 5 AS adjusted_stock FROM products;     │
 * │ SELECT price / 2 AS half_price FROM products;                  │
 * └────────────────────────────────────────────────────────────────┘
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * CASE 4 — STATIC LABELS: Adding fixed text to every row
 * ─────────────────────────────────────────────────────────────────────
 * You can add a hard-coded text value directly in SELECT.
 * The same text will appear in that column for every single row.
 * This is useful for tagging, labelling, or producing formatted reports.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ List all products and tag each row with 'In Warehouse'          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, 'In Warehouse' AS status                 │
 * │   FROM products;                                                │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+--------------+                          │
 * │ | product_name        | status       |                          │
 * │ +---------------------+--------------+                          │
 * │ | Gaming Mouse        | In Warehouse |                          │
 * │ | Mechanical Keyboard | In Warehouse |                          │
 * │ | Curved Monitor      | In Warehouse |                          │
 * │ | Ergonomic Chair     | In Warehouse |                          │
 * │ | USB-C Cable         | In Warehouse |                          │
 * │ +---------------------+--------------+                          │
 * │                                                                 │
 * │ 'In Warehouse' is a string literal — not a column name.         │
 * │ SQL prints the same text for every row.                         │
 * │                                                                 │
 * │ Useful for:                                                     │
 * │   → Reports that need a status tag on every row                 │
 * │   → Combining data from multiple tables with a source label     │
 * │   → Adding context or categories to exported results            │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * PRACTICAL EXAMPLES
 * ─────────────────────────────────────────────────────────────────────
 * Example 1: See the full table structure
 *   SELECT *
 *   FROM products;
 *   → Returns all columns and all rows — great for exploration
 *
 * Example 2: Show only what your app needs
 *   SELECT product_name, price
 *   FROM products;
 *   → Fetches just 2 of the 5 columns — faster and more efficient
 *
 * Example 3: Display price before product name
 *   SELECT price, product_name
 *   FROM products;
 *   → Column order in SELECT controls column order in output
 *
 * Example 4: Calculate inventory value per product
 *   SELECT product_name, price * stock_quantity AS total_value
 *   FROM products;
 *   → Multiplies two columns and names the result column clearly
 *
 * Example 5: Apply a 10% discount and label it
 *   SELECT product_name, price * 0.9 AS discounted_price
 *   FROM products;
 *   → Computes the reduced price without modifying the original table
 *
 * Example 6: Tag every row with a static status label
 *   SELECT product_name, 'In Warehouse' AS status
 *   FROM products;
 *   → Adds the same text to every row in a new output column
 *
 * Example 7: Combine a calculation and a label together
 *   SELECT product_name,
 *          price * stock_quantity AS total_value,
 *          'USD' AS currency
 *   FROM products;
 *   → Shows total value and labels the currency on every row
 */


/**
 * ─────────────────────────────────────────────────────────────────────
 * QUICK REFERENCE:
 * ─────────────────────────────────────────────────────────────────────
 * BASIC PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT * FROM table;                      → All columns, all rows
 * SELECT col1, col2 FROM table;             → Specific columns only
 * SELECT col2, col1 FROM table;             → Your custom column order
 *
 * CALCULATIONS IN SELECT:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT col * 2 AS doubled FROM table;     → Multiply a column
 * SELECT col + 100 AS adjusted FROM table;  → Add a constant value
 * SELECT col1 * col2 AS product FROM table; → Multiply two columns
 * SELECT col * 0.9 AS discounted FROM t;    → Apply a percentage
 *
 * STATIC LABELS:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT col, 'label' AS tag FROM table;    → Same text on every row
 * SELECT col, 42 AS constant FROM table;    → Same number on every row
 *
 * EXECUTION ORDER (important to remember):
 * ─────────────────────────────────────────────────────────────────────
 * 1. FROM      → Find and open the table
 * 2. WHERE     → Filter rows (if present)
 * 3. SELECT    → Pick and compute the columns
 * 4. ORDER BY  → Sort the result (if present)
 * 5. LIMIT     → Cap the number of rows (if present)
 */
