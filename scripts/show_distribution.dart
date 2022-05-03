#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import 'dart:collection';

import 'package:bbtraining/settings.dart';
import 'package:bbtraining/trainings/functional.dart';
import 'package:bbtraining/exercise.dart';
import 'package:sprintf/sprintf.dart';

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
  settings.useWeights = false;
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

  final sorted = SplayTreeMap<Exercise, int>.from(countsRand, (l, r) => countsRand[l]!.compareTo(countsRand[r]!));
  sorted.forEach((key, value) {
    var c = key.isCardio() ? "C" : "_";
    var s = key.isStrength() ? "S" : "_";
    var m = key.isMobility() ? "M" : "_";
    var u = key.isUpper() ? "U" : "_";
    var l = key.isLower() ? "L" : "_";

    print(sprintf("%1i : %4i [$c$s$m$u$l] %.2f $key", [countsRef[key], value, key.weight]));
  });

  return 0;
}
