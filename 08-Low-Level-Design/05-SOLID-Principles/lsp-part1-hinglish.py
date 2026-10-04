# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-1
#  Topic: Problem aur LSP ka matlab
# ============================================================
#
#  Kabhi kisi method mein child class ka object pass kiya (jo parent
#  expect kar raha tha), aur program crash ho gaya ya ajeeb behave
#  kiya? Ya class extend karke method ko override kiya bas exception
#  throw karne ke liye?
#
#  Agar haan, toh tumne LSP tod diya. Chalo aasan bhasha mein
#  samajhte hain.
#
# ============================================================
#
#  1. Problem: Document System Galat ho gaya
#  ------------------------------------------
#  Tumne ek Document base class banayi jisme open(), save(), aur
#  get_data() methods hain.
#
#  Ab naya requirement aaya: "Read-only document chahiye (sensitive
#  content ke liye)."
#  Tumne socha: ReadOnlyDocument toh ek Document hi hai. Inheritance
#  use kar lo. Bas save() ko override karke exception throw kar do.
#
#  class Document:
#      def save(self, new_data):
#          self.data = new_data
#          print("Document saved.")
#
#  class ReadOnlyDocument(Document):
#      def save(self, new_data):
#          raise Exception("Cannot save a read-only document!")
#
#  Ab client code (DocumentProcessor) koi bhi Document leta hai aur
#  uspe save() call karta hai. Normal Document pe theek hai. Par
#  jab ReadOnlyDocument pass kiya, toh CRASH! Exception aaya.
#
#  Client code ka expectation tha ki har Document save ho sakta hai.
#  Par ReadOnlyDocument ne yeh expectation tod di.
#
#  ------------------------------------------------------------
#  Kya galat hua?
#  ------------------------------------------------------------
#  ReadOnlyDocument parent (Document) ki jagah substitute nahi ho
#  saka bina program ke toote. Yahi LSP violation hai.
#
#  Agar tum kabhi method ko override karke exception throw karte ho,
#  ya client code mein "agar yeh ReadOnlyDocument hai toh" jaisa
#  check lagana padta hai — toh LSP break ho raha hai.
#
# ============================================================
#
#  2. LSP kya hai?
#  ---------------
#  Barbara Liskov ne 1987 mein kaha:
#  > "Agar S, T ka subtype hai, toh T type ke objects ko S type ke
#  > objects se replace kiya ja sake bina program ke desirable
#  > properties ko alter kiye."
#
#  Simple bhasha: Agar class S, class T ko extend karti hai, toh
#  tum S ko kahin bhi use kar sakte ho jahan T expect kiya ja raha
#  hai — bina program ke behavior ya logic ko tode.
#
#  Child class parent ki jagah replace ho saki bina kisi issue ke.
#  Client code ko farak nahi padna chahiye ki konsa subtype hai.
#  Sab kuch "just work" karna chahiye.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Problem: ReadOnlyDocument ne save() override karke exception
#    throw kiya. Client crash ho gaya. Parent ki jagah child substitute
#    nahi ho saki.
#  - LSP = "Child class parent ki jagah use ho saki bina program ke
#    tode. Subtype bas type ki expectations honor kare."
#  - Warning sign: Method override karke exception throw karna ya
#    client code mein type check (instanceof) lagana.
#
#  Next part mein: LSP kyun zaroori hai aur iske fayde.
#
# ============================================================
