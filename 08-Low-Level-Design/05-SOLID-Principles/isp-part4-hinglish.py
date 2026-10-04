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
#  1. Over-Segregation (Interface-itis)
#  ------------------------------------
#  Galti: Har method ke liye alag interface bana dena (Playable,
#  Stoppable, AdjustableVolume). Ek method, ek interface.
#  Problem: Bahut saari tiny files ban jaati hain. Manage karna aur
#  samajhna mushkil ho jaata hai. Ek bade interface ki tarah bura.
#  Solution: Related methods ko ek role mein group karo. PlayAudio,
#  StopAudio, AdjustVolume sab ek AudioPlayerControls interface mein.
#  Yeh ek cohesive role hai.
#
#  2. Client ki Nazar se na sochna
#  ------------------------------
#  Galti: Interface design karte waqt sirf implementer (jo class
#  implement kar rahi hai) ko dekhna, client ko nahi.
#  Problem: ISP client ke liye hai, implementer ke liye nahi.
#  Solution: Client code se shuru karo. Poocho: "Client ko kam se
#  kam kaunse methods chahiye?" Us hisaab se interface banao.
#
#  3. Cohesion ki Kami
#  -------------------
#  Galti: Unrelated methods ko ek interface mein daal dena.
#  Problem: Interface confuse karta hai, aur ek bade (fat) interface
#  jaisi hi problem aati hai.
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
#     hain, toh split karo. Roles ya capabilities ke terms mein socho.
#
#  Q2: "Bahut saare chhote interfaces complexity na badhayenge?"
#  A: Shuru mein lagta hai, par yeh intentional structure hai.
#     Ek 15-method wala bada interface samajhna mushkil hota hai.
#     Chhote, focused contracts samajhna easy hote hain. Coupling
#     kam hoti hai. Clutter nahi, intentional design hai.
#
#  Q3: "Kya class multiple interfaces implement kar sakti hai?"
#  A: Bilkul! Yeh ISP ka sabse bada fayda hai. Ek class multiple
#     roles play kar sakti hai. Jaise LoadableMedia, PlaybackControls,
#     VolumeControl sab implement kar sakti hai.
#
#  Q4: "ISP aur LSP ka kya rishta hai?"
#  A: Dono close hain.
#     - ISP ensure karta hai ki interfaces minimal aur relevant hon.
#     - LSP ensure karta hai ki implementations sahi behave karein.
#     Jab interfaces bahut bade hote hain (ISP break), toh classes
#     faltu methods implement karne ke liye majboor hoti hain jo
#     UnsupportedOperationException throw karte hain. Yeh LSP break
#     karta hai. ISP se LSP follow karna easy ho jaata hai.
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
#  - ISP aur LSP saath kaam karte hain. ISP minimal interfaces banata
#    hai, LSP unhe sahi se follow karwata hai.
#
#  Ek line mein: ISP = "Interface ko mota mat banao. Chhote, focused
#  rakho. Client ko jo chahiye sirf woh do, faltu methods mat thoso."
#
# ============================================================
