/**
 * Exclude<T, U>
 * - `Exclude<T, U>` creates a new union type by removing the specified members from 
 *   an existing union type.
 * - It is useful when you want all union members except a few.
 */

/**
 * First, we'll define a union type representing different events.
 */
type EventType = "click" | "scroll" | "mousemove";

/**
 * Using `Exclude`, we remove `"scroll"` from `EventType`.
 */
type ExcludeType = Exclude<EventType, "scroll">;

/**
 * The function now accepts only `"click"` or `"mousemove"`.
 */
const handleEvent = (event: ExcludeType) => {
    console.log(`Handling Event: ${event}`);
};

handleEvent("click");       // Valid
// handleEvent("scroll");   // Error

/**
 * Explanation
 * - `Exclude<EventType, "scroll">` removes `"scroll"`
 *   from the union type.
 *
 *   EventType:
 *
 *   "click" | "scroll" | "mousemove"
 *
 *   becomes:
 *
 *   "click" | "mousemove"
 *
 * - Since `"scroll"` is excluded, it cannot be passed
 *   to the `handleEvent()` function.
 */