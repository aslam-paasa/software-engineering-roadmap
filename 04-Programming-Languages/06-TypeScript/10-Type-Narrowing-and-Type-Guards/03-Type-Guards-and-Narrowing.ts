/**
 * Type Guards:
 * > A way to check the type of a variable
 * > Helps us know what type we are working with
 * > Think: "check the type"
 * 
 * Type Narrowing:
 * > After checking, TypeScript reduces the type to a more specific one
 * > Think: "make type more specific"
 * 
 * How are they related?
 * > Type Guard (check) ➜ Type Narrowing (result)
 * > Flow: unknown/union → check (type guard) → narrowed type → safe usage
 */


/**
 * Example 1: typeof
 * > Type Guards   : typeof check
 * > Type Narrowing: kind becomes string Or number
*/
function getChai(kind: string | number) {
    if (typeof kind === "string") {
        return `Making ${kind} chai...`; // string
    }
    return `Chai order #${kind}`; // number
}


/**
 * Example 2: truthy check 
 * > Guard    : in
 * > Narrowing: person is Admin
*/

function serveChai(msg?: string) {
    if (msg) {
        return `Serving ${msg}`;
    }
    return `Serving default masala chai`;
}


/* Example 3: literal check */

function orderChai(size: "small" | "medium" | "large" | number) {
    if (size === "small") {
        return `Small cutting chai`;
    }

    if (size === "medium" || size === "large") {
        return `Make extra chai`;
    }

    return `Chai order #${size}`; // number
}


/* Example 4: instanceof */

class KulhadChai {
    serve() {
        return `Serving Kulhad Chai`;
    }
}

class CuttingChai {
    serve() {
        return `Serving Cutting Chai`;
    }
}

function serve(chai: KulhadChai | CuttingChai) {
    if (chai instanceof KulhadChai) {
        return chai.serve();
    }

    return chai.serve(); // CuttingChai
}


/* Example 5: Custom Type Guard */

type ChaiOrder = {
    type: string;
    sugar: number;
};

/**
 * Custom type guard
 * > checks if object matches ChaiOrder
 */
function isChaiOrder(obj: unknown): obj is ChaiOrder {
    return (
        typeof obj === "object" &&
        obj !== null &&
        "type" in obj &&
        "sugar" in obj
    );
}

function serveOrder(item: ChaiOrder | string) {
    if (isChaiOrder(item)) {
        return `Serving ${item.type} chai with ${item.sugar} sugar`;
    }

    return `Serving custom chai: ${item}`;
}


/* Example 6: Discriminated Union (VERY IMPORTANT) */

type MasalaChai = { type: "masala"; spicelevel: number };
type GingerChai = { type: "ginger"; spicelevel: number };
type ElaichiChai = { type: "elaichi"; spicelevel: number };

type Chai = MasalaChai | GingerChai | ElaichiChai;

/**
 * Using switch → best way for union types
 */
function makeChai(order: Chai) {
    switch (order.type) {
        case "masala":
            return `Masala Chai with spice level ${order.spicelevel}`;

        case "elaichi":
            return `Elaichi Chai with spice level ${order.spicelevel}`;

        case "ginger":
            return `Ginger Chai with spice level ${order.spicelevel}`;

        default:
            return "Unknown chai";
    }
}

/* Example 7: 'in' operator */

function brew(order: MasalaChai | GingerChai) {
  if ("spicelevel" in order) {
    // both types have spicelevel → safe to use
    return `Brewing chai with spice level ${order.spicelevel}`;
  }
}



/**
 * Summary
 * - Type narrowing makes type more specific
 * - Happens after type checking
 */


/**
 * Easy Understanding
 * > any        → no checking 
 * > unknown    → check first 
 * > type guard → how you check 
 * > narrowing  → result after check 
 * 
 * Flow: unknown → check → narrowed → safe usage
 */