/**
 * Extract<T, U>
 * - `Extract<T, U>` creates a new union type by keeping only
 *   the members that are common to both types.
 * - It is useful when you want to filter and keep specific
 *   values from a union type.
 */

/**
 * First, we'll define a union type representing different events.
 */
type EventType = "click" | "scroll" | "mousemove";

/**
 * Using `Extract`, we keep only `"click"` and `"scroll"`
 * from `EventType`.
 */
type ExtractType = Extract<EventType, "click" | "scroll">;

/**
 * The function now accepts only `"click"` or `"scroll"`.
 */
const handleEvent = (event: ExtractType) => {
    console.log(`Handling Event: ${event}`);
};

handleEvent("click");      // Valid
handleEvent("scroll");     // Valid
// handleEvent("mousemove"); // Error

/**
 * Explanation
 * - `Extract<EventType, "click" | "scroll">` keeps only the
 *   common members from the union type.
 *
 *   EventType:
 *
 *   "click" | "scroll" | "mousemove"
 *
 *   becomes:
 *
 *   "click" | "scroll"
 *
 * - Since `"mousemove"` is not part of the extracted type,
 *   it cannot be passed to the `handleEvent()` function.
 */