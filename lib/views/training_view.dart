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

enum ExercisePosition { Top, Center, Bottom }

class TrainingViewState extends State<TrainingView> {
  Training training;
  List<Exercise> exercises;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  SizedBox _exerciseButton(Exercise exercise, ExercisePosition position) {
    BorderRadius radius;
    switch (position) {
      case ExercisePosition.Top:
        radius = BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10));
        break;
      case ExercisePosition.Center:
        radius = BorderRadius.zero;
        break;
      case ExercisePosition.Bottom:
        radius = BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
        break;
    }

    return SizedBox(
        width: 280,
        child: FlatButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.symmetric(vertical: 18),
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
          color: Theme.of(context).accentColor,
          child: Text(exercise.toString()),
        ));
  }

  Column _block(int pos) {
    return Column(
      children: [
        _exerciseButton(training.exercises[pos], ExercisePosition.Top),
        _exerciseButton(training.exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(training.exercises[pos + 2], ExercisePosition.Bottom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgets;

    if (training != null) {
      widgets = Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView(
          children: [
            _block(0),
            SizedBox(height: 12),
            _block(3),
            SizedBox(height: 12),
            _block(6),
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
          color: Theme.of(context).accentColor,
          onPressed: () async {
            training = Training.genTraining(exercises);
            var prefs = await SharedPreferences.getInstance();
            prefs.setStringList("exercises", training.toStringList());
            setState(() {});
          },
          child: Text("Training"),
        ),
        FlatButton(
            color: Theme.of(context).buttonColor,
            onPressed: training == null
                ? null
                : () {
                    Clipboard.setData(ClipboardData(text: training.toString()));
                    final snackBar = SnackBar(content: Text("Copied training into clipboard"));
                    scaffoldKey.currentState.showSnackBar(snackBar);
                  },
            child: Text("Clipboard")),
      ],
    );

    return Scaffold(
      key: scaffoldKey,
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
