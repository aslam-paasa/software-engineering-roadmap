/**
 * Record<Keys, Type>
 * - `Record<Keys, Type>` creates an object type where every key has the same value type.
 * - It is useful when you want a fixed set of keys with consistent value types.
 */

/**
 * First, we'll define a union type representing different user roles.
 */
type UserRoles = "admin" | "user" | "guest";

/**
 * Using `Record`, we create an object where every role
 * is mapped to a string permission.
 */
const userPermissions: Record<UserRoles, string> = {
    admin: "Full Access",
    user: "Limited Access",
    guest: "Read-Only Access"
};

console.log(userPermissions);

/**
 * Explanation
 * - `Record<UserRoles, string>` creates an object type where:
 *   - Keys must be: `"admin" | "user" | "guest"`
 *   - Values must be of type `string`
 *
 *   It becomes:
 *
 *   {
 *     admin: string;
 *     user: string;
 *     guest: string;
 *   }
 *
 * - Since all keys are required, omitting any role or adding
 *   an extra key results in a TypeScript error.
 */