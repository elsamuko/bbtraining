import 'package:bbtraining/views/training_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BB Training',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff111111),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: const ColorScheme.dark(
          surface: const Color(0xff007680),
          primary: Colors.white,
          primaryContainer: const Color(0xff547390),
          secondary: const Color(0xff9a007d),
        ),
      ),
      home: TrainingView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
