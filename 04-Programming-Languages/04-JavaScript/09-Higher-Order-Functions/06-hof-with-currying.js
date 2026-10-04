/*
===================================================================
FUNCTION RETURNING FUNCTION (HOF & Currying) - 30 Real-Life Problems
===================================================================

Is pattern mein ek function dusra function return karta hai.
Jaise aap ek machine (outer function) ko chalate hain, aur wo 
machine aapko ek button (inner function) deti hai. Jab aap us 
button ko dabate hain, tab asal kaam hota hai.

Example:
  function outer() {
    return function inner() {
      console.log("Kaam ho gaya!");
    }
  }
  const myButton = outer();
  myButton(); // "Kaam ho gaya!"

Let's start from absolute basics with real-life examples.
===================================================================
*/


/**
 * PROBLEM 1: Basic Greeting Machine
 * - Real Life: Ek machine jo aapse naam poochti hai, phir hello bolti hai.
 * - Input:  greet()("John")
 * - Output: "Hello, John!"
*/

function greet1() {
  return function (name) {
    return `Hello, ${name}!`;
  };
}

const sayHello1 = greet1(); // sayHello1 ab ek function hai
console.log(sayHello1("John"));

// Output: "Hello, John!"


/**
 * PROBLEM 2: Tea Maker (Sugar Fix)
 * - Real Life: Pehle decide karo kitni chini chahiye, phir tea banao.
 * - Input:  makeTea(2)("Ginger Tea")
 * - Output: "Ginger Tea with 2 spoons of sugar"
*/

function makeTea2(sugarSpoons) {
  return function (teaType) {
    return `${teaType} with ${sugarSpoons} spoons of sugar`;
  };
}

const lessSugarTea = makeTea2(1); // 1 chini fix
console.log(lessSugarTea("Green Tea"));

// Output: "Green Tea with 1 spoons of sugar"


/**
 * PROBLEM 3: Multiplier Machine
 * - Real Life: Ek calculator jisme factor set karo, phir number daalo.
 * - Input:  multiplier(3)(5)
 * - Output: 15
*/

function multiplier3(factor) {
  return function (num) {
    return num * factor;
  };
}

const tripleIt = multiplier3(3); // Factor 3 set ho gaya
console.log(tripleIt(5));

// Output: 15


/**
 * PROBLEM 4: Discount Calculator
 * - Real Life: Pehle discount % set karo, phir bill aane par calculate karo.
 * - Input:  discountCalculator(10)(500)
 * - Output: 50 (10% of 500)
*/

function discountCalculator4(percent) {
  return function (billAmount) {
    return (billAmount * percent) / 100;
  };
}

const festivalDiscount = discountCalculator4(10); // 10% fix
console.log(festivalDiscount(500));

// Output: 50


/**
 * PROBLEM 5: Pizza Size Selector
 * - Real Life: Pehle size decide karo, phir topping.
 * - Input:  orderPizza("Large")("Cheese Burst")
 * - Output: "Large Pizza with Cheese Burst"
*/

function orderPizza5(size) {
  return function (topping) {
    return `${size} Pizza with ${topping}`;
  };
}

const largePizza = orderPizza5("Large");
console.log(largePizza("Cheese Burst"));

// Output: "Large Pizza with Cheese Burst"


/**
 * PROBLEM 6: Simple Adder
 * - Real Life: Pehle ek number rakho, phir doosra number add karo.
 * - Input:  adder(10)(5)
 * - Output: 15
*/

function adder6(num1) {
  return function (num2) {
    return num1 + num2;
  };
}

const addTen6 = adder6(10);
console.log(addTen6(5));

// Output: 15


/**
 * PROBLEM 7: Temperature Converter
 * - Real Life: Pehle scale decide karo (C to F), phir temperature do.
 * - Input:  convertTemp("CtoF")(25)
 * - Output: 77 (25 * 9/5 + 32)
*/

function convertTemp7(scale) {
  return function (temp) {
    if (scale === "CtoF") return (temp * 9) / 5 + 32;
    if (scale === "FtoC") return ((temp - 32) * 5) / 9;
  };
}

const celsiusToFahrenheit = convertTemp7("CtoF");
console.log(celsiusToFahrenheit(25));

// Output: 77


/**
 * PROBLEM 8: Password Generator
 * - Real Life: Pehle length decide karo, phir word do.
 * - Input:  padString("*")(5)("abc")
 * - Output: "abc**" (pad at end)
*/

function padString8(char) {
  return function (length) {
    return function (text) {
      return text + char.repeat(length);
    };
  };
}

const starPad = padString8("*")(5);
console.log(starPad("abc"));

// Output: "abc*****"


/**
 * PROBLEM 9: Timer Alarm
 * - Real Life: Pehle minutes set karo, phir message do.
 * - Input:  setAlarm(5)("Wake up!")
 * - Output: "Alarm set for 5 mins: Wake up!"
*/

function setAlarm9(minutes) {
  return function (message) {
    return `Alarm set for ${minutes} mins: ${message}`;
  };
}

const fiveMinAlarm = setAlarm9(5);
console.log(fiveMinAlarm("Wake up!"));

// Output: "Alarm set for 5 mins: Wake up!"


/**
 * PROBLEM 10: Car Speed Limiter
 * - Real Life: Pehle max speed set karo, phir current speed check karo.
 * - Input:  speedLimiter(80)(100)
 * - Output: "Over speed! Limit is 80"
*/

function speedLimiter10(maxSpeed) {
  return function (currentSpeed) {
    if (currentSpeed > maxSpeed) return `Over speed! Limit is ${maxSpeed}`;
    return "Safe driving";
  };
}

const highwayLimit = speedLimiter10(80);
console.log(highwayLimit(100));

// Output: "Over speed! Limit is 80"


/**
 * PROBLEM 11: Tax Calculator
 * - Real Life: Pehle tax % fix karo, phir amount do.
 * - Input:  taxCalculator(18)(1000)
 * - Output: 180
*/

function taxCalculator11(taxPercent) {
  return function (amount) {
    return (amount * taxPercent) / 100;
  };
}

const gst = taxCalculator11(18);
console.log(gst(1000));

// Output: 180


/**
 * PROBLEM 12: Volume of a Box
 * - Real Life: Pehle length, phir width, phir height.
 * - Input:  boxVolume(2)(3)(4)
 * - Output: 24
*/

function boxVolume12(length) {
  return function (width) {
    return function (height) {
      return length * width * height;
    };
  };
}

console.log(boxVolume12(2)(3)(4));

// Output: 24


/**
 * PROBLEM 13: Interest Calculator
 * - Real Life: Pehle rate, phir time, phir principal.
 * - Input:  simpleInterest(5)(2)(1000)
 * - Output: 100 (PTR/100 = 1000*5*2/100)
*/

function simpleInterest13(rate) {
  return function (time) {
    return function (principal) {
      return (principal * rate * time) / 100;
    };
  };
}

const rdInterest = simpleInterest13(5)(2); // Rate 5%, Time 2 years
console.log(rdInterest(1000));

// Output: 100


/**
 * PROBLEM 14: User Role Checker
 * - Real Life: Pehle role fix karo, phir check karo user wahi toh hai.
 * - Input:  checkRole("admin")({ name: "John", role: "admin" })
 * - Output: true
*/

function checkRole14(role) {
  return function (user) {
    return user.role === role;
  };
}

const isAdmin = checkRole14("admin");
console.log(isAdmin({ name: "John", role: "admin" }));

// Output: true


/**
 * PROBLEM 15: Database Table Selector
 * - Real Life: Pehle table naam do, phir id do.
 * - Input:  getFromTable("users")(5)
 * - Output: "Fetching user with ID 5 from users table"
*/

function getFromTable15(tableName) {
  return function (id) {
    return `Fetching user with ID ${id} from ${tableName} table`;
  };
}

const getUser = getFromTable15("users");
console.log(getUser(5));

// Output: "Fetching user with ID 5 from users table"


/**
 * PROBLEM 16: Logging with Levels
 * - Real Life: Pehle level (INFO/WARN) fix karo, phir message do.
 * - Input:  log("ERROR")("Disk Full")
 * - Output: "[ERROR] Disk Full"
*/

function log16(level) {
  return function (message) {
    return `[${level}] ${message}`;
  };
}

const errorLog = log16("ERROR");
console.log(errorLog("Disk Full"));

// Output: "[ERROR] Disk Full"


/**
 * PROBLEM 17: String Prefixer
 * - Real Life: Pehle prefix fix karo, phir text do.
 * - Input:  prefixer("Mr.")("John")
 * - Output: "Mr. John"
*/

function prefixer17(prefix) {
  return function (text) {
    return `${prefix} ${text}`;
  };
}

const addMr = prefixer17("Mr.");
console.log(addMr("John"));

// Output: "Mr. John"


/**
 * PROBLEM 18: Area of Circle
 * - Real Life: Pehle Pi fix karo, phir radius do.
 * - Input:  circleArea(3.14)(5)
 * - Output: 78.5
*/

function circleArea18(pi) {
  return function (radius) {
    return pi * radius * radius;
  };
}

const exactArea = circleArea18(3.14);
console.log(exactArea(5));

// Output: 78.5


/**
 * PROBLEM 19: Shop Filter
 * - Real Life: Pehle category fix karo, phir price filter lagao.
 * - Input:  filterProducts("Electronics")(5000)
 * - Output: "Showing Electronics below 5000"
*/

function filterProducts19(category) {
  return function (maxPrice) {
    return `Showing ${category} below ${maxPrice}`;
  };
}

const electronics = filterProducts19("Electronics");
console.log(electronics(5000));

// Output: "Showing Electronics below 5000"


/**
 * PROBLEM 20: OTP Generator Base
 * - Real Life: Pehle length fix karo, phir random number generate karo.
 * - Input:  generateOTP(4)()
 * - Output: "1234" (random)
*/

function generateOTP20(length) {
  return function () {
    let otp = "";
    for (let i = 0; i < length; i++) {
      otp += Math.floor(Math.random() * 10);
    }
    return otp;
  };
}

const fourDigitOTP = generateOTP20(4);
console.log(fourDigitOTP());

// Output: "8472" (random)


/**
 * PROBLEM 21: Event Listener
 * - Real Life: Pehle event type fix karo, phir element do.
 * - Input:  onEvent("click")("Button1")
 * - Output: "Click listener added to Button1"
*/

function onEvent21(event) {
  return function (element) {
    return `${event} listener added to ${element}`;
  };
}

const onClick = onEvent21("click");
console.log(onClick("Button1"));

// Output: "Click listener added to Button1"


/**
 * PROBLEM 22: Partial Application (Fix 2 args)
 * - Real Life: Pehle 2 number fix karo, 3rd baad mein do.
 * - Input:  partialAdd(1, 2)(3)
 * - Output: 6
*/

function partialAdd22(a, b) {
  return function (c) {
    return a + b + c;
  };
}

const addFirstTwo = partialAdd22(1, 2);
console.log(addFirstTwo(3));

// Output: 6


/**
 * PROBLEM 23: Salary Calculator
 * - Real Life: Base salary fix karo, phir bonus do.
 * - Input:  calculateSalary(50000)(10000)
 * - Output: 60000
*/

function calculateSalary23(base) {
  return function (bonus) {
    return base + bonus;
  };
}

const devSalary = calculateSalary23(50000);
console.log(devSalary(10000));

// Output: 60000


/**
 * PROBLEM 24: Power Function (Exponent fix)
 * - Real Life: Pehle power fix karo (square/cube), phir base do.
 * - Input:  power(3)(2)
 * - Output: 8 (2^3)
*/

function power24(exponent) {
  return function (base) {
    return Math.pow(base, exponent);
  };
}

const cube = power24(3);
console.log(cube(2));

// Output: 8


/**
 * PROBLEM 25: Discount with Code
 * - Real Life: Pehle promo code fix karo, phir amount do.
 * - Input:  applyPromo("DIWALI")(1000)
 * - Output: 900 (10% off)
*/

function applyPromo25(code) {
  return function (amount) {
    if (code === "DIWALI") return amount * 0.9; // 10% off
    return amount;
  };
}

const diwaliOffer = applyPromo25("DIWALI");
console.log(diwaliOffer(1000));

// Output: 900


/**
 * PROBLEM 26: Message Formatter
 * - Real Life: Pehle template do, phir actual value do.
 * - Input:  formatter("Hello {0}")("World")
 * - Output: "Hello World"
*/

function formatter26(template) {
  return function (value) {
    return template.replace("{0}", value);
  };
}

const welcomeMsg = formatter26("Hello {0}");
console.log(welcomeMsg("World"));

// Output: "Hello World"


/**
 * PROBLEM 27: Chain Multiple Operations (Pipe)
 * - Real Life: Pehle 10 add karo, phir 2 se multiply karo.
 * - Input:  pipe(add10, multiply2)(5)
 * - Output: 30 ((5+10)*2)
*/

function pipe27(...fns) {
  return function (x) {
    return fns.reduce((acc, fn) => fn(acc), x);
  };
}

const add10 = (x) => x + 10;
const multiply2 = (x) => x * 2;

const mathPipe = pipe27(add10, multiply2);
console.log(mathPipe(5));

// Output: 30


/**
 * PROBLEM 28: API Fetch Wrapper
 * - Real Life: Pehle URL fix karo, phir endpoint do.
 * - Input:  api("https://api.example.com")("/users")
 * - Output: "Fetching https://api.example.com/users"
*/

function api28(baseUrl) {
  return function (endpoint) {
    return `Fetching ${baseUrl}${endpoint}`;
  };
}

const myApi = api28("https://api.example.com");
console.log(myApi("/users"));

// Output: "Fetching https://api.example.com/users"


/**
 * PROBLEM 29: Validation Checker
 * - Real Life: Pehle minimum length fix karo, phir password check karo.
 * - Input:  minLength(8)("password123")
 * - Output: true
*/

function minLength29(min) {
  return function (str) {
    return str.length >= min;
  };
}

const isPasswordValid = minLength29(8);
console.log(isPasswordValid("password123"));

// Output: true


/**
 * PROBLEM 30: Custom Greeting with Time
 * - Real Life: Pehle time fix karo, phir naam do.
 * - Input:  greetByTime("Morning")("John")
 * - Output: "Good Morning, John!"
*/

function greetByTime30(time) {
  return function (name) {
    return `Good ${time}, ${name}!`;
  };
}

const morningGreet = greetByTime30("Morning");
console.log(morningGreet("John"));

// Output: "Good Morning, John!"

/*
===================================================================
SUMMARY FOR BEGINNERS:
===================================================================
1. Jab bhi aap dekho ki ek function dusra function return kar raha 
   hai, samajh jao ki ye HOF (Higher-Order Function) hai.
2. Iska fayda kya hai? Hum configuration aur execution ko alag kar 
   sakte hain. Jaise Problem 4 mein discount % pehle set kiya, 
   phir baad mein bill aane par calculate kiya.
3. Ye pattern Currying aur Partial Application ka foundation hai.
4. Real life mein: React ke HOCs, Express.js middleware, Redux 
   connect() function - sabhi isi pattern par based hain.
===================================================================
*/
