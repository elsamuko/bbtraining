import 'package:bbtraining/exercise.dart';
import 'dart:math';
import 'package:bbtraining/log.dart';
import 'package:dart_random_choice/dart_random_choice.dart';

typedef ExerciseCallback = bool Function(Exercise exercise);

class Requirement {
  String name;
  ExerciseCallback callback;
  Requirement(this.name, this.callback);
  @override
  String toString() => name;
  bool call(Exercise ex) => callback(ex);
  static Random random = Random();

  static List<Exercise> allWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = exercises.where((exercise) => requirements.every((filter) => filter(exercise))).toList();
    return filtered;
  }

  static Exercise randomWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = allWithRequirements(exercises, requirements);

    // ensure, filtered list is not empty by dropping requirements
    while (filtered.length == 0) {
      log("no exercise with these requirements, dropping last requirement ${requirements.last}");
      requirements.removeLast();
      filtered = allWithRequirements(exercises, requirements);
    }

    List<double> weights = filtered.map((e) => e.weight).toList();
    return randomChoice(filtered, weights);
  }
}
