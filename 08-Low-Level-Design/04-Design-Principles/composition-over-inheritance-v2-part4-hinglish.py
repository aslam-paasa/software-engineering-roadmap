# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-4) — Aasan Hinglish
#  Topic: Comparison aur Kab Inheritance use karein
# ============================================================
#
#  Ab dono ko side-by-side compare karte hain.
#
# ============================================================
#
#  1. Inheritance vs Composition (Aasan Table)
#  --------------------------------------------
#  | Cheez       | Inheritance                 | Composition                       |
#  |-------------|-----------------------------|-----------------------------------|
#  | Rishta      | "is-a" (Dog is Animal)      | "has-a" (Car has Engine)          |
#  | Coupling    | Tight (tightly jude)        | Loose (azad)                      |
#  | Flexibility | Compile time pe fix         | Runtime pe change kar sakte ho    |
#  | New Feature | Nayi class banao            | Bas block mix karo                 |
#  | Testing     | Mushkil                     | Easy (mock daal sakte ho)          |
#
#  - Inheritance: Ek baar "Dog is Animal" likha, toh hamesha ke liye
#    fix. Parent change karoge toh child break hoga.
#  - Composition: Blocks ko mix-match karo. Runtime pe bhi block
#    badal sakte ho. Testing easy kyunki nakli (mock) block daal
#    sakte ho.
#
# ============================================================
#
#  2. Kab Inheritance use karna chahiye?
#  ---------------------------------------
#  Principle yeh hai: Composition ko fayda do. Iska matlab yeh nahi
#  ki Inheritance kabhi use mat karo. Inheritance tab sahi hai jab
#  subclass sach mein parent ka ek type ho. (Liskov Substitution
#  Principle: Parent ki jagah child rakh do, sab kaam kare).
#
#  Achhe Examples:
#  - ArrayList is-a List (ArrayList ek List hai).
#  - SavingsAccount is-a BankAccount (Savings account ek bank
#    account hai).
#
#  ------------------------------------------------------------
#  Litmus Test (3 Sawaal)
#  ------------------------------------------------------------
#  Inheritance use karne se pehle 3 sawaal poocho:
#  1. Kya "X ek Y hai" sensical (sense) karta hai?
#     (SavingsAccount is a BankAccount? Haan.)
#  2. Kya main Y ki jagah X daal sakta hoon bina kuch tode?
#     (BankAccount wale function mein SavingsAccount daal sakte ho?
#     Haan.)
#  3. Kya yeh relationship stable hai?
#     (Banking domain change nahi hoga. Haan.)
#
#  Agar teeno ka jawab HAAN hai, tab Inheritance use karo.
#  Agar koi "No" ya "Shak" hai, toh Composition use karo.
#
#  ------------------------------------------------------------
#  Galat Example (Jahan Composition behtar tha)
#  ------------------------------------------------------------
#  Humne Monster banaye: FireDragon, PoisonDragon, WalkingFireMonster.
#  Yahan "Dragon is-a Monster" tha, par behavior share karne ke liye
#  inheritance galat use hui. Isse classes bahut zyada bani.
#  Composition (blocks) use karte toh sirf 6 blocks bana ke 9 monsters
#  bana sakte the.
#
# ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Inheritance: "is-a", tight coupling, compile-time fix, testing
#    mushkil. Nayi class banani padti hai.
#  - Composition: "has-a", loose coupling, runtime changeable, testing
#    easy. Mix and match blocks.
#  - Inheritance tab use karo jab subclass sach mein parent ka ek
#    type ho (SavingsAccount is a BankAccount).
#  - 3 Sawaal: "Ek Y hai?", "Substitute kar sakte ho?", "Stable hai?"
#    Agar teeno haan, toh Inheritance. Agar nahi, toh Composition.
#
#  Ek line mein: "Agar X ek Y hai (SavingsAccount is a BankAccount),
#  toh Inheritance. Agar X ke paas Y hai (Car has an Engine), toh
#  Composition."
#
# ============================================================
