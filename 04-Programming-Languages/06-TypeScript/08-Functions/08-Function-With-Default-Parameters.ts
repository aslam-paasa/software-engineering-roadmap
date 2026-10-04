/**
 * Default Parameters
 * - A default parameter has a predefined value.
 * - If no value is passed, the default value is used automatically.
 * - If a value is provided, it overrides the default value.
 */

/**
 * First, we'll define a function with a default parameter.
 */
function greet(name: string, message: string = "Hello"): void {
    console.log(`${message}, ${name}`);
}

greet("Rohan");                 // Uses default value
greet("Rohan", "Good Morning"); // Overrides default value

/**
 * Explanation
 * - `message: string = "Hello"` assigns `"Hello"`
 *   as the default value.
 *
 *   Function:
 *
 *   greet(name: string, message: string = "Hello"): void
 *
 * - If `message` is not passed, `"Hello"` is used.
 * - If `message` is passed, the provided value replaces
 *   the default value.
 */