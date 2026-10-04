/**
 * Interface vs Generics
 *
 * Interface
 * - An interface describes the structure (shape) of an object.
 * - It defines which properties and their types an object must have.
 * - Use an interface when the structure of the data is fixed.
 *
 * Generics
 * - Sometimes we want to use the same code with different data types.
 * - Instead of writing separate code for `string`, `number`, `boolean`, etc.,
 *   Generics let us write the code only once using a type placeholder (like `T`).
 * - The data type is chosen when the function, class, or interface is used.
 */


/* Interface Example */

interface User {
    name: string;
    age: number;
}

const user: User = {
    name: "Rohan",
    age: 23
};


/** 
 * Generic Function
 * - A generic function uses a type parameter (`T`) to work with different data types.
 */

function identity<T>(value: T): T {
    return value;
}

identity<string>("Rohan");
identity<number>(23);

console.log(name);
console.log(age);

/**
 * Explanation
 * - `<T>` is a placeholder for a type.
 * - When calling the function, TypeScript replaces `T` with the provided type.
 *   a. identity<string>("Rohan") → T becomes string
 *   b. identity<number>(23)      → T becomes number
 * - The function returns the same type that it receives.
 */


/**
 * Generic Interface
 * - A generic interface can work with different types of data.
 */

interface ApiResponse<T> {
    success: boolean;
    data: T;
}

const user: ApiResponse<{ name: string; age: number }> = {
    success: true,
    data: {
        name: "Rohan",
        age: 23
    }
};

console.log(user);

/**
 * Explanation
 * - `T` represents the type of the `data` property.
 * - ApiResponse<User> becomes:
 *   {
 *     success: boolean;
 *     data: User;
 *   }
 * - This allows the same interface to be reused for different response types.
 */


/**
 * Generic Class
 * - A generic class can store different types of data while maintaining type safety.
 */

class Box<T> {
    constructor(public value: T) {}
}

const stringBox = new Box<string>("Chai");
const numberBox = new Box<number>(100);

console.log(stringBox.value);
console.log(numberBox.value);

/**
 * Explanation
 * - `T` represents the type stored inside the class.
 *   a. Box<string> → value: string
 *   b. Box<number> → value: number
 * - The same class can be reused for different data types.
 */


/**
 * Generic Constraints
 * - Generic constraints restrict the types that can be passed to a generic.
 */

interface Length {
    length: number;
}

function printLength<T extends Length>(value: T): void {
    console.log(value.length);
}

printLength("Hello");
printLength([1, 2, 3]);
// printLength(100); // Error

/**
 * Explanation
 * - `T extends Length` means `T` must have a `length` property.
 *
 * - Valid:
 *   - string
 *   - array
 *   - objects with a `length` property
 *
 * - Invalid:
 *   - number
 *   - boolean
 *
 * - This provides flexibility while enforcing required properties.
 */