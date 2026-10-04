/**
 * Indexing:
 * - We've created postgres tables many times. 
 * - Let's see how/if indexing helps us speed up queries.
*/

/**
 * 1. Create a postgres DB:
 *    - don't use neon, we have a lot of data to store, will be very slow
 *    - docker run -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
 * 
 * 2. Connect to it and create some dummy data in it
 *    - docker exec -it container_id /bin/bash
 *    - psql -U postgres
 * 
 * 3. Create the schema for a simple medium like app (Paste in the bash terminal):
 *    CREATE TABLE users (
 *       user_id SERIAL PRIMARY KEY,
 *       email VARCHAR(255) UNIQUE NOT NULL,
 *       password VARCHAR(255) NOT NULL,
 *       name VARCHAR(255)
 *    );
 * 
 *    CREATE TABLE users (
 *       post_id SERIAL PRIMARY KEY,
 *       user_id INTEGER NOT NULL,
 *       title VARCHAR(255) NOT NULL,
 *       description TEXT,
 *       image VARCHAR(255),
 *       FOREIGN KEY (user_id) REFERENCES users(user_id)
 *    );
 * 
 * 4. Insert some dummy data in the bash terminal:
 *    DO $$
 *    DECLARE
 *       returned_user_id INT:
 *    BEGIN
 *       -- Insert 5 users
 *       FOR i IN 1..5 LOOP
 *          INSERT INTO users (email, password, name) VALUES
 *          ('user'||i||'@example.com', 'pass'||i, 'User '||i)
 *          Returning user_id INTO returned_user_id;
 * 
 *          FOR j IN 1..500000 LOOP
 *             INSERT INTO posts(user_id, title, description)
 *             VALUES (returned_user_id, 'Title'||j, 'Description for post '||j)
 *          END LOOP;
 *       END LOOP;
 *    END $$;
 * 
 * 5. Try running a query to get all the posts of a user and log the time it took:
 *    - EXPLAIN ANALYZE SELECT * FROM posts WHERE user_id=1 LIMIT 5; 
 *    - Focus on the 'execution time' - 47.198 ms for 5,00,000 rows
 *    - How can we make this faster? Indexing
 * 
 * 6. Add an index to user_id:
 *    - CREATE INDEX idx_user_id ON posts (user_id);
 *    - This command trying to tell the database: 
 *      "Hey, I will query you a lot based on the constraint on user_id, 
 *       so please index yourself on this constraint" 
 *    - Notice the execution time now.
 * 
 *  What do you think happened that caused the query time to go down by so much?
 *  First, let's understanding what exactly is an index and how does it make the query faster.
*/


/**
 * How indexing works (briefly)
 * - When you create an index on a field, a new data structure (usually B-tree) is created
 *   that stores the mapping from the 'index column' to the 'location' of the record in
 *   the original table.
 * - It means it stores the index column on side and the location (mem_addr) of the record on
 *   the other side of a table. And when we hit the command, it will directly jump the the
 *   actual location.
 * - Search on the index is usually log(n)
 * 
 * # Without Indexes:
 *   
 *   posts
 *   +---------+---------+----------+-------------+  |
 *   | post_id | user_id | title    | description |  |
 *   +---------+---------+----------+-------------+  | SELECT *
 *   | 1.      | 1.      | hi there | hello       |  | FROM users
 *   | 2.      | 2.      | hi there | hello       |  | WHERE id=1;
 *   | 3.      | 3.      | hi there | hello       |  |
 *   | 4.      | 4.      | hi there | hello       |  | (Full Scan)
 *   | 5.      | 5.      | hi there | hello       |  |
 *   +---------+---------+----------+-------------+  V
 * 
 * # With Indexes:
 *   - SELECT * FROM users WHERE id=1
 *     -> Search the relevant records O(log(n))
 *     -> Get the record from the posts table (1)
 *   posts                                                 posts_index
 *   +---------+---------+----------+-------------+       +----------+-------------+
 *   | post_id | user_id | title    | description |       | index    |  location   |
 *   +---------+---------+----------+-------------+       +----------+-------------+
 *   | 1.      | 1.      | hi there | hello       |<------|  1.      |  1          |
 *   | 2.      | 2.      | hi there | hello       |<------|  2.      |  2          |
 *   | 3.      | 3.      | hi there | hello       |       |  3.      |  3          |
 *   | 4.      | 4.      | hi there | hello       |       |  4.      |  4          |
 *   | 5.      | 5.      | hi there | hello       |       |  5.      |  5          |
 *   +---------+---------+----------+-------------+       +----------+-------------+
 *                                                           |
 *                                                           V
 *                                                        Column is sorted
 * 
 *   - The data-pointer (in case of postgres) is the 'page' and 'offset' at which this record
 *     can be found.
 *   - Think of the index as the 'appendix' of a book and the 'location' as the 'page+offset'
 *     of where this data can be found.
*/


/**
 * Complex Indexes:
 * - You can have index on more than one column for more complex queries.
 * - For example, Give me all the posts of a user with given id with title "Class 1".
 * - This index needs to have two keys now:
 *   CREATE INDEX idx_posts_user_id_title ON posts (description, title);
 * 
 * # Try searching before the index is added and after is added:
 *   SELECT * FROM posts WHERE title="title" AND description="my title";
*/