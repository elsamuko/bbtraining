import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'exercise.dart';
import 'training.dart';
import 'settings.dart';

class Persistence {
  //! \returns list of exercises from internal json
  static Future<List<Exercise>> getExercises() async {
    ByteData bytes = await rootBundle.load("res/exercises.json");
    String string = utf8.decode(bytes.buffer.asUint8List());
    List json = jsonDecode(string);
    return Exercise.fromList(json);
  }

  //! loads previous training from prefs
  static Future<Training> getTraining(List<Exercise> exercises) async {
    if (exercises == null) return null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> persisted = prefs.getStringList('exercises') ?? [];

    if (persisted.isNotEmpty) {
      return Training.fromStringList(exercises, persisted);
    } else {
      return null;
    }
  }

  static Future<void> setTraining(Training training) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("exercises", training.toStringList());
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
