/**
 * Deep Dive — Comparison Operators:
 * 1. Operator Overview       : The 6 comparison operators and their meanings
 * 2. Execution in Context    : Where comparisons fit in the query pipeline
 * 3. Greater Than (>)        : Finding premium or high-value items
 * 4. Less Than or Equal (<=) : Low stock alerts and range limits
 * 5. Not Equal (!= / <>)     : Excluding specific categories or values
 * 6. Common Mistakes         : Pitfalls every beginner hits
 */

/**
 * Comparison Operators:
 * > Use >, <, >=, <= operators to compare numeric values. 
 * > Our users' ages range from 25 to 45 years.
 * 
 * > Comparison operators work with numbers, dates, and even text. 
 * > > means "greater than".
 * > Use WHERE column_name > value
*/


/**
 * COMPARISON OPERATORS — The building blocks of filtering
 *
 * What are comparison operators?
 * ─────────────────────────────────────────────────────────────────────
 * Comparison operators allow the database to compare two values and
 * decide whether a row should be included in the result. They form
 * the foundation of filtering data in SQL and appear inside the
 * WHERE clause alongside column names and values.
 *
 * In previous sections, we only looked for exact matches using =.
 * But real-world questions are almost always about ranges:
 *   → "Which items cost MORE than $100?"
 *   → "Which products are running LOW on stock?"
 *   → "Show me everything EXCEPT Accessories."
 *
 * Comparison operators make all of these possible.
 *
 * ┌──────────┬──────────────────────────┬────────────────────────────┐
 * │ Operator │ Meaning                  │ Example                    │
 * ├──────────┼──────────────────────────┼────────────────────────────┤
 * │ <        │ Less than                │ population < 50000000      │
 * │ >        │ Greater than             │ salary > 30000             │
 * │ <=       │ Less than or equal to    │ age <= 18                  │
 * │ >=       │ Greater than or equal to │ marks >= 90                │
 * │ =        │ Equal to                 │ city = 'Delhi'             │
 * │ <> / !=  │ Not equal to             │ status != 'active'         │
 * └──────────┴──────────────────────────┴────────────────────────────┘
 *
 * Don't worry if these feel new — each operator is explored below
 * through practical, real-world inventory queries.
 *
 * Where they are used:
 *   Comparison operators are particularly valuable in:
 *   - Financial reporting   → Find transactions above a threshold
 *   - Inventory management  → Find items running low or out of stock
 *   - User analytics        → Filter users by age, score, or activity
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
 * CASE 1 — GREATER THAN (>): Finding premium products
 *
 * The > operator finds values that are STRICTLY larger than a number.
 * The boundary value itself is NOT included — if you filter price > 150,
 * a product priced at exactly 150 will be excluded.
 *
 * This is perfect for identifying high-end, luxury, or expensive items
 * that cross a pricing threshold.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Which products have a price greater than $150?                  │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, price                                    │
 * │   FROM products                                                 │
 * │   WHERE price > 150;                                            │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------------+-------+                                     │
 * │ | product_name    | price |                                     │
 * │ +-----------------+-------+                                     │
 * │ | Curved Monitor  |   300 |                                     │
 * │ | Ergonomic Chair |   250 |                                     │
 * │ +-----------------+-------+                                     │
 * │                                                                 │
 * │ Gaming Mouse ($50), Mechanical Keyboard ($120), and             │
 * │ USB-C Cable ($15) are all blocked — their prices are not        │
 * │ strictly greater than 150.                                      │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Related operators for price filtering:
 * ┌────────────────────────────────────────────────────────────────┐
 * │ WHERE price > 150    → Strictly above 150 (150 excluded)       │
 * │ WHERE price >= 150   → 150 and above (150 included)            │
 * │ WHERE price < 100    → Strictly below 100 (100 excluded)       │
 * │ WHERE price <= 100   → 100 and below (100 included)            │
 * └────────────────────────────────────────────────────────────────┘
 */


/**
 * CASE 2 — LESS THAN OR EQUAL TO (<=): Low stock alerts
 *
 * The <= operator finds values that are either SMALLER than OR EXACTLY
 * EQUAL TO a number. Unlike >, the boundary value IS included.
 *
 * This is the standard pattern for inventory management — catching
 * items that are at or below a restocking threshold.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ List all products with 50 or fewer units remaining in stock     │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, stock_quantity                           │
 * │   FROM products                                                 │
 * │   WHERE stock_quantity <= 50;                                   │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+----------------+                        │
 * │ | product_name        | stock_quantity |                        │
 * │ +---------------------+----------------+                        │
 * │ | Mechanical Keyboard |             50 |                        │
 * │ | Curved Monitor      |             20 |                        │
 * │ | Ergonomic Chair     |             10 |                        │
 * │ +---------------------+----------------+                        │
 * │                                                                 │
 * │ Mechanical Keyboard has exactly 50 units — it IS included       │
 * │ because <= catches the boundary value too.                      │
 * │ Gaming Mouse (100) and USB-C Cable (200) are blocked.           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ⭐ Key distinction — boundary inclusion:
 *
 * ┌──────────────────────────────────────────────────────────────┐
 * │ WHERE stock_quantity < 50   → Excludes 50 (strict)           │
 * │ WHERE stock_quantity <= 50  → Includes 50 (inclusive)        │
 * └──────────────────────────────────────────────────────────────┘
 *
 * This small difference matters a lot. If your restock threshold is
 * "50 or fewer," always use <= so items at exactly 50 are caught.
 */


/**
 * CASE 3 — NOT EQUAL TO (!= / <>): Excluding specific values
 *
 * Sometimes it is easier to tell the database what you do NOT want
 * rather than listing everything you do want. Both != and <> mean
 * "not equal to" — they are interchangeable in most databases.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Show all products except those in the Accessories category      │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category                                 │
 * │   FROM products                                                 │
 * │   WHERE category != 'Accessories';                              │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------------+-------------+                               │
 * │ | product_name    | category    |                               │
 * │ +-----------------+-------------+                               │
 * │ | Curved Monitor  | Electronics |                               │
 * │ | Ergonomic Chair | Furniture   |                               │
 * │ | USB-C Cable     | Cables      |                               │
 * │ +-----------------+-------------+                               │
 * │                                                                 │
 * │ Gaming Mouse and Mechanical Keyboard are both Accessories —     │
 * │ they are blocked. Every other category passes through.          │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * != vs <> — which should you use?
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ !=   → Widely supported, more readable, preferred in most DBs    │
 * │ <>   → SQL standard, supported everywhere including older DBs    │
 * │                                                                  │
 * │ Both produce identical results. Use != for modern databases      │
 * │ and <> when writing SQL that needs to run on legacy systems.     │
 * └──────────────────────────────────────────────────────────────────┘
 */


/**
 * COMMON MISTAKES TO AVOID
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 1 — Using == instead of =                               │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ In Python or Java, you compare values with a double equals (==).│
 * │ In SQL, you must use a single equals sign (=). A double equals  │
 * │ sign is not valid SQL and will cause a syntax error.            │
 * │                                                                 │
 * │   ❌ WHERE price == 50   → Syntax error in SQL                  │
 * │   ✅ WHERE price = 50    → Correct SQL comparison               │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ Mistake 2 — Putting quotes around numbers                        │
 * ├──────────────────────────────────────────────────────────────────┤
 * │ Writing WHERE price > '100' may work in some databases, but it   │
 * │ forces the database to first convert the text '100' into a       │
 * │ number before comparing — making the query slower.               │
 * │ Always keep numbers unquoted.                                    │
 * │                                                                  │
 * │   ❌ WHERE price > '100'  → Works sometimes, but causes slowdown │
 * │   ✅ WHERE price > 100    → Correct — numeric comparison         │
 * └──────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 3 — Writing the equals sign in the wrong order          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ For two-character operators like <= and >=, the equals sign     │
 * │ must always come SECOND. Reversing the order is a syntax error. │
 * │                                                                 │
 * │   ❌ WHERE stock_quantity =< 50  → Syntax error                 │
 * │   ✅ WHERE stock_quantity <= 50  → Correct                      │
 * │                                                                 │
 * │   ❌ WHERE price => 150          → Syntax error                 │
 * │   ✅ WHERE price >= 150          → Correct                      │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: Find all expensive products (over $200)
 *   SELECT product_name, price
 *   FROM products
 *   WHERE price > 200;
 *   → Returns Curved Monitor and Ergonomic Chair
 *
 * Example 2: Find affordable products ($50 or less)
 *   SELECT product_name, price
 *   FROM products
 *   WHERE price <= 50;
 *   → Returns Gaming Mouse ($50) and USB-C Cable ($15)
 *
 * Example 3: Find critically low stock (fewer than 20 units)
 *   SELECT product_name, stock_quantity
 *   FROM products
 *   WHERE stock_quantity < 20;
 *   → Returns Ergonomic Chair (10 units)
 *
 * Example 4: Exclude a specific price point
 *   SELECT product_name, price
 *   FROM products
 *   WHERE price != 50;
 *   → Returns everything except Gaming Mouse
 *
 * Example 5: Find all non-furniture items
 *   SELECT product_name, category
 *   FROM products
 *   WHERE category <> 'Furniture';
 *   → Returns all 4 products outside the Furniture category
 *
 * Example 6: Find countries with population at least 300 million
 *   SELECT country, population
 *   FROM countries
 *   WHERE population >= 300000000;
 *   → Returns India, China, and USA
 *
 * Example 7: Find countries smaller than 5 million sq km
 *   SELECT country, area
 *   FROM countries
 *   WHERE area < 5000000;
 *   → Returns India and China
 */


/**
 * QUICK REFERENCE
 *
 * OPERATOR PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * WHERE col > 100          → Strictly above 100 (100 excluded)
 * WHERE col >= 100         → 100 and above (100 included)
 * WHERE col < 50           → Strictly below 50 (50 excluded)
 * WHERE col <= 50          → 50 and below (50 included)
 * WHERE col = 'value'      → Exact match
 * WHERE col != 'value'     → Exclude a specific value
 * WHERE col <> 'value'     → Same as != (SQL standard form)
 *
 * BOUNDARY INCLUSION CHEATSHEET:
 * ─────────────────────────────────────────────────────────────────────
 * >   → Does NOT include the boundary value (strict)
 * <   → Does NOT include the boundary value (strict)
 * >=  → INCLUDES the boundary value
 * <=  → INCLUDES the boundary value
 *
 * COMMON USE CASES:
 * ─────────────────────────────────────────────────────────────────────
 * Price above threshold   → WHERE price > 150
 * Low stock alert         → WHERE stock_quantity <= 50
 * Out of stock            → WHERE stock_quantity = 0
 * Exclude a category      → WHERE category != 'Accessories'
 * Minimum score filter    → WHERE marks >= 90
 */


/**
 * GOLDEN RULES OF COMPARISON OPERATORS
 *
 * 1. ✅ Use > and < for strict range filtering — the boundary value
 *       is NOT included. Use >= and <= when the boundary must be
 *       included in the result.
 *
 * 2. ❌ Never use == in SQL — a single equals sign (=) is the correct
 *       comparison operator. Double equals is a syntax error.
 *
 * 3. ✅ Both != and <> mean "not equal to" and produce identical
 *       results. Use != for readability in modern databases and <>
 *       for maximum compatibility with older or legacy systems.
 *
 * 4. ❌ Never put quotes around numbers — write WHERE price > 100,
 *       not WHERE price > '100'. Quoted numbers may cause implicit
 *       type conversion and slow down your query.
 *
 * 5. ✅ For two-character operators (<=, >=), the equals sign always
 *       comes SECOND. Writing =< or => is a syntax error.
 *
 * 6. ✅ Comparison operators work on text too — WHERE city = 'Delhi'
 *       and WHERE category != 'Accessories' are valid text comparisons.
 *       Remember to wrap text values in single quotes.
 *
 * 7. ✅ These operators form the foundation of all WHERE filtering.
 *       Master them early — they appear in almost every SQL query you
 *       will ever write.
 */