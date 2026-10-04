# ============================================================
#  SINGLE RESPONSIBILITY PRINCIPLE (SRP) — Part-3
#  Topic: SRP ko code mein kaise lagayein?
# ============================================================
#
#  Ab hum apni UserService God Class ko fix karenge using SRP.
#  Har zimmedari ko apni class mein nikalenge.
#
# ============================================================
#
#  1. User Class (Core Data)
#  --------------------------
#  Pehle simple User class banao. Iska sirf ek kaam: user represent
#  karna. Yeh password hash nahi karega, save nahi karega, email
#  nahi bhejega.
#
#  class User:
#      def __init__(self, username, email, password):
#          self._username = username
#          self._email = email
#          self._password = password
#
#  ============================================================
#
#  2. Password Hashing
#  --------------------
#  Yeh class sirf password validate aur hash karegi.
#
#  class PasswordHasher:
#      def validate_and_hash(self, password: str) -> str:
#          if len(password) < 8:
#              raise ValueError("Password must be 8+ chars")
#          return "bcrypt_hashed_" + password  # Simplified
#
#  Agar hashing algorithm badle (bcrypt to argon2), toh sirf yeh
#  class update hogi. Kuch aur nahi.
#
#  ============================================================
#
#  3. Database Persistence
#  -----------------------
#  Yeh class sirf DB se baat karegi, data save karegi.
#
#  class UserRepository:
#      def save(self, user: User):
#          print(f"Saving user {user.get_username()} to database...")
#
#  Tum SQL se NoSQL pe switch karo, sirf yeh class change hogi.
#
#  ============================================================
#
#  4. Auth Token Generation
#  -------------------------
#  Yeh class sirf tokens (JWT) banayegi.
#
#  class AuthTokenService:
#      def generate_token(self, user: User) -> str:
#          payload = f'{{"username":"{user.get_username()}"}}'
#          return f"token_header.{payload}.signature"
#
#  Tum JWT se opaque tokens pe switch karo, sirf yeh class touch hogi.
#  Password hashing aur email se koi lena dena nahi.
#
#  ============================================================
#
#  5. Welcome Email
#  ----------------
#  Yeh class sirf email bhejne ka kaam karegi.
#
#  class EmailService:
#      def send_welcome_email(self, user: User):
#          print(f"Sending welcome email to: {user.get_email()}")
#
#  SMTP se API pe switch karo, sirf yeh class update hogi.
#
#  ------------------------------------------------------------
#  Result:
#  ------------------------------------------------------------
#  Ab 1 God Class ki jagah 5 focused classes hain. Har class ka
#  ek hi reason to change hai. Test karna easy. Reuse karna easy.
#  Maintain karna easy. Yahi SRP in action hai.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - God Class ko todo aur har zimmedari ko apni class do.
#  - User (data), PasswordHasher, UserRepository (DB), AuthTokenService
#    (tokens), EmailService (email) — sab alag classes.
#  - Ek class change karo, dusri pe asar nahi padta.
#
#  Next part mein: SRP apply karte waqt common galtiyan.
#
# ============================================================
