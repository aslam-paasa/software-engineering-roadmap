/**
 * ============================================================================
 * SUBQUERIES - COMPLETE BEGINNER'S GUIDE
 * Simple English - Easy to understand with INPUT/OUTPUT examples
 * ============================================================================
 * 
 * 📚 TABLE OF CONTENTS:
 * 
 * 1. WHAT IS A SUBQUERY? ------------------- (Query inside a query)
 * 2. SUBQUERY IN SELECT Clause ------------- (Fetch single value)
 * 3. SUBQUERY WITH IN ---------------------- (Check value in list)
 * 4. SUBQUERY WITH EXISTS ------------------ (Check if any row exists)
 * 5. SUBQUERY WITH NOT EXISTS -------------- (Check if no row exists)
 * 6. CORRELATED SUBQUERY ------------------- (Subquery uses outer query values)
 * 7. SUBQUERY WITH ANY/ALL ----------------- (Compare with any/all values)
 * 8. SUBQUERY IN FROM Clause --------------- (Subquery as a table)
 * 9. SUBQUERY IN WHERE Clause -------------- (Filter using subquery)
 * 10. SUBQUERY WITH AGGREGATES ------------- (Using MAX, MIN, AVG, SUM)
 * 11. IN vs EXISTS vs NOT IN vs NOT EXISTS - (When to use which)
 * 12. COMMON MISTAKES ---------------------- (What to avoid)
 * 13. GOLDEN RULES ------------------------- (Key principles)
 * 
 * ============================================================================
 */

-- ============================================================================
-- SAMPLE TABLES FOR ALL EXAMPLES
-- ============================================================================

/**
 * TABLE 1: USERS - Customer information
 */

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50)
);

/**
 * TABLE 2: PRODUCTS - Items available for purchase
 */

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product VARCHAR(50)
);

/**
 * TABLE 3: ORDERS - Purchase records
 */

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT,
    amount DECIMAL(10,2),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================================================
-- SAMPLE DATA
-- ============================================================================

/**
 * USERS TABLE
 * ┌─────────┬──────────┐
 * │ user_id │ name     │
 * ├─────────┼──────────┤
 * │    1    │ Ayaan    │
 * │    2    │ Sneha    │
 * │    3    │ Rohit    │
 * │    4    │ Kavya    │
 * │    5    │ Zoya     │
 * │    6    │ Arjun    │
 * │    7    │ (empty)  │
 * │    8    │ NULL     │
 * └─────────┴──────────┘
 */

INSERT INTO users (user_id, name) VALUES
(1, 'Ayaan'),
(2, 'Sneha'),
(3, 'Rohit'),
(4, 'Kavya'),
(5, 'Zoya'),
(6, 'Arjun'),
(7, ''),
(8, NULL);

/**
 * PRODUCTS TABLE
 * ┌────────────┬─────────────┐
 * │ product_id │ product     │
 * ├────────────┼─────────────┤
 * │    10      │ Tablet      │
 * │    11      │ Headphones  │
 * │    12      │ Keyboard    │
 * └────────────┴─────────────┘
 */

INSERT INTO products (product_id, product) VALUES
(10, 'Tablet'),
(11, 'Headphones'),
(12, 'Keyboard');

/**
 * ORDERS TABLE
 * ┌──────────┬─────────┬────────────┬─────────┐
 * │ order_id │ user_id │ product_id │ amount  │
 * ├──────────┼─────────┼────────────┼─────────┤
 * │   101    │    1    │    10      │ 1200.00 │
 * │   102    │    1    │    11      │ 300.00  │
 * │   103    │    1    │    12      │ 150.00  │
 * │   104    │    3    │    10      │ 1100.00 │
 * │   105    │    3    │    11      │ 350.00  │
 * │   106    │    4    │    11      │ 400.00  │
 * │   107    │    1    │    11      │ 250.00  │
 * │   108    │    1    │    12      │ NULL    │
 * │   109    │    3    │    11      │ 349.00  │
 * │   110    │    3    │    11      │ 50.00   │
 * │   111    │    4    │    NULL    │ 50.00   │
 * │   112    │    4    │    11      │ 10.00   │
 * └──────────┴─────────┴────────────┴─────────┘
 */

INSERT INTO orders (order_id, user_id, product_id, amount) VALUES
(101, 1, 10, 1200.00),
(102, 1, 11, 300.00),
(103, 1, 12, 150.00),
(104, 3, 10, 1100.00),
(105, 3, 11, 350.00),
(106, 4, 11, 400.00),
(107, 1, 11, 250.00),
(108, 1, 12, NULL),
(109, 3, 11, 349.00),
(110, 3, 11, 50.00),
(111, 4, NULL, 50.00),
(112, 4, 11, 10.00);

-- ============================================================================
-- PART 1: WHAT IS A SUBQUERY?
-- ============================================================================

/**
 * A SUBQUERY is a SELECT statement written INSIDE another SQL statement.
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    WHAT IS A SUBQUERY?                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   OUTER QUERY (Main query)                                              │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT column1, (SELECT column2 FROM table2 WHERE condition)   │   │
 * │   │ FROM table1                                                     │   │
 * │   │ WHERE column3 IN (SELECT column4 FROM table3)                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                     ↑                                                  │
 * │               INNER QUERY (Subquery)                                   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ 1. SQL executes the INNER query (subquery) FIRST                │   │
 * │   │ 2. Then uses the result to execute the OUTER query              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   REAL LIFE EXAMPLE:                                                    │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ "Find customers who bought the most expensive product"          │   │
 * │   │                                                                  │   │
 * │   │ Step 1 (Subquery): Find the highest price (₹5000)               │   │
 * │   │ Step 2 (Outer query): Find customers who bought product for ₹5000│   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 * 
 * TYPES OF SUBQUERIES:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │ Type                    │ Where it goes          │ What it returns      │
 * ├─────────────────────────┼────────────────────────┼──────────────────────┤
 * │ Scalar Subquery         │ SELECT clause          │ Single value         │
 * │ Row Subquery            │ SELECT clause          │ Single row           │
 * │ Table Subquery          │ FROM clause            │ Multiple rows/cols   │
 * │ Predicate Subquery      │ WHERE/HAVING clause    │ TRUE/FALSE           │
 * │ Correlated Subquery     │ Any clause             │ Uses outer values    │
 * └─────────────────────────┴────────────────────────┴──────────────────────┘
 */

-- ============================================================================
-- PART 2: SUBQUERY IN SELECT CLAUSE (Fetch single value)
-- ============================================================================

/**
 * A scalar subquery returns a SINGLE value (one row, one column).
 * Used in SELECT clause to fetch additional data from another table.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY IN SELECT CLAUSE                            │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY:                                                                │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT o.order_id,                                              │   │
 * │   │        (SELECT u.name FROM users u WHERE u.user_id = o.user_id) │   │
 * │   │        AS user_name                                             │   │
 * │   │ FROM orders o;                                                  │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ For EACH order row:                                             │   │
 * │   │   - Take the order's user_id                                    │   │
 * │   │   - Run subquery: SELECT name FROM users WHERE user_id = ?      │   │
 * │   │   - Return the name as user_name column                         │   │
 * │   │                                                                  │   │
 * │   │ Example for order_id=101:                                       │   │
 * │   │   user_id = 1 → Subquery returns 'Ayaan'                        │   │
 * │   │                                                                  │   │
 * │   │ Example for order_id=111:                                       │   │
 * │   │   user_id = 4 → Subquery returns 'Kavya'                        │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌──────────┬───────────┐                                            │
 * │   │ order_id │ user_name │                                            │
 * │   ├──────────┼───────────┤                                            │
 * │   │ 101      │ Ayaan     │                                            │
 * │   │ 102      │ Ayaan     │                                            │
 * │   │ 103      │ Ayaan     │                                            │
 * │   │ 104      │ Rohit     │                                            │
 * │   │ 105      │ Rohit     │                                            │
 * │   │ 106      │ Kavya     │                                            │
 * │   │ 107      │ Ayaan     │                                            │
 * │   │ 108      │ Ayaan     │                                            │
 * │   │ 109      │ Rohit     │                                            │
 * │   │ 110      │ Rohit     │                                            │
 * │   │ 111      │ Kavya     │                                            │
 * │   │ 112      │ Kavya     │                                            │
 * │   └──────────┴───────────┘                                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Subquery in SELECT clause
SELECT 
    o.order_id,
    (SELECT u.name FROM users u WHERE u.user_id = o.user_id) AS user_name
FROM orders o
ORDER BY o.order_id;

/**
 * OUTPUT:
 * ┌──────────┬───────────┐
 * │ order_id │ user_name │
 * ├──────────┼───────────┤
 * │ 101      │ Ayaan     │
 * │ 102      │ Ayaan     │
 * │ 103      │ Ayaan     │
 * │ 104      │ Rohit     │
 * │ 105      │ Rohit     │
 * │ 106      │ Kavya     │
 * │ 107      │ Ayaan     │
 * │ 108      │ Ayaan     │
 * │ 109      │ Rohit     │
 * │ 110      │ Rohit     │
 * │ 111      │ Kavya     │
 * │ 112      │ Kavya     │
 * └──────────┴───────────┘
 * 
 * EXPLANATION:
 * - Outer query: selects each order from orders table
 * - Subquery: for each order, finds the user's name from users table
 * - This is a CORRELATED subquery (uses o.user_id from outer query)
 */

-- ============================================================================
-- PART 3: SUBQUERY WITH IN (Check value in list)
-- ============================================================================

/**
 * IN operator checks whether a value exists in a list returned by subquery.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY WITH IN                                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find users who have placed at least one order                 │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT u.user_id, u.name                                        │   │
 * │   │ FROM users u                                                    │   │
 * │   │ WHERE u.user_id IN (                                            │   │
 * │   │     SELECT DISTINCT o.user_id                                   │   │
 * │   │     FROM orders o                                               │   │
 * │   │ );                                                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 1: Execute subquery first                                       │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT DISTINCT o.user_id FROM orders o                         │   │
 * │   │ Result: {1, 3, 4}  (users who have orders)                     │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   STEP 2: Outer query uses this list                                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT u.user_id, u.name FROM users u                          │   │
 * │   │ WHERE u.user_id IN (1, 3, 4)                                   │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬──────────┐                                              │
 * │   │ user_id │ name     │                                              │
 * │   ├─────────┼──────────┤                                              │
 * │   │ 1       │ Ayaan    │                                              │
 * │   │ 3       │ Rohit    │                                              │
 * │   │ 4       │ Kavya    │                                              │
 * │   └─────────┴──────────┘                                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- SCENARIO 1: Users who have placed any order
SELECT 
    u.user_id,
    u.name
FROM users u
WHERE u.user_id IN (
    SELECT DISTINCT o.user_id
    FROM orders o
);

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ user_id │ name     │
 * ├─────────┼──────────┤
 * │ 1       │ Ayaan    │
 * │ 3       │ Rohit    │
 * │ 4       │ Kavya    │
 * └─────────┴──────────┘
 * 
 * EXPLANATION:
 * - Inner query: finds all unique user_ids from orders table → {1, 3, 4}
 * - Outer query: returns users whose user_id is in that list
 * - Users 2,5,6,7,8 have no orders → not returned
 */

-- SCENARIO 2: Users who purchased a Tablet
SELECT 
    o.user_id,
    o.product_id
FROM orders o
WHERE o.product_id IN (
    SELECT p.product_id
    FROM products p
    WHERE p.product = 'Tablet'
);

/**
 * OUTPUT:
 * ┌─────────┬────────────┐
 * │ user_id │ product_id │
 * ├─────────┼────────────┤
 * │ 1       │ 10         │
 * │ 3       │ 10         │
 * └─────────┴────────────┘
 * 
 * EXPLANATION:
 * - Inner query: finds product_id for 'Tablet' → {10}
 * - Outer query: returns orders where product_id = 10
 */

-- ============================================================================
-- PART 4: SUBQUERY WITH EXISTS (Check if any row exists)
-- ============================================================================

/**
 * EXISTS checks whether the subquery returns at least ONE row.
 * Returns TRUE if subquery has any rows, FALSE if empty.
 * Stops searching as soon as first match is found (efficient).
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY WITH EXISTS                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Users who have placed at least one order                      │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT u.user_id, u.name                                        │   │
 * │   │ FROM users u                                                    │   │
 * │   │ WHERE EXISTS (                                                  │   │
 * │   │     SELECT 1                                                    │   │
 * │   │     FROM orders o                                               │   │
 * │   │     WHERE o.user_id = u.user_id                                 │   │
 * │   │ );                                                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 *   │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ For each user in users table:                                    │   │
 * │   │                                                                  │   │
 * │   │ User 1 (Ayaan): Does any order exist with user_id=1?            │   │
 * │   │   → Yes (orders 101,102,103,107,108) → KEEP                      │   │
 * │   │                                                                  │   │
 * │   │ User 2 (Sneha): Does any order exist with user_id=2?            │   │
 * │   │   → No → REMOVE                                                   │   │
 * │   │                                                                  │   │
 * │   │ User 3 (Rohit): Does any order exist with user_id=3?            │   │
 * │   │   → Yes (orders 104,105,109,110) → KEEP                          │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬──────────┐                                              │
 * │   │ user_id │ name     │                                              │
 * │   ├─────────┼──────────┤                                              │
 * │   │ 1       │ Ayaan    │                                              │
 * │   │ 3       │ Rohit    │                                              │
 * │   │ 4       │ Kavya    │                                              │
 * │   └─────────┴──────────┘                                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- SCENARIO 1: Users who have placed at least one order
SELECT 
    u.user_id,
    u.name
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = u.user_id
);

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ user_id │ name     │
 * ├─────────┼──────────┤
 * │ 1       │ Ayaan    │
 * │ 3       │ Rohit    │
 * │ 4       │ Kavya    │
 * └─────────┴──────────┘
 * 
 * EXPLANATION:
 * - EXISTS returns TRUE if subquery finds at least one order for the user
 * - Subquery uses SELECT 1 (value doesn't matter, just checking existence)
 * - Correlated subquery: uses u.user_id from outer query
 * - Very efficient because it stops at first match
 */

-- SCENARIO 2: Users with at least one high value order (amount >= 500)
SELECT 
    u.user_id,
    u.name
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = u.user_id
      AND o.amount >= 500
);

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ user_id │ name     │
 * ├─────────┼──────────┤
 * │ 1       │ Ayaan    │
 * │ 3       │ Rohit    │
 * └─────────┴──────────┘
 * 
 * EXPLANATION:
 * - User 4 (Kavya) has max order amount 400 (<500) → excluded
 * - NULL amounts never satisfy >= 500
 */

-- ============================================================================
-- PART 5: SUBQUERY WITH NOT EXISTS (Check if no row exists)
-- ============================================================================

/**
 * NOT EXISTS ensures that NO matching row exists in the subquery.
 * Returns TRUE if subquery returns NO rows.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    SUBQUERY WITH NOT EXISTS                             │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Users who have NEVER placed an order                          │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT u.user_id, u.name                                        │   │
 * │   │ FROM users u                                                    │   │
 * │   │ WHERE NOT EXISTS (                                              │   │
 * │   │     SELECT 1                                                    │   │
 * │   │     FROM orders o                                               │   │
 * │   │     WHERE o.user_id = u.user_id                                 │   │
 * │   │ );                                                              │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS:                                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ For each user in users table:                                    │   │
 * │   │                                                                  │   │
 * │   │ User 1 (Ayaan): Does any order exist? → Yes → REMOVE             │   │
 * │   │ User 2 (Sneha): Does any order exist? → No → KEEP                │   │
 * │   │ User 3 (Rohit): Does any order exist? → Yes → REMOVE             │   │
 * │   │ User 4 (Kavya): Does any order exist? → Yes → REMOVE             │   │
 * │   │ User 5 (Zoya): Does any order exist? → No → KEEP                 │   │
 * │   │ User 6 (Arjun): Does any order exist? → No → KEEP                │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬──────────┐                                              │
 * │   │ user_id │ name     │                                              │
 * │   ├─────────┼──────────┤                                              │
 * │   │ 2       │ Sneha    │                                              │
 * │   │ 5       │ Zoya     │                                              │
 * │   │ 6       │ Arjun    │                                              │
 * │   │ 7       │ (empty)  │                                              │
 * │   │ 8       │ NULL     │                                              │
 * │   └─────────┴──────────┘                                              │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- SCENARIO 1: Users who have never placed an order
SELECT 
    u.user_id,
    u.name
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = u.user_id
);

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ user_id │ name     │
 * ├─────────┼──────────┤
 * │ 2       │ Sneha    │
 * │ 5       │ Zoya     │
 * │ 6       │ Arjun    │
 * │ 7       │          │
 * │ 8       │ NULL     │
 * └─────────┴──────────┘
 * 
 * EXPLANATION:
 * - NOT EXISTS returns TRUE if NO order exists for the user
 * - Users 1,3,4 have orders → excluded
 * - Users 2,5,6,7,8 have no orders → included
 */

-- SCENARIO 2: Users who bought ALL products (no product they haven't bought)
SELECT 
    u.user_id,
    u.name
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM products p
    WHERE NOT EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.user_id = u.user_id
          AND o.product_id = p.product_id
    )
);

/**
 * OUTPUT:
 * ┌─────────┬──────────┐
 * │ user_id │ name     │
 * ├─────────┼──────────┤
 * │ 1       │ Ayaan    │
 * └─────────┴──────────┘
 * 
 * EXPLANATION:
 * - Double NOT EXISTS = "For every product, the user has bought it"
 * - User 1 bought Tablet(10), Headphones(11), Keyboard(12) → all products
 * - User 3 bought Tablet(10) and Headphones(11) but NOT Keyboard(12) → excluded
 * - User 4 bought Headphones(11) only → excluded
 * - This is called "Relational Division" in SQL
 */

-- ============================================================================
-- PART 6: CORRELATED SUBQUERY (Subquery uses outer query values)
-- ============================================================================

/**
 * A CORRELATED subquery references columns from the OUTER query.
 * The inner query executes ONCE for EACH row processed by the outer query.
 * 
 * INPUT/OUTPUT TRANSACTION BOX:
 * 
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    CORRELATED SUBQUERY                                  │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │   QUERY: Find the highest order amount for each user                   │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ SELECT u.user_id, u.name,                                       │   │
 * │   │        (SELECT MAX(o.amount)                                    │   │
 * │   │         FROM orders o                                           │   │
 * │   │         WHERE o.user_id = u.user_id) AS max_amount              │   │
 * │   │ FROM users u                                                    │   │
 * │   │ WHERE EXISTS (                                                  │   │
 * │   │     SELECT 1 FROM orders o WHERE o.user_id = u.user_id)         │   │
 * │   │ ORDER BY max_amount DESC;                                       │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   HOW IT WORKS (For each user):                                         │
 * │   ┌─────────────────────────────────────────────────────────────────┐   │
 * │   │ User 1 (Ayaan): Subquery finds MAX amount in user's orders     │   │
 * │   │   Orders: 1200, 300, 150, 250, NULL → MAX = 1200               │   │
 * │   │                                                                  │   │
 * │   │ User 3 (Rohit): Subquery finds MAX amount in user's orders      │   │
 * │   │   Orders: 1100, 350, 349, 50 → MAX = 1100                       │   │
 * │   │                                                                  │   │
 * │   │ User 4 (Kavya): Subquery finds MAX amount in user's orders      │   │
 * │   │   Orders: 400, 50, 10 → MAX = 400                               │   │
 * │   └─────────────────────────────────────────────────────────────────┘   │
 * │                                                                          │
 * │   OUTPUT:                                                              │
 * │   ┌─────────┬──────────┬────────────┐                                 │
 * │   │ user_id │ name     │ max_amount │                                 │
 * │   ├─────────┼──────────┼────────────┤                                 │
 * │   │ 1       │ Ayaan    │ 1200.00    │                                 │
 * │   │ 3       │ Rohit    │ 1100.00    │                                 │
 * │   │ 4       │ Kavya    │ 400.00     │                                 │
 * │   └─────────┴──────────┴────────────┘                                 │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- SCENARIO 1: Highest order amount for each user
SELECT 
    u.user_id,
    u.name,
    (
        SELECT MAX(o.amount)
        FROM orders o
        WHERE o.user_id = u.user_id
    ) AS max_amount
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = u.user_id
)
ORDER BY max_amount DESC;

/**
 * OUTPUT:
 * ┌─────────┬──────────┬────────────┐
 * │ user_id │ name     │ max_amount │
 * ├─────────┼──────────┼────────────┤
 * │ 1       │ Ayaan    │ 1200.00    │
 * │ 3       │ Rohit    │ 1100.00    │
 * │ 4       │ Kavya    │ 400.00     │
 * └─────────┴──────────┴────────────┘
 * 
 * EXPLANATION:
 * - Subquery is CORRELATED (uses u.user_id from outer query)
 * - Runs separately for each user
 * - MAX() ignores NULL values
 * - WHERE EXISTS removes users with no orders
 */

-- SCENARIO 2: Find which order produced the maximum amount for each user
SELECT 
    o.user_id,
    o.product_id,
    o.amount
FROM orders o
WHERE o.amount = (
    SELECT MAX(o2.amount)
    FROM orders o2
    WHERE o2.user_id = o.user_id
)
ORDER BY o.user_id, o.amount DESC;

/**
 * OUTPUT:
 * ┌─────────┬────────────┬─────────┐
 * │ user_id │ product_id │ amount  │
 * ├─────────┼────────────┼─────────┤
 * │ 1       │ 10         │ 1200.00 │
 * │ 3       │ 10         │ 1100.00 │
 * │ 4       │ 11         │ 400.00  │
 * └─────────┴────────────┴─────────┘
 * 
 * EXPLANATION:
 * - For each order, subquery finds user's max amount
 * - Outer query keeps only orders where amount equals that max
 * - Shows the actual order row for each user's highest purchase
 */

-- ============================================================================
-- PART 7: SUBQUERY WITH ANY/ALL (Compare with any/all values)
-- ============================================================================

/**
 * ANY and ALL compare a value with ANY or ALL values in a subquery result.
 * 
 * ANY = value > ANY(subquery) → true if greater than at least one value
 * ALL = value > ALL(subquery) → true if greater than all values
 */

-- ANY example: Find users who have spent more than ANY user's total
-- (Users who are not the lowest spender)

-- First, calculate each user's total spending
SELECT 
    o.user_id,
    SUM(o.amount) AS total_spent
FROM orders o
GROUP BY o.user_id
ORDER BY total_spent DESC;

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ user_id │ total_spent │
 * ├─────────┼─────────────┤
 * │ 1       │ 1900.00     │
 * │ 3       │ 1849.00     │
 * │ 4       │ 460.00      │
 * └─────────┴─────────────┘
 */

-- ALL example: Find users who have spent more than ALL users with orders
-- (The user with highest total spending)

SELECT 
    o.user_id,
    SUM(o.amount) AS total_spent
FROM orders o
GROUP BY o.user_id
HAVING SUM(o.amount) >= ALL (
    SELECT SUM(o2.amount)
    FROM orders o2
    GROUP BY o2.user_id
);

/**
 * OUTPUT:
 * ┌─────────┬─────────────┐
 * │ user_id │ total_spent │
 * ├─────────┼─────────────┤
 * │ 1       │ 1900.00     │
 * └─────────┴─────────────┘
 * 
 * EXPLANATION:
 * - Subquery returns {1900, 1849, 460}
 * - ALL condition: total_spent must be >= ALL values (>=1900)
 * - Only user 1 qualifies (1900 >= 1900, 1900 >= 1849, 1900 >= 460)
 */

-- ============================================================================
-- PART 8: SUBQUERY IN FROM CLAUSE (Subquery as a table)
-- ============================================================================

/**
 * Subquery in FROM clause acts as a "virtual table" that you can query.
 * Must give it an alias.
 */

-- Find average of user totals (average spending per user)
SELECT 
    AVG(user_total) AS avg_spent_per_user
FROM (
    SELECT 
        o.user_id,
        SUM(o.amount) AS user_total
    FROM orders o
    GROUP BY o.user_id
) AS user_totals;

/**
 * OUTPUT:
 * ┌────────────────────┐
 * │ avg_spent_per_user │
 * ├────────────────────┤
 * │ 1403.00            │
 * └────────────────────┘
 * 
 * EXPLANATION:
 * - Subquery creates virtual table: user_id, user_total
 * - Outer query calculates AVG of user_total column
 */

-- ============================================================================
-- PART 9: SUBQUERY IN WHERE CLAUSE (Filter using subquery)
-- ============================================================================

-- Find products that have never been ordered
SELECT 
    p.product_id,
    p.product
FROM products p
WHERE p.product_id NOT IN (
    SELECT DISTINCT o.product_id
    FROM orders o
    WHERE o.product_id IS NOT NULL
);

/**
 * OUTPUT:
 * ┌────────────┬─────────┐
 * │ product_id │ product │
 * ├────────────┼─────────┤
 * │ 12         │ Keyboard│
 * └────────────┴─────────┘
 * 
 * EXPLANATION:
 * - Subquery finds all product_ids that appear in orders: {10, 11}
 * - Outer query returns products not in that list: Keyboard (12)
 */

-- ============================================================================
-- PART 10: SUBQUERY WITH AGGREGATES (Using MAX, MIN, AVG, SUM)
-- ============================================================================

-- Find orders that are above average amount
SELECT 
    o.order_id,
    o.user_id,
    o.amount
FROM orders o
WHERE o.amount > (
    SELECT AVG(o2.amount)
    FROM orders o2
    WHERE o2.amount IS NOT NULL
)
ORDER BY o.amount DESC;

/**
 * OUTPUT:
 * ┌──────────┬─────────┬─────────┐
 * │ order_id │ user_id │ amount  │
 * ├──────────┼─────────┼─────────┤
 * │ 101      │ 1       │ 1200.00 │
 * │ 104      │ 3       │ 1100.00 │
 * │ 106      │ 4       │ 400.00  │
 * │ 105      │ 3       │ 350.00  │
 * └──────────┴─────────┴─────────┘
 */

-- ============================================================================
-- PART 11: IN vs EXISTS vs NOT IN vs NOT EXISTS
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    COMPARISON GUIDE                                     │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ ┌────────────┬────────────────────────┬────────────────────────────────┐│
 * │ │ Clause     │ What it checks         │ Best for                       ││
 * ├────────────┼────────────────────────┼────────────────────────────────┤│
 * │ IN         │ Value matches any in    │ Small lists, no NULLs          ││
 * │            │ subquery result         │                                ││
 * ├────────────┼────────────────────────┼────────────────────────────────┤│
 * │ EXISTS     │ Subquery returns at     │ Existence checks, large data   ││
 * │            │ least one row           │ (stops early)                   ││
 * ├────────────┼────────────────────────┼────────────────────────────────┤│
 * │ NOT IN     │ Value not in list       │ Avoid if NULL possible         ││
 * │            │                         │ (can return no rows)           ││
 * ├────────────┼────────────────────────┼────────────────────────────────┤│
 * │ NOT EXISTS │ No matching row exists  │ Anti-joins, safe with NULLs    ││
 * └────────────┴────────────────────────┴────────────────────────────────┘│
 *                                                                          │
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    IMPORTANT: NOT IN with NULL                          │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ SELECT * FROM users WHERE user_id NOT IN (SELECT user_id FROM orders)  │
 * │                                                                          │
 * │ If orders.user_id has NULL, NOT IN returns NO ROWS!                     │
 * │ Because: user_id NOT IN (1,3,4,NULL) is always FALSE/UNKNOWN           │
 * │                                                                          │
 * │ ✅ ALWAYS use NOT EXISTS for safety:                                    │
 * │ SELECT * FROM users u WHERE NOT EXISTS (SELECT 1 FROM orders o         │
 * │                                       WHERE o.user_id = u.user_id)     │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- Demonstrate NOT IN problem with NULL
-- This query may return unexpected results if subquery has NULLs
SELECT u.user_id, u.name
FROM users u
WHERE u.user_id NOT IN (SELECT o.user_id FROM orders o);

-- ✅ Safe alternative using NOT EXISTS
SELECT u.user_id, u.name
FROM users u
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.user_id);

-- ============================================================================
-- PART 12: COMMON MISTAKES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                         COMMON MISTAKES                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ MISTAKE #1: Subquery returns multiple rows in SELECT clause            │
 * │                                                                          │
 * │   ❌ SELECT (SELECT name FROM users) FROM orders;                       │
 * │      → Error! Subquery returns 8 rows, but SELECT expects 1 value       │
 * │                                                                          │
 * │   ✅ SELECT (SELECT name FROM users WHERE user_id = o.user_id)          │
 * │      FROM orders o;  ← Add condition to return single value            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- MISTAKE #2: NOT IN with NULL
-- This returns NO rows if subquery contains NULL
SELECT * FROM users WHERE user_id NOT IN (SELECT user_id FROM orders);
-- orders.user_id has NULL → unexpected results!

-- ✅ Use NOT EXISTS instead
SELECT * FROM users u WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.user_id);

-- ============================================================================
-- PART 13: GOLDEN RULES
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                          GOLDEN RULES                                   │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ RULE 1: Subquery in SELECT must return ONE value (one row, one column) │
 * │                                                                          │
 * │ RULE 2: Subquery in WHERE with IN can return multiple values           │
 * │                                                                          │
 * │ RULE 3: EXISTS checks for existence, not values                        │
 * │         → SELECT 1 inside is standard (value doesn't matter)           │
 * │                                                                          │
 * │ RULE 4: NOT IN is DANGEROUS with NULLs                                 │
 * │         → Always prefer NOT EXISTS for anti-joins                      │
 * │                                                                          │
 * │ RULE 5: Correlated subqueries run once per outer row                   │
 * │         → Can be slow on large tables, use JOINs when possible         │
 * │                                                                          │
 * │ RULE 6: Subquery in FROM clause must have an alias                      │
 * │         → SELECT * FROM (SELECT ...) AS alias                          │
 * │                                                                          │
 * │ RULE 7: EXISTS stops at first match (efficient)                        │
 * │         → Better than IN for large datasets                            │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- QUICK REFERENCE CARD
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                    QUICK REFERENCE CARD                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ -- Subquery in SELECT (scalar)                                          │
 * │ SELECT column, (SELECT single_value FROM table2 WHERE condition)       │
 * │ FROM table1;                                                            │
 * │                                                                          │
 * │ -- Subquery with IN                                                     │
 * │ SELECT * FROM table1 WHERE column IN (SELECT column FROM table2);      │
 * │                                                                          │
 * │ -- Subquery with EXISTS                                                 │
 * │ SELECT * FROM table1 WHERE EXISTS (SELECT 1 FROM table2 WHERE condition);│
 * │                                                                          │
 * │ -- Subquery with NOT EXISTS                                             │
 * │ SELECT * FROM table1 WHERE NOT EXISTS (SELECT 1 FROM table2 WHERE cond);│
 * │                                                                          │
 * │ -- Correlated Subquery                                                  │
 * │ SELECT column, (SELECT aggregate FROM table2                           │
 * │                WHERE table2.foreign_key = table1.primary_key)          │
 * │ FROM table1;                                                            │
 * │                                                                          │
 * │ -- Subquery in FROM (derived table)                                     │
 * │ SELECT * FROM (SELECT * FROM table1) AS alias;                         │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

/**
 * EXERCISE 1: Find all orders with user name using subquery in SELECT
 * 
 * Answer:
 *   SELECT o.order_id, (SELECT u.name FROM users u WHERE u.user_id = o.user_id)
 *   FROM orders o;
 */

/**
 * EXERCISE 2: Find users who have NOT placed any order
 * 
 * Answer:
 *   SELECT * FROM users u WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.user_id = u.user_id);
 */

/**
 * EXERCISE 3: Find products that have been ordered at least once
 * 
 * Answer:
 *   SELECT * FROM products p WHERE p.product_id IN (SELECT DISTINCT o.product_id FROM orders o);
 */

/**
 * EXERCISE 4: Find the average order amount per user
 * 
 * Answer:
 *   SELECT user_id, AVG(amount) FROM orders GROUP BY user_id;
 */

-- ============================================================================
-- CLEANUP
-- ============================================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- ============================================================================
-- FINAL SUMMARY
-- ============================================================================

/**
 * ┌─────────────────────────────────────────────────────────────────────────┐
 * │                           FINAL SUMMARY                                 │
 * ├─────────────────────────────────────────────────────────────────────────┤
 * │                                                                          │
 * │ 1. SUBQUERY = SELECT statement inside another SQL statement            │
 * │                                                                          │
 * │ 2. SCALAR SUBQUERY: Returns ONE value (used in SELECT)                 │
 * │                                                                          │
 * │ 3. IN: Checks if value exists in list (subquery returns list)          │
 * │                                                                          │
 * │ 4. EXISTS: Checks if subquery returns ANY rows (efficient)             │
 * │                                                                          │
 * │ 5. NOT EXISTS: Checks if subquery returns NO rows (safe with NULLs)    │
 * │                                                                          │
 * │ 6. CORRELATED SUBQUERY: Uses values from outer query                   │
 * │                         Runs once per outer row                         │
 * │                                                                          │
 * │ 7. Use NOT EXISTS instead of NOT IN to avoid NULL problems             │
 * │                                                                          │
 * │ 8. Subquery in FROM creates a "virtual table" (must have alias)        │
 * │                                                                          │
 * │ REMEMBER:                                                              │
 * │   - Subquery in SELECT must return 1 value                             │
 * │   - EXISTS is faster than IN for large datasets                        │
 * │   - NOT IN with NULL returns NO rows                                   │
 * │   - Always use NOT EXISTS for anti-joins                               │
 * │                                                                          │
 * └─────────────────────────────────────────────────────────────────────────┘
 */

-- ============================================================================
-- END OF SUBQUERIES GUIDE
-- ============================================================================