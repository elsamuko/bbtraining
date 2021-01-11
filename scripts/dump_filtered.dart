#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import '../lib/training.dart';
import '../lib/exercise.dart';

extension RangeExtension on int {
  List<int> to(int to) => [for (int i = this; i <= to; i++) i];
}

int main(List<String> args) {
  if (args.isEmpty) {
    print("dump_filtered.dart <exercises.json>");
    return 0;
  }
  File f = File(args.first);
  String content = f.readAsStringSync();
  // print(content);

  List json = jsonDecode(content);
  List<Exercise> exercises = Exercise.fromList(json);
  Training.dumpFiltered(exercises);

  return 0;
}
