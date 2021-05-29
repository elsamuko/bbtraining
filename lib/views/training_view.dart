import 'package:bbtraining/trainings/core.dart';
import 'package:bbtraining/trainings/mobility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'exercise_view.dart';
import 'settings_view.dart';
import 'exercises_view.dart';
import '../settings.dart';
import '../trainings/functional.dart';
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
  var currentTraining;
  FunctionalTraining functional;
  MobilityTraining mobility;
  CoreTraining core;
  List<Exercise> exercises;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    Persistence.getExercises().then((value) async {
      exercises = value;
      functional = FunctionalTraining();
      mobility = MobilityTraining();
      core = CoreTraining();
      functional = await Persistence.getTraining(functional, exercises);
      mobility = await Persistence.getTraining(mobility, exercises);
      core = await Persistence.getTraining(core, exercises);
      settings = await Persistence.getSettings();
      if (functional != null) {
        currentTraining = functional;
        functional.level = settings.level;
      }
      if (mobility != null) {
        mobility.level = settings.level;
      }
      if (core != null) {
        core.level = settings.level;
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
        child: TextButton(
          key: Key("exercise_$pos"),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: radius,
            ),
            backgroundColor: Theme.of(context).accentColor,
          ),
          onPressed: () => showExercise(exercise),
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
                  child: Center(
                      child: Text(
                          "${exercise.pairwise ? "2 x " : ""}${exercise.repsByLevel(functional.level)}${exercise.unit}"))),
              SizedBox(width: 10),
            ],
          ),
        ));
  }

  Column _block(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, functional.exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, functional.exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, functional.exercises[pos + 2], ExercisePosition.Bottom),
      ],
    );
  }

  Column _mobility(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, mobility.exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, mobility.exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, mobility.exercises[pos + 2], ExercisePosition.Center),
        _exerciseButton(pos + 3, mobility.exercises[pos + 3], ExercisePosition.Center),
        _exerciseButton(pos + 4, mobility.exercises[pos + 4], ExercisePosition.Bottom),
      ],
    );
  }

  Column _core(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, core.exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, core.exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, core.exercises[pos + 2], ExercisePosition.Bottom),
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
      functional.level = settings.level;
      mobility.level = settings.level;
      core.level = settings.level;
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
      key: Key("options_menu"),
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
                key: Key(element.name),
                child: Text(element.name),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgets;
    List<Widget> slides = [];

    if (functional != null) {
      slides.add(ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(functional.beautyName)),
          ),
          _block(0),
          SizedBox(height: 12),
          _block(3),
          SizedBox(height: 12),
          _block(6),
        ],
      ));
    }

    if (mobility != null) {
      slides.add(ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(mobility.beautyName)),
          ),
          _mobility(0),
        ],
      ));
    }

    if (core != null) {
      slides.add(ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(core.beautyName)),
          ),
          _core(0),
        ],
      ));
    }

    if (slides.isEmpty) {
      slides.add(Center(child: Text("Hello")));
    }

    widgets = CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          switch (index % 3) {
            case 0:
              currentTraining = functional;
              break;
            case 1:
              currentTraining = mobility;
              break;
            case 2:
              currentTraining = core;
              break;
          }
        },
        viewportFraction: 1,
        // enlargeCenterPage: true,
        height: 600.0,
        scrollDirection: Axis.vertical,
      ),
      items: slides,
    );

    Row bottomButtons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => carouselController.previousPage(),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).accentColor,
          ),
          key: Key("gen_training"),
          onPressed: () async {
            functional = FunctionalTraining.genTraining(exercises, settings);
            mobility = MobilityTraining.genTraining(exercises, settings);
            core = CoreTraining.genTraining(exercises, settings);
            setState(() {
              Persistence.setTraining(functional);
              Persistence.setTraining(mobility);
              Persistence.setTraining(core);
            });
          },
          child: Text("Training"),
        ),
        TextButton(
            style: TextButton.styleFrom(backgroundColor: Theme.of(context).buttonColor),
            onPressed: functional == null
                ? null
                : () {
                    Clipboard.setData(ClipboardData(text: currentTraining.toString()));
                    final snackBar = SnackBar(content: Text("Copied training into clipboard"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
            child: Text("Clipboard")),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () => carouselController.nextPage(),
        ),
      ],
    );

    return Scaffold(
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
