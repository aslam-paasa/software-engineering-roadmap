/*
===================================================================
FUNCTION KE ANDAR FUNCTION + (...args) - Absolute Beginner Guide
===================================================================

Bhai, confusion isliye hota hai kyunki hum ek function ke andar 
dusra function banate hain. Aur usme `...args` bhi hota hai.

Isko samajhne ke liye bas 2 baatein yaad rakho:
1. BAHAR wala function = "Rule Set Karna" 
   (Jaise: "Bhaiya, mujhe aisi machine chahiye jo double kare")
2. ANDAR wala function = "Machine ko chalana" 
   (Jaise: "Machine bana di, ab isme 5 daal ke dekho")

 aur `...args` kya hai?
- "..." ka matlab hai "JITNE BHI CHEEZEN DO, MAIN SAB EK DIBBE (Array) MEIN RAKH LUNGA".
- Agar user 1 number de toh `...args` ban jayega `[1]`.
- Agar user 5 number de toh `...args` ban jayega `[1, 2, 3, 4, 5]`.
- Iska fayda? Tumhe pata nahi hota ki user kitne cheezein dega, 
  isliye `...args` likh dete ho ki "jo bhi dega, main accept karunga".

Chalo bilkul ghar ki real-life examples se samajhte hain.
===================================================================
*/


/**
 * PROBLEM 1: Coffee Machine (Basic Rule & Run)
 * - Real Life: Pehle machine ko bolo "2 chammach cheeni daalna", phir coffee bana ke do.
 * - Input:  coffeeMachine(2)("Cappuccino")
 * - Output: "Cappuccino with 2 spoons of sugar"
*/

function coffeeMachine1(sugarSpoons) {
  // Rule set: sugarSpoons = 2
  return function (coffeeName) {
    // Run: coffeeName = "Cappuccino"
    return `${coffeeName} with ${sugarSpoons} spoons of sugar`;
  };
}

// Machine banai jo 2 cheeni daalti hai
const myCoffee1 = coffeeMachine1(2);
console.log(myCoffee1("Cappuccino"));

// Output: "Cappuccino with 2 spoons of sugar"


/**
 * PROBLEM 2: Shopping Bag (Why use ...args?)
 * - Real Life: Pehle bag ka color decide karo, phir usme jitne marzi saman daalo.
 * - Input:  redBag("Apple", "Banana", "Milk")
 * - Output: "Red bag has: Apple, Banana, Milk"
*/

function getBag2(bagColor) {
  // Rule: Bag ka color fix kar diya
  return function (...items) {
    // Run: ...items matlab jitne bhi saman doge, ek array ban jayega
    // items = ["Apple", "Banana", "Milk"]
    return `${bagColor} bag has: ${items.join(", ")}`;
  };
}

const redBag2 = getBag2("Red");
console.log(redBag2("Apple", "Banana", "Milk"));

// Output: "Red bag has: Apple, Banana, Milk"


/**
 * PROBLEM 3: SMS Sender
 * - Real Life: Pehle sender ka naam set karo, phir jitne chahe numbers pe message bhejo.
 * - Input:  sendSMS("Amazon")(9876543210, 9123456789)
 * - Output: "Amazon sent message to 2 numbers"
*/

function smsSender3(senderName) {
  return function (...phoneNumbers) {
    // phoneNumbers = [9876543210, 9123456789]
    return `${senderName} sent message to ${phoneNumbers.length} numbers`;
  };
}

const amazonSMS3 = smsSender3("Amazon");
console.log(amazonSMS3(9876543210, 9123456789));

// Output: "Amazon sent message to 2 numbers"


/**
 * PROBLEM 4: Discount Machine
 * - Real Life: Pehle discount % set karo (10%), phir jitne marzi bills do.
 * - Input:  diwaliSale(100, 200, 500)
 * - Output: [90, 180, 450]
*/

function discountMachine4(percent) {
  return function (...bills) {
    // bills = [100, 200, 500]
    // Har bill se 10% minus karo
    return bills.map(bill => bill - (bill * percent) / 100);
  };
}

const diwaliSale4 = discountMachine4(10);
console.log(diwaliSale4(100, 200, 500));

// Output: [90, 180, 450]


/**
 * PROBLEM 5: The "Pipe" Assembly Line (Left to Right)
 * - Real Life: Factory line. Pehle bolo kaunse machines lagane hain, phir material do.
 * - Input:  factoryLine(cutter, packer)("Wood")
 * - Output: "Packed cut Wood"
*/

function factoryLine5(...machines) {
  // machines = [cutter, packer]
  // Hume nahi pata kitne machines hain, isliye ...machines
  return function (...materials) {
    // materials = ["Wood"]
    let currentMaterial = materials[0];
    
    // Machine 1 (cutter) chalega, phir Machine 2 (packer)
    for (let machine of machines) {
      currentMaterial = machine(currentMaterial);
    }
    return currentMaterial;
  };
}

const cutter5 = (item) => `cut ${item}`;
const packer5 = (item) => `Packed ${item}`;

// Pehle config: cutter aur packer lagana hai
// Phir run: material "Wood" do
const myLine5 = factoryLine5(cutter5, packer5);
console.log(myLine5("Wood"));

// Output: "Packed cut Wood"


/**
 * PROBLEM 6: The "Compose" Assembly Line (Right to Left)
 * - Real Life: Same factory line, par machine right se left chalti hai (Math rule).
 * - Input:  reverseFactory(packer, cutter)("Wood")
 * - Output: "Packed cut Wood"
*/

function reverseFactory6(...machines) {
  // machines = [packer, cutter]
  return function (...materials) {
    let currentMaterial = materials[0];
    
    // Pehle machine 2 (cutter) chalega, phir machine 1 (packer)
    for (let i = machines.length - 1; i >= 0; i--) {
      currentMaterial = machines[i](currentMaterial);
    }
    return currentMaterial;
  };
}

const cutter6 = (item) => `cut ${item}`;
const packer6 = (item) => `Packed ${item}`;

const myReverseLine6 = reverseFactory6(packer6, cutter6);
console.log(myReverseLine6("Wood"));

// Output: "Packed cut Wood"


/**
 * PROBLEM 7: GST Calculator for Cart
 * - Real Life: Pehle GST % set karo (18%), phir jitne marzi items ke price do.
 * - Input:  gst18(50, 100, 200)
 * - Output: [59, 118, 236]
*/

function gstMachine7(percent) {
  return function (...prices) {
    // prices = [50, 100, 200]
    return prices.map(price => price + (price * percent) / 100);
  };
}

const gst18 = gstMachine7(18);
console.log(gst18(50, 100, 200));

// Output: [59, 118, 236]


/**
 * PROBLEM 8: VIP Entry Checker
 * - Real Life: Pehle VIP ki age limit set karo (21+), phir jitne marzi log check karo.
 * - Input:  clubEntry(21)(25, 19, 30)
 * - Output: [true, false, true]
*/

function ageChecker8(minAge) {
  return function (...ages) {
    // ages = [25, 19, 30]
    return ages.map(age => age >= minAge);
  };
}

const nightClub8 = ageChecker8(21);
console.log(nightClub8(25, 19, 30));

// Output: [true, false, true]


/**
 * PROBLEM 9: Simple Adder Machine
 * - Real Life: Machine bolo pehle 100 add karo, phir jitne marzi number do.
 * - Input:  addHundred(10, 20, 30)
 * - Output: 160
*/

function adderMachine9(baseNumber) {
  return function (...numsToAdd) {
    // numsToAdd = [10, 20, 30]
    // Sabko add karo
    const sum = numsToAdd.reduce((acc, curr) => acc + curr, 0);
    return baseNumber + sum;
  };
}

const addHundred9 = adderMachine9(100);
console.log(addHundred9(10, 20, 30));

// Output: 160


/**
 * PROBLEM 10: Pizza Topping Applier
 * - Real Life: Pehle base pizza set karo ("Large"), phir jitne marzi toppings lagao.
 * - Input:  largePizza("Cheese", "Olives", "Panner")
 * - Output: "Large Pizza with Cheese, Olives, Panner"
*/

function pizzaBase10(size) {
  return function (...toppings) {
    // toppings = ["Cheese", "Olives", "Panner"]
    return `${size} Pizza with ${toppings.join(", ")}`;
  };
}

const largePizza10 = pizzaBase10("Large");
console.log(largePizza10("Cheese", "Olives", "Panner"));

// Output: "Large Pizza with Cheese, Olives, Panner"


/**
 * PROBLEM 11: Tag Generator (HTML/CSS)
 * - Real Life: Pehle tag ka naam do ("div"), phir usme jitne marzi classes daalo.
 * - Input:  makeTag("div")("container", "flex", "dark")
 * - Output: "div container flex dark"
*/

function htmlTag11(tagName) {
  return function (...classes) {
    // classes = ["container", "flex", "dark"]
    return `${tagName} ${classes.join(" ")}`;
  };
}

const divTag11 = htmlTag11("div");
console.log(divTag11("container", "flex", "dark"));

// Output: "div container flex dark"


/**
 * PROBLEM 12: Multi-Argument First Function
 * - Real Life: Assembly line jisme pehli machine 2 cheezein maange, baaki sirf 1.
 * - Input:  factory(sumAndSquare)(10, 20)
 * - Output: 900 (10+20=30, 30*30=900)
*/

function factory12(...machines) {
  // machines = [sumAndSquare]
  return function (...args) {
    // args = [10, 20]
    let currentResult = args; // Start with [10, 20]
    
    for (let i = 0; i < machines.length; i++) {
      // Agar pehli machine hai, toh saare args do
      if (i === 0) {
        currentResult = machines[i](...currentResult);
      } else {
        currentResult = machines[i](currentResult);
      }
    }
    return currentResult;
  };
}

const sum12 = (a, b) => a + b;  // Takes 2 args
const square12 = (x) => x * x;  // Takes 1 arg

const myMachine12 = factory12(sum12, square12);
console.log(myMachine12(10, 20));

// Output: 900


/**
 * PROBLEM 13: Database Query Builder
 * - Real Life: Pehle table naam do ("users"), phir jitne marzi IDs do fetch karne ke liye.
 * - Input:  getUsers(1, 5, 10)
 * - Output: "Fetching users: 1, 5, 10"
*/

function dbTable13(tableName) {
  return function (...ids) {
    // ids = [1, 5, 10]
    return `Fetching ${tableName}: ${ids.join(", ")}`;
  };
}

const getUsers13 = dbTable13("users");
console.log(getUsers13(1, 5, 10));

// Output: "Fetching users: 1, 5, 10"


/**
 * PROBLEM 14: Message Logger with Tags
 * - Real Life: Pehle tag fix karo ("ERROR"), phir jitne marzi errors print karo.
 * - Input:  errorLog("Disk Full", "CPU 100%")
 * - Output: ["[ERROR] Disk Full", "[ERROR] CPU 100%"]
*/

function logger14(tag) {
  return function (...messages) {
    // messages = ["Disk Full", "CPU 100%"]
    return messages.map(msg => `[${tag}] ${msg}`);
  };
}

const errorLog14 = logger14("ERROR");
console.log(errorLog14("Disk Full", "CPU 100%"));

// Output: ["[ERROR] Disk Full", "[ERROR] CPU 100%"]


/**
 * PROBLEM 15: Curry (Collect Until Enough)
 * - Real Life: Machine tab tak inputs collect karti rehti hai jab tak requirement pura na ho jaye.
 * - Input:  smartAdder(1)(2)(3)
 * - Output: 6
*/

function smartAdder15(totalExpectedArgs) {
  let collectedArgs = [];
  
  return function curried(...newArgs) {
    // Naye args ko purane args mein add karo
    collectedArgs = [...collectedArgs, ...newArgs];
    
    // Check karo: kya saare args aa gaye?
    if (collectedArgs.length >= totalExpectedArgs) {
      // Ab data process karo
      return collectedArgs.reduce((acc, curr) => acc + curr, 0);
    }
    
    // Agar abhi kam hain, toh aur inputs mangne ke liye function return karo
    return curried;
  };
}

// Machine ko bolo "Mujhe 3 numbers chahiye"
const adder15 = smartAdder15(3);
console.log(adder15(1)(2)(3));

// Output: 6


/*
===================================================================
FINAL SUMMARY FOR BEGINNERS:
===================================================================
1. Jab bhi dekho: function ke andar function return ho raha hai,
   samajh jao: BAHAR wala "Rule/Config" set kar raha hai, aur 
   ANDAR wala "Asal Kaam" kar raha hai.

2. `...args` ka use tab karo jab tumhe nahi pata ki user kitne 
   arguments dega. "..." lagane se sab ek Array ban jata hai, 
   jise hum aaram se .map, .reduce ya loop se handle kar sakte hain.

3. `(...fns) => (...args) => ...` pattern:
   - Pehle hum functions (machines) ka list dete hain.
   - Phir hum data dete hain.
   - Data ek-ek machine se guzarta hai.
===================================================================
*/
