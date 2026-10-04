# ============================================================
#  KISS PRINCIPLE — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Kabhi kisi function ko dekha aur socha: "Yeh itna complicated
#  kyun hai?" Ya bug fix karne gaye, toh 5 layers, ajeeb abstraction
#  aur chalakiyan (clever tricks) mili jo dimag kha jaaye?
#
#  Agar haan, toh tumne KISS principle tod diya. KISS ka matlab hai
#  "Keep It Simple, Stupid" — chalo isko aasan bhasha mein samajhte
#  hain.
#
# ============================================================
#
#  1. KISS Principle kya hai? (Simple mein)
#  -----------------------------------------
#  KISS principle 1960s mein U.S. Navy ne banaya tha. Idea simple
#  tha: zyada tar systems tab best kaam karte hain jab woh simple
#  hote hain. Faltu complexity se failures aate hain, samajhna
#  mushkil hota hai, aur tootne pe theek karna mushkil hota hai.
#
#  Software mein KISS ka matlab hai aisa code likhna jo:
#  - Padhne mein aasaan ho (dusra developer 30 min trace na kare).
#  - Samajhne mein aasaan ho (logic natural flow kare, koi chalaki
#    nahi, koi hidden side effects nahi).
#  - Change karne mein aasaan ho (requirements badlein toh bina
#    kuch tode code modify kar sako).
#
#  Simple rule: Code jitna simple, bugs utne kam. Bugs kam, system
#  utna reliable. System reliable, team utni kam firefighting karegi.
#
#  ------------------------------------------------------------
#  The Complexity Cycle (Complexity kaise aati hai)
#  ------------------------------------------------------------
#  Complexity achanak nahi aati. Thodi-thodi aati hai, aur har faltu
#  complexity agli ko justify karti hai. Ek cycle banti hai:
#  1. Code samajhna thoda mushkil hai.
#  2. Bug aa gaya.
#  3. Bug ko theek karne ke bajaye workaround (jugaad) laga diya.
#  4. Jugaad ne aur complexity badha di.
#  5. Ab code aur samajhna mushkil, naye bugs aur mushkil se milte
#     hain. Cycle chalti rehti hai jab tak koi poora code dobara
#     likhne ka na soch le.
#  KISS is cycle ko shuru hone se hi tod deta hai.
#
# ============================================================
#
#  2. Example — Over-engineered Calculator (KISS Violation)
#  ----------------------------------------------------------
#  Maan lo basic calculator bana rahe ho: +, -, *, /. Bas 4 operations.
#  Ek junior developer ne "future-proof" banane ke chakkar mein
#  inheritance-based framework bana diya. Interface, 4 alag classes,
#  aur calculator jo operation object accept kare.
#
#  from abc import ABC, abstractmethod
#
#  class Operation(ABC):
#      @abstractmethod
#      def calculate(self, a: float, b: float) -> float:
#          pass
#
#  class Addition(Operation):
#      def calculate(self, a, b): return a + b
#
#  class Subtraction(Operation):
#      def calculate(self, a, b): return a - b
#
#  class Calculator:
#      def execute(self, op: Operation, a, b):
#          return op.calculate(a, b)
#
#  calc = Calculator()
#  result = calc.execute(Addition(), 10, 5)
#  print(result)  # 15.0
#
#  Yeh design flexible hai. Par 4-function calculator ke liye bilkul
#  over-engineered hai. Jo kaam simple if-else se ho jaata, woh uske
#  liye interface, 4 classes aur extra layer chahiye. Naya operation
#  (modulo) add karne ke liye nayi class banao, interface implement
#  karo, wire karo. Bahut zyada ceremony, kam fayda. Yeh classic
#  KISS violation hai.
#
# ============================================================
#
#  3. Simple Solution (KISS Applied)
#  ----------------------------------
#  Same calculator ko KISS lagake dekhte hain. Ek class, ek method.
#  Simple if-else.
#
#  class Calculator:
#      def calculate(self, operator, a, b):
#          if operator == "+":
#              return a + b
#          elif operator == "-":
#              return a - b
#          elif operator == "*":
#              return a * b
#          elif operator == "/":
#              if b == 0:
#                  raise ValueError("Division by zero")
#              return a / b
#          else:
#              raise NotImplementedError(f"Unknown operator: {operator}")
#
#  Bas. Simple. Padhne mein aasaan, test karne mein aasaan. Naya
#  operation add karna ho? Ek aur elif case add karo. Itna hi.
#  Agar future mein sach mein pluggable operations chahiye (runtime
#  pe strategies badalni hain), tab hi refactor karo. Abhi ke liye
#  problem jo hai, uske liye simple solution likho. Future ki
#  imagination pe code mat banao.
#
# ============================================================
#
#  4. Complexity kyun khatarnak hai?
#  ---------------------------------
#  Faltu complexity codebase ko 4 tarah nuksan pahunchati hai:
#
#  1. Padhna mushkil: Simple code obvious hota hai. Ek hi nazar mein
#     samajh aata hai. Complex code mein 5 layers dimag mein rakhni
#     padti hain ek operation follow karne ke liye.
#  2. Bugs ke chhupne ki jagah: Har line bug ka ghar ho sakti hai.
#     Extra abstraction aur wrappers bugs ko chhupne ki jagah dete
#     hain. Over-engineered calculator mein 6 classes sahi honi
#     chahiye. Simple mein 1 class. Kam code, kam bugs.
#  3. Onboarding slow: Naye developer ko samajhne mein time lagta
#     hai. Ek hafta calculator samajhne mein lage, toh kuch gadbad
#     hai. Simple code se naye log jaldi contribute karte hain.
#  4. Debugging mushkil: Simple code mein breakpoint lagao, step
#     through karo, bug mil gaya. Complex code mein 5 classes, 2
#     interfaces trace karo. Har debugging session detective
#     investigation ban jaati hai.
#
# ============================================================
#
#  5. Signs You’re Violating KISS (Warning Signs)
#  ----------------------------------------------
#  Complexity code mein ghusti hui kaise pata chale?
#  - Doosri implementation aane se pehle hi interface bana diya.
#  - Jo kaam simple method call se ho raha tha, uske liye reflection
#    use kar liya.
#  - "Just in case" future ke liye extra layer add kar di.
#  - Method mein 5 optional parameters aur deeply nested if-else hain.
#  - Loop simple tha, par tumne recursion use kar liya.
#  - Naya developer tumhari class bina 3 dusri classes padhe samajh
#    nahi pa raha.
#  - Tumhare code mein business logic se zyada boilerplate (faltu
#    ceremony) hai.
#  Agar yeh signs dikhein, toh ruko aur poocho: "Kya iska koi aasan
#  tareeka hai?"
#
# ============================================================
#
#  6. KISS kaise lagayein? (5 Practical Tips)
#  -------------------------------------------
#  Principle jaanna ek baat hai, lagana dusri. 5 tips:
#
#  1. Machines ke liye nahi, Insaano ke liye likho
#     Compiler ko farak nahi padta variable ka naam 'x' hai ya
#     'customerOrderTotal'. Par 6 mahine baad code padhne wale
#     developer ko padega. Naam clear rakho.
#  2. Jaldi Abstraction mat banao
#     Abstraction powerful hai, par jab zaroorat ho ya repetition
#     ho tab banao. Ek implementation ke liye abstract class, interface
#     aur factory banaana engineering nahi, speculation (bhavishyavani)
#     hai.
#  3. Composition ko Inheritance pe fayda do
#     Deep inheritance hierarchies code ko tightly jodte hain aur
#     follow karna mushkil. Method dhoondhne ke liye 3-4 parent
#     classes upar jaana padta hai. Flat, composed structure simple
#     aur flexible hota hai.
#  4. Functions chhote rakho
#     Ek function ek kaam acche se kare. Agar function validation,
#     transformation, persistence, notification sab kar raha hai, toh
#     woh bahut zyada kar raha hai. Rule: agar function ka kaam ek
#     line mein bina "and" use kiye describe nahi ho sakta, toh usko
#     split (tod) do.
#  5. Familiar constructs use karo
#     Apni language ke known patterns aur data structures use karo.
#     Simple List, Map, for loop se kaam ho raha hai, toh pahiya
#     (wheel) dubara mat invent karo.
#
# ============================================================
#
#  7. Kab Simple Nahi Karna Chahiye?
#  ---------------------------------
#  KISS powerful hai, par andha dhundh lagana backfire kar sakta hai.
#  Kuch cases mein complexity zaroori hoti hai:
#
#  1. Critical Systems ko oversimplify mat karo
#     Payment system mein validation, logging, error handling zaroori
#     hai. Simple bolke corners cut mat karo. Warna data corruption,
#     security vulnerability, ya financial loss ho sakta hai.
#     Sawaal yeh nahi ki "Kya yeh simple hai?", sawaal yeh hai ki
#     "Kya yeh saari requirements (safety, reliability) meet karte
#     hue jitna simple ho sakta hai?"
#
#  2. Logic duplicate mat karo "Simple" rakhne ke chakkar mein
#     Kabhi developer shared utility nahi banate kyunki lagta hai
#     "abstraction badh raha hai". Par same logic 5 jagah hai, toh
#     rule change hua 5 jagah update karna padega. Ek chhota sa
#     helper function 5 copies se zyada simple hai.
#     KISS aur DRY saath kaam karte hain. Simplest solution jo
#     unnecessary repeat na ho.
#
#  3. Audience pe depend karta hai
#     Kabhi design pattern custom approach se zyada samajhne mein
#     aasaan hota hai. Agar tumhara team Spring Boot use karta hai
#     aur sabko @Autowired aata hai, toh woh manually dependencies
#     wire karne se zyada simple hai. Simplicity reader pe depend
#     karti hai. Experienced developer ke liye simple, junior ke liye
#     confusing ho sakta hai.
#
#  Goal sabse simple code likhna nahi hai. Goal "simplest sufficient"
#  code likhna hai — jo zaroorat poora kare aur utna hi complex ho.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - KISS = "Keep It Simple, Stupid". Systems simple rakhne se best
#    kaam karte hain. Faltu complexity se bugs aate hain.
#  - Code padhne, samajhne, aur change karne mein aasaan hona chahiye.
#  - Complexity achanak nahi aati, cycle banti hai: hard to understand
#    -> bug -> workaround -> aur complexity. Is cycle ko break karo.
#  - Over-engineering (jaise 4-function calculator ke liye 6 classes)
#    avoid karo. Simple if-else se kaam ho raha hai toh wahi karo.
#  - Faltu complexity se: Padhna mushkil, bugs chhupne ki jagah,
#    onboarding slow, debugging detective investigation.
#  - Tips: Insaano ke liye likho, jaldi abstraction mat banao,
#    composition over inheritance, functions chhote rakho, familiar
#    constructs use karo.
#  - Kab simple nahi karna: Critical systems (payment), logic duplicate
#    na karo (DRY), audience pe depend karta hai.
#
#  Ek line mein: KISS = "Code ko faltu complicated mat banao. Jo
#  problem hai, uska sabse simple aur direct solution likho."
#
# ============================================================
