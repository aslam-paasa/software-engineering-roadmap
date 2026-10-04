# ============================================================
#  YAGNI PRINCIPLE — Sabse Aasan Hinglish Guide
# ============================================================
#
#  Kabhi koi feature isliye banaya hai kyunki "shayad kal ko
#  zaroorat pad jaaye"? Ya aise use case ke liye abstraction banaya
#  hai jo abhi exist hi nahi karta?
#
#  Agar haan, toh tumne YAGNI tod diya. YAGNI ka matlab hai "You
#  Aren't Gonna Need It" — "Tumhe iski zaroorat nahi padegi."
#
#  Chalo isko aasan bhasha mein samajhte hain.
#
# ============================================================
#
#  1. YAGNI Principle kya hai? (Simple mein)
#  -----------------------------------------
#  YAGNI kehta hai ki jab tak tumhe kisi feature ki sach mein
#  zaroorat nahi hai, tab tak usko banaane se resist (rocok) karo.
#  Matlab: kal ke liye mat banao. Aaj ke liye banao.
#
#  Simple Analogy:
#  > Tum cycle chalana seekh rahe ho. Tumhe abhi sports bike ki
#  > zaroorat nahi. Pehle cycle pe practice karo. Jab zaroorat hogi,
#  > tab bike lo. Pehle hi sports bike kharid lena YAGNI violation
#  > hai — paise waste, zyada complex, aur sambhalna mushkil.
#
#  Yeh principle Extreme Programming (XP) se aaya hai. XP maanta
#  hai ki software requirements change hote rehte hain, toh future
#  predict karke code banana waste hai. Aaj jo simplest code kaam
#  kar raha hai, woh likho. Zaroorat padne par iterate karo.
#
#  Iska matlab yeh nahi ki ganda code likho. Iska matlab hai ki
#  aaj ki zaroorat ke liye clean code likho, par kal ki imagined
#  zarooraton ke liye layers of abstraction ya extra features mat
#  banao.
#
# ============================================================
#
#  2. Real-World Problem — Image Uploader
#  ---------------------------------------
#  Maan lo user ki profile picture upload karni hai. Current
#  requirement simple hai:
#  1. Image accept karo
#  2. 300x300 size pe resize karo
#  3. Local filesystem pe save karo
#
#  Bas 3 steps. Par developer ne socha:
#  - "Kal video upload bhi chahiye hoga" -> Media Handler Interface
#  - "Cloud storage pe switch karenge" -> Storage Provider Abstraction
#  - "Doosre teams plugin chahte honge" -> Plugin System
#
#  Aur instead of simple uploader, usne yeh bana diya:
#
#  class IMediaHandler(ABC): ...  # Interface for media types
#  class IStorageProvider(ABC): ...  # Interface for storage
#  class MediaHandlerFactory: ...  # Factory for handlers
#  class CloudStorageAdapter(IStorageProvider): ...  # Cloud (empty stubs)
#  class ImageMediaHandler(IMediaHandler): ...  # The only real handler
#  class MediaProcessingEngine: ...  # The bloated engine
#
#  Dekho kya hua. Requirement 3 line ka tha. Par 6 classes aur
#  interfaces bana diye. CloudStorageAdapter mein empty method
#  bodies hain. Factory sirf ek handler manage kar rahi. IStorageProvider
#  ka retrieve/delete method koi use nahi kar raha.
#
#  Dozens of lines of infrastructure code jo kisi user ka kaam nahi
#  kar raha aur koi problem solve nahi kar raha. Yeh classic YAGNI
#  violation hai.
#
#  ------------------------------------------------------------
#  Simple Version (YAGNI Applied)
#  ------------------------------------------------------------
#  YAGNI lagane pe code aisa dikhega:
#
#  class ImageUploader:
#      def __init__(self, resizer, storage):
#          self.resizer = resizer
#          self.storage = storage
#
#      def upload(self, image_file):
#          resized = self.resizer.resize(image_file, 300, 300)
#          self.storage.save(resized)
#
#  Bas. Itna hi. Yeh code:
#  - Aaj ki requirement poori karta hai.
#  - Padhna, test karna, debug karna aasaan hai.
#  - Kal zaroorat padne par extend kar sakte ho.
#  - Koi dead code nahi, koi empty stubs nahi, koi speculative
#    abstraction nahi.
#
#  Agar kal cloud storage ya video format ki zaroorat pade, tab
#  refactor karna. Pehle nahi.
#
# ============================================================
#
#  3. Premature Work (Jaldi ka kaam) kyun nuksan de hai?
#  ------------------------------------------------------
#  Tum sochoge "Tayyar rehne mein kya har hai?" Bahut kuch hai.
#  Har speculative line of code hidden cost carry karti hai.
#
#  1. Wasted Time (Bekaar waqt)
#     Ek ghanta feature pe laga jo needed nahi, woh ek ghanta
#     important feature se chheena gaya. CloudStorageAdapter aur
#     Factory pe time waste hua jo kisi ne use nahi kiya.
#
#  2. Increased Complexity (Badhti Complexity)
#     Extra flexibility se moving parts badhte hain. Code samajhna,
#     test karna, modify karna mushkil hota hai. Naya developer aaya,
#     MediaProcessingEngine dekha, darr gaya. Sochega "koi to reason
#     hoga itne complexity ka" aur simplify karna darte hain.
#     Speculative code permanent ho jaata hai.
#
#  3. Delayed Value (Late Delivery)
#     "Someday" wale features pe kaam karne se, aaj ke features late
#     hote hain. Simple uploader 1 din mein ban jaata, overengineered
#     version 7 din le gaya. User ko 6 din extra wait karaya, un
#     features ke liye jo kisi ne maange hi nahi.
#
#  4. Higher Maintenance Costs (Maintain karne ka kharcha)
#     Unused features bhi cost carry karte hain. Bugs laa sakte hain,
#     dependencies change hone pe update karne padte hain. Storage
#     library upgrade karoge, toh LocalStorage ke saath
#     CloudStorageAdapter bhi update karna padega, jo koi use nahi
#     karta. Dead code free nahi hai, yeh debt hai.
#
# ============================================================
#
#  4. Kab YAGNI ko todna theek hai? (Exceptions)
#  ----------------------------------------------
#  YAGNI ke exceptions hain. Kabhi plan pehle karna justified hota
#  hai. Farq yeh pehchano: "Speculative features" (kya pata kal
#  zaroorat pade) vs "Known constraints" (asli requirement, rule,
#  ya contract).
#
#  1. Security and Compliance (Suraksha aur Niyam)
#     Financial data, health records, ya personal info handle kar
#     rahe ho, toh day one se audit trails, encryption, aur access
#     controls chahiye. Yeh speculative nahi, yeh legal requirements
#     hain. Yeh mat soch ke "shayad security chahiye hogi", yeh
#     pata hai ki chahiye.
#
#  2. Architecture with Known Constraints (Pehle se pata constraints)
#     Agar system ka contractual SLA hai (uptime guarantee) ya
#     pehle se pata hai ki cross-region replication karni hi
#     padegi, toh kuch architectural decisions pehle lena padta hai.
#     Baad mein high availability add karna pehle se bananaa bahut
#     zyada mehenga hota hai.
#
#  3. Reusable Libraries ya Frameworks
#     Agar tum aisi library bana rahe ho jisko dusre teams use
#     karenge, toh thodi flexibility expected hai. API design ke
#     liye pehle sochna padta hai kyunki breaking changes affect
#     bahut logon ko karte hain. Par yahan bhi minimal API se
#     shuru karo, actual usage ke hisaab se expand karo.
#
#  Common thread: Zaroorat "known and concrete" honi chahiye, imagined
#  nahi. Tum guess nahi kar rahe ki audit logging chahiye hoga. Tum
#  jaante ho ki chahiye kyunki law kehta hai.
#
# ============================================================
#
#  SUMMARY — YAAD RAKHNA
#  ---------------------
#  - YAGNI = "You Aren't Gonna Need It". Kal ki soch kar aaj ka code
#    mat banao. Aaj jo cheez chahiye, sirf wahi banao.
#  - Cycle chalana (plugin system for one plugin, factory for one
#    implementation) avoid karo.
#  - Premature work se: Time waste, complexity badhti hai, value
#    late aata hai, maintenance cost badhta hai. Dead code debt hai.
#  - Solution: Simplest code likho jo aaj ki requirement poori kare.
#    Zaroorat padne par refactor karo.
#  - Exceptions: Security/compliance (legal rule), known long-term
#    constraints (SLA, replication), reusable libraries. Yahan
#    known requirements ke liye pehle plan karna theek hai.
#
#  Ek line mein: YAGNI = "Kal ki zaroorat ka andaza mat lagao.
#  Aaj ki zaroorat ka simple aur clean solution banao. Jab zaroorat
#  padegi, tab sochna."
#
# ============================================================
