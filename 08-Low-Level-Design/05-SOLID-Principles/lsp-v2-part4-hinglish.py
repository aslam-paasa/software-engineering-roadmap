# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-4
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  LSP samajhna easy hai, par apply karna thoda tricky hai. Kuch
#  common galtiyan dekhte hain.
#
# ============================================================
#
#  1. The "Is-A" Linguistic Trap (Bhasha ka Jaal)
#  ----------------------------------------------
#  Bas kyunki English mein koi cheez "is-a" sound karti hai, iska
#  matlab yeh nahi ki code mein valid subtype hai.
#
#  Example: Penguin "is a" Bird (Penguin ek pakshi hai). Par Penguin
#  ud nahi sakta. Agar Bird class mein fly() method hai, aur tum
#  Penguin mein override karke exception throw karte ho — toh LSP
#  break.
#
#  Subtyping behavior pe based honi chahiye, biology pe nahi. Agar
#  Bird uda nahi sakta, toh usse Bird ki subclass mat banao.
#
#  ------------------------------------------------------------
#  2. Override karke kuch na karna ya Exception throw karna
#  ---------------------------------------------------------
#  Agar tum child class mein method override kar rahe ho bas usko
#  khali (pass) rakhne ya exception throw karne ke liye, toh woh
#  valid subtype nahi hai. LSP break.
#
#  ------------------------------------------------------------
#  3. Client Code mein Type Checks (instanceof)
#  -------------------------------------------
#  Agar client code mein "if obj instanceof ReadOnlyDocument" check
#  karna pad raha hai, toh yeh LSP break hone ka symptom hai.
#  Polymorphism ka matlab hi yeh hai ki client ko subtype nahi pata
#  honi chahiye. Sab khud chale.
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Agar child class parent jaisa kaam nahi kar sakti toh?"
#  A: Wahin ruko aur hierarchy rethink karo.
#     - Shayad woh subtype hi nahi honi chahiye. (Penguin bird nahi
#       agar udna hai).
#     - Responsibilities split karo (Readable, Editable interfaces).
#     - Composition use karo (Inheritance ke bajaye object rakho).
#
#  Q2: "Iska matlab main kabhi instanceof use nahi kar sakta?"
#  A: Kabhi-kabhi legitimate use cases hain (jaise equals check).
#     Par agar tum isinstance se business logic chala rahe ho, toh
#     tum LSP violation chhupa rahe ho. Apne aap se poocho: "Kya
#     main yeh isliye use kar raha hoon kyunki maine polymorphism
#     tod diya?"
#
#  ============================================================
#
#  SUMMARY (Part-4)
#  ----------------
#  - "Is-A" trap: Penguin bird hai par ud nahi sakta. Behavior pe
#    based karo, biology pe nahi.
#  - Override karke exception/pass mat karo. Subtype valid nahi hai.
#  - Client code mein isinstance se business logic mat chalao.
#  - Agar child parent jaisa kaam nahi kar sakti, toh hierarchy
#    badlo ya Composition use karo.
#
#  Ek line mein: LSP = "Bete (child) ko pita (parent) ki jagah
#  bitha do. Sab kuch waise hi chalna chahiye. Agar nahi chal raha,
#  toh inheritance galat hai."
#
# ============================================================
