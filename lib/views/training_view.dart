import 'package:bbtraining/trainings/core.dart';
import 'package:bbtraining/trainings/mobility.dart';
import 'package:bbtraining/trainings/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bbtraining/views/exercise_view.dart';
import 'package:bbtraining/views/settings_view.dart';
import 'package:bbtraining/views/exercises_view.dart';
import 'package:bbtraining/settings.dart';
import 'package:bbtraining/trainings/functional.dart';
import 'package:bbtraining/exercise.dart';
import 'package:bbtraining/persistence.dart';

class TrainingView extends StatefulWidget {
  TrainingView({Key? key}) : super(key: key);

  @override
  TrainingViewState createState() => TrainingViewState();
}

enum ExercisePosition { Top, Center, Bottom }

class TrainingViewState extends State<TrainingView> {
  Settings settings = Settings();
  int current = 0;
  List<Training> trainings = [];
  List<Exercise> exercises = [];
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    Persistence.getExercises().then((value) async {
      exercises = value;
      settings = await Persistence.getSettings();

      trainings = [
        FunctionalTraining.genTraining(exercises, settings),
        MobilityTraining.genTraining(exercises, settings),
        CoreTraining.genTraining(exercises, settings)
      ];

      Training? functional = await Persistence.getTraining(trainings[0], exercises);
      Training? mobility = await Persistence.getTraining(trainings[1], exercises);
      Training? core = await Persistence.getTraining(trainings[2], exercises);

      if (functional != null) {
        trainings[0] = functional;
      }
      if (mobility != null) {
        trainings[1] = mobility;
      }
      if (core != null) {
        trainings[2] = core;
      }

      for (int i = 0; i < trainings.length; ++i) {
        trainings[i].level = settings.level;
        trainings[i].genRequirements(settings);
      }

      setState(() {});
    });
    super.initState();
  }

  Dismissible _exerciseButton(int pos, Exercise exercise, ExercisePosition position) {
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

    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          trainings[current].replace(exercises, pos);
          Persistence.setTraining(trainings[current]);
          setState(() {});
        },
        resizeDuration: Duration(microseconds: 1),
        background: Container(
          width: 350,
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: radius,
              )),
        ),
        child: SizedBox(
            width: 350,
            child: TextButton(
              key: Key("exercise_$pos"),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: radius),
                backgroundColor: Theme.of(context).colorScheme.secondary,
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
                              "${exercise.pairwise ? "2 x " : ""}${exercise.repsByLevel(settings.level)}${exercise.unit}"))),
                  SizedBox(width: 10),
                ],
              ),
            )));
  }

  Column _block(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, trainings[0].exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, trainings[0].exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, trainings[0].exercises[pos + 2], ExercisePosition.Bottom),
      ],
    );
  }

  Column _mobility(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, trainings[1].exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, trainings[1].exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, trainings[1].exercises[pos + 2], ExercisePosition.Center),
        _exerciseButton(pos + 3, trainings[1].exercises[pos + 3], ExercisePosition.Center),
        _exerciseButton(pos + 4, trainings[1].exercises[pos + 4], ExercisePosition.Bottom),
      ],
    );
  }

  Column _core(int pos) {
    return Column(
      children: [
        _exerciseButton(pos, trainings[2].exercises[pos], ExercisePosition.Top),
        _exerciseButton(pos + 1, trainings[2].exercises[pos + 1], ExercisePosition.Center),
        _exerciseButton(pos + 2, trainings[2].exercises[pos + 2], ExercisePosition.Bottom),
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
        })) ??
        exercises;
    setState(() {
      Persistence.setExercises(exercises);
    });
  }

  void showSettings() async {
    settings = await Navigator.of(context).push(MaterialPageRoute<Settings>(builder: (BuildContext context) {
          return SettingsView(settings);
        })) ??
        settings;
    setState(() {
      for (int i = 0; i < trainings.length; ++i) {
        trainings[i].level = settings.level;
      }
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
    if (trainings.isNotEmpty) {
      slides.add(ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(trainings[0].beautyName)),
          ),
          _block(0),
          SizedBox(height: 12),
          _block(3),
          SizedBox(height: 12),
          _block(6),
        ],
      ));

      slides.add(ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(trainings[1].beautyName)),
          ),
          _mobility(0),
        ],
      ));

      slides.add(ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(trainings[2].beautyName)),
          ),
          _core(0),
        ],
      ));
    } else {
      slides.add(Center(child: Text("Hello")));
    }

    widgets = CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        onPageChanged: (int index, CarouselPageChangedReason reason) {
          current = index & trainings.length;
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
          icon: Icon(Icons.keyboard_arrow_up),
          onPressed: () => carouselController.previousPage(),
        ),
        Container(
            width: 100,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              key: Key("gen_training"),
              onPressed: () async {
                switch (current) {
                  case 0:
                    trainings[current] = FunctionalTraining.genTraining(exercises, settings);
                    break;
                  case 1:
                    trainings[current] = MobilityTraining.genTraining(exercises, settings);
                    break;
                  case 2:
                    trainings[current] = CoreTraining.genTraining(exercises, settings);
                    break;
                }
                Persistence.setTraining(trainings[current]);
                setState(() {});
              },
              child: Text("Training"),
            )),
        Container(
          width: 100,
          child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primaryVariant),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: trainings[current].toString()));
                final snackBar = SnackBar(
                    content: Text(
                  "Copied ${trainings[current].beautyName.toLowerCase()} into clipboard",
                  textAlign: TextAlign.center,
                ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text("Clipboard")),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down),
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
