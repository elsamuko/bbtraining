import 'dart:math';

typedef ExerciseCallback = bool Function(Exercise exercise);

class Requirement {
  String name;
  ExerciseCallback callback;
  Requirement(this.name, this.callback);
  String toString() => name;
  bool call(Exercise ex) => callback(ex);
}

class Exercise {
  String name;
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
  bool outdoor;
  List<String> stress; // list of stressed body parts

  bool isUpper() => upper >= 5;

  bool isLower() => lower >= 5;

  bool isCore() => core >= 5;

  bool isStrength() => strength >= 5;

  bool isCardio() => cardio >= 5;

  bool isMobility() => mobility >= 5;

  bool isIndoor() => !outdoor;

  bool isToolless() => !bank && !bar && !weights;

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
      this.outdoor,
      this.stress});

  String toString() => name;

  static Exercise randomWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = exercises.where((exercise) => requirements.every((filter) => filter(exercise))).toList();
    return filtered[Random().nextInt(filtered.length)];
  }

  static List<Exercise> fromList(List list) {
    List<Exercise> exercises = [];
    list.forEach((data) {
      // if it's 0, type is int -> dismiss
      // if it's "shoulder knee", split
      List<String> stress = [];
      if (data['stress'].runtimeType == "".runtimeType) {
        stress = data['stress'].split(" ");
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
          outdoor: (data['outdoor'] ?? 0) > 0,
          stress: stress);
      exercises.add(exercise);
    });
    return exercises;
  }

  static Exercise fromMap(Map<String, dynamic> data) {
    Exercise exercise = Exercise(
        name: data['name'] ?? "",
        upper: data['upper'] ?? 0,
        lower: data['lower'] ?? 0,
        core: data['core'] ?? 0,
        strength: data['strength'] ?? 0,
        cardio: data['cardio'] ?? 0,
        mobility: data['mobility'] ?? 0,
        difficulty: data['difficulty'] ?? 0,
        weights: data['weights'] ?? false,
        bank: data['bank'] ?? false,
        bar: data['bar'] ?? false,
        outdoor: data['outdoor'] ?? false);
    return exercise;
  }
}
