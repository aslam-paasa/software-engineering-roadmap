# ============================================================
#  COMPOSITION OVER INHERITANCE (Part-1) — Aasan Hinglish
#  Topic: Basic Idea (Has-a vs Is-a)
# ============================================================
#
#  Ek simple sawaal: Tumhe ek Car (gaadi) design karni hai.
#  Gaadi chalne ke liye Engine chahiye.
#
#  Ab dimaag chalta hai: "Engine mein start() aur stop() hai.
#  Toh kyun na Car class Engine class se inherit kar le?
#  matlab Car ek Engine ban jaaye."
#
#  RUKO! Yeh GALAT hai.
#
#  class Engine:
#      def start(self): pass
#
#  class Car(Engine):  # Car ek Engine hai? Bilkul nahi!
#      pass
#
#  Ek gaadi ek engine NAHI hai. Gaadi ke andar ek engine hota hai.
#
#  Yeh simple si baat OOP ke sabse bade principle ki kunji hai:
#  "Favor Composition over Inheritance" (Inheritance se zyada
#  Composition acha hai).
#
#  ------------------------------------------------------------
#  Inheritance (Is-A) vs Composition (Has-A)
#  ------------------------------------------------------------
#  INHERITANCE ("Is-A" - Ek hai):
#  - Dog ek Animal hai. (Dog is an Animal).
#  - Inheritance mein ek class doosri class ki beti (child) ban jaati
#    hai.
#
#  COMPOSITION ("Has-A" - Ke paas hai):
#  - Car ke paas Engine hai. (Car has an Engine).
#  - Composition mein ek class apne andar doosri class ka object
#    apne paas rakhti hai.
#
#  ------------------------------------------------------------
#  Real-Life Analogy: LEGO Blocks
#  ------------------------------------------------------------
#  Composition bilkul LEGO blocks jaisa hai. Tum ek gaadi banate ho
#  chhote blocks ko jod kar (engine, wheels, seat). Agar tumhe ek
#  wheel change karna hai, toh tum sirf woh block nikal kar naya
#  daal dete ho. Poori gaadi dobarah banani nahi padti.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Car "is-an" Engine nahi, "has-a" Engine hai.
#  - Inheritance = "Is-A" (Dog is an Animal).
#  - Composition = "Has-A" (Car has an Engine).
#  - Composition LEGO blocks jaisa hai: parts ko jod kar banao,
#    swap karna easy.
#
#  Next part mein: Inheritance kaam kaise karta hai aur uski
#  problems kya hain.
#
# ============================================================
