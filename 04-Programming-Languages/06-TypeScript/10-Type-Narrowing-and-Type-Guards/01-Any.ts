/**
 * any Type in TypeScript
 * > The 'any' type means a variable can store any kind of value.
 * > TypeScript will NOT check the type of this variable.
 * > Think: "anything is allowed"
 */


/**
 * Example:
 */

let dataOne: any = 10;        // number
dataOne = "hello";            // string
dataOne = true;               // boolean
dataOne = { name: "Aslam" };  // object

// All are allowed ✅ (no type checking)


/**
 * Why 'any' is risky?
 * - No type safety
 * - Errors can happen at runtime
 * - Hard to debug in large projects
 */


/**
 * When to use 'any'?
 * - When you don’t know the type yet
 * - Temporary use during development
 * - Avoid using it too much
 */


/**
 * Better Alternative:
 * > Use 'unknown' instead of 'any'
 * > (safer option with type checking)
 */