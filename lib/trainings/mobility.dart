import '../level.dart';
import '../requirement.dart';
import '../settings.dart';
import '../exercise.dart';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

class MobilityTraining {
  List<Exercise> exercises = List.filled(5, Exercise());

  Level level = Level.Normal;

  bool contains(Exercise a) {
    return exercises.any((b) => a == b);
  }

  static MobilityTraining fromStringList(List<Exercise> exercises, List<String> names) {
    MobilityTraining training = MobilityTraining();

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
    exercises.forEach((exercise) {
      if (exercise.pairwise) {
        s += "2x";
      } else {
        s += "  ";
      }
      s += exercise.repsByLevel(level).toString() + " " + exercise.toString() + "\n";
    });
    return s;
  }

  static MobilityTraining genTraining(List<Exercise> exercises, Settings settings) {
    MobilityTraining training = MobilityTraining();
    training.level = settings.level;

    Requirement mobilityExtra = Requirement("mobilityExtra", (Exercise exercise) => exercise.isMobilityExtra());

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

    List<Requirement> all = [onlyEnabled, noDuplicates, mobilityExtra, indoor, noWeights, noBar];

    if (!settings.useBank) {
      all.add(noBank);
    }
    if (!settings.useFloor) {
      all.add(noFloor);
    }

    for (int i = 0; i < training.exercises.length; ++i) {
      training.exercises[i] = Requirement.randomWithRequirements(exercises, all);
    }

    return training;
  }

  // print all exercises, which fulfill current requirements
  // run with latest exercises:
  // scripts/gen_json.py res/exercises.ods > res/exercises.json
  static void dumpFiltered(List<Exercise> exercises) {
    Requirement mobilityExtra = Requirement("mobilityExtra", (Exercise exercise) => exercise.isMobilityExtra());

    List<Requirement> all = [];

    Function printer = (List<Requirement> requirements) {
      print(requirements);
      Requirement.allWithRequirements(exercises, requirements).forEach((element) {
        print("    $element");
      });
    };

    printer(all + [mobilityExtra]);
  }
}
