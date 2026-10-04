/**
 * Awaited<T>
 * - `Awaited<T>` extracts the resolved value type of a `Promise`.
 * - It is useful when you want to reuse the type returned after
 *   a Promise is resolved.
 */

/**
 * First, we'll define an async function that returns
 * a Promise containing a user object.
 */
async function fetchUser() {
    return {
        name: "Rohan",
        age: 23
    };
}

/**
 * Using `Awaited`, we extract the resolved type
 * of the Promise returned by `fetchUser`.
 */
type User = Awaited<ReturnType<typeof fetchUser>>;

/**
 * Since `User` represents the resolved value of the Promise,
 * it must have the same structure.
 */
const user: User = {
    name: "Rohan",
    age: 23
};

console.log(user);

/**
 * Explanation
 * - `ReturnType<typeof fetchUser>` gives:
 *
 *   Promise<{
 *     name: string;
 *     age: number;
 *   }>
 *
 * - `Awaited<...>` unwraps the `Promise` and extracts
 *   its resolved value.
 *
 *   Promise<{
 *     name: string;
 *     age: number;
 *   }>
 *
 *   becomes:
 *
 *   {
 *     name: string;
 *     age: number;
 *   }
 *
 * - Since `User` is the resolved type, it matches the
 *   value returned after `await fetchUser()`.
 */