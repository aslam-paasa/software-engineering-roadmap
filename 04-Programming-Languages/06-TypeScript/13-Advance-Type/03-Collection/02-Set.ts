/**
 * Set<T>
 * - `Set<T>` stores only unique values.
 * - Duplicate values are automatically ignored.
 * - It is useful when you want to keep only distinct values.
 */

/**
 * First, we'll create a Set that stores strings.
 */
const fruits = new Set<string>();

/**
 * Add values using `add()`.
 * Duplicate values are ignored.
 */
fruits.add("Apple");
fruits.add("Mango");
fruits.add("Apple"); // Duplicate

console.log(fruits);

/**
 * Check whether a value exists.
 */
console.log(fruits.has("Apple")); // true

/**
 * Remove a value.
 */
fruits.delete("Mango");

console.log(fruits);

/**
 * Explanation
 * - `Set<string>` means every value in the set must
 *   be of type `string`.
 *
 *   It becomes:
 *
 *   Set {
 *     "Apple",
 *     "Mango"
 *   }
 *
 * - `add()` inserts a value into the set.
 * - Duplicate values are automatically ignored.
 * - `has()` checks whether a value exists.
 * - `delete()` removes a value from the set.
 */