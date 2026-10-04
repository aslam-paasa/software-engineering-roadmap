# ============================================================
#  INTERFACE SEGREGATION PRINCIPLE (ISP) — Part-4
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  ISP lagana aasan hai, par thoda dhyan rakhna padta hai. Kuch
#  common traps dekhte hain.
#
# ============================================================
#
#  1. Over-Segregation (Bahut zyada tod dena)
#  -----------------------------------------
#  Galti: Har method ke liye alag interface bana dena (Playable,
#  Stoppable, AdjustableVolume). Ek method, ek interface.
#  Problem: Bahut saari tiny files ban jaati hain. Manage karna mushkil.
#  Solution: Related methods ko ek role mein group karo. PlayAudio,
#  StopAudio, AdjustVolume sab ek AudioPlayerControls interface mein.
#
#  2. Client ki Nazar se na sochna
#  ------------------------------
#  Galti: Interface design karte waqt sirf implementer ko dekhna,
#  client ko nahi.
#  Solution: Client code se shuru karo. Poocho: "Client ko kam se
#  kam kaunse methods chahiye?" Us hisaab se interface banao.
#
#  3. Cohesion ki Kami (Unrelated methods ek mein)
#  ----------------------------------------------
#  Galti: Unrelated methods ko ek interface mein daal dena.
#  Solution: Har interface ek role hona chahiye. Interface ke saare
#  methods us role se related hone chahiye.
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Interface kitna chhota hona chahiye?"
#  A: Koi strict rule nahi. Rule of thumb: Client ki zaroorat pe
#     based banao. Agar alag-alag clients alag capabilities interested
#     hain, toh split karo.
#
#  Q2: "Bahut saare chhote interfaces complexity na badhayenge?"
#  A: Shuru mein lagta hai, par yeh intentional structure hai.
#     Ek 15-method wala bada interface samajhna mushkil hota hai.
#     Chhote, focused contracts samajhna easy hote hain.
#
#  Q3: "Kya class multiple interfaces implement kar sakti hai?"
#  A: Bilkul! Yeh ISP ka sabse bada fayda hai. Ek class multiple
#     roles play kar sakti hai. Jaise AudioPlayerControls aur
#     VideoPlayerControls dono implement kar sakti hai.
#
#  Q4: "ISP aur LSP ka kya rishta hai?"
#  A: Dono close hain.
#     - ISP ensure karta hai ki interfaces minimal aur relevant hon.
#     - LSP ensure karta hai ki implementations sahi behave karein.
#     Jab interfaces bahut bade hote hain (ISP break), toh classes
#     faltu methods implement karne ke liye majboor hoti hain jo
#     exception throw karte hain. Yeh LSP break karta hai. ISP se
#     LSP follow karna easy ho jaata hai.
#
#  ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - Over-segregation mat karo: Har method ke liye alag interface
#    nahi. Related methods ko ek role mein group karo.
#  - Client ki perspective se design karo.
#  - Cohesion maintain karo: Interface ke methods ek role ke hone
#    chahiye.
#  - Multiple interfaces implement karna allowed aur faydemand hai.
#  - ISP aur LSP saath kaam karte hain.
#
#  Ek line mein: ISP = "Interface ko mota mat banao. Chhote, focused
#  rakho. Client ko jo chahiye sirf woh do, faltu methods mat thoso."
#
# ============================================================
