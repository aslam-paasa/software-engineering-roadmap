# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-2) — Aasan Hinglish Guide
#  Topic: The Cracks in the Inheritance Hierarchy (Problems)
# ============================================================
#
#  Pichle part mein humne Monster hierarchy banayi thi. Ab dekhte
#  hain ki Inheritance ke 3 bade problems kya hain jab system grow
#  karta hai.
#
# ============================================================
#
#  1. Rigidity aur Combinatorial Explosion
#  ----------------------------------------
#  Game designer naye monsters ka list leke aaya:
#  - Ek monster jo tair (swim) sake aur zehar (poison) thuk sake.
#  - Ek jo ud sake aur zehar thuk sake.
#  - Ek jo chal sake aur aag (fire) uda sake.
#  - ... aur bahut saare combinations.
#
#  Kya karein? SwimmingPoisonMonster class banaayein? FlyingPoisonMonster?
#  WalkingFireMonster? Har movement aur attack style ke combination
#  ke liye ek nayi class banani padegi. Isko "Combinatorial Explosion"
#  (combinations ka dhamaka) kehte hain.
#
#  Movement types: Fly, Walk, Swim (3 types)
#  Attack types: Fire, Poison, Melee (3 types)
#  Total classes needed = 3 x 3 = 9 (plus intermediate parents!)
#
#  Agar 1 naya movement (Teleport) add karo, toh 3 naye attack wale
#  classes banao. Agar 1 naya attack add karo, toh 3 naye movement
#  wale classes banao. Yahan wahan classes bomb rahe hain.
#
#  Aur Java jaisi languages mein multiple inheritance nahi hota, toh
#  agar ek monster ko fly bhi karna hai aur swim bhi, toh phasa.
#  Rigid "is-a" taxonomy fail ho gayi.
#
# ============================================================
#
#  2. The Fragile Base Class Problem
#  ---------------------------------
#  Inheritance OOP ka sabse tight coupling hai. Subclass apne
#  parent ki "implementation" se juda hota hai. Agar parent (base)
#  class mein change kiya, toh saare descendants break ho sakte hain.
#
#  Example: Maan lo humne Monster base class ke attack() method
#  mein ek parameter add kar diya (Target target).
#  Pehle: def attack(self): ...
#  Baad mein: def attack(self, target): ...
#
#  Toh har ek Monster subclass jo attack() override karti thi, woh
#  compile hi nahi hogi. Ek jagah lagatar achanak change ne poore
#  hierarchy ko tod diya. Base class "fragile" (nazuk) ho gaya.
#  Hierarchy jitna deep hoga, yeh utna hi fragile hoga.
#
# ============================================================
#
#  3. The "Gorilla/Banana" Problem
#  --------------------------------
#  Yeh famous quote Erlang creator Joe Armstrong ne di:
#  > "Tumhe ek banana chahiye tha, par tumhe jo mila woh ek gorilla
#  > hai jo banana pakde hue hai... aur poora jungle bhi."
#
#  Matlab: Jab tum kisi class se inherit karte ho, toh tumhe SAB
#  kuch mil jaata hai — saare public/protected methods aur fields,
#  chahe unki zaroorat ho ya na ho.
#
#  Agar Monster class mein 50 methods hain, par Dragon subclass ko
#  sirf 10 chahiye, tab bhi usko 50 milenge. Object bloat ho jaata
#  hai. Tum un cheezon ko expose karte ho jo tumhe nahi chahiye.
#  Tum udhar-udhar ke implementation details se jude rehte ho jo
#  tumne kabhi use nahi kiye.
#
# ============================================================
#
#  Root Cause (Asli problem kya hai?)
#  -----------------------------------
#  Yeh teeno problems — combinatorial explosion, fragile base class,
#  aur gorilla/banana — ek hi root cause se aate hain:
#  Inheritance ek mechanism hai "object kya hai (IS)" define karne ke
#  liye, par hum ise galat use karte hain "object kya karta hai (DOES)"
#  share karne ke liye.
#
#  Yahi wo jagah hai jahan Composition step in karta hai.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  Inheritance ke 3 problems:
#  - Combinatorial Explosion: Har behavior combination ke liye nayi
#    class banao (Fly+Poison, Walk+Fire...). Classes bahut zyada
#    ban jaate hain.
#  - Fragile Base Class: Parent class mein chhota change, saare
#    children break ho jaate hain.
#  - Gorilla/Banana Problem: Tumhe sirf banana (behavior) chahiye,
#    but tumhe poora gorilla (parent class) aur jungle bhi milta hai.
#
#  Next part mein: Solution — Composition (LEGO blocks wala tareeka).
#
# ============================================================
