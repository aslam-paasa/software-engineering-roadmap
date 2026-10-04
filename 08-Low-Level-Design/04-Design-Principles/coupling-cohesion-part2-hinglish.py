# ============================================================
#  COUPLING & COHESION (Part-2) — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Pichle part mein humne Cohesion seekha (ek class ke andar kitna
#  focused hai). Ab COUPLING samajhte hain.
#
# ============================================================
#
#  1. COUPLING kya hai? (Ekdam simple mein)
#  --------------------------------------------
#  Coupling measure karta hai ki ek module doosre module ke
#  "inner workings" (andar ke details) pe kitna zyada depend
#  karta hai. Yeh do modules ke beech ka relationship describe
#  karta hai.
#
#  Simple Analogy — USB Port:
#  > Socho tumhare computer mein USB port hai. Tum usme mouse,
#  > keyboard, ya pen drive koi bhi daal sakte ho. Computer ko
#  > farak nahi padta. Woh sirf "USB interface" se baat karta hai.
#  > Agar mouse kharab ho, toh nayi loge, computer nahi badalna
#  > padega. Yeh LOW COUPLING hai.
#  >
#  > Agar mouse seedha computer ke circuit se judda (soldered)
#  > ho, toh mouse change karne ke liye computer ka circuit
#  > todhna padega. Yeh HIGH COUPLING hai (Super glue model).
#
#  ------------------------------------------------------------
#  Low Coupling vs High Coupling
#  ------------------------------------------------------------
#  LOW COUPLING (Yehi goal hai):
#  - Modules ek dusre se simple, stable interfaces ke through
#    interact karte hain. Andar ki details jaanne ki zaroorat
#    nahi.
#
#  HIGH COUPLING (Recipe for disaster):
#  - Modules tightly jude hue hain. Ek module change karo, toh
#    doosre mein cascade (ripple) of changes aayenge. System
#    rigid aur fragile ho jaata hai. Ek cheez chhedi, sab toot
#    gaye.
#
# ============================================================
#
#  2. Example — High vs Low Coupling
#  ---------------------------------
#  OrderService ko repository (DB) aur notification service chahiye.
#  Galat tareeka (High Coupling): OrderService apne dependencies
#  khud concrete classes se banata hai.
#
#  Before (High Coupling):
#  class OrderService:
#      def __init__(self):
#          # RED FLAG: Service apne aap dependencies bana raha hai!
#          self._order_repository = OrderRepository()
#          self._notification_service = EmailNotificationService()
#
#      def process_order(self, order):
#          if not order.get_items():
#              raise ValueError("Order must have at least one item.")
#          self._order_repository.save(order)
#          self._notification_service.send_order_confirmation(order)
#
#  Isme kya problem hai?
#  1. Rigidity: File mein save karna ho DB ki jagah, toh class ka
#     code change karna padega.
#  2. Testability: DB aur Email server mock nahi kar sakte. Test
#     karna nearly impossible.
#  3. Reusability: Email ki jagah SMS bhejna ho, toh reuse nahi
#     kar sakte. Concrete dependency hardcoded hai.
#  OrderService bahut zyada jaanta hai. Usse sirf "kya" chahiye
#  pata hona chahiye, "kaise" implement hai nahi.
#
#  After (Low Coupling via Interfaces and DI):
#  Solution: "Program to an interface, not an implementation."
#
#  Step 1: Interfaces (Contracts) define karo.
#  from abc import ABC, abstractmethod
#
#  class OrderRepository(ABC):
#      @abstractmethod
#      def save(self, order: Order) -> None:
#          pass
#
#  class NotificationService(ABC):
#      @abstractmethod
#      def send_order_confirmation(self, order: Order) -> None:
#          pass
#
#  Step 2: Concrete classes inko implement karein.
#  class DatabaseOrderRepository(OrderRepository): ...
#  class EmailNotificationService(NotificationService): ...
#  class SmsNotificationService(NotificationService): ...  # Naya option!
#
#  Step 3: OrderService ab concrete classes pe nahi, interfaces
#  pe depend karega. Dependencies bahar se (constructor se) aayengi.
#
#  class OrderService:
#      def __init__(self, repository: OrderRepository, notifier: NotificationService):
#          self._order_repository = repository  # Interface type
#          self._notification_service = notifier # Interface type
#
#      def process_order(self, order):
#          if not order.get_items():
#              raise ValueError("Order must have at least one item.")
#          self._order_repository.save(order)
#          self._notification_service.send_order_confirmation(order)
#
#  Ab OrderService interfaces (stable contracts) pe depend karta
#  hai, concrete classes (volatile implementations) pe nahi.
#  Naya implementation add karna ho (FileRepository, PushNotification),
#  toh bina OrderService chhede add kar sakte ho.
#  Yahi low coupling hai. Har module ko sirf utna pata hai jitni
#  zaroorat hai, aur ek dam zyada nahi.
#
# ============================================================
#
#  3. Coupling aur Cohesion ka Rishta
#  ----------------------------------
#  Coupling aur Cohesion alag nahi hain. Yeh design ke sikke ke
#  do pehlu hain. Ek ko improve karne se dusra apne aap improve
#  hota hai.
#
#  > High Cohesion achieve karna hi Low Coupling achieve karne ka
#  > sabse best tareeka hai.
#
#  - Low Cohesion (God Class): Ek class bahut saare kaam karti hai.
#    Toh bahut saari classes uspe alag-alag reasons pe depend
#    karte hain. Ek bada web of HIGH COUPLING ban jaata hai.
#    Jaise OrderManager validation, DB, email, PDF, logging sab
#    karta hai. ReportingService uspe PDF ke liye, AuditService
#    logging ke liye, CustomerPortal email ke liye depend hai.
#    Sab ek hi bloated class pe jude hain.
#
#  - High Cohesion (Focused Class): Ek class ek kaam karti hai.
#    Doosri classes sirf uss ek purpose ke liye depend karti hain.
#    Dependency ka area kam hota hai, isse LOW COUPLING milta
#    hai. Jab tum OrderManager ko focused classes mein tod dete
#    ho, toh ReportingService sirf PDF class pe depend karti hai.
#    OrderManager pe nahi.
#
#  Simple words mein: Jab classes apna kaam focused rakhti hain
#  (high cohesion), toh dusri classes un sirf utne pe depend karti
#  hain jitna unhe chahiye. Faltu ka coupling nahi banta.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - Coupling = Do modules ke beech kitni dependency hai. Ek module
#    dusre ke andar ke details pe kitna depend karta hai. (External
#    quality)
#  - Low Coupling (Goal): USB port jaisa. Interface pe depend karo,
#    concrete class pe nahi. Ek change karo, dusre pe asar na ho.
#  - High Coupling (Problem): Super glue jaisa. Ek change karo, toh
#    poore system mein ripple effect aayega. Code rigid, fragile.
#  - Solution: "Program to an interface, not an implementation."
#    Dependencies bahar se inject karo (Dependency Injection).
#  - Coupling aur Cohesion ka rishta: Yeh dono ek doosre se jude
#    hain. High Cohesion (focused classes) se apne aap Low Coupling
#    milta hai. God class (low cohesion) sab ko apne saath jod leti
#    hai (high coupling).
#
#  Ek line mein: Coupling = "Doosre ke andar ke details pe mat
#  depend karo. Interface pe baat karo, aur apni class focused rakho."
#
# ============================================================
