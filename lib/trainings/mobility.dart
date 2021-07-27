import 'package:bbtraining/requirement.dart';
import 'package:bbtraining/settings.dart';
import 'package:bbtraining/exercise.dart';
import 'package:bbtraining/trainings/training.dart';

class MobilityTraining extends Training {
  MobilityTraining() : super(5, 0);

  String get name => "mobility_training";
  String get beautyName => "Mobility Training";

  static MobilityTraining from(List<Exercise> exercises, List<String> names) {
    MobilityTraining training = MobilityTraining();
    training.fromStringList(exercises, names);
    return training;
  }

  void genRequirements(Settings settings) {
    Requirement mobilityExtra = Requirement("mobilityExtra", (Exercise exercise) => exercise.isMobilityExtra());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement noWeights = Requirement("noWeights", (Exercise exercise) => exercise.noWeights());
    Requirement noBar = Requirement("noBar", (Exercise exercise) => exercise.noBar());
    Requirement noFloor = Requirement("noFloor", (Exercise exercise) => exercise.noFloor());
    Requirement noBank = Requirement("noBank", (Exercise exercise) => exercise.noBank());
    Requirement noDuplicates = Requirement("noDuplicates", (Exercise a) => !contains(a));

    Requirement onlyEnabled = Requirement("onlyEnabled", (Exercise a) => a.enabled);

    List<Requirement> all = [onlyEnabled, noDuplicates, mobilityExtra, indoor, noWeights, noBar];

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

  static MobilityTraining genTraining(List<Exercise> exercises, Settings settings) {
    MobilityTraining training = MobilityTraining();
    training.gen(exercises, settings);
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
    print("");
  }
}
