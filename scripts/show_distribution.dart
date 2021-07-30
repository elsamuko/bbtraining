#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

import 'package:bbtraining/settings.dart';
import 'package:bbtraining/trainings/functional.dart';
import 'package:bbtraining/exercise.dart';

int main(List<String> args) {
  if (args.isEmpty) {
    print("show_distribution.dart <exercises.json>");
    return 0;
  }
  File f = File(args.first);
  String content = f.readAsStringSync();
  List json = jsonDecode(content);
  List<Exercise> exercises = Exercise.fromList(json);
  Map<Exercise, int> countsRand = {};
  Map<Exercise, int> countsRef = {};
  exercises.forEach((e) {
    countsRand[e] = 0;
    countsRef[e] = 0;
  });
  Settings settings = Settings();
  settings.useWeights = true;
  settings.useBar = true;
  settings.withOutdoor = true;

  List<Exercise> collected = FunctionalTraining.dumpFiltered(exercises);
  collected.forEach((e) {
    countsRef.update(e, (value) => value + 1);
  });

  for (int i = 0; i < 10000; ++i) {
    FunctionalTraining training = FunctionalTraining.genTraining(exercises, settings);
    training.exercises.forEach((e) {
      countsRand.update(e, (value) => value + 1);
    });
  }

  countsRand.forEach((key, value) {
    print("${countsRef[key]} : $value $key");
  });

  return 0;
}
