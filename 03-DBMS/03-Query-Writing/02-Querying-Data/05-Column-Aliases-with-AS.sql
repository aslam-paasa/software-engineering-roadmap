/**
 * Column Aliases with AS:
 * > Rename columns in your result set for clarity. 
 * > Make output more readable with meaningful names.
 * 
 * > AS creates an alias - a temporary name for a column in the result. 
 * > The actual column names don't change in the database.
 * > Syntax: SELECT column1 AS alias1, column2 AS alias2 FROM table_name
*/

/**
 * Deep Dive — DISTINCT & AS (Aliases):
 * 1. Overview                 : What DISTINCT and AS do
 * 2. Unique Categories        : Removing duplicates with DISTINCT
 * 3. Renaming Columns         : Cleaner labels with AS
 * 4. Naming Calculated Columns: Always alias your computed results
 * 5. Common Mistakes          : Pitfalls every beginner hits
 */


/**
 * DISTINCT & AS — Removing duplicates and labelling output columns
 *
 * What do they do?
 * ─────────────────────────────────────────────────────────────────────
 * DISTINCT acts like a filter that squeezes your result so each unique
 * value appears only once. Without it, a column with repeated values
 * shows every single occurrence — including all duplicates.
 *
 * AS assigns a temporary, human-friendly nickname to a column in the
 * output. Database engineers often give columns short technical names
 * like prod_id or qty_on_hand that work for the computer but are not
 * useful in a business report. AS lets you rename them for clarity
 * without touching the actual database structure.
 *
 * ┌───────────────┬──────────────────────────────────────────────────┐
 * │ Keyword       │ Behaviour                                        │
 * ├───────────────┼──────────────────────────────────────────────────┤
 * │ DISTINCT      │ Removes duplicate rows from the result — each    │
 * │               │ unique value appears exactly once                │
 * │ AS alias      │ Gives a column or table a temporary nickname     │
 * │               │ in the output — does not change the database     │
 * └───────────────┴──────────────────────────────────────────────────┘
 *
 * Quick example — unique regions, renamed header:
 *
 *   SELECT DISTINCT region AS unique_region
 *   FROM countries;
 *
 * Output:
 * +---------------+
 * | unique_region |
 * +---------------+
 * | Asia          |
 * | South America |
 * | Oceania       |
 * | North America |
 * +---------------+
 *
 * Asia appears twice in the raw table (India + China) but DISTINCT
 * ensures it only shows up once. AS renames the header to unique_region.
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
 *
 * Notice: "Accessories" appears twice (rows 101 and 102).
 * DISTINCT is what prevents it from showing up twice in the output.
 */


/**
 * CASE 1 — DISTINCT: Finding unique values
 *
 * Without DISTINCT, selecting a column that has repeated values shows
 * every single occurrence. DISTINCT tells the database to deduplicate
 * the result — keep one row per unique value and discard the rest.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ What different product categories do we currently have?         │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Without DISTINCT — shows every row, including duplicates:       │
 * │                                                                 │
 * │   SELECT category FROM products;                                │
 * │                                                                 │
 * │   +-------------+                                               │
 * │   | category    |                                               │
 * │   +-------------+                                               │
 * │   | Accessories |   ← appears twice                             │
 * │   | Accessories |   ← duplicate                                 │
 * │   | Electronics |                                               │
 * │   | Furniture   |                                               │
 * │   | Cables      |                                               │
 * │   +-------------+                                               │
 * │                                                                 │
 * │ With DISTINCT — each category appears exactly once:             │
 * │                                                                 │
 * │   SELECT DISTINCT category                                      │
 * │   FROM products;                                                │
 * │                                                                 │
 * │   +-------------+                                               │
 * │   | category    |                                               │
 * │   +-------------+                                               │
 * │   | Accessories |                                               │
 * │   | Electronics |                                               │
 * │   | Furniture   |                                               │
 * │   | Cables      |                                               │
 * │   +-------------+                                               │
 * │                                                                 │
 * │ The second "Accessories" row is removed. All other categories   │
 * │ already appeared only once so they are unaffected.              │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * DISTINCT on multiple columns — unique pairs:
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ SELECT DISTINCT category, price FROM products;                   │
 * │                                                                  │
 * │ The database looks for unique category + price combinations.     │
 * │ A row is only removed if BOTH values match another row exactly.  │
 * │ Two rows with the same category but different prices will both   │
 * │ appear in the result.                                            │
 * └──────────────────────────────────────────────────────────────────┘
 */


/**
 * CASE 2 — AS: Renaming columns for better clarity
 *
 * AS assigns a temporary label to any column in the output. This label
 * exists only for the duration of the query — it does not rename the
 * column in the actual database. The real column name remains unchanged.
 *
 * This is especially useful when column names are technical, abbreviated,
 * or unclear to people reading a report.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ List products and prices, labelled "Item" and "Price_USD"       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name AS Item, price AS Price_USD               │
 * │   FROM products;                                                │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-----------+                             │
 * │ | Item                | Price_USD |                             │
 * │ +---------------------+-----------+                             │
 * │ | Gaming Mouse        |        50 |                             │
 * │ | Mechanical Keyboard |       120 |                             │
 * │ | Curved Monitor      |       300 |                             │
 * │ | Ergonomic Chair     |       250 |                             │
 * │ | USB-C Cable         |        15 |                             │
 * │ +---------------------+-----------+                             │
 * │                                                                 │
 * │ The headers read "Item" and "Price_USD" instead of              │
 * │ "product_name" and "price". The table in the database is        │
 * │ completely unchanged.                                           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Alias naming rules:
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ ✅ Use underscores for multi-word aliases: Price_USD, Item_Name  │
 * │ ✅ Wrap spaces in quotes if needed: AS "Product Name"            │
 * │ ✅ Prefer underscores over spaces to avoid compatibility issues  │
 * │ ✅ Aliases are case-sensitive in some databases — be consistent  │
 * └──────────────────────────────────────────────────────────────────┘
 */


/**
 * CASE 3 — NAMING CALCULATED COLUMNS: Always alias your computations
 *
 * When you multiply, divide, or otherwise compute a value in SELECT,
 * the database does not have a meaningful default name for the result.
 * It generates a placeholder like "price * stock_quantity" as the
 * header — unreadable in a report or application output.
 *
 * Always use AS to give every computed column a clean, descriptive name.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Calculate total inventory value per product                     │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name,                                          │
 * │          price * stock_quantity AS Inventory_Value              │
 * │   FROM products;                                                │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-----------------+                       │
 * │ | product_name        | Inventory_Value |                       │
 * │ +---------------------+-----------------+                       │
 * │ | Gaming Mouse        |            5000 |                       │
 * │ | Mechanical Keyboard |            6000 |                       │
 * │ | Curved Monitor      |            6000 |                       │
 * │ | Ergonomic Chair     |            2500 |                       │
 * │ | USB-C Cable         |            3000 |                       │
 * │ +---------------------+-----------------+                       │
 * │                                                                 │
 * │ Without AS, the header would display "price * stock_quantity"   │
 * │ — technically correct but useless for any real report or app.   │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ⭐ Once you name a calculated column with AS, you can reference that
 *    alias in ORDER BY to sort by it — one of the few places where an
 *    alias defined in SELECT is available:
 *
 *   SELECT product_name, price * stock_quantity AS Inventory_Value
 *   FROM products
 *   ORDER BY Inventory_Value DESC;
 *   → Sorted from highest to lowest total stock value
 */


/**
 * COMMON MISTAKES TO AVOID
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 1 — Placing DISTINCT in the wrong position              │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ DISTINCT must appear immediately after SELECT — before any      │
 * │ column names. Placing it in the middle of a column list causes  │
 * │ a syntax error.                                                 │
 * │                                                                 │
 * │   ❌ SELECT category, DISTINCT price FROM products; ❌         │
 * │      → Syntax error — DISTINCT cannot go mid-list               │
 * │                                                                 │
 * │   ✅ SELECT DISTINCT category FROM products;        ✅         │
 * │      → Correct — DISTINCT is immediately after SELECT           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 2 — Using an alias in a WHERE clause                    │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ You cannot use an AS nickname inside WHERE. Aliases are created │
 * │ in SELECT, which runs AFTER WHERE in the execution order. The   │
 * │ database has not seen your alias yet when it filters rows.      │
 * │                                                                 │
 * │   ❌ SELECT price AS cost FROM products WHERE cost > 100;  ❌  │
 * │      → "cost" is unknown at WHERE time → error                  │
 * │                                                                 │
 * │   ✅ SELECT price AS cost FROM products WHERE price > 100; ✅  │
 * │      → Use the real column name in WHERE                        │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 3 — Misunderstanding DISTINCT on multiple columns       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ DISTINCT on two columns deduplicates based on the combination   │
 * │ of BOTH values together — not each column independently.        │
 * │ A row is only removed if every selected column matches another  │
 * │ row exactly.                                                    │
 * │                                                                 │
 * │   SELECT DISTINCT category, price FROM products;                │
 * │   → Two rows with the same category but different prices are    │
 * │     both kept — the pair is unique even if category is not      │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 4 — Using spaces in alias names without quotes          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ An alias with a space must be wrapped in quotes, otherwise the  │
 * │ database misreads it as two separate tokens and throws an error.│
 * │ The safer habit is to use underscores instead.                  │
 * │                                                                 │
 * │   ❌ SELECT price AS Price USD FROM products;              ❌  │
 * │      → "USD" is read as an unexpected extra keyword → error     │
 * │                                                                 │
 * │   ✅ SELECT price AS "Price USD" FROM products;            ✅  │
 * │      → Quoted — works, but uncommon                             │
 * │   ✅ SELECT price AS Price_USD FROM products;              ✅  │
 * │      → Underscore — the cleaner, universally safe approach      │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: List all unique regions from the countries table
 *   SELECT DISTINCT region
 *   FROM countries;
 *   → Returns Asia, South America, Oceania, North America (no duplicates)
 *
 * Example 2: List all unique regions with a renamed header
 *   SELECT DISTINCT region AS unique_region
 *   FROM countries;
 *   → Same result, header reads "unique_region" instead of "region"
 *
 * Example 3: Rename technical column names for a report
 *   SELECT product_name AS Item,
 *          stock_quantity AS Units_In_Stock
 *   FROM products;
 *   → Friendlier headers without changing the database
 *
 * Example 4: Calculate and name a derived column
 *   SELECT product_name,
 *          price * 0.9 AS Discounted_Price
 *   FROM products;
 *   → Shows 10% off prices under a clean alias
 *
 * Example 5: Calculate, name, then sort by the alias
 *   SELECT product_name,
 *          price * stock_quantity AS Inventory_Value
 *   FROM products
 *   ORDER BY Inventory_Value DESC;
 *   → Sorted highest to lowest — alias used in ORDER BY
 *
 * Example 6: DISTINCT on two columns — unique category + price pairs
 *   SELECT DISTINCT category, price
 *   FROM products;
 *   → Returns all 5 rows — each category + price pair is already unique
 *
 * Example 7: Combine DISTINCT with ORDER BY
 *   SELECT DISTINCT region AS unique_region
 *   FROM countries
 *   ORDER BY unique_region ASC;
 *   → Unique regions sorted alphabetically: Asia, North America,
 *     Oceania, South America
 */


/**
 * QUICK REFERENCE
 *
 * DISTINCT PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT DISTINCT col FROM t;              → Unique values in one column
 * SELECT DISTINCT col1, col2 FROM t;       → Unique col1 + col2 pairs
 * SELECT DISTINCT col AS alias FROM t;     → Unique values, renamed header
 *
 * AS (ALIAS) PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT col AS alias FROM t;              → Rename a column in output
 * SELECT col1 AS a, col2 AS b FROM t;      → Rename multiple columns
 * SELECT col * 2 AS doubled FROM t;        → Name a calculated column
 * SELECT col AS "My Label" FROM t;         → Alias with a space (quoted)
 * SELECT col AS My_Label FROM t;           → Alias with underscore (safer)
 *
 * WHERE ALIASES ARE VALID:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT  → alias defined here
 * WHERE   → ❌ alias NOT available (WHERE runs before SELECT)
 * ORDER BY→ ✅ alias available (ORDER BY runs after SELECT)
 * HAVING  → ✅ alias available in most databases
 */


/**
 * GOLDEN RULES OF DISTINCT & AS
 *
 * 1. ✅ DISTINCT must come immediately after SELECT — it applies to
 *       all selected columns at once, not to a single column in the
 *       middle of a list.
 *
 * 2. ✅ DISTINCT on multiple columns deduplicates based on the full
 *       combination of all selected values — not each column alone.
 *       Two rows are only removed if every column matches exactly.
 *
 * 3. ✅ Use AS on every computed or calculated column — without it,
 *       the header displays the raw formula, which is unreadable in
 *       any real report or application output.
 *
 * 4. ❌ Never use an alias in a WHERE clause — aliases are created
 *       in SELECT, which runs after WHERE. The database does not know
 *       the alias yet when it is filtering rows. Use the real column
 *       name in WHERE.
 *
 * 5. ✅ Aliases are available in ORDER BY — use them freely to sort
 *       by computed columns without repeating the full formula.
 *
 * 6. ✅ Use underscores in alias names instead of spaces — it avoids
 *       quoting requirements and works consistently across all databases.
 *
 * 7. ✅ AS does not change the database — aliases are temporary and
 *       exist only in the query output. The real column names and table
 *       structure are never touched.
 */