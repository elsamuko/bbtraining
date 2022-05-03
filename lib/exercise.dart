import 'package:bbtraining/level.dart';

class Exercise {
  double weight = 1.0; // probability
  String name;
  bool enabled = true;
  int upper;
  int lower;
  int core;
  int strength;
  int cardio;
  int mobility;
  int difficulty;
  bool weights;
  bool bank;
  bool bar;
  bool floor;
  bool outdoor;
  List<String> stresses; // list of stressed body parts
  bool pairwise;
  int reps;
  String unit;
  List<String> instructions;
  int images; // available images for this exercise in res/images

  bool isUpper() => upper >= 3;

  bool isLower() => lower >= 3;

  bool isCore() => core >= 3;

  bool isStrength() => strength >= 3;

  bool isCardio() => cardio >= 3;

  bool isMobility() => mobility >= 3;

  bool isMobilityExtra() => mobility >= 4;

  bool isCoreExtra() => core >= 4;

  bool isIndoor() => !outdoor;

  bool noWeights() => !weights;

  bool noBar() => !bar;

  bool noFloor() => !floor;

  bool noBank() => !bank;

  bool sameStressAs(String stress) {
    return stresses.contains(stress);
  }

  int repsByLevel(Level level) {
    double dreps = reps.toDouble();
    if (level == Level.Hard) {
      dreps *= 1.5;
    }
    if (level == Level.Easy) {
      dreps /= 2;
    }

    return dreps.toInt();
  }

  @override
  bool operator ==(dynamic other) => this.name == other.name;

  @override
  int get hashCode => name.hashCode;

  Exercise(
      {required this.name,
      required this.upper,
      required this.lower,
      required this.core,
      required this.strength,
      required this.cardio,
      required this.mobility,
      required this.difficulty,
      required this.weights,
      required this.bank,
      required this.bar,
      required this.floor,
      required this.outdoor,
      required this.stresses,
      required this.pairwise,
      required this.reps,
      required this.unit,
      required this.instructions,
      required this.images});

  static Exercise empty() {
    return Exercise(
        name: "",
        upper: 0,
        lower: 0,
        core: 0,
        strength: 0,
        cardio: 0,
        mobility: 0,
        difficulty: 0,
        weights: false,
        bank: false,
        bar: false,
        floor: false,
        outdoor: false,
        stresses: [],
        pairwise: false,
        reps: 0,
        unit: "",
        instructions: [],
        images: 0);
  }

  @override
  String toString() => name;

  static List<Exercise> fromList(List list) {
    List<Exercise> exercises = [];
    list.forEach((data) {
      // if it's 0, type is int -> dismiss
      // if it's "shoulder knee", split
      List<String> stresses = [];
      if (data['stress'].runtimeType == "".runtimeType) {
        stresses = data['stress'].split(" ");
      }

      // if it's 0, type is int -> dismiss
      // if it's "do this; do that", split
      List<String> instructions = [];
      if (data['instructions'].runtimeType == "".runtimeType) {
        instructions = data['instructions'].split("; ");
      }

      // if it's 0, type is int -> dismiss
      // if it's "rounds", type is string
      String unit = "";
      if (data['unit'].runtimeType == "".runtimeType) {
        unit = " " + data['unit'];
      }

      Exercise exercise = Exercise(
        name: data['exercise'] ?? "",
        upper: data['upper']?.toInt() ?? 0,
        lower: data['lower']?.toInt() ?? 0,
        core: data['core']?.toInt() ?? 0,
        strength: data['strength']?.toInt() ?? 0,
        cardio: data['cardio']?.toInt() ?? 0,
        mobility: data['mobility']?.toInt() ?? 0,
        difficulty: data['difficulty']?.toInt() ?? 0,
        weights: (data['weights'] ?? 0) > 0,
        bank: (data['bank'] ?? 0) > 0,
        bar: (data['bar'] ?? 0) > 0,
        floor: (data['floor'] ?? 0) > 0,
        outdoor: (data['outdoor'] ?? 0) > 0,
        stresses: stresses,
        pairwise: (data['pairwise'] ?? 0) > 0,
        reps: data['reps']?.toInt() ?? 0,
        unit: unit,
        instructions: instructions,
        images: data['images']?.toInt() ?? 0,
      );

      exercises.add(exercise);
    });

    return exercises;
  }
}
