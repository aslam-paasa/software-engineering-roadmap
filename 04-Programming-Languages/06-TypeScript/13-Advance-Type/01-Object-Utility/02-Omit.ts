/**
 * Omit<T, Keys>
 * - Remove specific properties from an object type.
 * - It means Omit<T, Keys> creates a new type by removing the specified
 *   properties from an existing type.
 * - It is useful when we want almost all properties except a few.
 */

/**
 * First, we'll define a User interface with several properties.
 */
interface User {
    id: number;
    name: string;
    age: number;
    email: string;
    password: string;
}

/**
 * Using `Omit`, we create a new type by removing `password`
 * from the `User` interface.
 */
type PublicUser = Omit<User, "password">;

/**
 * Since `PublicUser` does not contain the `password` property,
 * we can create an object without it.
 */
const user: PublicUser = {
    id: 9876,
    name: "Rohan",
    age: 23,
    email: "rohan@gmail.com"
};

console.log(user);

/**
 * Explanation
 * - `Omit<User, "password">` creates a new type by removing only
 *   the `password` property from `User`.
 *
 *   User:
 *   {
 *     id: number;
 *     name: string;
 *     age: number;
 *     email: string;
 *     password: string;
 *   }
 *
 *   becomes:
 *
 *   {
 *     id: number;
 *     name: string;
 *     age: number;
 *     email: string;
 *   }
 *
 * - Since `password` is omitted, it cannot be added to the `user` object.
 */