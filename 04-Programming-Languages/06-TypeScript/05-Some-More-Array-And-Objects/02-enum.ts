/**
 * Enum
 * - An `enum` is a special TypeScript type used to define a fixed set of named constants.
 * - It makes code more readable and type-safe by allowing only predefined values.
 * - Enums can be numeric, string, or const enums.
 */


/**
 * Numeric Enum
 * - By default, enum members are assigned numeric values starting from `0`.
 * - Each subsequent member is automatically incremented by `1`.
 */

enum CupSize {
    SMALL,
    MEDIUM,
    LARGE
}

const size = CupSize.LARGE;

console.log(size);

/**
 * Explanation
 * - TypeScript automatically assigns numeric values.
 *
 *   CupSize:
 *
 *   {
 *     SMALL  = 0,
 *     MEDIUM = 1,
 *     LARGE  = 2
 *   }
 *
 * - `CupSize.LARGE` returns `2`.
 */


/**
 * Numeric Enum with Custom Values
 * - We can assign a custom numeric value to an enum member.
 * - The following members are automatically incremented from that value.
 */

enum Status {
    PENDING = 100,
    SERVED,
    CANCELLED
}

console.log(Status);

/**
 * Explanation
 * - Since `PENDING` is assigned `100`, the remaining members are incremented automatically.
 *
 *   Status:
 *
 *   {
 *     PENDING   = 100,
 *     SERVED    = 101,
 *     CANCELLED = 102
 *   }
 */


/**
 * String Enum
 * - In a string enum, every member must be assigned a string value.
 * - String enums are commonly used for readable constants such as roles, statuses, 
 *   and categories.
 */

enum ChaiType {
    MASALA = "masala",
    GINGER = "ginger"
}

function makeChai(type: ChaiType): void {
    console.log(`Making: ${type} Chai`);
}

makeChai(ChaiType.GINGER);

/**
 * Explanation
 * - Each enum member stores a string value.
 *
 *   ChaiType:
 *
 *   {
 *     MASALA = "masala",
 *     GINGER = "ginger"
 *   }
 *
 * - The function accepts only values from `ChaiType`.
 * - Passing any other string results in a TypeScript error.
 */


/**
 * Const Enum
 * - `const enum` is similar to a normal enum, but it is removed during compilation.
 * - TypeScript replaces enum members with their actual values, resulting in smaller 
 *   and faster JavaScript.
 */

const enum Sugar {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3
}

const sugar = Sugar.LOW;

console.log(sugar);

/**
 * Explanation
 * - `const enum` members are inlined during compilation.
 *
 *   Sugar:
 *
 *   {
 *     LOW    = 1,
 *     MEDIUM = 2,
 *     HIGH   = 3
 *   }
 *
 * - `Sugar.LOW` is replaced directly with `1` in the generated JavaScript.
 * - Since no enum object is created at runtime, `const enum` is more efficient than 
 *   a regular enum.
 */