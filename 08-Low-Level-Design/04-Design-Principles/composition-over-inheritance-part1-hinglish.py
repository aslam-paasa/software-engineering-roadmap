# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-1) — Aasan Hinglish Guide
#  Topic: Introduction & The Lure of Inheritance
# ============================================================
#
#  Socho tumhe software mein ek Car design karni hai. Tumhara pehla
#  instinct khud OOP ke early lessons se aata hai: "Car kya hai?"
#  Car ko chalne ke liye Engine chahiye. Engine mein start() aur
#  stop() methods hain. Toh kyun na Car class Engine se inherit
#  kar le?
#
#  WAIT! Yeh GALAT tareeka hai!
#
#  class Engine:
#      def start(self): pass
#      def stop(self): pass
#
#  class Car(Engine):  # Car "is-an" Engine? NAHI!
#      pass
#
#  Yeh model turant galat lagta hai. Car ek engine NAHI hai. Car
#  ke paas engine HAI. Language mein yeh simple difference hi samajhne
#  ki kunji hai OOP design ke ek sabse powerful principle ki:
#  "Favor Composition over Inheritance" (Composition ko Inheritance
#  se zyada prefer karo).
#
#  Inheritance "is-a" (ek hai) relationship banata hai.
#  Composition "has-a" (ke paas hai) relationship banata hai.
#
#  Composition tumhe complex objects chhote, independent, aur
#  interchangeable (badalne yogya) parts jod kar banane deta hai.
#  Bilkul LEGO blocks ki tarah — ek piece ko snap karo, aur tum
#  bina poora structure dobara banaye koi bhi piece swap kar sakte ho.
#
# ============================================================
#
#  1. The Lure of Inheritance ("Is-A" Relationship)
#  -------------------------------------------------
#  Inheritance OOP ka pehla pillar hai jo developers seekhte hain.
#  Yeh world ko model karne aur code reuse karne ka intuitive tareeka
#  hai. Hum hierarchies roz dekhte hain: Dog is an Animal,
#  CheckingAccount is a BankAccount, Button is a UIComponent.
#
#  Inheritance ka primary fayda Polymorphism hai. Tum alag-alag
#  Animal subtypes (Dog, Cat, Bird) ki ek list bana sakte ho aur
#  un sab pe common method like makeSound() call kar sakte ho.
#
#  ------------------------------------------------------------
#  Example: Video Game Monster System
#  ------------------------------------------------------------
#  Ek simple monster system inheritance se banate hain.
#
#  Pehle base Monster class jisme common state aur default attack
#  behavior ho:
#
#  from abc import ABC
#
#  class Monster(ABC):
#      def __init__(self):
#          self.health = 0
#
#      def attack(self):
#          print("The monster attacks with base melee attack!")
#
#  Ab humein alag types ke monsters chahiye. Kuch ud sakte hain.
#  Kuch aag uda sakte hain. Toh hierarchy extend karte hain:
#
#  class Dragon(Monster):
#      def fly(self):
#          print("The dragon flaps its wings!")
#
#  class FireDragon(Dragon):
#      def attack(self):
#          print("The fire dragon breathes flame!")
#
#  Ab tak theek lag raha hai. Par jab requirements change honge,
#  toh yeh hierarchy problem mein pad jaayegi. Next part mein
#  dekhenge yeh kaise toot jaata hai.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Car "is-an" Engine nahi hai. Car "has-a" Engine hai.
#  - Inheritance = "is-a" relationship (rigid).
#  - Composition = "has-a" relationship (flexible, LEGO blocks).
#  - Inheritance intuitive hai aur polymorphism deta hai, par
#    misuse se system rigid ho jaata hai.
#
#  Next part mein: Inheritance ke 3 bade problems.
#
# ============================================================
