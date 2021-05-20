import '../level.dart';
import '../requirement.dart';
import '../settings.dart';
import '../exercise.dart';

abstract class Training {
  List<Exercise> exercises;
  Level level = Level.Normal;

  Training(int count) {
    exercises = List.filled(count, Exercise());
  }

  bool contains(Exercise a) {
    return exercises.any((b) => a == b);
  }

  void fromStringList(List<Exercise> exercises, List<String> names) {
    for (int i = 0; i < names.length; i++) {
      Exercise exercise = exercises.firstWhere(
        (element) => element.name == names[i],
        orElse: () => Exercise(name: ""),
      );
      this.exercises[i] = exercise;
    }
  }

  List<String> toStringList() {
    return exercises.map((e) => e.name).toList();
  }

  String toString() {
    String s = "";
    exercises.forEach((exercise) {
      if (exercise.pairwise) {
        s += "2x";
      } else {
        s += "  ";
      }
      s += exercise.repsByLevel(level).toString() + " " + exercise.toString() + "\n";
    });
    return s;
  }
}
