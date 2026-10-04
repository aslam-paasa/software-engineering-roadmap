/**
 * unknown Type in TypeScript
 * > The 'unknown' type means a variable can store any value,
 *   but TypeScript will NOT allow you to use it directly without 
 *   checking its type first.
 * > Think: "unknown = I don’t know the type yet"
 */


/**
 * Example:
 */

let dataTwo: unknown = 10;

dataTwo = "hello";
dataTwo = true;
dataTwo = { name: "Aslam" };
// All values allowed ✅


/**
 * But you cannot use it directly
 */

// ❌ Error
// console.log(data.toUpperCase());


/**
 * ✅ You must check type first
 */

if (typeof data === "string") {
  console.log(data.toUpperCase()); // works ✅
}


/**
 * Why use 'unknown'?
 * - Safer than 'any'
 * - Forces you to check type before using
 * - Prevents runtime errors
 */


/**
 * Difference from 'any'
 * > any     → no checking at all    ❌
 * > unknown → must check before use ✅
 */


/**
 * When to use?
 * - When type is not known initially
 * - When handling API responses
 * - When working with dynamic data
 */