# ============================================================
#  OPEN-CLOSED PRINCIPLE (OCP) — Part-2
#  Topic: OCP ke fayde (Kyun zaroori hai?)
# ============================================================
#
#  Pichle part mein seekha ki har baar class modify karna (naye
#  payment add karte waqt if-else lagana) risky hai. Ab dekhte hain
#  OCP follow karne ke fayde kya hain.
#
# ============================================================
#
#  1. Maintainability (Maintain karna aasaan)
#  ------------------------------------------
#  Jab tum naye features naye code se add karte ho (nayi class bana
#  ke), purane code ko chhuede bina, toh purana feature tootne ka
#  risk kam ho jaata hai. System maintain karna easy ho jaata hai.
#
#  2. Scalability (Scale karna aasaan)
#  -----------------------------------
#  Naye features ya variations minimal impact ke saath add ho
#  sakte hain. Codebase change ke liye flexible aur adaptable ban
#  jaati hai.
#
#  3. Reduced Risk (Kam khatra)
#  ----------------------------
#  Tum battle-tested (tested aur working) purane code ko chhu nahi
#  rahe, toh regressions (purane features mein bugs) aane ka chance
#  bahut kam. Deployment ke time confidence badhta hai.
#
#  4. Better Testability (Test karna aasaan)
#  -----------------------------------------
#  Naye extensions ko isolation mein test kar sakte ho. Pura system
#  dobara test karne ki zaroorat nahi. Naya payment method aaya,
#    sirf uski nayi class test karo.
#
#  5. Clearer Code (Saaf-saaf code)
#  --------------------------------
#  OCP se responsibilities clearly alag-alag ho jaati hain. Code
#  samajhna aasaan ho jaata hai. Ek hi class mein 10 if-else nahi
#  pade rahenge.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  OCP ke 5 fayde:
#  1. Maintainability: Naya code add karo, purana safe rahega.
#  2. Scalability: Variations minimal impact se add hote hain.
#  3. Reduced Risk: Purana code chhued nahi, toh regression kam.
#  4. Testability: Naye feature ko akele test karo.
#  5. Clearer Code: Responsibilities alag, if-else kam.
#
#  Next part mein: OCP ko code mein kaise apply karte hain?
#
# ============================================================
