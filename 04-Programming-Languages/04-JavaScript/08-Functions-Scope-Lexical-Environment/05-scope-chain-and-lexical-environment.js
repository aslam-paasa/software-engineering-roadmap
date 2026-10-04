/**
 * Scope, Scope Chain & Lexical Environment
 * > Think of scope like floors in a building:
 *   - Ground floor = Global scope
 *   - 1st floor = function a's scope
 *   - 2nd floor = function c inside a's scope
 * > A person on the 2nd floor can see everything below — their own floor,
 *   1st floor, and ground floor. But a person on the ground floor cannot
 *   see upstairs. That's exactly how scope works in JavaScript.
*/

/**
 * What is Scope?
 * > Scope simply means: "where can I use this variable?"
*/


/**
 * Q. Can we access this 'b' inside function 'a'?
*/

// function a() {
//     console.log(b);
// }

// var b = 10;
// a();

/**
 * When JS Engine reach "console.log(b)", and it tries to execute this
 * line, JS will try to find whether 'b' exist in the local memory
 * memory space or not. Means JS Engine tries to find the 'b' in the
 * local memory of variable-a's execution context.
 * 
 * This fn-a's local memory will try to find out 'b', and it won't be
 * there because we never created 'b' inside that fn.
 * 
 * Q. Will it print undefined or not defined(b never existed) or it will
 *    print the value of 'b'?
 * => If we print the line, it will print '10'. That means somehow inside
 *    this fn-a, this 'b' can access the value of 'b' which was outside
 *    this fn-a.
*/


/**
 * Q. Now what if we try to access 'b' inside this fn-c. What will happen?
 *    Will it print undefined or not defined(b never existed) or it will
 *    print the value of 'b'?
 * => It will print '10' which is at Global Scope and out fn is present
 *    another fn and it can still access the value of 'b'.
*/
// function a() {
//     c();
//     function c() {
//         console.log(b);
//     }
// }

// var b = 10;
// a();


/**
 * Now can we still access the variable 'b'?
 * => Yes
*/
// function a() {
//     var b = 10;
//     c();
//     function c() {
//         console.log(b);
//     }
// }

// a();


/**
 * Now can we access this variable 'b' outside this fn?
 * => No -> 'b' is not defined. 
 * => So, here comes 'scope' into picture.
*/
function a() {
    var b = 10;
    c();
    function c() {
        // console.log(b);
    }
}

a();
console.log(b);


/**
 * Scope means where we can access a specific variable or fn in our
 * code.
 * 
 * There are 2 aspects of scope:
 * 1. What is the scope of this variable-b? Means where can I access
 *    this variable-b.
 * 2. Is variable-b inside the scope? So, if we say Is variable-b
 *    inside the scope of fn-c, means Can I access this variable-b
 *    inside fn-c?
 * 
 * Note: Scope is directly dependent on the lexical environment.
*/
function a() {
    var b = 10;
    c();
    function c() {
        // console.log(b);
    }
}

a();
console.log(b);

/**
 * When we run this program, a GEC is created and put onto the callstack.
 * And this GEC has Memory & Code Execution section in it. So, what
 * will happen when we run this program? It will try to assign values
 * to the global variables and functions.
 * 
 * +----------------------------------------------------------------+
 * | +----------------+----------------+
 * | | Memory         | Code Execution | LEC: fn c() incovation
 * | +----------------+----------------+
 * | | b = {undefined}|                |
 * | | c = {...} (fn) |                |
 * | |                |                |
 * | |                |                |
 * | |                |                |
 * | +----------------+----------------+
 * 
 * | +----------------+----------------+
 * | | Memory         | Code Execution | LEC: fn a() incovation
 * | +----------------+----------------+
 * | | b = {undefined}|                |
 * | | c = {...} (fn) |                |
 * | |                |                |
 * | |                |                |
 * | |                |                |
 * | +----------------+----------------+
 * 
 * | +----------------+----------------+
 * | | Memory         | Code Execution | GEC
 * | +----------------+----------------+
 * | | a = {} (fn)    |                |
 * | |                |                |
 * | |                |                |
 * | |                |                |
 * | |                |                |
 * | +----------------+----------------+
 * 
 * => Whenever an execution context is created, a Lexical Environment
 *    is also created. So, Lexical Environment is the local memory
 *    along with the Lexical Environment of its parent.
 * 
 * Q. What is Lexical Environment?
 * => "Lexical" just means where the code is physically written.
 *    The position of a function in your code determines what it can access.
 * => We can say fn-c is lexically/hierarchically sitting inside 'a' fn.
 *    Or in code term we can say fn-c is present physically inside
 *    fn-a. So, that means 'c' is lexically inside 'a', and 'a' is
 *    lexically inside Global Scope.
 * => fn-a points to Global as its Lexical Parent, but variable in
 *    Global Points to 'null', because it doesn't have any Lexical
 *    Parent.
 * 
 * Note: Child can access parent's variables as reference till GEC, but
 *       parent cannot access them. 
 * 
 * Q. What is Scope Chain?
 * => When JavaScript looks for a variable, it follows a very specific search pattern:
 *    a. Look in the current function's own memory
 *    b. Not found? Look in parent function's memory
 *    c. Not found? Look in grandparent's memory
 *    d. Keep going up until Global scope
 *    e. Still not found? ReferenceError
 * => And this way of finding is known as "Scope Chain".
 * 
*/

var global = "I am global"; // step 4 — found here

function outer() {
    var outerVar = "I am outer"; // step 3

    function inner() {
        var innerVar = "I am inner"; // step 1 — found here immediately

        console.log(innerVar);  // ✅ step 1 — own scope
        console.log(outerVar);  // ✅ step 3 — parent scope
        console.log(global);    // ✅ step 4 — grandparent scope
        console.log(nowhere);   // ❌ step 5 — ReferenceError, not found anywhere
    }

    inner();
}

outer();



/**
 * Summary in simple words:
 * 1. What is Scope?
 *    - Scope is the area where a variable/function is available
 *    - There are 3 types of scope:
 *      a. Global Scope: Available throughout the file
 *      b. Function Scope: Only available inside the function
 *      c. Block Scope: Only available inside {} (for let/const)
 * 
 * 2. Scope tells us where we can use a variable.
 *    Each function has its own scope, and it can also
 *    use variables from its parent's scope.
 * 
 * 3. Scope Chain means when JS can't find a variable,
 *    it looks in the parent scope, then parent's parent,
 *    and so on until it reaches global scope.
 * 
 * 4. Lexical Environment is just a function's own memory
 *    plus its parent's memory.
 * 
 * 5. Closure happens when a function remembers its parent's
 *    variables, even after the parent function is done.
*/