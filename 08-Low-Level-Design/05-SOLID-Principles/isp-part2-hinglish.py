# ============================================================
#  INTERFACE SEGREGATION PRINCIPLE (ISP) — Part-2
#  Topic: ISP ke fayde (Kyun zaroori hai?)
# ============================================================
#
#  Pichle part mein seekha ki "Fat" interface (sab kuch karne wala)
#  problem create karta hai. Ab dekhte hain ISP follow karne ke
#  fayde kya hain.
#
# ============================================================
#
#  1. High Cohesion aur Low Coupling (Focused aur Azad)
#  ----------------------------------------------------
#  Interfaces highly focused ho jaate hain. AudioPlayer sirf audio
#  wale methods jaanta hai, VideoPlayer sirf video wale. Faltu ki
#  dependencies nahi banti. Classes ek dusre se azad rehti hain.
#
#  2. Flexibility aur Reusability (Reuse karna easy)
#  -------------------------------------------------
#  Chhote, role-specific interfaces ko implement karna easy hota
#  hai. Tum capabilities ko jod sakte ho. Jaise ek full video player
#  audio aur video dono interfaces implement kar sakta hai. Mix and
#  match kar sakte ho.
#
#  3. Code Readability (Padhne mein aasaan)
#  ----------------------------------------
#  Ek class kya kar sakti aur kya nahi, yeh turant clear ho jaata
#  hai. Jab interface mota tha, toh AudioOnlyPlayer dekh ke samajh
#  nahi aata tha ki woh video support karta hai ya nahi. Ab sirf
#  uske implemented interfaces dekho, sab clear hai.
#
#  4. Better Testability (Test karna easy)
#  ---------------------------------------
#  Jab tum client test karte ho jo AudioPlayer interface use karta
#  hai, toh sirf audio wale methods mock karne padte hain. Video ke
#  methods mock karne ki zaroorat nahi.
#
#  5. Avoids "Interface Pollution" aur LSP Violations
#  ---------------------------------------------------
#  Classes ko faltu methods implement nahi karne padte. Isse
#  UnsupportedOperationException aur LSP violations ka risk bahut
#  kam ho jaata hai. Subtypes reliably substitute ho sakte hain.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  ISP ke 5 fayde:
#  1. High Cohesion: Interfaces focused, classes azad.
#  2. Flexibility: Capabilities ko mix-match kar sakte ho.
#  3. Readability: Class ka kaam turant clear pata chal jaata hai.
#  4. Testability: Sirf zaroori methods mock karo, baaki nahi.
#  5. Avoids Pollution: Faltu methods nahi, LSP safe.
#
#  Next part mein: ISP ko code mein kaise apply karte hain?
#
# ============================================================
