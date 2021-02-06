enum Level { Easy, Normal, Hard }

extension Name on Level {
  String get name {
    switch (this) {
      case Level.Easy:
        return "Easy";
      case Level.Hard:
        return "Hard";
      default:
        return "Normal";
    }
  }
}
