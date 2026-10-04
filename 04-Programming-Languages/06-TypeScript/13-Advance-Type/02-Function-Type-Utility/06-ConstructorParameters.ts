/**
 * ConstructorParameters<T>
 * - `ConstructorParameters<T>` extracts the parameter types
 *   of a class constructor and returns them as a tuple.
 * - It is useful when you want to reuse a constructor's
 *   parameter types without writing them again.
 */

/**
 * First, we'll define a class with a constructor.
 */
class User {
    constructor(
        public name: string,
        public age: number
    ) {}
}

/**
 * Using `ConstructorParameters`, we extract the
 * constructor parameter types of `User`.
 */
type UserConstructorParams = ConstructorParameters<typeof User>;

/**
 * Since the extracted type is a tuple, the values
 * must follow the same order as the constructor parameters.
 */
const userData: UserConstructorParams = ["Rohan", 23];

console.log(userData);

/**
 * Explanation
 * - `ConstructorParameters<typeof User>` extracts the
 *   parameter types from the constructor.
 *
 *   Constructor:
 *
 *   constructor(name: string, age: number)
 *
 *   becomes:
 *
 *   [string, number]
 *
 * - Since `UserConstructorParams` is a tuple, the values
 *   must be provided in the same order as the constructor parameters.
 */