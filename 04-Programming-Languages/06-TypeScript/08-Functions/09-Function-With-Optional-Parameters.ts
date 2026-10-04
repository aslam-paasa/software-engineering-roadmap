/**
 * Optional Parameters
 * - An optional parameter is marked using `?`.
 * - It is not mandatory to pass an optional parameter
 *   while calling the function.
 * - Optional parameters must come after required parameters.
 */

/**
 * First, we'll define a function with one required
 * parameter and one optional parameter.
 */
function greet(name: string, message?: string): void {
    if (message) {
        console.log(`${message}, ${name}`);
        return;
    }

    console.log(`Hello, ${name}`);
}

greet("Rohan");                  // Valid
greet("Rohan", "Good Morning");  // Valid

/**
 * Explanation
 * - `message?: string` means the parameter is optional.
 *
 *   Function:
 *
 *   greet(name: string, message?: string): void
 *
 * - We can call the function:
 *   - With only the required parameter.
 *   - Or with both parameters.
 *
 * - If `message` is not provided, its value becomes `undefined`.
 */