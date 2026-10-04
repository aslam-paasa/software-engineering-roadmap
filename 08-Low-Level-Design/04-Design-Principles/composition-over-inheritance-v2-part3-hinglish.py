# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-3) — Aasan Hinglish
#  Topic: Composition ka Solution (LEGO blocks)
# ============================================================
#
#  Inheritance ki problems dekh li. Ab dekhte hain Composition kaise
#  in problems ko solve karta hai.
#
#  Idea simple hai: Behaviors (kaam karne ke tarike) ko alag-alag
#  chhote LEGO blocks banao. Phir Monster ko batao "tujhe yeh block
#  use karna hai." Monster class mein hardcode mat daalo.
#
# ============================================================
#
#  Step 1: Behaviors ke Interface (Contracts) banao
#  -------------------------------------------------
#  Pehle movement aur attack ke contracts banao.
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
#  Step 2: Concrete LEGO blocks banao
#  ----------------------------------
#  Ab in contracts ko implement karo. Yeh chhote, independent blocks
#  hain.
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
#  class PoisonSpitAttack(AttackBehavior):
#      def attack(self): print("Spitting poison!")
#
#  ============================================================
#
#  Step 3: Monster ko Compose karo
#  --------------------------------
#  Monster class ab fly() ya attack() hardcode nahi karti. Uske
#  paas MoveBehavior aur AttackBehavior blocks hain. Woh unse kaam
#  karwati hai (delegate karti hai).
#
#  class Monster:
#      def __init__(self, move_behavior: MoveBehavior, attack_behavior: AttackBehavior):
#          self.health = 0
#          self.move_behavior = move_behavior
#          self.attack_behavior = attack_behavior
#
#      # Monster ka action, block ko delegate karta hai
#      def perform_move(self):
#          self.move_behavior.move()
#
#      def perform_attack(self):
#          self.attack_behavior.attack()
#
#      # RUNTIME pe block change kar sakte hain!
#      def set_move_behavior(self, new_move):
#          self.move_behavior = new_move
#
#  ============================================================
#
#  Step 4: Koi bhi Monster banao
#  ------------------------------
#  Ab monster banana bahut easy hai. Bas LEGO blocks jod do.
#
#  # Fire udane wala, udne wala Dragon
#  dragon = Monster(FlyMovement(), FireBreathAttack())
#  dragon.perform_move()   # "Soaring through the sky!"
#  dragon.perform_attack() # "Breathing flame!"
#
#  # Zehar thukne wala, chalne wala Zombie
#  zombie = Monster(WalkMovement(), PoisonSpitAttack())
#  zombie.perform_attack()
#
#  # Dragon ki pankh kat gayi? Game chalte hue block change karo!
#  dragon.set_move_behavior(WalkMovement())
#  dragon.perform_move() # Ab woh chalega, uda nahi.
#
#  Dekho! Koi nayi class nahi bani. Bas blocks mix kiye. No class
#  explosion. Aur runtime pe behavior bhi change ho gaya. Yahi
#  Composition ka jadoo hai.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Composition = "has-a". Behaviors ko LEGO blocks ki tarah banao.
#  - Interface banao (MoveBehavior).
#  - Blocks banao (FlyMovement, FireBreathAttack).
#  - Monster in blocks ko apne paas rakhega (delegate karega).
#  - Runtime pe blocks swap kar sakte ho. Flexible, reusable,
#    no class explosion.
#
#  Next part mein: Dono ka comparison aur kab kya use karein.
#
# ============================================================
