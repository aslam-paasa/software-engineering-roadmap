# ============================================================
#  LISKOV SUBSTITUTION PRINCIPLE (LSP) — Part-3
#  Topic: LSP ko code mein kaise theek karein?
# ============================================================
#
#  Problem yeh thi ki base class Document assume kar raha tha ki
#  "saare documents save ho sakte hain". Par Read-only document
#  save nahi ho sakta. Isliye LSP break hua.
#
#  Solution: Read aur Write behavior ko alag karo. Interfaces use
#  karo.
#
# ============================================================
#
#  Step 1: Interfaces Banao (Contract)
#  ------------------------------------
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
#  Step 2: Classes Implement Karo
#  -------------------------------
#  Ab EditableDocument, Editable ko implement karega (read + write).
#  ReadOnlyDocument sirf Document ko implement karega (sirf read).
#
#  class EditableDocument(Editable):
#      def open(self): print("Editable Document opened.")
#      def save(self, new_data): print("Document saved.")
#      def get_data(self): return self.data
#
#  class ReadOnlyDocument(Document):
#      def open(self): print("Read-Only Document opened.")
#      def get_data(self): return self.data
#
#  Ab dekho: ReadOnlyDocument mein save() method hai hi nahi! Woh
#  kabhi save() ka wada hi nahi karta. Toh exception throw karna
#  ka sawaal hi paida nahi hota.
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
#          doc.save(doc.get_data() + additional_info)
#
#  Ab magic dekho: Agar tum ReadOnlyDocument ko process_and_save()
#  mein pass karne ki koshish karoge, toh COMPILER error dega!
#  "ReadOnlyDocument Editable nahi hai." Program run hi nahi hoga.
#  Runtime pe crash nahi hoga. Compile time pe hi pakad liya gaya.
#
#  Yahi hai LSP-compliant design ka asli power: galti run hone se
#  pehle hi pakad mein aa jaati hai.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Problem: Base class assume kar raha tha sab save honge.
#  - Solution: Read aur Write behavior ko interfaces mein alag karo.
#    Editable (save karega) extends Document (sirf read karega).
#  - ReadOnlyDocument sirf Document implement karega. Usme save() hi
#    nahi hai, toh exception throw karne ka sawaal hi nahi.
#  - Client code jo save() karega, woh Editable maangega. ReadOnlyDocument
#    pass karte hi compiler error dega. Runtime crash nahi hoga.
#
#  Next part mein: LSP apply karte waqt common galtiyan.
#
# ============================================================
