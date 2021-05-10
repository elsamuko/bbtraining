import 'level.dart';

class Exercise {
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
  List<String> stress; // list of stressed body parts
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

  bool isIndoor() => !outdoor;

  bool noWeights() => !weights;

  bool noBar() => !bar;

  bool noFloor() => !floor;

  bool noBank() => !bank;

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
      {this.name,
      this.upper,
      this.lower,
      this.core,
      this.strength,
      this.cardio,
      this.mobility,
      this.difficulty,
      this.weights,
      this.bank,
      this.bar,
      this.floor,
      this.outdoor,
      this.stress,
      this.pairwise = false,
      this.reps = 10,
      this.unit,
      this.instructions,
      this.images});

  String toString() => name;

  static List<Exercise> fromList(List list) {
    List<Exercise> exercises = [];
    list.forEach((data) {
      // if it's 0, type is int -> dismiss
      // if it's "shoulder knee", split
      List<String> stress = [];
      if (data['stress'].runtimeType == "".runtimeType) {
        stress = data['stress'].split(" ");
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
        unit = data['unit'];
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
        stress: stress,
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
