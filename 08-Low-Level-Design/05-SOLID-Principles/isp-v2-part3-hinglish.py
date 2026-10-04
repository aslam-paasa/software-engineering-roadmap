# ============================================================
#  INTERFACE SEGREGATION PRINCIPLE (ISP) — Part-3
#  Topic: ISP ko code mein kaise lagayein?
# ============================================================
#
#  Ab apne mota (fat) MediaPlayer interface ko fix karte hain.
#  Strategy: Bade interface ko chhote, logical interfaces mein
#  todo. Har interface ek specific kaam represent kare.
#
# ============================================================
#
#  Step 1: Chhote Interfaces Banao
#  --------------------------------
#  Ek AudioPlayerControls interface jisme sirf audio wale methods
#  hon. Ek VideoPlayerControls interface jisme sirf video wale.
#
#  from abc import ABC, abstractmethod
#
#  class AudioPlayerControls(ABC):
#      @abstractmethod
#      def play_audio(self, audio_file): pass
#      @abstractmethod
#      def stop_audio(self): pass
#
#  class VideoPlayerControls(ABC):
#      @abstractmethod
#      def play_video(self, video_file): pass
#      @abstractmethod
#      def stop_video(self): pass
#      @abstractmethod
#      def display_subtitles(self, subtitle_file): pass
#
#  ============================================================
#
#  Step 2: Classes Sirf Zaroori Interface Implement Karein
#  ------------------------------------------------------
#  Ab AudioOnlyPlayer sirf AudioPlayerControls implement karega.
#  Usme video ka koi method hi nahi hai. No exceptions, no empty
#  methods!
#
#  class ModernAudioPlayer(AudioPlayerControls):
#      def play_audio(self, audio_file):
#          print(f"Playing audio - {audio_file}")
#      def stop_audio(self):
#          print("Audio stopped.")
#
#  SilentVideoPlayer sirf VideoPlayerControls implement karega:
#
#  class SilentVideoPlayer(VideoPlayerControls):
#      def play_video(self, video_file):
#          print(f"Playing video - {video_file}")
#      def stop_video(self):
#          print("Video stopped.")
#      def display_subtitles(self, subtitle_file):
#          print(f"Subtitles from {subtitle_file}")
#
#  ------------------------------------------------------------
#  Agar dono chahiye? Multiple interfaces implement karo!
#  ------------------------------------------------------------
#  Ek ComprehensiveMediaPlayer jo audio aur video dono chalata hai,
#  woh dono interfaces implement karega.
#
#  class ComprehensiveMediaPlayer(AudioPlayerControls, VideoPlayerControls):
#      def play_audio(self, audio_file): print(f"Playing audio")
#      def play_video(self, video_file): print(f"Playing video")
#      def stop_audio(self): print("Stopped")
#      def stop_video(self): print("Stopped")
#      def display_subtitles(self, sub): print("Subs")
#
#  Ab dekho: Har class sirf wahi contracts implement kar rahi hai
#  jo woh poori tarah poora kar sakti hai. Interfaces chhote,
#  focused, aur jodne yogya (composable) hain.
#
# ============================================================
#
#  SUMMARY (Part-3)
#  ----------------
#  - Bade interface ko chhote interfaces mein todo (Audio, Video).
#  - Class sirf wahi implement kare jo usse chahiye.
#  - AudioOnlyPlayer -> AudioPlayerControls (no video methods!).
#  - Dono chahiye toh dono interfaces implement karo (ComprehensiveMediaPlayer).
#  - No empty methods, no exceptions. Clean contracts.
#
#  Next part mein: ISP apply karte waqt common galtiyan.
#
# ============================================================
