import 'dart:math';

import 'level.dart';

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
  bool pairwise;
  int reps;
  String unit;

  bool isUpper() => upper >= 3;

  bool isLower() => lower >= 3;

  bool isCore() => core >= 3;

  bool isStrength() => strength >= 3;

  bool isCardio() => cardio >= 3;

  bool isMobility() => mobility >= 3;

  bool isIndoor() => !outdoor;

  bool noWeights() => !weights;

  bool noBar() => !bar;

  bool noBank() => !bank;

  int repsByLevel(Level level) {
    double dreps = reps.toDouble();
    if (level == Level.Hard) {
      dreps *= 1.5;
    }
    if (level == Level.Easy) {
      dreps *= 1.5;
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
      this.outdoor,
      this.stress,
      this.pairwise,
      this.reps,
      this.unit});

  String toString() => name;

  static List<Exercise> allWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = exercises.where((exercise) => requirements.every((filter) => filter(exercise))).toList();
    return filtered;
  }

  static Exercise randomWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = allWithRequirements(exercises, requirements);
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
        outdoor: (data['outdoor'] ?? 0) > 0,
        stress: stress,
        pairwise: (data['pairwise'] ?? 0) > 0,
        reps: data['reps']?.toInt() ?? 0,
        unit: unit,
      );

      exercises.add(exercise);
    });

    return exercises;
  }
}
