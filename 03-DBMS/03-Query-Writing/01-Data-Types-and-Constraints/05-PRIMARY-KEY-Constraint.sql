/**
 * PRIMARY KEY Constraint:
 * > PRIMARY KEY uniquely identifies each row. 
 * > Every table should have one. 
 * > Automatically creates an index.
 * 
 * > PRIMARY KEY = UNIQUE + NOT NULL. 
 * > Each table has one. 
 * > Usually an auto-incrementing integer (SERIAL). 
 * > Ensures each row is uniquely identifiable.
*/

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,   -- unique + not null + auto increment
    full_name VARCHAR(100) NOT NULL
);


/**
 * Insert Data:
 */

-- Valid inserts (ID auto-generated)
INSERT INTO users (full_name)
VALUES ('Mohammad');

INSERT INTO users (full_name)
VALUES ('Rahul');


/**
 * Invalid Cases:
 */

-- Duplicate PRIMARY KEY (if manually inserted)
INSERT INTO users (user_id, full_name)
VALUES (1, 'Ali');  -- Error if 1 already exists

-- NULL PRIMARY KEY (not allowed)
INSERT INTO users (user_id, full_name)
VALUES (NULL, 'John');  -- Error


/**
 * Q. Select id and name from users.
 *    Notice id is unique and cannot be NULL - it's the PRIMARY KEY.
 */

SELECT 
    user_id,
    full_name
FROM users;