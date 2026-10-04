# ============================================================
#  OPEN-CLOSED PRINCIPLE (OCP) — Part-4
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  OCP powerful hai, par isme kuch traps hain jinme developers
#  fast sakte hain. Dekhte hain.
#
# ============================================================
#
#  1. Over-Engineering (Jaldi Abstraction mat banao)
#  -------------------------------------------------
#  Galti: Har future change ke liye pehle se abstraction bana lena.
#  Example: Abhi sirf Credit Card hai, par future mein 100 aa
#  sakte hain isliye pehle hi interface bana lo.
#  Problem: Yeh code unnecessarily complex bana deta hai. YAGNI
#  principle break hota hai.
#  Solution: OCP strategically lagao jahan change anticipate ho.
#  Sab jagah mat lagao.
#
#  2. "Closed for Modification" ka galat matlab
#  -------------------------------------------
#  Galti: "Closed for modification" ka matlab yeh samajhna ki class
#  ko kabhi chhua nahi ja sakta. Agar bug hai, toh fix karo!
#  Solution: OCP sirf naye behavior add karne ke liye hai. Bug fix
#  aur refactoring allowed hain.
#
#  3. Abstraction Hell
#  --------------------
#  Galti: Bahut saare layers of abstraction bana lena.
#  Problem: Code samajhna aur debug karna mushkil ho jaata hai.
#  Solution: Goal clarity hai, abstraction-for-the-sake-of-abstraction
#  nahi.
#
#  4. Extension Points miss karna
#  ------------------------------
#  Galti: System ke stable hisse pe extension point banana, aur
#  volatile (badlavshil) hisse ko hardcode karna.
#  Solution: Domain samajho aur identify karo kahan change hone ke
#  chances hain (jaise payment types).
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Kya OCP ka matlab hai kabhi purana code change nahi kar sakte?
#      Bug fix kya karu?"
#  A: Nahi. OCP naye features/behaviors add karne ke baare mein hai.
#     Bug fix exception hai. Agar code mein flaw hai, toh definitely
#     modify karo. "Closed for modification" ka matlab yeh nahi ki
#     bug wala code chheda nahi ja sake.
#
#  Q2: "OCP kab apply karna chahiye? Har class ke liye?"
#  A: Zaroori nahi ki day one se har class pe OCP lagao. Yeh un
#     hisso mein sabse faydemand hai jahan change ya variations
#     anticipate ho (jaise business rules, integrations). Agar code
#     stable hai, toh OCP force karne se over-complication aayegi.
#
#  Q3: "Har chhote change ke liye nayi class banana cumbersome nahi?"
#  A: Shuru mein lagta hai, par long-term mein reduced risk aur easy
#     maintenance fayde outweigh karte hain. Monolithic, tangled class
#     se toh behtar hai ki chhoti classes bana lo. Modern IDEs mein
#     class manage karna easy hai.
#
#  ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Over-engineing mat karo: Sirf un points pe abstraction banao
#    jahan change expect ho (Rule of Three / YAGNI).
#  - Bug fix allowed hai, "closed for modification" uspe nahi lagta.
#  - Abstraction hell se bacho. Clarity pe focus karo.
#  - OCP har class pe force mat karo, stable code pe nahi. Volatile
#    parts (payments, integrations) pe lagao.
#
#  Ek line mein: OCP = "Naya feature add karne ke liye purana code
#  mat todo, nayi class banao. Par har future ke liye pehle se
#  abstraction mat banao, jab change aaye tab banao."
#
# ============================================================
