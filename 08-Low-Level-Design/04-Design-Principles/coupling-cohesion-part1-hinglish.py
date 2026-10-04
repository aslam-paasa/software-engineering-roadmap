# ============================================================
#  COUPLING & COHESION (Part-1) — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Jab tum system design karte ho, toh tum sirf yeh decide nahi
#  karte ki kaunsi class banani hai. Tum yeh bhi decide karte ho
#  ki classes ek dusre pe kaise depend karti hain aur unke paas
#  kaunsi zimmedari (responsibility) hai.
#
#  Yeh do cheezein decide karti hain ki code change karna aasaan
#  hai ya mushkil, bugs kitni jaldi failte hain, aur system kitna
#  testable hai. Iske liye do concepts hain: Coupling aur Cohesion.
#
#  Aaj pehle COHESION samajhte hain.
#
# ============================================================
#
#  1. COHESION kya hai? (Ekdam simple mein)
#  --------------------------------------------
#  Cohesion measure karta hai ki ek module (jaise class) ke andar
#  ki zimmedariyan kitni closely related aur focused hain. Yeh ek
#  module ki "internal" quality hai.
#
#  Simple Analogy:
#  > Soch ek Swiss Army Knife (chaku jisme bahut tools hain) aur
#  > ek proper Chef's Knife (ranna wala chaku). Swiss Army Knife
#  > mein knife, screwdriver, scissors sab hai — yeh kam focused
#  > (low cohesion) hai. Chef's Knife sirf kaatne ke liye bana
#  > hai — yeh bahut focused (high cohesion) hai.
#
#  ------------------------------------------------------------
#  High Cohesion vs Low Cohesion
#  ------------------------------------------------------------
#  HIGH COHESION (Yehi goal hai):
#  - Ek class ek kaam karti hai aur usko bahut achi tarah karti hai.
#  - Jaise LocalDate class. Sirf date represent karti hai. File
#    I/O ya network se koi lena dena nahi.
#
#  LOW COHESION (Yeh galat hai):
#  - Ek class bahut saare unrelated kaam karti hai. Isko "Junk
#    Drawer" (kabaad ke dabbe) ya "God Class" bolte hain.
#  - Jaise ek Manager class jo user authentication bhi kare, DB
#    se connect bhi kare, XML parse bhi kare, email bhi bhej de.
#    Sab kuch ek jagah. Bada mess.
#
#  Pehchaan ka simple tareeka: Class ka kaam ek line mein bina
#  "and" use kiye batana. Agar nahi bata sakte, toh low cohesion hai.
#
#  ------------------------------------------------------------
#  Cohesion Spectrum (Cohesion ke types)
#  ------------------------------------------------------------
#  Cohesion sirf "good" ya "bad" nahi hota. Yeh ek spectrum hai —
#  worst se best tak. Samajhne ke liye types dekhte hain:
#
#  1. Coincidental (Sabse kharab):
#     Elements ka koi meaning relation nahi. Bas aise hi group kar
#     diye. Example: Utils class jisme formatDate(), sendEmail(),
#     aur calculateTax() sab ek saath pade hain.
#
#  2. Logical (Thoda behtar, par still kharab):
#     Similar type ke operations ek jagah. Example: Saare "input"
#     operations ek class mein (file, keyboard, network se input).
#     Kaam similar hai, par unrelated classes.
#
#  3. Temporal (Waqt ke hisaab se):
#     Elements isliye group hain kyunki ek hi waqt hote hain.
#     Example: Startup class jisme initializeDatabase(), loadConfig(),
#     startLogger() hain. Program shuru hota waqt teeno chalte hain.
#
#  4. Procedural (Sequence ke hisaab se):
#     Elements ek sequence mein hote hain. Example: Step 1 data laata
#     hai, Step 2 process karta hai, Step 3 save karta hai.
#
#  5. Communicational (Same data pe kaam):
#     Elements same data pe operate karte hain. Example: Ek class
#     customer record padhti hai aur phir usko display ke liye
#     format karti hai.
#
#  6. Sequential (Output input banta hai):
#     Ek element ka output dusre ka input. Example: readFile()
#     ka data parseData() ko milta hai, phir validateData() ko.
#
#  7. Functional (Sabse best — yehi aim chahiye):
#     Har element ek hi well-defined task ko support karta hai.
#     Example: PasswordHasher class jiska sirf kaam password hash
#     karna aur verify karna hai. Saara focus ek cheez pe.
#
#  Hamesha FUNCTIONAL cohesion ka aim karo.
#
# ============================================================
#
#  2. Example — Low vs High Cohesion
#  ---------------------------------
#  Ek OrderManager class dekhte hain jo sab kuch kar raha hai.
#
#  Before (Low Cohesion):
#  class OrderManager:
#      def process_order(self, order):
#          # 1. Business Logic (Validation)
#          if not order.get_items():
#              print("Order must have at least one item.")
#              return
#          # 2. Persistence (Database Interaction)
#          conn = sqlite3.connect("...")
#          # ... DB save code ...
#          conn.close()
#          # 3. Notification (Email)
#          # ... smtplib email code ...
#          print("Email sent")
#
#  Problem kya hai? Yeh class 3 alag kaam kar raha hai. Agar email
#  logic change karoge, toh DB wale code ke paas jaana padega.
#  Validation test karne ke liye DB aur Email server mock karna
#  padega. Reuse karna mushkil hai.
#
#  After (High Cohesion — 3 classes mein todo):
#  Ab in concerns ko 3 specialized classes mein tod dete hain.
#
#  1. OrderService (Business Logic):
#     Sirf business rules enforce karega.
#     class OrderService:
#         def __init__(self, repo, notifier):
#             self._repo = repo
#             self._notifier = notifier
#
#         def process_order(self, order):
#             if not order.get_items():
#                 raise ValueError("Order must have at least one item.")
#             self._repo.save(order)
#             self._notifier.send_order_confirmation(order)
#
#  2. OrderRepository (Persistence):
#     Sirf data access (DB) ka kaam karega.
#     class OrderRepository:
#         def save(self, order):
#             # ... DB save code ...
#             print(f"Saving order {order.get_id()} to DB.")
#
#  3. EmailNotificationService (Notification):
#     Sirf email bhejne ka kaam.
#     class EmailNotificationService:
#         def send_order_confirmation(self, order):
#             # ... email code ...
#             print(f"Email sent to {order.get_customer_email()}")
#
#  Ab dekho: Har class ka ek hi clear purpose hai. Bina "and"
#  use kiye ek line mein describe kar sakte ho. Inhe akele test
#  karna easy hai. Maintain karna easy hai. Yahi high cohesion hai.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - Cohesion = Ek class ke andar ki zimmedariyan kitni focused
#    aur related hain. (Internal quality)
#  - High Cohesion (Goal): Ek class, ek kaam. (Jaise Chef's Knife)
#  - Low Cohesion (Problem): God Class / Junk Drawer. Sab kuch ek
#    class mein. (Jaise Swiss Army Knife)
#  - Pehchaan: Class ka kaam ek line mein bina "and" use kiye
#    batana. Agar nahi bata sakte, toh low cohesion hai.
#  - Spectrum (Worst to Best): Coincidental -> Logical -> Temporal
#    -> Procedural -> Communicational -> Sequential -> Functional.
#  - Hamesha Functional Cohesion ka aim karo. Har field aur method
#    ek hi clear purpose ko support kare.
#  - Faida: Test karna easy, maintain karna easy, reuse karna easy.
#
#  Ek line mein: Cohesion = "Ek class, ek kaam. Apne kaam pe focus
#  karo, dusre kaam ko andar mat ghusne do."
#
# ============================================================
