/**
 * Required<T>:
 * - Make all properties required.
 * - It means `Required<T>` makes all optional properties mandatory.
 * - It is useful when every property must be provided.
 */

/* Example */

type ChaiOrder = {
    name?: string;
    quantity?: number;
};

const placeOrder = (order: Required<ChaiOrder>) => {
    console.log(order);
};

placeOrder({
    name: "Masala Chai",
    quantity: 2
}); // Valid

// placeOrder({}); // Error

/**
 * Explanation
 * - `Required<ChaiOrder>` converts:
 *
 *   {
 *     name?: string;
 *     quantity?: number;
 *   }
 *
 *   into:
 *
 *   {
 *     name: string;
 *     quantity: number;
 *   }
 *
 * - Since every property becomes required, we must provide both `name`
 *   and `quantity`. Otherwise, TypeScript throws an error.
 */