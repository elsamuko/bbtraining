import 'exercise.dart';
import 'dart:math';

typedef ExerciseCallback = bool Function(Exercise exercise);

class Requirement {
  String name;
  ExerciseCallback callback;
  Requirement(this.name, this.callback);
  String toString() => name;
  bool call(Exercise ex) => callback(ex);

  static List<Exercise> allWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = exercises.where((exercise) => requirements.every((filter) => filter(exercise))).toList();
    return filtered;
  }

  static Exercise randomWithRequirements(List<Exercise> exercises, List<Requirement> requirements) {
    List<Exercise> filtered = allWithRequirements(exercises, requirements);
    return filtered[Random().nextInt(filtered.length)];
  }
}
