import 'dart:convert';

import 'package:bbtraining/level.dart';
import 'package:bbtraining/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('IO', () {
    Settings settings = Settings();
    settings.useFloor = false;
    settings.useBar = true;

    // parse toMap back to cluster
    Map<String, dynamic> m = settings.toMap();
    Settings settings2 = Settings.fromMap(m);
    expect(settings, settings2);

    // parse toJSON back to cluster
    String json = jsonEncode(settings);
    Map<String, dynamic> m2 = jsonDecode(json);
    Settings settings3 = Settings.fromMap(m2);
    expect(settings, settings3);
  });
}
