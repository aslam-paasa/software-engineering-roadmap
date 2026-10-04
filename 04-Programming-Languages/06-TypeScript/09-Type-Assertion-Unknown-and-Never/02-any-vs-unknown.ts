/**
 * Difference Between `any` and `unknown`
 *
 * `any`
 * - A variable of type `any` can store any value.
 * - TypeScript completely disables type checking for it.
 * - You can directly access properties or call methods without any checks.
 * - This is flexible but unsafe because it can cause runtime errors.
 *
 * `unknown`
 * - A variable of type `unknown` can also store any value.
 * - However, TypeScript does NOT allow you to access properties or call methods
 *   until you first verify its actual type.
 * - This makes `unknown` much safer than `any`.
 */



/* Example */
let value: any;

value = "chai";
value = [1, 2, 3];
value = 2.5;

value.toUpperCase(); // No compile-time error, but may fail at runtime.

/* Example */
let newValue: unknown;

newValue = "chai";
newValue = [1, 2, 3];
newValue = 2.5;

// newValue.toUpperCase(); // Error: TypeScript doesn't know the actual type.

/**
 * Solution:
 * - Before using an `unknown` value, we must narrow its type.
 * - Here, `typeof` confirms that `newValue` is a string.
 * - After the check, TypeScript safely allows string methods.
 */
if (typeof newValue === "string") {
    newValue.toUpperCase();
}



/**
 * Example: Common Issue faced in try-catch
*/

try {

} catch (error) {
    /* Solution */
    if (error instanceof Error) {
        console.log(error.message)
    }
    console.log('Error:', error)
}



/**
 * Example: Type Assertion (Forcefully set as String Datatype)
*/
const data: unknown = 'chai aur code'
const strData: string = data as string



/**
 * 3. Void Data: RBAC (Role-Based Access Control)
*/

type Role = "admin" | "user" | "superadmin";

function redirectBasedOnRole(role: Role): void {
    if (role === "admin") {
        console.log("Redirecting to Admin Dashboard");
        return;
    }

    if (role === "user") {
        console.log("Redirecting to User Dashboard");
        return;
    }

    /* As soon as we added the new role `superadmin`,
       TypeScript automatically narrows `role` to `"superadmin"`
       because all other possible values have already been handled. */
    role;
}

/**
 * Explanation
 * - TypeScript uses Control Flow Analysis to narrow the type of `role`.
 * - After handling `"admin"` and `"user"`, the only remaining possible value is
 *   `"superadmin"`.
 * - Therefore, at the end of the function, `role` is automatically inferred as
 *   `"superadmin"` instead of the full `Role` union.
 */


/**
 * 4. Never:
*/

function neverReturnAnything(): never {
    while (true) { }
}

/**
 * Explanation
 * - The return type `never` means the function never completes normally.
 * - This function runs forever because of the infinite loop.
 * - Since it never returns a value or reaches the end of the function,
 *   `never` is the correct return type.
 */