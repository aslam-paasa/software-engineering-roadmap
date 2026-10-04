/**
 * NonNullable<T>
 *
 * - `NonNullable<T>` creates a new type by removing
 *   `null` and `undefined` from an existing type.
 * - It is useful when a value must always exist.
 */

/**
 * First, we'll define a type that can contain a string,
 * `null`, or `undefined`.
 */
type UserName = string | null | undefined;

/**
 * Using `NonNullable`, we remove `null` and `undefined`
 * from the type.
 */
type ValidUserName = NonNullable<UserName>;

/**
 * The function now accepts only a valid string.
 */
const greetUser = (name: ValidUserName) => {
    console.log(`Hello, ${name}`);
};

greetUser("Rohan");      // Valid
// greetUser(null);      // Error
// greetUser(undefined); // Error

/**
 * Explanation
 * - `NonNullable<UserName>` removes `null` and `undefined`
 *   from the type.
 *
 *   UserName:
 *
 *   string | null | undefined
 *
 *   becomes:
 *
 *   string
 *
 * - Since `null` and `undefined` are removed, only a valid
 *   string can be passed to the `greetUser()` function.
 */