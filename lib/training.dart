import 'exercise.dart';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

class Training {
  List<Exercise> exercises = List(9);

  bool contains(Exercise a) {
    return exercises.any((b) => a == b);
  }

  static Training fromStringList(List<Exercise> exercises, List<String> list) {
    Training training = Training();

    for (int i = 0; i < exercises.length; i++) {
      training.exercises[i] = exercises.firstWhere((element) => element.name == list[i]);
    }

    return training;
  }

  List<String> toStringList() {
    return exercises.map((e) => e.name).toList();
  }

  String toString() {
    String s = "";
    int i = 0;
    exercises.forEach((exercise) {
      s += exercise.toString() + "\n";
      if (++i % 3 == 0) {
        s += "\n";
      }
    });
    return s;
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

    // check, if previous exercise does not stress the same body part
    Function noDoubleStress = (int pos) {
      return Requirement("noDoubleStress",
          (Exercise a) => !a.stress.any((part) => training.exercises[pos].stress.any((other) => part == other)));
    };

    List<Requirement> all = [indoor, toolless, noDuplicates];

    // warm up/cardio
    training.exercises[0] = Exercise.randomWithRequirements(exercises, all + [cardio, lower]);
    training.exercises[1] = Exercise.randomWithRequirements(exercises, all + [cardio, core, noDoubleStress(0)]);
    training.exercises[2] = Exercise.randomWithRequirements(exercises, all + [cardio, lower, noDoubleStress(1)]);

    // strength
    training.exercises[3] = Exercise.randomWithRequirements(exercises, all + [strength, lower, noDoubleStress(2)]);
    training.exercises[4] = Exercise.randomWithRequirements(exercises, all + [strength, upper, noDoubleStress(3)]);
    training.exercises[5] = Exercise.randomWithRequirements(exercises, all + [strength, lower, noDoubleStress(4)]);

    // mobility
    training.exercises[6] = Exercise.randomWithRequirements(exercises, all + [mobility, lower, noDoubleStress(5)]);
    training.exercises[7] = Exercise.randomWithRequirements(exercises, all + [mobility, core, noDoubleStress(6)]);
    training.exercises[8] = Exercise.randomWithRequirements(exercises, all + [mobility, lower, noDoubleStress(7)]);

    return training;
  }
}
