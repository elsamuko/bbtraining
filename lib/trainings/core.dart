import '../requirement.dart';
import '../settings.dart';
import '../exercise.dart';
import 'training.dart';

class CoreTraining extends Training {
  CoreTraining() : super(3, 0);

  String get name => "core_training";

  static CoreTraining from(List<Exercise> exercises, List<String> names) {
    CoreTraining training = CoreTraining();
    training.fromStringList(exercises, names);
    return training;
  }

  static CoreTraining genTraining(List<Exercise> exercises, Settings settings) {
    CoreTraining training = CoreTraining();
    training.level = settings.level;

    Requirement coreExtra = Requirement("coreExtra", (Exercise exercise) => exercise.isCoreExtra());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement noWeights = Requirement("noWeights", (Exercise exercise) => exercise.noWeights());
    Requirement noBar = Requirement("noBar", (Exercise exercise) => exercise.noBar());
    Requirement noFloor = Requirement("noFloor", (Exercise exercise) => exercise.noFloor());
    Requirement noBank = Requirement("noBank", (Exercise exercise) => exercise.noBank());
    Requirement noDuplicates = Requirement("noDuplicates", (Exercise a) => !training.contains(a));

    Requirement onlyEnabled = Requirement("onlyEnabled", (Exercise a) => a.enabled);

    List<Requirement> all = [onlyEnabled, noDuplicates, coreExtra, indoor, noWeights, noBar];

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
    Requirement coreExtra = Requirement("coreExtra", (Exercise exercise) => exercise.isCoreExtra());

    List<Requirement> all = [];

    Function printer = (List<Requirement> requirements) {
      print(requirements);
      Requirement.allWithRequirements(exercises, requirements).forEach((element) {
        print("    $element");
      });
    };

    printer(all + [coreExtra]);
    print("");
  }
}
