/**
 * Parameters<T>
 * - `Parameters<T>` extracts the parameter types of a function
 *   and returns them as a tuple.
 * - It is useful when you want to reuse a function's parameter
 *   types without writing them again.
 */

/**
 * First, we'll define a function with two parameters.
 */
function createUser(name: string, age: number) {
    return {
        name,
        age
    };
}

/**
 * Using `Parameters`, we extract the parameter types
 * of `createUser`.
 */
type UserParams = Parameters<typeof createUser>;

/**
 * The extracted type is a tuple, so the values must
 * follow the same order as the function parameters.
 */
const user: UserParams = ["Rohan", 23];

console.log(user);

/**
 * Explanation
 * - `Parameters<typeof createUser>` extracts the parameter
 *   types from the function.
 *
 *   Function:
 *
 *   createUser(name: string, age: number)
 *
 *   becomes:
 *
 *   [string, number]
 *
 * - Since `UserParams` is a tuple, the values must be
 *   provided in the same order as the function parameters.
 */