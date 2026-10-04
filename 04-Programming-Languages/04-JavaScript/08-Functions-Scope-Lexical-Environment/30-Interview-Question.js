/**
 * What is function declaration?
 * - Function declaration is a way to create a function.
 * - Also called as function statement or function definition.
*/

function square(num) {
    return num * num;
}


/**
 * What is function Expression?
 * - When we store a function inside of a variable, called fn expression.
*/

const squareEx = function (num) {
    return num * num;
}

/**
 * Calling a function expression:
*/
console.log(squareEx(5));


/**
 * What is anonymous function?
 * - A function without a name is called an anonymous function.
 * - It can be assigned to a variable or passed as a callback.
 * - Ex:
 *       function (num) {
 *          return num * num;
 *       }
*/


/** 
 * What are first class functions?
 * - In a language where a function is treated like a variable, is called
 *   first class functions.
 * - In these cases, function can be passed to another function, can be
 *   used, manipulated and return from those functions. So, basically
 *   it can do everything that a variable can do.
*/

function squareFn(num) {
    return num * num;
}

function displaySquare(fn) {
    console.log("Square is " + fn(5));
}

displaySquare(squareFn);


/**
 * What is IIFE?
 * - Immediately Invoked Function Expression.
 * - We wrap this function in a parenthesis and then call it immediately.
*/

(function squareIIFE(num) {
    console.log("Square is " + num * num);
})(5);


/**
 * IIFE Example:
 * - It will check in its local scope first, if not found then it will check
 *   in the parent's scope.
*/
(function (x) {
    return (function (y) {
        console.log(x);
    })(2);
})(1); // Output: 1


/**
 * Function Scope (Where variables can be used):
 * - Think of a function like a room. If you keep something inside the room,
 *   you can only use it inside that room, not outside.
 *   Example: If you write 'var x = 10' inside a function, you can only use 
 *   'x' inside that function
 * 
 * - But if you keep something outside (like in a hallway), you can use it 
 *   anywhere - both inside rooms and in the hallway.
 *   Example: If you write 'var y = 20' outside functions, you can use 'y' 
 *   anywhere in your code
*/ 

for (let i = 0; i < 5; i++) {
    setTimeout(() => {
        console.log(i); // 0, 1, 2, 3, 4
    }, i * 1000);
}

for (var i = 0; i < 5; i++) {
    setTimeout(() => {
        console.log(i); // 5, 5, 5, 5, 5
    }, i * 1000); 
}

/**
 * It will print 0, 1, 2, 3, 4.
 * - Because let is block scoped, so it will create a new block scope for
 *   each iteration.
 * - So, each time the setTimeout will print the value of i.
 * - But if we use var, it will print 5, 5, 5, 5, 5.
 * - Because var is function scoped, so it will print the value of i after
 *   the loop is finished.
*/


/**
 * Function Hoisting:
 * - JavaScript automatically moves function declarations to the top
 * - Allows calling functions before their definition
 * - Only works with normal functions, not arrow functions or variables
 * - JavaScript processes function declarations before executing code
*/

functionName(); // fn is hoisted to the top, so it will work

function functionName() {
    console.log("workattech");
}

functionName();



/**
 * Function Hoisting Example:
 * - Yahan x ki value undefined aayegi kyunki function k andar wala x
 *   upar hoist ho jaata hai, lekin uski value nahi
*/

var x = 21;

var fun = function() {
    console.log(x);     // undefined
    var x = 20;
}

fun();


/**
 * Params vs Arguments:
 * a. Args : Sending Values
 * b. Params: Receiving Values
*/

function squareParamVsArg(num) { // Params: Receiving Values
    console.log(num * num);
}

squareParamVsArg(5); // Arguments: Sending Values



/**
 * Spread Operator & Rest Operator:
 * It is used to spread the values of an array or object into individual
 * elements.
 * a. Spread Operator: Sending Values
 * b. Rest Operator  : Receiving Values
*/
function multiply(...nums) {    // Rest Operator: Receiving Values
    console.log(nums[0] * nums[1]);
}

var args = [5, 6];
multiply(...args); // Spread Operator: Sending Values



/**
 * When we use Rest Operator, it should be the last parameter in the function.
 * If we use it in the middle, it will throw an error.
 * a. a : 5
 * b. x : 6
 * c. y : 3
 * d. numbers : [7, 8, 9]
*/
const fn = (a, x, y, ...numbers) => {
    console.log(x, y);
}

fn(5, 6, 3, 7, 8, 9);


/**
 * Callback Function:
 * - A callback function is a function that is passed as an argument to 
 *   another function. 
 * - It is a function that is executed after another function has
 *   finished executing.
 * 
 * Example:
 * a. Map
 * b. Filter
 * c. Every
 * etc...
*/




/**
 * Arrow Functions:
 * - Introduced in ES6
 * - They are a shorter way to write functions
*/

const add = (firstName, secondName) => {
    return firstName + secondName;
}


/**
 * Arrow Fn Vs Normal Fn:
*/


/**
 * 1. Syntax:
*/
function normalFn() {
    return num * num;
}

const arrowFn = () => {
    return num * num;
}


/**
 * 2. Implicit "return" keyword
*/
const arrowFun = (num) => num * num;


/**
 * 3. Arguments:
*/

function normalFnArg() {
    console.log(arguments);   // arguments is defined: [1, 2, 3]
}

normalFnArg(1, 2, 3);


const arrowFnArg = () => {
    console.log(arguments);   // arguments is not defined
}

arrowFnArg(1, 2, 3);


/**
 * 4. "this" keyword:
 *    a. arrow fn : Subscribe to undefined
 *    b. normal fn: Subscribe to John
 * 
 * Because in arrow fn, 'this' keyword is pointing to the parent scope 
 * i.e. window object. But in normal fn, 'this' keyword is pointing to the
 * object that is calling the function.
*/

let user = {
    userName: "John",
    rc1: () => {
        console.log('Subscribe to ' + this.userName);
    },
    rc2() {
        console.log('Subscribe to ' + this.userName);
    }
}

user.rc1();
user.rc2();



/**
 * Closures:
 * 
*/

/**
 * PROBLEM 1: Basic closure - inner function accessing outer variable
 * - Input:  outer()() 
 * - Output: "I am from outer"
*/

function outer() {
  const message = "I am from outer";
  function inner() {
    return message;
  }
  return inner;
}
console.log(outer()());

// Output: "I am from outer"


/**
 * PROBLEM 2: Create a counter using closure
 * - Input:  counter() called 3 times
 * - Output: 1, 2, 3
*/

function createCounter() {
  let count = 0;
  return function () {
    count++;
    return count;
  };
}
const counter2 = createCounter();
console.log(counter2()); // 1
console.log(counter2()); // 2
console.log(counter2()); // 3

// Output: 1, 2, 3


/**
 * PROBLEM 3: Greeting function using closure
 * - Input:  greet("John")()
 * - Output: "Hello, John!"
*/

function createGreeter(name) {
  return function () {
    return `Hello, ${name}!`;
  };
}
const greet3 = createGreeter("John");
console.log(greet3());

// Output: "Hello, John!"


/**
 * PROBLEM 4: Closure with parameters in returned function
 * - Input:  add(5)(3)
 * - Output: 8
*/

function add(a) {
  return function (b) {
    return a + b;
  };
}
console.log(add(5)(3));

// Output: 8


/**
 * PROBLEM 5: Multiple counters with independent state
 * - Input:  counter1() twice, counter2() once
 * - Output: 1, 1, 2 (counter1: 1, counter2: 1, counter1: 2)
*/

function createCounter5() {
  let count = 0;
  return function () {
    count++;
    return count;
  };
}
const c5a = createCounter5();
const c5b = createCounter5();
console.log(c5a()); // 1
console.log(c5b()); // 1 (independent)
console.log(c5a()); // 2

// Output: 1, 1, 2


/**
 * PROBLEM 6: Closure preserving string state
 * - Input:  createTag("div")("content")
 * - Output: "<div>content</div>"
*/

function createTag(tag) {
  return function (content) {
    return `<${tag}>${content}</${tag}>`;
  };
}
const divTag = createTag("div");
console.log(divTag("content"));

// Output: "<div>content</div>"


/**
 * PROBLEM 7: Multiply using closure
 * - Input:  multiplier(3)(5)
 * - Output: 15
*/

function multiplier(factor) {
  return function (num) {
    return num * factor;
  };
}
const triple = multiplier(3);
console.log(triple(5));

// Output: 15


/**
 * PROBLEM 8: Closure returning multiple functions (object)
 * - Input:  counter.inc(), counter.dec(), counter.getCount()
 * - Output: 1, 0, 0
*/

function createCounter8() {
  let count = 0;
  return {
    inc: function () {
      return ++count;
    },
    dec: function () {
      return --count;
    },
    getCount: function () {
      return count;
    },
  };
}
const counter8 = createCounter8();
console.log(counter8.inc());
console.log(counter8.dec());
console.log(counter8.getCount());

// Output: 1, 0, 0


/**
 * PROBLEM 9: Private counter with only increment and getValue
 * - Input:  counter.inc(), counter.inc(), counter.getValue()
 * - Output: 1, 2, 2 (count is private, cannot access directly)
*/

function createPrivateCounter() {
  let count = 0; // Private variable
  return {
    inc: function () {
      count++;
      return count;
    },
    getValue: function () {
      return count;
    },
  };
}
const counter9 = createPrivateCounter();
console.log(counter9.inc());
console.log(counter9.inc());
console.log(counter9.getValue());

// Output: 1, 2, 2


/**
 * PROBLEM 10: Generate power functions using closure
 * - Input:  power(2)(5), power(3)(2)
 * - Output: 25, 8
*/

function power(exponent) {
  return function (base) {
    return Math.pow(base, exponent);
  };
}
const square = power(2);
const cube = power(3);
console.log(square(5));
console.log(cube(2));

// Output: 25, 8


/**
 * PROBLEM 11: Memoization using closure (cache results)
 * - Input:  slowSquare(4) called twice
 * - Output: 16 (computed), 16 (from cache)
*/

function memoizeSquare(fn) {
  const cache = {};
  return function (n) {
    if (n in cache) {
      console.log("From cache");
      return cache[n];
    }
    console.log("Computed");
    cache[n] = fn(n);
    return cache[n];
  };
}
const slowSquare = memoizeSquare(function (n) {
  return n * n;
});
console.log(slowSquare(4)); // Computed
console.log(slowSquare(4)); // From cache

// Output: 16, 16


/**
 * PROBLEM 12: "Once" function — run only once using closure
 * - Input:  runOnce() called twice
 * - Output: "Executed!", "Already executed!"
*/

function once(fn) {
  let hasRun = false;
  let result;
  return function (...args) {
    if (!hasRun) {
      hasRun = true;
      result = fn(...args);
      return result;
    }
    return "Already executed!";
  };
}
const runOnce = once(function () {
  return "Executed!";
});
console.log(runOnce()); // Executed!
console.log(runOnce()); // Already executed!

// Output: "Executed!", "Already executed!"


/**
 * PROBLEM 13: Curry function using closures
 * - Input:  curry(1)(2)(3)
 * - Output: 6
*/

function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn(...args);
    }
    return function (...args2) {
      return curried(...args, ...args2);
    };
  };
}
const sum13 = curry(function (a, b, c) {
  return a + b + c;
});
console.log(sum13(1)(2)(3));

// Output: 6


/**
 * PROBLEM 14: Partial application using closures
 * - Input:  partialAdd(5, 10, 20)
 * - Output: 35
*/

function partial(fn, ...fixedArgs) {
  return function (...remainingArgs) {
    return fn(...fixedArgs, ...remainingArgs);
  };
}
function addFour(a, b, c, d) {
  return a + b + c + d;
}
const addFirstTwo = partial(addFour, 5, 10);
console.log(addFirstTwo(20, 0));

// Output: 35


/**
 * PROBLEM 15: Closure in a loop using var (classic trap)
 * - Input:  Loop with var, setTimeout
 * - Output: 3, 3, 3 (all 3s because var is function-scoped)
*/

for (var i = 0; i < 3; i++) {
  setTimeout(function () {
    console.log(i);
  }, 100);
}

// Output: 3, 3, 3 (classic closure trap)


/**
 * PROBLEM 16: Fix closure in loop using IIFE
 * - Input:  Loop with var + IIFE
 * - Output: 0, 1, 2
*/

for (var i = 0; i < 3; i++) {
  (function (j) {
    setTimeout(function () {
      console.log(j);
    }, 100);
  })(i);
}

// Output: 0, 1, 2


/**
 * PROBLEM 17: Fix closure in loop using let (modern approach)
 * - Input:  Loop with let
 * - Output: 0, 1, 2
*/

for (let i = 0; i < 3; i++) {
  setTimeout(function () {
    console.log(i);
  }, 100);
}

// Output: 0, 1, 2


/**
 * PROBLEM 18: Store a secret using closure
 * - Input:  createSecret("password123").getSecret()
 * - Output: "password123"
*/

function createSecret(secret) {
  return {
    getSecret: function () {
      return secret;
    },
    setSecret: function (newSecret) {
      secret = newSecret;
    },
  };
}
const mySecret = createSecret("password123");
console.log(mySecret.getSecret());

// Output: "password123"


/**
 * PROBLEM 19: Debounce function using closure
 * - Input:  debounce(fn, 100)
 * - Output: Function that only executes after 100ms of no calls
*/

function debounce(fn, delay) {
  let timeoutId;
  return function (...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => {
      fn.apply(this, args);
    }, delay);
  };
}
const debouncedLog = debounce(function (msg) {
  console.log(msg);
}, 100);
debouncedLog("Hello");
debouncedLog("World"); // Only this executes after 100ms

// Output: "World" (after 100ms)


/**
 * PROBLEM 20: Throttle function using closure
 * - Input:  throttle(fn, 100)
 * - Output: Function that executes at most once per 100ms
*/

function throttle(fn, limit) {
  let inThrottle;
  return function (...args) {
    if (!inThrottle) {
      fn.apply(this, args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
    }
  };
}
const throttledLog = throttle(function (msg) {
  console.log(msg);
}, 100);
throttledLog("First");
throttledLog("Second"); // Ignored

// Output: "First"


/**
 * PROBLEM 21: Module pattern using closures
 * - Input:  counterModule.increment(), counterModule.getCount()
 * - Output: 1, 2
*/

const counterModule = (function () {
  let count = 0; // Private
  return {
    increment: function () {
      count++;
      return count;
    },
    decrement: function () {
      count--;
      return count;
    },
    getCount: function () {
      return count;
    },
  };
})();
console.log(counterModule.increment());
console.log(counterModule.getCount());

// Output: 1, 1


/**
 * PROBLEM 22: Singleton pattern using closures
 * - Input:  getInstance() called twice
 * - Output: Same instance reference
*/

const createSingleton = (function () {
  let instance;
  function Singleton() {
    this.value = Math.random();
  }
  return {
    getInstance: function () {
      if (!instance) {
        instance = new Singleton();
      }
      return instance;
    },
  };
})();
const s1 = createSingleton.getInstance();
const s2 = createSingleton.getInstance();
console.log(s1 === s2);

// Output: true


/**
 * PROBLEM 23: Iterator using closure
 * - Input:  createIterator([1, 2, 3]).next()
 * - Output: 1, 2, 3, undefined
*/

function createIterator(arr) {
  let index = 0;
  return {
    next: function () {
      return index < arr.length ? arr[index++] : undefined;
    },
    reset: function () {
      index = 0;
    },
  };
}
const iter23 = createIterator([1, 2, 3]);
console.log(iter23.next());
console.log(iter23.next());
console.log(iter23.next());
console.log(iter23.next());

// Output: 1, 2, 3, undefined


/**
 * PROBLEM 24: Bank account using closure
 * - Input:  account.deposit(100), account.withdraw(50), account.getBalance()
 * - Output: 100, 50, 50
*/

function createBankAccount(initialBalance) {
  let balance = initialBalance;
  return {
    deposit: function (amount) {
      balance += amount;
      return balance;
    },
    withdraw: function (amount) {
      if (amount > balance) return "Insufficient funds";
      balance -= amount;
      return balance;
    },
    getBalance: function () {
      return balance;
    },
  };
}
const account24 = createBankAccount(0);
console.log(account24.deposit(100));
console.log(account24.withdraw(50));
console.log(account24.getBalance());

// Output: 100, 50, 50


/**
 * PROBLEM 25: Compose functions using closures
 * - Input:  compose(fn1, fn2)(5)
 * - Output: Result of fn1(fn2(5))
*/

function compose(...fns) {
  return function (x) {
    return fns.reduceRight((acc, fn) => fn(acc), x);
  };
}
const addOne25 = (x) => x + 1;
const double25 = (x) => x * 2;
const composed25 = compose(addOne25, double25);
console.log(composed25(5)); // addOne(double(5)) = addOne(10) = 11

// Output: 11


/**
 * PROBLEM 26: Pipe functions using closures
 * - Input:  pipe(fn1, fn2)(5)
 * - Output: Result of fn2(fn1(5))
*/

function pipe(...fns) {
  return function (x) {
    return fns.reduce((acc, fn) => fn(acc), x);
  };
}
const addOne26 = (x) => x + 1;
const double26 = (x) => x * 2;
const piped26 = pipe(addOne26, double26);
console.log(piped26(5)); // double(addOne(5)) = double(6) = 12

// Output: 12


/**
 * PROBLEM 27: Rate limiter using closure
 * - Input:  limiter.allow() called 5 times rapidly
 * - Output: true, true, false, false, false (max 2 calls allowed)
*/

function createRateLimiter(maxCalls, timeWindow) {
  let calls = [];
  return {
    allow: function () {
      const now = Date.now();
      calls = calls.filter((time) => now - time < timeWindow);
      if (calls.length < maxCalls) {
        calls.push(now);
        return true;
      }
      return false;
    },
  };
}
const limiter27 = createRateLimiter(2, 1000);
console.log(limiter27.allow());
console.log(limiter27.allow());
console.log(limiter27.allow());

// Output: true, true, false


/**
 * PROBLEM 28: EventEmitter using closure
 * - Input:  emitter.on('test', cb), emitter.emit('test')
 * - Output: "Event triggered!"
*/

function createEventEmitter() {
  const events = {};
  return {
    on: function (event, callback) {
      if (!events[event]) events[event] = [];
      events[event].push(callback);
    },
    emit: function (event, data) {
      if (events[event]) {
        events[event].forEach((cb) => cb(data));
      }
    },
  };
}
const emitter28 = createEventEmitter();
emitter28.on("test", (data) => console.log(data));
emitter28.emit("test", "Event triggered!");

// Output: "Event triggered!"


/**
 * PROBLEM 29: Custom bind function using closure
 * - Input:  customBind(fn, context, arg1)(arg2)
 * - Output: fn called with context and all args
*/

Function.prototype.customBind = function (context, ...boundArgs) {
  const fn = this;
  return function (...args) {
    return fn.apply(context, [...boundArgs, ...args]);
  };
};
function greet29(greeting, punctuation) {
  return `${greeting}, ${this.name}${punctuation}`;
}
const obj29 = { name: "John" };
const bound29 = greet29.customBind(obj29, "Hello");
console.log(bound29("!"));

// Output: "Hello, John!"


/**
 * PROBLEM 30: Memoize any function with multi-arg support using closure
 * - Input:  memoizedAdd(1, 2), memoizedAdd(1, 2), memoizedAdd(2, 3)
 * - Output: 3 (computed), 3 (cached), 5 (computed)
*/

function memoize30(fn) {
  const cache = new Map();
  return function (...args) {
    const key = JSON.stringify(args);
    if (cache.has(key)) {
      console.log("From cache");
      return cache.get(key);
    }
    console.log("Computed");
    const result = fn(...args);
    cache.set(key, result);
    return result;
  };
}
const memoizedAdd = memoize30(function (a, b) {
  return a + b;
});
console.log(memoizedAdd(1, 2)); // Computed
console.log(memoizedAdd(1, 2)); // From cache
console.log(memoizedAdd(2, 3)); // Computed

// Output: 3, 3, 5



/**
 * Currying:
*/

/**
 * PROBLEM 1: Basic curry — convert add(a, b) to add(a)(b)
 * - Input:  add(1)(2)
 * - Output: 3
*/

function add(a) {
  return function (b) {
    return a + b;
  };
}
console.log(add(1)(2));

// Output: 3


/**
 * PROBLEM 2: Curry a 3-argument function manually
 * - Input:  multiply(2)(3)(4)
 * - Output: 24
*/

function multiply(a) {
  return function (b) {
    return function (c) {
      return a * b * c;
    };
  };
}
console.log(multiply(2)(3)(4));

// Output: 24


/**
 * PROBLEM 3: Generic curry wrapper (fixed arity)
 * - Input:  curry(sum)(1)(2)(3)
 * - Output: 6
*/

function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn(...args);
    }
    return function (...args2) {
      return curried(...args, ...args2);
    };
  };
}
const sum3 = curry(function (a, b, c) {
  return a + b + c;
});
console.log(sum3(1)(2)(3));
console.log(sum3(1, 2)(3));
console.log(sum3(1, 2, 3));

// Output: 6, 6, 6


/**
 * PROBLEM 4: Infinite curry — keep accepting args until no args passed
 * - Input:  sum(1)(2)(3)()
 * - Output: 6
*/

function infiniteCurry() {
  let total = 0;
  function curried(num) {
    if (num === undefined) return total;
    total += num;
    return curried;
  }
  return curried;
}
console.log(infiniteCurry()(1)(2)(3)());

// Output: 6


/**
 * PROBLEM 5: Infinite curry using closure accumulator
 * - Input:  add(1)(2)(3)()
 * - Output: 6
*/

function add5(a) {
  return function (b) {
    if (b === undefined) return a;
    return add5(a + b);
  };
}
console.log(add5(1)(2)(3)());

// Output: 6


/**
 * PROBLEM 6: Variadic curry that stops on empty call
 * - Input:  join("-")("a")("b")("c")()
 * - Output: "a-b-c"
*/

function joinCurry(separator) {
  let parts = [];
  return function curried(str) {
    if (str === undefined) return parts.join(separator);
    parts.push(str);
    return curried;
  };
}
console.log(joinCurry("-")("a")("b")("c")());

// Output: "a-b-c"


/**
 * PROBLEM 7: Curry with placeholder support
 * - Input:  curry(fn)(_, 2)(1)
 * - Output: fn(1, 2)
*/

const _ = {};
function curryPlaceholder(fn) {
  return function curried(...args) {
    if (args.length >= fn.length && !args.includes(_)) {
      return fn(...args);
    }
    return function (...args2) {
      const merged = args.map((arg) => (arg === _ ? args2.shift() : arg));
      return curried(...merged, ...args2);
    };
  };
}
const sub = curryPlaceholder(function (a, b) {
  return a - b;
});
console.log(sub(_, 2)(1));

// Output: -1


/**
 * PROBLEM 8: Partial application — fix first argument
 * - Input:  partial(add, 10)(5)
 * - Output: 15
*/

function partial(fn, ...fixedArgs) {
  return function (...remainingArgs) {
    return fn(...fixedArgs, ...remainingArgs);
  };
}
function add8(a, b) {
  return a + b;
}
const addTen = partial(add8, 10);
console.log(addTen(5));

// Output: 15


/**
 * PROBLEM 9: Partial application from the right
 * - Input:  partialRight(sub, 2)(10)
 * - Output: 8 (10 - 2)
*/

function partialRight(fn, ...fixedArgs) {
  return function (...remainingArgs) {
    return fn(...remainingArgs, ...fixedArgs);
  };
}
function sub9(a, b) {
  return a - b;
}
const subTwo = partialRight(sub9, 2);
console.log(subTwo(10));

// Output: 8


/**
 * PROBLEM 10: Curry a function that logs args in sequence
 * - Input:  log("a")("b")("c")
 * - Output: "a, b, c"
*/

function logCurry(a) {
  return function (b) {
    return function (c) {
      return `${a}, ${b}, ${c}`;
    };
  };
}
console.log(logCurry("a")("b")("c"));

// Output: "a, b, c"


/**
 * PROBLEM 11: Curry to create a filter function
 * - Input:  curry(filter)(isEven)([1, 2, 3, 4])
 * - Output: [2, 4]
*/

function curry11(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) return fn(...args);
    return (...args2) => curried(...args, ...args2);
  };
}
const filter = curry11(function (predicate, arr) {
  return arr.filter(predicate);
});
const isEven = (n) => n % 2 === 0;
console.log(filter(isEven)([1, 2, 3, 4]));

// Output: [2, 4]


/**
 * PROBLEM 12: Curry to create a map function
 * - Input:  curry(map)(double)([1, 2, 3])
 * - Output: [2, 4, 6]
*/

const map = curry11(function (transform, arr) {
  return arr.map(transform);
});
const double = (n) => n * 2;
console.log(map(double)([1, 2, 3]));

// Output: [2, 4, 6]


/**
 * PROBLEM 13: Curry to create a reduce function
 * - Input:  curry(reduce)(sum)(0)([1, 2, 3])
 * - Output: 6
*/

// const reduce = curry11(function (reducer, initial, arr) {
//   return arr.reduce(reducer, initial);
// });
// const sum13 = (a, b) => a + b;
// console.log(reduce(sum13)(0)([1, 2, 3]));

// Output: 6


/**
 * PROBLEM 14: Curry a property accessor
 * - Input:  prop("name")(user)
 * - Output: "John"
*/

const prop = curry11(function (key, obj) {
  return obj[key];
});
const user14 = { name: "John", age: 30 };
console.log(prop("name")(user14));

// Output: "John"


/**
 * PROBLEM 15: Curry a comparator for sorting
 * - Input:  curry(sortBy)("age")(users)
 * - Output: Users sorted by age ascending
*/

const sortBy = curry11(function (key, arr) {
  return [...arr].sort((a, b) => a[key] - b[key]);
});
const users15 = [
  { name: "A", age: 30 },
  { name: "B", age: 20 },
  { name: "C", age: 25 },
];
console.log(sortBy("age")(users15));

// Output: [{name: 'B', age: 20}, {name: 'C', age: 25}, {name: 'A', age: 30}]


/**
 * PROBLEM 16: Uncurry — convert curried function back to multi-arg
 * - Input:  uncurry(add)(1, 2)
 * - Output: 3
*/

function uncurry(fn) {
  return function (...args) {
    return args.reduce((acc, arg) => acc(arg), fn);
  };
}
const curriedAdd = (a) => (b) => a + b;
const uncurriedAdd = uncurry(curriedAdd);
console.log(uncurriedAdd(1, 2));

// Output: 3


/**
 * PROBLEM 17: Curry that accepts array of args at once
 * - Input:  curry(fn)([1, 2, 3])
 * - Output: 6
*/

function curryArray(fn) {
  return function (args) {
    return fn(...args);
  };
}
const sum17 = curryArray(function (a, b, c) {
  return a + b + c;
});
console.log(sum17([1, 2, 3]));

// Output: 6


/**
 * PROBLEM 18: Flip arguments using curry
 * - Input:  flip(sub)(2)(10)
 * - Output: 8 (flips to sub(10, 2) = 8)
*/

function flip(fn) {
  return function (a) {
    return function (b) {
      return fn(b, a);
    };
  };
}
const sub18 = (a, b) => a - b;
const flippedSub = flip(sub18);
console.log(flippedSub(2)(10));

// Output: 8


/**
 * PROBLEM 19: Curry with default values
 * - Input:  greet("Hello")("John")
 * - Output: "Hello, John!"
*/

function greetCurry(greeting) {
  return function (name = "Guest") {
    return `${greeting}, ${name}!`;
  };
}
const sayHello = greetCurry("Hello");
console.log(sayHello("John"));
console.log(sayHello());

// Output: "Hello, John!", "Hello, Guest!"


/**
 * PROBLEM 20: Curry a DOM event listener helper
 * - Input:  on("click")(handler)(element)
 * - Output: Adds event listener
*/

const on = curry11(function (event, handler, element) {
  element.addEventListener(event, handler);
  return element;
});
// Mock element for demonstration
const mockEl = {
  listeners: {},
  addEventListener(e, h) {
    this.listeners[e] = h;
  },
};
on("click")(() => console.log("Clicked!"))(mockEl);
mockEl.listeners.click();

// Output: "Clicked!"


/**
 * PROBLEM 21: Curry a fetch URL builder
 * - Input:  buildUrl("https://api.example.com")("/users")("1")
 * - Output: "https://api.example.com/users/1"
*/

function buildUrl(baseUrl) {
  return function (path) {
    return function (id) {
      return `${baseUrl}${path}/${id}`;
    };
  };
}
console.log(buildUrl("https://api.example.com")("/users")("1"));

// Output: "https://api.example.com/users/1"


/**
 * PROBLEM 22: Curry a logger with levels
 * - Input:  log("INFO")("Server started")
 * - Output: "[INFO] Server started"
*/

function logCurry22(level) {
  return function (message) {
    return `[${level}] ${message}`;
  };
}
const infoLog = logCurry22("INFO");
const errorLog = logCurry22("ERROR");
console.log(infoLog("Server started"));
console.log(errorLog("Server crashed"));

// Output: "[INFO] Server started", "[ERROR] Server crashed"


/**
 * PROBLEM 23: Infinite curry with mixed operations
 * - Input:  calc(1)("+")(2)("*")(3)()
 * - Output: 7 (1+2=3, 3*3=9? Wait, left-to-right: 1+2=3, 3*3=9)
*/

function calc(initial) {
  let result = initial;
  function curried(op) {
    return function (num) {
      if (num === undefined) return result;
      switch (op) {
        case "+": result += num; break;
        case "-": result -= num; break;
        case "*": result *= num; break;
        case "/": result /= num; break;
      }
      return curried;
    };
  }
  return curried;
}
console.log(calc(1)("+")(2)("*")(3)());

// Output: 9


/**
 * PROBLEM 24: Curry with this binding
 * - Input:  curry(method)(obj)(arg)
 * - Output: method called with obj as this
*/

function curryThis(fn) {
  return function (context) {
    return function (...args) {
      return fn.apply(context, args);
    };
  };
}
const obj24 = { name: "John" };
const getName = curryThis(function (greeting) {
  return `${greeting}, ${this.name}`;
});
console.log(getName(obj24)("Hello"));

// Output: "Hello, John"


/**
 * PROBLEM 25: Curry a pipe composer
 * - Input:  pipeCurry(fn1, fn2, fn3)(input)
 * - Output: fn3(fn2(fn1(input)))
*/

// function pipeCurry(...fns) {
//   return function (input) {
//     return fns.reduce((acc, fn) => fn(acc), input);
//   };
// }
// const addOne = (x) => x + 1;
// const double25 = (x) => x * 2;
// const minusThree = (x) => x - 3;
// const pipeline = pipeCurry(addOne, double25, minusThree);
// console.log(pipeline(5));

// Output: 9 ((5+1)*2 - 3 = 9)


/**
 * PROBLEM 26: Curry a string formatter
 * - Input:  format("Hello")(name)("!")
 * - Output: "Hello John!"
*/

function format(prefix) {
  return function (value) {
    return function (suffix) {
      return `${prefix} ${value}${suffix}`;
    };
  };
}
const greet26 = format("Hello");
console.log(greet26("John")("!"));

// Output: "Hello John!"


/**
 * PROBLEM 27: Curry a memoized fibonacci
 * - Input:  fib(10)
 * - Output: 55
*/

function memoFib() {
  const cache = {};
  function fib(n) {
    if (n in cache) return cache[n];
    if (n <= 1) return n;
    cache[n] = fib(n - 1) + fib(n - 2);
    return cache[n];
  }
  return fib;
}
const fib = memoFib();
console.log(fib(10));

// Output: 55


/**
 * PROBLEM 28: Curry a regex matcher
 * - Input:  match(/hello/i)("Hello World")
 * - Output: true
*/

const match = curry11(function (regex, str) {
  return regex.test(str);
});
const isHello = match(/hello/i);
console.log(isHello("Hello World"));
console.log(isHello("Goodbye"));

// Output: true, false


/**
 * PROBLEM 29: Curry a deep get (safe property access)
 * - Input:  deepGet("a")("b")("c")({a: {b: {c: 42}}})
 * - Output: 42
*/

function deepGet(firstKey) {
  return function (obj) {
    let current = obj;
    const getMore = (key) => {
      if (key === undefined) return current;
      current = current && current[key];
      return getMore;
    };
    current = current && current[firstKey];
    return getMore;
  };
}
const data29 = { a: { b: { c: 42 } } };
console.log(deepGet("a")(data29)("b")("c")());

// Output: 42


/**
 * PROBLEM 30: Full generic curry that handles any arity, partial calls, and collects all
 * - Input:  curry(fn)(1)(2, 3)
 * - Output: 6
*/

function fullCurry(fn) {
  return function curried(...args) {
    const bound = args.length >= fn.length;
    if (bound) return fn(...args);
    return (...next) => curried(...args, ...next);
  };
}
const sum30 = fullCurry(function (a, b, c, d) {
  return a + b + c + d;
});
console.log(sum30(1)(2)(3)(4));
console.log(sum30(1, 2)(3, 4));
console.log(sum30(1)(2, 3, 4));
console.log(sum30(1, 2, 3, 4));

// Output: 10, 10, 10, 10
