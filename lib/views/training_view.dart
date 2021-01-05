import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../training.dart';
import '../exercise.dart';

class TrainingView extends StatefulWidget {
  TrainingView({Key key}) : super(key: key);

  @override
  TrainingViewState createState() => TrainingViewState();
}

class TrainingViewState extends State<TrainingView> {
  Training training;
  List<Exercise> exercises;

  @override
  void initState() {
    rootBundle.load("res/exercises.json").then((bytes) {
      String string = utf8.decode(bytes.buffer.asUint8List());
      List json = jsonDecode(string);
      exercises = Exercise.fromList(json);
      SharedPreferences.getInstance().then((prefs) {
        List<String> persisted = prefs.getStringList('exercises') ?? [];
        if (persisted.isNotEmpty) {
          training = Training.fromStringList(exercises, persisted);
        }
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widgets;

    if (training != null) {
      widgets = Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(training.exercises[0].toString()),
            Text(training.exercises[1].toString()),
            Text(training.exercises[2].toString()),
            SizedBox(height: 12),
            Text(training.exercises[3].toString()),
            Text(training.exercises[4].toString()),
            Text(training.exercises[5].toString()),
            SizedBox(height: 12),
            Text(training.exercises[6].toString()),
            Text(training.exercises[7].toString()),
            Text(training.exercises[8].toString()),
          ],
        ),
      );
    } else {
      widgets = Text("Hello");
    }

    Row bottomButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () async {
            training = Training.genTraining(exercises);
            var prefs = await SharedPreferences.getInstance();
            prefs.setStringList("exercises", training.toStringList());
            setState(() {});
          },
          child: Text("Training"),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Burpeebären Training"),
      ),
      body: Center(
        child: widgets,
      ),
      bottomNavigationBar: bottomButtons,
    );
  }
}
