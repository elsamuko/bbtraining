#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

import '../lib/settings.dart';
import '../lib/trainings/functional.dart';
import '../lib/trainings/core.dart';
import '../lib/trainings/mobility.dart';
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
  Settings settings = Settings();
  FunctionalTraining training = FunctionalTraining.genTraining(exercises, settings);
  print(training);
  MobilityTraining mobility = MobilityTraining.genTraining(exercises, settings);
  print(mobility);
  CoreTraining core = CoreTraining.genTraining(exercises, settings);
  print(core);

  return 0;
}
