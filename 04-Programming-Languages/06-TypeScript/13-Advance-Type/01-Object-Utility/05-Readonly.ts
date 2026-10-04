/**
 * Readonly<T>
 * - Make all properties read-only (immutable).
 * - It means `Readonly<T>` makes all properties of a type read-only.
 * - Once a value is assigned, it cannot be modified.
 * - It is useful for creating immutable objects.
 */

/**
 * First, we'll define a User interface with a few properties.
 */
interface User {
    id: number;
    name: string;
}

/**
 * Using `Readonly`, we create an object whose properties
 * cannot be modified after initialization.
 */
const readOnlyUser: Readonly<User> = {
    id: 1,
    name: "Rohan"
};

console.log(readOnlyUser);

/**
 * readOnlyUser.id = 2;          // Error
 * readOnlyUser.name = "Gaurav"; // Error
 */

/**
 * Explanation
 * - `Readonly<User>` creates a new type where every property
 *   becomes read-only.
 *
 *   User:
 *   {
 *     id: number;
 *     name: string;
 *   }
 *
 *   becomes:
 *
 *   {
 *     readonly id: number;
 *     readonly name: string;
 *   }
 *
 * - Once the object is created, its properties cannot be reassigned.
 * - Any attempt to modify `id` or `name` results in a TypeScript error.
 */