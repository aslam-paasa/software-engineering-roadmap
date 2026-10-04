/**
 * Deep Dive — Logical Operators:
 * 1. Operator Overview       : AND, OR, and NOT at a glance
 * 2. AND                     : All conditions must be true
 * 3. OR                      : At least one condition must be true
 * 4. NOT                     : Negate a condition — exclude a group
 * 5. The Logic Trap          : Mixing AND with OR safely
 * 6. Common Mistakes         : Pitfalls every beginner hits
 */


/**
 * LOGICAL OPERATORS — Combining and modifying conditions
 *
 * What are logical operators?
 * ─────────────────────────────────────────────────────────────────────
 * Logical operators (AND, OR, NOT) let you combine or modify multiple
 * conditions inside a WHERE clause. They are essential when a single
 * comparison is not enough to describe the rows you want.
 *
 * In real-world projects, you will rarely ask simple questions.
 * Usually you need to filter based on several rules at once:
 *   → "Users who signed up last month AND spent over $100"
 *   → "Products in Furniture OR Cables"
 *   → "Everything EXCEPT the Electronics category"
 *
 * ┌───────────┬─────────────────────────────────────────────────────┐
 * │ Operator  │ Behaviour                                           │
 * ├───────────┼─────────────────────────────────────────────────────┤
 * │ AND       │ ALL conditions must be true for a row to pass       │
 * │ OR        │ AT LEAST ONE condition must be true for a row to    │
 * │           │ pass — more flexible than AND                       │
 * │ NOT       │ NEGATES a condition — shows rows where the          │
 * │           │ condition is false                                  │
 * └───────────┴─────────────────────────────────────────────────────┘
 *
 * Quick examples using the countries table:
 *
 * AND — population > 50M and area < 5M sq km:
 *   SELECT * FROM countries
 *   WHERE population > 50000000 AND area < 5000000;
 *   → Returns India only (satisfies BOTH conditions)
 *
 * OR — region is Asia or Oceania:
 *   SELECT * FROM countries
 *   WHERE region = 'Asia' OR region = 'Oceania';
 *   → Returns India, China, Australia
 *
 * NOT — exclude North America:
 *   SELECT * FROM countries
 *   WHERE NOT region = 'North America';
 *   → Returns India, China, Brazil, Australia
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
 * CASE 1 — WHERE with AND: All conditions must pass
 * > Combine multiple conditions with AND. 
 * > All conditions must be true for a row to be included.
 * > AND requires both conditions to be true. 
 * > Use WHERE condition1 AND condition2
 *
 * AND is used when you want a row to appear ONLY if it passes every
 * single condition you set. If a row fails even ONE part of the
 * condition, the entire row is blocked by the gatekeeper.
 *
 * Think of AND as a strict checklist — every box must be ticked.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Which Accessories items cost more than $80?                     │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category, price                          │
 * │   FROM products                                                 │
 * │   WHERE category = 'Accessories' AND price > 80;                │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-------------+-------+                   │
 * │ | product_name        | category    | price |                   │
 * │ +---------------------+-------------+-------+                   │
 * │ | Mechanical Keyboard | Accessories |   120 |                   │
 * │ +---------------------+-------------+-------+                   │
 * │                                                                 │
 * │ Gaming Mouse is in Accessories but costs only $50 — it fails    │
 * │ the price condition and is blocked. Every other product either  │
 * │ fails the category check or both checks at once.                │
 * │                                                                 │
 * │ Both conditions must be TRUE for a row to pass:                 │
 * │   category = 'Accessories'  ✅  AND  price > 80  ✅  → Passes  │
 * │   category = 'Accessories'  ✅  AND  price > 80  ❌  → Blocked │
 * │   category = 'Electronics'  ❌  AND  price > 80  ✅  → Blocked │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * CASE 2 — OR: At least one condition must pass
 *
 * OR is used when you want to see rows that meet ANY of your rules.
 * Even if a row satisfies only one condition, it is included.
 * OR broadens your search — it is more flexible than AND.
 *
 * Think of OR as an open invitation — qualify through any door.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ List all products in the Furniture OR Cables category           │
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category                                 │
 * │   FROM products                                                 │
 * │   WHERE category = 'Furniture' OR category = 'Cables';          │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +-----------------+-----------+                                 │
 * │ | product_name    | category  |                                 │
 * │ +-----------------+-----------+                                 │
 * │ | Ergonomic Chair | Furniture |                                 │
 * │ | USB-C Cable     | Cables    |                                 │
 * │ +-----------------+-----------+                                 │
 * │                                                                 │
 * │ A row qualifies if it matches EITHER condition:                 │
 * │   category = 'Furniture'  ✅  OR  category = 'Cables'  ❌  → ✅│
 * │   category = 'Furniture'  ❌  OR  category = 'Cables'  ✅  → ✅│
 * │   category = 'Furniture'  ❌  OR  category = 'Cables'  ❌  → ❌│
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * CASE 3 — NOT: Exclude a specific group
 *
 * NOT negates a condition — it shows you rows where the condition is
 * FALSE. Use NOT when it is easier to describe what you do not want
 * rather than listing everything you do want.
 *
 * This is often faster and cleaner than writing a long OR chain.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Show all products that do NOT belong to the Electronics category│
 * ├─────────────────────────────────────────────────────────────────┤
 * │   SELECT product_name, category                                 │
 * │   FROM products                                                 │
 * │   WHERE NOT category = 'Electronics';                           │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +---------------------+-------------+                           │
 * │ | product_name        | category    |                           │
 * │ +---------------------+-------------+                           │
 * │ | Gaming Mouse        | Accessories |                           │
 * │ | Mechanical Keyboard | Accessories |                           │
 * │ | Ergonomic Chair     | Furniture   |                           │
 * │ | USB-C Cable         | Cables      |                           │
 * │ +---------------------+-------------+                           │
 * │                                                                 │
 * │ Curved Monitor is the only Electronics item — it is blocked.    │
 * │ All other rows pass because their category is NOT Electronics.  │
 * │                                                                 │
 * │ NOT vs != — both are valid ways to exclude:                     │
 * │   WHERE NOT category = 'Electronics'   → NOT syntax             │
 * │   WHERE category != 'Electronics'      → Equivalent result      │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * THE LOGIC TRAP — Mixing AND with OR safely
 *
 * When you combine AND and OR in a single query, the order matters.
 * SQL evaluates AND BEFORE OR — just like multiplication comes before
 * addition in maths. This can produce unexpected results if you are
 * not careful.
 *
 * ⚠️  The unsafe version (no parentheses):
 *
 *   SELECT product_name, category, price
 *   FROM products
 *   WHERE category = 'Accessories' OR category = 'Cables' AND price < 20;
 *
 *   SQL reads this as:
 *   WHERE category = 'Accessories' OR (category = 'Cables' AND price < 20)
 *
 *   This returns ALL Accessories (regardless of price) AND Cables
 *   under $20 — probably not what you intended.
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Find items that are Accessories or Cables, AND cost under $20   │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Use parentheses to group the OR conditions first, then apply    │
 * │ the AND. The database solves what is inside the brackets first. │
 * │                                                                 │
 * │   SELECT product_name, category, price                          │
 * │   FROM products                                                 │
 * │   WHERE (category = 'Accessories' OR category = 'Cables')       │
 * │     AND price < 20;                                             │
 * │                                                                 │
 * │ Output:                                                         │
 * │ +--------------+----------+-------+                             │
 * │ | product_name | category | price |                             │
 * │ +--------------+----------+-------+                             │
 * │ | USB-C Cable  | Cables   |    15 |                             │
 * │ +--------------+----------+-------+                             │
 * │                                                                 │
 * │ Gaming Mouse ($50) is in Accessories but costs too much.        │
 * │ Mechanical Keyboard ($120) is also in Accessories but too       │
 * │ expensive. Only USB-C Cable passes both checks.                 │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ✅ Rule: Whenever you mix AND with OR, wrap the OR conditions in
 *    parentheses. This makes your intention explicit and protects
 *    your query from silent logic errors.
 */


/**
 * COMMON MISTAKES TO AVOID
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 1 — Forgetting to repeat the column name with OR        │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ You cannot shorthand an OR by dropping the column name.         │
 * │ Every condition needs a full column = value expression.         │
 * │                                                                 │
 * │   ❌ WHERE region = 'Asia' OR 'Europe'                          │
 * │      → SQL does not know what 'Europe' is comparing against     │
 * │                                                                 │
 * │   ✅ WHERE region = 'Asia' OR region = 'Europe'                 │
 * │      → Each condition is complete and unambiguous               │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 2 — Using AND on the same column with different values  │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ A single column can only hold one value per row. Filtering for  │
 * │ two values at once with AND will ALWAYS return zero results.    │
 * │                                                                 │
 * │   ❌ WHERE category = 'Asia' AND category = 'Europe'            │
 * │      → A row cannot be two categories at once → 0 results       │
 * │                                                                 │
 * │   ✅ WHERE category = 'Asia' OR category = 'Europe'             │
 * │      → Returns rows matching either value                       │
 * └─────────────────────────────────────────────────────────────────┘
 *
 * ┌─────────────────────────────────────────────────────────────────┐
 * │ Mistake 3 — Wrong parentheses placement with AND + OR           │
 * ├─────────────────────────────────────────────────────────────────┤
 * │ Misplaced brackets completely change what the query returns.    │
 * │ SQL evaluates AND before OR, so always group OR conditions      │
 * │ in parentheses when pairing them with AND.                      │
 * │                                                                 │
 * │   ❌ WHERE category = 'Accessories' OR category = 'Cables'      │
 * │         AND price < 20                                          │
 * │      → AND runs first → gives wrong results silently            │
 * │                                                                 │
 * │   ✅ WHERE (category = 'Accessories' OR category = 'Cables')    │
 * │         AND price < 20                                          │
 * │      → OR groups are resolved first → correct results           │
 * └─────────────────────────────────────────────────────────────────┘
 */


/**
 * PRACTICAL EXAMPLES
 *
 * Example 1: Find high-value, low-stock items (AND)
 *   SELECT product_name, price, stock_quantity
 *   FROM products
 *   WHERE price > 200 AND stock_quantity < 20;
 *   → Returns Ergonomic Chair ($250, 10 units)
 *
 * Example 2: Find items in Electronics or Furniture (OR)
 *   SELECT product_name, category
 *   FROM products
 *   WHERE category = 'Electronics' OR category = 'Furniture';
 *   → Returns Curved Monitor and Ergonomic Chair
 *
 * Example 3: Exclude Accessories from the view (NOT)
 *   SELECT product_name, category
 *   FROM products
 *   WHERE NOT category = 'Accessories';
 *   → Returns Curved Monitor, Ergonomic Chair, USB-C Cable
 *
 * Example 4: Safe OR + AND with parentheses
 *   SELECT product_name, category, price
 *   FROM products
 *   WHERE (category = 'Electronics' OR category = 'Furniture')
 *     AND price < 280;
 *   → Returns Ergonomic Chair ($250) — Curved Monitor ($300) is too expensive
 *
 * Example 5: Three-condition AND chain
 *   SELECT product_name, category, price, stock_quantity
 *   FROM products
 *   WHERE category = 'Accessories'
 *     AND price > 40
 *     AND stock_quantity >= 50;
 *   → Returns Gaming Mouse and Mechanical Keyboard
 *
 * Example 6: Countries in Asia with large populations (AND)
 *   SELECT country, population
 *   FROM countries
 *   WHERE region = 'Asia' AND population > 1000000000;
 *   → Returns India and China
 *
 * Example 7: Countries outside Asia and South America (NOT + OR)
 *   SELECT country, region
 *   FROM countries
 *   WHERE NOT (region = 'Asia' OR region = 'South America');
 *   → Returns Australia, USA
 */


/**
 * QUICK REFERENCE
 *
 * OPERATOR PATTERNS:
 * ─────────────────────────────────────────────────────────────────────
 * WHERE cond1 AND cond2              → Both must be true
 * WHERE cond1 OR cond2               → Either can be true
 * WHERE NOT cond                     → Condition must be false
 * WHERE col != 'value'               → Equivalent to NOT col = 'value'
 *
 * COMBINING SAFELY:
 * ─────────────────────────────────────────────────────────────────────
 * WHERE (cond1 OR cond2) AND cond3   → Group OR first with parentheses
 * WHERE cond1 AND (cond2 OR cond3)   → AND applies to the OR group
 *
 * DECIDING WHICH OPERATOR TO USE:
 * ─────────────────────────────────────────────────────────────────────
 * All rules must apply          → AND
 * Any rule is acceptable        → OR
 * Easier to say what to exclude → NOT
 * Mixing both                   → Use parentheses around OR groups
 *
 * OPERATOR PRECEDENCE (SQL evaluation order):
 * ─────────────────────────────────────────────────────────────────────
 * 1. NOT    → evaluated first
 * 2. AND    → evaluated second
 * 3. OR     → evaluated last
 *
 * Always use parentheses to override this order explicitly.
 */
