import 'package:bbtraining/requirement.dart';
import 'package:bbtraining/settings.dart';
import 'package:bbtraining/exercise.dart';
import 'package:bbtraining/trainings/training.dart';

class CoreTraining extends Training {
  CoreTraining() : super(3, 0);

  @override
  String get name => "core_training";
  @override
  String get beautyName => "Core Training";

  static CoreTraining from(List<Exercise> exercises, List<String> names) {
    CoreTraining training = CoreTraining();
    training.fromStringList(exercises, names);
    return training;
  }

  @override
  List<double> getWeights(List<Exercise> exercises) {
    return List<double>.filled(exercises.length, 1.0);
  }

  @override
  void genRequirements(Settings settings) {
    Requirement coreExtra = Requirement("coreExtra", (Exercise exercise) => exercise.isCoreExtra());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement noWeights = Requirement("noWeights", (Exercise exercise) => exercise.noWeights());
    Requirement noBar = Requirement("noBar", (Exercise exercise) => exercise.noBar());
    Requirement noFloor = Requirement("noFloor", (Exercise exercise) => exercise.noFloor());
    Requirement noBank = Requirement("noBank", (Exercise exercise) => exercise.noBank());
    Requirement noDuplicates = Requirement("noDuplicates", (Exercise a) => !contains(a));

    Requirement onlyEnabled = Requirement("onlyEnabled", (Exercise a) => a.enabled);

    List<Requirement> all = [onlyEnabled, noDuplicates, coreExtra, indoor, noWeights, noBar];

    if (!settings.useBank) {
      all.add(noBank);
    }
    if (!settings.useFloor) {
      all.add(noFloor);
    }

    for (int i = 0; i < exercises.length; ++i) {
      requirements[i] = all;
    }
  }

  static CoreTraining genTraining(List<Exercise> exercises, Settings settings) {
    CoreTraining training = CoreTraining();
    training.gen(exercises, settings);
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
