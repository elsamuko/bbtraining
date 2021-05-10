import '../level.dart';
import '../requirement.dart';
import '../settings.dart';
import '../exercise.dart';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

class FunctionalTraining {
  List<Exercise> exercises = List.filled(9, Exercise());
  Level level = Level.Normal;

  bool contains(Exercise a) {
    return exercises.any((b) => a == b);
  }

  static FunctionalTraining fromStringList(List<Exercise> exercises, List<String> names) {
    FunctionalTraining training = FunctionalTraining();

    for (int i = 0; i < names.length; i++) {
      Exercise exercise = exercises.firstWhere(
        (element) => element.name == names[i],
        orElse: () => Exercise(name: ""),
      );
      training.exercises[i] = exercise;
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
      if (exercise.pairwise) {
        s += "2x";
      } else {
        s += "  ";
      }
      s += exercise.repsByLevel(level).toString() + " " + exercise.toString() + "\n";
      if (++i % 3 == 0) {
        s += "\n";
      }
    });
    return s;
  }

  static FunctionalTraining genTraining(List<Exercise> exercises, Settings settings) {
    FunctionalTraining training = FunctionalTraining();
    training.level = settings.level;

    Requirement lower = Requirement("lower", (Exercise exercise) => exercise.isLower());
    Requirement upper = Requirement("upper", (Exercise exercise) => exercise.isUpper());
    Requirement core = Requirement("core", (Exercise exercise) => exercise.isCore());
    Requirement cardio = Requirement("cardio", (Exercise exercise) => exercise.isCardio());
    Requirement strength = Requirement("strength", (Exercise exercise) => exercise.isStrength());
    Requirement mobility = Requirement("mobility", (Exercise exercise) => exercise.isMobility());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement noWeights = Requirement("noWeights", (Exercise exercise) => exercise.noWeights());
    Requirement noBar = Requirement("noBar", (Exercise exercise) => exercise.noBar());
    Requirement noFloor = Requirement("noFloor", (Exercise exercise) => exercise.noFloor());
    Requirement noBank = Requirement("noBank", (Exercise exercise) => exercise.noBank());
    Requirement noDuplicates = Requirement("noDuplicates", (Exercise a) => !training.contains(a));

    Requirement onlyEnabled = Requirement("onlyEnabled", (Exercise a) => a.enabled);

    // check, if previous exercise does not stress the same body part
    Function noDoubleStress = (int pos) {
      return Requirement("noDoubleStress",
          (Exercise a) => !a.stress.any((part) => training.exercises[pos].stress.any((other) => part == other)));
    };

    List<Requirement> all = [onlyEnabled, noDuplicates];

    if (!settings.withOutdoor) {
      all.add(indoor);
    }
    if (!settings.useWeights) {
      all.add(noWeights);
    }
    if (!settings.useBar) {
      all.add(noBar);
    }
    if (!settings.useBank) {
      all.add(noBank);
    }
    if (!settings.useFloor) {
      all.add(noFloor);
    }

    // warm up/cardio
    training.exercises[0] = Requirement.randomWithRequirements(exercises, all + [cardio, lower]);
    training.exercises[1] = Requirement.randomWithRequirements(exercises, all + [cardio, core, noDoubleStress(0)]);
    training.exercises[2] = Requirement.randomWithRequirements(exercises, all + [cardio, lower, noDoubleStress(1)]);

    // strength
    training.exercises[3] = Requirement.randomWithRequirements(exercises, all + [strength, lower, noDoubleStress(2)]);
    training.exercises[4] = Requirement.randomWithRequirements(exercises, all + [strength, upper, noDoubleStress(3)]);
    training.exercises[5] = Requirement.randomWithRequirements(exercises, all + [strength, lower, noDoubleStress(4)]);

    // mobility
    training.exercises[6] = Requirement.randomWithRequirements(exercises, all + [mobility, lower, noDoubleStress(5)]);
    training.exercises[7] = Requirement.randomWithRequirements(exercises, all + [mobility, core, noDoubleStress(6)]);
    training.exercises[8] = Requirement.randomWithRequirements(exercises, all + [mobility, lower, noDoubleStress(7)]);

    return training;
  }

  // print all exercises, which fulfill current requirements
  // run with latest exercises:
  // scripts/gen_json.py res/exercises.ods > res/exercises.json
  static void dumpFiltered(List<Exercise> exercises) {
    Requirement lower = Requirement("lower", (Exercise exercise) => exercise.isLower());
    Requirement upper = Requirement("upper", (Exercise exercise) => exercise.isUpper());
    Requirement core = Requirement("core", (Exercise exercise) => exercise.isCore());
    Requirement cardio = Requirement("cardio", (Exercise exercise) => exercise.isCardio());
    Requirement strength = Requirement("strength", (Exercise exercise) => exercise.isStrength());
    Requirement mobility = Requirement("mobility", (Exercise exercise) => exercise.isMobility());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement toolless = Requirement("toolless", (Exercise exercise) => exercise.noBar() && exercise.noWeights());

    List<Requirement> all = [];

    Function printer = (List<Requirement> requirements) {
      print(requirements);
      Requirement.allWithRequirements(exercises, requirements).forEach((element) {
        print("    $element");
      });
    };

    printer(all + [cardio, lower]);
    printer(all + [cardio, upper]);
    print("");

    printer(all + [strength, lower]);
    printer(all + [strength, upper]);
    print("");

    printer(all + [mobility, lower]);
    printer(all + [mobility, upper]);
    print("");
  }
}
