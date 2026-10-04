# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-2
#  Topic: LSP ke fayde (Kyun zaroori hai?)
# ============================================================
#
#  Pichle part mein seekha ki ReadOnlyDocument exception throw karke
#  LSP break kar raha tha. Ab dekhte hain LSP follow karne ke fayde.
#
# ============================================================
#
#  1. Reliability aur Predictability (Bharosa)
#  ------------------------------------------
#  Jab LSP follow hota hai, code consistently behave karta hai. Tum
#  koi bhi subtype substitute kar sakte ho aur client ko wahi result
#  milega jo expect karta hai. Koi unpleasant surprise nahi.
#
#  2. Reduced Bugs (Kam Bugs)
#  ----------------------------
#  LSP break karne pe client code mein conditions lagani padti hain
#  (jaise if obj instanceof ReadOnlyDocument). Yeh code smell hai.
#  Jab client ko subtype ka pata hona padta hai, polymorphism break
#  ho jaata hai. LSP se yeh conditions nahi lagani padti, bugs kam
#  aate hain.
#
#  3. Maintainability aur Extensibility
#  -----------------------------------
#  Well-behaved hierarchies samajhna, maintain karna aur extend karna
#  easy hota hai. Naya subtype add karo bina existing code ke toote
#  ke dar ke.
#
#  4. True Polymorphism (Asli Polymorphism)
#  -----------------------------------------
#  LSP wajah hai ki polymorphism powerful banta hai. Tum base type
#  pe generic algorithms likh sakte ho, yakeen ke saath ki woh kisi
#  bhi current ya future subtype ke saath sahi kaam karenge.
#
#  5. Testability (Test karna easy)
#  --------------------------------
#  Base class ke liye likhe gaye tests, agar LSP follow ho raha hai,
#  toh saare subtypes ke liye bhi pass hone chahiye. Test suites
#  reuse ho sakte hain.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  LSP ke 5 fayde:
#  1. Reliability: Consistent behavior, koi surprise nahi.
#  2. Reduced Bugs: Client code mein type check nahi karna padta.
#  3. Maintainability: Naya subtype add karna safe aur easy.
#  4. True Polymorphism: Base type pe generic code likho, sab chalega.
#  5. Testability: Base class ke tests subtypes pe bhi pass honge.
#
#  Next part mein: LSP ko code mein kaise theek karte hain (Refactoring).
#
# ============================================================
