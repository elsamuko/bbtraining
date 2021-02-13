import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

takeScreenshot(FlutterDriver driver, String path) async {
  List<int> pixels = await driver.screenshot();
  File("screenshots/screenshot_$path.png").writeAsBytesSync(pixels);
  print("Screenshot saved to screenshots/screenshot_$path.png");
}

// https://medium.com/flutter-community/testing-flutter-ui-with-flutter-driver-c1583681e337
// https://flutter.dev/docs/cookbook/testing/integration/introduction
void main() {
  group('BB Training', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await Directory("screenshots").create();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('check driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test('screenshot main view', () async {
      // generate training
      await driver.tap(find.byValueKey('gen_training'));

      // screenshot
      await takeScreenshot(driver, 'main');
    });

    test('screenshot settings view', () async {
      // go to settings
      await driver.tap(find.byValueKey("show_settings"));

      // screenshot
      await takeScreenshot(driver, 'settings');

      // return
      await driver.tap(find.pageBack());
    });

    test('screenshot exercise', () async {
      // go to exercise
      await driver.tap(find.byValueKey("exercise_1"));

      // screenshot
      await takeScreenshot(driver, 'exercise');

      // return
      await driver.tap(find.pageBack());
    });
  }, timeout: Timeout(Duration(minutes: 5)));
}
