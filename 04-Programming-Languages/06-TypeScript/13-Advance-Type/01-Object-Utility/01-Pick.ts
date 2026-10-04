/**
 * Pick<T, Keys>:
 * - Select specific properties of an object type.
 * - It means Pick<T, Keys> creates a new type by selecting only the specified
 *   properties from an existing type.
 * - It is useful when we need only a subset of an object's properties.
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
 * Using `Pick`, we create a new type that contains only `id`, `name`,
 * and `age` from the `User` interface.
 */
type UpdateUser = Pick<User, "id" | "name" | "age">;

/**
 * Since `UpdateUser` contains only the selected properties,
 * we can create an object with just those fields.
 */
const user: UpdateUser = {
    id: 9876,
    name: "Rohan",
    age: 23
};

console.log(user);

/**
 * Explanation
 * - `Pick<User, "id" | "name" | "age">` creates a new type by selecting only
 *   these three properties from `User`.
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
 *   }
 *
 * - Since `email` and `password` are not part of `UpdateUser`,
 *   they cannot be added to the `user` object.
 */