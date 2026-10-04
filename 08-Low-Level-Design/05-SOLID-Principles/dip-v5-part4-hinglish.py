# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-4 (Tech Example)
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  DIP lagana aasan hai, par kuch galtiyan avoid karna padta hai.
#  Tech example (LoginService aur Database) se samajhte hain.
#
# ============================================================
#
#  1. Over-Abstraction (Har cheez ka contract bana dena)
#  ----------------------------------------------------
#  Galti: Har chhoti class ke liye contract (interface) bana dena,
#  jo kabhi change hi nahi hogi. Jaise ek utility class jo string
#  capitalize karti hai, uska bhi interface bana lena.
#  Problem: Faltu ka clutter aur confusion. Code samajhna mushkil.
#  Solution: Contract tab banao jab zaroorat ho (external API, DB,
#  testing, ya change hone ke chances). Agar stable class hai, toh
#  skip karo.
#
#  2. Leaky Abstraction (Contract mein tool ki details thosna)
#  ---------------------------------------------------------
#  Galti: DatabaseInterface contract mein MySQL-specific methods
#  daal dena (jaise run_mysql_query()).
#  Problem: Contract hi MySQL pe depend kar raha hai. Purpose kharab.
#  Tool change karo toh contract bhi change karna padega.
#  Solution: Contract mein sirf wahi rakho jo LoginService (dimaag)
#  ko chahiye (get_user), tool-specific details nahi.
#
#  3. No Actual Injection (Contract use karke bhi khud tool banana)
#  -------------------------------------------------------------
#  Galti: LoginService contract pe depend karta hai, par constructor
#  mein khud "new MySQLDatabase()" kar raha hai.
#  Problem: Phirse tightly coupled. Dependency inversion fail.
#  Solution: Tool bahar se aana chahiye (Constructor ya setter).
#  Dimaag khud tool mat banao.
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Kya DIP aur Dependency Injection (DI) ek cheez hai?"
#  A: Nahi. Dono alag hain.
#     - DIP ek principle hai: "Contract (interface) pe depend karo,
#       tool (database) pe nahi."
#     - DI ek technique hai jisse DIP achieve karte hain: Database
#       ko bahar se inject karo, LoginService khud na banaye.
#     DIP goal hai, DI us goal tak pahunchne ka tareeka hai.
#
#  Q2: "Kya har class ke liye contract (interface) chahiye?"
#  A: Nahi. Sirf un hisson mein use karo jahan external systems
#     (APIs, DB) hain, testing ke liye mock chahiye, ya change hone
#     ke chances hain. Agar stable internal class hai, toh contract
#     skip karo.
#
#  Q3: "Contract (interface) kahan rakha jaata hai (project structure)?"
#  A: LoginService (dimaag) ke saath. DatabaseInterface contract
#     LoginService wale package mein ho. Kyunki contract woh batata
#     hai jo usse chahiye, implementation jo neeche hai woh nahi.
#
#  Q4: "Agar database (tool) ka connection code change hua toh?"
#  A: Database ka code change hua, toh sirf uss database ki class
#     update karo. LoginService (dimaag) ko farak nahi padega. Kyunki
#     LoginService sirf contract (interface) ko jaanta hai.
#
#  ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Over-abstraction mat karo: Har stable class ke liye contract nahi.
#  - Leaky abstraction se bacho: Contract mein database-specific
#    details mat daalo (jaise run_mysql_query).
#  - Proper injection karo: LoginService ke andar database mat banao,
#    bahar se lo.
#  - DIP principle hai, DI technique.
#
#  Ek line mein: DIP = "LoginService (dimaag) aur Database (tool),
#  dono ek Contract (interface) pe depend karein. LoginService direct
#  database pe depend na kare. Database change ho jaye, LoginService
#  ko farak nahi padna chahiye."
#
# ============================================================
