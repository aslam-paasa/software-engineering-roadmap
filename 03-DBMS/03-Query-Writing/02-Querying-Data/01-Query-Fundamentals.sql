/**
 * Basic SQL Commands:
 * 1. SELECT          : Which columns to show
 * 2. FROM            : Where to read from
 * 3. WHERE           : Which rows to keep
 * 4. Comparison Ops  : Filter rows using <, >, =, !=, etc.
 * 5. Logical Ops     : Combine conditions with AND, OR, NOT
 * 6. Arithmetic Ops  : Perform math on column values
 * 7. ORDER BY/LIMIT  : How to sort and how many rows to return
 * 8. DISTINCT        : Remove duplicate values
 * 9. AS (Alias)      : Rename columns or tables in the output
 */


/**
 * SQL BASICS — Querying and Filtering Data
 *
 * What is SQL?
 * ─────────────────────────
 * SQL (Structured Query Language) is the standard language for
 * interacting with relational databases. It lets you create tables,
 * insert data, and retrieve or manipulate that data using queries.
 *
 * Why does it matter?
 * ─────────────────────────
 * - You control exactly which data you see — which columns, which rows.
 * - You can filter, sort, and limit results without loading everything.
 * - Queries are declarative — you describe WHAT you want, not HOW to
 *   get it. The database engine figures out the rest.
 * - It is the foundation of every data-driven application.
 *
 * Topics covered:
 * 1. Setting Up — CREATE TABLE & INSERT
 * 2. SELECT & FROM
 * 3. WHERE
 * 4. Comparison Operators
 * 5. Logical Operators (AND, OR, NOT)
 * 6. Arithmetic Operators
 * 7. ORDER BY & LIMIT
 * 8. DISTINCT & AS (Aliases)
 * 9. Practical Examples
 * 10. Quick Reference
 * 11. Golden Rules
 */


/**
 * SETTING UP — Creating a table and inserting data
 *
 * Before writing SELECT queries, you need a table to query.
 * The examples throughout these notes use the countries table below.
 *
 * CREATE TABLE:
 */

CREATE TABLE countries (
  id         SERIAL       PRIMARY KEY,
  country    VARCHAR(64)  NOT NULL,
  population BIGINT,
  area       INT          NOT NULL,
  region     VARCHAR(64)  NOT NULL
);

/**
 * INSERT DATA:
 */

INSERT INTO countries (country, population, area, region) VALUES
  ('India',      1400000000, 3287000, 'Asia'),
  ('China',      1200000000, 4287000, 'Asia'),
  ('Brazil',      214000000, 8516000, 'South America'),
  ('Australia',    25700000, 7692000, 'Oceania'),
  ('USA',         331000000, 9834000, 'North America');

/**
 * Resulting table — countries:
 *
 * +----+-----------+------------+---------+---------------+
 * | id | country   | population | area    | region        |
 * +----+-----------+------------+---------+---------------+
 * |  1 | India     | 1400000000 | 3287000 | Asia          |
 * |  2 | China     | 1200000000 | 4287000 | Asia          |
 * |  3 | Brazil    |  214000000 | 8516000 | South America |
 * |  4 | Australia |   25700000 | 7692000 | Oceania       |
 * |  5 | USA       |  331000000 | 9834000 | North America |
 * +----+-----------+------------+---------+---------------+
 */


/**
 * SELECT & FROM — Choosing what to show and where to read from
 *
 * What they do:
 *   SELECT  → Specifies which columns you want to retrieve.
 *             Without SELECT, SQL does not know what data to show.
 *   FROM    → Specifies which table to read the data from.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ a. Select ALL columns from a table                              │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Use * to return every column without naming them individually.  │
 * │                                                                 │
 * │   SELECT *                                                      │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +----+-----------+------------+---------+---------------+       │
 * │ | id | country   | population | area    | region        |       │
 * │ +----+-----------+------------+---------+---------------+       │
 * │ |  1 | India     | 1400000000 | 3287000 | Asia          |       │
 * │ |  2 | China     | 1200000000 | 4287000 | Asia          |       │
 * │ |  3 | Brazil    |  214000000 | 8516000 | South America |       │
 * │ |  4 | Australia |   25700000 | 7692000 | Oceania       |       │
 * │ |  5 | USA       |  331000000 | 9834000 | North America |       │
 * │ +----+-----------+------------+---------+---------------+       │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ b. Select SPECIFIC columns                                      │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ List only the column names you need, separated by commas.       │
 * │                                                                 │
 * │   SELECT country, population                                    │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+------------+                                      │
 * │ | country   | population |                                      │
 * │ +-----------+------------+                                      │
 * │ | India     | 1400000000 |                                      │
 * │ | China     | 1200000000 |                                      │
 * │ | Brazil    |  214000000 |                                      │
 * │ | Australia |   25700000 |                                      │
 * │ | USA       |  331000000 |                                      │
 * │ +-----------+------------+                                      │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * WHERE — Filtering rows with conditions
 *
 * What it does:
 *   WHERE restricts rows by applying one or more logical conditions.
 *   Only rows that satisfy the condition(s) are included in the result.
 *   Think of WHERE as a gatekeeper — it decides which rows are allowed
 *   to pass through to the output.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Filter rows where region equals 'Oceania'                       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT *                                                      │
 * │   FROM countries                                                │
 * │   WHERE region = 'Oceania';                                     │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+----------+---------+---------+                    │
 * │ | country   | population | area  | region  |                    │
 * │ +-----------+----------+---------+---------+                    │
 * │ | Australia |  25700000 | 7692000 | Oceania |                   │
 * │ +-----------+----------+---------+---------+                    │
 * │                                                                 │
 * │ WHERE decides which rows are allowed to stay.                   │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * COMPARISON OPERATORS — The building blocks of filtering
 *
 * Comparison operators form the foundation of every WHERE condition.
 * They compare a column value against a literal or another column.
 *
 * ┌──────────┬──────────────────────────┬───────────────────────────┐
 * │ Operator │ Meaning                  │ Example                   │
 * ├──────────┼──────────────────────────┼───────────────────────────┤
 * │ <        │ Less than                │ population < 50000000     │
 * │ >        │ Greater than             │ salary > 30000            │
 * │ <=       │ Less than or equal to    │ age <= 18                 │
 * │ >=       │ Greater than or equal to │ marks >= 90               │
 * │ =        │ Equal to                 │ city = 'Delhi'            │
 * │ <> / !=  │ Not equal to             │ status != 'active'        │
 * └──────────┴──────────────────────────┴───────────────────────────┘
 *
 * These operators are used directly inside WHERE conditions and are
 * frequently combined with logical operators (AND, OR, NOT).
 */


/**
 * LOGICAL OPERATORS — Combining and modifying conditions
 *
 * AND, OR, and NOT let you build complex multi-condition filters
 * inside a WHERE clause.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ AND — ALL conditions must be true                               │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Find countries where population > 50M AND area < 5M sq km.      │
 * │                                                                 │
 * │   SELECT *                                                      │
 * │   FROM countries                                                │
 * │   WHERE population > 50000000 AND area < 5000000;               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+------------+---------+--------+                   │
 * │ | country   | population | area    | region |                   │
 * │ +-----------+------------+---------+--------+                   │
 * │ | India     | 1400000000 | 3287000 | Asia   |                   │
 * │ +-----------+------------+---------+--------+                   │
 * │                                                                 │
 * │ India is the only country satisfying BOTH conditions.           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ OR — AT LEAST ONE condition must be true                        │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Find countries located in Asia OR Oceania.                      │
 * │                                                                 │
 * │   SELECT *                                                      │
 * │   FROM countries                                                │
 * │   WHERE region = 'Asia' OR region = 'Oceania';                  │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+------------+---------+---------+                  │
 * │ | country   | population | area    | region  |                  │
 * │ +-----------+------------+---------+---------+                  │
 * │ | India     | 1400000000 | 3287000 | Asia    |                  │
 * │ | China     | 1200000000 | 4287000 | Asia    |                  │
 * │ | Australia |   25700000 | 7692000 | Oceania |                  │
 * │ +-----------+------------+---------+---------+                  │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ NOT — Negates a condition                                       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Exclude all countries where region is 'North America'.          │
 * │                                                                 │
 * │   SELECT *                                                      │
 * │   FROM countries                                                │
 * │   WHERE NOT region = 'North America';                           │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+------------+---------+---------------+            │
 * │ | country   | population | area    | region        |            │
 * │ +-----------+------------+---------+---------------+            │
 * │ | India     | 1400000000 | 3287000 | Asia          |            │
 * │ | China     | 1200000000 | 4287000 | Asia          |            │
 * │ | Brazil    |  214000000 | 8516000 | South America |            │
 * │ | Australia |   25700000 | 7692000 | Oceania       |            │
 * │ +-----------+------------+---------+---------------+            │
 * │                                                                 │
 * │ USA is excluded because its region IS 'North America'.          │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * ARITHMETIC OPERATORS — Performing math inside queries
 *
 * Arithmetic operators let you compute values directly inside a query.
 * They work on numeric column values or literal numbers.
 *
 * ┌────────────────┬──────────────────────────────────────┬──────────────────────────────┐
 * │ Operator       │ Definition                           │ Example Query                │
 * ├────────────────┼──────────────────────────────────────┼──────────────────────────────┤
 * │ + (Addition)   │ Adds two numbers or expressions      │ SELECT 10 + 5 AS result;     │
 * │ - (Subtraction)│ Subtracts the second from the first  │ SELECT 10 - 5 AS result;     │
 * │ * (Multiply)   │ Multiplies two numbers or expressions│ SELECT 10 * 5 AS result;     │
 * │ / (Division)   │ Divides the first by the second      │ SELECT 10 / 5 AS result;     │
 * │ % (Modulus)    │ Returns the remainder after division │ SELECT 10 % 3 AS remainder;  │
 * │ DIV            │ MySQL only: quotient without decimals│ SELECT 7 DIV 2 AS quotient;  │
 * └────────────────┴──────────────────────────────────────┴──────────────────────────────┘
 *
 * These operators are commonly used to calculate derived values, such as
 * population density (population / area) or percentage growth.
 *
 * Example — calculate population density per sq km:
 *
 *   SELECT country, population / area AS density_per_sqkm
 *   FROM countries
 *   ORDER BY density_per_sqkm DESC;
 */


/**
 * ORDER BY & LIMIT — Sorting results and capping row count
 *
 * What they do:
 *   ORDER BY → Sorts the result set based on one or more columns.
 *              Default is ASC (ascending: small → large, A → Z).
 *              Add DESC to reverse the order (large → small, Z → A).
 *
 *   LIMIT    → Returns only a fixed number of rows from the top of
 *              the result. Useful for "top N" queries.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Find the top 2 countries by land area (largest first)           │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Step 1: Sort by area from largest to smallest (DESC).           │
 * │ Step 2: Return only the top 2 rows (LIMIT 2).                   │
 * │                                                                 │
 * │   SELECT country, area                                          │
 * │   FROM countries                                                │
 * │   ORDER BY area DESC                                            │
 * │   LIMIT 2;                                                      │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------+---------+                                           │
 * │ | country | area    |                                           │
 * │ +---------+---------+                                           │
 * │ | USA     | 9834000 |                                           │
 * │ | Brazil  | 8516000 |                                           │
 * │ +---------+---------+                                           │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ OFFSET — Skip rows before starting to return results            │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ OFFSET is used together with LIMIT to paginate results.         │
 * │                                                                 │
 * │ To get rows 3–4 (skip the first 2, then take the next 2):       │
 * │                                                                 │
 * │   SELECT country, area                                          │
 * │   FROM countries                                                │
 * │   ORDER BY area DESC                                            │
 * │   LIMIT 2 OFFSET 2;                                             │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------+---------+                                         │
 * │ | country   | area    |                                         │
 * │ +-----------+---------+                                         │
 * │ | Australia | 7692000 |                                         │
 * │ | China     | 4287000 |                                         │
 * │ +-----------+---------+                                         │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * DISTINCT & AS — Removing duplicates and renaming output columns
 *
 * DISTINCT:
 *   Used when you want only unique values from a column.
 *   It removes any duplicate rows from the selected output.
 *
 * AS (Alias):
 *   Assigns a temporary, readable name to a column or table in the
 *   output. It does NOT change the actual database structure —
 *   it only affects how the result is displayed.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Find all unique regions and rename the column in the output     │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT DISTINCT region AS unique_region                       │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------+                                               │
 * │ | unique_region |                                               │
 * │ +---------------+                                               │
 * │ | Asia          |                                               │
 * │ | South America |                                               │
 * │ | Oceania       |                                               │
 * │ | North America |                                               │
 * │ +---------------+                                               │
 * │                                                                 │
 * │ Asia appears twice in the table (India + China) but DISTINCT    │
 * │ ensures it only appears once in the result.                     │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ AS on a calculated column                                       │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Without AS, SQL would display the formula itself as the header. │
 * │ AS gives the result a clean, readable name.                     │
 * │                                                                 │
 * │   SELECT country, population / area AS density                  │
 * │   FROM countries;                                               │
 * │                                                                 │
 * │ Output column header shows "density" instead of                 │
 * │ "population / area".                                            │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: See all data in the table
 *   SELECT *
 *   FROM countries;
 *   → Returns every column and every row
 *
 * Example 2: Find countries in Asia with population over 1 billion
 *   SELECT country, population
 *   FROM countries
 *   WHERE region = 'Asia' AND population > 1000000000;
 *   → Returns India and China
 *
 * Example 3: Find the 3 smallest countries by area
 *   SELECT country, area
 *   FROM countries
 *   ORDER BY area ASC
 *   LIMIT 3;
 *   → Returns India, China, Australia (in ascending area order)
 *
 * Example 4: List all regions without duplicates
 *   SELECT DISTINCT region
 *   FROM countries;
 *   → Returns Asia, South America, Oceania, North America (4 rows)
 *
 * Example 5: Calculate population density for each country
 *   SELECT country, population / area AS density_per_sqkm
 *   FROM countries
 *   ORDER BY density_per_sqkm DESC;
 *   → Highest density countries appear first
 *
 * Example 6: Find countries that are NOT in Asia
 *   SELECT *
 *   FROM countries
 *   WHERE NOT region = 'Asia';
 *   → Returns Brazil, Australia, USA
 *
 * Example 7: Find mid-range countries by population (50M to 400M)
 *   SELECT country, population
 *   FROM countries
 *   WHERE population >= 50000000 AND population <= 400000000;
 *   → Returns Brazil and USA
 *
 * Example 8: Paginate results — show rows 3 to 4 by area
 *   SELECT country, area
 *   FROM countries
 *   ORDER BY area DESC
 *   LIMIT 2 OFFSET 2;
 *   → Skips the 2 largest, returns the next 2
 */


/**
 * QUICK REFERENCE
 *
 * SELECTING DATA:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT * FROM table;                    → All columns, all rows
 * SELECT col1, col2 FROM table;           → Specific columns
 * SELECT DISTINCT col FROM table;         → Unique values only
 * SELECT col AS alias FROM table;         → Rename column in output
 *
 * FILTERING WITH WHERE:
 * ─────────────────────────────────────────────────────────────────────
 * WHERE col = 'value'                     → Exact match
 * WHERE col != 'value'                    → Exclude a value
 * WHERE col > 100                         → Greater than
 * WHERE col BETWEEN 10 AND 50             → Range filter
 * WHERE col1 = 'x' AND col2 > 100        → Both must be true
 * WHERE col1 = 'x' OR col1 = 'y'         → Either can be true
 * WHERE NOT col = 'x'                     → Exclude a condition
 *
 * SORTING & LIMITING:
 * ─────────────────────────────────────────────────────────────────────
 * ORDER BY col ASC                        → Sort A→Z or small→large
 * ORDER BY col DESC                       → Sort Z→A or large→small
 * ORDER BY col1 ASC, col2 DESC            → Sort by multiple columns
 * LIMIT 10                               → Return top 10 rows only
 * LIMIT 10 OFFSET 20                     → Skip 20, return next 10
 *
 * ARITHMETIC:
 * ─────────────────────────────────────────────────────────────────────
 * SELECT col + 100 FROM table;            → Add 100 to every value
 * SELECT col * 1.1 AS increased FROM t;   → 10% increase, aliased
 * SELECT col % 2 AS remainder FROM t;     → Modulus (even/odd check)
 */


/**
 * GOLDEN RULES OF SQL QUERYING
 *
 * QUERY DESIGN:
 * 1. ✅ Always start with SELECT and FROM — these two are the minimum
 *       required parts of any query.
 * 2. ✅ Use specific column names instead of SELECT * in production —
 *       it avoids retrieving unnecessary data.
 * 3. ✅ Always use LIMIT when exploring an unknown table — never pull
 *       millions of rows without knowing what is there.
 * 4. ✅ Test conditions in isolation before combining with AND/OR —
 *       it makes debugging much easier.
 * 5. ✅ Use aliases (AS) on computed columns — SQL will display the
 *       formula as the header without it, which is unreadable.
 *
 * FILTERING & OPERATORS:
 * 6. ✅ Use AND when ALL conditions must match; use OR when ANY one
 *       condition is enough — mixing them up is a very common mistake.
 * 7. ⚠️  Be careful with NOT — it can make queries harder to read.
 *       Sometimes rewriting with != or a different operator is cleaner.
 * 8. ⚠️  Use <> / != carefully with NULL values — comparisons against
 *       NULL require IS NULL or IS NOT NULL, not = or !=.
 * 9. ✅ Use DISTINCT only when you genuinely need unique values — it
 *       adds overhead and can slow down large queries.
 *
 * SORTING & RESULTS:
 * 10.✅ Always pair ORDER BY with LIMIT — sorting without limiting
 *       on a large table wastes resources.
 * 11.✅ Use OFFSET + LIMIT together for pagination — never load all
 *       rows and discard them in application code.
 * 12.✅ Remember that ORDER BY runs AFTER WHERE — you sort the
 *       already-filtered rows, not the entire table.
 */