#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import '../lib/training.dart';
import '../lib/exercise.dart';

int main(List<String> args) {
  if (args.isEmpty) {
    print("gen_training.dart <exercises.json>");
    return 0;
  }
  File f = File(args.first);
  String content = f.readAsStringSync();
  // print(content);

  List json = jsonDecode(content);
  List<Exercise> exercises = Exercise.fromList(json);
  Training training = Training.genTraining(exercises);
  print(training);

  return 0;
}
