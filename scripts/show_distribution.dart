#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

import '../lib/settings.dart';
import '../lib/trainings/functional.dart';
import '../lib/exercise.dart';

int main(List<String> args) {
  if (args.isEmpty) {
    print("show_distribution.dart <exercises.json>");
    return 0;
  }
  File f = File(args.first);
  String content = f.readAsStringSync();
  List json = jsonDecode(content);
  List<Exercise> exercises = Exercise.fromList(json);
  Map<Exercise, int> counts_rand = {};
  Map<Exercise, int> counts_ref = {};
  exercises.forEach((e) {
    counts_rand[e] = 0;
    counts_ref[e] = 0;
  });
  Settings settings = Settings();
  settings.useWeights = true;
  settings.useBar = true;
  settings.withOutdoor = true;

  List<Exercise> collected = FunctionalTraining.dumpFiltered(exercises);
  collected.forEach((e) {
    counts_ref[e] += 1;
  });

  for (int i = 0; i < 10000; ++i) {
    FunctionalTraining training = FunctionalTraining.genTraining(exercises, settings);
    training.exercises.forEach((e) {
      counts_rand[e] += 1;
    });
  }

  counts_rand.forEach((key, value) {
    print("${counts_ref[key]} : $value $key");
  });

  return 0;
}
