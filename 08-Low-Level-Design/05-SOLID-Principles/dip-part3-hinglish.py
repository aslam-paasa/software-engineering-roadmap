# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-3
#  Topic: DIP ko code mein kaise lagayein?
# ============================================================
#
#  Ab apne EmailService ko DIP use karke fix karte hain. Strategy:
#  Ek interface (contract) banao, aur usko use karo.
#
# ============================================================
#
#  Step 1: Abstraction (Interface) Banao
#  --------------------------------------
#  Ek EmailClient interface banao. Yeh batata hai ki koi bhi email
#  sender ko kya karna chahiye (send_email method).
#
#  from abc import ABC, abstractmethod
#
#  class EmailClient(ABC):
#      @abstractmethod
#      def send_email(self, to, subject, body):
#          pass
#
#  ============================================================
#
#  Step 2: Concrete Implementations banao
#  --------------------------------------
#  Ab Gmail aur Outlook wale classes is interface ko implement karenge.
#  Yeh apne provider ka kaam khud karenge, par contract wahi rakhenge.
#
#  class GmailClientImpl(EmailClient):
#      def send_email(self, to, subject, body):
#          print(f"Sending via Gmail to {to}: {subject}")
#
#  class OutlookClientImpl(EmailClient):
#      def send_email(self, to, subject, body):
#          print(f"Sending via Outlook to {to}: {subject}")
#
#  ============================================================
#
#  Step 3: High-Level Module ko Update karo
#  -----------------------------------------
#  Ab EmailService GmailClient ya OutlookClient ko nahi jaanta. Woh
#  sirf EmailClient interface ko jaanta hai. Asli object bahar se
#  inject hoga (Dependency Injection).
#
#  class EmailService:
#      def __init__(self, email_client: EmailClient):
#          self.email_client = email_client  # Bahar se mila (Injected)
#
#      def send_welcome_email(self, user_email, user_name):
#          self.email_client.send_email(user_email, "Welcome", "Hi")
#
#  EmailService ab concrete classes se totally decoupled hai.
#
#  ============================================================
#
#  Step 4: Application mein Use Karo
#  ---------------------------------
#  Main method (ya DI framework) mein tum decide karte ho kaunsa
#  implementation use karna hai. Yahan "wiring" hoti hai.
#
#  # Gmail use karna ho toh:
#  gmail_service = EmailService(GmailClientImpl())
#  gmail_service.send_welcome_email("test@example.com", "Alice")
#
#  # Outlook use karna ho toh (bina EmailService change kiye):
#  outlook_service = EmailService(OutlookClientImpl())
#  outlook_service.send_welcome_email("test@example.com", "Alice")
#
#  Dekho magic! Provider change karne ke liye EmailService ka ek
#  line bhi change nahi karna pada. Bas nayi class pass kar di.
#  Agar Amazon SES add karna ho, toh bas SesClientImpl banao aur
#  pass kar do.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Interface banao (EmailClient) jo bataye kya karna hai.
#  - Implementations (GmailClientImpl, OutlookClientImpl) is interface
#    ko implement karein.
#  - EmailService sirf EmailClient interface pe depend kare. Concrete
#    class pe nahi.
#  - Object bahar se inject karo (Dependency Injection).
#  - Switch karna easy: Bas nayi class pass karo, business logic safe.
#
#  Next part mein: DIP apply karte waqt common galtiyan.
#
# ============================================================
