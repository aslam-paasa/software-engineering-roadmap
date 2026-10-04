# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-3
#  Topic: LSP ko code mein kaise theek karein? (Refactoring)
# ============================================================
#
#  Problem yeh thi ki base class Document assume kar raha tha ki
#  "saare documents save ho sakte hain". Par Read-only document
#  save nahi ho sakta. Isliye LSP break hua.
#
#  Solution: Editable aur Read-only behavior ko alag karo. Interfaces
#  use karo.
#
# ============================================================
#
#  Step 1: Interfaces Define Karo
#  -------------------------------
#  Document interface sirf read-only access deta hai (open aur
#  get_data). Editable interface Document ko extend karta hai aur
#  save method add karta hai.
#
#  from abc import ABC, abstractmethod
#
#  class Document(ABC):
#      @abstractmethod
#      def open(self): pass
#      @abstractmethod
#      def get_data(self): pass
#
#  class Editable(Document):
#      @abstractmethod
#      def save(self, new_data): pass
#
#  ============================================================
#
#  Step 2: Concrete Classes Implement Karo
#  ---------------------------------------
#  Ab EditableDocument, Editable ko implement karega (read + write).
#  ReadOnlyDocument sirf Document ko implement karega (sirf read).
#
#  class EditableDocument(Editable):
#      def __init__(self, data): self.data = data
#      def open(self): print("Editable Document opened.")
#      def save(self, new_data):
#          self.data = new_data
#          print("Document saved.")
#      def get_data(self): return self.data
#
#  class ReadOnlyDocument(Document):
#      def __init__(self, data): self.data = data
#      def open(self): print("Read-Only Document opened.")
#      def get_data(self): return self.data
#
#  Ab dekho: ReadOnlyDocument mein save() method hai hi nahi. Woh
#  kabhi save() ka wada hi nahi karta. Toh break kya karega?
#
#  ============================================================
#
#  Step 3: Client Code Update Karo
#  --------------------------------
#  DocumentProcessor ke 2 methods banao:
#  1. process(): Jo koi bhi Document accept karta hai (read only).
#  2. process_and_save(): Jo sirf Editable accept karta hai.
#
#  class DocumentProcessor:
#      def process(self, doc: Document):
#          doc.open()
#          print("Document processed.")
#
#      def process_and_save(self, doc: Editable, additional_info):
#          doc.open()
#          new_data = doc.get_data() + " | " + additional_info
#          doc.save(new_data)
#          print("Document saved.")
#
#  Agar tum ReadOnlyDocument ko process_and_save() mein pass karne ki
#  koshish karoge, toh compiler error dega pehle hi! Kyunki woh
#  Editable nahi hai. Runtime pe exception nahi aayega. Compile time
#  pe hi pakad liya gaya.
#
#  Yahi hai LSP-compliant design ka asli power: correctness compile
#  time pe enforce hoti hai, runtime exceptions pe nahi.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Problem: Base class assume kar raha tha sab save honge.
#  - Solution: Read aur Write behavior ko interfaces mein alag karo.
#    Editable (save karega) extends Document (sirf read karega).
#  - ReadOnlyDocument sirf Document implement karega. Usme save() hi
#    nahi hai.
#  - Client code jo save() karega, woh Editable maangega. ReadOnlyDocument
#    pass karte hi compiler error dega. Runtime crash nahi hoga.
#
#  Next part mein: LSP apply karte waqt common galtiyan.
#
# ============================================================
