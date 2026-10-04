/**
 * Deep Dive — Arithmetic Operators:
 * 1. Operator Overview       : The 6 arithmetic operators and their meanings
 * 2. Operators on Table Data : Applying math directly to columns
 * 3. Calculating Density     : A real derived-value use case
 * 4. Division by Zero        : The hidden danger in numeric queries
 * 5. Safe Division (NULLIF)  : The production-safe pattern
 * 6. NULLIF Beyond Numbers   : Handling empty strings the same way
 */


/**
 * ARITHMETIC OPERATORS — Performing math inside queries
 *
 * What are arithmetic operators?
 * ─────────────────────────────────────────────────────────────────────
 * Arithmetic operators let you compute values directly inside a query.
 * They work on numeric column values, literal numbers, or a mix of
 * both — and the database calculates the result for every single row
 * automatically, without any loops or application code.
 *
 * ┌──────────────────────┬─────────────────────────────────────┬──────────────────────────────┐
 * │ Operator             │ Definition                          │ Example Query                │
 * ├──────────────────────┼─────────────────────────────────────┼──────────────────────────────┤
 * │ + (Addition)         │ Adds two numbers or expressions     │ SELECT 10 + 5 AS result;     │
 * │ - (Subtraction)      │ Subtracts second from the first     │ SELECT 10 - 5 AS result;     │
 * │ * (Multiplication)   │ Multiplies two numbers              │ SELECT 10 * 5 AS result;     │
 * │ / (Division)         │ Divides the first by the second     │ SELECT 10 / 5 AS result;     │
 * │ % (Modulus)          │ Returns remainder after division    │ SELECT 10 % 3 AS remainder;  │
 * │ DIV (Integer div)    │ MySQL only — quotient, no decimals  │ SELECT 7 DIV 2 AS quotient;  │
 * └──────────────────────┴─────────────────────────────────────┴──────────────────────────────┘
 *
 * These operators are straightforward and appear constantly in
 * real queries — for pricing calculations, inventory reports,
 * analytics, and any situation where you need a derived value.
 */


/**
 * THE SAMPLE TABLE — countries
 *
 * The examples below use a countries table.
 *
 * +-----------+------------+---------+---------------+
 * | country   | population | area    | region        |
 * +-----------+------------+---------+---------------+
 * | India     | 1400000000 | 3287000 | Asia          |
 * | China     | 1200000000 | 4287000 | Asia          |
 * | Brazil    |  214000000 | 8516000 | South America |
 * | Australia |   25700000 | 7692000 | Oceania       |
 * | USA       |  331000000 | 9834000 | North America |
 * +-----------+------------+---------+---------------+
 */


/**
 * ARITHMETIC ON TABLE DATA — Applying operators to columns
 *
 * Arithmetic operators become truly powerful when applied to table
 * columns. Instead of computing a fixed number, the database runs
 * the calculation on every row and returns the result inline —
 * no extra code required.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Divide every country's population by 2                          │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT country, population / 2                                │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+------------------+                                │
 * │ | country   | population / 2   |                                │
 * │ +-----------+------------------+                                │
 * │ | India     |        700000000 |                                │
 * │ | China     |        600000000 |                                │
 * │ | Brazil    |        107000000 |                                │
 * │ | Australia |         12850000 |                                │
 * │ | USA       |        165500000 |                                │
 * │ +-----------+------------------+                                │
 * │                                                                 │
 * │ The database divides population by 2 for every row instantly.   │
 * │ The original table is not changed — this is a computed result.  │
 * │                                                                 │
 * │ ⭐ Always use AS to give computed columns a clean header. ⭐   │
 * │    Without AS, the header shows the raw formula (population/2)  │
 * │    which is unreadable in reports and application output.       │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * REAL USE CASE — Calculating population density
 *
 * Density = population / area
 *
 * This is a classic derived value — it does not exist as a column in
 * the table, but can be computed on the fly for every row.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Calculate population density (people per sq km) for each country│
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT country, population / area AS density                  │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+---------+                                         │
 * │ | country   | density |                                         │
 * │ +-----------+---------+                                         │
 * │ | India     |     426 |                                         │
 * │ | China     |     279 |                                         │
 * │ | Brazil    |      25 |                                         │
 * │ | Australia |       3 |                                         │
 * │ | USA       |      33 |                                         │
 * │ +-----------+---------+                                         │
 * │                                                                 │
 * │ The density column is computed dynamically at query time.       │
 * │ Nothing is stored or altered in the original table.             │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * THE PROBLEM — Division by zero
 *
 * Any time you divide a column by another column, there is a hidden
 * risk: what if the divisor column contains a zero?
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ What happens if area = 0 in any row?                            │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT country, population / area AS density                  │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │   SHOW WARNINGS;                                                │
 * │                                                                 │
 * │ Behaviour:                                                      │
 * │   MySQL does NOT crash — it returns NULL for that row.          │
 * │   But it throws a warning: "Division by 0"                      │
 * │                                                                 │
 * │   Warning: 1365 Division by 0                                   │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ⚠️  Why warnings are dangerous in production:
 *   - Warnings are silent — they do not stop the query from running.
 *   - Rows affected return NULL without telling the end user.
 *   - In financial, scientific, or medical systems, a silent NULL
 *     where a number was expected can cause serious downstream errors.
 *   - Accumulated warnings in logs are a sign of a fragile query that
 *     will break under real data conditions.
 *
 * The fix is to guard against zero before the division happens.
 */


/**
 * THE SOLUTION — Safe division with NULLIF
 *
 * What is NULLIF?
 * ─────────────────────────────────────────────────────────────────────
 * NULLIF(expression, value) compares two values. If they are equal,
 * it returns NULL. If they are not equal, it returns the original
 * expression unchanged.
 *
 *   NULLIF(area, 0)
 *     → If area = 0  → returns NULL
 *     → If area ≠ 0  → returns area as-is
 *
 * Dividing by NULL produces NULL — no warning, no crash.
 * This is the correct, production-safe approach.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Safe density calculation — guarded against division by zero     │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT country,                                               │
 * │          population / NULLIF(area, 0) AS density                │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │   SHOW WARNINGS;                                                │
 * │                                                                 │
 * │ What happens:                                                   │
 * │   area ≠ 0  → NULLIF returns area → division runs normally      │
 * │   area = 0  → NULLIF returns NULL → result is NULL, no warning  │
 * │                                                                 │
 * │ No division by zero warning is thrown.                          │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * How NULLIF works step by step:
 *
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ Step │ What happens                                              │
 * ├──────────────────────────────────────────────────────────────────┤
 * │  1   │ NULLIF checks if area equals 0                            │
 * │  2   │ If yes  → replaces area with NULL                         │
 * │  3   │ If no   → keeps area as its original value                │
 * │  4   │ population / NULL = NULL (safe, no warning)               │
 * │  5   │ population / area = normal result (for non-zero rows)     │
 * └──────────────────────────────────────────────────────────────────┘
 */


/**
 * NULLIF BEYOND NUMBERS — Handling empty strings
 *
 * NULLIF is not limited to preventing division by zero on numbers.
 * It works on any data type — including text. A common real-world
 * problem is distinguishing between a NULL value and an empty string.
 * Many forms and data imports store missing data as '' rather than
 * NULL, which can cause filtering and reporting issues.
 *
 * NULLIF converts those empty strings into proper NULLs so the
 * rest of your query treats them correctly.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Convert empty city values to NULL                               │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT NULLIF(city, '')                                       │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ What happens:                                                   │
 * │   city = ''         → returns NULL  (empty string normalised)   │
 * │   city = 'Delhi'    → returns 'Delhi' (non-empty unchanged)     │
 * │                                                                 │
 * │ This is useful when data comes from external sources or forms   │
 * │ that store missing values as empty strings instead of NULL.     │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * Pattern summary — NULLIF works on any type:
 *
 * ┌──────────────────────────────────────────────────────────────────┐
 * │ NULLIF(area, 0)       → Numeric: guard against zero divisor      │
 * │ NULLIF(city, '')      → Text:    normalise empty strings to NULL │
 * │ NULLIF(status, 'N/A') → Text:    treat placeholder as missing    │
 * └──────────────────────────────────────────────────────────────────┘
 */


/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: Add a flat shipping cost to every product price
 *   SELECT product_name, price + 10 AS price_with_shipping
 *   FROM products;
 *   → Adds $10 to every row's price in the output
 *
 * Example 2: Apply a 10% discount across all products
 *   SELECT product_name, price * 0.9 AS discounted_price
 *   FROM products;
 *   → Computes 90% of price for every row
 *
 * Example 3: Calculate total inventory value per product
 *   SELECT product_name, price * stock_quantity AS total_value
 *   FROM products;
 *   → Multiplies two columns together for every row
 *
 * Example 4: Find the remainder when splitting stock into groups of 7
 *   SELECT product_name, stock_quantity % 7 AS leftover
 *   FROM products;
 *   → Returns how many units would be left after grouping in sevens
 *
 * Example 5: Integer division — how many full boxes of 10 fit in stock?
 *   SELECT product_name, stock_quantity DIV 10 AS full_boxes
 *   FROM products;
 *   → MySQL only — drops the decimal and returns the whole number
 *
 * Example 6: Safe density calculation with zero guard
 *   SELECT country, population / NULLIF(area, 0) AS density
 *   FROM countries;
 *   → Returns density normally, returns NULL for any row where area = 0
 *
 * Example 7: Normalise empty status labels to NULL
 *   SELECT product_name, NULLIF(status, '') AS clean_status
 *   FROM products;
 *   → Any row with an empty status string is returned as NULL instead
 */


/**
 * QUICK REFERENCE
 *
 * ARITHMETIC PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT col + 10 AS result FROM t;          → Add a constant
 * SELECT col - 5 AS result FROM t;           → Subtract a constant
 * SELECT col * 1.1 AS result FROM t;         → Multiply (e.g. 10% increase)
 * SELECT col / 2 AS result FROM t;           → Divide by a constant
 * SELECT col1 * col2 AS result FROM t;       → Multiply two columns
 * SELECT col1 / col2 AS result FROM t;       → Divide two columns
 * SELECT col % 3 AS remainder FROM t;        → Modulus (remainder)
 * SELECT col DIV 3 AS quotient FROM t;       → Integer division (MySQL)
 *
 * SAFE DIVISION PATTERN:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT col1 / NULLIF(col2, 0) AS result    → Safe — no zero warning
 * SELECT col1 / col2 AS result               → Unsafe — throws warning
 *                                               if col2 = 0
 *
 * NULLIF PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * NULLIF(col, 0)          → Returns NULL if col is 0, else col
 * NULLIF(col, '')         → Returns NULL if col is '', else col
 * NULLIF(col, 'N/A')      → Returns NULL if col is 'N/A', else col
 */


/**
 * GOLDEN RULES OF ARITHMETIC OPERATORS
 *
 * 1. ✅ Always use AS to name computed columns — without it, the
 *       column header displays the raw formula, which is unreadable
 *       in reports and application output.
 *
 * 2. ✅ Arithmetic in SELECT runs on every row automatically —
 *       you do not need loops or extra code. Let the database do
 *       the work.
 *
 * 3. ✅ Computed values are never stored — the original table is
 *       not changed. Results exist only in the query output.
 *
 * 4. ⚠️  Never divide one column by another without guarding against
 *       zero. If the divisor column ever contains 0, the query will
 *       silently return NULL with a warning — dangerous in production.
 *
 * 5. ✅ Always use NULLIF(col, 0) in the divisor position when
 *       dividing by a column. This is the production-safe standard
 *       pattern and produces no warnings even when zeros are present.
 *
 * 6. ✅ NULLIF works on any data type — use it to normalise empty
 *       strings, placeholder values, and zero divisors alike.
 *
 * 7. ✅ DIV is MySQL-only and returns an integer quotient with no
 *       decimals. Use standard / for cross-database compatibility.
 *
 */