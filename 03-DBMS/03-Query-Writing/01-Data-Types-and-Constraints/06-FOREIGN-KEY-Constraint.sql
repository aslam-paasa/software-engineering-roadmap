/**
 * Understanding FOREIGN KEY Constraint:
 * > FOREIGN KEY creates relationships between tables. 
 * > Ensures referential integrity - can't reference non-existent IDs.
 * 
 * FOREIGN KEY links tables:
 *
 *   +--------------+    +--------------+
 *   | users table  |    | orders table |
 *   + -------------+    +--------------+
 *   | user_id (PK) |←───| user_id (FK) |
 *   +--------------+    +--------------+
 *
 *   - orders.user_id references users.id, means:
 *     orders.user_id must exist in users.user_id
 *   - Can't insert order with user_id=999 if that user doesn't exist. 
 *   - Maintains data integrity!
*/


CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


/**
 * Insert Data:
 */

-- First insert user ✅ 
INSERT INTO users (full_name)
VALUES ('Mohammad');

-- Valid order (user_id exists) ✅ 
INSERT INTO orders (user_id)
VALUES (1);

-- Invalid order (user_id does NOT exist) ❌ 
INSERT INTO orders (user_id)
VALUES (999);  -- ERROR: violates foreign key constraint

/**
 * Q. Select order id, user_id, and user name. 
 *    orders.user_id is a FOREIGN KEY referencing users.id.
*/

SELECT 
    o.order_id,
    o.user_id,
    u.full_name
FROM orders o
JOIN users u ON o.user_id = u.user_id;