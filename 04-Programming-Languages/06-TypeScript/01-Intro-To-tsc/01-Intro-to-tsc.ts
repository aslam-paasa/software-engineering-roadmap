/**
 * Introduction to Typescript:
 * Q. Explain in your own words what TypeScript is and why it might be
 *    advantageous to use in web development.
 * 
 *    TypeScript is just like JavaScript, but better.
 *    It adds "types" to JavaScript.
 *   
 *    Types help us understand what kind of data we are using
 *    (like number, string, boolean, etc.).
 *   
 *    This helps us catch mistakes early while writing code,
 *    instead of getting errors later when the app runs.
 * 
 * Q. Why use TypeScript?
 *    - Finds errors early
 *    - Makes code easier to understand
 *    - Helps in big projects
 *    - Gives better support in editors (auto suggestions)
 *
 * Q. When should you learn TypeScript?
 *    +----+               +-------------------+
 *    | JS |-------------->| When to learn TS? |
 *    +----+               +-------------------+
 * 
 *    - After learning basic JavaScript
 *    - When building bigger projects
 *    - When working with a team
 * */ 


/**
 * Q. How TypeScript works?
 * 
 *    TypeScript code does not run directly in the browser.
 *    It first gets converted into JavaScript.
 * 
 *    +---------+         +-------+
 *    | TS Code |-------->| lexer |
 *    +---------+         +-------+
 *                            |
 *                            V
 *                        +--------+         +--------+         +---------+
 *                        | Parser |-------->| Binder |-------->| Checker |
 *                        +--------+         +--------+         +---------+
 *                                                                   |
 *                                                                   V
 *                                                              +---------+
 *                                                              | Emmiter |
 *                                                              +---------+
 *                                                                   |
 *                                                                   V
 *                                                               .js, .d.ts, .map
 *
 *   What each step does:
 *   1. Lexer  : Scans & Breaks code into small pieces (tokens)
 *   2. Parser : Understands the structure of the code
 *   3. Binder : Connects variables and functions with their scope
 *   4. Checker: Checks types and shows errors if something is wrong
 *   5. Emitter: Converts TypeScript into JavaScript files
 *
 *   Final Result:
 *   - .js   → JavaScript file (runs in browser/Node)
 *   - .d.ts → Type definitions (for developers)
 *   - .map  → Helps in debugging
 */