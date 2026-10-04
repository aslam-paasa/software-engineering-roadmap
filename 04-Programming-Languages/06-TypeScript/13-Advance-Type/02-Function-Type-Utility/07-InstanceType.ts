/**
 * InstanceType<T>
 * - `InstanceType<T>` extracts the instance type created
 *   by a class constructor.
 * - It is useful when you want to reuse the type of objects
 *   created from a class.
 */

/**
 * First, we'll define a class.
 */
class User {
    constructor(
        public name: string,
        public age: number
    ) {}
}

/**
 * Using `InstanceType`, we extract the instance type
 * created by the `User` class.
 */
type UserInstance = InstanceType<typeof User>;

/**
 * Since `UserInstance` represents an object created
 * from the `User` class, it must have the same structure.
 */
const user: UserInstance = new User("Rohan", 23);

console.log(user);

/**
 * Explanation
 * - `InstanceType<typeof User>` extracts the instance
 *   type created by the `User` class.
 *
 *   Class:
 *
 *   class User {
 *     name: string;
 *     age: number;
 *   }
 *
 *   becomes:
 *
 *   {
 *     name: string;
 *     age: number;
 *   }
 *
 * - Since `UserInstance` represents an instance of `User`,
 *   it can store only objects created from the `User` class.
 */