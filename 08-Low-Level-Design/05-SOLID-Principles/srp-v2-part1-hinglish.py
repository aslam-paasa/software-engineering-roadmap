# ============================================================
#  SINGLE RESPONSIBILITY PRINCIPLE (SRP) — Part-1
#  Topic: God Class aur SRP ka matlab
# ============================================================
#
#  Kabhi aisa hua ki tumne code ka ek chhota sa hissa badla, aur
#  achanak 5 alag-alag cheezein toot gayi?
#  Ya ek chhota feature add kiya, aur ek hi class ke 100 lines
#  edit karne pade?
#
#  Agar haan, toh tumne SRP tod diya. Chalo aasan bhasha mein
#  samajhte hain.
#
# ============================================================
#
#  1. Problem: The God Class (Sab kuch karne wali class)
#  ------------------------------------------------------
#  Tumne ek UserService class banayi. Isme username, email aur
#  password hai. Par is class ne sirf user ka data hold nahi kiya,
#  isne 4 alag-2 kaam bhi kar liye:
#  1. Password validate aur hash kiya.
#  2. Data ko DB mein save kiya.
#  3. Auth token (JWT) banaya.
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
#  class ke 4 alag reasons to change (badalne ka karan) hain:
#  - Password ka rule badla (bcrypt to argon2) -> class change.
#  - Token ka format badla -> class change.
#  - Database ka schema badla -> class change.
#  - Email provider badla -> class change.
#
#  Ek hi class 4 alag cheezon se judi hai. Yeh ek "God Class" hai
#  jo sab kuch karne ki koshish karti hai, par kuch bhi achhe se
#  nahi karti.
#
# ============================================================
#
#  2. SRP kya hai?
#  ---------------
#  Robert C. Martin (Uncle Bob) ne kaha:
#  > "A class should have one, and only one, reason to change."
#  (Ek class ka badalne ka sirf ek hi reason hona chahiye.)
#
#  Simple bhasha: Ek class ek kaam kare, aur woh achhe se kare.
#  SRP SOLID principles ka "S" hai.
#
#  Responsibility (zimmedari) kya hai?
#  Yeh koi method nahi hai. Yeh "reason to change" hai.
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
#  - Responsibility = reason to change. Kitne karon se class badlegi?
#  - Analogy: Restaurant mein Chef, Waiter, Cleaner, Accountant sab
#    alag hote hain.
#
#  Next part mein: SRP ke fayde kya hain?
#
# ============================================================
