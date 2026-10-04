# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-4
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  DIP lagana aasan hai, par kuch galtiyan avoid karna padta hai.
#
# ============================================================
#
#  1. Over-Abstraction (Bahut zyada interfaces)
#  -------------------------------------------
#  Galti: Har chhoti class ke liye interface bana dena, jo kabhi
#  change hi nahi hogi.
#  Problem: Faltu ka clutter aur confusion. Samajhna mushkil.
#  Solution: Interface tab banao jab zaroorat ho (external API,
#  testing, ya change hone ke chances).
#
#  2. Leaky Abstractions (Interface mein details thosna)
#  ----------------------------------------------------
#  Galti: EmailClient interface mein Gmail-specific methods daal dena
#  (jaise configure_gmail_setting()).
#  Problem: Interface phir se Gmail pe depend kar raha hai. Purpose
#  kharab.
#  Solution: Interface mein sirf wahi rakho jo high-level module ko
#  chahiye, implementation-specific details nahi.
#
#  3. No Actual Injection (Interface use karke bhi khud banana)
#  ---------------------------------------------------------
#  Galti: EmailService interface pe depend karta hai, par constructor
#  mein khud "new GmailClientImpl()" kar raha hai.
#  Problem: Phirse tightly coupled. Dependency inversion fail.
#  Solution: Dependency bahar se aani chahiye (Constructor ya setter).
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Kya DIP aur Dependency Injection (DI) ek cheez hai?"
#  A: Nahi.
#     - DIP ek principle hai: "Abstractions pe depend karo, concrete
#       pe nahi."
#     - DI ek technique hai jisse DIP achieve karte hain: Dependencies
#       bahar se inject karo, class khud na banaye.
#
#  Q2: "Kya har class ke liye interface chahiye?"
#  A: Nahi. Sirf un hisso mein use karo jahan external systems (APIs,
#     DB) hain, testing ke liye mock chahiye, ya change hone ke chances
#     hain. Agar stable internal class hai, toh interface skip karo.
#
#  Q3: "Interfaces kahan rakhe jaane chahiye (project structure)?"
#  A: Client (high-level module) ke saath. EmailClient interface
#     EmailService wale package mein ho. Kyunki interface woh batata
#     hai jo usse chahiye, implementation jo neeche hai woh nahi.
#
#  ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Over-abstraction mat karo: Har stable class ke liye interface
#    nahi.
#  - Leaky abstraction se bacho: Interface mein provider-specific
#    details mat daalo.
#  - Proper injection karo: Class ke andar concrete object mat banao,
#    bahar se lo.
#  - DIP principle hai, DI technique.
#
#  Ek line mein: DIP = "Business logic ko farak nahi padna chahiye
#  ki kaunsa tool use ho raha hai. Sab interface pe depend karein,
#  concrete class pe nahi."
#
# ============================================================
