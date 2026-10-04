/**
 * Map<K, V>
 * - `Map<K, V>` stores data as key-value pairs.
 * - Unlike objects, a `Map` provides built-in methods such as `set()`, `get()`, `has()`,
 *   and `delete()`.
 * - It is useful when keys need to be unique and data must be
 *   accessed efficiently.
 */

/**
 * First, we'll define a User type representing user details.
 */
type UserMap = {
    name: string;
    age: number;
    email: string;
};

/**
 * Using `Map`, we create a collection where:
 * - Keys are of type `string`
 * - Values are of type `UserMap`
 */
const users = new Map<string, UserMap>();

/**
 * Add users to the map using `set()`.
 */
users.set("A", {
    name: "Rohan",
    age: 25,
    email: "rohan@example.com"
});

users.set("B", {
    name: "Gaurav",
    age: 23,
    email: "gaurav@example.com"
});

/**
 * Retrieve a user using `get()`.
 */
const selectedUser = users.get("A");

console.log(selectedUser);

/**
 * Explanation
 * - `Map<string, UserMap>` means:
 *   - Every key must be of type `string`.
 *   - Every value must follow the `UserMap` type.
 *
 *   It becomes:
 *
 *   Key   -> string
 *   Value -> {
 *              name: string;
 *              age: number;
 *              email: string;
 *            }
 *
 * - `set()` adds or updates a key-value pair.
 * - `get()` retrieves the value associated with a key.
 * - If the key does not exist, `get()` returns `undefined`.
 */