/**
 * Promise.resolve() in JavaScript:
 *
 * Promise.resolve() is used to create a promise
 * that is already RESOLVED.
 *
 * Simple meaning:
 * - It creates a successful promise immediately
 * - No waiting, no async work needed
 *
 * Important points:
 * 1. Promise.resolve() returns a NEW Promise.
 * 2. The returned promise is already fulfilled.
 * 3. It is often used to:
 *    - wrap a normal value into a promise
 *    - normalize sync and async code
 */

/**
 * Syntax:
 * Promise.resolve(value);
 *
 * value:
 * - Can be anything (number, string, object, promise)
 *
 * Return value:
 * - A resolved Promise
 */

/* Simple Example */
const promise = Promise.resolve("Hello");

promise.then(value => {
    console.log(value);
});

// Output:
// "Hello"

/**
 * Step-by-step flow:
 *
 * Promise.resolve("Hello")
 * → creates a resolved promise
 * → then() runs immediately
 */

/**
 * Promise.resolve() with a value:
 */
Promise.resolve(100)
    .then(val => console.log(val));

// Output:
// 100

/**
 * Promise.resolve() with an object:
 */
Promise.resolve({ name: "JS" })
    .then(obj => console.log(obj));

// Output:
// { name: "JS" }

/**
 * Important behavior:
 *
 * If you pass a PROMISE into Promise.resolve():
 * - It returns the SAME promise
 */

/* Example */
const p = new Promise(res => setTimeout(res, 1000, "Done"));

Promise.resolve(p).then(val => console.log(val));

// Output (after 1s):
// "Done"

/**
 * Promise.resolve() vs new Promise():
 *
 * new Promise():
 * - Used when you need async logic
 *
 * Promise.resolve():
 * - Used when you already have a value
 */

/**
 * Real-world use cases:
 *
 * - Convert sync data to promise
 * - Ensure function always returns a promise
 * - Use inside Promise.all(), race(), any()
 */

/* Example: normalize return type */
function getData(value) {
    return Promise.resolve(value);
}

getData("Data received")
    .then(result => console.log(result));

/**
 * Promise.resolve() vs Promise.reject():
 *
 * Promise.resolve() → success promise
 * Promise.reject()  → failed promise
 */

/**
 * Final understanding:
 *
 * Promise.resolve():
 * - Creates a fulfilled promise
 * - Useful for consistency
 * - No async delay
 *
 * Promise.resolve() = "instant success promise"
 */



/**
 *                  resolve(value)
 *                 +-------------->Fulfilled----------->.then(cb) runs
 *                 |              (has value)
 *                 |
 *  Pending -------+
 * (Waiting)       |
 *                 |
 *                 +-------------->Rejected------------>.catch(cb) runs
 *                  reject(reason) (has a reason)
 * +------------------------------------------------------------------------------+
 * | Once settled (fulfilled or rejected), a Promise can never change state again |
 * +------------------------------------------------------------------------------+
*/


/**
 * Now let's understand what Promise.resolve and Promise.reject actually do:
 * They're static shortcut methods that skip 'pending' state entirely:
 * 
 * > These two are equivalent:
 *   a. new Promise((resolve)) => resolve(42)
 *      Promise.resolve(42)
 *   b. new Promise((_, reject) => reject("oops"))
 *      Promise.reject("oops") 
*/


/**
 * Polyfill of Promise.resolve():
*/

if (!Promise.myResolve) {
  Promise.myResolve = function(value) {

    // If value is already a Promise (or "thenable"), just return it as-is.
    // No need to wrap it in another Promise.
    if (value && typeof value.then === 'function') {
      return value;
    }

    // Otherwise, wrap the plain value in a new Promise
    // and immediately resolve it.
    return new Promise(function(resolve) {
      resolve(value);
    });
  };
}



/**
 * Polyfill of Promise.reject:
*/
if (!Promise.myReject) {
  Promise.myReject = function(reason) {

    // Always wrap in a new Promise and immediately reject.
    // Unlike resolve, we never check if reason is a thenable —
    // we always reject, no matter what.
    return new Promise(function(_, reject) {
      reject(reason);
    });
  };
}



/**
 * Testing Both:
*/

/* Promise.resolve() */
Promise.myResolve(100).then(function(val) {
  console.log(val); // 100
});

/* a. Passing a plain string */
Promise.myResolve("hello").then(function(val) {
  console.log(val); // "hello"
});

/* b. Passing an existing Promise — returns it as-is (no double-wrapping) */ 
var existing = Promise.resolve(42);
Promise.myResolve(existing).then(function(val) {
  console.log(val); // 42
});


/* Promise.myReject */
Promise.myReject("something went wrong").catch(function(err) {
  console.log(err); // "something went wrong"
});

/* Rejecting with an Error object (best practice) */
Promise.myReject(new Error("network failed")).catch(function(err) {
  console.log(err.message); // "network failed"
});