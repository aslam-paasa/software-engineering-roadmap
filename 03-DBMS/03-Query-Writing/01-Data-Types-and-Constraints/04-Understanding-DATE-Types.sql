/**
 * Understanding DATE Types:
 * > DATE stores calendar dates without time. 
 * > Our orders and employees use DATE fields.
 * 
 * > DATE stores year-month-day (YYYY-MM-DD). 
 * > No time component. 
 * > Use for birth dates, order dates, hire dates. 
 * > Can compare and do date math.
*/

/**
 * DATE vs TIMESTAMP
 * → DATE        → Only date
 * → TIMESTAMP   → Date + Time
 *
 * Example:
 *   DATE        → 2024-01-10
 *   TIMESTAMP   → 2024-01-10 14:30:00
*/


CREATE TABLE orders (
   order_id SERIAL PRIMARY KEY,
   user_id INTEGER,
   order_date DATE   -- stores only date
);


/**
 * Insert Data:
*/

INSERT INTO orders (user_id, order_date)
VALUES (1, '2024-01-10');  -- Valid DATE values

INSERT INTO orders (user_id, order_date)
VALUES (2, '2024-01-25');  -- Valid DATE values


/**
 * Q. Select user name and order_date from orders joined with users.
 *    Filter orders from January 2024.
 */

SELECT 
    u.full_name,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.order_date >= '2024-01-01'
  AND o.order_date <= '2024-01-31';


