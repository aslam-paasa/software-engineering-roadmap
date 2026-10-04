# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-1
#  Topic: Problem aur LSP ka matlab
# ============================================================
#
#  Ek simple sawaal: Tumne parent class ka object expect karne
#  wale method mein child class ka object daala, aur program crash
#  ho gaya ya galat behave kiya?
#
#  Agar haan, toh tumne LSP tod diya. Chalo bilkul aasan bhasha
#  mein samajhte hain.
#
# ============================================================
#
#  1. Problem: Document System
#  ----------------------------
#  Tumne ek Document class banayi jisme open() aur save() methods
#  hain. Ab naya requirement aaya: "Sirf padhne wala document
#  chahiye (Read-only)."
#
#  Tumne socha: "Read-only document bhi toh ek Document hi hai.
#  Bas uska save() method override karke exception throw kar dunga."
#
#  class Document:
#      def save(self, new_data):
#          print("Document saved.")
#
#  class ReadOnlyDocument(Document):
#      def save(self, new_data):
#          raise Exception("Cannot save read-only document!")
#
#  Ab problem dekho: Tumhare system mein ek processor hai jo koi
#  bhi Document leta hai aur uspe save() call karta hai.
#  - Normal Document pe save() chala, sab theek.
#  - ReadOnlyDocument pe save() chala, toh CRASH! Exception aaya.
#
#  Client code ka expectation tha ki har Document save ho sakta
#  hai. Par ReadOnlyDocument ne yeh expectation tod di. Yahi LSP
#  violation hai.
#
#  ------------------------------------------------------------
#  Warning Sign (Pehchaan)
#  ------------------------------------------------------------
#  Agar tum kabhi method ko override karke exception throw karte
#  ho, ya client code mein "agar yeh Read-only hai toh yeh kar"
#  jaisa check lagana padta hai — toh samajh lo LSP break ho raha
#  hai.
#
# ============================================================
#
#  2. LSP kya hai?
#  ---------------
#  Barbara Liskov ne 1987 mein kaha:
#  > "Agar Child, Parent ka subtype hai, toh Parent ki jagah Child
#  > use kiya ja sake bina program ke toote."
#
#  Bilkul simple bhasha:
#  > "Bete (child) ko pita (parent) ki jagah bitha do. Sab kuch
#  > waise hi chalna chahiye jaise pita chal raha tha."
#
#  Agar pita ka kaam hai "save karna", aur beta save nahi kar sakta,
#  toh beta parent ki jagah replace nahi ho sakta. Yeh LSP break hai.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Problem: ReadOnlyDocument ne save() override karke exception
#    throw kiya. Program crash ho gaya. Parent ki jagah child replace
#    nahi ho saki.
#  - LSP = "Child class parent ki jagah use ho saki bina program
#    ke tode."
#  - Warning sign: Method override karke exception throw karna ya
#    client code mein type check (instanceof) lagana.
#
#  Next part mein: LSP kyun zaroori hai aur iske fayde.
#
# ============================================================
