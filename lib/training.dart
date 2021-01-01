import 'exercise.dart';
import 'dart:math';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

class Training {
  List<Exercise> first = List(3);
  List<Exercise> second = List(3);
  List<Exercise> third = List(3);

  static Training gen_training(List<Exercise> exercises) {
    Training training = Training();

    // warm up/cardio
    0.to(2).forEach((pos) {
      Exercise exercise = exercises[Random().nextInt(exercises.length)];
      training.first[pos] = exercise;
    });

    // strength
    0.to(2).forEach((pos) {
      Exercise exercise = exercises[Random().nextInt(exercises.length)];
      training.second[pos] = exercise;
    });

    // mobility
    0.to(2).forEach((pos) {
      Exercise exercise = exercises[Random().nextInt(exercises.length)];
      training.third[pos] = exercise;
    });

    return training;
  }
}
