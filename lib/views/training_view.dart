import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'exercise_view.dart';
import 'settings_view.dart';
import 'exercises_view.dart';
import '../settings.dart';
import '../training.dart';
import '../exercise.dart';
import '../persistence.dart';

class TrainingView extends StatefulWidget {
  TrainingView({Key key}) : super(key: key);

  @override
  TrainingViewState createState() => TrainingViewState();
}

enum ExercisePosition { Top, Center, Bottom }

class TrainingViewState extends State<TrainingView> {
  Settings settings;
  Training training;
  List<Exercise> exercises;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Persistence.getExercises().then((value) async {
      exercises = value;
      training = await Persistence.getTraining(exercises);
      settings = await Persistence.getSettings();
      if (training != null) {
        training.level = settings.level;
      }
      setState(() {});
    });
    super.initState();
  }

  SizedBox _exerciseButton(int pos, Exercise exercise, ExercisePosition position) {
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
        width: 320,
        child: FlatButton(
          key: Key("exercise_$pos"),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.symmetric(vertical: 18),
          onPressed: () => showExercise(exercise),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),
          color: Theme.of(context).accentColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Center(
                  child: Text(
                "${exercise.name}",
              )),
              Expanded(child: SizedBox(width: 10)),
              Container(
                  width: 60,
                  child:
                      Center(child: Text("${exercise.pairwise ? "2 x " : ""}${exercise.repsByLevel(training.level)}"))),
              SizedBox(width: 10),
            ],
          ),
        ));
  }

  Column _block(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, training.exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, training.exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, training.exercises[pos + 2], ExercisePosition.Bottom),
      ],
    );
  }

  void showExercise(Exercise exercise) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return ExerciseView(exercise);
    }));
  }

  void showExercises() async {
    exercises = await Navigator.of(context).push(MaterialPageRoute<List<Exercise>>(builder: (BuildContext context) {
      return ExercisesView(exercises);
    }));
    setState(() {
      Persistence.setExercises(exercises);
    });
  }

  void showSettings() async {
    settings = await Navigator.of(context).push(MaterialPageRoute<Settings>(builder: (BuildContext context) {
      return SettingsView(settings);
    }));
    setState(() {
      training.level = settings.level;
      Persistence.setSettings(settings);
    });
  }

  void showAbout() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Burpeebären Training v${packageInfo.version}"),
            content: Text("Training for the Burpeebären"),
          );
        });
  }

  PopupMenuButton<BBOpts> buildPopUpButton() {
    return PopupMenuButton<BBOpts>(
      key: Key("optionsMenu"),
      icon: Icon(const IconData(128059)), // https://emojiguide.org/bear
      onSelected: (BBOpts result) {
        switch (result) {
          case BBOpts.Settings:
            showSettings();
            break;
          case BBOpts.Exercises:
            showExercises();
            break;
          case BBOpts.About:
            showAbout();
            break;
        }
      },
      // map enum to menu
      itemBuilder: (BuildContext context) => BBOpts.values
          .map((element) => PopupMenuItem<BBOpts>(
                value: element,
                child: Text(element.name),
              ))
          .toList(),
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
          key: Key("gen_training"),
          color: Theme.of(context).accentColor,
          onPressed: () async {
            training = Training.genTraining(exercises, settings);
            setState(() {
              Persistence.setTraining(training);
            });
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
        actions: [
          buildPopUpButton(),
        ],
      ),
      body: Center(
        child: widgets,
      ),
      bottomNavigationBar: bottomButtons,
    );
  }
}

enum BBOpts { Settings, Exercises, About }

extension Name on BBOpts {
  String get name {
    switch (this) {
      case BBOpts.Settings:
        return "Settings";
      case BBOpts.Exercises:
        return "Exercises";
      case BBOpts.About:
        return "About";
      default:
        return "About";
    }
  }
}
