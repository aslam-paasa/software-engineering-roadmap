# ============================================================
#  SINGLE RESPONSIBILITY PRINCIPLE (SRP) — Part-4
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  SRP lagana aasan lagta hai, par developers kuch common galtiyan
#  karte hain. Dekhte hain kya hai aur kaise bacha jaaye.
#
# ============================================================
#
#  1. Over-Splitting (Bahut zyada tod dena)
#  -----------------------------------------
#  Galti: Class ko bahut saare chhote classes mein tod dena jo koi
#  asli value nahi add karte.
#  Example: PasswordHasher ko 4 classes mein todna — PasswordValidator,
#  SaltGenerator, BcryptEncoder, HashAggregator.
#  Problem: Yeh system ko samajhna mushkil banata hai. Bahut saari
#  files aur dependencies dimag mein rakhni padti hain.
#  Solution: "Cohesion" par focus karo. Jo logic ek saath change hota
#  hai, usko ek class mein rakho. Hashing ka sab ek jagah theek hai.
#
#  2. Methods ko Responsibilities samajhna
#  ---------------------------------------
#  Galti: Har method ko apni class banana. Jaise EmailService mein
#  send_welcome_email() aur send_payslip_email() dono hain, toh
#  WelcomeEmailSender aur PayslipEmailSender alag bana lo.
#  Problem: Dono methods ek hi kaam (email bhejna) kar rahe hain.
#  Solution: Methods ki ginti aur responsibilities ki ginti alag hai.
#  Agar methods ek hi purpose serve karte hain, toh ek class mein
#  rakho.
#
#  3. Small classes mein SRP ignore karna
#  --------------------------------------
#  Galti: "Yeh class chhoti hai, SRP ki zaroorat nahi." Par chhoti
#  class quietly God Class ban sakti hai.
#  Example: ReportUtils jisme CSV generate karna, email bhejna, aur
#  archive karna sab hai.
#  Solution: Early apply karo. Pehle se focused rakho.
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Kya isse classes bahut zyada nahi ho jaate?"
#  A: Haan, classes badhte hain. Par yeh acha hai! Ek badi class jo
#     sab kuch poori tarah nahi karti, usse behtar hai chhoti classes
#     jo ek kaam achhe se karein. Padhna, test karna, maintain karna
#     aasaan ho jaata hai.
#
#  Q2: "Zimmedari kitni chhoti honi chahiye?"
#  A: Koi strict rule nahi. Par simple check:
#     Agar class ka kaam batane ke liye tumhe "AND" ya "OR" use karna
#     pade, toh uske 1 se zyada responsibilities hain.
#     Example: "Yeh class reports banati AUR email bhejti hai." -> 2
#     responsibilities. Todo.
#
#  Q3: "Kya SRP sirf classes pe lagta hai?"
#  A: Nahi. Yeh har level pe lagta hai: Class, Method, Module, Service
#     (microservice), System. Har level pe ek kaam hona chahiye.
#
#  Q4: "Agar responsibilities related hain toh?"
#  A: Related behaviors ko ek class mein rakhna theek hai. Jaise
#     EmailService welcome, password reset, payslip email bhej sakti
#     hai. Sab ek kaam kar rahe hain: email bhejna. Par agar yeh PDF
#     generate karna start kar de, toh usko split karo.
#
#  ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Over-splitting mat karo: Jo logic ek saath change hota hai, usko
#    ek class mein rakho (Cohesion).
#  - Method count aur responsibility count alag hain. Dono confuse mat karo.
#  - "AND/OR" test: Agar class ka kaam batane mein "and/or" lagta hai,
#    toh SRP break ho raha hai.
#  - SRP classes, methods, modules, services sab pe lagta hai.
#  - Related behaviors ek class mein theek hain (EmailService different
#    emails bhej sakti hai). Unrelated behaviors ko split karo.
#
#  Ek line mein: SRP = "Ek class, ek kaam. Ek reason to change."
#
# ============================================================
