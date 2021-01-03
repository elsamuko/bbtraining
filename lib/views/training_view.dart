import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = null;

    if (training != null) {
      widgets = Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(training.first[0].toString()),
            Text(training.first[1].toString()),
            Text(training.first[2].toString()),
            SizedBox(height: 12),
            Text(training.second[0].toString()),
            Text(training.second[1].toString()),
            Text(training.second[2].toString()),
            SizedBox(height: 12),
            Text(training.third[0].toString()),
            Text(training.third[1].toString()),
            Text(training.third[2].toString()),
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
