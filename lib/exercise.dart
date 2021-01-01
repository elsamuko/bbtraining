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
  int endurance;
  int mobility;
  int difficulty;
  bool weights;
  bool bank;
  bool bar;
  bool outdoor;

  bool isUpper() => upper >= 5;

  bool isLower() => lower >= 5;

  bool isCore() => core >= 5;

  bool isStrength() => strength >= 5;

  bool isCardio() => cardio >= 5;

  bool isMobility() => mobility >= 5;

  Exercise(
      {this.name,
      this.upper,
      this.lower,
      this.core,
      this.strength,
      this.cardio,
      this.endurance,
      this.mobility,
      this.difficulty,
      this.weights,
      this.bank,
      this.bar,
      this.outdoor});

  String toString() => name;

  static Exercise randomWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = exercises.where((exercise) => requirements.every((filter) => filter(exercise))).toList();
    return filtered[Random().nextInt(filtered.length)];
  }

  static List<Exercise> fromList(List list) {
    List<Exercise> exercises = [];
    list.forEach((data) {
      Exercise exercise = Exercise(
          name: data['exercise'] ?? "",
          upper: data['upper']?.toInt() ?? 0,
          lower: data['lower']?.toInt() ?? 0,
          core: data['core']?.toInt() ?? 0,
          strength: data['strength']?.toInt() ?? 0,
          cardio: data['cardio']?.toInt() ?? 0,
          endurance: data['endurance']?.toInt() ?? 0,
          mobility: data['mobility']?.toInt() ?? 0,
          difficulty: data['difficulty']?.toInt() ?? 0,
          weights: (data['weights'] ?? 0) > 0,
          bank: (data['bank'] ?? 0) > 0,
          bar: (data['bar'] ?? 0) > 0,
          outdoor: (data['outdoor'] ?? 0) > 0);
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
        endurance: data['endurance'] ?? 0,
        mobility: data['mobility'] ?? 0,
        difficulty: data['difficulty'] ?? 0,
        weights: data['weights'] ?? false,
        bank: data['bank'] ?? false,
        bar: data['bar'] ?? false,
        outdoor: data['outdoor'] ?? false);
    return exercise;
  }
}
