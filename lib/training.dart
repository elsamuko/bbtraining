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

  static Training fromStringList(List<Exercise> exercises, List<String> list) {
    Training training = Training();

    training.first[0] = exercises.firstWhere((element) => element.name == list[0]);
    training.first[1] = exercises.firstWhere((element) => element.name == list[1]);
    training.first[2] = exercises.firstWhere((element) => element.name == list[2]);

    training.second[0] = exercises.firstWhere((element) => element.name == list[3]);
    training.second[1] = exercises.firstWhere((element) => element.name == list[4]);
    training.second[2] = exercises.firstWhere((element) => element.name == list[5]);

    training.third[0] = exercises.firstWhere((element) => element.name == list[6]);
    training.third[1] = exercises.firstWhere((element) => element.name == list[7]);
    training.third[2] = exercises.firstWhere((element) => element.name == list[8]);

    return training;
  }

  List<String> toStringList() {
    return [
      first[0].name,
      first[1].name,
      first[2].name,
      second[0].name,
      second[1].name,
      second[2].name,
      third[0].name,
      third[1].name,
      third[2].name,
    ];
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
