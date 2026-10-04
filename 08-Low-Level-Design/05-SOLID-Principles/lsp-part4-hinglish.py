# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-4
#  Topic: Common Galtiyan aur Sawaal-Jawaab
# ============================================================
#
#  LSP samajhna easy hai, par apply karna challenging hai. Kuch
#  common traps dekhte hain.
#
# ============================================================
#
#  1. The "Is-A" Linguistic Trap (Bhasha ka jaal)
#  ----------------------------------------------
#  Bas kyunki natural language mein koi cheez "is-a" sound karti
#  hai, iska matlab yeh nahi ki code mein valid subtype hai.
#  Example: Penguin "is a" Bird. Par Penguin ud nahi sakta.
#  Agar Bird class mein fly() method hai, aur tum Penguin mein
#  override karke exception throw karte ho — toh LSP break.
#  Subtyping behavior pe based honi chahiye, taxonomy (biology) pe
#  nahi.
#
#  2. Override karke kuch na karna ya Exception throw karna
#  -------------------------------------------------------
#  Agar tum child class mein method override kar rahe ho bas usko
#  khali (pass) rakhne ya exception throw karne ke liye, toh woh
#  valid subtype nahi hai. LSP break.
#
#  3. Preconditions ya Postconditions violate karna
#  -----------------------------------------------
#  - Precondition violation: Base class method koi bhi positive
#    number accept karta hai. Par tumhara subtype sirf 100 se bade
#    number accept karta hai. Client jo 50 dega, woh break ho jaayega.
#  - Postcondition violation: Base class guarantee deta hai ki return
#    value null nahi hogi. Par tumhara subtype kabhi null return
#    karta hai. Trust break.
#
#  4. Client Code mein Type Checks (instanceof)
#  -------------------------------------------
#  Agar client code mein "if obj instanceof ReadOnlyDocument" check
#  karna pad raha hai, toh yeh LSP break hone ka symptom hai.
#  Polymorphism ka matlab hi yeh hai ki client ko subtype nahi pata
#  honi chahiye.
#
#  ============================================================
#
#  Sawaal-Jawaab (Common Questions)
#  ---------------------------------
#
#  Q1: "Kya LSP sirf 'good inheritance' ke baare mein hai?"
#  A: Haan, par zyada precise. Yeh define karta hai ki correct
#     behavioral inheritance kya dikhti hai. Yeh sirf code reuse
#     nahi, correctness aur intention preserve karta hai.
#
#  Q2: "Agar child class parent jaisa kaam nahi kar sakti toh?"
#  A: Wahin ruko aur hierarchy rethink karo.
#     - Shayad woh subtype hi nahi honi chahiye.
#     - Responsibilities split karo (Readable, Editable interfaces).
#     - Composition use karo (Inheritance ke bajaye object rakho).
#
#  Q3: "Iska matlab main kabhi instanceof use nahi kar sakta?"
#  A: Kabhi-kabhi legitimate use cases hain (equals, serialization).
#     Par agar tum instanceof se business logic chala rahe ho, toh
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
#  - Preconditions/Postconditions violate mat karo (zyada strict
#    mat karo, kam guarantee mat do).
#  - Client code mein instanceof se business logic mat chalao.
#  - Agar child parent jaisa kaam nahi kar sakti, toh hierarchy
#    badlo ya Composition use karo.
#
#  Ek line mein: LSP = "Child class parent ki jagah replace ho saki
#  bina kisi issue ke. Agar nahi ho sakti, toh inheritance galat hai."
#
# ============================================================
