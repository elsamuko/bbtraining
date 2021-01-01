import 'exercise.dart';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

class Training {
  List<Exercise> first = List(3);
  List<Exercise> second = List(3);
  List<Exercise> third = List(3);

  static Training genTraining(List<Exercise> exercises) {
    Training training = Training();

    Requirement lower = Requirement("lower", (Exercise exercise) => exercise.isLower());
    Requirement upper = Requirement("upper", (Exercise exercise) => exercise.isUpper());
    Requirement core = Requirement("core", (Exercise exercise) => exercise.isCore());
    Requirement cardio = Requirement("cardio", (Exercise exercise) => exercise.isCardio());
    Requirement strength = Requirement("strength", (Exercise exercise) => exercise.isStrength());
    Requirement mobility = Requirement("mobility", (Exercise exercise) => exercise.isMobility());

    // warm up/cardio
    training.first[0] = Exercise.randomWithRequirements(exercises, [cardio, lower]);
    training.first[1] = Exercise.randomWithRequirements(exercises, [cardio, core]);
    training.first[2] = Exercise.randomWithRequirements(exercises, [cardio, lower]);

    // strength
    training.second[0] = Exercise.randomWithRequirements(exercises, [strength, lower]);
    training.second[1] = Exercise.randomWithRequirements(exercises, [strength, upper]);
    training.second[2] = Exercise.randomWithRequirements(exercises, [strength, lower]);

    // mobility
    training.third[0] = Exercise.randomWithRequirements(exercises, [mobility, lower]);
    training.third[1] = Exercise.randomWithRequirements(exercises, [mobility, core]);
    training.third[2] = Exercise.randomWithRequirements(exercises, [mobility, lower]);

    return training;
  }
}
