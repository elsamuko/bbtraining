import '../level.dart';
import '../requirement.dart';
import '../settings.dart';
import '../exercise.dart';

abstract class Training {
  List<Exercise> exercises;
  List<List<Requirement>> requirements; // requirements for each exercise
  Level level = Level.Normal;
  int separatedAt;

  Training(int count, this.separatedAt) {
    exercises = List.filled(count, Exercise());
    requirements = List.filled(count, []);
  }

  String get name;
  String get beautyName;

  bool contains(Exercise a) {
    return exercises.any((b) => a == b);
  }

  void genRequirements(Settings settings);

  void gen(List<Exercise> exercises, Settings settings) {
    genRequirements(settings);
    level = settings.level;

    for (int i = 0; i < this.exercises.length; ++i) {
      this.exercises[i] = Requirement.randomWithRequirements(exercises, requirements[i]);
    }
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
    int i = 0;
    exercises.forEach((exercise) {
      if (exercise.pairwise) {
        s += "2x";
      } else {
        s += "  ";
      }
      s += exercise.repsByLevel(level).toString() + " " + exercise.toString() + "\n";
      if (separatedAt > 0) {
        if (++i % separatedAt == 0) {
          s += "\n";
        }
      }
    });
    return s;
  }
}
