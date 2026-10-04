# ============================================================
#  INTERFACE SEGREGATION PRINCIPLE (ISP) — Part-1
#  Topic: Problem aur ISP ka matlab
# ============================================================
#
#  Kabhi kisi interface ko implement kiya, aur faltu khali methods
#  likhne pade bas compiler ko khush rakhne ke liye?
#
#  Agar haan, toh tumne ISP tod diya. Chalo bilkul aasan bhasha
#  mein samajhte hain.
#
# ============================================================
#
#  1. Problem: Mota (Fat) Interface
#  --------------------------------
#  Tum media player app bana rahe ho. Audio (MP3) aur Video (MP4)
#  dono support karna hai. Tumne socha: "Ek hi bada interface bana
#  leta hoon jisme sab kuch hoga."
#
#  class MediaPlayer(ABC):
#      @abstractmethod
#      def play_audio(self): pass
#      @abstractmethod
#      def play_video(self): pass
#      @abstractmethod
#      def adjust_brightness(self): pass
#
#  Ab tumhe sirf Audio wala player banana hai (jo video nahi chalata).
#  Par tumne MediaPlayer implement kiya, toh compiler bolega:
#  "play_video() aur adjust_brightness() bhi implement karo!"
#
#  class AudioOnlyPlayer(MediaPlayer):
#      def play_audio(self): print("Playing audio")
#      # Faltu methods! Mujhe nahi chahiye par likhna padega!
#      def play_video(self): raise Exception("Not supported")
#      def adjust_brightness(self): raise Exception("Not supported")
#
#  AudioOnlyPlayer ko video wale methods implement karne pade jo
#  usse koi lena dena nahi hai.
#
#  Isme 3 problems hain:
#  1. Interface Pollution: Interface mein sab kuch bhara hua hai.
#     Ek class jo sirf audio chahiye, woh sab ka bojh uthaye.
#  2. Fragile Code: Agar interface mein naya method add karoge, toh
#     AudioOnlyPlayer ko bhi update karna padega (jo usse koi matlab
#     nahi).
#  3. LSP Break: Client expect karta hai MediaPlayer se video chale,
#     par AudioOnlyPlayer exception throw karega. Program crash.
#
# ============================================================
#
#  2. ISP kya hai?
#  ---------------
#  Robert C. Martin ne kaha:
#  > "Client ko aise methods pe depend karne ke liye majboor nahi
#  > hona chahiye jo woh use nahi karte."
#
#  Simple bhasha: Apne interfaces chhota aur focused rakho. Har
#  interface ek specific kaam represent kare. Agar class ko koi method
#  nahi chahiye, toh use implement karne ke liye majboor mat karo.
#
#  ------------------------------------------------------------
#  Real-Life Analogy: Thaali (Plate) ka system
#  ------------------------------------------------------------
#  Soch ek restaurant mein ek hi badi thaali hai jisme sab kuch hai —
#  Paneer, Roti, Chawal, Ice-cream, Papad. Agar tum sirf Roti aur
#  Paneer khana chahte ho, tab bhi tumhe poora thaali lena padega.
#  Aur agar manager ne thaali mein naya dish (Jalebi) add kar diya,
#  toh tumhe waise hi lena padega.
#
#  ISP kehta hai: Alag-alag chhoti thaali rakho. Paneer chahiye toh
#  Paneer ki thaali lo. Sirf Roti chahiye toh Roti ki. Kuch nahi
#  chahiye toh mat lo. Faltu cheezein mat thoso.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Problem: Ek bada (fat) interface. Sirf audio chahiye, toh bhi
#    video ke methods implement karne pade (exception throw karne ke
#    liye).
#  - ISP = "Client ko un methods pe majboor mat karo jo use nahi
#    karte. Interfaces chhote aur focused rakho."
#  - Analogy: Ek badi thaali ki jagah chhote alag-alag thaali.
#
#  Next part mein: ISP kyun zaroori hai aur iske fayde.
#
# ============================================================
