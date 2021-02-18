import 'package:bbtraining/views/separated_rounded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../exercise.dart';

extension RangeExtension on int {
  List<Widget> each(Widget w) => [for (int i = 0; i < this; i++) w];
}

class ExerciseView extends StatefulWidget {
  Exercise exercise;

  ExerciseView(this.exercise, {Key key}) : super(key: key);

  @override
  ExerciseViewState createState() => ExerciseViewState();
}

class ExerciseViewState extends State<ExerciseView> {
  Row stars(int count, IconData icon) {
    return Row(
      children: count.each(Row(children: [
        SizedBox(width: 3),
        Container(
          width: 20,
          child: Center(child: FaIcon(icon, size: 18, color: Colors.white)),
        ),
      ])),
    );
  }

  Widget line(String label, int count, IconData icon) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        stars(count, icon),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exercise.name,
          style: TextStyle(fontSize: 16, color: widget.exercise.enabled ? Colors.white : Colors.black26),
        ),
        actions: [
          Switch(
            value: widget.exercise.enabled,
            onChanged: (v) {
              setState(() {
                widget.exercise.enabled = v;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListView(
            children: [
              SeparatedRounded(children: [
                line("Upper", widget.exercise.upper, FontAwesomeIcons.arrowAltCircleUp),
                line("Lower", widget.exercise.lower, FontAwesomeIcons.arrowAltCircleDown),
                line("Core", widget.exercise.core, FontAwesomeIcons.dotCircle),
                line("Strength", widget.exercise.strength, FontAwesomeIcons.fistRaised),
                line("Cardio", widget.exercise.cardio, FontAwesomeIcons.heartbeat),
                line("Mobility", widget.exercise.mobility, FontAwesomeIcons.expandArrowsAlt),
                line("Difficulty", widget.exercise.difficulty, FontAwesomeIcons.star),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
