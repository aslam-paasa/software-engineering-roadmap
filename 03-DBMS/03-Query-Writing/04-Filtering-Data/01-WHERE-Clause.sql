/**
 * WHERE Clause:
 * > Filter rows based on conditions. 
 * > Our users are from USA, Canada, UK, and Australia.
 * 
 * > WHERE filters data before returning results. 
 * > This returns only USA-based customers.
 * > Use WHERE column_name = 'value' (use single quotes for text)
*/

/**
 * Deep Dive — WHERE Clause:
 * 1. The Gatekeeper Model    : How WHERE evaluates every row
 * 2. Execution Order         : When filtering happens in the pipeline
 * 3. Filtering by Text       : Using single quotes for string values
 * 4. Filtering by Numbers    : No quotes needed for numeric values
 * 5. Finding Out-of-Stock    : A real inventory use case
 * 6. Common Mistakes         : Pitfalls every beginner hits
 */


/**
 * WHERE: THE GATEKEEPER OF YOUR DATA
 *
 * What does WHERE do?
 * ─────────────────────────
 * WHERE restricts rows by applying logical conditions.
 * Only rows that satisfy the condition(s) are included in the result.
 *
 * Think of WHERE as a security guard standing between the raw data in
 * your table and the final result you see on your screen. It looks at
 * every single row, checks your condition, and makes a binary decision:
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ How the gatekeeper works                                        │
 * ├─────────────────────────────────────────────────────────────────┤
 * │                                                                 │
 * │   Every row  →  WHERE checks condition  →  True?  => Let it in  │
 * │                                         →  False? => Block it   │
 * │                                                                 │
 * │   If the condition is TRUE  → the row passes to the result      │
 * │   If the condition is FALSE → the row is blocked and ignored    │
 * │                                                                 │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Simple example — find countries in the Oceania region:
 *
 *   SELECT *
 *   FROM countries
 *   WHERE region = 'Oceania';
 *
 * Output:
 * +-----------+------------+---------+---------+
 * | country   | population | area    | region  |
 * +-----------+------------+---------+---------+
 * | Australia |   25700000 | 7692000 | Oceania |
 * +-----------+------------+---------+---------+
 *
 * WHERE decides which rows are allowed to stay.
 */


/**
 * EXECUTION ORDER WITH FILTERING
 *
 * Even though SELECT appears at the top of a query, the database does
 * NOT run it first. When a WHERE clause is present, the engine filters
 * rows BEFORE it picks which columns to display.
 *
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ Step │ Clause   │ What happens                                   │
 * ├──────────────────────────────────────────────────────────────────┤
 * │  1   │ FROM     │ The database finds and opens the table         │
 * │  2   │ WHERE    │ It checks every row against your condition and  │
 * │      │          │ removes any row that does not pass             │
 * │  3   │ SELECT   │ It takes the surviving rows and extracts the    │
 * │      │          │ specific columns you asked for                 │
 * └──────────────────────────────────────────────────────────────────┘
 *
 * Why this order matters:
 *   This is why you can filter by a column like stock_quantity even
 *   if you do NOT want that column to appear in the final result.
 *   The database sees stock_quantity during Step 2 (WHERE), before it
 *   hides it in Step 3 (SELECT).
 *
 *   Example — filter on a column you are not displaying:
 *
 *   SELECT product_name
 *   FROM products
 *   WHERE stock_quantity < 30;
 *
 *   stock_quantity is used to filter, but it never appears in the
 *   output. This works perfectly because WHERE runs before SELECT.
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
 * | 104        | Ergonomic Chair     | Furniture   |   250 |              0 |
 * | 105        | USB-C Cable         | Cables      |    15 |            200 |
 * +------------+---------------------+-------------+-------+----------------+
 */


/**
 * CASE 1 — FILTERING BY TEXT: Always use single quotes
 *
 * When searching for specific words — such as a category name or a
 * region — you must wrap the value in single quotes.
 * This tells the database you are looking for a string of text, not
 * a column name or a number.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Show all items that belong to the 'Accessories' category        │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category                                 │
 * │   FROM products                                                 │
 * │   WHERE category = 'Accessories';                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-------------+                           │
 * │ | product_name        | category    |                           │
 * │ +---------------------+-------------+                           │
 * │ | Gaming Mouse        | Accessories |                           │
 * │ | Mechanical Keyboard | Accessories |                           │
 * │ +---------------------+-------------+                           │
 * │                                                                 │
 * │ 'Accessories' is in single quotes → the database treats it as   │
 * │ a text value, not a column name.                                │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * CASE 2 — FILTERING BY NUMBERS: No quotes needed
 *
 * When filtering on numeric values, write the number directly —
 * no single quotes. If you put quotes around a number, the database
 * may treat it as text, which can lead to slow queries or errors on
 * certain column types.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Find the product that has exactly 20 units in stock             │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, stock_quantity                           │
 * │   FROM products                                                 │
 * │   WHERE stock_quantity = 20;                                    │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +----------------+----------------+                             │
 * │ | product_name   | stock_quantity |                             │
 * │ +----------------+----------------+                             │
 * │ | Curved Monitor |             20 |                             │
 * │ +----------------+----------------+                             │
 * │                                                                 │
 * │ 20 has no quotes → the database treats it as a number and       │
 * │ performs a proper numeric comparison.                           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Quick rule:
 * ┌───────────────┬──────────────────────────────────────────────┐
 * │ Value type    │ Syntax                                       │
 * ├───────────────┼──────────────────────────────────────────────┤
 * │ Text / String │ WHERE category = 'Accessories'  ← quotes     │
 * │ Number        │ WHERE stock_quantity = 20       ← no quotes  │
 * └───────────────┴──────────────────────────────────────────────┘
 */


/**
 * CASE 3 — FINDING OUT-OF-STOCK ITEMS: A real inventory use case
 *
 * Finding items where stock has hit zero is one of the most common
 * real-world queries a store manager would run. We filter for rows
 * where stock_quantity equals exactly 0.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Which products are currently out of stock?                      │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category                                 │
 * │   FROM products                                                 │
 * │   WHERE stock_quantity = 0;                                     │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------------+-----------+                                 │
 * │ | product_name    | category  |                                 │
 * │ +-----------------+-----------+                                 │
 * │ | Ergonomic Chair | Furniture |                                 │
 * │ +-----------------+-----------+                                 │
 * │                                                                 │
 * │ Only the Ergonomic Chair had 0 stock — all other rows were      │
 * │ blocked by the gatekeeper because their condition was FALSE.    │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Extension — find items that are running LOW (not just zero):
 *
 *   SELECT product_name, stock_quantity
 *   FROM products
 *   WHERE stock_quantity < 30;
 *
 * Output:
 * +-----------------+----------------+
 * | product_name    | stock_quantity |
 * +-----------------+----------------+
 * | Curved Monitor  |             20 |
 * | Ergonomic Chair |              0 |
 * +-----------------+----------------+
 *
 * This catches items that are about to run out, not just those
 * that are already empty.
 */


/**
 * COMMON MISTAKES TO AVOID
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 1 — Case Sensitivity                                    │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Searching for 'accessories' (lowercase) will NOT match          │
 * │ 'Accessories' (capitalized) in many databases.                  │
 * │ Always match the capitalisation exactly as stored in the table. │
 * │                                                                 │
 * │   ❌ WHERE category = 'accessories'   → may return no results   │
 * │   ✅ WHERE category = 'Accessories'   → matches correctly       │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 2 — Forgetting quotes around text values                │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ If you omit quotes around a text value, the database treats     │
 * │ it as a column name — and usually throws an error.              │
 * │                                                                 │
 * │   ❌ WHERE category = Accessories                               │
 * │      → Database looks for a column called "Accessories" → Error │
 * │                                                                 │
 * │   ✅ WHERE category = 'Accessories'   → works correctly         │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 3 — Using aliases (AS) inside WHERE                     │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ You cannot reference an alias created in SELECT inside WHERE.   │
 * │ This fails because WHERE runs BEFORE SELECT in the execution    │
 * │ order — the alias does not exist yet when WHERE is evaluated.   │
 * │                                                                 │
 * │   ❌ SELECT price AS cost                                       │
 * │      FROM products                                              │
 * │      WHERE cost = 50;   → "cost" is unknown at this step        │
 * │                                                                 │
 * │   ✅ SELECT price AS cost                                       │
 * │      FROM products                                              │
 * │      WHERE price = 50;  → use the real column name in WHERE     │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: Find all countries in a specific region
 *   SELECT *
 *   FROM countries
 *   WHERE region = 'Asia';
 *   → Returns India and China
 *
 * Example 2: Find a product by its exact category
 *   SELECT product_name, category
 *   FROM products
 *   WHERE category = 'Electronics';
 *   → Returns Curved Monitor
 *
 * Example 3: Find products priced above 100
 *   SELECT product_name, price
 *   FROM products
 *   WHERE price > 100;
 *   → Returns Mechanical Keyboard, Curved Monitor, Ergonomic Chair
 *
 * Example 4: Find items with very high stock (over 150 units)
 *   SELECT product_name, stock_quantity
 *   FROM products
 *   WHERE stock_quantity > 150;
 *   → Returns USB-C Cable (200 units)
 *
 * Example 5: Filter on a column you are not displaying
 *   SELECT product_name
 *   FROM products
 *   WHERE stock_quantity < 30;
 *   → Shows only product names but filters by stock — valid because
 *     WHERE runs before SELECT in the execution order
 *
 * Example 6: Find out-of-stock items and their categories
 *   SELECT product_name, category
 *   FROM products
 *   WHERE stock_quantity = 0;
 *   → Returns Ergonomic Chair, Furniture
 */


/**
 * QUICK REFERENCE
 *
 * SYNTAX PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * WHERE col = 'text'           → Match a specific text value
 * WHERE col = 42               → Match a specific number (no quotes)
 * WHERE col = 0                → Find zero / empty stock
 * WHERE col > 100              → Greater than a value
 * WHERE col < 30               → Less than a value
 * WHERE col >= 50              → Greater than or equal to
 * WHERE col <= 10              → Less than or equal to
 * WHERE col != 'value'         → Exclude a specific value
 *
 * QUOTING RULES:
 * ─────────────────────────────────────────────────────────────────────
 * Text / String  → Always wrap in single quotes: 'Accessories'
 * Numbers        → Never use quotes: 20, 0, 300
 * Column names   → Never use quotes: stock_quantity, price
 *
 * EXECUTION ORDER (with WHERE):
 * ─────────────────────────────────────────────────────────────────────
 * 1. FROM     → Find the table
 * 2. WHERE    → Filter rows (aliases from SELECT not yet available)
 * 3. SELECT   → Extract and display the columns
 * 4. ORDER BY → Sort (if present)
 * 5. LIMIT    → Cap the results (if present)
 */


/**
 * ======================================================================
 * GOLDEN RULES OF THE WHERE CLAUSE
 * ======================================================================
 *
 * 1. ✅ WHERE is the gatekeeper — every row is evaluated individually.
 *       A condition that is TRUE lets the row through; FALSE blocks it.
 *
 * 2. ✅ WHERE always runs before SELECT — you can filter on any column
 *       in the table, even if that column does not appear in your
 *       SELECT list.
 *
 * 3. ❌ Never use an alias (AS) inside WHERE — the alias is created in
 *       SELECT, which runs after WHERE. The database will not
 *       recognise it and will throw an error. Use the real column name.
 *
 * 4. ✅ Always use single quotes around text values — no quotes around
 *       numbers. Mixing these up causes errors or silent wrong results.
 *
 * 5. ✅ Always match text values exactly — most databases are case
 *       sensitive. 'oceania' will not match 'Oceania'.
 *
 * 6. ❌ Never put quotes around a number — the database may treat it
 *       as text and perform a string comparison instead of a numeric
 *       one, leading to slow queries or incorrect results.
 *
 * 7. ✅ Use WHERE to filter early and filter aggressively — the fewer
 *       rows the database has to carry forward into SELECT and beyond,
 *       the faster your query runs.
 *
 * ======================================================================
 */