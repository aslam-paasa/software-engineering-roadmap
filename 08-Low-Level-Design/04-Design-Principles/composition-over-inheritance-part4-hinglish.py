# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-4) — Aasan Hinglish Guide
#  Topic: Head-to-Head Comparison & When to Use Inheritance
# ============================================================
#
#  Ab tak humne dono approaches dekhe. Ab Inheritance aur
#  Composition ko head-to-head compare karte hain, aur dekhte hain
#  kab Inheritance use karna sahi hai.
#
# ============================================================
#
#  1. Head-to-Head: Inheritance vs Composition
#  --------------------------------------------
#  | Feature        | Inheritance                    | Composition                               |
#  |----------------|--------------------------------|-------------------------------------------|
#  | Relationship   | "is-a" (Car is a Vehicle)      | "has-a" (Car has an Engine)               |
#  | Coupling       | Tight (parent ke impl pe tied) | Loose (interface pe depend karta hai)     |
#  | Flexibility    | Compile time pe fix            | Runtime pe changeable                     |
#  | Code Reuse     | Class hierarchy se             | Object delegation se                       |
#  | Adding Behavior| Naya subclass banao            | Mix and match existing components          |
#  | Testing        | Isolation mein mushkil          | Mock karna easy                            |
#  | Hierarchy      | Deep aur fragile ho sakta hai  | Flat aur stable rehta hai                 |
#
#  Chalo isko simple words mein samjhte hain:
#
#  - Relationship: Inheritance pehchan (identity) model karta hai
#    ("Dog IS an Animal"). Composition capability model karta hai
#    ("Car HAS an Engine"). Sawaal yeh hai ki rishta sach mein
#    "kya hai" ka hai ya bas "kya kar sakta hai" ka.
#  - Coupling: Inheritance mein subclass parent ke protected fields,
#    constructor behavior, method signatures sab jaanta hai. Change
#    karo toh break hoga. Composition mein main object sirf interface
#    jaanta hai. Piche kya concrete class hai, use farak nahi padta.
#  - Flexibility: Inheritance compile time pe baked hota hai. Ek baar
#    Dragon extends Monster likha, toh hamesha ke liye. Composition
#    mein runtime pe setMoveBehavior() call karke behavior change
#    kar sakte ho.
#  - Testing: Inheritance mein parent ko specific state mein rakhna
#    padta hai test ke liye. Composition mein har behavior ko akele
#    mock kar sakte ho.
#
# ============================================================
#
#  2. Kab Inheritance use karna sahi hai?
#  ---------------------------------------
#  Principle yeh hai: "Favor Composition", yani composition ko
#  prefer karo. Iska matlab yeh NAHI hai ki "Inheritance kabhi use
#  mat karo." Inheritance tab sahi hai jab subclass sach mein parent
#    ka subtype ho. Yeh Liskov Substitution Principle (LSP) se
#  validate hota hai: Parent class ki jagah koi bhi subclass rakh
#  do, application break nahi hona chahiye.
#
#  Inheritance ke achhe examples:
#  - ArrayList is-a List
#  - CheckingAccount is-a BankAccount
#  - IllegalArgumentException is-a RuntimeException
#
#  Yahan subclass sirf code share nahi kar raha. Woh genuinely ek
#  concept ko specialize kar raha hai aur parent ke contract ko poori
#  tarah follow kar raha hai.
#
#  ------------------------------------------------------------
#  Code Example: Sahi Inheritance
#  ------------------------------------------------------------
#  class BankAccount:
#      def __init__(self, initial_balance: float):
#          self.balance = initial_balance
#
#      def deposit(self, amount: float):
#          self.balance += amount
#
#  # SavingsAccount ek BankAccount hai. Isme deposit/withdraw sab
#  # same hai, bas interest add karta hai. LSP pass.
#  class SavingsAccount(BankAccount):
#      def __init__(self, initial_balance: float, interest_rate: float):
#          super().__init__(initial_balance)
#          self.interest_rate = interest_rate
#
#      def apply_interest(self):
#          interest = self.balance * self.interest_rate
#          self.deposit(interest)
#
#  Yahan inheritance sahi hai kyunki SavingsAccount LSP test pass
#  karta hai. Jahan BankAccount expect hai, wahan SavingsAccount daal
#  do, sab kaam karega.
#
#  ------------------------------------------------------------
#  Inheritance use karne se pehle 3 sawaal (Litmus Test):
#  ------------------------------------------------------------
#  1. Kya main "X is a Y" bol sakta hoon aur yeh sense karta hai?
#     (SavingsAccount is a BankAccount. Haan.)
#  2. Kya main Y ki jagah X substitute kar sakta hoon bina kuch
#     tode? (BankAccount wale function mein SavingsAccount do. Haan.)
#  3. Kya yeh relationship stable hai aur unlikely to change?
#     (Bank accounts stable domain hai. Haan.)
#
#  Agar kisi ka jawab "No" ya "Maybe" hai, toh Composition use karo.
#
# ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Inheritance: "is-a", tight coupling, compile-time fix, testing
#    mushkil. Hierarchy deep ho sakti hai.
#  - Composition: "has-a", loose coupling, runtime changeable, testing
#    easy. Flat structure.
#  - Inheritance tab use karo jab subclass sach mein parent ka subtype
#    ho (LSP pass ho). Jaise SavingsAccount ek BankAccount hai.
#  - Agar goal sirf code share karna hai, toh Composition behtar hai.
#  - Litmus test: "is-a" sense karta hai? substitute kar sakte ho?
#    stable hai? Agar teeno haan, toh inheritance. Agar shak, toh
#    composition.
#
#  Ek line mein: "Agar X ek Y hai (SavingsAccount is a BankAccount),
#  toh Inheritance. Agar X ke paas Y hai (Car has an Engine), toh
#  Composition."
#
# ============================================================
