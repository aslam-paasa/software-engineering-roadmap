# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-2) — Aasan Hinglish
#  Topic: Inheritance ki Problems
# ============================================================
#
#  Pichle part mein seekha ki Inheritance "Is-A" (beti ban na) aur
#  Composition "Has-A" (paas rakhna) hai. Ab dekhte hain Inheritance
#  ke 3 bade nuksan kya hain.
#
#  Maan lo tum game bana rahe ho jisme Monsters hain. Kuch udte
#  hain (Fly), kuch chalte hain (Walk). Kuch aag udaate hain (Fire),
#  kuch zehar thukte hain (Poison).
#
# ============================================================
#
#  Problem 1: Combinatorial Explosion (Class ka Dhamaka)
#  -----------------------------------------------------
#  Agar tum Inheritance use karoge, toh har combination ke liye ek
#  nayi class banani padegi.
#  - Fly + Fire wala monster (FireDragon)
#  - Fly + Poison wala monster (PoisonDragon)
#  - Walk + Fire wala monster (WalkingFireMonster)
#  - Swim + Poison wala monster (PoisonSwimmer)
#
#  Ab dekho: Movement ke 3 type (Fly, Walk, Swim) aur Attack ke 3
#  type (Fire, Poison, Melee) hain. Total classes banenge 3 x 3 = 9!
#  Agar 1 movement (Teleport) add karoge, toh 3 naye attack wale
#  classes banao. Classes bomb rahe hain, manage karna mushkil.
#
#  Problem 2: Fragile Base Class (Nazuk Base Class)
#  ------------------------------------------------
#  Tumne Monster base class banaya. Usme attack() method hai.
#  Ab tumne socha "attack() mein target parameter add kar dete hain."
#  Pehle: def attack(self)
#  Baad mein: def attack(self, target)
#
#  BOOM! Tumhare saare child classes (Dragon, Zombie) jo attack()
#  override kar rahe the, woh compile error de degi. Parent mein ek
#  chhota sa change ne poore system ko tod diya. Yeh hierarchy ko
#  "fragile" (nazuk) banata hai.
#
#  Problem 3: Gorilla/Banana Problem
#  ---------------------------------
#  Famous quote hai: "Tumhe ek Kela (banana) chahiye tha, par
#  tumhe ek Gorilla mila jo kela pakde hue hai... aur poora jungle."
#
#  Matlab: Jab tum Inheritance use kar ke parent se code lete ho,
#  toh tumhe SAB kuch mil jaata hai. Agar Monster class mein 50
#  methods hain, aur tumhe sirf 10 chahiye, tab bhi 50 milenge.
#  Object faltu ka code se bhar jaata hai. Tum un cheezon ke saath
#    jude rehte ho jo tumne use hi nahi ki.
#
# ============================================================
#
#  Asli Problem (Root Cause)
#  --------------------------
#  Inheritance "object kya hai (IS)" define karne ke liye bana tha.
#  Par hum galat use karte hain "object kya karta hai (DOES)" share
#  karne ke liye. Yahi problem hai.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  Inheritance ke 3 problems:
#  1. Combinatorial Explosion: Har naye combination ke liye nayi
#     class banao. (Fly+Fire, Walk+Poison... classes bahut zyada).
#  2. Fragile Base Class: Parent mein chhota change, saare children
#     break ho jaate hain.
#  3. Gorilla/Banana: Sirf 1 feature chahiye, but poora parent
#     class (50 methods) inherit karna padta hai.
#
#  Next part mein: Solution — Composition (LEGO blocks).
#
# ============================================================
