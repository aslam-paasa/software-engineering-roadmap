# ============================================================
#  DRY PRINCIPLE — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Kya tumne kabhi ek hi validation logic (jaise email check karna)
#  alag-alag files mein copy-paste kiya hai? Ya koi business rule ek
#  jagah badla aur doosri jagah bhool gaye?
#
#  Agar haan, toh tumne DRY principle tod diya. DRY ka matlab hai
#  "Don't Repeat Yourself" — apne aap ko dohrana mat.
#
# ============================================================
#
#  1. DRY Principle kya hai? (Simple mein)
#  -------------------------------------
#  DRY kahta hai ki system mein har piece of knowledge (jaankari)
#  ki ek hi single, clear jagah honi chahiye. Jab tumhe woh jaankari
#  kahin aur chahiye, toh dusri copy banaane ke bajaye us single
#  jagah ko reference karo.
#
#  Simple Analogy:
#  > Tumhare paas ek diary hai jisme tumhare saare contacts likhe
#  > hain. Agar tum kisi ko call karna ho, toh tum dusri diary
#  > nahi banate, usi ek diary mein dekh kar call karte ho. Agar
#  > number badle, toh sirf ek jagah update karna padta hai. Yahi
#  > DRY hai.
#
#  Dhyan rakhna — yahan "knowledge" (jaankari) shabd use hua hai,
#  "code" nahi. DRY sirf duplicate lines of code ke baare mein
#  nahi hai. Yeh in sab pe apply hota hai:
#  - Business rules: "User 18 saal ke hon" yeh rule ek baar likho,
#    5 jagah nahi.
#  - Configuration: DB password, API keys ek config file mein rakho,
#    har class mein bichhara mat karo.
#  - Data models: User ka structure ek baar define karo.
#  - Tests: Shared setup logic (jaise test user banana) copy-paste
#    mat karo, helper mein nikal do.
#
#  Agar ek hi concept do jagah appear hota hai, toh redundancy aati
#  hai. Isse system maintain karna mushkil hota hai aur bugs aate
#  hain.
#
#  ------------------------------------------------------------
#  Rule of Three (Teen ka Niyam)
#  ------------------------------------------------------------
#  Code ko bahut jaldi extract (shared) mat karo. Pehle ek pattern
#  ko TEEN baar hone do. Agar sirf do baar hua, toh shayad
#  coincidence hai. Par teen baar hone ke baad samajh lo ki yeh
#  ek pattern hai. Tab usko ek jagah extract karo. Jaldi matti
#  uthaana.
#
# ============================================================
#
#  2. Real-World Example — Email Validation
#  -----------------------------------------
#  Maan lo tumhare 3 modules hain: Auth, Payment, Messaging. Teeno
#  mein email validate karne ka same logic likha hai.
#
#  # In auth_service.py
#  def is_valid_email(email):
#      return email is not None and "@" in email and "." in email
#
#  # In payment_service.py
#  def is_valid_email(email):
#      return email is not None and "@" in email and "." in email
#
#  # In messaging_service.py
#  def is_valid_email(email):
#      return email is not None and "@" in email and "." in email
#
#  Ab business ne rule badla: Email mein ".com" ya ".org" hona
#  chahiye.
#  Ab tumhe teeno jagah update karna padega. Ek bhool gaye, toh
#  Auth mein email accept ho jaayega par Payment mein fail ho jaayega
#  user. Inconsistent system. Technical debt badhti jaayegi.
#
# ============================================================
#
#  3. Repetition (Dohrana) kyun problem hai?
#  ------------------------------------------
#  Chhoti projects mein theek lagta hai, par bade codebase mein yeh
#  4 problems aati hain:
#
#  1. Maintain karna mushkil: Rule change hua, toh har jagah dhundh
#     ke update karo. 500 files mein yaad nahi rahega. Ek miss kiya
#     toh bug.
#  2. Bugs ka risk: Copy karte waqt koi null check bhool gaya. Ek
#     module crash, baaki theek. Bug tab dikhega jab production mein
#     null email jaayega us specific module mein.
#  3. Bloated code: Same 10 line 15 files mein hain. Faltu ka noise.
#     Code padhna aur navigate karna mushkil.
#  4. Poor test coverage: Har copy ke liye alag tests likhne padenge.
#     Naya rule add hua, toh teeno test files update karna padega.
#     Log aksar 1-2 update karte hain, teesri bhool jaate hain.
#
#  Copy-Paste ek Red Flag (warning sign) hai. Apne aap se poocho:
#  > "Agar future mein yeh logic change karna padha, toh kya main
#  > saari jagah yaad rakh paunga?" Agar jawab nahi hai, toh risk
#  > badh raha hai.
#
# ============================================================
#
#  4. DRY kaise lagayein? (Email Example ka solution)
#  ---------------------------------------------------
#  Common logic ko ek single shared jagah pe extract karo.
#
#  Step 1: Ek Utility Class banao (Single source of truth)
#
#  class EmailValidator:
#      @staticmethod
#      def is_valid(email):
#          return (
#              email is not None
#              and "@" in email
#              and "." in email
#              and (email.endswith(".com") or email.endswith(".org"))
#          )
#
#  Step 2: Har module ko is shared validator ko use karne do
#
#  # In auth_service.py
#  if EmailValidator.is_valid(user.email):
#      # authentication aage badhao
#
#  # In payment_service.py
#  if EmailValidator.is_valid(customer.email):
#      # payment process karo
#
#  Ab email validation ki logic ek hi jagah hai. Future mein koi
#  badlav (regex add karna ya naya domain support karna), sirf ek
#  jagah karna hai. Teeno modules apne aap consistent reh jaayenge.
#
# ============================================================
#
#  5. Kab Repeat Karna Theek Hai?
#  ------------------------------
#  DRY ek guideline hai, strict rule nahi. Kabhi-kabhi thodi
#  repetition behtar hoti hai.
#
#  1. Jaldi abstraction mat banao (Premature Abstraction)
#     Code ko pehle duplicate hone do. Agar pattern clear nahi hai,
#     toh jaldi extract karna mushkil ho sakta hai. Galat abstraction
#     duplication se bhi mehengi padti hai.
#
#  2. Tests ko readable rakho
#     Tests akele padhne mein samajh aane chahiye. Agar tum test ke
#     setup ko helper mein nikal doge, toh padhne wale ko kahin aur
#     dekhna padega. Tests mein thodi repetition clarity ke liye
#   theek hai.
#
#  3. Simple cheezein
#     Agar code bahut simple hai (jaise x + 1), toh uske liye
#     utility method banana overengineering hai. `MathUtils.add(x, 1)`
#     likhne se achha hai `x + 1` hi likho.
#
# ============================================================
#
#  6. Practical Example — Notification System
#  -----------------------------------------
#  Maan lo 3 services hain: OrderService, ShippingService,
#  SupportService. Teeno ko user ko notification bhejni hai. Har
#  service mein message format karne aur bhejne ka same logic copy
#  paste tha.
#
#  Before (DRY Violation):
#  class OrderService:
#      def notify_order_confirmation(self, user_id, order_id):
#          message = f"[Order] Hi {user_id}, your order {order_id} confirmed."
#          formatted = message[0].upper() + message[1:]
#          print("Connecting to notification API...")
#          print(f"Sending to {user_id}: {formatted}")
#          print("Notification sent successfully.")
#
#  # ShippingService aur SupportService mein bhi same hi logic
#  # copy-paste tha.
#
#  After (DRY Applied):
#  # Do focused classes banayi — ek formatting ke liye, ek sending ke liye.
#  class MessageFormatter:
#      @staticmethod
#      def format(category, user_id, detail):
#          message = f"[{category}] Hi {user_id}, {detail}"
#          return message[0].upper() + message[1:]
#
#  class NotificationSender:
#      @staticmethod
#      def send(user_id, message):
#          print("Connecting to notification API...")
#          print(f"Sending to {user_id}: {message}")
#          print("Notification sent successfully.")
#
#  class OrderService:
#      def notify_order_confirmation(self, user_id, order_id):
#          message = MessageFormatter.format(
#              "Order", user_id, f"your order {order_id} has been confirmed.")
#          NotificationSender.send(user_id, message)
#
#  # ShippingService aur SupportService bhi same MessageFormatter
#  # aur NotificationSender ko use karenge apne apne detail ke saath.
#
#  ------------------------------------------------------------
#  Yeh design kyun sahi hai?
#  ------------------------------------------------------------
#  - Single source of truth: Formatting badalni ho toh
#    MessageFormatter update karo. Sending ka API change hua toh
#    NotificationSender update karo. Ek jagah.
#  - Har service apne kaam pe focused: OrderService sirf order
#    jaanti hai. Usse formatting/sending ke baare mein nahi pata.
#  - Test karna easy: MessageFormatter aur NotificationSender ko
#    akele test kar sakte ho.
#  - Extend karna easy: Naya BillingService add karo, bina existing
#    code change kiye usko format aur send use karne do.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - DRY = "Don't Repeat Yourself." Ek hi knowledge system mein ek
#    hi jagah honi chahiye. Copy-paste mat karo.
#  - Yeh sirf code nahi, business rules, config, data models, tests
#    sab pe apply hota hai.
#  - Repetition se: Maintain mushkil, zyada bugs, bloated code, aur
#    poor test coverage.
#  - Solution: Common logic ko ek jagah extract karo (utility class,
#    shared method) aur sab jagah usko reference karo.
#  - Rule of Three: 3 baar duplicate hone par extract karo, pehle
#    nahi.
#  - Kab repeat theek hai: Jaldi abstraction na banao, tests readable
#    rakho, simple cheezon ke liye over-engineering mat karo.
#
#  Ek line mein: DRY = "Ek hi cheez 2 jagah mat likho. Ek baar likho,
#  kahin bhi use karo." Isse code maintain karna aasaan, bugs kam,
#  aur life peaceful.
#
# ============================================================
