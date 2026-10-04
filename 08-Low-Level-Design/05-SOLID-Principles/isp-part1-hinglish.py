# ============================================================
#  INTERFACE SEGREGATION PRINCIPLE (ISP) — Part-1
#  Topic: Problem aur ISP ka matlab
# ============================================================
#
#  Kabhi kisi interface ko implement kiya, aur faltu khali methods
#  likhne pade bas compiler ko khush rakhne ke liye? Ya shared
#  interface mein badlav kiya, aur achanak bahut saari unrelated
#  classes toot padi?
#
#  Agar haan, toh tumne ISP tod diya. Chalo aasan bhasha mein
#  samajhte hain.
#
# ============================================================
#
#  1. Problem: Fat Interface (Mota Interface)
#  -------------------------------------------
#  Tum media player app bana rahe ho. Audio (MP3) aur Video (MP4)
#  dono support karna hai. Tumne ek hi bada interface banaya jisme
#  sab kuch hai:
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
#  Par tumne MediaPlayer implement kiya, toh compiler majboor karega
#  ki tum play_video() aur adjust_brightness() bhi implement karo!
#
#  class AudioOnlyPlayer(MediaPlayer):
#      def play_audio(self): print("Playing audio")
#      # Faltu methods jo mujhe nahi chahiye!
#      def play_video(self): raise NotImplementedError("Not supported")
#      def adjust_brightness(self): raise NotImplementedError("Not supported")
#
#  AudioOnlyPlayer ko video wale methods implement karne pade jo
#  usse koi lena dena nahi hai. Yeh "Interface Pollution" hai.
#
#  ------------------------------------------------------------
#  Isme 3 problems hain:
#  ------------------------------------------------------------
#  1. Interface Pollution: Interface bahut saare unrelated kaam kar
#     raha hai (audio + video + brightness). Ek class jo sirf audio
#     chahiye, woh sab ka bojh uthaye.
#  2. Fragile Code: Agar interface mein naya method (jaise
#     enablePictureInPicture) add karoge, toh AudioOnlyPlayer ko bhi
#     update karna padega. Ek change ne sab jagah tabah macha di.
#  3. LSP Violation: Client expect karta hai MediaPlayer se video
#     chale, par AudioOnlyPlayer exception throw karega. Yeh LSP
#     break karta hai (Child parent ki jagah nahi le paayi).
#
# ============================================================
#
#  2. ISP kya hai?
#  ---------------
#  Robert C. Martin (Uncle Bob) ne kaha:
#  > "Clients should not be forced to depend on methods they do
#  > not use."
#  (Client ko aise methods pe depend karne ke liye majboor nahi
#  hona chahiye jo woh use nahi karte.)
#
#  Simple bhasha: Apne interfaces chhota aur focused rakho. Har
#  interface ek specific capability (shamta) represent kare. Agar
#  class ko koi method nahi chahiye, toh use implement karne ke
#  liye majboor mat karo.
#
#  ------------------------------------------------------------
#  Real-Life Analogy — Swiss Army Knife
#  ------------------------------------------------------------
#  Soch ek Swiss Army Knife jisme knife, scissors, screwdriver,
#  can opener sab hai. Agar tumhe sirf kaatna hai, toh bhi tum
#  poora bhaari knife uthaoge. Aur agar ek tool kharab hua, toh
#  poora knife change karna padega.
#  ISP kehta hai: Alag-alag chhote tools rakho. Sirf chaku chahiye
#  toh chaku uthao, scissors chahiye toh scissors.
#
# ============================================================
#
#  SUMMARY (Part-1)
#  ----------------
#  - Problem: Ek bada (fat) interface jo sab kuch karta hai. Sirf
#    audio chahiye, toh bhi video ke methods implement karne pade
#    (exception throw karne ke liye).
#  - ISP = "Client ko un methods pe depend karne ke liye majboor
#    mat karo jo woh use nahi karte. Interfaces chhote aur focused
#    rakho."
#  - Analogy: Ek bada Swiss Army Knife ki jagah chhote alag tools.
#
#  Next part mein: ISP kyun zaroori hai aur iske fayde.
#
# ============================================================
