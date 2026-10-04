# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-1
#  Topic: Problem aur DIP ka matlab
# ============================================================
#
#  Kabhi database, email provider, ya third-party API change kiya,
#  aur realize hua ki business logic implementation details mein
#  itna uljha hua hai ki ek cheez change karne ke liye aadhi class
#  dobara likhni padi?
#
#  Agar haan, toh tumne DIP tod diya. Chalo aasan bhasha mein
#  samajhte hain.
#
# ============================================================
#
#  1. Problem: Tightly Coupled EmailService
#  -----------------------------------------
#  Tum EmailService bana rahe ho. Pehle Gmail se email bhejna tha.
#  Tumne GmailClient (low-level) banaya aur EmailService (high-level)
#  mein uska object khud bana liya.
#
#  class GmailClient:
#      def send_gmail(self, to, subject, body):
#          print("Sending via Gmail...")
#
#  class EmailService:
#      def __init__(self):
#          self.gmail_client = GmailClient()  # Khud bana liya!
#
#      def send_welcome_email(self, user_email):
#          self.gmail_client.send_gmail(user_email, "Welcome", "Hi")
#
#  Pehli nazar mein theek lagta hai. Par ek din manager bola:
#  "Gmail ki jagah Outlook use karo."
#  Problem! EmailService (business logic) GmailClient (implementation)
#  pe tightly depend karta hai. Switch karne ke liye:
#  - EmailService ko rewrite karo.
#  - gmail_client ki jagah outlook_client likho.
#  - Constructor change karo.
#  Agar 5 providers hote, toh EmailService ek bada if-else soup ban
#  jaata.
#
# ============================================================
#
#  2. DIP kya hai?
#  ---------------
#  Robert C. Martin (Uncle Bob) ne 2 rules diye:
#  1. High-level modules (business logic) low-level modules
#     (implementations) pe depend nahi karte. Dono abstractions
#     (interfaces) pe depend karte hain.
#  2. Abstractions details pe depend nahi karte. Details (concrete
#     classes) abstractions pe depend karte hain.
#
#  Simple bhasha:
#  > "Business logic ko farak nahi padna chahiye ki kaunsa tool use
#  > ho raha hai. Dono (business logic aur tool) ek common interface
#  > pe depend karein."
#
#  "Inverted" kya hua?
#  Pehle: High-level module low-level pe depend karta tha.
#    (EmailService -> GmailClient)
#  Ab: Dono interface pe depend karte hain.
#    (EmailService -> EmailClient Interface <- GmailClient)
#  Dependency ka direction ulat (invert) gaya.
#
#  ------------------------------------------------------------
#  Real-Life Analogy — Plug aur Socket
#  ------------------------------------------------------------
#  Soch ek electric socket. Tumhari gaadi (high-level) socket se
#  charge hoti hai. Socket ka design (interface) fix hai. Tum kabhi
#  power company (low-level) change karo (grid to solar), gaadi ko
#  farak nahi padta. Bas socket (interface) same rehna chahiye.
#  Agar gaadi seedha power company ke wire se juddi hoti, toh company
#  badalne pe gaadi ka wire bhi change karna padta.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Problem: EmailService GmailClient pe tightly juda hai. Provider
#    change karne ke liye business logic (EmailService) change karna
#    padta hai.
#  - DIP = "High-level aur low-level, dono abstractions (interfaces)
#    pe depend karein. Direct ek dusre pe nahi."
#  - Dependency direction invert ho jaati hai.
#  - Analogy: Gaadi aur socket. Socket (interface) fix, power company
#    (implementation) change ho sakti hai.
#
#  Next part mein: DIP kyun zaroori hai aur iske fayde.
#
# ============================================================
