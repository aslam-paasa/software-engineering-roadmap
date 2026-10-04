/**
 * Introducing Interfaces:
 * - interface InterfaceName {
 *      propertyName: propertyType
 *      anotherProperty: anotherPropertyType
 *   }
*/

/**
 * Q. Define an interface named Person with properties name(string),
 *    Then, declare a variable person that adheres to this interface.
*/

// type PersonOne {
//     name: String,
//     age: number
// }

/* Note: Use interface for classes instead of type */

interface PersonOne {
    name: string
    age: number
}

const person: PersonOne = {
    name: 'Alice',
    age: 30,
}
