# ============================================================
#  SINGLE RESPONSIBILITY PRINCIPLE (SRP) — Part-1
#  Topic: Problem (God Class) aur SRP kya hai
# ============================================================
#
#  Kabhi code ka ek hissa change kiya, aur 5 unrelated cheezein
#  toot gayi? Ya chhota sa feature add kiya, aur ek hi class ke
#  bahut saare lines edit karne pade?
#
#  Agar haan, toh tumne Single Responsibility Principle (SRP)
#  tod diya. Chalo isko aasan bhasha mein samajhte hain.
#
# ============================================================
#
#  1. Problem: The God Class (Sab kuch karte wali class)
#  -------------------------------------------------------
#  Tumne ek UserService class banayi. Isme username, email aur
#  password hai. Par isne sirf user ka data hold nahi kiya, isne
#  4 alag-alag kaam bhi kar liye:
#  1. Password validate aur hash kiya.
#  2. DB mein data save kiya.
#  3. Auth token (JWT) generate kiya.
#  4. Welcome email bheja.
#
#  class UserService:
#      def __init__(self, username, email, password): ...
#      def validate_and_hash_password(self): ...
#      def save_to_database(self): ...
#      def generate_auth_token(self): ...
#      def send_welcome_email(self): ...
#
#  Pehli nazar mein easy lagta hai — sab kuch ek jagah. Par is
#  class ke 4 alag-alag "reasons to change" (badhne ka reason) hain:
#  - Password hashing rule badla (bcrypt to argon2) -> class change.
#  - Token format badla (JWT to opaque) -> class change.
#  - Database schema badla -> class change.
#  - Email provider badla -> class change.
#
#  Ek class 4 alag cheezon se jude hai. Yeh ek God Class hai jo
#  sab kuch karne ki koshish karti hai, par kuch bhi achhe se nahi
#  karti.
#
# ============================================================
#
#  2. SRP kya hai? (Simple mein)
#  ------------------------------
#  Robert C. Martin (Uncle Bob) ne kaha:
#  > "A class should have one, and only one, reason to change."
#  (Ek class ka badalne ka ek hi, aur sirf ek, reason hona chahiye.)
#
#  Simple bhasha mein: Ek class ek kaam kare, aur woh achi tarah kare.
#  SRP SOLID principles ka "S" hai.
#
#  Responsibility (zimmedari) kya hai?
#  Yeh method ya function nahi hai. Yeh "reason to change" hai.
#  Apne aap se poocho: "Future mein koi is class ko update karne ka
#  kitna reason ho sakta hai?" Agar jawab 1 se zyada hai, toh class
#  SRP break kar rahi hai.
#
#  ------------------------------------------------------------
#  Real-Life Analogy — Restaurant
#  ------------------------------------------------------------
#  Ek restaurant mein kya tum ek hi aadmi se sab karwaoge?
#  - Khana banana
#  - Order lena
#  - Table saaf karna
#  - Hisaab karna
#  Nahi! Tum ek Chef, ek Waiter, ek Cleaner, ek Accountant rakho
#  ge. Har kisi ki ek zimmedari. Code kyun alag hona chahiye?
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - God Class = jo sab kuch karne ki koshish kare (password, DB,
#    email, token sab ek class mein). Iske 4 reasons to change hote
#    hain, jo galat hai.
#  - SRP = "Ek class ka badalne ka ek hi reason hona chahiye."
#  - Responsibility = reason to change. Kitne kaaron se class badlegi?
#  - Analogy: Restaurant mein Chef, Waiter, Cleaner, Accountant sab
#    alag hote hain.
#
#  Next part mein: SRP kyun zaroori hai aur iske fayde.
#
# ============================================================
