import '../level.dart';
import '../requirement.dart';
import '../settings.dart';
import '../exercise.dart';
import 'training.dart';

class FunctionalTraining extends Training {
  FunctionalTraining() : super(9, 3);

  String get name => "functional_training";
  String get beautyName => "Functional Training";

  static FunctionalTraining from(List<Exercise> exercises, List<String> names) {
    FunctionalTraining training = FunctionalTraining();
    training.fromStringList(exercises, names);
    return training;
  }

  void genRequirements(Settings settings) {
    Requirement lower = Requirement("lower", (Exercise exercise) => exercise.isLower());
    Requirement upper = Requirement("upper", (Exercise exercise) => exercise.isUpper());
    Requirement cardio = Requirement("cardio", (Exercise exercise) => exercise.isCardio());
    Requirement strength = Requirement("strength", (Exercise exercise) => exercise.isStrength());
    Requirement mobility = Requirement("mobility", (Exercise exercise) => exercise.isMobility());

    Requirement indoor = Requirement("indoor", (Exercise exercise) => exercise.isIndoor());
    Requirement noWeights = Requirement("noWeights", (Exercise exercise) => exercise.noWeights());
    Requirement noBar = Requirement("noBar", (Exercise exercise) => exercise.noBar());
    Requirement noFloor = Requirement("noFloor", (Exercise exercise) => exercise.noFloor());
    Requirement noBank = Requirement("noBank", (Exercise exercise) => exercise.noBank());
    Requirement noDuplicates = Requirement("noDuplicates", (Exercise a) => !contains(a));

    Requirement onlyEnabled = Requirement("onlyEnabled", (Exercise a) => a.enabled);

    // check, if previous exercise does not stress the same body part
    Function noDoubleStress = (int pos) {
      return Requirement("noDoubleStress",
          (Exercise a) => !a.stress.any((part) => exercises[pos].stress.any((other) => part == other)));
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
    requirements[0] = all + [cardio, lower];
    requirements[1] = all + [cardio, upper, noDoubleStress(0)];
    requirements[2] = all + [cardio, lower, noDoubleStress(1)];

    // strength
    requirements[3] = all + [strength, lower, noDoubleStress(2)];
    requirements[4] = all + [strength, upper, noDoubleStress(3)];
    requirements[5] = all + [strength, lower, noDoubleStress(4)];

    // mobility
    requirements[6] = all + [mobility, lower, noDoubleStress(5)];
    requirements[7] = all + [mobility, upper, noDoubleStress(6)];
    requirements[8] = all + [mobility, lower, noDoubleStress(7)];
  }

  static FunctionalTraining genTraining(List<Exercise> exercises, Settings settings) {
    FunctionalTraining training = FunctionalTraining();
    training.gen(exercises, settings);
    return training;
  }

  // print all exercises, which fulfill current requirements
  // run with latest exercises:
  // scripts/gen_json.py res/exercises.ods > res/exercises.json
  static void dumpFiltered(List<Exercise> exercises) {
    Requirement lower = Requirement("lower", (Exercise exercise) => exercise.isLower());
    Requirement upper = Requirement("upper", (Exercise exercise) => exercise.isUpper());
    Requirement cardio = Requirement("cardio", (Exercise exercise) => exercise.isCardio());
    Requirement strength = Requirement("strength", (Exercise exercise) => exercise.isStrength());
    Requirement mobility = Requirement("mobility", (Exercise exercise) => exercise.isMobility());

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
