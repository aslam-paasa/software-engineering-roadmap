# ============================================================
#  INTERFACE SEGREGATION PRINCIPLE (ISP) — Part-2
#  Topic: ISP ke fayde (Kyun zaroori hai?)
# ============================================================
#
#  Pichle part mein seekha ki "Mota" interface problem create karta
#  hai. Ab dekhte hain ISP follow karne ke fayde kya hain.
#
# ============================================================
#
#  1. Focused aur Azad (High Cohesion)
#  ------------------------------------
#  Interfaces highly focused ho jaate hain. AudioPlayer sirf audio
#  wale methods jaanta hai, VideoPlayer sirf video wale. Faltu ki
#  dependencies nahi banti. Classes ek dusre se azad rehti hain.
#
#  2. Mix and Match (Flexibility)
#  ------------------------------
#  Chhote interfaces ko implement karna easy hota hai. Tum capabilities
#  ko jod sakte ho. Jaise ek full video player audio aur video dono
#  interfaces implement kar sakta hai. Jo chahiye sirf woh lo.
#
#  3. Padhne mein Aasaan (Readability)
#  -----------------------------------
#  Ek class kya kar sakti aur kya nahi, yeh turant clear ho jaata
#  hai. Jab interface mota tha, toh AudioOnlyPlayer dekh ke samajh
#  nahi aata tha ki yeh video support karta hai ya nahi. Ab sirf
#  uske implemented interface dekho, sab clear.
#
#  4. Test karna easy
#  ------------------
#  Jab tum client test karte ho jo AudioPlayer interface use karta
#  hai, toh sirf audio wale methods mock karne padte hain. Video ke
#  methods mock karne ki zaroorat nahi.
#
#  5. Kam Bugs (Avoids Pollution)
#  ------------------------------
#  Classes ko faltu methods implement nahi karne padte. Isse
#  UnsupportedOperationException ka risk bahut kam ho jaata hai.
#  LSP violations nahi aate.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  ISP ke 5 fayde:
#  1. Focused: Interfaces focused, classes azad.
#  2. Flexibility: Capabilities ko mix-match kar sakte ho.
#  3. Readability: Class ka kaam turant clear pata chalta hai.
#  4. Testability: Sirf zaroori methods mock karo, baaki nahi.
#  5. Kam Bugs: Faltu methods nahi, LSP safe.
#
#  Next part mein: ISP ko code mein kaise lagate hain?
#
# ============================================================
