import 'exercise.dart';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

class Training {
  List<Exercise> first = List(3);
  List<Exercise> second = List(3);
  List<Exercise> third = List(3);

  bool contains(Exercise a) {
    return first.any((b) => a == b) || second.any((b) => a == b) || third.any((b) => a == b);
  }

  static Training genTraining(List<Exercise> exercises) {
    Training training = Training();

    Requirement lower = Requirement("lower", (Exercise exercise) => exercise.isLower());
    Requirement upper = Requirement("upper", (Exercise exercise) => exercise.isUpper());
    Requirement core = Requirement("core", (Exercise exercise) => exercise.isCore());
    Requirement cardio = Requirement("cardio", (Exercise exercise) => exercise.isCardio());
    Requirement strength = Requirement("strength", (Exercise exercise) => exercise.isStrength());
    Requirement mobility = Requirement("mobility", (Exercise exercise) => exercise.isMobility());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement toolless = Requirement("toolless", (Exercise exercise) => exercise.isToolless());
    Requirement noDuplicates = Requirement("noDuplicates", (Exercise a) => !training.contains(a));

    List<Requirement> all = [indoor, toolless, noDuplicates];

    // warm up/cardio
    training.first[0] = Exercise.randomWithRequirements(exercises, all + [cardio, lower]);
    training.first[1] = Exercise.randomWithRequirements(exercises, all + [cardio, core]);
    training.first[2] = Exercise.randomWithRequirements(exercises, all + [cardio, lower]);

    // strength
    training.second[0] = Exercise.randomWithRequirements(exercises, all + [strength, lower]);
    training.second[1] = Exercise.randomWithRequirements(exercises, all + [strength, upper]);
    training.second[2] = Exercise.randomWithRequirements(exercises, all + [strength, lower]);

    // mobility
    training.third[0] = Exercise.randomWithRequirements(exercises, all + [mobility, lower]);
    training.third[1] = Exercise.randomWithRequirements(exercises, all + [mobility, core]);
    training.third[2] = Exercise.randomWithRequirements(exercises, all + [mobility, lower]);

    return training;
  }
}
