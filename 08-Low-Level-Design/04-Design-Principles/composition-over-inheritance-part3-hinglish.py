# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-3) — Aasan Hinglish Guide
#  Topic: The Composition Alternative ("Has-A" Relationship)
# ============================================================
#
#  Inheritance ki problems dekh li. Ab dekhte hain Composition kaise
#  in problems ko solve karta hai. Composition mein hum objects ko
#  rigid family tree mein daalne ke bajaye, "behaviors" ko jod kar
#  banate hain.
#
#  Core idea: Behaviors ko unke khud ke objects mein encapsulate
#  karo, aur phir in "behavior objects" ko main object ko do.
#  Bilkul LEGO blocks ki tarah.
#
# ============================================================
#
#  Step 1: Behaviors identify karke Interfaces banao
#  -------------------------------------------------
#  Jo cheezein change hoti hain (movement, attack) unhe class
#  hierarchy mein daalne ke bajaye, hum unhe "interfaces" (contracts)
#  ke roop mein model karte hain.
#
#  class MoveBehavior(ABC):
#      @abstractmethod
#      def move(self): pass
#
#  class AttackBehavior(ABC):
#      @abstractmethod
#      def attack(self): pass
#
#  ============================================================
#
#  Step 2: Concrete Implementations banao (LEGO Blocks)
#  -----------------------------------------------------
#  Yeh humare LEGO blocks hain. Har ek chhota, focused, aur
#  interchangeable hai. Yeh Monster ke baare mein kuch nahi jaante.
#  Woh independent aur reusable units of behavior hain.
#
#  # Movement Blocks
#  class FlyMovement(MoveBehavior):
#      def move(self): print("Soaring through the sky!")
#
#  class WalkMovement(MoveBehavior):
#      def move(self): print("Walking on the ground.")
#
#  # Attack Blocks
#  class FireBreathAttack(AttackBehavior):
#      def attack(self): print("Breathing flame!")
#
#  class MeleeAttack(AttackBehavior):
#      def attack(self): print("Attacking with claws!")
#
#  ============================================================
#
#  Step 3: Main Object ko Compose karo
#  ------------------------------------
#  Ab Monster class mein fly() ya attack() baked (hardcoded) nahi
#  hai. Monster "has-a" MoveBehavior aur "has-a" AttackBehavior.
#  Woh apna kaam in behavior objects ko delegate karta hai.
#
#  class Monster:
#      def __init__(self, move_behavior: MoveBehavior, attack_behavior: AttackBehavior):
#          self.health = 0
#          self.move_behavior = move_behavior
#          self.attack_behavior = attack_behavior
#
#      # Monster ka action, behavior object ko delegate karta hai
#      def perform_move(self):
#          self.move_behavior.move()
#
#      def perform_attack(self):
#          self.attack_behavior.attack()
#
#      # RUNTIME pe behavior change kar sakte hain!
#      def set_move_behavior(self, new_move):
#          self.move_behavior = new_move
#
#  Monster class ab simple aur stable hai. Use farak nahi padta ki
#  movement kaisi hai ya attack kaisa hai. Use bas itna pata hai ki
#  uske paas move karne aur attack karne wali cheezein hain.
#
#  ============================================================
#
#  Step 4: Koi bhi Monster banao
#  ------------------------------
#  Ab koi bhi monster banana trivial aur flexible hai. Bas pasand
#  ke behaviors constructor mein pass kar do.
#
#  # Aag udane wala, udne wala monster (Dragon)
#  dragon = Monster(FlyMovement(), FireBreathAttack())
#  dragon.perform_move()   # "Soaring through the sky!"
#  dragon.perform_attack() # "Breathing flame!"
#
#  # Zehar thukne wala, tairne wala monster (Sea Serpent)
#  sea_serpent = Monster(SwimMovement(), PoisonSpitAttack())
#  sea_serpent.perform_attack()
#
#  # Dragon ki pankh kat gayi? Runtime pe behavior change karo!
#  dragon.set_move_behavior(WalkMovement())
#  dragon.perform_move() # Ab woh chalega, uda nahi.
#
#  Yeh Strategy Pattern hai — composition ka sabse classic example.
#  Naya behavior add karna ho toh bas ek nayi class banao aur pass
#  karo. Monster class ko chhued nahi. No combinatorial explosion!
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Composition = "has-a" relationship. Behaviors ko alag objects
#    banao aur main object ko do.
#  - Interfaces banao (MoveBehavior, AttackBehavior).
#  - Concrete LEGO blocks banao (FlyMovement, FireBreathAttack).
#  - Main object (Monster) unhe delegate karega.
#  - Runtime pe behaviors swap kar sakte ho. Flexible, reusable,
#    no class explosion.
#
#  Next part mein: Inheritance vs Composition head-to-head aur kab
#  inheritance use karna chahiye.
#
# ============================================================
