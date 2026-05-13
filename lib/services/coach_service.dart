class CoachService {

  static String getMessage({
    required double progress,
    required bool isDayCompleted,
    required int streak,
  }) {

    if (isDayCompleted) {
      return "🔥 Harika! Bugün işi bitirdin. Bu disiplin seni değiştiriyor.";
    }

    if (progress == 0) {
      return "⚡ Bugün başlamak için en iyi gün. 5 dakika bile yeter.";
    }

    if (progress < 0.5) {
      return "💪 İyi gidiyorsun ama bitirmeden bırakma.";
    }

    if (progress < 1) {
      return "🚀 Son adımlar kaldı. Şimdi bırakma zamanı değil.";
    }

    if (streak >= 5) {
      return "🔥 5+ gün streak! Artık sistem oturdu.";
    }

    return "📈 Devam et, küçük adımlar büyük değişim getirir.";
  }
}