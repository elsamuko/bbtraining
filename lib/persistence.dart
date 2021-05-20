import 'dart:convert';
import 'package:bbtraining/trainings/mobility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'exercise.dart';
import 'trainings/functional.dart';
import 'settings.dart';

class Persistence {
  //! \returns list of exercises from internal json
  static Future<List<Exercise>> getExercises() async {
    ByteData bytes = await rootBundle.load("res/exercises.json");
    String string = utf8.decode(bytes.buffer.asUint8List());
    List json = jsonDecode(string);

    List<Exercise> exercises = Exercise.fromList(json);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> persisted = prefs.getStringList('disabled_exercises') ?? [];

    persisted.forEach((name) {
      exercises.forEach((exercise) {
        if (exercise.name == name) {
          exercise.enabled = false;
        }
      });
    });

    return exercises;
  }

  static Future<void> setExercises(List<Exercise> exercises) async {
    List<String> filtered = exercises.where((exercise) => !exercise.enabled).map((e) => e.name).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("disabled_exercises", filtered);
  }

  //! loads previous training from prefs
  static Future<FunctionalTraining> getTraining(List<Exercise> exercises) async {
    if (exercises == null) return null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> persisted = prefs.getStringList('functional_training') ?? [];

    if (persisted.isNotEmpty) {
      return FunctionalTraining.from(exercises, persisted);
    } else {
      return null;
    }
  }

  //! loads previous mobility training from prefs
  static Future<MobilityTraining> getMobilityTraining(List<Exercise> exercises) async {
    if (exercises == null) return null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> persisted = prefs.getStringList('mobility_training') ?? [];

    if (persisted.isNotEmpty) {
      return MobilityTraining.from(exercises, persisted);
    } else {
      return null;
    }
  }

  static Future<void> setTraining(FunctionalTraining training) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("functional_training", training.toStringList());
  }

  static Future<void> setMobilityTraining(MobilityTraining training) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("mobility_training", training.toStringList());
  }

  static Future<Settings> getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('settings');
    if (json == null) return Settings();
    Map<String, dynamic> map = jsonDecode(json);
    return Settings.fromMap(map);
  }

  static Future<void> setSettings(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("settings", jsonEncode(settings));
  }
}
