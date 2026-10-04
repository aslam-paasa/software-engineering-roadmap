/**
 * Types:
*/

type TypeA = { propA: number };
const objectA: TypeA = { propA: 22 };

type TypeB = { propB: string };
const objectB: TypeB = { propB: "tanay" };

/**
 * Intersection: ('&')
 * > Intersection means combining multiple types into one.
 *   The new type must have ALL properties from both types.
 * > If TypeC is an intersection of TypeA and TypeB, then all the common
 *   properties of TypeA and TypeB are mandatory in TypeC i.e.
 *   a. propA
 *   b. propB
 */
type TypeC = TypeA & TypeB;
const objectC: TypeC = { propA: 33, propB: "aslam" };
/* Both propA and propB are required */


/**
 * Union: OR ('|')
 * > Union means a value can be ONE of multiple types. ("OR")
 * > Syntax: let variableName: type1 | type2;
 *   (Not mandatory)
*/
type TypeD = TypeA | TypeB;
const objectD: TypeD = { propB: "neha" }; 
/* Only one type is enough */

/**
 * any Type
 * > 'any' means TypeScript will not check the type.
 * > You can assign any value (number, string, object, etc.)
 *   (Not recommended in most cases)
 */

let data: any = 10;
data = "hello";
data = true;
/* All allowed (no type safety) */


/**
 * Easy Summary
 * 1. Intersection (&) → Combine types (ALL required)
 * 2. Union (|)        → Choose one type (ANY one)
 * 3. any              → No type checking (avoid if possible)
 */