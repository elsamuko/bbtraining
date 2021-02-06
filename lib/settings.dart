enum Repetitions { Easy, Normal, Hard }

extension Name on Repetitions {
  String get name {
    switch (this) {
      case Repetitions.Easy:
        return "Easy";
      case Repetitions.Hard:
        return "Hard";
      default:
        return "Normal";
    }
  }
}

class Settings {
  bool useWeights = false;
  bool useBank = true;
  bool useBar = false;
  bool withOutdoor = false;
  Repetitions repetitions = Repetitions.Normal;

  bool hard() => repetitions == Repetitions.Hard;
  bool easy() => repetitions == Repetitions.Easy;

  Map<String, dynamic> toMap() {
    return {
      'useWeights': useWeights,
      'useBank': useBank,
      'useBar': useBar,
      'withOutdoor': withOutdoor,
      'Repetitions': repetitions,
    };
  }
}
