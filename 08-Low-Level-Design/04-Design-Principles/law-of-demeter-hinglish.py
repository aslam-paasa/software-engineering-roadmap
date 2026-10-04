# ============================================================
#  LAW OF DEMETER (LoD) — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Kabhi kisi object pe method call kiya, phir dusre pe, phir
#  teesre pe... jab tak line dots (.) se bhar na gayi ho?
#  Ya ek class chhota sa change kiya, aur 5 dusri jagah code
#  update karna pada?
#
#  Agar haan, toh tumne Law of Demeter (LoD) tod diya. Chalo isko
#  aasan bhasha mein samajhte hain.
#
# ============================================================
#
#  1. Problem: "Train Wreck" (Dot Chaining)
#  -----------------------------------------
#  Maan lo e-commerce system bana rahe ho. Customer ka Cart hai,
#  Cart mein Items hain, Item mein Product hai, Product ka Price hai.
#  Tumhe pehle product ki price dikhani hai.
#
#  Ek common (galat) tareeka:
#  price = customer.get_shopping_cart().get_items()[0].get_product().get_price()
#
#  Dekho is line ko. Ek object se doosre, phir teesre, phir chauthre
#  tak pohoch gaye. Isko "Train Wreck" ya "Dot Chaining" kehte hain.
#
#  Isme kya problem hai?
#  1. High Coupling: Tumhara code 6 classes ke internal structure
#     se juda hua hai. Cart item list se Map pe switch kare, toh
#     tumhara code toot jaayega.
#  2. Encapsulation Violation: Tum andar tak haath daal rahe ho.
#     Har layer ki internal details expose ho rahi hain.
#  3. Maintenance Nightmare: Price ka type change kiya, toh jahan
#     jahan yeh chain hai, sab update karna padega.
#  4. Testing Mushkil: Test karne ke liye 6 objects mock karne
#     padenge. Bahut exhausting aur fragile.
#
# ============================================================
#
#  2. Law of Demeter kya hai? (Simple Rule)
#  -----------------------------------------
#  LoD kehta hai:
#  > "Sirf apne direct dost se baat karo."
#
#  Ek method sirf in cheezon ke methods call kar sakta hai:
#  1. Khud (the object itself)
#  2. Apne fields (instance variables jo object rakhta hai)
#  3. Apne method parameters (jo arguments pass hue)
#  4. Jo objects woh method ke andar create karta hai (new ...)
#
#  Bas. Itna hi. Agar tum a.getB().getC().doSomething() kar rahe
#  ho, toh tum LoD tod rahe ho kyunki tum B ke through C pe pohoch
#  rahe ho. Tumhe sirf A se baat karni chahiye, aur A ko decide
#  karne do ki kaam kaise hoga.
#
#  ------------------------------------------------------------
#  Real-Life Analogy
#  ------------------------------------------------------------
#  Tum apne dost (Customer) se kehte ho "Mujhe 100 rupay do."
#  Dost apni jeb (Cart) mein haath daalta hai, wallet (Item) nikaalta
#  hai, aur 100 rupay (Price) deta hai.
#  Tum directly dost ki jeb mein haath nahi daalte, uske wallet
#  mein nahi jhaadte. Tum sirf dost se maangte ho, woh khud manage
#  karta hai. Yahi LoD hai.
#
# ============================================================
#
#  3. Refactoring (Solution: Delegation)
#  --------------------------------------
#  Strategy: Responsibility (zimmedari) un classes ko do jo data
#  ke maalik hain. Har class ek meaningful method expose kare,
#  apne internals nahi.
#
#  Step 1: ShoppingCart mein method add karo.
#  ShoppingCart apne items jaanta hai. Toh item ki price dhoondhne
#  ki zimmedari uski hai.
#
#  class ShoppingCart:
#      def __init__(self):
#          self._items = []
#
#      def get_first_item_price(self):
#          if not self._items:
#              return Money.ZERO
#          return self._items[0].get_product().get_price()
#          # Yahan chain within cart ki responsibility boundary hai.
#          # Bahar walo ko is chain ki zaroorat nahi.
#
#  Step 2: Customer mein method add karo.
#  Customer apne Cart ka maalik hai, toh cart-related queries
#  delegate karega.
#
#  class Customer:
#      def __init__(self, shopping_cart):
#          self._shopping_cart = shopping_cart
#
#      def get_first_cart_item_price(self):
#          return self._shopping_cart.get_first_item_price()
#
#  Step 3: OrderService update karo.
#  Ab OrderService sirf apne direct dost (Customer) se baat karega.
#
#  def display_first_item_price(customer: Customer):
#      price = customer.get_first_cart_item_price()
#      print("Price of the first item:", price.get_amount())
#
#  Ab OrderService ko farak nahi padta ki Cart item kaise store
#  karta hai, Product price kaise rakhta hai. Woh sirf Customer
#  se poochta hai, Customer Cart ko delegate karta hai. Har layer
#  dusre ko chhupa deti hai. Yeh LoD at work hai.
#
# ============================================================
#
#  4. Fayde (Benefits)
#  -------------------
#  - Low Coupling: Classes sirf apne direct collaborators pe depend
#    karti hain. Ek jagah change se codebase mein ripple nahi aata.
#  - Better Encapsulation: Koi external code internals mein nahi
#    jhaakta. Objects meaningful behavior dikhate hain.
#  - Easy Refactoring: Internal implementation evolve kar sakte ho
#    bina consumers pe asar daale.
#  - Better Testing: Mock chain nahi banani padti. Sirf Customer
#    mock karo, price return karo. Bas.
#  - Cleaner APIs: Methods intentional hote hain ("first item price
#    do") instead of raw structure ("list do, main khud dhoondhunga").
#
# ============================================================
#
#  5. Common Questions (Sawaal-Jawaab)
#  ------------------------------------
#  Q: Isn't this just more code? Zyada wrapper methods likhne padte hain!
#  A: Haan, chhote delegating methods add hote hain. Par yeh "extra"
#     code coupling kam karta hai. 3 line abhi likho, ya 300 line
#     baad mein refactor karo. Yeh "Tell, Don't Ask" principle hai —
#     object ko bolo kya karna hai, andar daal ke khud mat karo.
#
#  Q: Kya iska matlab hai getters use mat karo?
#  A: Nahi. Simple property access jaise customer.get_name() theek
#     hai (name direct part hai). Problem tab hai jab getters chain
#     banayein: customer.get_cart().get_items().get(0)... Yeh
#     internal structure expose karta hai. Operation delegate karo.
#
#  Q: Data structures pe .size() call kar sakte hain?
#  A: Haan. getUsers().size() theek hai. List transparent abstraction
#     hai. Par getUsers().get(0).getAddress().getStreet() violation
#     hai. Tum domain objects ke through traverse kar rahe ho. Simple
#     data structure hai ya object ki responsibility chain hai, yeh
#     key hai.
#
#  Q: Kab violate karna theek hai?
#  A: LoD guideline hai, hard rule nahi. Exceptions:
#     - DTOs / Value Objects: Simple data carriers pe traverse theek.
#     - Stable Low-Level Libraries: Map.get(), List.size() safe hain.
#     - Fluent APIs / Builders: Method chaining intentional design.
#     Agar coupling trade-off samjho aur justify karo, toh karo. Par
#     accident mein mat karo.
#
# ============================================================
#
#  6. Practical Example: Ride Notification System
#  -----------------------------------------------
#  Uber jaisa app. NotificationService ko ride update bhejna hai.
#  Tume 3 cheezein chahiye: Driver ka naam, Car ki plate, Passenger
#  ka phone.
#
#  Problem (Train Wreck):
#  class NotificationService:
#      def send_ride_update(self, ride):
#          driver_name = ride.get_driver().get_profile().get_full_name()
#          plate = ride.get_driver().get_vehicle().get_registration().get_license_plate()
#          phone = ride.get_passenger().get_contact_info().get_phone_number()
#          # ... message bhejo ...
#
#  NotificationService ab 7 classes ke internal structure ko jaanta
#  hai. Vehicle ka structure change hua, toh yeh service toot jaayegi.
#
#  Fix: Delegation methods add karo Ride class mein.
#  Ride pe driver aur passenger ke references hain, toh yeh natural
#  jagah hai in sawaalon ke jawab dene ki.
#
#  class Ride:
#      def __init__(self, driver, passenger):
#          self._driver = driver
#          self._passenger = passenger
#
#      def get_driver_name(self):
#          return self._driver.get_profile().get_full_name()
#
#      def get_vehicle_plate(self):
#          return self._driver.get_vehicle().get_registration().get_license_plate()
#
#      def get_passenger_phone(self):
#          return self._passenger.get_contact_info().get_phone_number()
#
#  Ab NotificationService simple aur clean:
#  class NotificationService:
#      def send_ride_update(self, ride):
#          driver_name = ride.get_driver_name()
#          plate = ride.get_vehicle_plate()
#          phone = ride.get_passenger_phone()
#          # ... message bhejo ...
#
#  NotificationService ab sirf Ride ko jaanta hai. Usse pata hi
#  nahi ki Driver, Vehicle, Profile jaisi koi cheez exist karti hai.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - Law of Demeter = "Sirf apne direct dost se baat karo." Ek
#    object ko dusre ke andar se third object nikalna mat do.
#  - Avoid "Train Wreck" (a.getB().getC().doSomething()).
#  - Problem: High coupling, encapsulation violation, maintenance
#    nightmare, testing mushkil (bahut mocks).
#  - Solution: Responsibility delegate karo. Owner class mein method
#    banao jo andar ki chain handle kare, bahar sirf simple result de.
#  - Fayde: Low coupling, better encapsulation, easy refactoring,
#    easy testing, cleaner APIs.
#  - Exceptions: DTOs, stable libraries, fluent APIs. Intentional
#    design mein allow hai.
#
#  Ek line mein: LoD = "Object ko bolo kya chahiye, uske andar
#  mat ghuso. Apne dost se direct baat karo, dost ke dost se nahi."
#
# ============================================================
