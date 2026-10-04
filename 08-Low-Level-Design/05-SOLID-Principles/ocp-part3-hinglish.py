# ============================================================
#  OPEN-CLOSED PRINCIPLE (OCP) — Part-3
#  Topic: OCP ko code mein kaise lagayein?
# ============================================================
#
#  Ab apne PaymentProcessor ko OCP compliant banate hain. Key hai
#  payment methods ke liye ek abstraction (interface) banana.
#
# ============================================================
#
#  Step 1: Interface Define Karo (Contract)
#  -----------------------------------------
#  Ek PaymentMethod interface banao. Har payment type ko iska
#  process_payment method implement karna padega.
#
#  from abc import ABC, abstractmethod
#
#  class PaymentMethod(ABC):
#      @abstractmethod
#      def process_payment(self, amount):
#          pass
#
#  ============================================================
#
#  Step 2: Concrete Strategies banao (LEGO blocks)
#  -----------------------------------------------
#  Har payment type ke liye ek alag class banao jo interface ko
#  implement kare. Yeh classes independent hain.
#
#  class CreditCardPayment(PaymentMethod):
#      def process_payment(self, amount):
#          print(f"Processing credit card payment of ${amount}")
#
#  class PayPalPayment(PaymentMethod):
#      def process_payment(self, amount):
#          print(f"Processing PayPal payment of ${amount}")
#
#  class UPIPayment(PaymentMethod):
#      def process_payment(self, amount):
#          print(f"Processing UPI payment of ₹{amount * 80}")
#
#  ============================================================
#
#  Step 3: PaymentProcessor ko abstraction pe depend karo
#  -------------------------------------------------------
#  Ab PaymentProcessor concrete classes pe depend nahi karta. Woh
#  PaymentMethod interface pe depend karta hai. Koi if-else nahi,
#  koi switch nahi. Naya method aaye toh yeh class change nahi hogi.
#
#  class PaymentProcessor:
#      def process(self, payment_method: PaymentMethod, amount):
#          # Bas process_payment call kar do. Type ka khayal nahi.
#          payment_method.process_payment(amount)
#
#  ============================================================
#
#  Step 4: Checkout Service
#  -------------------------
#  CheckoutService bas payment method ko processor ko pass karta hai.
#  Use koi farak nahi padta konsa type hai.
#
#  class CheckoutService:
#      def process_payment(self, method: PaymentMethod, amount):
#          processor = PaymentProcessor()
#          processor.process(method, amount)
#
#  # Usage
#  checkout = CheckoutService()
#  checkout.process_payment(CreditCardPayment(), 100.00)
#  checkout.process_payment(UPIPayment(), 100.00)
#
#  ------------------------------------------------------------
#  Result:
#  ------------------------------------------------------------
#  Ab client ne bola "Bitcoin add karo". Kya karoge?
#  1. Ek nayi class banao: BitcoinPayment jo PaymentMethod implement kare.
#  2. Uska process_payment method likho.
#  Bas! PaymentProcessor aur CheckoutService chhued nahi. Yeh closed
#  for modification hain, par open for extension hain (naye classes se).
#  Yeh Strategy Pattern hai.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Interface banao (PaymentMethod).
#  - Har payment type ki apni class banao (LEGO blocks).
#  - Processor ko interface pe depend karo, concrete class pe nahi.
#  - Naya payment add karna ho toh bas nayi class banao. Purana code
#    safe. No if-else.
#
#  Next part mein: OCP apply karte waqt common galtiyan.
#
# ============================================================
