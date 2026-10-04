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
#  1. Bharosa (Reliability)
#  -------------------------
#  Jab LSP follow hota hai, code consistently behave karta hai. Tum
#  koi bhi child class parent ki jagah daal sakte ho, aur client ko
#  wahi result milega jo expect karta hai. Koi achanak crash nahi.
#
#  2. Kam Bugs
#  -----------
#  LSP break karne pe client code mein conditions lagani padti hain
#  (jaise "agar yeh ReadOnlyDocument hai toh save mat kar"). Yeh code
#  smell hai. LSP se yeh conditions nahi lagani padti, bugs kam aate
#  hain.
#
#  3. Naya Type Add Karna Aasaan (Extensibility)
#  ---------------------------------------------
#  Well-behaved hierarchy mein naya child add karna safe hota hai.
#  Existing code break hone ka dar nahi rehta.
#
#  4. Asli Polymorphism
#  ---------------------
#  LSP ki wajah se polymorphism powerful banta hai. Tum parent type
#  pe generic code likh sakte ho, yakeen ke saath ki woh kisi bhi
#  child ke saath sahi kaam karega.
#
#  5. Test Karna Aasaan
#  --------------------
#  Parent class ke liye likhe gaye tests, agar LSP follow ho raha
#  hai, toh child ke liye bhi pass hone chahiye. Alag se tests likhne
#  ki zaroorat nahi.
#
# ============================================================
#
#  SUMMARY (Part-2)
#  ----------------
#  LSP ke 5 fayde:
#  1. Reliability: Consistent behavior, koi surprise nahi.
#  2. Reduced Bugs: Client code mein type check nahi karna padta.
#  3. Extensibility: Naya child add karna safe aur easy.
#  4. True Polymorphism: Parent pe generic code likho, sab chalega.
#  5. Testability: Parent ke tests child pe bhi pass honge.
#
#  Next part mein: LSP ko code mein kaise theek karte hain?
#
# ============================================================
