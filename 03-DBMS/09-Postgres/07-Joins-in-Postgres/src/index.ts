/**
 * Command:
 * 1. npm init -y
 * 2. npm install typescript
 * 3. npx tsc --init
 *    - Go to tsconfig.json:
 *      - "rootDir": "./src",
 *      - "outDir": "./dist"
 * 4. Create a src folder
 * 5. Create a index.ts file
 * 6. npm install pg
 * 7. npm install @types/pg
 * 8. package.json:
 *    - "scripts": {
 *        "dev": "tsc && node dist/index.js"
 *      }
 *    - This will compile the typescript code and run the javascript code.
 * 9. Install express:
 *    - npm install express
 *    - npm install @types/express
*/

import express from "express";
import { Client } from "pg";

const app = express();
app.use(express.json());

/**
 * 1. Database Connection:
 */
const pgClient = new Client({
  connectionString: "postgresql://neondb_owner:npg_ouM0yCUPX5wb@ep-little-bird-a1mlb6dz-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require",
});

/**
 * 2. Initialize Database (Tables):
 */
async function initApp() {
  try {
    await pgClient.connect();
    console.log("Connected to DB ✅");

    await pgClient.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL
      );
    `);

    await pgClient.query(`
      CREATE TABLE IF NOT EXISTS addresses (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        city VARCHAR(100),
        country VARCHAR(100)
      );
    `);

    await pgClient.query(`
      CREATE TABLE IF NOT EXISTS todos (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        title TEXT,
        done BOOLEAN DEFAULT false
      );
    `);

    console.log("Tables ready");

  } catch (err) {
    console.error("DB Init Failed", err);
    process.exit(1);
  }
}

/**
 * 3. SEED DATA (With Transaction):
*/
app.post("/seed", async (req, res) => {
  try {
    await pgClient.query("BEGIN");

    await pgClient.query(`
      INSERT INTO users (username, email)
      VALUES 
      ('john', 'john@mail.com'),
      ('alice', 'alice@mail.com')
      ON CONFLICT DO NOTHING;
    `);

    await pgClient.query(`
      INSERT INTO addresses (user_id, city, country)
      VALUES 
      (1, 'Delhi', 'India'),
      (2, 'Mumbai', 'India')
      ON CONFLICT DO NOTHING;
    `);

    await pgClient.query(`
      INSERT INTO todos (user_id, title, done)
      VALUES 
      (1, 'Learn JOIN', false),
      (1, 'Build Project', true),
      (2, 'Read Book', false)
      ON CONFLICT DO NOTHING;
    `);

    await pgClient.query("COMMIT");

    res.json({ message: "Seeded safely ✅" });

  } catch (err) {
    await pgClient.query("ROLLBACK");
    res.status(500).json({ error: "Seed failed" });
  }
});


/**
 * 4. Joins in SQL:
 *    > Defining relationships in SQL is easy, but joining data from 
 *      two(or more) tables together is hard. 
 *    > Relationship is connection between two tables, whereas join is 
 *      combining data from two or more tables based on a related column.
 *    > There are 4 main types of SQL joins:
 *      a. INNER JOIN:
 *         - Only returns rows that match in both tables
 *         - Ex: Only users who have addresses
 *      
 *      b. LEFT JOIN:
 *         - All rows from left table + matching rows from right table
 *         - Ex: All users, whether they have addresses or not
 *    
 *      c. RIGHT JOIN:
 *         - All rows from right table + matching rows from left table  
 *         - Ex: All addresses, whether they have associated users or not
 *    
 *      d. FULL JOIN:
 *         - All rows from both tables, whether they match or not
 *         - Ex: All users and addresses, regardless of relationships
*/


/**
 * 1. LEFT JOIN — User + Address
 */

app.get("/users/:id/metadata", async (req, res) => {

  /** STEP 1: Get user id from request */
  const { id } = req.params;

  try {

    /**
     * STEP 2: Execute LEFT JOIN
     *
     * JOIN NAME: LEFT JOIN
     *
     * LOGIC:
     * > LEFT table = users (main table)
     * > RIGHT table = addresses
     *
     * MATCH CONDITION:
     * > users.id = addresses.user_id
     *
     * BEHAVIOR:
     * > Always return user
     * > If address exists → include it
     * > If not → address fields = NULL
     *
     * INTERNAL FLOW (BEGINNER):
     * > Step-1: DB pehle users table se matching user dhundta hai
     * > Step-2: Fir addresses table me check karta hai ki us user ka address hai ya nahi
     * > Step-3: Agar match mila → dono tables ka data combine hota hai
     * > Step-4: Agar address nahi mila → user data aayega, address NULL hoga
     */
    const result = await pgClient.query(`
      SELECT 
        u.id AS user_id,
        u.username,
        u.email,
        a.city,
        a.country
      FROM users u
      LEFT JOIN addresses a
      ON u.id = a.user_id
      WHERE u.id = $1
    `, [id]);

    /**
     * STEP 3: Return result
     *
     * FIX + EXPLANATION:
     * > Agar user exist hi nahi karta → result empty aayega
     * > Isliye check karna zaroori hai
     */
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({
      user: result.rows[0]
    });

  } catch (err) {
    res.status(500).json({ error: "Error fetching user" });
  }
});

/**
 * 2. LEFT JOIN — User + Todos
 */

app.get("/users/:id/todos-left-join", async (req, res) => {

  /** STEP 1: Get user id */
  const { id } = req.params;

  try {

    /**
     * STEP 2: Execute LEFT JOIN
     *
     * JOIN NAME: LEFT JOIN
     *
     * LOGIC:
     * > One user → multiple todos
     * > SQL returns multiple rows (user repeated)
     *
     * Example:
     * user1 + todo1
     * user1 + todo2
     *
     * INTERNAL FLOW (BEGINNER):
     * > Step-1: DB user ko find karta hai
     * > Step-2: Todos table me us user ke saare todos dhundta hai
     * > Step-3: Har todo ke liye ek row banata hai
     * > Isliye user multiple baar repeat hota hai
     */
    const result = await pgClient.query(`
      SELECT 
        u.id,
        u.username,
        t.id AS todo_id,
        t.title,
        t.done
      FROM users u
      LEFT JOIN todos t
      ON u.id = t.user_id
      WHERE u.id = $1
    `, [id]);

    /**
     * STEP 3: Convert flat data → structured object
     *
     * WHY?
     * > SQL gives repeated rows
     * > We want nested JSON
     *
     * FIX:
     * > Agar user exist nahi kare → empty result
     */
    if (result.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    const user = {
      id: result.rows[0].id,
      username: result.rows[0].username,

      /**
       * STEP 4: Filter + Map todos
       *
       * > Remove NULL todos
       * > Convert into clean array
       *
       * INTERNAL FLOW:
       * > Agar user ke paas todo nahi hai → todo_id NULL aata hai
       * > Filter usko hata deta hai
       * > Map clean object bana deta hai
       */
      todos: result.rows
        .filter((row: any) => row.todo_id !== null)
        .map((row: any) => ({
          id: row.todo_id,
          title: row.title,
          done: row.done
        }))
    };

    /**
     * STEP 5: Send response
     */
    res.json(user);

  } catch (err) {
    res.status(500).json({ error: "Error fetching todos" });
  }
});

/**
 * 3. INNER JOIN — User + Todos
 */

app.get("/users/:id/todos-inner-join", async (req, res) => {

  /** STEP 1: Get user id */
  const { id } = req.params;

  try {

    /**
     * STEP 2: Execute INNER JOIN
     *
     * JOIN NAME: INNER JOIN
     *
     * LOGIC:
     * > Only return rows where match exists
     *
     * BEHAVIOR:
     * CASE 1:
     * > User has todos → data returned
     *
     * CASE 2:
     * > No todos → EMPTY result
     *
     * INTERNAL FLOW (BEGINNER):
     * > Step-1: DB users table se user dhundta hai
     * > Step-2: Todos table me matching rows dhundta hai
     * > Step-3: Sirf wahi rows return hoti hai jaha dono match ho
     * > Agar todo nahi mila → kuch bhi return nahi hota
     */
    const result = await pgClient.query(`
      SELECT 
        u.id,
        u.username,
        t.title
      FROM users u
      INNER JOIN todos t
      ON u.id = t.user_id
      WHERE u.id = $1
    `, [id]);

    /**
     * STEP 3: Response
     *
     * FIX:
     * > Clear handling of empty result
     */
    res.json({
      hasTodos: result.rows.length > 0,
      data: result.rows
    });

  } catch (err) {
    res.status(500).json({ error: "Error fetching data" });
  }
});

/**
 * 4. INNER JOIN — Todos + User
 */

app.get("/todos-with-users", async (req, res) => {

  try {

    /**
     * STEP 1: Execute JOIN
     *
     * JOIN NAME: INNER JOIN
     *
     * LOGIC:
     * > Main table = todos
     * > Attach user details
     *
     * USE CASE:
     * > Show todo + who created it
     *
     * INTERNAL FLOW (BEGINNER):
     * > Step-1: DB todos table se data uthata hai
     * > Step-2: Har todo ke liye user_id leta hai
     * > Step-3: Users table me match karta hai
     * > Step-4: Combined row return karta hai
     */
    const result = await pgClient.query(`
      SELECT 
        t.id,
        t.title,
        t.done,
        u.username,
        u.email
      FROM todos t
      INNER JOIN users u
      ON t.user_id = u.id
    `);

    /**
     * STEP 2: Return data
     *
     * FIX:
     * > Add count for better debugging + clarity
     */
    res.json({
      count: result.rows.length,
      todos: result.rows
    });

  } catch (err) {
    res.status(500).json({ error: "Error fetching todos" });
  }
});

/**
 * 5. Start Server:
*/
async function start() {
  await initApp();

  app.listen(3000, () => {
    console.log("Server running on http://localhost:3000 🚀");
  });
}

start();