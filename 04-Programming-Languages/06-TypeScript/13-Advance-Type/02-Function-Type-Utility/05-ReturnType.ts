/**
 * ReturnType<T>
 * - `ReturnType<T>` extracts the return type of a function.
 * - It is useful when you want to reuse a function's return
 *   type without defining it again.
 */

/**
 * First, we'll define a function that returns a user object.
 */
function createUser(name: string, age: number) {
    return {
        name,
        age
    };
}

/**
 * Using `ReturnType`, we extract the return type
 * of `createUser`.
 */
type User = ReturnType<typeof createUser>;

/**
 * Since `User` represents the function's return type,
 * the object must have the same structure.
 */
const user: User = {
    name: "Rohan",
    age: 23
};

console.log(user);

/**
 * Explanation
 * - `ReturnType<typeof createUser>` extracts the return
 *   type of the function.
 *
 *   Function:
 *
 *   createUser(name: string, age: number)
 *
 *   returns:
 *
 *   {
 *     name: string;
 *     age: number;
 *   }
 *
 * - Since `User` is the extracted return type,
 *   any object of type `User` must follow the same structure.
 */