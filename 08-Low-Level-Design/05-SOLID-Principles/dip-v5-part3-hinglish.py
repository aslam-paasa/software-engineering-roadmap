# ============================================================
#  DEPENDENCY INVERSION PRINCIPLE (DIP) — Part-3 (Tech Example)
#  Topic: DIP ko code mein kaise lagayein? (Step-by-Step)
# ============================================================
#
#  Ab apne LoginService (dimaag) ko DIP use karke fix karte hain.
#  Scratch se step-by-step code likhte hain.
#
# ============================================================
#
#  Step 1: Contract (Interface) Banao
#  ----------------------------------
#  Sabse pehle ek "Contract" banao. Yeh batata hai ki koi bhi
#  database tool ko kya karna chahiye. Ismein ek method hoga:
#  get_user. Yeh contract interface hai jo dono (LoginService aur
#  Database) ko malum hoga.
#
#  from abc import ABC, abstractmethod
#
#  class DatabaseInterface(ABC):  # Yeh contract hai
#      @abstractmethod
#      def get_user(self, email):
#          pass
#
#  ============================================================
#
#  Step 2: Tools (Databases) banao jo Contract ko follow karein
#  -------------------------------------------------------
#  Ab apne asli databases (MySQL, MongoDB) banao. Yeh databases
#  contract (DatabaseInterface) ko implement karenge. Yeh apne tarike
#  se data laayenge, par contract wahi rakhenge.
#
#  class MySQLDatabase(DatabaseInterface):  # MySQL ne contract follow kiya
#      def get_user(self, email):
#          print(f"Connecting to MySQL...")
#          return {"email": email, "password": "1234"}
#
#  class MongoDBDatabase(DatabaseInterface):  # MongoDB ne contract follow kiya
#      def get_user(self, email):
#          print(f"Connecting to MongoDB...")
#          return {"email": email, "password": "1234"}
#
#  ============================================================
#
#  Step 3: Dimaag (LoginService) ko Contract pe depend karo
#  -------------------------------------------------------
#  Ab LoginService MySQLDatabase ya MongoDBDatabase ko nahi jaanta.
#  Woh sirf DatabaseInterface (contract) ko jaanta hai. Asli database
#  bahar se milega (Dependency Injection).
#
#  class LoginService:
#      def __init__(self, db: DatabaseInterface):
#          self.db = db  # Bahar se mila (Injected)
#
#      def login(self, email, password):
#          user = self.db.get_user(email)  # Contract ka use
#          if user["password"] == password:
#              print("Login Successful!")
#          else:
#              print("Wrong password!")
#
#  LoginService ab databases se totally azad hai.
#
#  ============================================================
#
#  Step 4: Application mein Use Karo
#  ---------------------------------
#  Main method mein tum decide karte ho kaunsa database use karna hai.
#
#  # MySQL use karna ho toh:
#  mysql_login = LoginService(MySQLDatabase())
#  mysql_login.login("test@example.com", "1234")
#
#  # MongoDB use karna ho toh (bina LoginService change kiye):
#  mongo_login = LoginService(MongoDBDatabase())
#  mongo_login.login("test@example.com", "1234")
#
#  Dekho magic! Database change karne ke liye LoginService ka ek
#  line bhi change nahi karna pada. Bas nayi database class pass
#  kar di. Agar Postgres add karna ho, toh bas PostgresDatabase banao
#  jo DatabaseInterface ko implement kare, aur pass kar do.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Step 1: Contract (DatabaseInterface) banao.
#  - Step 2: Databases (MySQL, MongoDB) contract ko implement karein.
#  - Step 3: LoginService sirf contract pe depend kare. Asli database
#    bahar se aaye (Dependency Injection).
#  - Step 4: App mein decide karo kaunsa database use karna hai. DB
#    change karo, LoginService safe.
#
#  Next part mein: DIP apply karte waqt common galtiyan.
#
# ============================================================
