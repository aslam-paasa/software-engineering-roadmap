# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-2 (Tech Example)
#  Topic: DIP ke fayde (Kyun zaroori hai?)
# ============================================================
#
#  Pichle part mein seekha ki LoginService ka directly MySQLDatabase
#  pe depend karna problem create karta hai. Ab dekhte hain DIP
#  (Interface lagana) ke 5 fayde kya hain.
#
# ============================================================
#
#  1. Azadi (Decoupling)
#  ---------------------
#  Jab LoginService (dimaag) interface (contract) pe depend karta
#  hai, toh woh database (tool) ke details se azad ho jaata hai.
#  Tumhara LoginService ko farak nahi padta ki data MySQL se aaya
#  ya MongoDB se. Usse bas user ka data chahiye. "Database change
#  karo, LoginService mat chheddo."
#
#  2. Flexibility (Badlav aasaan)
#  ------------------------------
#  Naya database add karna ho ya purana change karna ho? Bas naya
#  database class banao jo interface (contract) ko implement kare.
#  Aur use LoginService mein daal do. LoginService (dimaag) ko
#  chhued nahi karna padta.
#
#  3. Test karna easy (Nakli database use karo)
#  --------------------------------------------
#  Jab tum LoginService test karte ho, toh asli database ki zaroorat
#  nahi. Asli DB pe connect karna slow aur mushkil hai. Tum ek
#  "Nakli" (Mock) database banao jo interface ko follow karta hai,
#  par asli DB pe query nahi chalata. Bas hardcode data return karta
#  hai. LoginService us Nakli DB pe test hota hai. Isse testing
#  fast aur safe ho jaati hai.
#
#  4. Maintain karna easy
#  ----------------------
#  Ek part mein change karne se dusra part break nahi hota. Agar
#  MySQLDatabase (tool) ka internal connection code change hua, toh
#  sirf MySQLDatabase update hoga. LoginService (dimaag) safe rahega,
#  jaise tak interface (contract) same raha.
#
#  5. Teamwork (Parallel Development)
#  ----------------------------------
#  Ek baar interface (contract) define ho gaya, toh alag-alag teams
#  independent kaam kar sakte hain. Ek team LoginService (dimaag)
#  bana raha hai, doosri team MySQLDatabase aur MongoDB bana rahi hai.
#  Dono ko sirf interface ke baare mein pata hai. Ek dusre ke code ka
#  wait nahi karna padta.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  DIP ke 5 fayde:
#  1. Azadi: Business logic (LoginService) tool (Database) se azad.
#  2. Flexibility: Naya database add karna easy, bina dimaag chhede.
#  3. Testability: Nakli (mock) database daal ke test karo, asli DB
#     nahi chahiye.
#  4. Maintainability: Ek change se dusra break nahi.
#  5. Teamwork: Teams independent kaam kar sakte hain.
#
#  Next part mein: DIP ko code mein kaise lagate hain?
#
# ============================================================
