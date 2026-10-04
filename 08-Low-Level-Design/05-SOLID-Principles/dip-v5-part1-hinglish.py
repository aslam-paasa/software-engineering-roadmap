# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-1 (Tech Example)
#  Topic: Problem aur DIP ka matlab (Bilkul Scratch se)
# ============================================================
#
#  Chalo isko ek real-world tech example se samajhte hain jo har
#  developer ko pata hai: Login Page aur Database.
#
#  Tum ek app bana rahe ho. User login karta hai. Tumhara "LoginService"
#  (dimaag) user ka password check karta hai. Password check karne ke
#  liye user ka data chahiye, toh tumhe database se baat karni padti
#  hai. Yeh database tool hai (haath).
#
#  ------------------------------------------------------------
#  Problem: LoginService aur MySQL ka direct judna
#  ------------------------------------------------------------
#  Maan lo tumne LoginService ke andar hi MySQL database ka object
#  bana liya (new MySQLDatabase()).
#
#  class MySQLDatabase:
#      def get_user(self, email):
#          print(f"Connecting to MySQL...")
#          return {"email": email, "password": "1234"}
#
#  class LoginService:
#      def __init__(self):
#          self.db = MySQLDatabase()  # Khud MySQL bana liya!
#
#      def login(self, email, password):
#          user = self.db.get_user(email)  # MySQL se data maanga
#          if user["password"] == password:
#              print("Login Successful!")
#          else:
#              print("Wrong password!")
#
#  Pehli nazar mein theek lag raha hai. Login ho raha hai.
#
#  Ab ek din tumhara startup bohot bada ho gaya. Tumne socha: "MySQL
#  slow ho gaya, MongoDB use karte hain."
#  Tum LoginService (dimaag) ke paas gaye. MySQLDatabase nikala,
#  MongoDB daala. LoginService ka code change karna pada. Agar kal
#  ko Postgres chahiye, toh phir change karna padega.
#  LoginService (business logic) database (tool) ke change se itna
#  juda hua ki database badle toh LoginService bhi badalna pade.
#
#  ------------------------------------------------------------
#  Real-World Tech Solution: "Interface" (DIP)
#  ------------------------------------------------------------
#  Acha tareeka kya hai? Tum ek "DatabaseInterface" banao (contract).
#  Ab LoginService sirf DatabaseInterface ko jaanta hai. Woh bolta
#  hai "mujhe user ka data chahiye". Ab DatabaseInterface ke peeche
#  tum MySQL daal do ya MongoDB, LoginService ko farak nahi padta.
#  Bas interface (contract) same rehna chahiye.
#
#  Isko hi DIP kehte hain:
#  > LoginService (high-level) aur Database (low-level), dono ek
#  > Interface (contract) pe depend karein. Direct ek dusre pe nahi.
#
#  "Inverted" kya hua?
#  Pehle: LoginService -> MySQLDatabase (Direct depend)
#  Ab: LoginService -> DatabaseInterface <- MySQLDatabase
#  Ab dono (LoginService aur Database) interface ko dekh rahe hain.
#  Dependency ka direction ulta (invert) ho gaya.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Problem: LoginService ne khud MySQLDatabase bana liya. DB change
#    karne ke liye LoginService ka code change karna pada.
#  - DIP = "LoginService aur Database, dono ek Interface (contract) pe
#    depend karein. Direct ek dusre pe nahi."
#  - Analogy: LoginService (dimaag) aur Database (tool). Tool change
#    karo, dimaag mat chheddo.
#
#  Next part mein: DIP kyun zaroori hai aur iske fayde.
#
# ============================================================
