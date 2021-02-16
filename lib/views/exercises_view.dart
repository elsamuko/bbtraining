import 'package:bbtraining/views/separated_rounded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../exercise.dart';

extension RangeExtension on int {
  List<Widget> each(Widget w) => [for (int i = 0; i < this; i++) w];
}

class ExercisesView extends StatefulWidget {
  List<Exercise> exercises;

  ExercisesView(this.exercises, {Key key}) : super(key: key);

  @override
  ExercisesViewState createState() => ExercisesViewState();
}

class ExercisesViewState extends State<ExercisesView> {
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, widget.exercises);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Exercises"),
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: ListView.builder(
                      itemCount: widget.exercises.length,
                      itemBuilder: (context, i) {
                        return Text(widget.exercises[i].toString());
                      }))),
        ));
  }
}
