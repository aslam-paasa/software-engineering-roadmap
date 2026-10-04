# ============================================================
#  SINGLE RESPONSIBILITY PRINCIPLE (SRP) — Part-2
#  Topic: SRP kyun zaroori hai? (Fayde)
# ============================================================
#
#  Pichle part mein seekha ki God Class (sab kuch karne wali class)
#  galat hai. Ab dekhte hain SRP follow karne ke fayde kya hain.
#
# ============================================================
#
#  1. Padhne mein aasaan (Easier to read)
#  --------------------------------------
#  Jab class sirf ek kaam karti hai, toh turant samajh aata hai ki
#  yeh class kya karna aayi hai. Koi surprise nahi, koi hundreds of
#  lines scroll karke method dhoondhne ki zaroorat nahi.
#
#  2. Test karna aasaan (Easier to test)
#  -------------------------------------
#  Chhoti zimmedari matlab chhote test cases aur kam dependencies.
#  Tum PasswordHasher ko test kar sakte ho bina database connection
#  ya email server ke. Sirf password do, hash check karo. Bas.
#
#  3. Kam nazuk (Less brittle)
#  ----------------------------
#  Ek zimmedari mein change karne se unrelated parts pe asar nahi
#  padta. Email service update karo, toh password hashing break
#  nahi hogi. Bug ka "blast radius" kam hota hai.
#
#  4. Reuse karna aasaan (Easier to reuse)
#  ----------------------------------------
#  Chhoti, focused classes alag-alag contexts mein use ho sakti hain.
#  AuthTokenService web app aur mobile API dono mein use ho sakta hai.
#
#  5. Scale karna aasaan (Scales better)
#  -------------------------------------
#  Teams system ke alag-alag parts pe kaam kar sakte hain bina ek
#  dusre ke pair pe padhe. DB team UserRepository modify kare, email
#  workflow break nahi hoga.
#
#  Yeh fayde time ke saath compound hote hain. SRP follow karne
#  wala codebase 6 mahine baad extend karna bahut aasaan hota hai.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  SRP ke 5 fayde:
#  1. Readability: Class ka kaam turant samajh aata hai.
#  2. Testing: Kam dependencies, aasaan tests.
#  3. Less Brittle: Ek change se dusra break nahi hota.
#  4. Reusability: Focused classes kahin bhi use ho sakte hain.
#  5. Scalability: Teams independent kaam kar sakte hain.
#
#  Next part mein: SRP ko code mein kaise apply karte hain?
#
# ============================================================
