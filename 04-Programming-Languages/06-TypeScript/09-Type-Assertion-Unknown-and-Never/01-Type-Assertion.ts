/**
 * Where Type Assertion Fails?
 * - Suppose we receive a response from anywhere, such as the web, an API call,
 *   or any external source, so we declare its type as `any`.
 * - Later, the response contains the value `"42"`. Even though the value is a
 *   string, TypeScript still treats its type as `any`.
 * - Since the type is `any`, TypeScript cannot provide proper string methods
 *   and IntelliSense. Therefore, we need to use Type Assertion.
 * 
 * - Solution: We wrap the response in parentheses and tell TypeScript that this
 *   response is a `string`. After the assertion, TypeScript provides all string
 *   properties and methods. This is called "Type Assertion", where we explicitly
 *   tell the compiler what type the value should be.
 */

let response: any = "42";

let numericLength: number = (response as string).length;


/* Example */
type Books = {
    name: string
}

let bookString= '{ "name": "who moved my cheese" }'
let bookObject = JSON.parse(bookString) as Books

 /**
  * Explanation
  * - We use the Books type because we already knoww that the JSON string represents
  *   a Book object with a name property.
  * - By writing 'as Books', we tell TypeScript: "Treat this parsed object as a Books
  *   object because I know its structure."
  * - Without 'as Books', bookObject remains any, so TypeScript cannot provide
  *   proper type checking and IntelliSense.
*/


/* Example */
const inputElement = document.getElementById("username") as HTMLInputElement;

/**
 * Explanation
 * - `document.getElementById()` returns `HTMLElement | null` because it does not
 *   know the exact type of the HTML element.
 * - We use `as HTMLInputElement` because we already know that the element with
 *   id `"username"` is an `<input>` element.
 * - This allows TypeScript to provide input-specific properties such as
 *   `.value`, `.placeholder`, and `.focus()`.
 */